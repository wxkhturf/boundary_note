
#!/usr/bin/perl -w
use strict;

use Cwd qw( getcwd abs_path);
my $path = abs_path(getcwd()); 
require $path."/boundary_note.pm";


open(FILEIN,"<./file_list");
my @all_files = <FILEIN>;
close FILEIN;
system ("mkdir -p temp");

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
my $begin     = '\/\/jack\s+begin';
my $end       = '\/\/jack\s+end';
my $note_head = '\/\/j:';
#----------------------------------------------------------

foreach $a (@all_files){
    #file open
        open (FILETEMP,"< $a");
        my @lines = <FILETEMP>;
        close FILETEMP;
        open(FILEOUT,"> ./temp/$a");
    #file end
    
    my @cont;
    @cont = boundary_note::del_note($begin, $end, $note_head, @lines);
    foreach (@cont){
        print FILEOUT $_;
    }
    close FILEOUT;
}