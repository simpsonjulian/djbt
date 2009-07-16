require 'fileutils'
include FileUtils




class Basher
  attr_accessor :base_dir, :build_dir, :build_file, :builder, :libs, :lib_dir
  
  # for tests
  attr_reader :result
  attr_writer :libs 
  
  def initialize(dir,builder)
    @log = Logger.new 'mylog'
    @log.outputters = Outputter.stdout
    @log.info("Brute Force Library Basher")

    @base_dir = dir
    @builder = builder
    @build_dir = "#{@base_dir}/build"
    @build_file = "#{@build_dir}/build.xml"
    @lib_dir = ""
    @libs=self.find_libs("#{base_dir}/#{@lib_dir}")
  end
    
  def run(libs)
    whitelist=Array.new
    blacklist=Array.new
    
    libs.each do | path |
      jar = Library.new(path)
      jar.disable
      @result = @builder.build(@build_file)
      if (@result)
        @log.debug "build success, perhaps you don't need #{jar}"
        blacklist << jar
      else
        @log.debug "build failure, I guess you did need #{jar}"
        whitelist << jar
      end
      jar.enable
      
     end
    @log.info "whitelist: #{whitelist.length}"
    @log.info "blacklist: #{blacklist.length}"
    puts blacklist
  end
  
end

