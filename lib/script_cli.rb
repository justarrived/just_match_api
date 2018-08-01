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

  def system_call(command, puts: false)
    puts("$ #{command}")
    return '' if noop?

    `#{command}`.tap { |output| puts(output) if puts }
  end

  def noop?
    @noop
  end
end
# rubocop:enable Rails/Output, Rails/Exit
