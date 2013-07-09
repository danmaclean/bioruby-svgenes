module Bio
  class Graphics
    
    ##
    #A Bio::Graphics::MiniFeature object represents a single genomic feature (e.g. a gene, transcript, exon, start codon, etc), it is a lightweight object that 
    #holds the minimum information needed to do the render.
class MiniFeature
  attr_accessor :start, :end, :strand, :exons, :utrs, :block_gaps, :segment_height, :id, :params
  #Creates a new MiniFeature
  #
  #== args
  #* :start = the start position of the feature
  #* :end = the end position of the feature
  #* :strand  = the strand of the feature
  #* :exons = an array of exon positions
  #* :utrs = an array of utrs positions
  #* :block_gaps = an array of regions with nothing to be drawn, e.g. introns
  #* :id = the name for the feature such as the gene name or transcript ID
  #* :segment_height = the height of the current feature
  #
  #== Example usage
  #
  ## mini1 = Bio::Graphics::MiniFeature.new(
  #           :start=>3631, 
  #           :end=>5899, 
  #           :strand=>'+',
  #           :exons=>[4000, 4500, 4700, 5000], 
  #           :utrs=>[3631, 3650], 
  #           :segment_height=>5, 
  #           :id=>"AT1G01010"
  #            )
  #
  #=== MiniFeatures and Tracks
  #MiniFeatures are created and added to Bio::Graphics::Track objects which will take responsibility for positioning and syling them.#
  def initialize(args)
    @start = args[:start]
    @end = args[:end]
    @strand = args[:strand]
    @exons = args[:exons] || []
    @utrs = args[:utrs] || [] #start, ennd, strand, arg[:exons], arg[:utrs]
    @block_gaps = []
    @id = args[:id]
    @segment_height = args[:segment_height]
    @params = args[:params]
  end
end

end
end
