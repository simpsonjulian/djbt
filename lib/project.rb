require 'rexml/document'
require 'lib/property_file'
include REXML

class Project
  attr_writer :file, :doc
  attr_reader :buildfile
  
  
  def initialize(file)
    @file = file
    bf = File.new(file)
    @doc = Document.new(bf)
    bf.rewind
    @buildfile = bf.read
  end
  
  def properties()
    props = Array.new
    @doc.elements.each("project/property") do |element|
      
      name = element.attributes["name"]
      property_file = element.attributes["file"]
      value = element.attributes["value"]
      location = element.attributes["location"]
      
      if (property_file != nil) then
        pf = PropertyFile.new(property_file,self.get_basedir,@file)
        pf.read.each do | prop |
          props.push(prop) if (prop != nil)
        end
      end
      
      props.push(name) if ((name != nil) and (value != nil ))
      props.push(name) if ((name != nil) and (location != nil ))
    end
    return props.uniq
  end
  
  def get_basedir()
    basedir=@doc.root.attributes["basedir"]  
    return basedir
  end
  
  def get_name()
    name=@doc.root.attributes["name"]
    return name
  end
  
  def properties_in_targets()
    nested=Array.new
    @doc.elements.each("project/target/property") do |element|
      name = element.attributes["name"]
      nested.push(name) if (name != nil)
      return nested.uniq
    end
    
  end
  
  def targets()
    targets=Array.new
    @doc.elements.each("/project/target") do |element|
      name=element.attributes["name"]
      targets.push(name) 
    end
    return targets.sort
  end
  
  def get_description()
    @doc.elements.each("/project/description") do |element|
      return element.text if element.has_text?
    end
  end  
  
  def property_is_used?(property,buildfile)
    used = false
    buildfile.each_line do |line|
      used = true if line.include?("${#{property}}")
    end
    return used
  end
  
  def get_unused_props(props,buildfile)
    unused=[]
    props.each do |prop|
      unused << prop unless property_is_used?(prop,buildfile)
    end
    return unused
  end
  
  def has_imports?
    imports=Array.new
    elements=@doc.elements.each("/project/import") do |element|
      imports << element.attributes["file"]
    end
    return false if (imports.length == 0)
    return true if (imports.length == 1) 
  end
  
  def property_usages(property,buildfile)
    string=""
    buildfile.each_line { |line| string << line} 
    string.scan("${#{property}}").length
  end
  
  def get_single_usage_props(props,buildfile)
    singles=[]
    props.each do |prop|
      singles.push(prop) if buildfile.include?("${#{prop}}")
    end
    return singles
  end
  
  def undeclared_props(props,buildfile)
    undeclared=[]
    buildfile.each_line do |line |
      line.scan(/\$\{[\w\-_\.]+\}/).each do |prop| 
        prop.sub!("${",'')
        prop.sub!("}",'')
        undeclared << prop unless props.include? prop
      end
    end
    return undeclared.uniq
  end
  
  def Project.find_libs(lib_dir)
      Dir.chdir(lib_dir)
    libs=Dir["**/*.jar"]
  end
  
  
end