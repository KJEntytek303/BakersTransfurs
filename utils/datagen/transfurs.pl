#!/usr/bin/perl

use warnings;
use strict;


#global variables
my $PACKAGE_PATH = '../../src/main/java/net/brown_bakers/bakers_transfurs/entity/generated';
my $VERSION = '0.1';


#pre-main {{{

my @files;
my @prepared_files;
my $should_crash;
my $errored=0;
my $force_regen=0;
getlopt(@ARGV);
my $argc = scalar(@files);

#}}}


#variables #{{{

my $template = "./templates/generic.java.template";		#template file
my $extend = "net.ltxprogrammer.changed.entity.ChangedEntity";	#which class to extend

my @presets;
my %attributes;
my @abilities;
my @scares;			#what mobs fear the variant
my @imports;			#java class imports

my $transfur_sound;		#sound a variant makes when transfurring
my $transfur_mode;		#default tf mode
my $mining_speed;
#my $legs;			#amount of legs
my $entity_shape;		#entity shape enum. Assumes changed namespace, and is a subject to change
my $use_item_mode
my $fly;
my $jumps;			#jump charges
my $vision;			#default vision type
my $climb;			#stiger climb
my $safe_fall;			#safe fall distance multiplier
my $z_offset;			#camera z-offset used for taurs
my $gendered;			#this switches the script from generating 1 file, to generating 3.
my $freezing_ticks;		#powder snow
my $breathing_mode;
my $aqua_affinity;
my $powder_snow_walkable;
my $transfur_colors;
#my $latex_faction;		#DL/WL swimming and cover slowdown
my $VARIANT_FILE;		#FILE* to a variant

my @registered_transfurs;
my @final_imports;
	
#}}}

#main

#if @files is empty, recompile all entries in ./variants
if ($argc == 0 || $force_regen == 1)
{
	opendir(my $D, './variants') or die "Error: Can't open directory ./variants: $!.
Compilation aborted\n";
	@files = readdir($D);
	closedir($D);
}


foreach (@files) {
	generateTransfur($_);
	write_temporary_file();
	resetValues();
}

write_registries();
write_transfurs();
wipe_tmp();

# functions {{{

sub write_registries { #{{{
} #}}}

sub write_transfurs { #{{{
} #}}}

sub generateTransfur { #{{{
	my $mode = 'NORMAL';
	my $array = "";
	open(VARIANT_FILE, "<", $_[0]);
	foreach(<VARIANT_FILE>) {
		loop_begin:

		if( /^#.*/ ) { #if comment {{{
			next;
		} #}}}

		if ($mode eq 'NORMAL') { #{{{

			if ( /^TEMPLATE=(.+)/ ) { # {{{
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
	
			if ( /^[A-Z_]+-=\[\h*/ ) { #if array opening {{{
				$mode ='ARRAY';
				goto loop_begin; #reevaluate as array.
			} # }}}
	
			if ( /^TRANSFUR_SOUND=(.+)\h*/ ) {# unsafe {{{
				$transfur_sound = $1;
				next;
			}# }}}
	
			if ( /^TRANSFUR_MODE=(ABSORBING|REPLICATING|NONE)\h*/ ) { #{{{
				$transfur_mode = $1;
				next;
			} #}}}
	
			if ( /^MINING=(WEAK|NORMAL|STRONG)\h*/ ) { #{{{
				$mining_speed=$1;
				next;
			} #}}}
	
			if ( /^LEGS=(0|2|4)\h*/ ) { #{{{
				$legs = $1; 
				next;
			} #}}}
	
			if ( /^ENTITY_SHAPE=(ANTRO|FERAL|TAUR|NAGA|MER)\h*/ ) { #{{{
				$entity_shape = $1;
				next;
			} #}}}
	
			if ( /^SHOW_HOTBAR=(true|false)\h*/ ) { #{{{
				$show_hotbar = $1;
				next;
			} #}}}
	
			if ( /^ITEMS_IN_MAIN_HAND=(true|false)\h*/ ) { #{{{
				$items_in_main_hand = $1;
				next;
			} #}}}
	
			if ( /^ITEMS_IN_OFF_HAND=(true|false)\h*/ ) { #{{{
				$items_in_offhand = $1;
				next;
			} #}}}
	
			if ( /^BLOCK_INTERACTION=(true|false)\h*/ ) { #{{{
				$block_interaction = $1;
				next;
			} #}}}
	
			if ( /^BLOCK_BREAKING=(true|false)\h*/ ) { #{{{
				$block_breaking = $1;
				next;
			} #}}}
	
			if ( /^FLY=(NONE|CT|ELYTRA|BOTH)\h*/ ) {# {{{
				$fly = $1;
				next;
			}# }}}
	
			if ( /^JUMPS=(\d+)\h*/ ) {# {{{
				$jumps = $1;
				next;
			}# }}}
	
			if ( /^VISION=(NORMAL|NIGHT_VISION|BLIND|REDUCED|VAVE_VISION)\h*/ ) {# {{{
				$vision = $1;
				next;
			}# }}}
	
			if ( /^CLIMB=(true|false)\h*/ ) { #{{{
				$climb = $1;
				next;
			} #}}}
	
			if ( /^SAFE_FALL_DIST=(\d+\.\d+)\h*/ ) {# {{{
				$safe_fall = $1;
				next;
			}# }}}
	
			if ( /^Z_OFFSET=(\d+\.\d+)\h*/ ) {# {{{
				$z_offset = $1;
				next;
			}# }}}
	
			if ( /^GENDERED=(true|false)\h*/ ) {# {{{
				$gendered = $1;
				next;
			}# }}}
			
			if ( /^TICKS_TO_FREEZE=(\d+)\h*/ ) {# {{{
				$freezing_ticks = $1;
				next;
			}# }}}
	
			if ( /^BREATH=(NORMAL|WATER|BOTH|NONE)\h*/ ) {# {{{
				$breathing_mode = $1;
				next;
			}# }}}
	
			if ( /^AQUA_AFFINITY=(true|false)\h*/ ){# {{{
				$aqua_affinity = $1;
				next;
			}# }}}
	
			if ( /^POWDER_SNOW_WALKABLE=(true|false)\h*/ ){# {{{
				$powder_snow_walkable = $1;
				next;
			}# }}}
	
			if ( /^TRANFUR_COLORS=(0x[0-9a-fA-F]{,6})\h*/ ) {# {{{
				$transfur_colors = $1;
				next;
			}# }}}
	
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

			if ( $array eq 'ABILITIES' ) { #{{{
				$_ =~ /(.+)\h*/;
				push( @abilities, $1 );
				next;
			} #}}}

			if ( $array eq 'ATTRIBUTES' ) { #{{{
				$_ =~ /(.+):(.+)\h*/;
				$attributes{$1} = $2;
				next;
			} #}}}

			if ( $array eq 'SCARES' ) { #{{{
				$_ =~ /(.+)\h*/;
				push( @scares, $1 );
				next;
			} #}}}
			
			if ( $array eq 'IMPORTS' ) { #{{{
				$_ =~ /(.+)\h*/;
				push( @imports, $1 );
				next;
			} #}}}

			print "Unknown array definition: \"$array\", field: \"$_\"";
			$errored = 1;
			next;
		} #}}}

		$errored = 1;
		die "Internal Compiler Error - bad mode: $array";
	}
	close(VARIANT_FILE);
} #}}}

sub resetValues { #{{{
	$template = "./templates/generic.java.template";		
	$extend = "net.ltxprogrammer.changed.entity.ChangedEntity";	

	@presets = ();
	%attributes = ();
	@abilities = ();
	@scares = ();		
	@imports = ();		

	$transfur_sound = "";	
	$transfur_mode = "";	
	$mining_speed = "";
	$legs = "";		
	$entity_shape = "";	
	$show_hotbar = "";	
	$items_in_main_hand = "";	
	$items_in_offhand = "";	
	$block_interaction = "";	
	$block_breaking = "";	
	$fly = "";
	$jumps = "";		
	$vision = "";		
	$climb = "";		
	$safe_fall = "";		
	$z_offset = "";		
	$gendered = "";		
	$freezing_ticks = "";	
	$breathing_mode = "";
	$aqua_affinity = "";
	$powder_snow_walkable = "";
	$transfur_colors = "";
#	$latex_faction = "";

} #}}}

#Getopt and stuff {{{
sub getlopt { #{{{
	foreach (@ARGV){
		if ($_ =~ /^--help$/) {
			printHelp();
			exit(0);
		}
		if ($_ =~ /^--version$/) {
			print $VERSION;
			exit(0);
		}
		if ($_ =~ /^--force-regen$/) {
			$force_regen = 1;
			next;
		}
		if ($_ =~ /^--crash$/) {
			$should_crash = 1;
			next;
		}
		if ($_ =~ /^-[hcVf]+$/) {
			getsopt($_);
			next;
		}

		#if not opt, push into files
		push(@files, $_);
	}
} #}}}

sub getsopt { #{{{
	if ($_ =~ /h/) {
		printHelp();
		exit(0);
	}
	if ($_ =~ /V/) {
		print $VERSION;
		exit(0);
	}
	if ($_ =~ /c/) {
		$should_crash = 1;
	}
	if ($_ =~ /f/) {
		$force_regen = 1;
	}
} #}}}

sub printHelp { #{{{
	print "
KJEntytek's303 Line Oriented Format Transfur Generator
Version $VERSION

USAGE:
./generator.sh [OPTION] [FILE]

If no file is given, the program recompiles all models inside ./variants

OPTIONS:
 -h	--help		- Displays this message
 -c	--crash 	- Crashes on error
 -V	--version	- Prints version
 -f	--full-regen	- Force regenerates all entries. Ingores all FILEs. Useful to regenerate registriers, instead of appending to them.
";
} #}}}

#}}}
# }}}

# macros {{{
#}}}
