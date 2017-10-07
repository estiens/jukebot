class FindRadio < SlackRubyBot::Commands::Base
  find_radio_regex = /find ?(?<digit>\d+)? radio (?<query>.*)/i
  match BotRegex.new(find_radio_regex)

  help do
    title 'find radio'
    desc '`find <num> radio <query>` - searches tunein for stations'
    long_desc 'returns <num> results. Can be used with or without a number. '\
              'Examples: `find 5 radio techno` or `find radio WMCN`'
  end

  def self.make_response(stations)
    response = "I found the following #{stations.length} stations:\n"
    stations.each_with_index do |station, idx|
      response += "#{idx + 1}: #{station[:name]}: #{station[:subtext]} "
      response += "(bitrate: #{station[:bitrate]})" if station[:bitrate]
      response += "\n"
    end
    response
  end

  def self.call(client, data, match)
    stations = JukeBot.tunein.search(query: match[:query],
                                     limit: match[:digit])
    response = make_response(stations)
    client.say(text: response, channel: data.channel)
  end
end
