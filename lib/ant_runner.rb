class AntRunner
  attr_accessor :ant_jar, :target
  
  def initialize(ant_jar )
    @target = 'clean compile'
    @ant_jar = ant_jar
  end
  
  def run(file)
    result = system("java -classpath #{@ant_jar} org.apache.tools.ant.launch.Launcher -f #{file} #{@target}")
    return result
  end
end
