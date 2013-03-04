$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path('.')
require 'rubygems'
require 'helper'


class TestPrimitive < Test::Unit::TestCase
  def setup

    @circle_glyph = Bio::Graphics::Glyph.circle({})
    @generic_glyph = Bio::Graphics::Glyph.generic({})
    @label_glyph = Bio::Graphics::Glyph.label({})
    @directed_glyph = Bio::Graphics::Glyph.directed(:x => 0, :y => 0, :width => 10)
    @down_triangle_glyph =Bio::Graphics::Glyph.down_triangle(:x => 0, :y => 0, :width => 10)
    @up_triangle_glyph = Bio::Graphics::Glyph.up_triangle(:x => 0, :y => 0, :width => 10)
    @span_glyph = Bio::Graphics::Glyph.span(:x => 0, :y => 0, :width => 10)


  end


  def test_init
    @circle_glyph.each do |g|
      assert_equal(:circle, g.primitive, "circle_glyph  should be a circle, but is a #{g.class}")
    end
    @generic_glyph.each do |g|
      assert_equal(:rectangle, g.primitive, "generic_glyph  should be a rectangle, but is a #{g.class}")
    end
    @label_glyph.each do |g|
      assert_equal(:text, g.primitive, "label_glyph  should be a text, but is a #{g.class}")
    end
    @directed_glyph.each do |g|
      assert_equal(:polygon, g.primitive, "directed_glyph  should be a polygon, but is a #{g.class}")
    end
    @down_triangle_glyph.each do |g|
      assert_equal(:polygon, g.primitive, "down_triangle_glyph  should be a polygon, but is a #{g.class}")
    end
    @up_triangle_glyph.each do |g|
      assert_equal(:polygon, g.primitive, "up_triangle_glyph  should be a polygon, but is a #{g.class}")
    end
    @span_glyph.each do |g|
      assert_equal(:line, g.primitive, "span_glyph  should be a line, but is a #{g.class}")
    end
  end
end