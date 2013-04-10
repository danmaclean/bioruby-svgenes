# bio-svgenes

SVGenes is a Ruby-language library that uses SVG primitives to render typical genomic glyphs through a simple and flexible Ruby interface. 

The library implements a simple Page object that spaces and contains horizontal Track objects that in turn style,colour and positions features within them. Tracks are the level at which visual information is supplied providing the full styling capability of the SVG standard. Genomic entities like genes, transcripts and histograms are modelled in Glyph objects that are attached to a track and take advantage of SVG primitives to render the genomic features in a track as any of a selection of defined glyphs. The feature model within SVGenes is simple but flexible and not dependent on particular existing gene feature formats meaning graphics for any existing datasets can easily be created without need for conversion. 

## Installation and Basic Use

This should be easy - the package is available as a gem. If you have an internet connection try:

	gem install bio-svgenes
	
If this doesn't work try,

	sudo gem install bio-svgenes

### Workflow

#### Loading the gem
Basic use is straightforward. First, load in the gem

	require 'bio-svgenes'

#### Set up the page object
The first thing we need to do is set up the page object, a `Bio::Graphics::Page` instance. This defines the attributes of the page into which our glyphs will be drawn.

	p = Bio::Graphics::Page.new(
				 :width => 800, 
	             :height => 200, 
	             :number_of_intervals => 10
	)

The `:width` attribute specifies the minimum width of the page and the `:height` attribute specifies the minimum height. Each of these will be increased if successful rendering requires more room than specified. The `:number_of_intervals` attributes specifies the number of segments to divide the scale into. A scale is always drawn.

#### Add a track to the page
Next, we need to add a track to the page. We do this with the `Bio::Graphics::Page#add_track` method. Glyphs are rendered within tracks and tracks define how those glyphs will be styled. In this example we create a `generic` block glyph.

	generic_track = p.add_track(
				 :glyph => :generic, 
				 :name => 'generic_features', 
				 :label => true  
	)
	
The `:name` attribute allows us to define a name for the track and the `:label` attribute explicitly states whether the name should be written onto the track.

#### Create a MiniFeature object
Each of the features is represented by a `Bio::Graphics::MiniFeature` object. This is easily created:

	mini_feature = Bio::Graphics::MiniFeature.new(
					:start => 923, 
					:end => 2212, 
					:strand => '+', 
					:id => "MyFeature"
	)

The minimum information you need to provide for a feature is the start and end. In this example, we add a strand and an id for the feature.

#### Add the feature to the track

The feature now needs to be added to the track object to be considered during rendering, we use `Bio::Graphics::Track#add` for this.

	generic_track.add(mini_feature)

This process is repeated for all the features and tracks you want to show in the final rendered figure. We then tell the page to render itself to a file.

	p.write("output.svg")

See the RDOC in the packages doc directory for more information.

 




### Contributing to bio-svgenes
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or it is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Dan MacLean. See LICENSE.txt for further details.

