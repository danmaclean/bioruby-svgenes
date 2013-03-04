$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path('.')
require 'rubygems'
#require 'json'
require 'bio-svgenes'
require 'test/unit'
require 'helper'
require 'pp'

module Bio
  class Graphics
    class Page
      attr_accessor :scale_start, :scale_stop, :nt_per_px_x, :width, :tracks, :track_top, :height

    end
  end
end

class TestPage < Test::Unit::TestCase

  def setup

    @page = Bio::Graphics::Page.new(:width => 800,:height => 110, :number_of_intervals => 10)

  end


  def test_class
    assert_equal(Bio::Graphics::Page, @page.class, "From TestPage, test_class. @page should be a Bio::Graphics::Page but a #{@page.class} is found")
  end

  def test_get_limits
    #pp @page
    @generic_track = @page.add_track(:glyph => :generic, :name => 'generic_features', :label => true, :track_height => 10)
    @feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '+', :id => "MyFeature")
    @feature2 = Bio::Graphics::MiniFeature.new(:start => 3000, :end => 3500, :strand => '+', :id => "MyFeature2")
    @generic_track.add(@feature1)
    @generic_track.add(@feature2)
    @page.get_limits

    assert_equal(923, @page.scale_start, "From TestPage, test_get_limits. scale_start is wrong value (#{@page.scale_start})")
    assert_equal(3500, @page.scale_stop, "From TestPage, test_get_limits. scale_stop is wrong value (#{@page.scale_stop})")
    assert_equal(800, @page.width, "From TestPage, test_get_limits. width is wrong value (#{@page.width})")
    #@nt_per_px_x = (@scale_stop - @scale_start).to_f / @width.to_f
    #which is equal to (3500-923)/800 = 3.22125
    assert_equal(3.22125, @page.nt_per_px_x, "From TestPage, test_get_limits. nt_per_px_x is wrong value (#{@page.nt_per_px_x})")

  end

  def test_add_track

    @generic_track2 = @page.add_track(:glyph => :generic, :name => 'generic_features2', :label => true, :track_height => 10)
    #add_track returns the last track added (@generic_track2 in this case)
    #test that the last track in the tracks array is a Track
    assert_equal(Bio::Graphics::Track,  @page.tracks.last.class, "From TestPage, test_add_track. Looking for a Bio::Graphics::Track but encountered a (#{@page.tracks.last.class})" )
    #check that the current name of the new track and the last track returned from the tracks array are the same
    assert_equal(@generic_track2.name,  @page.tracks.last.name, "From TestPage, test_add_track. The feature names do not match (#{@generic_track2.name} and #{@page.tracks.last.name})")

  end

  def test_draw_features
    #get the track top before drawing the features, as we want to calculate it manually later
    tt = @page.track_top

    #create a new track, features and add the features to the track. The features are overlapping so there will be two rows
    @generic_track = @page.add_track(:glyph => :generic, :name => 'generic_features', :label => true, :track_height => 10)
    @feature1 = Bio::Graphics::MiniFeature.new(:start => 923, :end => 2212, :strand => '+', :id => "MyFeature")
    @feature2 = Bio::Graphics::MiniFeature.new(:start => 2000, :end => 3500, :strand => '+', :id => "MyFeature2")
    @generic_track.add(@feature1)
    @generic_track.add(@feature2)
    #draw the features which should update @page.track_top
    @page.draw_features(@generic_track)


    #caluclate the track_top (tt) manually (the code in draw_features that does this is provided in comments)
    th = @generic_track.track_height
    fh = @generic_track.feature_height
    nr = @generic_track.number_rows

    #@track_top += (track.track_height) + 20
    tt += th + 20
    #@track_top += (track.feature_height * track.number_rows * 2) + 20
    tt += (fh*nr*2)+20

    assert_equal(tt, @page.track_top, "From TestPage, test_draw_features. track_top is incorrect")
  end

  def test_json
    #create a new page from the json_config.json file
    json_file = ("test/json_config.json")
    out_file = ("test/from_json.svg")
    p = Bio::Graphics::Page.from_json(:json => json_file, :outfile => out_file )
    #test that the outfile exists and has a size > 0
    assert(File.size?('test/from_json.svg') > 0, "From TestJson, method test_file_exists: File doesn't exist, or is empty")
    #delete the temp :outfile
    File.delete('test/from_json.svg')

  end


  def test_parse_gff
    #create a parent and child gff entry both starting at position 900
    gff1 = "ctg123	.	mRNA	900	9200	.	+	.	ID=mRNA00001;Name=EDEN.1"
    gff2 = "ctg123	.	utr	900	1000	.	+	.	ID=utr00001;Parent=mRNA00001"
    #open a temp file and write the gff to it
    temp_file = File.new('temp_gff.gff', 'w')
    temp_file.puts(gff1)
    temp_file.puts(gff2)
    temp_file.close_write

    #open and parse the file
    gff_obj = Bio::Graphics::Page.parse_gff('temp_gff.gff')
    #test to see if it returns an array of length 2 (the number of gff entries that should be in it)
    assert_equal(2, gff_obj.length, "From TestJson, method test_parse_gff: array of gff objects should be of length 2 but is of length #{gff_obj.length}")

    #test to make sure each array object is a GFF3::Record and that it starts at 900
    gff_obj.each do |o|
      assert_equal(Bio::GFF::GFF3::Record, o.class, "From TestJson, method test_parse_gff: array of gff objects should contain only Bio::GFF::GFF3::Record objects, but contains #{o.class} objects")
      assert_equal(900, o.start, "From TestJson, method test_parse_gff: gff object should start at position 900 but starts at #{o.start}")
    end
    #delete the temp file
    File.delete(temp_file.path.to_s)

  end


end