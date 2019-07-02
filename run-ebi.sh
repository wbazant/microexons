#!/usr/bin/bash
perl -MSpeciesFtp -MProductionMysql -E '
for my $species (ProductionMysql->staging->species(@ARGV ? @ARGV : "core_$ENV{PARASITE_VERSION}")){
  my $path = SpeciesFtp->current_staging->path_to($species, "annotations.gff3");
  say join "\t", $species, $path
}
' "$@" | while read -r species path ; do
  echo " zcat $path | grep WormBase_imported | ./microexons.pl > results/$species.gff3 "
done | parallel --will-cite --halt soon,fail=1 --jobs 30 

for result in results/*; do
  [ -s $result ] || rm $result
done

grep \#microexons results/* | perl -nE 'my @F = split ":"; $F[0]=~s{results/(.*).gff3}{$1}; $F[3] =~s/^\s*//; print join "\t", @F[0,2,3];' > all-structures.tsv

echo "#grep -c \$'\\t'gene results/* | sort -nr -k2 -t : " > counts.txt
grep -c $'\t'gene results/* | sort -nr -k2 -t : >> counts.txt
