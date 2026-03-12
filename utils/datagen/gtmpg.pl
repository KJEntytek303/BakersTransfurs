#!/usr/bin/perl
#GregTech Masochist's Perl Generator /j
use warnings;
use strict;

use File::Path qw(make_path);

my @files;

open(my $CACHED_LOCATIONS, "<cache") or die "Couldn't open discovered file struct: $!\nAborted";

foreach (<$CACHED_LOCATIONS>) {
	if ( $_ =~ /(.+\.mctag)/ ) {
		push( @files, $1 );
	}
}
close $CACHED_LOCATIONS;

foreach(@files) {

	my $gen_path = $_;
	$gen_path =~ s/^data/generated/;

	my $gen_dir_path = $gen_path;
	$gen_dir_path =~ s/(\/)[^\/]+$//; #delete file name and leave just dir path.

	make_path($gen_dir_path);

	$gen_path =~ s/\.mctag$/\.json/;

	$gen_path =~ s/mctag$/json/;
	my $errored = 0;

	my @tag_values;
	open( my $FILE, "<$_" ) or die "Couldn't open file '$_': $!";

	foreach (<$FILE>) { # scan a file and push the lines into a buffer{{{

		if ( $_ =~ /^\h*\n?$/ || $_ =~ /^;/ ) { #blank line or comment
			next;
		}
		$_ =~ /(^#?[a-z][a-z0-9_]*:[a-z][a-z0-9_\/]*)\h*(false|)?\h*$/ ;
		my $tmp1 = $1;
		my $tmp2 = $2;

		if ( ! $_ =~ /(^#?[a-z][a-z0-9_]*:[a-z][a-z0-9_\/]*)\h*(false|)?\h*$/ ) { #not entry
			print STDERR "Broken entry \"$_";
			$errored = 1;
		}

		my $temp_tmp;

		if ( $tmp2 eq 'false' ) {
			$temp_tmp = '{ "id": "' . $tmp1 . '", "required": false }';
		}
		else {
			$temp_tmp = '"' . $tmp1 . '"';
		}

		$temp_tmp = '    ' . $temp_tmp . ',' . "\n";
		push(@tag_values, $temp_tmp);
	} #}}}

	close ($FILE);

	if ($errored) {
		print STDERR "in file \"$_\"\n";
		next;}

	open( my $TFILE, 'tag.json.template' ) or die "Couldn't open file 'tag.json.template': $!";
	my @TAG_FILE = <$TFILE>;
	close ($TFILE);

	$tag_values[ scalar(@tag_values) - 1 ] =~ s/,$//;
	
	foreach (@TAG_FILE) {
		$_ =~ s/PERL_TAGS/@tag_values/;
	}
	
	open(WFILE, '>', $gen_path ) or die "Couldn't open file '$gen_path': $!";
	foreach ( @TAG_FILE ) {
		print WFILE $_;
	}

	close (WFILE);
}
