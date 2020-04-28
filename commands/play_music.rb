class PlayMusic < SlackRubyBot::Commands::Base
  play_regex = /play music (?<play>.*)/i
  match BotRegex.new(play_regex)

  help do
    title 'play music'
    desc '`play music <num>|<query>` - plays the specified music'
    long_desc 'Plays result from last search.'\
              ' Or searches spotify and plays first result. '\
              'Examples: `play music 3` or `play music free falling`'
  end

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
