module Bio
  class Graphics

    ##
    #The Bio::Graphics::Page class represents the page of the final rendered SVG and is the top level container into which Bio::Graphics::Tracks are added.
    #It will contain a scale
    #and all the tracks along with their features. The scale is calculated will start at the genomic co-ordinates of the start
    #of the first feature and stop at the end of the last feature)
    class Page
      #Creates a new Page object.
      #
      #== args
      #* :height = the minimum height of the rendered page
      #* :width = the minimum width of the rendered page
      #* :background_color = the background color of the page (default none), can be any SVG colour eg rgb(256,0,0) or #FF0000
      def initialize(args)
        @height = args[:height]
        @width = args[:width]
        args[:style] = "background-color:#{args[:background_color]};" if args[:background_color]
        @svg = SVGEE.new(args)
        @scale_start = 1.0/0.0
        @scale_stop = -1.0/0.0
        @tracks = [] #array of track objects with loads of features in it...
        @nt_per_percent = 1;
        @num_intervals = args[:number_of_intervals]
        @track_top = 30

        def @svg.update_height(height)
          @height = height
        end

        #def @svg.update_width(width)
        #  @width = width
        #end
      end

      #Takes a custom-written json file and uses it to generate an SVG document based on the information in that page.
      #* :json a JSON file describing the parameters and files needed to build an SVG document
      def self.from_json(args)
        require 'rubygems'
        require 'json'
        data = JSON.parse(File.open(args[:json], 'r').read)
        p = Page.new(:width => data["Page"]["width"],
                     :height => data["Page"]["height"],
                     :number_of_intervals => data["Page"]["intervals"])
        data["Tracks"].each do |track|
          #prep the track args
          track_args = track.dup
          track_args.delete("file")
          track_args.delete("file_type")
          track_args = track_args.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
          ##convert any of the pre-made gradient strings in the keys to symbol
          track_args.each_key do |k|
            next unless track_args[k].respond_to?(:to_sym)
            track_args[k] = track_args[k].to_sym if Glyph.gradients.include?(track_args[k].to_sym)
          end

          svg_track = p.add_track(track_args)
          features = [] ##set up the features...

          case track["file_type"] ##deal with the gff and data files
            when "gff"
              groups = {}
              parentless_features = []
              Page.parse_gff(track["file"]).each do |gff| #gets features in a list and links their children to them as members of the array at the key
                parent_id = gff.attributes.select { |a| a.first == 'Parent' }
                if parent_id.empty?
                  parentless_features << gff
                else
                  if groups[parent_id.first.last].nil?
                    groups[parent_id.first.last] = []
                    groups[parent_id.first.last] << gff
                  else
                    groups[parent_id.first.last] << gff
                  end
                end
              end
              #now flick through the parentless features and add any exons / UTRs
              parentless_features.each do |plf|
                require 'pp'
                #pp parentless_features
                gff_id = plf.attributes.select { |a| a.first == 'ID' }
                gff_id = gff_id.first.last
                exons = []
                utrs = []
                children = groups[gff_id] || children = []
                children.each do |child|
                  if child.feature == 'exon' or child.feature == 'CDS'
                    exons += [child.start, child.end]
                  elsif child.feature =~ /utr/i
                    utrs += [child.start, child.end]
                  end
                end
                features << MiniFeature.new(:start => plf.start, :end => plf.end, :exons => exons, :utrs => utrs, :strand => plf.strand, :id => gff_id)
              end #parentless features end
            when "data"
              ##each line is a data feature
              File.open(track["file"], "r").each do |line|
                start, stop, value = line.split(/\t/)
                features << MiniFeature.new(:start => start.to_i, :end => stop.to_i, :segment_height => value.to_f)
              end
          end #data end
          features.each { |f| svg_track.add(f) }
        end #track end
        p.write(args[:outfile])
      end

      #Parses a GFF file into an Array of Bio::GFF::GFF3::Record[http://bioruby.org/rdoc/Bio/GFF/GFF3/Record.html] objects
      #* gff_file - a GFF-formatted file
      #* returns - an Array of Bio::GFF::GFF3::Record[http://bioruby.org/rdoc/Bio/GFF/GFF3/Record.html] objects
      def self.parse_gff(gff_file)
        require 'bio'
        a = []
        File.open(gff_file).each do |line|
          next if line =~ /^#/
          a << Bio::GFF::GFF3::Record.new(line)
        end
        a
      end

      #adds a new Bio::Graphics::Track object to the current Bio::Graphics::Page object
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
      #=== returns
      # a new Bio::Graphics::Track object
      def add_track(args)
        #sort out the colour/gradient options
        [:fill_color, :exon_fill_color, :utr_fill_color].each do |colour_tag|
          if Glyph.gradients.include?(args[colour_tag])
            @svg.gradient(Glyph.gradient(args[colour_tag]))
            args[colour_tag] = "url(##{args[colour_tag]})"
          elsif args[colour_tag].instance_of?(Hash)
            @svg.gradient(args[colour_tag])
            args[colour_tag] = "url(##{args[colour_tag][:id]})"
          end
        end
        @tracks << Track.new(args)
        return @tracks.last
      end

      #Calculates the Page scale-start and scale-stop position and the nucleotides per pixel for the current Page
      def get_limits
        @tracks.each do |track|
          lowest = track.features.sort { |x, y| x.start <=> y.start }.first.start
          highest = track.features.sort { |x, y| y.end <=> x.end }.first.end
          @scale_start = lowest if lowest < @scale_start
          @scale_stop = highest if highest > @scale_stop
          @nt_per_px_x = (@scale_stop - @scale_start).to_f / @width.to_f
        end
        begin
          old_nt_per_px_x = @nt_per_px_x
          @tracks.each do |track|
            highest = track.features.map { |feat|
              compute_boundaries(feat)[1]
            }.max
            if highest > @scale_stop
              @scale_stop = highest
              @nt_per_px_x = (@scale_stop - @scale_start).to_f / @width.to_f
            end
          end
        end while (@nt_per_px_x - old_nt_per_px_x).abs > 1
      end

      def compute_boundaries(feature)
        feat_end = feature.end
        feat_end += (8 * @nt_per_px_x * feature.id.to_s.length).to_i if feature.id and @nt_per_px_x
        [feature.start, feat_end]
      end


      #Adds scale bar to the list of objects to be rendered in the final
      def draw_scale
        Glyph.scale(:start => @scale_start,
                    :stop => @scale_stop,
                    :number_of_intervals => @num_intervals, :page_width => @width).each { |g| @svg.add_primitive(g) }
      end
      
      #Adds the Bio::Graphics::Primitive objects to the SVGEE object
      #* +args+ - an Array of Bio::Graphics::Primitive object
      def draw_label(args)
        Glyph.label(:text => args[:text],
                    :x => args[:x],
                    :y => args[:y]).each { |g| @svg.add_primitive(g) }
      end
      

      def draw_generic(args) #remember presentation info comes from track@args when the track is defined
        Glyph.generic(args).each { |g| @svg.add_primitive(g) }
      end

      def draw_directed(args)
        Glyph.directed(args).each { |g| @svg.add_primitive(g) }
      end
 
      def draw_circle(args)
        Glyph.circle(args).each { |g| @svg.add_primitive(g) }
      end

      def draw_transcript(args)
        Glyph.transcript(args).each { |g| @svg.add_primitive(g) }
      end

      def draw_histogram(args)
        Glyph.generic(args).each { |g| @svg.add_primitive(g) }
      end

      def draw_up_triangle(args)
        Glyph.up_triangle(args).each { |g| @svg.add_primitive(g) }
      end

      def draw_down_triangle(args)
        Glyph.down_triangle(args).each { |g| @svg.add_primitive(g) }
      end

      def draw_span(args)
        Glyph.span(args).each { |g| @svg.add_primitive(g) }
      end

      #Takes a Bio::Graphics::Track object and does the work to draw features
      #
      #It examines the the type of track and calculates the required parameters
      #* +args+ - an Array of Bio::Graphics::Track object
      def draw_features(track)
        if [:histogram, "histogram"].include?(track.glyph) #do different stuff for data tracks...

          y = @track_top + (track.track_height)
          max = track.max_y ? track.max_y : track.features.sort { |a, b| a.segment_height <=> b.segment_height }.last.segment_height
          min = 0
          if track.label
            draw_label(:text => track.name, :y => @track_top += 30, :x => 3)
          end
          draw_label(:text => max, :x => to_px(@scale_stop - @scale_start) + 5, :y => @track_top + 5)
          draw_label(:text => min, :x => to_px(@scale_stop - @scale_start) + 5, :y => @track_top + track.track_height + 5)
          data_interval = max - min
          data_per_px = track.track_height.to_f / data_interval.to_f
          track.features.each do |f|
            x = to_px(f.start - @scale_start)
            width = to_px((f.end - @scale_start) - (f.start - @scale_start))
            height = f.segment_height.to_f * data_per_px
            y = @track_top + track.track_height - height + 5
            #$stderr.puts f.segment_height, data_per_px, data_interval, max, min, "------"
            self.send("draw_#{track.glyph}", {:x => x,
                                              :y => y,
                                              :width => width,
                                              :height => height}.merge!(track.args))
          end
          @track_top += (track.track_height) + 20
        else ##following stuff for the features
          if track.label
            draw_label(:text => track.name, :y => @track_top += 30, :x => 3)
          end
          track.get_rows(self) ##work out how many rows and which features belong in each row...
          track.features.each_with_index do |f, index|
            x = to_px(f.start - @scale_start) #bottom left of feature
            all_sub_blocks = []

            #convert the exon and utr start stops to px start stops and px widths
            exons = []
            if f.exons
              f.exons.each_slice(2).each do |exon|
                all_sub_blocks << exon
                next if exon.nil?
                exons << [to_px(exon[0] - @scale_start), to_px((exon[1] - @scale_start) - (exon[0] - @scale_start))]
              end
            end
            f.exons = exons

            utrs = []
            if f.utrs
              f.utrs.each_slice(2).each do |utr|
                all_sub_blocks << utr
                next if utr.nil?
                utrs << [to_px(utr[0] - @scale_start), to_px((utr[1] - @scale_start) - (utr[0] - @scale_start))]
              end
            end
            f.utrs = utrs

            #if there are any intron like gaps.. get where they would be
            if not all_sub_blocks.empty?
              all_sub_blocks = all_sub_blocks.sort { |a, b| a.first <=> b.first }
              all_sub_blocks.each_index do |i|
                next if i + 1 == all_sub_blocks.length or all_sub_blocks[i].last >= all_sub_blocks[i + 1].first #skip if there is no gap
                f.block_gaps << [to_px(all_sub_blocks[i].last - @scale_start), to_px((all_sub_blocks[i + 1].first - @scale_start) - (all_sub_blocks[i].last - @scale_start))]
              end
            end

            width = to_px((f.end - @scale_start) - (f.start - @scale_start))
            if track.min_width and width < track.min_width
              width = track.min_width
            end
            y = @track_top + (track.feature_rows[index] * 2 * track.feature_height)

            self.send("draw_#{track.glyph}", {:x => x,
                                              :y => y,
                                              :width => width,
                                              :strand => f.strand,
                                              :exons => f.exons,
                                              :utrs => f.utrs,
                                              :block_gaps => f.block_gaps,
                                              :height => track.feature_height,
                                              :params => f.params
            }.merge!(track.args))

            if f.id
              draw_label(:y => y, :x => x + width +2, :text => f.id)
            end
          end
          @track_top += (track.feature_height * track.number_rows * 2) + 20
        end

        @height = @track_top + 100 #fudge...
        @svg.update_height(@height)
                               #@svg.update_width(@width + 200)

      end
      #Calculates the pixel value for a given number
      def to_px(num)
        (num.to_f / @nt_per_px_x.to_f)
      end

      #generates the SVG text
      def get_markup
        get_limits
        draw_scale
        @tracks.each do |track|
          draw_features(track)
        end
        @svg.draw
      end
      #Prints the svg text to STDOUT
      def draw
        puts get_markup
      end

      #Writes the SVG text to a file
      def write(file)
        File.open(file, 'w').write(get_markup)
      end
    end
  end
end
