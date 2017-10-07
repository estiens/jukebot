class ChangeRoom < SlackRubyBot::Commands::Base
  change_room_regex = /change\sroom\s(?:to )?(?<room>.*)$/i
  match BotRegex.new(change_room_regex)

  help do
    title 'change room'
    desc '`change room <room>` - changes the current room'
    long_desc 'will fail if an invalid room is specified'\
              'Example: `change room bedroom`'
  end

  def self.call(client, data, match)
    if JukeBot.api.change_room(match[:room])
      response = "Ok, room set to #{match[:room]}."
    else
      response = "Sorry, it doesn't look like that room exists."
      response += "Try #{JukeBot.api.rooms.join(', ')}"
    end
    client.say(text: response, channel: data.channel)
  end
end
