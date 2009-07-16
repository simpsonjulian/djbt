require 'test/unit'
require 'lib/ant_runner'
require 'mock'

class AntRunnerTest < Test::Unit::TestCase
  
  def setup
    @ant_runner = AntRunner.new('C:/EclipseWorkspace/ant/lib/ant-launcher.jar')
  end
  
  def test_builder_gets_correct_ant_jar
    assert_equal('C:/EclipseWorkspace/ant/lib/ant-launcher.jar', @ant_runner.ant_jar)
  end
  
  
  def test_can_specify_build_dir
    @ant_runner.build_dir="/tmp/foo/build"
    fail("not finished")
  end
  
  def test_can_specify_lib_dir
    @ant_runner.lib_dir="foo"
    fail("not finished")
  end
  
end

