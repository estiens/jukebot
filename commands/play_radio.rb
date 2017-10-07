class PlayRadio < SlackRubyBot::Commands::Base
  play_regex = /radio (?<play>.*)/i
  match BotRegex.new(play_regex)

  help do
    title 'radio play'
    desc '`radio play <num>|<station_id>` - plays the specified station'
    long_desc 'Plays result from last search.'\
              ' Or can take a TuneIn station ID.'\
              'Examples: `radio play 1` or `play radio play s12345`'
  end

  def self.play_station(query)
    station = JukeBot.tunein.get_station_for(query)
    return "Sorry, I don't know what station you want" unless station
    JukeBot.api.radio_play(station_id: station[:guide_id][1..-1])
    response = "Alright, I'm now playing #{station[:name]}."
    response += "\n #{station[:image]}" if station[:image]
    response
  end

  def self.call(client, data, match)
    response = play_station(match[:play])
    client.say(text: response, channel: data.channel)
  end
end
