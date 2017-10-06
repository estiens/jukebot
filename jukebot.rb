require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'
require 'httparty'
require 'pry'
require 'rspotify'

class BotRegex < Regexp
  def initialize(*values)
    values = values.map { |value| Regexp.new(value).source }.join('|')
    super("^(?<bot>[[:alnum:][:punct:]@<>]*)[\\s]+(?<command>#{values})([\\s]+(?<expression>.*)|)$", Regexp::IGNORECASE)
  end
end

class String
  def number?
    to_i.to_s == self
  end
end

class SonosApi
  include HTTParty
  base_uri 'http://24.7.192.65:5005/'

  attr_accessor :sonos_room

  def initialize(sonos_room: 'Bedroom')
    @options = { basic_auth: { username: ENV['USERNAME'], password: ENV['PASSWORD'] } }
    @sonos_room = sonos_room
  end

  def spotify_play(track_url, play_when = 'now')
    url = URI.encode("/#{@sonos_room}/spotify/#{play_when}/#{track_url}")
    self.class.get(url, @options)
  end

  def say(text)
    url = URI.encode("/#{@sonos_room}/say/#{text}/50")
    self.class.get(url, @options)
  end

  def change_volume(volume)
    url = URI.encode("/#{@sonos_room}/volume/#{volume}")
    self.class.get(url, @options)
  end

  def rooms
    response = self.class.get('/zones', @options)
    json = return_error_or_parse_response(response)
    json.map { |h| h.dig('coordinator', 'roomName') }
  end

  def return_error_or_parse_response(response)
    return 'something went wrong' unless response.success?
    JSON.parse(response.body)
  end
end

class SpotifySearcher
  attr_reader :last_search

  def initialize
    @last_search = nil
  end

  def find(query)
    data = find_data(query)
    data.nil? ? nil : data.uri
  end

  def find_data(query)
    tracks = find_tracks(query)
    !tracks.empty? ? tracks.first : nil
  end

  def find_tracks(query:, limit:)
    limit ||= 3
    RSpotify.authenticate(ENV['RSPOTIFY_TOKEN'], ENV['RSPOTIFY_PASSWORD'])
    tracks = RSpotify::Track.search(query, limit: limit, market: 'US')
    @last_search = tracks.sort_by { |track| -track.popularity }
  end

  def get_album_info(uri)
    RSpotify.authenticate(ENV['RSPOTIFY_TOKEN'], ENV['RSPOTIFY_PASSWORD'])
    uri = uri.gsub('spotify:album:', '')
    RSpotify::Album.find(uri)
  end
end

class JukeBot < SlackRubyBot::Bot
  def self.api
    @api ||= SonosApi.new
  end

  def self.spotify
    @spotify ||= SpotifySearcher.new
  end

  find_music_regex = /find ?(?<digit>\d+)? music (?<query>.*)/i
  match BotRegex.new(find_music_regex) do |client, data, match|
    tracks = spotify.find_tracks(query: match[:query], limit: match[:digit])
    artist_array = []
    tracks.each do |track|
      artists = track.artists.map(&:name).join(',')
      name = track.name
      album = track.album.name
      artist_array << { artists: artists, name: name, album: album }
    end
    response = "I found the following #{artist_array.length} songs."
    artist_array.each_with_index do |artist, idx|
      response += "#{idx + 1}: #{artist[:name]} by #{artist[:artists]} on #{artist[:album]}. "
    end
    client.say(text: response, channel: data.channel)
  end

  play_regex = /play (?<play>.*)/i
  match BotRegex.new(play_regex) do |client, data, match|
    play_string = match[:play]
    if play_string.number?
      song_index = match[:play].to_i - 1
      api.spotify_play(spotify.last_search[song_index].uri)
      preview_image = spotify.last_search[song_index].album.images.first['url']
      response = "Alright, I'm now playing your request. #{preview_image}"
    else
      response = "Sorry, I couldn't figure out what to play"
    end
    client.say(text: response, channel: data.channel)
  end

  next_regex = /next (?<play>.*)/i
  match BotRegex.new(next_regex) do |client, data, match|
    play_string = match[:play]
    if play_string.number?
      song_index = match[:play].to_i - 1
      api.spotify_play(spotify.last_search[song_index].uri, 'next')
      preview_image = spotify.last_search[song_index].album.images.first['url']
      response = "Alright, I'm gonna play this next. #{preview_image}"
    else
      response = "Sorry, I couldn't figure out what to play next"
    end
    client.say(text: response, channel: data.channel)
  end

  queue_regex = /queue (?<play>.*)/i
  match BotRegex.new(queue_regex) do |client, data, match|
    play_string = match[:play]
    if play_string.number?
      song_index = match[:play].to_i - 1
      api.spotify_play(spotify.last_search[song_index].uri)
      response = "Alright, I queued up #{spotify.last_search[song_index].name}"
    else
      response = "Sorry, I couldn't figure out what to queue up"
    end
    client.say(text: response, channel: data.channel)
  end

  volume_regex = /volume (?<volume>.*)/i
  match BotRegex.new(volume_regex) do |client, data, match|
    volume = match[:volume]
    if volume.number?
      api.change_volume(volume)
      response = "Set the volume to #{volume} :mega:"
    else
      response = "How am I supposed to chage the volume to #{volume}?"
    end
    client.say(text: response, channel: data.channel)
  end

  change_room_regex = /change\sroom\s(?:to )?(?<room>.*)$/i
  match BotRegex.new(change_room_regex) do |client, data, match|
    @api = SonosApi.new(sonos_room: match[:room])
    response = "Ok, you are now controlling the #{match[:room]}. Feels good, doesn't it?"
    client.say(text: response, channel: data.channel)
  end

  say_regex = /say\s(?<words>.*)$/i
  match BotRegex.new(say_regex) do |_client, _data, match|
    api.say(match[:words])
  end

  command 'rooms' do |client, data, _match|
    response = "Current rooms available for control are #{api.rooms}"
    client.say(text: response, channel: data.channel)
  end
end

JukeBot.run
