puts Dir.pwd
Dir.entries("test").each {|file| require "test/#{file}" if file.match(/rb$/)}

