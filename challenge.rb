#!/usr/bin/env ruby
require_relative 'lib/vm'

module SynacorChallenge
  begin
    vm = Vm.new ARGV[0]
    vm.run
  rescue StandardError => e
    msg = "Standard error of type: #{e.class.name} with message: #{e.message}"
    puts msg
    puts e.backtrace.inspect
  end
end
