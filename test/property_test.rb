require 'lib/property_file'
require'test/unit'

class PropertyTest < Test::Unit::TestCase
  
  def setup
    @property = PropertyFile.new(nil,nil,nil)
  end
  
  def test_can_read_property_with_equals
    prop=@property.read_property('foo=bar=baz')
    assert_equal('foo',prop)
  end
  
  def test_can_read_property_with_padding
    prop=@property.read_property(' foo = bar ')
    assert_equal('foo',prop)
  end
  
  def test_can_read_property
    prop=@property.read_property('test.blah.results.dir=build/test/blah/results')
    assert_equal('test.blah.results.dir',prop)
  end
  
  def test_get_an_array_of_strings
  end
  
end