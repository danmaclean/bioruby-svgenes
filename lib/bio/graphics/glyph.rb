module Bio
  class Graphics

  #A glyph is a particular shape that represents a genomic feature. Bio::Graphics::Glyph objects represent glyphs. Bio::Graphics::Glyphs are created internally according to
  #specification from the Bio::Graphics::Track and not instantiated directly by the user.
  #Internally, these are constructed as an array of Bio::Graphics::Primitive objects, which are collections of simple shapes, combined appropriately to make a glyph
class Glyph

  #The different type of Glyphs are:
  #* :generic
  #* :circle
  #* :directed
  #* :down_triangle
  #* :up_triangle
  #* :span
  #* :transcript
  #* :scale
  #* :label
  #* :histogram

attr_reader :glyphs
  #only glyphs defined here will be allowed 
  @glyphs = [:generic, :directed, :transcript, :scale, :label, :histogram, :circle, :down_triangle, :up_triangle, :span]
  
  #A generic glyph is a block of colour that displays no specific directional information attached.
  #
  #== args
  #* :height = the height of the Glyph (default = 10)
  #* :fill_color = the fill colour of the Glyph (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # }  #* :stroke = the outline colour of the Glyph (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :stroke_width = The width of the outline stroke (default = 1), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :x_round = x-axis radius of the ellipse used to round off the corners of the rectangle (default = 1)
  #* :y_round = y-axis radius of the ellipse used to round off the corners of the rectangle (default = 1)
  #* :style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :x = x coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #* :y = y coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #
  #=== returns
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects
  def self.generic(args)
    args = { 
      :height => 10, 
      :fill_color => 'red', 
      :stroke => "black", 
      :stroke_width => 1, 
      :x_round => 1, 
      :y_round => 1, 
      :style => "fill-opacity:0.4;"}.merge!(args)
    [Bio::Graphics::Primitive.new(:rectangle, args)]
  end

  #A circular glyph centered on the start of the feature it represents
  #
  #== args
  #* :radius = the radius of the circle  (default = 10)
  #* :fill_color = the fill colour of the Glyph (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # }  #* :stroke = the outline colour of the Glyph (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :stroke_width = The width of the outline stroke (default = 1), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;"
  #* :x = base x coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #* :y = base y coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #
  #=== returns
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects
  def self.circle(args) 
    args = { 
      :radius => 10, 
      :fill_color => 'red', 
      :stroke => "black", 
      :stroke_width => 1, 
      :style => ""}.merge!(args)
      args[:x_center] = args[:x]
      args[:y_center] = args[:y]
      [:x, :y].each {|e| args.delete(e)}
    [Bio::Graphics::Primitive.new(:circle, args)]
  end 
  
  #A polygon glyph with a point on the end that represents the features strand and direction
  #== args
  #* :width = the width of the feature in px
  #* :fill_color = the fill colour of the Glyph (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # }
  #* :stroke = the outline colour of the Glyph (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :stroke_width = The width of the outline stroke (default = 1), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;"
  #* :strand = the strand on which the feature is located. May be '+' or '-'
  #* :points = the x and y axis coordinates that make up the corners of the polygon, calculated and added by the Bio::Graphics::Page object
  #* :x = base x coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #* :y = base y coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #The points of the polygon are calculated form the +:x+ and +:y+ co-ordinates
  #
  #=== returns
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects 
  def self.directed(args) #:x, :y, :width :fill, :stroke :stroke_width, :style, :height
    args = {
      
      :height => 10, 
      :fill_color => 'red', 
      :stroke => "black", 
      :stroke_width => 1, 
      :style => "fill-opacity:0.4;"}.merge!(args)
      
      if args[:strand] == '-'
        args[:points] = "#{args[:x]},#{args[:y]} #{args[:x] + args[:width]},#{args[:y]} #{args[:x] + args[:width]},#{args[:y] + args[:height] } #{args[:x]},#{args[:y] + (args[:height])} #{args[:x] - (args[:height] * 0.2)},#{args[:y] + (args[:height]/2)}"
      else
        args[:points] = "#{args[:x]},#{args[:y]} #{args[:x] + args[:width] - (args[:height] * 0.2)},#{args[:y]} #{args[:x] + args[:width]},#{args[:y] + (args[:height]/2) } #{args[:x] + args[:width] - (args[:height] * 0.2)},#{args[:y] + args[:height]} #{args[:x]},#{args[:y] + args[:height]}"

      end
    [Bio::Graphics::Primitive.new(:polygon, args)]
  end
  
  #A downward-pointing triangle glyph
  #== args
  #* :height = the height of the Glyph (default = 10)
  #* :fill_color = the fill colour of the Glyph (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # } #* :stroke = the outline colour of the Glyph (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :stroke_width = The width of the outline stroke (default = 1), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :x = x coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #* :y = y coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #
  #=== returns
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects
  def self.down_triangle(args) #:x, :y, :width :fill, :stroke :stroke_width, :style, :height
    args = {
      
      :height => 10, 
      :fill_color => 'red', 
      :stroke => "black", 
      :stroke_width => 1, 
      :style => "fill-opacity:0.4;"}.merge!(args)

      args[:points] = "#{args[:x]},#{args[:y]} #{args[:x] + args[:width]},#{args[:y]} #{ args[:x] + (args[:width]/2) },#{(args[:y] + args[:height]) }"
    [Bio::Graphics::Primitive.new(:polygon, args)]
  end
  
  #An upward-pointing triangle glyph
  #== args
  #* :height = the height of the Glyph (default = 10)
  #* :fill_color = the fill colour of the Glyph (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # }
  #* :stroke = the outline colour of the Glyph (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :stroke_width = The width of the outline stroke (default = 1), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :x = x coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #* :y = y coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #
  #=== returns
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects
  def self.up_triangle(args) #:x, :y, :width :fill, :stroke :stroke_width, :style, :height
    args = {
      :height => 10, 
      :fill_color => 'red', 
      :stroke => "black", 
      :stroke_width => 1, 
      :style => "fill-opacity:0.4;"}.merge!(args)
      args[:points] = "#{args[:x]},#{args[:y] + args[:height]} #{args[:x] + args[:width]},#{args[:y] + args[:height]} #{ args[:x] + (args[:width]/2) },#{args[:y] }"
    [Bio::Graphics::Primitive.new(:polygon, args)]
  end
  
  #A line (span) glyph
  #
  #+args+
  #* :height = the height of the Glyph (default = 10)
  #* :fill_color = the fill colour of the Glyph (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # }
  #* :stroke = the outline colour of the Glyph (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :stroke_width = The width of the outline stroke (default = 1)
  #* :style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :x = x coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #* :y = y coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #
  #=== returns
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects
  def self.span(args)
    args = {
      :height => 10,
      :fill_color => 'red',
      :stroke => "black",
      :stroke_width => 1,
      :style => "fill-opacity:1;"
    }.merge!(args)
    args[:x1] = args[:x]
    args[:x2] = args[:x] + args[:width]
    args[:y1] = args[:y]
    args[:y2] = args[:y]
    [Bio::Graphics::Primitive.new(:line, args)]
  end
  
  #Creates a transcript glyph, which is a composite glyph containing generic glyphs for the exons/utrs and a directed glyph
  #at the end. The glyphs are joined by lines.
  #
  #== args
  #* :height = the height of the Glyph (default = 10)
  #* :utr_fill_color = the fill colour of the utr part of the glyph (default = 'black'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # }
  #* :utr_stroke = the outline colour of the utr part of the glyph (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :utr_stroke_width = The width of the outline stroke for the utr part of the glyph (default = 1)
  #* :exon_fill_color = the fill colour of the utr part of the glyph (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients or a custom definition of a gradient 
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  #or a custom definition of a gradient
  # {:type => :radial, 
  # :id => :custom, 
  # :cx => 5, 
  # :cy => 5, 
  # :r => 50, 
  # :fx => 50, 
  # :fy => 50, 
  #   :stops => [ {
  #        :offset => 0, 
  #        :color => 'rgb(255,255,255)', 
  #        :opacity => 0
  #        },  {
  #        :offset => 100, 
  #        :color => 'rgb(0,127,200)', 
  #        :opacity => 1
  #        }, ]
  # }
  #* :exon_stroke = the outline colour of the exon part of the glyph (default = "black") can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :exon_stroke_width = The width of the outline stroke for the exon part of the glyph (default = 1)
  #* :line_color = the colour for the line part that joins the blocks (default = 'black') can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :line_width = the width ffor the line part that joins the blocks (default = 1)
  #* :exon_style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :utr_style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :line_style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :block_gaps = gaps between the rendered blocks - calculated internally by Bio::Graphics::Page object
  #* :gap_marker = style of the line between blocks - either angled or straight
  #* :x = x coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #* :y = y coordinate of the feature in pixels, usually added by the Bio::Graphics::Page object
  #
  #+returns+
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects
  def self.transcript(args)
      args = {
      :height => 10, 
      :utr_fill_color => 'black', 
      :utr_stroke => "black", 
      :utr_stroke_width => 1, 
      :exon_fill_color => 'red', 
      :exon_stroke => "black", 
      :exon_stroke_width => 1, 
      :line_color => 'black',
      :line_width => 1, 
      :exon_style => "fill-opacity:0.4;",
      :utr_style => "",
      :line_style => "",
      :block_gaps => "",
      :gap_marker => ""
      }.merge!(args)
      
      composite = []

      if not args[:utrs].empty?  ##draw the utr as terminal element...##terminal utr is the one with the point on...
        x,width =  args[:strand] == '-' ? args[:utrs].shift : args[:utrs].pop 
        composite += Glyph.directed(:x => x, 
                                    :y => args[:y], 
                                    :width => width, 
                                    :strand => args[:strand], 
                                    :height => args[:height], 
                                    :fill_color => args[:utr_fill_color], 
                                    :stroke =>args[:utr_stroke], 
                                    :stroke_width => args[:utr_stroke_width], 
                                    :style => args[:utr_style] )
        ##draw the other(s!) 
        args[:utrs].each do |utr|
          composite <<  Bio::Graphics::Primitive.new(:rectangle, {
                                                    :x => utr.first, 
                                                    :width => utr.last, 
                                                    :y => args[:y], 
                                                    :height => args[:height], 
                                                    :fill_color => args[:utr_fill_color], 
                                                    :stroke =>args[:utr_stroke], 
                                                    :stroke_width => args[:utr_stroke_width], 
                                                    :style => args[:utr_style]} )
        end
      else ## draw the terminal exon as terminal element  
        points = nil      
        x,width =  args[:strand] == '-' ? args[:exons].shift : args[:exons].pop 
        composite += Glyph.directed(:x => x, 
                                    :y => args[:y], 
                                    :width => width, 
                                    :strand => args[:strand], 
                                    :height => args[:height], 
                                    :fill_color => args[:exon_fill_color], 
                                    :stroke =>args[:exon_stroke], 
                                    :stroke_width => args[:exon_stroke_width], 
                                    :style => args[:exon_style] )
      end
      #draw any remaining exons
      args[:exons].each do |exon|
          composite <<  Bio::Graphics::Primitive.new(:rectangle, {
                                                    :x => exon[0], 
                                                    :width => exon[1], 
                                                    :y => args[:y], 
                                                    :height => args[:height], 
                                                    :fill_color => args[:exon_fill_color], 
                                                    :stroke =>args[:exon_stroke], 
                                                    :stroke_width => args[:exon_stroke_width], 
                                                    :style => args[:exon_style]} )
      end
      if not args[:block_gaps].empty?
        if args[:gap_marker] == "angled"
          args[:block_gaps].each do |gap|
            points = "#{gap.first},#{args[:y] + (args[:height]/2) } #{gap.first + (gap.last/2)},#{args[:y]} #{gap.first + gap.last},#{args[:y] + (args[:height]/2)}"
            composite << Bio::Graphics::Primitive.new(:polyline, {
                                                  :points => points, 
                                                  :stroke => args[:line_color], 
                                                  :stroke_width => args[:line_width], 
                                                  :fill => "none", 
                                                  :line_style => args[:line_style]})
          end
        else
        #add line
          composite << Bio::Graphics::Primitive.new(:line, {
                                              :x1 => args[:x], 
                                              :x2 => "#{args[:x] + args[:width]}", 
                                              :y1 => args[:y] + (args[:height]/2), 
                                              :y2 => args[:y] + (args[:height]/2), 
                                              :stroke => args[:line_color], 
                                              :stroke_width => args[:line_width], 
                                              :line_style => args[:line_style]})

        end
      end
      composite
  end
  
  #Glyph for the scale across the top of the rendered page
  #
  #== args
  #* :start = the start of the scale, usually added by the Bio::Graphics::Page object
  #* :stop = the end of the scale, usually added by the Bio::Graphics::Page object
  #* :number_of_intervals = the number of tick-marks the scale will marked with
  #* :page_width = the minimum width of the page, usually updated by the Bio::Graphics::Page object
  #
  #+returns+
  #
  #* An Array[http://www.ruby-doc.org/core-2.0/Array.html] of Bio::Graphic::Primitive objects (of type 'line', 'rectangle' and 'text')
  def self.scale(args)
    first_mark = args[:start]
    last_mark = args[:stop] 
    #(num.to_f / @nt_per_px_x.to_f)
    full_dist = last_mark - first_mark
    interval_width =  full_dist / (args[:number_of_intervals] - 1) 


    a = [Bio::Graphics::Primitive.new(:line, 
                               :stroke => 'black', 
                               :stroke_width => 1, 
                               :x1 => 1, :x2 => args[:page_width],# * 1.1, 
                               :y1 => "20", :y2 => "20"  )]


    marks = (first_mark..last_mark).step(interval_width).to_a
  
    px_per_nt =  args[:page_width].to_f / full_dist.to_f
    marks.each do |mark|
      x =   (mark.to_f - first_mark ).to_f * px_per_nt
      a << Bio::Graphics::Primitive.new(:rectangle, 
                         :x => x, 
                         :y => 20, 
                         :stroke => 'black', 
                         :stroke_width => 1, 
                         :width => 1, 
                         :height => 5 )
                         
      a << Bio::Graphics::Primitive.new(:text, 
                         :x => x, 
                         :y => 40, :fill => 'black', 
                         :text => mark, 
                         :style => "font-family:Arial;font-style:italic")
    end
    return a
  end
  
  #Creates a label Glyph to write text
  #
  #+args+
  #* :text = the text to write
  #* :fill = the colour of the text ("black")
  #* :style = the style of writing ("font-family:monospace;")
  #* :x = the co-ordinates of the Glyph for the x-axis
  #* :y = the co-ordinates of the Glyph for the y-axis
  def self.label(args)
    [Bio::Graphics::Primitive.new(:text, 
                   :text => args[:text], 
                   :x => args[:x], 
                   :y => args[:y], 
                   :fill => "black", 
                   :style => "font-family:monospace;")]
  end
  
  #The list of pre-defined gradients
  def self.gradients #needs to know which of its gradients are predefined
    [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  end

  #Sets the the type (linear or radial) and colours for a pre-defined gradient
  #
  #== args
  #* gradient = a pre-defined gradient type, one of 
  # [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  def self.gradient(gradient)
    type, color = case gradient
    when :red_white_h
      [:linear, "red"]
    when :green_white_h
      [:linear, "green"]
    when :blue_white_h
      [:linear, "blue"]
    when :yellow_white_h
      [:linear, "yellow"]
    when :red_white_radial
      [:radial, "red"]
    when :green_white_radial
      [:radial, "green"]
    when :blue_white_radial
      [:radial, "blue"]
    when :yellow_white_radial
      [:radial, "yellow"]
    end
    
    case type
    when :linear
            {:type => :linear, 
       :id => gradient, 
       :x1 => 0, :y1 => 0, 
       :x2 => 0, :y2 => 100, 
       :stops => [
         {
          :color => color, 
          :offset => 0, 
          :opacity=> 1
          },
          {
           :color => "white", 
           :offset => 100, 
           :opacity=> 1 
           }
          ]
        }
    when :radial
      {
       :type => :radial, 
       :id => gradient, 
       :cx => 50, :cy => 50, 
       :r => 50, :fx => 50, :fy => 50, 
       :stops => [ 
         {:offset => 0, 
          :color => "white", 
          :opacity => 0
          },  
          {
          :offset => 100, 
          :color => color, 
          :opacity => 1
          }
        ]
      }
    end
    
  end
  
  
end
end
end