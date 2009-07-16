class PropertyFile
  attr_writer :file, :basedir, :buildfile
  
  def initialize( file, basedir, buildfile )
    @file = file
    @basedir = basedir
    @buildfile = buildfile
  end
  
  def read()
    file=self.find(@file)
    puts "reading properties from #{file}"
    
    props=Array.new
    if File.exists?(file) then
      IO.foreach(file) do |line|
        property=self.read_property(line.chomp)
        props.push(property) unless (property == nil)
        
      end
    end
    return props
  end
  
  def read_property(line)
    return nil if /^#|^\s+$/.match(line)
    
    if line.match(/([^=]+)=(.*)/) then
      property,val=$1
      puts "ewww, property #{property} is an array" if property.is_a? Array
      return property.strip
    else
      return nil
    end
  end
  
  def find(propfile)
    dirname = File.dirname(@buildfile)
    return "#{dirname}/#{@basedir}/#{propfile}"
  end
  
end
