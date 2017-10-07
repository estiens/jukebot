class Say < SlackRubyBot::Commands::Base
  say_regex = /say\s(?<words>.*)$/i
  match BotRegex.new(say_regex)

  def self.call(_client, _data, match)
    JukeBot.api.say(text: match[:words])
  end
end
