require 'test/unit'
require 'lib/project'

class ProjectTest < Test::Unit::TestCase
  
  def test_can_get_libs_from_project
    libs=Project.find_libs("functional_test/lib")
    assert_equal('lib_foo.jar',libs.to_s)
  end
  
end

