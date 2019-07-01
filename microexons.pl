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
  my @lengths = map {$_->[4] - $_->[3] + 1} @_;
  my @largest_running_series = largest_running_series(map {$_ % 3 ==0 ? $_ : 0} @lengths);
  my $largest_running_series_length = scalar @largest_running_series;
  my $largest_running_series_sum;
  $largest_running_series_sum += $_ for @largest_running_series;
  my $largest_running_series_average = $largest_running_series_length > 0 ? $largest_running_series_sum / $largest_running_series_length: 0;
  my $all_exons = scalar @_;
  my $largest_running_series_total_under_sixty = grep {$_ && $_ < 60 } @largest_running_series;
  return $all_exons >= 7 
    && $largest_running_series_length >= 3 
    && $largest_running_series_length * 2 >= ($all_exons - 2) 
    && $largest_running_series_total_under_sixty > 0.8 * $largest_running_series_length;
}

sub looks_like_microexon {
  my $length = $_[4] - $_[3] + 1;
  my $result = $length % 3 ==0;
  print STDERR "looks_like_microexon: $result .".join("\t", @_)
   if $ENV{MICROEXONS_VERBOSE};
  return $result;
}

sub largest_running_series {
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
