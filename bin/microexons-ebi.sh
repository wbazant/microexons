#!/usr/bin/bash

root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"

perl -MSpeciesFtp -MProductionMysql -E '
for my $species (ProductionMysql->staging->species(@ARGV ? @ARGV : "core_$ENV{PARASITE_VERSION}")){
  my $path = SpeciesFtp->current_staging->path_to($species, "annotations.gff3");
  say join "\t", $species, $path
}
' "$@" | while read -r species path ; do
  echo " zcat $path | grep WormBase_imported | $root_dir/bin/microexons.pl > $root_dir/results/gff3/$species.gff3 "
done | parallel --will-cite --halt soon,fail=1 --jobs 30 

for result in $root_dir/results/gff3/results/*; do
  [ -s $result ] || rm $result
done

grep \#microexons $root_dir/results/gff3/* | perl -nE 'my @F = split ":"; $F[0]=~s{results/(.*).gff3}{$1}; $F[3] =~s/^\s*//; print join "\t", @F[0,2,3];' > $root_dir/results/all_structures.tsv

grep -c $'\t'gene $root_dir/results/gff3/* | sort -nr -k2 -t : | perl -nE 'chomp; m{gff3/(.*).gff3:(.*)} and say "$1\t$2"' > $root_dir/results/gene_counts.tsv
