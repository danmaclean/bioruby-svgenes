module Bio
  class Graphics
    
  #The Bio::Graphics::Track object acts as a container for Bio::Graphics::MiniFeature objects. The Bio::Graphics::Track takes style information on instantiation.
  #Style information is applied to each feature in the track by the track
class Track
  attr_reader :glyph, :name, :label, :args, :track_height, :scale, :max_y, :min_width
  attr_accessor :features, :feature_rows, :name, :number_rows, :feature_height
  
  #Creates a new Bio::Graphics::Track
  #
  #==args
  #
  #* :glyph = one of Bio::Graphics::Glyphs#glyphs currently 
  # [:generic, :directed, :transcript, :scale, :label, :histogram, :circle, :down_triangle, :up_triangle, :span]
  #* :stroke_color =  the outline colour of the glyphs in the track (default = "black"), can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :fill_color = the fill colour of the glyphs in the track (default = 'red'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients 
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
  #* :track_height = minimum height for the track, will be modified automatically if more space is needed e.g for overlapping features (default = auto),
  #* :name = a displayed name for the track (default = 'feature_track')
  #* :label = display the name given to the track (default = true), 
  #* :stroke_width = width in pixels of the outline of the glyphs (default=1)
  #* :x_round = x radius of the ellipse used to round off the corners of rectangles (default = 1)
  #* :y_round = y radius of the ellipse used to round off the corners of rectangles (default = 1)
  #:utr_fill_color = the fill colour of the utr part of the glyph (default = 'black'), can be any SVG colour eg rgb(256,0,0) or #FF0000, or one of the built in gradient types Bio::Graphics::Glyph#gradients
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
  # 
  #* :exon_stroke = the outline colour of the exon part of the glyph (default = "black") can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :exon_stroke_width = The width of the outline stroke for the exon part of the glyph (default = 1)
  #* :line_color = the colour for the line part that joins the blocks (default = 'black') can be any SVG colour eg rgb(256,0,0) or #FF0000
  #* :line_width = the width ffor the line part that joins the blocks (default = 1)
  #* :exon_style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :utr_style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :line_style = an arbitrary SVG compliant style string eg "fill-opacity:0.4;" 
  #* :gap_marker = style of the line between blocks - either angled or straight
  def initialize(args)
    @args = {:glyph => :generic, 
             :name => "feature_track", 
             :label => true, 
             :feature_height => 10,
             :track_height => nil }.merge!(args)
    @glyph = @args[:glyph]
    @name = @args[:name]
    @label = @args[:label]
    @track_height = @args[:track_height]
    @features = []
    @feature_rows = []
    @scale = @args[:scale]
    @feature_height = @args[:feature_height]
    @number_of_rows = 1
    @max_y = args[:max_y]
    @min_width = args[:min_width]
    

  end
  
  #Adds a new Bio::Graphics::MiniFeature object to the current Bio::Graphics::Track
  def add(feature)
    @features << feature
  end

  #Calculates how many rows are needed per track for overlapping features
  #and which row each feature should be in. Usually only called by the enclosing Bio::Graphics::Page object.
  def get_rows(page=nil)
    @feature_rows = Array.new(@features.length, -1)
    rows = Hash.new { |h,k| h[k] = [] }
    @features.each_with_index  do |f1, i|
      current_row = 1
      begin
        found = true
        rows[current_row].each_with_index do |f2, j|
          if overlaps(f1, f2, page)
            found = false
            current_row += 1
            break
          end
        end
      end until found
      @feature_rows[i] = current_row
      rows[current_row] << f1
    end
    @number_rows = @feature_rows.max
  end

  #Calculates whether two Bio::Graphics::MiniFeature objects overlap by examining their start and end positions.
  #If the page where they are placed is given, then the function also considers the features' labels.
  #
  #+args+
  #* f1 - a Bio::Graphics::MiniFeature object
  #* f2 - a Bio::Graphics::MiniFeature object
  #* page - the optional Bio::Graphics::Page object where the features are placed
  def overlaps(f1, f2, page=nil)
    if not page
      b1 = [f1.start, f1.end]
      b2 = [f2.start, f2.end]
    else
      b1 = page.compute_boundaries(f1)
      b2 = page.compute_boundaries(f2)
    end
    (b2[0] <= b1[1]) and (b1[0] <= b2[1])
  end
  
end


end
end
