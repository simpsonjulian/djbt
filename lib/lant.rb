require 'lib/project'
class Lant
  attr_writer :file, :basedir, :display_properties

  
  def parse(file)
    
    project = Project.new(file)
    
    @project_basedir = project.get_basedir()
    name = project.get_name()
    properties = project.properties()
    targets = project.targets()
    nested_props = project.properties_in_targets()
    description = project.get_description()
    unused_props = project.get_unused_props(properties,project.buildfile)
    single_use_props = project.get_single_usage_props(properties,project.buildfile)
    undeclared_props = project.undeclared_props(properties,project.buildfile)
    
    display("LANT - Ant Style Checker")
    display("Summary:", "#{properties.length} properties found, #{targets.length} targets found.")
    display("Project Description Missing","") if (description == nil)
    display("Project Name Missing","") if (name == nil)
    display("Properties defined inside targets:",nested_props) if (nested_props.length!=0)
    display("List of properties:",properties.sort) if (@display_properties==true)
    display("#{unused_props.length} unused props:",unused_props) if unused_props.length != 0 
    display("#{single_use_props.length} properties used once:", single_use_props) if single_use_props != 0 
    display("#{undeclared_props.length} properties undeclared:",undeclared_props) if (undeclared_props.length != 0)
    
  end
  
  
  
  def display(title,*args)
    line="--------------------------------------------------------------"
    puts line
    print "#{title}\n"
    puts line
    puts args
    puts
    
  end
end


  