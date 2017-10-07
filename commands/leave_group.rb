class LeaveGroup < SlackRubyBot::Commands::Base
  command 'leave'
  command 'standalone'

  help do
    title 'leave'
    desc '`leave` - leaves the current group'
    long_desc 'makes the current room its own group'\
              'Example: `leave`'
  end

  def self.call(client, data, _match)
    JukeBot.api.leave
    response = "Alright, we're all on our own in #{JukeBot.api.current_room}"
    client.say(text: response, channel: data.channel)
  end
end
