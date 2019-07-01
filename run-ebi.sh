#!/usr/bin/bash
perl -MSpeciesFtp -MProductionMysql -E '
for my $species (ProductionMysql->staging->species(@ARGV ? @ARGV : "core_$ENV{PARASITE_VERSION}")){
  my $path = SpeciesFtp->current_staging->path_to($species, "annotations.gff3");
  say join "\t", $species, $path
}
' "$@" | while read -r species path ; do
  echo $species; 
  zcat $path | grep WormBase_imported | ./microexons.pl > results/$species.gff3
  grep -c $'\t'gene results/$species.gff3 
  [ -s results/$species.gff3 ] || rm -v results/$species.gff3
   echo ""
done
