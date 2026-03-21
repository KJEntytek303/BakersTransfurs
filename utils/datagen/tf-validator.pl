#!/usr/bin/perl

use strict;
use warnings;

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
foreach ( @IFILE ) {

	$i++;

	loop_begin:

	if( ( $_ =~ /^;/ ) || ( $_ =~ /^\h*$/ ) ) { 
		next;
	}

	if ($mode eq 'NORMAL') { #{{{

		if ( $_ =~ /^[A-Z_]+=\[\h*/ ) { #if array opening {{{
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

		if ( $_ =~ /^EXTEND=([a-zA-Z0-9])+\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^TRANSFUR_SOUND=(.+)\h*/ ) {# unsafe {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^TRANSFUR_MODE=(ABSORBING|REPLICATING|NONE)\h*/ ) { #{{{
			push( @mapped_file, $_ ); next;
		} #}}}

		if ( $_ =~ /^MINING=(WEAK|NORMAL|STRONG)\h*/ ) { #{{{
			push( @mapped_file, $_ ); next;
		} #}}}

		if ( $_ =~ /^ENTITY_SHAPE=(ANTHRO|FERAL|TAUR|NAGA|MER)\h*/ ) { #{{{
			push( @mapped_file, $_ ); next;
		} #}}}

		if ( $_ =~ /^USE_ITEM_MODE=(NORMAL|MOUTH|NONE)\h*/ ) { #{{{
			push( @mapped_file, $_ ); next;
		} #}}}

		if ( $_ =~ /^FLY=(NONE|CT|ELYTRA|BOTH)\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^JUMPS=(\d+)\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^VISION=(NORMAL|NIGHT_VISION|BLIND|REDUCED|VAVE_VISION)\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^CLIMB=(true|false)\h*/ ) { #{{{
			push( @mapped_file, $_ ); next;
		} #}}}

		if ( $_ =~ /^Z_OFFSET=(\d+\.\d+)\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^TICKS_TO_FREEZE=(\d+)\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^BREATH=(NORMAL|WATER|ANY|NONE)\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^AQUA_AFFINITY=(true|false)\h*/ ){# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^POWDER_SNOW_WALKABLE=(true|false)\h*/ ){# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^TRANSFUR_COLOR=(0x[0-9a-fA-F]{,6})\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^ABILITY_COLOR_1ST=(0x[0-9a-fA-F]{,6})\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}

		if ( $_ =~ /^ABILITY_COLOR_2ND=(0x[0-9a-fA-F]{,6})\h*/ ) {# {{{
			push( @mapped_file, $_ ); next;
		}# }}}
		
		if ( $_ =~ /^GENDERED=(true|false)/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^BIOME_PRESET=(\.)/ ) {
			if ( !(-f ("data/data/additional_transfurs/forge/biome_modifier/$1" . ".json" ))) {
				$errored = 1;
				print STDERR "Error: No such file '$1', line $i:\n$_";
			}
			next;
		}

		if ( $_ =~ /^MIN_SPAWN=(\d)*/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^MAX_SPAWN=(\d)*/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^SPAWN_WEIGHT=(\d)*/ ) {
			push( @mapped_file, $_ ); next;
		}
		
		if ( $_ =~ /^RENDERER_TYPE=/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^ARMOR_TYPE=/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^EYES_PRESENT=(true|false)\h*$/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^IRIS_1ST_COLOR=0x([0-9a-fA-F]{,6})\h*/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^IRIS_2ND_COLOR=0x([0-9a-fA-F]{,6})\h*/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^SCLERA_COLOR=0x([0-9a-fA-F]{,6})\h*/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^GAS_MASK_LAYER=(.+)/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^ANIM_PRESET=(.)+\h*$/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^MODEL_SCALE=(\d+\.\d+)/ ) {
			push( @mapped_file, $_ ); next;
		}

		if ( $_ =~ /^BUILDER=(\.+)\h*/) {
			push( @mapped_file, $_ ); next;
		}

		$errored = 1;
		chomp( $_);
		print STDERR "Invalid option $_, line $i\n";
		next;
	} #}}}

	if ( $mode eq 'ARRAY' ) { 

		if ( $_ =~ /^]\h*/ ) { #{{{
			$array = '';
			$mode = 'NORMAL';
			push( @mapped_file, $_ );
			next;
		} # }}}

		if ( $array eq '' ) { # if we drop from normal mode, get option 
			$_ =~ /([A-Z]+)=\[\h*/;
			$array = $1;
			push( @mapped_file, $_ );
			next;
		}

		if ( $array eq 'PRESETS' ) { push( @mapped_file, $_ ); next; }

		if ( $array eq 'ABILITIES' ) { push( @mapped_file, $_ ); next; } 

		if ( $array eq 'ATTRIBUTES' ) { push( @mapped_file, $_ ); next; }

		if ( $array eq 'SCARES' ) { push( @mapped_file, $_ ); next; }
		
		if ( $array eq 'SPAWN_DIMENSIONS' ) { push( @mapped_file, $_ ); next; }
		
		if ( $array eq 'DIMENSIONS' ) { push( @mapped_file, $_ ); next; };

		print STDERR "Unknown array definition: \"$array\", field: \"$_\", line $i";
		$errored = 1;
		next;
	} #

	$errored = 1;
	print STDERR "Internal Compiler Error - bad mode: $mode, line $i\n";
}

die 'Errors occuree, compilation aborted' if $errored;

print @mapped_file;
