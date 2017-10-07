class Say < SlackRubyBot::Commands::Base
  say_regex = /say\s(?<words>.*)$/i
  match BotRegex.new(say_regex)

  help do
    title 'say'
    desc '`say <text>` - speaks the specified text in the current room'
    long_desc 'Example: `say an injury to one is an injury to all`'\
  end

  def self.call(_client, _data, match)
    JukeBot.api.say(text: match[:words])
  end
end
