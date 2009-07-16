require 'rake/clean'
task :default => [ :test ]   

CLEAN.include('coverage')
CLEAN.include('build')

task :test => [:clean] do 
#  ruby 'test/basher_test.rb'
  system "rcov test/basher_test.rb"
end

