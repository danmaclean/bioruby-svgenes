$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path('.')
require 'rubygems'
require 'helper'
require 'bio-svgenes'
require 'test/unit'
require 'pp'

module Bio
  class Graphics
    class SVGEE
      attr_accessor :width, :height, :style

    end
  end
end

class TestSvgee < Test::Unit::TestCase
  def setup

    @svg = Bio::Graphics::SVGEE.new({})

  end


  def test_svg_class
    assert_equal(Bio::Graphics::SVGEE, @svg.class)
  end


  def test_svg_methods

    #test to see if the svg instance is empty, other than those default variables
    assert_equal([], @svg.primitives, "From Class:TestSvgee,  method:test_svg_methods, @svg.primitives should be empty")
    assert_equal("100%", @svg.height, "From Class:TestSvgee,  method:test_svg_methods, @svg.height should be 100%")
    assert_equal("100%", @svg.width, "From Class:TestSvgee,  method:test_svg_methods, @svg.width should be 100%")
    assert_equal(nil, @svg.style, "From Class:TestSvgee,  method:test_svg_methods, @svg.style should be nil")

    #create a circle
    circ = @svg.circle(:x_center => 40, :y_center => 40, :radius => 20, :fill_color => "url(#grad1)")

    #test to see if there is one and only one entry into the primitives array
    assert_equal(1, @svg.primitives.length, "From Class:TestSvgee,  method:test_svg_methods, Added a circle. @svg.primitives should be one")
    #check that the primitive type is a :circle
    assert_equal(:circle, circ.primitive, "From Class:TestSvgee,  method:test_svg_methods, @svg.primitive does not return a :circle")


    rect = @svg.rectangle(:x => 125, :y => 125, :width => 100, :height => 50, :fill_color => 'red', :stroke => 'black', :stroke_width => 2, :style => "fill-opacity:0.1;stroke-opacity:0.9")
    #test to see if there is one and only one entry into the primitives array
    assert_equal(2, @svg.primitives.length, "From Class:TestSvgee,  method:test_svg_methods, Added a rectangle. @svg.primitives should be two")
    #check that the primitive type is a :circle
    assert_equal(:rectangle, rect.primitive, "From Class:TestSvgee,  method:test_svg_methods, @svg.primitive does not return a :rectangle")

    elli = @svg.ellipse(:x_center => 100, :y_center => 190, :x_radius => 40, :y_radius => 20, :fill_color => 'green', :stroke => 'black')
    assert_equal(3, @svg.primitives.length, "From Class:TestSvgee,  method:test_svg_methods, Added an ellipse. @svg.primitives should be three")
    #check that the primitive type is a :circle
    assert_equal(:ellipse, elli.primitive, "From Class:TestSvgee,  method:test_svg_methods, @svg.primitive does not return an :ellipse")


  end

  def test_add_primitive
    #get the current number of primitives
    no_prims = @svg.primitives.length

    @circle_glyph = Bio::Graphics::Glyph.circle({})
    @circle_glyph.each do |g|

      @svg.add_primitive(g)
    end
    assert_equal(no_prims+1, @svg.primitives.length, "From Class:TestSvgee,  method:test_add_primitive, @svg should only have increased by one")
  end
end