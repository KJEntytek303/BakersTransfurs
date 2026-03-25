#!/usr/bin/perl
#VKSTG - Validator of KJEntytek's Simple Transfur Generator

use strict;
#use warnings; #ENABLE ONLY DURING TESTING, generally keep it disabled on production.

my @mapped_file = ();
my @IFILE = ();
my $errored = 0;
my $mode = 'NORMAL';
my $array = '';
my $current_array = '';


while ( !eof STDIN ) {
	push( @IFILE, <STDIN> );
}


my $i = 0;

my @dependencies = ();

reevaluate_file:


foreach ( @IFILE ) {

	$i++;
	loop_begin:

	if( ( $_ =~ /^;/ ) || ( $_ =~ /^\h*$/ ) ) { 
		next;
	}

	if ($mode eq 'NORMAL') { #{{{

		if ( $_ =~ /^([A-Z_]+)=\[\h*/ ) { #if array opening {{{
			$mode ='ARRAY';
			goto loop_begin; #reevaluate as array.
		} # }}}

		if ( $_ =~ /^TEMPLATE=(.+)/ ) { # {{{
			if(-f ( "data/java/tf-templates/$1" . ".java" ) ) {
				push( @mapped_file, $_ );
				next;
			}
			else {
				$errored = 1;
				print STDERR "Error: Template file $1 not found, line $i";
			}
			next;
		} #}}}

		if ( $_ =~ /^EXTEND=([a-zA-Z0-9])+\h*/ ||
		$_ =~ /^TRANSFUR_SOUND=(.+)\h*/ ||
		$_ =~ /^TRANSFUR_MODE=(ABSORPTION|REPLICATION|NONE)\h*/ || 
		$_ =~ /^MINING=(WEAK|NORMAL|STRONG)\h*/ || 
		$_ =~ /^ENTITY_SHAPE=(ANTHRO|FERAL|TAUR|NAGA|MER)\h*/ || 
		$_ =~ /^USE_ITEM_MODE=(NORMAL|MOUTH|NONE)\h*/ || 
		$_ =~ /^FLY=(NONE|CT|ELYTRA|BOTH)\h*/ ||
		$_ =~ /^JUMPS=(\d+)\h*/ ||
		$_ =~ /^VISION=(NORMAL|NIGHT_VISION|BLIND|REDUCED|VAVE_VISION)\h*/ ||
		$_ =~ /^CLIMB=(true|false)\h*/ || 
		$_ =~ /^Z_OFFSET=(\d+\.\d+)\h*/ ||
		$_ =~ /^TICKS_TO_FREEZE=(\d+)\h*/ ||
		$_ =~ /^BREATH=(NORMAL|WATER|ANY|NONE)\h*/ ||
		$_ =~ /^POWDER_SNOW_WALKABLE=(true|false)\h*/ ||
		$_ =~ /^TRANSFUR_COLOR=(0x[0-9a-fA-F]{,6})\h*/ ||
		$_ =~ /^ABILITY_COLOR_1ST=(0x[0-9a-fA-F]{,6})\h*/ ||
		$_ =~ /^ABILITY_COLOR_2ND=(0x[0-9a-fA-F]{,6})\h*/ ||
		$_ =~ /^LATEX_TYPE=(WHITE_LATEX|DARK_LATEX|NONE)/ ||
		$_ =~ /^BUILDER=(.+)/ ||
		$_ =~ /^MIN_SPAWN=(\d)*/ ||
		$_ =~ /^MAX_SPAWN=(\d)*/ ||
		$_ =~ /^SPAWN_WEIGHT=(\d)*/ ||
		$_ =~ /^RENDERER_TYPE=/ ||
		$_ =~ /^MULTIHANDED_RENDERER=(true|false)/ ||
		$_ =~ /^ARMOR_TYPE=/ ||
		$_ =~ /^EYES_PRESENT=(true|false)\h*$/ ||
		$_ =~ /^IRIS_1ST_COLOR=0x([0-9a-fA-F]{,6})\h*/ ||
		$_ =~ /^IRIS_2ND_COLOR=0x([0-9a-fA-F]{,6})\h*/ ||
		$_ =~ /^SCLERA_COLOR=0x([0-9a-fA-F]{,6})\h*/ ||
		$_ =~ /^GAS_MASK_LAYER=(.+)/ ||
		$_ =~ /^EMISSIVE_LAYER=(true|false)/ ||
		$_ =~ /^TRANSLUCENT_LAYER=(true|false)/ ||
		$_ =~ /^MODEL_SCALE=(\d+\.\d+)/ ||
		$_ =~ /^ANIM_PRESET=(.)+\h*$/ ||
		$_ =~ /^RIDING_OFFSET=(\d+\.\d+)/ ||
		$_ =~ /^GENDERED=(true|false)/
		) { push( @mapped_file, $_ ); next; }

		if ( $_ =~ /^BIOME_PRESET=(\.)/ ) {
			if ( !(-f ("data/data/additional_transfurs/forge/biome_modifier/$1" . ".json" ))) {
				$errored = 1;
				print STDERR "Error: No such file '$1', line $i:\n$_";
			}
			next;
		}

		$errored = 1;
		chomp( $_);
		print STDERR "Invalid option $_, line $i\n";
		next;
	} #}}}

	if ( $mode eq 'ARRAY' ) { # {{{

		if ( $_ =~ /^]\h*/ ) { #array end
			$array = '';
			$mode = 'NORMAL';
			push( @mapped_file, $_ );
			next;
		} 

		if ( $array eq '' ) { # if we drop from normal mode, get option 
			$_ =~ /([A-Z]+)=\[\h*/;
			$array = $1;
			push( @mapped_file, $_ );
			next;
		}

		if ( $array eq 'PRESETS' ) {
			chomp($_);
			if ( -f "data/klofs/presets/$_.klof" ) {
				push( @dependencies, "data/klofs/presets/$_.klof");
				next;
			}

			$errored = 1;
			print STDERR "Error: data/klofs/presets/$_.klof: No such file, line $i";
		}

		if ( $array eq 'ABILITIES' ||
			$array eq 'ATTRIBUTES' ||
			$array eq 'SCARES' ||
			$array eq 'DIMENSIONS'
		) { push( @mapped_file, $_ ); next; };

		print STDERR "Unknown array definition: \"$array\", field: \"$_\", line $i";
		$errored = 1;
		next;
	} #}}}

	$errored = 1;
	print STDERR "Internal Compiler Error - bad mode: $mode, line $i\n";
}

if ( scalar(@dependencies) != 0 ) {
	resolveDependencies($dependencies[0]);
	shift( @dependencies );
	goto reevaluate_file;
}


if ( $errored ) { die 'Errors occurred, compilation aborted'; }

print @mapped_file;

sub resolveDependencies() {
	#Inject the file at the beginning.
	my @tmp;
 	( @tmp = `./vkstg.pl < $_[0]` );
	system( "./vkstg.pl < $_[0] > /dev/null" ) && die "Broken template file $_[0]\n";
	splice (@mapped_file, 0, 0, @tmp);
	@IFILE = @mapped_file;
	@mapped_file = ();
}
