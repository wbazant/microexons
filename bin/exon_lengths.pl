#! /usr/bin/env perl
use strict;
use warnings;

my $all_exons = 0;
my @lengths_mod_3 = (0) x 3;
my $all_exons_under_70 = 0;
my @lengths_mod_3_under_70 = (0) x 3;
my $all_exons_over_70 = 0;
my @lengths_mod_3_over_70 = (0) x 3;
while(<>){
  next if /^#/;
  my @F = split "\t";
  if($F[2] eq "exon"){
     my $length = $F[4] - $F[3] + 1;
     $length = 1000 if $length > 1000;
     $lengths_mod_3[$length % 3] ++;
     $all_exons++;
     if($length < 70 ){
       $lengths_mod_3_under_70[$length % 3] ++;
       $all_exons_under_70++;
     } else {
       $lengths_mod_3_over_70[$length % 3] ++;
       $all_exons_over_70++;
     }
  }
}
print sprintf("%.03f\t%.03f\n", $lengths_mod_3[0]/$all_exons - 1/3, $lengths_mod_3_under_70[0]/ $all_exons_under_70 - $lengths_mod_3[0]/$all_exons );
