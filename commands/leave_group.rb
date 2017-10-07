class LeaveGroup < SlackRubyBot::Commands::Base
  command 'leave'
  command 'standalone'

  def self.call(client, data, _match)
    JukeBot.api.leave
    response = "Alright, we're all on our own in #{JukeBot.api.current_room}"
    client.say(text: response, channel: data.channel)
  end
end
