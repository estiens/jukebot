class BotRegex < Regexp
  def initialize(*values)
    values = values.map { |value| Regexp.new(value).source }.join('|')
    super("^(?<bot>[[:alnum:][:punct:]@<>]*)[\\s]+(?<command>#{values})([\\s]+(?<expression>.*)|)$", Regexp::IGNORECASE)
  end
end
