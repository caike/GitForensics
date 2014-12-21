require './models'
require 'colored'

def print(rate, mod=nil)
  percent = "#{('%2.0f' % rate[:change_rate])}%"
  output = "#{percent.ljust(10)}\t#{rate[:file_name]}"
  if mod
    puts output.yellow.send(mod)
  else
    puts output.yellow
  end
end

file_name = ARGV[0]
cf = CommitFile.find(name: file_name)
rates = cf.calculate_change_rate[0..10]

puts "\n"
print(rates.shift, :bold)
rates.each do |cr|
  print(cr)
end
