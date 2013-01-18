#!/usr/bin/env ruby
#
#  untitled
#
#  Created by Dan MacLean (TSL) on 2012-09-30.
#  Copyright (c)  . All rights reserved.
###################################################
require 'optparse'
options ={}
optparse = OptionParser.new do|opts|

  opts.on( '-j', '--json_file FILE', ' name of JSON config file' ) do |j|
    options[:json] = j
  end

  opts.on( '-o', '--svg_file FILE', ' name of SVG outfile' ) do |s|
    options[:svg] = s
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!



require 'bio-svgenes'

Bio::Graphics::Page.from_json(:json => options[:json], :outfile => options[:svg] )
