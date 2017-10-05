require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'
require 'httparty'
require 'pry'

BASE_URL = "http://#{ENV['USERNAME']}:#{ENV['PASSWORD']}@24.7.192.65:5005".freeze

class SonosApi
  include HTTParty
  base_uri 'http://24.7.192.65:5005'

  attr_accessor :sonos_room

  def initialize(sonos_room: 'Bedroom')
    @options = { basic_auth: { username: ENV['USERNAME'], password: ENV['PASSWORD'] } }
    @sonos_room = sonos_room
  end

  def say(text)
    url = URI.encode("/#{@sonos_room}/say/#{text}/50")
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

class JukeBot < SlackRubyBot::Bot
  def self.api
    @api ||= SonosApi.new
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
