class QueueMusic < SlackRubyBot::Commands::Base
  queue_regex = /queue (?<play>.*)/i
  match BotRegex.new(queue_regex)

  help do
    title 'queue music'
    desc '`queue music <num>|<query>` - queues the specified music'
    long_desc 'Queues result from last search next.'\
              ' Or searches spotify and queues first result. '\
              'Examples: `queue music 5` or `queue music black mountain lights`'
  end

  def self.queue_track(query)
    track = JukeBot.spotify.get_track_from_query(query)
    return "Sorry, can't find that song." unless track
    JukeBot.api.spotify_play(track: track.uri, when_to_play: 'queue')
    "Alright, I'll add #{track.name} to the queue."
  end

  def self.call(client, data, match)
    response = queue_track(match[:play])
    client.say(text: response, channel: data.channel)
  end
end
