# Microexon genes in WormBase ParaSite genomes

## Definition
A gene is a microexon gene if it has a "run" of small exons that are each divisible by three. Specifically, we require:
- at least five exons
- at least three exons in a row that:
  + are under 30 base pairs in length
  + their length is divisible by three

## Motivation
They are potentially remarkable, it's a very non-random structure.

We were originally interested in them for a previous <i>S. mansoni</i> genome paper: [Berriman et al., 2009](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2756445/#S2title).

## Results
`results` contains excerpts of GFF3 annotation file from WormBase ParaSite 14, for genes that we identify as microexon.

