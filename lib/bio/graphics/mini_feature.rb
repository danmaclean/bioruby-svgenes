module Bio
  class Graphics
    ##
    #The MiniFeature class represents any feature (e.g. a gene, transcript, exon, start codon, etc) on a track.
    #
class MiniFeature
  attr_accessor :start, :end, :strand, :exons, :utrs, :block_gaps, :segment_height, :id
  #Creates a new MiniFeature
  #
  #_Arguments_
  #* start = the start position of the feature
  #* end = the end position of the feature
  #* strand  = the strand of the feature
  #* exons = an array of exon positions
  #* utrs = an array of utrs positions
  #* \block_gaps = an array of regions with nothing to be drawn, e.g. introns
  #* id = the name of the feature such as the gene name or transcript ID
  #* \segment_height = the height of the current feature
  #
  #==Example usage
  #
  ##@mini1 = Bio::Graphics::MiniFeature.new(:start=>3631, :end=>5899, :strand=>'+',
  # :exons=>[4000, 4500, 4700, 5000], :utrs=>[3631, 3650], :segment_height=>5, :id=>"AT1G01010")
  #
  #===MiniFeatures and Tracks
  #MiniFeatures are added to Track objects, with overlapping MiniFeatures being placed onto separate rows
  #
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