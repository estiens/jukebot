class FindMusic < SlackRubyBot::Commands::Base
  find_music_regex = /find ?(?<digit>\d+)? music (?<query>.*)/i
  match BotRegex.new(find_music_regex)

  def self.make_track_info(track)
    artists = track.artists.map(&:name).join(',')
    name = track.name
    album = track.album.name
    { artists: artists, name: name, album: album }
  end

  def self.make_response(tracks)
    response = "I found the following #{tracks.length} songs:\n"
    tracks.each_with_index do |track, idx|
      response += "#{idx + 1}: #{track[:name]} by #{track[:artists]} "
      response += "on #{track[:album]}.\n"
    end
    response
  end

  def self.call(client, data, match)
    tracks = JukeBot.spotify.find_tracks(query: match[:query],
                                         limit: match[:digit])
    tracks = tracks.map { |track| make_track_info(track) }
    response = make_response(tracks)
    client.say(text: response, channel: data.channel)
  end
end
