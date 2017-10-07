require 'dotenv'
Dotenv.load
require 'slack-ruby-bot'
require 'pry'

require_relative 'includes/bot_regex'
require_relative 'includes/string_monkeypatch'

require_relative 'services/sonos_service'
require_relative 'services/spotify_service'
require_relative 'services/tune_in_service'

require_relative 'commands/what_is_playing'
require_relative 'commands/find_music'
require_relative 'commands/play_music'
require_relative 'commands/next_music'
require_relative 'commands/queue_music'
require_relative 'commands/single_commands'
require_relative 'commands/find_radio'
require_relative 'commands/play_radio'
require_relative 'commands/join_group'
require_relative 'commands/leave_group'
require_relative 'commands/change_group_volume'
require_relative 'commands/change_room_volume'

class JukeBot < SlackRubyBot::Bot
  def self.api
    @api ||= JukeBotService::Sonos.new
  end

  def self.spotify
    @spotify ||= JukeBotService::Spotify.new
  end

  def self.tunein
    @tunein ||= JukeBotService::TuneIn.new
  end

  change_room_regex = /change\sroom\s(?:to )?(?<room>.*)$/i
  match BotRegex.new(change_room_regex) do |client, data, match|
    if api.change_room(match[:room])
      response = "Ok, room set to #{match[:room]}."
    else
      response = "Sorry, it doesn't look like that room exists."
      response += "Try #{api.rooms.join(', ')}"
    end
    client.say(text: response, channel: data.channel)
  end

  say_regex = /say\s(?<words>.*)$/i
  match BotRegex.new(say_regex) do |_client, _data, match|
    api.say(text: match[:words])
  end
end

JukeBot.run
