require 'test/unit'
require 'rexml/document'
require 'lib/lant'
require 'lib/property_file'
include REXML

class LantTest < Test::Unit::TestCase
  
  def setup
    @lant = Lant.new
    raw_build_file=("test/test.xml")
    @buildfile = File.new(raw_build_file)
    @property = PropertyFile.new(nil,nil,nil)
    @project = Project.new(raw_build_file)
  end
  
  def test_can_catch_property_inside_target
    doc = Document.new @buildfile
    @project.doc = doc
    nested_props = @project.properties_in_targets()
    assert_equal("bar",nested_props.to_s)
  end
  
  def test_can_list_properties_scoped_to_project
    @buildfile = File.new("test/test.xml")
    @project.doc = Document.new @buildfile
    properties = @project.properties()
    assert_equal("foo",properties[0].to_s)
  end
  
  def test_will_get_project_basedir
    @project.doc = Document.new(@buildfile)
    basedir = @project.get_basedir()
    assert_equal(".",basedir)
  end

  def test_property_descripton_for_proj
    @project.doc = Document.new(@buildfile)
    desc = @project.get_description()
    assert_equal("builds foo with bar",desc)
  end
      
  def test_project_should_have_name
    @project.doc = Document.new(@buildfile)
    name = @project.get_name()
    assert_equal("test",name)
  end

  def test_can_detect_imports
    @project.doc = Document.new(@buildfile)
    assert(@project.has_imports?)
  end

  def test_can_find_propfile
    @property.basedir = ".."
    @property.buildfile = "/foo/bar/baz/build.xml"
    location = @property.find("foo.properties")
    assert_equal("/foo/bar/baz/../foo.properties",location)
  end
  
  def test_can_find_declared_and_used_property
    assert(@project.property_is_used?('igetcalled',@buildfile))
  end   
   
  def test_can_find_declared_but_unused_property
    assert_equal(false,@project.property_is_used?('inevergetcalled',@buildfile))
  end
  
  def test_can_find_undeclared_and_used_property
    props = ['foo','baz','igetcalled','inevergetcalled']
    assert_equal('iamnotdeclared',@project.undeclared_props(props, @buildfile).to_s)
  end
  
  def test_can_find_single_usage_of_property
    props = ['igetcalled']
    assert_equal(1,@project.property_usages(props,@buildfile))
  end    
end
