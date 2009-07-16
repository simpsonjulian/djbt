$:<<"lib"
$:<<"test"
puts $:
require 'test/unit'
require 'test/unit/mock'
require 'ant_project'

class MockLibrary

  def initialize
  end
  
  def disable
  end
  
  def enable
  end
   
end

class MockBuilder < Object
  attr_writer :status
  def initialize(buildfile="build/build.xml",target="test")
    @buildfile=buildfile
    @target=target
    @status=true
  end
  
  def build
    return @status
  end
  
  def validate
    true
  end
end

class BasherTest < Test::Unit::TestCase
  
  def setup
    FileUtils.mkdir_p('build')
    FileUtils.touch('build/build.xml')
  end
  def test_project_can_find_libs
    project=AntProject.new('functional_test')
    assert_equal('functional_test/lib/lib_foo.jar', project.get_libs[0].to_s)
  end
  
  def test_can_overide_lib_dir
    project=AntProject.new('functional_test')
    project.lib_dir="/tmp"
    assert_equal([],project.get_libs)
  end
  
  def test_can_build_project
    project=AntProject.new('functional_test')
    assert(project.build(MockBuilder.new))
  end
  
  def test_failing_lib_will_display_unused_lib
    project = AntProject.new('build',MockBuilder)
    make_test_lib
    project.validate()    
    assert_equal("poo.jar",project.unused_libs[0].name)
    assert_equal([],project.used_libs)
  end
  
  def make_test_lib
    test_lib = File.join('build', 'lib', 'poo.jar')
    FileUtils.mkdir_p File.dirname(test_lib)
    FileUtils.touch test_lib
  end
  private :make_test_lib
  
  def test_failing_build_should_display_used_lib
    project = AntProject.new('build',MockBuilder)
    mb= MockBuilder.new
    mb.status = false
    project.builder = mb
    make_test_lib
    project.validate    
    assert_equal("poo.jar",project.used_libs[0].name)
    assert_equal([],project.unused_libs)
  end    
  
  def test_passing_build_should_display_used_lib
    project = AntProject.new('build',MockBuilder)
    project.builder= MockBuilder.new
    make_test_lib
    project.validate
    assert_equal("poo.jar",project.unused_libs[0].name)
    assert_equal([],project.used_libs)
  end
  
  def test_library_should_mark_invalid_lib_as_such
    test_lib=File.join('build','poo.jar')
    FileUtils.touch(test_lib)
    lib=Library.new(test_lib)
    mb=MockBuilder.new
    mb.status=false
    assert_equal(false,lib.verify(mb))
  end
  
  def test_library_should_mark_valid_lib_as_valid
    test_lib=File.join('build','poo.jar')
    FileUtils.touch(test_lib)
    lib=Library.new(test_lib)
    assert(lib.verify(MockBuilder.new))
  end
  
  
  def test_report_is_generated_from_a_build
    project = AntProject.new('build',MockBuilder)
    assert_nil(project.report)
    project.validate()
    assert(project.report)
  end
  
  def test_do_build_before_running_validate
    assert_raise BuildFailedError do
    project = AntProject.new('/tmp',FailingBuilder)
    end
  end
  
  def test_project_can_work_out_its_own_libs
    project = AntProject.new('build',MockBuilder)
    assert(project.validate())
  end
  
  def test_builder_can_do_preflight_check
    builder = Builder.new('build/buildFOO.xml','test')
    assert_raises RuntimeError do  
      builder.validate
    end 
  end
  def test_library_should_raise_error_if_file_doesnt_exist
    assert_raise RuntimeError do 
      lib=Library.new('/path/to/some/file')
    end
  end
  
  def test_builder_should_optionally_chdir_to_project_root_to_support_builds_that_arent_sane
    fail("not done")
  end
  
  def test_builder_can_detect_a_passing_build
    builder = Builder.new('functional_test/build.xml','foo')
  end
  
  def test_builder_should_accept_one_path_to_build_file
    assert(Builder.new('build/build.xml', 'test'))
  end
  
  def test_builder_should_find_the_ANT_HOME_var
    fail("not done")
  end
  
    
end  

class BuildFailedError <Exception
end
class  FailingBuilder
    def initialize(x, z)
    end
    def validate
      true
    end
  def build
    raise BuildFailedError
  end
end