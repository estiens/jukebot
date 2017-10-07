class ChangeGroupVolume < SlackRubyBot::Commands::Base
  volume_regex = /volume (?<volume>.*)/i
  match BotRegex.new(volume_regex)

  help do
    title 'volume'
    desc '`volume <num>` - changes the volume of the entire group'
    long_desc 'takes a number between 1 and 100. Example `volume 10`'
  end

  def self.call(client, data, match)
    volume = match[:volume]
    if volume.number?
      JukeBot.api.change_group_volume(volume)
      response = "Set the volume to #{volume} :mega:"
    else
      response = "How am I supposed to change the volume to #{volume}?"
    end
    client.say(text: response, channel: data.channel)
  end
end
