require 'set'

module RCI
  module Commands
    class << self
      attr_reader :commands, :read_commands, :read_command_names
    end

    @read_commands = []
    @read_command_names = Set.new

    # As of Redis 3.0 there isn't any indication from the COMMAND return
    # info as to which commands accept a subcommand so we're tracking them here
    COMMANDS_WITH_SUBCOMMANDS = %i{client cluster command debug script}.to_set.freeze
    Command = Struct.new(:name, :arity, :flags, :first_key_position, :last_key_position, :step_count)

    def self.command_type(command_array)
      @read_command_names.include?(command_array.first) ? :read : :write
    end

    def self.discover!(client)
      return @commands if @commands
      @commands = client.command.map{ |command_description|
        command_name = command_description.shift.to_sym
        Command.new(command_name, *command_description)
      }
      @read_commands = @commands.select { |command| command.flags.include?('readonly') }
      @read_command_names = @read_commands.map(&:name).to_set
      @commands
    end

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
