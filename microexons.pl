#! /usr/bin/env perl
use strict;
use warnings;
# Assume the GFF is split by gene
# Assume also that exon order is from 5' to 3'
# WormBase ParaSite GFF3's have both of these
# Go through genes, if it looks like a microexon gene then print it


my @buffer;
while(<>){
  next if /^#/;
  my @F = split "\t";
  if($F[2] eq "gene"){
     process_gene(@buffer);
     @buffer = ();
  }
  push @buffer, \@F;
}
process_gene(@buffer) if @buffer;

sub process_gene {
  my @lines = @_;
  return unless is_microexon_structure(grep {$_->[2] eq "exon"} @lines);
  for my $line (@lines) {
     my @F = @$line;
     print join ("\t", @F);
     if ($F[2] eq "mRNA"){
       my ($id) = $F[8] =~ /ID=(.*?);/;
       print "#microexons $id: ";
       my $is_ml_previous = 0;
       for my $length (map {$_->[4] - $_->[3] +1} grep {$_->[2] eq "exon" && $_->[8] =~ /Parent=$id/} @lines){
          my $is_ml = is_microexon_length ($length);
          print $is_ml && $is_ml_previous ?"-":" ";
          print $length;
          $is_ml_previous = $is_ml;
       }
       print "\n";
     }
  }
}
sub is_microexon_length {
  my ($length) = @_;
  return $length <= 30 && $length % 3 ==0 ? 1 : 0;
}
sub is_microexon_structure {
  my @scores = map {looks_like_microexon(@$_)} @_;
  return scalar @_ >= 5 && largest_running_total(@scores) >=3;
}

sub looks_like_microexon {
  my $length = $_[4] - $_[3] + 1;
  my $result = is_microexon_length($length);
  print STDERR "looks_like_microexon: $result .".join("\t", @_)
   if $ENV{MICROEXONS_VERBOSE};
  return $result;
}

sub largest_running_total {
  my @scores = @_;
  my $max_total = 0;
  my $current_total = 0;
  for my $s (@scores){
    if($s){
      $current_total +=$s;
    } else {
      $max_total = $current_total if $max_total < $current_total;
      $current_total = 0 ; 
    }
  }
  $max_total = $current_total if $max_total < $current_total;
  print STDERR "largest_running_total: $max_total" . join (",", @scores). "\n"
   if $ENV{MICROEXONS_VERBOSE};
  return $max_total;
}
