class PlayMusic < SlackRubyBot::Commands::Base
  play_regex = /play (?<play>.*)/i
  match BotRegex.new(play_regex)

  def self.play_track(query)
    track = JukeBot.spotify.get_track_from_query(query)
    return "Sorry, I don't know what song you want" unless track
    JukeBot.api.spotify_play(track: track.uri)
    preview_image = track.album.images.first['url']
    "Alright, I'm now playing your request. #{preview_image}"
  end

  def self.call(client, data, match)
    response = play_track(match[:play])
    client.say(text: response, channel: data.channel)
  end
end
