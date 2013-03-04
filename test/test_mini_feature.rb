$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
$: << File.expand_path('.')
require 'rubygems'
require 'helper'
require 'pp'


class TestMiniFeature < Test::Unit::TestCase
  
  def setup
    @mini1 = Bio::Graphics::MiniFeature.new(:start=>3631, :end=>5899, :strand=>'+', :exons=>[4000, 4500, 4700, 5000], :utrs=>[3631, 3650], :segment_height=>5, :id=>"AT1G01010")
    @mini2 = Bio::Graphics::MiniFeature.new(:start=>5928, :end=>8737, :strand=>'-', :exons=>[7000, 7150, 7200, 8000], :utrs=>[5928, 6500], :segment_height=>5, :id=>"AT1G01020")
    
    # :start, :end, :strand, :exons, :utrs, :block_gaps, :segment_height, :id
  end
  
  
  def test_parse
    #no methods in mini_feature, so just testing the accessor
    assert_equal(3631, @mini1.start, "From TestMiniFeature test_parse, @mini1 start site is incorrect (#{@mini1.start})")
    assert_equal(5899, @mini1.end, "From TestMiniFeature test_parse, @mini1 end site is incorrect (#{@mini1.end})")
    assert_equal('+', @mini1.strand, "From TestMiniFeature test_parse, @mini1 strand is incorrect (#{@mini1.strand})")
    assert_equal([4000, 4500, 4700, 5000], @mini1.exons, "From TestMiniFeature test_parse, @mini1 exons are incorrect (#{@mini1.exons})")
    
    assert_equal([3631, 3650], @mini1.utrs, "From TestMiniFeature test_parse, @mini1 utrs are incorrect (#{@mini1.utrs})")
    assert_equal(5, @mini1.segment_height, "From TestMiniFeature test_parse, @mini1 segment_height is incorrect")
    assert_equal("AT1G01010", @mini1.id, "From TestMiniFeature test_parse, @mini1 id is incorrect (#{@mini1.id})")
    
    assert_equal(5928, @mini2.start, "From TestMiniFeature test_parse, @mini2 start site is incorrect (#{@mini2.start})")
    assert_equal(8737, @mini2.end, "From TestMiniFeature test_parse, @mini2 end site is incorrect (#{@mini2.end})")
    assert_equal('-', @mini2.strand, "From TestMiniFeature test_parse, @mini2 strand is incorrect (#{@mini2.strand})")
    assert_equal([7000, 7150, 7200, 8000], @mini2.exons, "From TestMiniFeature test_parse, @mini2 exons are incorrect (#{@mini2.exons})")
    assert_equal([5928, 6500],@mini2.utrs, "From TestMiniFeature test_parse, @mini2 utrs are incorrect (#{@mini2.utrs})")
    assert_equal(5, @mini2.segment_height, "From TestMiniFeature test_parse, @mini2 segment_height is incorrect")
    assert_equal("AT1G01020", @mini2.id, "From TestMiniFeature test_parse, @mini2 id is incorrect (#{@mini2.id})")
  end
end