module Bio
  class Graphics
class MiniFeature
  attr_accessor :start, :end, :strand, :exons, :utrs, :block_gaps, :segment_height, :id
  def initialize(args)
    @start = args[:start]
    @end = args[:end]
    @strand = args[:strand]
    @exons = args[:exons] || []
    @utrs = args[:utrs] || [] #start, ennd, strand, arg[:exons], arg[:utrs]
    @block_gaps = []
    @id = args[:id]
    @segment_height = args[:segment_height]
  end
end

end
end