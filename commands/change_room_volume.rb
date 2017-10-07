class ChangeRoomVolume < SlackRubyBot::Commands::Base
  volume_regex = /room volume (?<volume>.*)/i
  match BotRegex.new(volume_regex)

  def self.call(client, data, match)
    volume = match[:volume]
    if volume.number?
      JukeBot.api.change_volume(volume)
      response = "Set the volume to #{volume} :mega:"
    else
      response = "How am I supposed to change the volume to #{volume}?"
    end
    client.say(text: response, channel: data.channel)
  end
end
