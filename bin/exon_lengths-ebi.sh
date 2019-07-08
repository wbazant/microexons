#!/usr/bin/bash

root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"

perl -MSpeciesFtp -MProductionMysql -E '
for my $species (ProductionMysql->staging->species(@ARGV ? @ARGV : "core_$ENV{PARASITE_VERSION}")){
  my $path = SpeciesFtp->current_staging->path_to($species, "annotations.gff3");
  say join "\t", $species, $path
}
' "$@" | while read -r species path ; do
  echo $species $( zcat $path | grep WormBase_imported | $root_dir/bin/exon_lengths.pl )
done | tr ' ' $'\t' | sort -rg -k3,3 -t $'\t' | cat <( echo "#species   excess proportion of modular exons      excess proportion of short modular exons" ) - > $root_dir/results/exon_lengths_imbalance.tsv
