require 'pathname'
require_relative 'module'

# VM class to run the binary file for the Synacor Challenge.
class Vm
  include SynacorChallenge

  def initialize(binary_path)
    @stack = []
    @registers = Array.new(8, 0)
    @counter = 0
    load_data binary_path
  end

  protected

  def load_data(binary_path)
    path = Pathname.new(binary_path.to_s)
    fail SystemExit, "Path #{binary_path} does not exist" unless path.exist?
    File.open(path.to_s, 'rb') do |file|
      @memory = file.read.unpack('v*')
    end
  end
end
