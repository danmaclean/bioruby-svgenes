$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path('.')
require 'rubygems'
require 'helper'
require 'bio-svgenes'
require 'pp'


class TestTrack < Test::Unit::TestCase
  def setup

    @track = Bio::Graphics::Track.new(:glyph => :generic,
                                       :name => 'generic_features',
                                       :label => true, :feature_height => 12)
    @feature1 = Bio::Graphics::MiniFeature.new(:start => 100, :end => 200, :strand => '+', :id => "MyFeature1")
    @feature2 = Bio::Graphics::MiniFeature.new(:start => 190, :end => 250, :strand => '+', :id => "MyFeature2")
    @feature3 = Bio::Graphics::MiniFeature.new(:start => 300, :end => 350, :strand => '+', :id => "MyFeature3")

  end


  def test_track_class
    assert_equal(Bio::Graphics::Track, @track.class)

    assert_equal(:generic, @track.glyph)
    assert_equal('generic_features', @track.name)
    assert_equal(true, @track.label)
    assert_equal(nil, @track.track_height)

  end

  def test_overlaps
    assert(@track.overlaps(@feature1, @feature2))
    assert_equal(false, @track.overlaps(@feature2, @feature3))
  end

  def test_get_rows_and_add
    @track.add(@feature1)
    assert_not_equal(2, @track.features.length)
    assert_equal(1, @track.features.length)
    @track.add(@feature2)
    assert_equal(2, @track.features.length)
    @track.add(@feature3)
    assert_equal(3, @track.features.length)

    #hasn't been called yet, so should be nil
    assert_nil(@track.number_rows)
    #call method - @feature1 and @feature2 overlap, but @feature3 doesn't so there should be two rows
    @track.get_rows
    assert_equal(2, @track.number_rows)

  end
end