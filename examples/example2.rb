#!/usr/bin/env ruby
#an example that loads data and renders different features from a gff
#will select any features in ['gene', 'mRNA','cDNA_match', 'microarray_probe', 'insertion','deletion','substitution','transposable_element_insertion_site'] and
#render these

require 'bio-svgenes'



page = Bio::Graphics::Page.new(
      :width => 800, 
      :height => 200, 
      :number_of_intervals => 10,
      :background_color => "#F8F8F8"
      )


def new_gene_track_on page
  page.add_track(
    :glyph => :directed,
    :height => 15,
    :name => "Genes", 
    :label => true, 
    :stroke => :green,
    :fill_color => :green_white_h
  )
end

def new_mRNA_track_on page
  page.add_track(
    :glyph => :transcript,
    :name => "mRNA", 
    :height => 15,    
    :label => true,
    :exon_stroke => :black,
    :exon_stroke_width => 1, 
    :exon_fill_color => :blue,
    :utr_fill_color => :purple,
    :utr_stroke => :black,
    :utr_stroke_width => 1,
    :gap_marker => 'angled',
    :line_color => :black,
    :style => "fill-opacity:0.4;"
  )
end

def new_te_insertion_site_track_on page
  page.add_track(
    :glyph => :circle,
    :name => "TE Insertions", 
    :label => true, 
    :fill_color => :blue,
    :radius => 3,
    :stroke => :blue,
    :stroke_width => 0.5,
    :style => "fill-opacity:0.4;"
  )
end

def new_cDNA_match_track_on page
  page.add_track(
    :glyph => :directed,
    :name => "cDNA matches", 
    :label => true, 
    :stroke => :red,
    :height => 15,
    :fill_color => :red_white_h
  )
end


def new_microarray_probe_track_on page
  page.add_track(
    :glyph => :generic,
    :height => 15,
    :name => "Microarray probes", 
    :label => true, 
    :fill_color => 'green',
    :stroke_width => 0,
    :style => "fill-opacity:1.0;"
  )
end

def new_insertion_track_on page
  page.add_track(
    :glyph => :down_triangle,
    :name => "Insertions", 
    :label => true, 
    :min_width => 6,
    :fill_color => :red,
    :stroke_width => 0,
    :style => "fill-opacity:0.4;"
  )
end


def new_deletion_track_on page
  page.add_track(
    :glyph => :up_triangle,
    :name => "Deletions", 
    :label => true, 
    :fill_color => :green,
    :min_width => 6,
    :stroke_width => 0,
    :style => "fill-opacity:0.4;"
  )
end

def new_marker_track_on page
  page.add_track(
    :glyph => :span,
    :height => 20,
    :name => "Markers", 
    :label => true, 
    :stroke => :orange,
    :stroke_width => 15
  )
end


all_features = Bio::Graphics::Page.parse_gff( ARGV[0] )

['gene', 'mRNA','cDNA_match', 'microarray_probe', 'insertion','deletion','substitution','transposable_element_insertion_site'].each do |feature_type|

  puts "rendering #{feature_type}"
    case feature_type
    when 'gene'
      track = new_gene_track_on page
      all_features.select {|f| f.feature == feature_type }.each do |feature|
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :end => feature.end,
                                        :strand => feature.strand,
                                        :id => feature.attributes.select {|a| a.first == 'Name'}.first.last
                                        )
       track.add(mf)
      end 
    when 'cDNA_match'
      track = new_cDNA_match_track_on page
      all_features.select {|f| f.feature == feature_type }.each do |feature|
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :strand => feature.strand,
                                        :end => feature.end      
        )
        track.add(mf)
      end  
    when 'mRNA'
      track = new_mRNA_track_on page
      five_utrs = all_features.select {|x| x.feature_type == 'five_prime_UTR'} 
      three_utrs = all_features.select {|z| z.feature_type == 'three_prime_UTR'}
      all_exons = all_features.select {|z| z.feature_type == 'CDS'}
      require 'pp'
      pp all_exons
      all_features.select {|f| f.feature == feature_type }.each do |feature|

        feature_id = feature.attributes.select {|y| y.first == "ID"}.first.last
        five_utr = five_utrs.select {|x|  x.attributes_to_hash["Parent"] == feature_id  }.first
        three_utr = three_utrs.select {|z| z.attributes_to_hash["Parent"] == feature_id }.first
        utrs = []
        if not five_utr.nil? and not three_utr.nil?
          utrs = [five_utr.start,five_utr.end, three_utr.start,three_utr.end]
                  require 'pp'
          utrs.sort!
          
        end
        exons = []
        exons = all_exons.select {|x|  x.attributes_to_hash["Parent"] == feature_id  }
        exons = exons.collect {|x| [x.start, x.end] }.flatten
        #if not exons.empty?
        #  exons = exons.sort
        #end
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :end => feature.end,
                                        :utrs => utrs,
                                        :exons => exons,
                                        :strand => feature.strand      
        )
        track.add(mf)
      end
    when 'microarray_probe'
      track = new_microarray_probe_track_on page
            all_features.select {|f| f.feature == feature_type }.each do |feature|
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :strand => feature.strand,
                                        :end => feature.end      
        )
        track.add(mf)
      end
    when 'transposable_element_insertion_site'
      track = new_te_insertion_site_track_on page
      all_features.select {|f| f.feature == feature_type }.each do |feature|
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :strand => feature.strand,
                                        :end => feature.end      
        )
        track.add(mf)
      end
    when 'insertion'
      track = new_insertion_track_on page
      all_features.select {|f| f.feature == feature_type }.each do |feature|
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :end => feature.end      
        )
        track.add(mf)
      end
     when 'deletion'
      track = new_deletion_track_on page
      all_features.select {|f| f.feature == feature_type }.each do |feature|
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :end => feature.end      
        )
        track.add(mf)
      end
     when 'marker'
      track = new_marker_track_on page
      all_features.select {|f| f.feature == feature_type }.each do |feature|
        mf = Bio::Graphics::MiniFeature.new(
                                        :start => feature.start, 
                                        :end => feature.end      
        )
        track.add(mf)
      end
    end
    
    
end

data_track1 = page.add_track(:glyph => :histogram,  #might also be :density or heatmap  ##page doesn't know how to deal with individual file types, rather page object takes a list of values (e.g bar heights) from pre-processed data source and renders those
                        :stroke_color => 'black',
                        :fill_color => :blue,
                        :track_height => 75,
                        :name => 'Simulated NGS coverage (transformed sine function)', 
                        :label => true, 
                        :stroke_width => 0,
                        :style => "fill-opacity:0.6;"
                        
                        )
##generate a load of data, each data point becomes a feature...                         
data = (19597235..19637234).step(10) do |start|
#data = (19616011..19618459).step(1) do |start|
  height = Math::sin(start)
  height = height * -1 if height < 0
  height = Math::log(height)
  height = height * -1 if height < 0
  data_feature = Bio::Graphics::MiniFeature.new(:start => start,
                       :end => start + 30,
                       :segment_height => height * 10
                     )
  data_track1.add(data_feature)
  
end

data_track2 = page.add_track(:glyph => :histogram,  #might also be :density or heatmap  ##page doesn't know how to deal with individual file types, rather page object takes a list of values (e.g bar heights) from pre-processed data source and renders those
                        :stroke_color => 'black',
                        :fill_color => :yellow,
                        :track_height => 75,
                        :name => 'Random bar height', 
                        :label => true, 
                        :stroke_width => 1,
                        :style => "fill-opacity:0.4;"
                        
                        )
##generate a load of data, each data point becomes a feature...                         
data = (19597235..19637234).step(200) do |start|
#data = (19616011..19618459).step(30) do |start|
  data_feature = Bio::Graphics::MiniFeature.new(:start => start,
                       :end => start + 200,
                       :segment_height => rand(30)
                     )
  data_track2.add(data_feature)
  
end

page.write( "out.svg" )