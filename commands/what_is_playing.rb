class WhatIsPlaying < SlackRubyBot::Commands::Base
  command "what's playing"
  command 'what is playing'
  command 'now playing'
  command 'whats playing'
  command 'playing?'
  command 'current track'

  help do
    title 'current track'
    desc 'displays the current track playing'
    long_desc 'displays the current track playing'
  end

  def self.call(client, data, _match)
    current_track = JukeBot.api.current_track
    artist = current_track[:artist]
    title = current_track[:title]
    response = "#{title} by #{artist}"
    client.say(text: response, channel: data.channel)
  end
end
