module Bio
  class Graphics
    
 #The Bio::Graphics::SVGEE class takes argument information in a hash and creates SVG Markup tags, which it will draw
class SVGEE
  attr_reader :primitives, :defs, :supported_primitives
  #Creates a new Bio::Graphics::SVGEE object which will contain all the necessary objects to display all the features on a page
  #
  #== args
  #* :width = the width of the SVG page (100%)
  #* :height = the amount of the page height the svg should take up (100%)
  #* :style = the svg style information
  def initialize(args)
    opts = {:width => '100%', :height => '100%'}.merge!(args)
    @width = opts[:width]
    @height = opts[:height]
    @style= opts[:style]
    @primitives = []
    @defs = []
    @supported_primitives = [:circle, :rectangle, :ellipse, :line, :polyline, :text]
  end
  
  #Produces the opening text for an svg file
  def open_tag
    %{<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="#{@width}" height="#{@height}" style="#{@style}" xmlns:xlink="http://www.w3.org/1999/xlink">}
  end
  
  #Produces the closing text for an svg file
  def close_tag
    %{</svg>}
  end
  
  private
  def add(primitive_string)
    @primitives << primitive_string
  end
  
  def add_def(definition_string)
    @defs << definition_string
  end
  
  def make_tag(primitive, args)
    if args.has_key?(:link)
      add link_and_tag(primitive, args)
    else
      add self.send("#{primitive}_tag", args)
    end
    return Bio::Graphics::Primitive.new(primitive, args)
  end
  
  def link_and_tag(primitive, args)
    %{<a xlink:href="#{args[:link][:href]}" target="#{args[:link][:target]}">}  + self.send("#{primitive}_tag", args) + %{</a>}
  end
  
  def circle_tag(a = {})
    %{<circle cx="#{a[:x_center]}" cy="#{a[:y_center]}" r="#{a[:radius]}" fill="#{a[:fill_color]}" } + common_attributes(a) + %q{/>}
  end
  
  def rectangle_tag(a = {})
    %{<rect x="#{a[:x]}" y="#{a[:y]}" width="#{a[:width]}" height="#{a[:height]}" fill="#{a[:fill_color]}" rx="#{a[:x_round]}" ry="#{a[:y_round]}" } + common_attributes(a) + %q{/>}
  end
  
  def ellipse_tag(a = {})
    %{<ellipse cx="#{a[:x_center]}" cy="#{a[:y_center]}" rx="#{a[:x_radius]}" ry="#{a[:y_radius]}" stroke="#{a[:stroke]}" stroke-width="#{a[:stroke_width]}" fill="#{a[:fill_color]}" style="#{a[:style]}" />}
  end
  
  def line_tag(a = {})
    %{<line x1="#{a[:x1]}" y1="#{a[:y1]}" x2="#{a[:x2]}" y2="#{a[:y2]}" } + common_attributes(a) + %q{/>}
  end
  
  def polyline_tag(a={})
    %{<polyline points="#{a[:points]}" fill="#{a[:fill]}" } + common_attributes(a) + %{ />}
  end
  
  def polygon_tag(a={})
    %{<polygon points="#{a[:points]}" fill="#{a[:fill_color]}" } + common_attributes(a) + %{ />}
  end
  
  def text_tag(a = {})
    %{<text x="#{a[:x]}" y="#{a[:y]}" fill="#{a[:fill]}" transform="#{a[:transform]}" style="#{a[:style]}">#{a[:text]}</text>}
  end
  
  def common_attributes(a={})
    param_str = ""
    a[:params].each{|k,v| param_str << %{ #{k}="#{v}"}} if a[:params]

    %{stroke="#{a[:stroke]}" stroke-width="#{a[:stroke_width]}" style="#{a[:style]}"} + param_str
  end
  
  def method_missing(primitive, args={}) #only used to dynamically select the primitive type.. 
    raise NoMethodError if not self.supported_primitives.include?(primitive) #we're only doing the listed primitive types...
    self.send "make_tag", primitive, args 
  end
  
  public
  #Adds a Primitive object to the SVGEE object and makes the svg text for that Primitive
  def add_primitive(primitive_object)
    args = {}
    primitive_object.instance_variables.each{|v| args[v.to_s.gsub(/@/,"").to_sym] = primitive_object.instance_variable_get(v)  }
    primitive_string = args.delete(:primitive)
    make_tag(primitive_string, args)
  end
  #Takes the gradient information from a Glyph, which must be of type 'radial' or 'linear' and creates the svg text for that gradient
  #* +a+ = a gradient (a gradient type, a colour and the parameters for a given type)
  def gradient(a)
    definition_string = case a[:type]
    when :radial
      %{<radialGradient id="#{a[:id]}" cx="#{a[:cx]}%" cy="#{a[:cy]}%" r="#{a[:r]}%" fx="#{a[:fx]}%" fy="#{a[:fy]}%">}
    else
      %{<linearGradient id="#{a[:id]}" x1="#{a[:x1]}%" x2="#{a[:x2]}%" y1="#{a[:y1]}%" y2="#{a[:y2]}%">}
    end
    a[:stops].each do |s|
      definition_string = definition_string + "\n" + %{<stop offset="#{s[:offset]}%" style="stop-color:#{s[:color]};stop-opacity:#{s[:opacity]}" />}
    end
    add_def definition_string + (a[:type] == :linear ? '</linearGradient>' : '</radialGradient>')
  end
  #Produces the svg text to display all the features on a Page
  def draw
    head = self.open_tag
    defstring = ""
    defstring = "<defs>\n" + self.defs.join("\n") + "\n </defs>\n" if not defs.empty?
    shapes = self.primitives.join("\n")
    close = self.close_tag
    head + defstring + shapes + close
  end
  
end

end
end
=begin How to use SVGEE
s = SVGEE.new
s.gradient(:radial => "grad1", :cx => 50, :cy => 50, :r => 50, :fx => 50, :fy => 50, :stops => [ {:offset => 0, :color => 'rgb(255,255,255)', :opacity => 0},  {:offset => 100, :color => 'rgb(0,0,255)', :opacity => 1},] )
s.circle(:x_center => 40, :y_center => 40, :radius => 20, :fill_color => "url(#grad1)")
s.circle(:x_center => 250, :y_center => 250, :radius => 20, :fill_color => "url(#grad1)", :link => {:href => "http://www.bbc.co.uk"})
s.rectangle(:x => 125, :y => 125, :width => 100, :height => 50, :fill_color => 'red', :stroke => 'black', :stroke_width => 2, :style => "fill-opacity:0.1;stroke-opacity:0.9")
s.rectangle(:x => 125, :y => 125, :round_x => 5, :round_y => 5, :width => 100, :height => 50, :fill_color => 'red', :stroke => 'black', :stroke_width => 2, :style => "fill-opacity:0.1;stroke-opacity:0.9")
prim = s.ellipse(:x_center => 100, :y_center => 190, :x_radius => 40, :y_radius => 20, :fill_color => 'green', :stroke => 'black')
s.line(:x1 => 10, :y1 => 10, :x2 => 145, :y2 => 145, :stroke_width => 5, :stroke => 'blue')
s.polyline(:points => "2,2 400,440 600,440", :stroke_width => 10, :stroke => "#f00", :fill => "none")

s.text(:x => 100, :y => 100, :fill => 'red', :text => "Look! A circle!", :style => "letter-spacing:2;font-family:Arial")
s.text(:x => 100, :y => 400, :fill => 'green', :text => "This one is a link", :link => {:href => "http://www.bbc.co.uk"})
prim.update(:x_center => 200)
s.add_primitive(prim)  #add one of the returned, updated Primitive objects 

s.draw
=end
