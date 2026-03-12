#!/usr/bin/perl

use strict;
use warnings;

my @cached_files;
discover( "data" );

open( WFILE, '>', "cache" );
foreach ( @cached_files ) {
	print WFILE "$_\n";
}
close(WFILE);


sub discover {
	opendir(my $scanned_dir, $_[0]) or print STDERR "Couldn't open directory '$_[0]': $!";
	
	my @files_in_dir = readdir($scanned_dir);
	closedir($scanned_dir);

	foreach ( @files_in_dir ) {

		my $newpath = $_[0] . "/" . "$_";

		if ( $_ eq "." || $_ eq ".." ) { next;}

		if ( -d $newpath && $newpath =~ /[a-z_0-9\/]+/ ) { 
			discover($newpath);
			next;
		}

		if ( ! -f $newpath ) {
			print STDERR "Invalid file: $newpath";
			next;
		}

		push ( @cached_files, $newpath );
	}
}
