#!usr/bin/perl
package boundary_note;

sub del_note{
    (my $begin, my $end, my $note_head, my @lines)  = @_;
    my @output;
    my $flag = 0;

    foreach my $line (@lines)
    {

        if ( $line =~ /$begin/ ){
            $flag = 1;
        } elsif ( $line =~/$end/ ){
            $flag = 0;
            next;
        }

        if ( $flag == 0 ){
            push(@output, $line);
        } elsif( $flag == 1 ){
            if( ($line !~ /$begin/) and ($line !~ /$end/) ){
                if($line =~ /$note_head/){
                    $line =~ s/$note_head/\/\//g;
                    push(@output, $line);
                } elsif( $line =~/\/\//){
                    $line =~ s/\/\/.*//g;
                    push(@output, $line);
                } else {
                    push(@output, $line);
                }
            }
        }
    }
    return @output;
}


1;