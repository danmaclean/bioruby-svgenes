module Bio
  class Graphics
class Glyph
  attr_reader :glyphs
  #holds a load of definitions for glyphs .. a glyph is an array of primitives... 
  @glyphs = [:generic, :directed, :transcript, :scale, :label, :histogram, :circle, :down_triangle, :up_triangle, :span]
  
  def self.generic(args) #:x, :y, :width :fill, :stroke :stroke_width, :style, :height, 
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
      if args[:gap_marker] == "angled" and not args[:block_gaps].empty?
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
      composite
  end
  
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
  
  def self.label(args)
    [Bio::Graphics::Primitive.new(:text, 
                   :text => args[:text], 
                   :x => args[:x], 
                   :y => args[:y], 
                   :fill => "black", 
                   :style => "font-family:monospace;")]
  end
  
  def self.gradients #needs to know which of its gradients are predefined
    [:red_white_h, :green_white_h, :blue_white_h, :yellow_white_h, :red_white_radial, :green_white_radial, :blue_white_radial, :yellow_white_radial ]
  end
  
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