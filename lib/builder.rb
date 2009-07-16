class Builder
  def initialize(buildfile,target)
    @buildfile=buildfile
    @target=target
    @basedir=File.dirname(buildfile)
    @ant_jar = '/home/jsimpson/apps/apache-ant-1.6.5/lib/ant-launcher.jar'
  end
  
  def build
    file=@buildfile
    command="java -classpath #{@ant_jar} org.apache.tools.ant.launch.Launcher -f #{file} #{@target}"
    puts command
    system(command)
  end
  
  def validate
    raise "can't find dir" unless File.exists?(@basedir)
    raise "can't find buildfile" unless File.exists?(@buildfile)
  end
  
end