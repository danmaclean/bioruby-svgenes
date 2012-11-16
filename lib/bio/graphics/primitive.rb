class Primitive
  attr_reader :primitive
  
  def initialize(primitive,args)
    @primitive = primitive
    args.each_key do |k|
      self.instance_variable_set("@#{k}", args[k])
    end 
  end
  
  def update(args)
    args.each_key do |k|
      self.instance_variable_set("@#{k}", args[k])
    end
  end
  
end