# Module containing constants and opcode methods for the SynacorChallenge
module SynacorChallenge
  MODULO = 32_768

  MAX_INT = 32_767

  OPCODES = {
    0 => 'halt',
    1 => 'set',
    2 => 'push',
    3 => 'pop',
    4 => 'eq',
    5 => 'gt',
    6 => 'jmp',
    7 => 'jt',
    8 => 'jf',
    9 => 'add',
    10 => 'mult',
    11 => 'mod',
    12 => 'and',
    13 => 'or',
    14 => 'not',
    15 => 'rmem',
    16 => 'wmem',
    17 => 'call',
    18 => 'ret',
    19 => 'out',
    20 => 'in',
    21 => 'noop'
  }

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
      @memory = Array.new(MODULO)
      @memory = file.read.unpack('v*')
    end
  end

  def two_values
    [next_instruction, next_instruction]
  end

  def key_value
    [target_register, next_instruction]
  end

  def key_two_values
    [target_register, next_instruction, next_instruction]
  end

  # Opcodes
  def halt
    exit
  end

  def out
    print Integer(next_instruction).chr
  end

  def noop
    # noop
  end

  def jmp
    @counter = next_instruction
  end

  def jt
    test, value = two_values
    @counter = value if Integer(test) != 0
  end

  def jf
    test, value = two_values
    @counter = value if Integer(test) == 0
  end

  def set
    key, value = key_value
    @registers[key] = value
  end

  def add
    key, first, second = key_two_values
    @registers[key] = (first + second) % MODULO
  end

  def eq
    key, first, second = key_two_values
    @registers[key] = first == second ? 1 : 0
  end

  def push
    @stack.push next_instruction
  end

  def pop
    fail 'Stack is empty' unless @stack.count
    key = target_register
    @registers[key] = @stack.pop
  end

  def gt
    key, first, second = key_two_values
    @registers[key] = first > second ? 1 : 0
  end

  def and
    key, first, second = key_two_values
    @registers[key] = first & second
  end

  def or
    key, first, second = key_two_values
    @registers[key] = first | second
  end

  def not
    key = target_register
    @registers[key] = (~ next_instruction) & MAX_INT
  end

  def call
    @stack.push @counter + 1
    jmp
  end

  def mult
    key, first, second = key_two_values
    @registers[key] = (first * second) % MODULO
  end

  def mod
    key, first, second = key_two_values
    @registers[key] = first % second
  end

  def rmem
    key, address = key_value
    @registers[key] = @memory[address]
  end

  def wmem
    key, value = two_values
    @memory[key] = value
  end

  def ret
    halt unless @stack.count
    @counter = @stack.pop
  end

  def in
    char = STDIN.getc
    halt unless char
    code = char.ord
    instruction = raw_instruction
    if register? instruction
      key = register_id instruction
      @registers[key] = code
    else
      @memory[instruction] = code
    end
  end
end
