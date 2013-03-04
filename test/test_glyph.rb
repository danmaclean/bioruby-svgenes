$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path('.')
require 'rubygems'
require "test/unit"
require 'helper'
require 'pp'


class TestGlyph < Test::Unit::TestCase

  def setup
    @circle_glyph = Bio::Graphics::Glyph.circle({})
    @generic_glyph = Bio::Graphics::Glyph.generic({})
    @label_glyph = Bio::Graphics::Glyph.label({})
    @directed_glyph = Bio::Graphics::Glyph.directed(:x => 0, :y => 0, :width => 10)
    @scale_glyph = Bio::Graphics::Glyph.scale(:start => 2, :stop => 100, :width => 10, :number_of_intervals => 5)
    @down_triangle_glyph =Bio::Graphics::Glyph.down_triangle(:x => 0, :y => 0, :width => 10)
    @up_triangle_glyph = Bio::Graphics::Glyph.up_triangle(:x => 0, :y => 0, :width => 10)
    @span_glyph = Bio::Graphics::Glyph.span(:x => 0, :y => 0, :width => 10)
    @glyphs = [@circle_glyph, @generic_glyph, @directed_glyph, @scale_glyph, @label_glyph, @down_triangle_glyph, @up_triangle_glyph, @span_glyph]
  end


  def test_glyphs
    @glyphs.each do |g|
      assert(g.length > 0)
      g.each do |o|
        assert_equal(Bio::Graphics::Primitive, o.class, "not all objects in array are Bio::Graphics::Primitive. #{o.class} encountered")
      end
    end

  end
end