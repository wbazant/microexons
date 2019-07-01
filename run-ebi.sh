#!/usr/bin/bash
perl -MSpeciesFtp -MProductionMysql -E '
for my $species (ProductionMysql->staging->species(@ARGV ? @ARGV : "core_$ENV{PARASITE_VERSION}")){
  my $path = SpeciesFtp->current_staging->path_to($species, "annotations.gff3");
  say join "\t", $species, $path
}
' "$@" | while read -r species path ; do
  echo " zcat $path | grep WormBase_imported | ./microexons.pl > results/$species.gff3 "
done | parallel --will-cite --progress  --halt soon,fail=1 --jobs 30 

for result in results/*; do
  [ -s $result ] || rm $result
done
