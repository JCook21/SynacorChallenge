require 'pathname'
require_relative 'module'

# VM class to run the binary file for the Synacor Challenge.
class Vm
  include SynacorChallenge

  def run
    loop do
      key = next_instruction
      opcode = OPCODES[key]
      fail "Opcode #{key} not implemented" unless opcode
      send(opcode)
    end
  end

  protected

  def next_instruction
    data = raw_instruction
    case
    when data > MAX_INT && register?(data)
      key = register_id(data)
      data = @registers[key]
    when data > MAX_INT
      fail RangeError, "Data #{data} is greater than MAX_INT #{MAX_INT}"
    end
    data
  end

  def register?(instruction)
    instruction > MAX_INT && instruction <= MAX_INT + @registers.count
  end

  def register_id(instruction)
    instruction - MODULO
  end

  def raw_instruction
    instruction = @memory[@counter]
    @counter += 1
    instruction
  end

  def target_register
    instruction = Integer(raw_instruction)
    unless (32_768..32_775).include?(instruction)
      fail RangeError, "Data #{instruction} is out of register range"
    end
    register_id instruction
  end
end
