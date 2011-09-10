#!/usr/bin/perl -W

use File::Basename;

my $fn;

foreach $fn (@ARGV) {
  my ($name, $path, $suffix) = fileparse($fn, qr/\.[^.]*/);
  $name = uc $name;  # Fix lowercased names
  my $outname = $path . $name . "-clean" . $suffix;
  open(my $input, '<:encoding(iso-8859-1)', $fn) or die $!;
  open(my $output, '>:encoding(utf-8)', $outname);

  print STDERR "Processing ${fn}.\n";

  my $prev = "";
  my $namere = qr/^$name\|/;
  my $count = 0;
  my $procre;

  while (<$input>) {
    # Remove all newlines and backslashes.
    s/[\r\n\\]//go;
    if (m/$namere/) {
      if ($prev) {
        # Print last line, which is now complete.
        # Collapse runs of spaces and eliminate leading/trailing spaces
        # within fields.
        $prev =~ s/\s{2,}/ /go;
        $prev =~ s/\s*\|\s*/\|/go;
        if ($name eq "CO" or $name eq "EN") {
          # Special case -- fscking unescaped pipes in a pipe-delimited
          # file.
          # CO: Five pipes before the comment field and two after.
          # EN: 21 of 27 -- 20 before, 6 after.
          if ($name eq "CO") {
            $procre = qr/^((?:[^\|]*?\|){5})(.*?)(\|[^\|]*?\|[^\|]*?)$/;
          } elsif ($name eq "EN") {
            $procre = qr/^((?:[^\|]*?\|){20})(.*?)((?:\|[^\|]*?){6})$/;
          } else {
            die "Reached an impossible place";
          }
          if ($prev =~ m/$procre/) {
            my $before = $1;
            my $during = $2;
            my $after = $3;
            $during =~ s/\|/\\\|/g;
            my $newprev = $before . $during . $after;
            if ($newprev ne $prev) {
              # print STDERR 
              #   "Embedded pipes removed from line.\nWas: " .
              #   "$prev\nIs:  $newprev\n-----------\n";
              $prev = $newprev;
            }
          } else {
            die "This should not happen!";
          }
        }
        print $output $prev . "\n";
        $prev = "";
        $count++;
      }
      $prev = $_;
    } else {
      # Continuation of a previous line.
      $prev .= "\\n";
      $prev .= $_;
    }
  }
  if ($prev) {
    # Collapse runs of spaces and eliminate leading/trailing spaces within fields.
    $prev =~ s/\s{2,}/ /go;
    $prev =~ s/\s*\|\s*/\|/go;
    print $output $prev . "\n";
    $count++;
  }
  close $input;
  close $output;
  print STDERR "Processed $name with $count records.\n";
}
