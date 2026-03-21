#!/usr/bin/perl

use warnings;
use strict;


#global variables
my $VERSION = '0.1';

#pre-main {{{

my $errored=0;
my $mode='NORMAL';
my $array='';
my @infile = ();
getsopt(@ARGV);


#}}}

#variables #{{{

my $template = "data/java/tf-templates/generic-variant-template.java";	#template file
my $extend = "net.ltxprogrammer.changed.entity.ChangedEntity";	#which class to extend

my @presets=();
my @attributes=();
my @abilities=();
my @scares=( );			#what mobs fear the variant

my $transfur_sound="";		#sound a variant makes when transfurring
my $transfur_mode="";		#default tf mode
my $mining_speed="";
#my $legs;			#amount of legs
my $entity_shape="";		#entity shape enum. Assumes changed namespace, and is a subject to change
my $use_item_mode="";
my $fly="";
my $jumps="";			#jump charges
my $vision="";			#default vision type
my $climb="";			#stiger climb
my $z_offset="";		#camera z-offset used for taurs
my $freezing_ticks="";		#powder snow
my $breathing_mode="";
my $aqua_affinity="";
my $powder_snow_walkable="";
my $transfur_color="";
my $egg_back="";
my $egg_front="";
my @spawn_dimensions="net.minecraft.world.level.Level.OVERWORLD";

#}}}

while ( ! eof STDIN ) {
	push @infile, <STDIN>;
}

foreach ( @infile ) { #load config file
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
			if(-f "templates/$1") {
				$template = $1
			}
			else {
				$errored = 1;
				print STDERR "Error: Template file $1 not found, in file $_[0]
$_";
			}

			next;
		} #}}}

		if ( $_ =~ /^EXTEND=([a-zA-Z0-9])+\h*/ ) {# {{{
			$extend = $1;
			next;
		}# }}}

		if ( $_ =~ /^TRANSFUR_SOUND=(.+)\h*/ ) {# unsafe {{{
			$transfur_sound = $1;
			next;
		}# }}}

		if ( $_ =~ /^TRANSFUR_MODE=(ABSORBING|REPLICATING|NONE)\h*/ ) { #{{{
			$transfur_mode = $1;
			next;
		} #}}}

		if ( $_ =~ /^MINING=(WEAK|NORMAL|STRONG)\h*/ ) { #{{{
			$mining_speed=$1;
			next;
		} #}}}

		if ( $_ =~ /^ENTITY_SHAPE=(ANTHRO|FERAL|TAUR|NAGA|MER)\h*/ ) { #{{{
			$entity_shape = $1;
			next;
		} #}}}

		if ( $_ =~ /^USE_ITEM_MODE=(NORMAL|MOUTH|NONE)\h*/ ) { #{{{
			$use_item_mode = $1;
			next;
		} #}}}

		if ( $_ =~ /^FLY=(NONE|CT|ELYTRA|BOTH)\h*/ ) {# {{{
			$fly = $1;
			next;
		}# }}}

		if ( $_ =~ /^JUMPS=(\d+)\h*/ ) {# {{{
			$jumps = $1;
			next;
		}# }}}

		if ( $_ =~ /^VISION=(NORMAL|NIGHT_VISION|BLIND|REDUCED|VAVE_VISION)\h*/ ) {# {{{
			$vision = $1;
			next;
		}# }}}

		if ( $_ =~ /^CLIMB=(true|false)\h*/ ) { #{{{
			$climb = $1;
			next;
		} #}}}

		if ( $_ =~ /^Z_OFFSET=(\d+\.\d+)\h*/ ) {# {{{
			$z_offset = $1;
			next;
		}# }}}

		if ( $_ =~ /^TICKS_TO_FREEZE=(\d+)\h*/ ) {# {{{
			$freezing_ticks = $1;
			next;
		}# }}}

		if ( $_ =~ /^BREATH=(NORMAL|WATER|ANY|NONE)\h*/ ) {# {{{
			$breathing_mode = $1;
			next;
		}# }}}

		if ( $_ =~ /^AQUA_AFFINITY=(true|false)\h*/ ){# {{{
			$aqua_affinity = $1;
			next;
		}# }}}

		if ( $_ =~ /^POWDER_SNOW_WALKABLE=(true|false)\h*/ ){# {{{
			$powder_snow_walkable = $1;
			next;
		}# }}}

		if ( $_ =~ /^TRANSFUR_COLOR=(0x[0-9a-fA-F]{,6})\h*/ ) {# {{{
			$transfur_color = $1;
			next;
		}# }}}

		if ( $_ =~ /^ABILITY_COLOR_1ST=(0x[0-9a-fA-F]{,6})\h*/ ) {# {{{
			$egg_back = $1;
			next;
		}# }}}

		if ( $_ =~ /^ABILITY_COLOR_2ND=(0x[0-9a-fA-F]{,6})\h*/ ) {# {{{
			$egg_front = $1;
			next;
		}# }}}
		
		#unused, but needed
		if ( $_ =~ /^GENDERED=(true|false)/ ) {
			next;
		}

		if ( $_ =~ /^BIOMES=/ ) {
			next;
		}

		if ( $_ =~ /^MIN_SPAWN=(\d)*/ ) {
			next;
		}

		if ( $_ =~ /^MAX_SPAWN=(\d)*/ ) {
			next;
		}

		if ( $_ =~ /^SPAWN_WEIGHT=(\d)*/ ) {
			next;
		}
		
		if ( $_ =~ /^RENDERER_TYPE=/ ) {
			next;
		}

		print STDERR "Invalid option $_\n";
		$errored = 1;
	} #}}}

	if ( $mode eq 'ARRAY' ) { # {{{

		if ( $_ =~ /^]\h*/ ) { #{{{
			$array = '';
			$mode = 'NORMAL';
			next;
		} # }}}

		if ( $array eq '' ) { # if we drop from normal mode, get option {{{
			$_ =~ /([A-Z]+)=\[\h*/;
			$array = $1;
			next;
		} #}}}

		if ( $array eq 'PRESETS' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @presets, $1 );
			next;
		} #}}}

		if ( $array eq 'ABILITIES' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @abilities, $1 );
			next;
		} #}}}

		if ( $array eq 'ATTRIBUTES' ) { #{{{
			$_ =~ /(.+):(.+)\h*/;
			push @attributes, $2;
			next;
		} #}}}

		if ( $array eq 'SCARES' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @scares, $1 );
			next;
		} #}}}
		
		if ( $array eq 'SPAWN_DIMENSIONS' ) { #{{{
			$_ =~ /(.+)\h*/;
			push( @scares, $1 );
			next;
		} #}}}
		
		if ( $array eq 'DIMENSIONS' ) { next; };

		print STDERR "Unknown array definition: \"$array\", field: \"$_\"";
		$errored = 1;
		next;
	} #}}}

	$errored = 1;
	print STDERR "Internal Compiler Error - bad mode: $mode\n";
}

die 'Compikation aborted due to input errors' if $errored;
#main
#prepare arrays{{{
foreach( @abilities ) {
	$_ = ".addAbility(" . $_ . ")\n";
}

foreach ( @scares ) {
	$_ = ".scares(" . $_ . ".class)\n";
}

foreach ( @attributes ) {
	$_ =~ /^(.+):^(.+)/;
	my $attribute = $1;
	my $value = $2;

	$_ = "attributes.getInstance(" . $attribute . ".get().setBaseValue(" . $value . ");";
}
# }}}

$transfur_sound = ( $transfur_sound eq '' ) ? '' : ".sound(" . $transfur_sound . ".getId())\n";

my $TEMPLATE;
open( $TEMPLATE, '<', $template ) or die "Couldn't open file $template, $!";
my @mapped_file = <$TEMPLATE>;
close ($TEMPLATE);

foreach ( @mapped_file ) {
	
}

print @abilities;
print @attributes;
print @scares;
print @spawn_dimensions;

print $transfur_sound;
print $transfur_mode;
print $mining_speed;
print $entity_shape;
print $use_item_mode;
print $fly;
print $jumps;
print $vision;
print $climb;
print $z_offset;
print $freezing_ticks;
print $breathing_mode;
print $aqua_affinity;
print $powder_snow_walkable;
print $transfur_color;
print $egg_back;
print $egg_front;


sub getsopt {
	foreach (@_) {
		if ($_ eq -h ) {
			printHelp();
			exit(0);
		}
	}
}

sub printHelp { 
	print "
KJEntytek's303 Line Oriented Format Transfur Generator
Version $VERSION

USAGE:
./generator.sh [OPTION] [FILE]

If no file is given, the program recompiles all models inside ./variants

OPTIONS:
 -h	- Displays this message
";
} 
