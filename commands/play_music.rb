class PlayMusic < SlackRubyBot::Commands::Base
  play_regex = /play (?<play>.*)/i
  match BotRegex.new(play_regex)

  def self.play_track(track:)
    if track.number?
      play_track_from_list(track)
    else
      find_and_play_track(track)
    end
  end

  def self.play_track_from_list(number)
    song_index = number - 1
    track = JukeBot.spotify.last_search[song_index]
    return "Sorry, I don't know what song you want" unless track
    JukeBot.api.spotify_play(track: track.uri)
    preview_image = track.album.images.first['url']
    "Alright, I'm now playing your request. #{preview_image}"
  end

  def self.find_and_play_track(word)
    track = JukeBot.spotify.find_tracks(query: word, limit: 1).first
    return "Sorry couldn't find anything like that" unless track
    JukeBot.api.spotify_play(track: track.uri)
    response = "Alright, playing #{track.name}. "
    response += track.album.images.first['url']
    response
  end

  def self.call(client, data, match)
    response = play_track(track: match[:play])
    client.say(text: response, channel: data.channel)
  end
end
