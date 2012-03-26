# -*- coding: utf-8 -*-
#Script to find duplicates of files

folders = Dir['**/']
files = Array.new()
files_nodups = Array.new()
files_dups = Array.new()

folders.each do |i|
  Dir.chdir(i) do
    files += Dir['*.*']
    files_nodups |= Dir['*.*']
  end
end

temp = Array.new(files)

until temp==[]
  last = temp.pop
  if temp.include?(last)
    temp.delete(last)
    files_dups << last
  end
end

puts "Total nr of files: #{files.size}"
puts "Number of individual files: #{files_nodups.size}"
puts "Nr of files with duplicate names: #{files_dups.size}"

puts "View duplicates? (y/n): "
ans = gets.chomp()

if ans == "y"
  puts files_dups
  puts "> #{files_dups.size} duplicates total."
end
