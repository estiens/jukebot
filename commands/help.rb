class Help < SlackRubyBot::Commands::Base
  command 'help' do |client, data, match|
    command = match[:expression]

    text = if command.present?
             SlackRubyBot::Commands::Support::Help.instance.command_full_desc(command)
           else
             general_text
           end

    client.say(channel: data.channel, text: text, gif: 'help')
  end

  class << self
    private

    def general_text
      commands =
        SlackRubyBot::Commands::Support::Help.instance.commands_help_attrs
        .select { |command| command.command_name.present? }
        .map do |command|
          desc = command.command_desc.present? ? " - #{command.command_desc}" : ''
          "*#{command.command_name}*#{desc}"
        end
      <<TEXT
*Jukebot* - Slack bot that can control your Sonos system

*Commands:*
#{commands.join("\n")}

For a detailed description of the command use: *help <command>*
TEXT
    end
  end
end
