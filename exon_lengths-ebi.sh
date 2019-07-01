#!/usr/bin/bash
perl -MSpeciesFtp -MProductionMysql -E '
for my $species (ProductionMysql->staging->species(@ARGV ? @ARGV : "core_$ENV{PARASITE_VERSION}")){
  my $path = SpeciesFtp->current_staging->path_to($species, "annotations.gff3");
  say join "\t", $species, $path
}
' "$@" | while read -r species path ; do
  echo $species $( zcat $path | grep WormBase_imported | ./exon_lengths.pl i)
done | sort -rg -k3,3 > exon_lengths_imbalance.tsv
