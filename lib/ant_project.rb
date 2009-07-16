$:.unshift('..')
require 'fileutils'

require 'lib/builder'
class Logger
  def initialize(name)
  end
  
  def info(message)
    puts "INFO: #{message}"
  end
  
  def debug(message)
    puts "DEBUG: #{message}"
  end
end



class Library
  def initialize(path)
    @log = Logger.new 'mylog'
    @path = path
    @is_valid = false
    check_path(path) if path.class == String
  end
  
  def check_path path
    raise "this library does not exist" unless File.exists? path
  end
  private :check_path
  
  def disable()
      @log.info "going to whack #{@path}"
      @disabled_path="#{@path}.disabled"
      @log.debug "moving #{@path} to #{@disabled_path}"
      FileUtils.mv(@path, @disabled_path)
  end
  
  def enable()
     @log.debug "moving #{@disabled_path} to #{@path}"
      FileUtils.mv( @disabled_path, @path)
  end
  
  def verify(builder)
    disable
    @is_valid = true if builder.build
    enable
    return @is_valid
  end
  
  def name
    File.basename(@path)
  end
  end

class Report
  def initialize(bad,good)
    @bad = bad
    @good = good
    
  end
  def write
    puts "these are bad:"
    @bad.each do |p| 
      puts p.name
    end 
    
    puts "these are good"
    @good.each do |p| 
      puts p.name
    end
  end
end

class AntProject
# has_many Libraries
# has a Builder
# has a Report
  attr_writer :lib_dir, :builder
  attr_reader :unused_libs, :used_libs, :report
  def initialize(dir,builder=Builder)
    @dir = dir
    @lib_dir = "lib"
    @build_xml = File.join(dir,"build.xml")
    @builder = builder.new(@build_xml,"test")
    @used_libs = []
    @unused_libs = []
    @builder.validate
    raise "build failed.  need to get a passing build before starting the test run" unless @builder.build
   end
  
  def get_libs
    lib_path=File.join(@dir,@lib_dir)
    Dir["#{lib_path}/**/*.jar"]
  end
  
  def build(builder)
    return builder.build
  end
  
  def validate(libs=self.get_libs)
    libs.each do |path|
      lib=Library.new(path)
      if lib.verify(@builder) 
        @unused_libs << lib
      else
        @used_libs << lib
      end
    end
    testreport  
  end
  
  def testreport
    @report = Report.new(@unused_libs, @used_libs)
    @report.write
  end
  private :testreport
  
end
  
