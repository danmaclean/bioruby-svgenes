module Bio
  class Graphics
#The Primitive class is used to hold information about Glyphs.
#They contain a Glyph type and then a Hash of parameters pertinent for that Glyph
class Primitive
  attr_reader :primitive
  #Creates a new Primitive and initialises the Hash keys into instance variables
  #
  #+args+
  #* primitive = the Primitive type
  #* args = a hash of parameters needed to initialise the given Glyph type
  def initialize(primitive,args)
    @primitive = primitive
    args.each_key do |k|
      self.instance_variable_set("@#{k}", args[k])
    end 
  end

  #Updates a Primitive and initialises any new parameters into instance variables
  #
  #+args+
  #* args = a hash of new parameters for the given Glyph type
  def update(args)
    args.each_key do |k|
      self.instance_variable_set("@#{k}", args[k])
    end
  end
  
end

end
end