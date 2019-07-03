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
  return unless any_transcript_has_microexon_structure(grep {$_->[2] eq "exon"} @lines);
  for my $line (@lines) {
     my @F = @$line;
     print join ("\t", @F);
     if ($F[2] eq "mRNA"){
       my ($id) = $F[8] =~ /ID=(.*?);/;
       print "#microexons $id: ";
       my $is_ml_previous = 0;
       for my $length (map {$_->[4] - $_->[3] +1} grep {$_->[2] eq "exon" && $_->[8] =~ /Parent=$id/} @lines){
          my $is_ml =  $length % 3 ==0;
          print $is_ml && $is_ml_previous ?"-":" ";
          print $length;
          $is_ml_previous = $is_ml;
       }
       print "\n";
     }
  }
}

sub any_transcript_has_microexon_structure {
  my @exons = @_;
  my %exons_by_parent;
  for my $exon (@exons){
    my ($parent) = $exon->[8] =~ /Parent=([^;]*)/;
    push @{$exons_by_parent{$parent}}, $exon;
  }
  return grep {is_microexon_structure(@$_)} values %exons_by_parent;
}

sub is_microexon_structure {
  my @scores = map {
    my $length = $_->[4] - $_->[3] + 1;
    ($length % 3 ==0  && $length < 70 ) ? 1 : 0
  } @_;
  my $scores_count = grep {$_ } @scores;
  my $all_exons = scalar @_;
  my @series = longest_running_series(@scores);
  return $all_exons >= 7 && $scores_count >= 0.5 * $all_exons && scalar @series >= 4;
}

sub looks_like_microexon {
  my $length = $_[4] - $_[3] + 1;
  my $result = $length % 3 ==0;
  print STDERR "looks_like_microexon: $result .".join("\t", @_)
   if $ENV{MICROEXONS_VERBOSE};
  return $result;
}

sub longest_running_series {
  my @scores = @_;
  my @max_total;
  my @current_total;
  for my $s (@scores){
    if($s){
      push @current_total , $s;
    } else {
      @max_total = @current_total if @max_total < @current_total;
      @current_total = (); 
    }
  }
  @max_total = @current_total if @max_total < @current_total;
  print STDERR "largest_running_series: " . scalar @max_total . " " . join (",", @scores). "\n"
   if $ENV{MICROEXONS_VERBOSE};
  return @max_total;
}
