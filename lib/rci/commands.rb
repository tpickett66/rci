require 'set'

module RCI
  module Commands

    # As of Redis 3.0 there isn't any indication from the COMMAND return
    # info as to which commands accept a subcommand so we're tracking them here
    COMMANDS_WITH_SUBCOMMANDS = %i{client cluster command debug script}.to_set.freeze

    def self.extract_command(command_array)
      command = command_array[0]
      info = {command: command}
      if COMMANDS_WITH_SUBCOMMANDS.include?(command)
        subcommand = command_array[1]
        info[:subcommand] = subcommand unless subcommand.nil?
      end
      info
    end
  end
end
