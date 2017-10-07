require 'dotenv'
Dotenv.load
require 'slack-ruby-bot'

require_relative 'includes'

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
end

JukeBot.run
