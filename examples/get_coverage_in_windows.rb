#!/usr/bin/env ruby
#
#  get_coverage_in_windows.rb
#
#  Created by Dan MacLean (TSL) on 2012-10-05.
#  Copyright (c)  . All rights reserved.
###################################################
require 'optparse'
require 'pp'
options = {}
optparse = OptionParser.new do|opts|

  opts.on( '-b', '--bam FILE', ' name of sorrted BAM file' ) do |b|
    options[:bam] = b

  end
  opts.on( '-f', '--reference_file STRING', 'name of the reference sequence fasta file' ) do |f|
    options[:fasta] = f
 
  end
  opts.on( '-c', '--chromosome STRING', 'name of the chromosome / contig in the fasta file' ) do |c|
    options[:chrom] = c

  end
  opts.on( '-s', '--start INT', 'start position)' ) do |s|
    options[:start] = s.to_i

  end
  opts.on( '-e', '--stop INT', 'stop position' ) do |e|
    options[:stop] = e.to_i

  end  
  opts.on( '-w', '--step INT', 'window size to use' ) do |w|
    options[:step] = w.to_i

  end  
  opts.on( '-o', '--bam_opts INT', 'bio-samtools BAM opts' ) do |o|
    options[:bam_opts] = o ||= {:min_mapping_quality => 20, :min_base_quality => 30}

  end 
  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    puts %{Example:  ruby get_coverage_in_windows.rb --bam my_bam.bam --reference_file ref.fasta --chromosome contig1 --start 2000 --stop 3000 --step 100 --bam_opts {:min_mapping_quality => 20, :min_base_quality => 20}}
    exit
  end
end
optparse.parse!

options[:bam_opts] = {:min_mapping_quality => 20}


###Actual script --- 
require 'rubygems'
require 'bio-samtools'
require 'enumerator'
bam = Bio::DB::Sam.new({:bam=>options[:bam], :fasta=>options[:fasta]} )
bam.open

def passes_quality(aln, options)
  if aln.mapq > options[:bam_opts][:min_mapping_quality] && aln.is_mapped
    true
  else 
    false
  end
end

def actually_modify(cigar_arr, bases_to_ignore_at_start)
  result = []
  bases_ditched = 0
  cigar_arr.each do |arr|
    if arr[0] < bases_to_ignore_at_start - bases_ditched
      bases_ditched += arr[0]
    elsif arr[0] + bases_ditched >= bases_to_ignore_at_start && bases_ditched < bases_to_ignore_at_start
      remainder = arr[0] - (bases_to_ignore_at_start - bases_ditched)
      bases_ditched += (bases_to_ignore_at_start - bases_ditched)
      result << [remainder, arr[1]] unless remainder == 0
    elsif bases_ditched >= bases_to_ignore_at_start
      result << [arr[0],arr[1]]
    else
      raise "Shouldn't ever happen. Did though... Panic. Alarums. Etc."
      exit
    end
  end
  result
end

def correct_cigar_for_overlaps(cigar_arr, bases_to_ignore_at_start, bases_to_ignore_at_end)
  #takes the end off the cigar arr if the bases it describes are outside the window
  return cigar_arr if bases_to_ignore_at_start == 0 && bases_to_ignore_at_end == 0
  result = actually_modify(cigar_arr,bases_to_ignore_at_start)
  actually_modify(result.reverse, bases_to_ignore_at_end).reverse
end

(options[:start]..options[:stop]).step(options[:step]) do |start|
  positions = Array.new(options[:step], 0.0)

  bam.fetch(options[:chrom], start, start + options[:step]).each do |aln|
    next unless passes_quality(aln, options)
    
    #update start and end for overhanging clipped bases
    a = aln.cigar.split(/([A-Z])/)
    cigar_arr = a.enum_for(:each_slice, 2).to_a #convert to array of arrays
    cigar_arr.collect!{|a| [a.first.to_i, a.last] } #convert numbers to ints
    if cigar_arr.first.last == "S" or cigar_arr.first.last == "H"
      aln.pos = aln.pos - cigar_arr.first.first
      aln.pos = 1 if aln.pos < 1 #ignore negative overhangs...
    end
    
    if cigar_arr.last.last == "S" or cigar_arr.last.last == "H" 
      aln.calend = aln.calend - cigar_arr.last.first
      aln.calend = 1 if aln.calend < 1
    end
    
    ##remove any padding operations, we're only concerned with alignments relative to the reference, not other reads.. 
    cigar_arr.delete_if {|b| b.last == "P"}
    #need to know whether start outside window ...
    bases_to_ignore_at_start = 0
    bases_to_ignore_at_end = 0
    
    if aln.pos < start
      bases_to_ignore_at_start = start - aln.pos
    end
    
    if aln.calend >= start + options[:step] ## left hand border is included in window, right hand border excluded
      bases_to_ignore_at_end = aln.calend - (start + options[:step]) + 1
    end
    
    cigar_arr = correct_cigar_for_overlaps(cigar_arr.dup, bases_to_ignore_at_start, bases_to_ignore_at_end)
    #puts "start ignore = #{bases_to_ignore_at_start}"
    #puts "end ignore = #{bases_to_ignore_at_end}"
    #modify the read objects start and stop positions to keep only the bit in the window
    #ignore soft clipping at the start and end
    if bases_to_ignore_at_start >0
      aln.pos = aln.pos + bases_to_ignore_at_start
    end
    if bases_to_ignore_at_end > 0
      aln.calend = aln.calend - bases_to_ignore_at_end
    end
    
     begin
       raise "aln start >= aln end" if aln.pos > aln.calend 
     rescue
       next
     else
      read_start_corrected = aln.pos - start
      read_end_corrected = aln.calend - start
      range_start = read_start_corrected
      range_stop =  read_end_corrected
      positions[range_start..range_stop] = positions.slice(range_start..range_stop).collect! {|a| a += 1}
      ranges_to_decrement = []
      dist_through_read = 0
      cigar_arr.each_with_index do |cigar,i|
      #use the corrected cigar array to correct the coverage post-hoc
       if cigar.last == "D" or cigar.last == "N"
         ranges_to_decrement << Range.new(read_start_corrected + dist_through_read, read_start_corrected + dist_through_read + cigar.first - 1)
       end
       dist_through_read += cigar.first
      end #end cigar_arr each
      #pp ranges_to_decrement unless ranges_to_decrement.empty?
      ranges_to_decrement.each do |range|
        begin
          positions[range] = positions.slice(range).collect! {|b| b -= 1}
        rescue
          puts "Error: positions array likely  out of range ... this error affects one read only ... so we'll skip it. Panic if you get lots of this"
        end
      end
     end
  end #end fetch
  average = positions.inject(0) {|r,e|  r + e} / positions.length.to_f
  puts [start, start + options[:step], average].join("\t")

end

bam.close