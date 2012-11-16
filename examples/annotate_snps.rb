#!/usr/bin/env ruby
#
#  untitled
#
#  Created by Dan MacLean (TSL) on 2012-10-30.
#  Copyright (c)  . All rights reserved.
###################################################

require 'ostruct'

class DanGFF
  attr_accessor :seqname, :source, :attributes, :start, :end, :strand, :feature, :phase, :score
  
  def initialize(line)
    @seqname, @source, @feature, @start, @end, @score, @strand, @phase, @attributes = line.split(/\t/)
    @start = @start.to_i
    @end = @end.to_i 
  end

  def parent
    self.attributes =~ /Parent=(.*?);/
    $1
  end
  
  def overlaps?(other)
    if (self.seqname == other.seqname and self.start >= other.start and self.start <= other.end)
      return true
    elsif (self.seqname == other.seqname and self.end >= other.start and self.end <= other.end)
      return true
    end
  end
  
  def contains?(other)
    if self.seqname == other.seqname and self.start <= other.start and self.end >= other.end
      return true
    else
      return false
    end
  end
  
end
features_file = ARGV.shift
bam_file = ARGV.shift
bgi_snp_file = ARGV.shift
#rest = data dump files from R

#get SNP list (position, methodd)
ARGV.each do |file|
  snps = []
  file =~ /(.*)_r_dump.csv/
  id = $1
  File.open(file,"r").each do |line|
      next if line=~ /Method/
      snp = OpenStruct.new
      snp.index, snp.pos, snp.method =line.chomp.split(/,/)
      snp.index = snp.index.to_i
      snp.pos =  snp.pos.to_i
      snp.seqname = id
      snp.start = snp.pos
      snp.end = snp.pos
      snps << snp
  end
  features = []
  File.open(features_file, "r").each do |line|
    feature = DanGFF.new(line) 
    features << feature if feature.seqname == id and feature.feature == "mRNA"
  end

  features.each do |f|
    snps.each do |snp|
      if feature.contains(snp)
        snp_info = case snp.method
        when "BGI"
          get_snp_from_bgi(snp)
        when "PileUp"
          get_snp_from_pileup(snp)
        when "VCF"
          get_snp_from_vcf(snp)
        end
        print snp_out(snp,snp_info)
      end
    end
  end
  
end

