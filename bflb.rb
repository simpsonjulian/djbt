$:.unshift('../buildmaster/lib') 
require 'lib/ant_project'
require 'lib/builder'

#builder = Builder.new
project = AntProject.new('/home/jsimpson/workspace/cruisecontrol/main')
project.validate()


