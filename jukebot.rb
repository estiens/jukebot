require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'
require 'httparty'
require 'pry'
require 'rspotify'

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

  match(/find ?(\d+)? music (.*)/i) do |client, data, match|
    tracks = spotify.find_tracks(query: match[2], limit: match[1])
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

  match(/play (.*)/i) do |client, data, match|
    number = match[1].to_i.to_s == match[1]
    if number
      song_index = match[1].to_i - 1
      uri = spotify.last_search[song_index].uri
      api.spotify_play(uri)
      preview_image = spotify.last_search[song_index].album.images.first['url']
      response = "Alright, I'm now playing your request. #{preview_image}"
      client.say(text: response, channel: data.channel)
    end
  end

  match(/next (.*)/i) do |client, data, match|
    number = match[1].to_i.to_s == match[1]
    if number
      song_index = match[1].to_i - 1
      uri = spotify.last_search[song_index].uri
      api.spotify_play(uri, 'next')
      preview_image = spotify.last_search[song_index].album.images.first['url']
      response = "Alright, I'm playing what you want next. #{preview_image}"
      client.say(text: response, channel: data.channel)
    end
  end

  match(/queue (.*)/i) do |client, data, match|
    number = match[1].to_i.to_s == match[1]
    if number
      song_index = match[1].to_i - 1
      uri = spotify.last_search[song_index].uri
      api.spotify_play(uri, 'queue')
      response = "Alright, I queued up #{spotify.last_search[song_index].name}"
      client.say(text: response, channel: data.channel)
    end
  end

  match(/volume (.*)/i) do |client, data, match|
    volume = match[1]
    api.change_volume(volume)
    response = "Set the volume to #{volume} :mega:"
    client.say(text: response, channel: data.channel)
  end

  match(/.*\schange\sroom\s(?:to )?(?<room>.*)$/i) do |client, data, match|
    room = match[:room]
    @api = SonosApi.new(sonos_room: room)
    response = "Ok, I changed the room you are controlling to the #{room}"
    client.say(text: response, channel: data.channel)
  end

  match(/.*\ssay\s(.*)$/i) do |_client, _data, match|
    api.say(match[1])
  end

  command 'rooms' do |client, data, _match|
    response = "Current rooms available for control are #{api.rooms}"
    client.say(text: response, channel: data.channel)
  end
end

JukeBot.run
