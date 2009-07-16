require 'lib/lant'
require 'getoptlong'


opts = GetoptLong.new([ "--list-props",  "-l",  GetoptLong::NO_ARGUMENT ],
[ "--info-only",   "-i",  GetoptLong::NO_ARGUMENT ] )
lant=Lant.new


opts.each do |opt,val|
  lant.display_properties = true if opt=="--list-props"
end

file=ARGV[0]
if (file==nil)
  puts "usage: ruby lant.rb [options] <ant build file>"
else
  lant.parse(file) 
end


# TODO: handle import directives
# TODO: find <ant> tasks and find files to process as above.
# TODO: find <properties> with only one usage
# TODO: take some useful args (e.g. -dump-props, -dump-unused-props)



