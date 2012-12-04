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
require 'pp'
p = Bio::Graphics::Page.new(:width => 800, 
             :height => 200, 
             :number_of_intervals => 10)
             
             


transcript_track_last = p.add_track(:glyph => :transcript, 
                               :name => 'transcripts (grouped models)', 
                               :label => true, 
                               :exon_fill_color => 'green', 
                               :utr_fill_color => {:type => :radial, :id => :custom, :cx => 5, :cy => 5, :r => 50, :fx => 50, :fy => 50, :stops => [ {:offset => 0, :color => 'rgb(255,255,255)', :opacity => 0},  {:offset => 100, :color => 'rgb(0,127,200)', :opacity => 1},]}, 
                               :line_color => 'black', 
                               :feature_height => 20 )


feature3 = Bio::Graphics::MiniFeature.new(:start => 3631, 
                           :end => 5899, 
                           :strand => '+', 
                           :exons => [4486,4605,4706,5095,5174,5326], 
                           :utrs => [3631,4485,5631,5899])
                           #:utrs => [3631,4276,5439,5899])
transcript_track_last.add(feature3)


p.draw

#pp p