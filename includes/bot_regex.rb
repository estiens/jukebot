class BotRegex < Regexp
  def initialize(*values)
    values = values.map { |value| Regexp.new(value).source }.join('|')
    super("^#{bot_matcher}[\\s]+(?<command>#{values})([\\s]+(?<expression>.*)|)$", Regexp::IGNORECASE | Regexp::MULTILINE)
  end

  def bot_matcher
    SlackRubyBot::Commands::Base.bot_matcher
  end
end
