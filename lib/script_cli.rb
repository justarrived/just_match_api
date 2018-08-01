# frozen_string_literal: true

# rubocop:disable Rails/Output, Rails/Exit
class ScriptCLI
  def initialize(noop: false, output: STDOUT)
    @noop = noop
    @output = output
  end

  def puts(string)
    @output.puts(string)
  end

  def die!(message)
    puts("[ERROR] #{message}")
    exit(1)
  end

  def system_call(command)
    puts("$ #{command}")
    return '' if noop?

    `#{command}`
  end

  def noop?
    @noop
  end
end
# rubocop:enable Rails/Output, Rails/Exit
