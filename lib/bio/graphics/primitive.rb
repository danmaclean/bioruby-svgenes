module Bio
  class Graphics

#The Bio::Graphics::Primitive class is used to describe simple shapes. It is basically a simple data container that
#has lots of dynamically set instance variables including a name. The Bio::Graphics::Primitive object is later translated
#to an SVG string by the Bio::Graphics::SVGEE class. 
class Primitive
  attr_reader :primitive
  
  #Creates a new Primitive and initialises instance variables dynamically from the args hash 
  #
  #== args+
  #* :primitive = the Primitive type
  #* args = a hash of parameters needed to describe the attributes of the primitive type
  def initialize(primitive,args)
    @primitive = primitive
    args.each_key do |k|
      self.instance_variable_set("@#{k}", args[k])
    end 
  end

  #Updates a Primitive and sets the provided values as instance variables
  #
  #== args
  #* args = a hash of new parameters for the given primitive type
  def update(args)
    args.each_key do |k|
      self.instance_variable_set("@#{k}", args[k])
    end
  end
  
end

end
end