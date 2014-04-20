#!/usr/bin/env ruby
require_relative 'lib/vm'

unless ARGV[0]
  puts 'You need to pass the path to the binary as an argument'
  exit(1)
end
begin
  vm = Vm.new ARGV[0]
  vm.run
rescue StandardError => e
  puts "Standard error of type: #{e.class.name} with message: #{e.message}"
  puts e.backtrace.inspect
end
