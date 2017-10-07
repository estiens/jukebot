class NextMusic < SlackRubyBot::Commands::Base
  next_regex = /next (?<play>.*)/i
  match BotRegex.new(next_regex)

  def self.next_track(query)
    track = JukeBot.spotify.get_track_from_query(query)
    return "Sorry, can't find that song." unless track
    JukeBot.api.spotify_play(track: track.uri, when_to_play: 'next')
    "Alright, I'll play #{track.name} next!"
  end

  def self.call(client, data, match)
    response = next_track(match[:play])
    client.say(text: response, channel: data.channel)
  end
end
