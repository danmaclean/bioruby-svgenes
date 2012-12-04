#!/usr/bin/env ruby
#
#  untitled
#
#  Created by Dan MacLean (TSL) on 2012-09-28.
#  Copyright (c)  . All rights reserved.
###################################################
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bio-svgenes'

p = Bio::Graphics::Page.new(:width => 800, 
             :height => 200, 
             :number_of_intervals => 10)
             
             
generic_track = p.add_track(:glyph => :generic, 
                            :name => 'generic_features', 
                            :label => true  )
                            
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '+', :id => "MyFeature")
generic_track.add(feature1) 
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)



generic_track = p.add_track(:glyph => :generic, :name => 'more_generic_features', :label => true, :fill_color => 'green' )

feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212)
generic_track.add(feature1)
feature1 = Bio::Graphics::MiniFeature.new(:start => 3935, :end => 4212)
generic_track.add(feature1)
feature1 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 15000)
generic_track.add(feature1)


generic_track = p.add_track(:glyph => :generic, 
                            :name => 'yet_more_generic_features', 
                            :label => true, 
                            :fill_color => 'yellow', 
                            :stroke_width => '1', 
                            :x_round => 10 )
                            
                            
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212)
generic_track.add(feature1)
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature1 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 15000)
generic_track.add(feature1)

directed_track = p.add_track(:glyph => :directed, 
                             :name => 'directed_features gradient', 
                             :label => true,
                             :fill_color => :red_white_h  )
                             
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234, :strand => '+')
directed_track.add(feature2)
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '-')
directed_track.add(feature1)


generic_track = p.add_track(:glyph => :generic, 
                            :name => 'generic_features', 
                            :label => true  )
                            
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '+')
generic_track.add(feature1) # will be Bio::Feature object
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 2030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)



generic_track = p.add_track(:glyph => :generic, 
                            :name => 'more_generic_features', 
                            :label => true, 
                            :fill_color => 'green' )

feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212)
generic_track.add(feature1)
feature1 = Bio::Graphics::MiniFeature.new(:start => 3935, :end => 4212)
generic_track.add(feature1)
feature1 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 15000)
generic_track.add(feature1)


generic_track = p.add_track(:glyph => :generic, 
                            :name => 'yet_more_generic_features', 
                            :label => true, 
                            :fill_color => 'yellow', 
                            :stroke_width => '1', 
                            :x_round => 1 )
                            
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212)
generic_track.add(feature1) # will be Bio::Feature object
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature1 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 15000)
generic_track.add(feature1)

directed_track = p.add_track(:glyph => :directed, 
                             :name => 'directed_features', 
                             :label => true  )
                             
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234, :strand => '+')
directed_track.add(feature2)
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '-')
directed_track.add(feature1)


generic_track = p.add_track(:glyph => :generic, 
                            :name => 'generic_features', 
                            :label => true  )
                            
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '+')
generic_track.add(feature1) # will be Bio::Feature object
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)



generic_track = p.add_track(:glyph => :generic, 
                            :name => 'more_generic_features', 
                            :label => true, 
                            :fill_color => 'green' )

feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212)
generic_track.add(feature1)
feature1 = Bio::Graphics::MiniFeature.new(:start => 3935, :end => 4212)
generic_track.add(feature1)
feature1 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 15000)
generic_track.add(feature1)


generic_track = p.add_track(:glyph => :generic, 
                            :name => 'yet_more_generic_features', 
                            :label => true, 
                            :fill_color => :yellow_white_radial, 
                            :stroke_width => '1', 
                            :x_round => 4 )
                            
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212)
generic_track.add(feature1) # will be Bio::Feature object
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature2 = Bio::Graphics::MiniFeature.new(:start => 12000, :end => 12030)
generic_track.add(feature2)
feature1 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 15000)
generic_track.add(feature1)

directed_track = p.add_track(:glyph => :directed, 
                             :name => 'directed_features fat ones', 
                             :label => true,  
                             :feature_height => 32,
                             :fill_color => :red_white_h)
                             
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234, :strand => '+' )
directed_track.add(feature2)
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '-')
directed_track.add(feature1)
feature2 = Bio::Graphics::MiniFeature.new(:start => 467, :end => 1234, :strand => '+')
directed_track.add(feature2)
feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '-')
directed_track.add(feature1)

transcript_track = p.add_track(:glyph => :transcript, 
                               :name => 'transcripts (grouped models)', 
                               :label => true, 
                               :exon_fill_color => 'green', 
                               :utr_fill_color => {:type => :radial, :id => :custom, :cx => 5, :cy => 5, :r => 50, :fx => 50, :fy => 50, :stops => [ {:offset => 0, :color => 'rgb(255,255,255)', :opacity => 0},  {:offset => 100, :color => 'rgb(0,127,200)', :opacity => 1},]}, 
                               :line_color => 'black', 
                               :feature_height => 20 )

feature3 = Bio::Graphics::MiniFeature.new(:start => 923, 
                           :end => 2345, 
                           :strand => '-', 
                           :exons => [1000,1200,1800,2000], 
                           :utrs => [923,1000,2000,2345])
transcript_track.add(feature3)

feature1 = Bio::Graphics::MiniFeature.new(:start => 467, 
                           :end => 15000, 
                           :exons => [1500,2500, 3000,7000, 9000,12000], 
                           :utrs => [467, 1000, 13500,14000, 14400, 14900],
                           :id => 'MyTranscript')
transcript_track.add(feature1)


transcript_track = p.add_track(:glyph => :transcript, 
                               :name => 'transcripts (grouped models)', 
                               :label => true, 
                               :exon_fill_color => :green_white_h, 
                               :utr_fill_color => :blue_white_h, 
                               :line_color => 'black', 
                               :gap_marker => 'angled', 
                               :feature_height => 20 )
                               
feature3 = Bio::Graphics::MiniFeature.new(:start => 923, 
                           :end => 2345, 
                           :strand => '-', 
                           :exons => [1000,1200,1800,2000], 
                           :utrs => [923,1000,2000,2345])
transcript_track.add(feature3)

feature1 = Bio::Graphics::MiniFeature.new(:start => 467, 
                           :end => 15000, 
                           :exons => [1500,2500, 3000,7000, 9000,12000], 
                           :utrs => [467, 1000, 13500,14000])
transcript_track.add(feature1)

data_track = p.add_track(:glyph => :histogram,  #might also be :density or heatmap  ##page doesn't know how to deal with individual file types, rather page object takes a list of values (e.g bar heights) from pre-processed data source and renders those
                        :stroke_color => 'black',
                        :fill_color => 'gold',
                        :track_height => 150,
                        :name => 'data track', 
                        :label => true, 
                        :stroke_width => '1', 
                        :x_round => 1,
                        :y_round => 1
                        
                        )
##generate a load of data, each data point becomes a feature...                         
data = (400..25000).step(1000) do |start|
  data_feature = Bio::Graphics::MiniFeature.new(:start => start,
                       :end => start + 999,
                       :segment_height => rand(30)
                     )
  data_track.add(data_feature)
  
end


data_track1 = p.add_track(:glyph => :histogram,  #might also be :density or heatmap  ##page doesn't know how to deal with individual file types, rather page object takes a list of values (e.g bar heights) from pre-processed data source and renders those
                        :stroke_color => 'black',
                        :fill_color => :red_white_radial,
                        :track_height => 150,
                        :name => 'data track', 
                        :label => true, 
                        :stroke_width => '1', 
                        :x_round => 1,
                        :y_round => 1
                        
                        )
##generate a load of data, each data point becomes a feature...                         
data = (400..25000).step(200) do |start|
  data_feature = Bio::Graphics::MiniFeature.new(:start => start,
                       :end => start + 200,
                       :segment_height => rand(30)
                     )
  data_track1.add(data_feature)
  
end


p.draw