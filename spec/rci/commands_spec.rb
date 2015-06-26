require 'spec_helper'

module RCI
  RSpec.describe Commands do
    describe '.extract_command(command_array)' do
      it 'must return a hash with the command set to the command key' do
        expect(Commands.extract_command([:keys, '1234'])).to eq({command: :keys})
      end

      it 'must not include the subcommand key if the command does not have subcommands' do
        expect(Commands.extract_command([:keys, '1234']).keys).to_not include :subcommand
      end

      Commands::COMMANDS_WITH_SUBCOMMANDS.each do |command|
        it "must include the subcommand supplied to #{ command }" do
          expect(Commands.extract_command([command, :subcommand, '12345'])).
            to include command: command, subcommand: :subcommand
        end
      end

      it 'must not include the subcommand key when the command called is "command" and no subcommand is supplied' do
        expect(Commands.extract_command([:command]).keys).to_not include :subcommand
      end
    end
  end
end
