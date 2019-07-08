# Microexon genes in WormBase ParaSite genomes
[![DOI](https://zenodo.org/badge/194257264.svg)](https://zenodo.org/badge/latestdoi/194257264)
## About microexon genes
### Introduction

Flatworm gene structures are frequently made up of many tiny exons. Sometimes, they are all in phase, e.g. <a href="https://parasite.wormbase.org/Schistosoma_mansoni_prjea36577/Transcript/Exons?db=core;g=Smp_347450;r=SM_V7_ZW:52788190-52810835;t=Smp_347450.1">Exons of Smp_347450.1 in <i>S. mansoni</i></a> have lengths:
```
211-30-30-30-30-63-63-54-42-54-69-45-60-63-69-57-69-360
```

These strings of modular exons (each having length divisible by three) could be remarkable or interesting. We attempt to list them, using data from WormBase ParaSite 14.

### Definition
We say an exon is **modular** if its length is divisible modulo three, and we consider it a **short modular exon** if its length is divisible modulo three and it is under 70 base pairs, e.g. 15 or 63 bp. We say a gene is a **microexon gene** if:
- it has at least seven exons
- short modular exons constitute at least half of all exons
- it has at least four short modular exons in a row

This does not include genes with single short modular exons, but they are also being studied and many were identified in model organisms. For example, <a href="https://www.ncbi.nlm.nih.gov/pubmed/28188674">Ustianenko et al (2017)</a> are interested in genes where at least one exon is modular and of length between 3 to 30 nt.

<a href="https://www.ncbi.nlm.nih.gov/pubmed/19606141">Berriman et al. (2009)</a> define microexon genes as those with at least of 75% exons have lengths from 3 to 36 and divisible by three. We extend this slightly - including longer exons seems to provide more instances of the structure we observe. 

### Significance of modular exons
Exons of lengths divisible by three do not change the phase when translating through them, hence an exon dropping in or out does not terminate translation early and so largely preserves the sequence of the resulting protein. This means a point mutation or exon shuffling is more likely to result in a small change in the protein, and so there is more opportunity for modular exons to be part of incremental adaptations during evolution.

Modular exons can also be spliced in and out through a regulation mechanism. This is likely the case for SmPoMucs (<a href="https://parasite.wormbase.org/Schistosoma_mansoni_prjea36577/Gene/Summary?g=Smp_214320">Smp_214320</a>, <a href="https://parasite.wormbase.org/Schistosoma_mansoni_prjea36577/Gene/Summary?g=Smp_348010">Smp_348010</a>), a family of microexon genes in <i>S. mansoni</i>, responsible for secreted proteins that play a role in host invasion. Experiments confirm this: <a href="ncbi.nlm.nih.gov/pubmed/28253264">Galinier et al. (2017)</a> show that alternative splicing of SmPoMucs found between between two <a>S. mansoni</a> strains toggles host compatibility.

### Significance of multiple short modular exons being next to each other
Additional advantages of modular exons being short, of many modular exons being to each other, are less clear to us.

There's a theory of "controlled chaos" for <i>S. mansoni</i> (<a href="ncbi.nlm.nih.gov/pubmed/19002242">Roger et al. (2008)</a>), postulating a high degree of polymorphism based on a relatively low number of genes, giving the parasite an advantage in co-evolving against the host. However, we also see microexon genes in <i>Schmidtea mediterranea</i>, a free-living planarian: therefore microexon genes are not solely an adaptation for parasitism.

## Results
The results are available in this repository, in the `results` folder:
```
results/all_structures.tsv
results/exon_lengths_imbalance.tsv
results/gene_counts.tsv
results/gff3
```

### Microexon structures
We provide structures of microexon transcripts in one file: lengths with dashes drawn between numbers divisible by three:
#### `all_structures.tsv`:
```
...
schistosoma_mansoni_prjea36577	Smp_124000.1	101 22 24-24-24-24-21-24-21-15-24-24-6-15-27-21-21 194
...
schmidtea_mediterranea_prjna379262	SMEST077924001	142 315-288 203 90-93-51-33-27-24-24-18-24-24-15-24-27 40 116
schmidtea_mediterranea_prjna379262	SMEST077924004	152 315-288-339 203 90-93-51-33-27-24-24-18-24-21-15-24-27 56 98
...
```
<i>M. floridensis</i> has the most "microexon genes" by our method, as the unique <i>Meloidogyne</i> species. Flatworms come up high in the list, and there are also many results for outgroups of <i>Pristionchus pacificus</i>, all from the same sequencing project.
#### `counts.tsv`:
```
meloidogyne_floridensis_prjeb6016	253
pristionchus_japonicus_prjeb27334	127
pristionchus_arcanus_prjeb27334 123
pristionchus_mayeri_prjeb27334	119
parapristionchus_giblindavisi_prjeb27334	118
opisthorchis_felineus_prjna413383	118
schistosoma_mansoni_prjea36577	109
gyrodactylus_salaris_prjna244375	97
pristionchus_maxplancki_prjeb27334	95
pristionchus_entomophagus_prjeb27334	86
pristionchus_fissidentatus_prjeb27334	85
clonorchis_sinensis_prjna386618 82
pristionchus_exspectatus_prjeb24288	77
hymenolepis_microstoma_prjeb124 76
schmidtea_mediterranea_prjna379262	67
...
```
### Imbalance in exon length distribution
To focus on genomes where microexon genes are not likely to be a mere annotation artifact, we study distributions of exon lengths modulo three. 

We see that in the majority of our genomes, there are more than a third of modular exons: around three eights. 

Comparing this ratio to the same ratio for short exons lets us reject <i>M. floridensis</i> or the <i>Pristionchus</i> genomes as evidence that these species have unusually many microexon genes. If properties of an exon being short and being modular are of common consequence, the fraction of short modular exons should be a fraction of exons that are short, multiplied by the fraction of exons that are modular. When sorting all WormBase ParaSite genomes by excess proportion of short modular exons, the highest values are all for flatworms, but <i>M. floridensis</i> or the <i>Pristionchus</i> genomes do not stand out by that proportion.

#### `exon_lengths_imbalance.tsv`:
```
#species   excess proportion of modular exons      excess proportion of short modular exons
macrostomum_lignano_prjna371498	0.003	0.126
opisthorchis_felineus_prjna413383	0.057	0.125
schmidtea_mediterranea_prjna379262	0.068	0.113
schistosoma_mansoni_prjea36577	0.034	0.090
hymenolepis_microstoma_prjeb124	0.104	0.082
parastrongyloides_trichosuri_prjeb515	0.075	0.080
caenorhabditis_elegans_prjna13758	0.054	0.077
caenorhabditis_briggsae_prjna10731	0.057	0.067
clonorchis_sinensis_prjna386618	0.079	0.064
...
```

## Limitations

Predictive models in annotation tools like AUGUSTUS use exon length and phase to formulate a pattern that is later used to identify genes.

Hence studying genomes on the basis of summary statistics like exon lengths and phase is potentially confounded, and likely to be more informative of the annotation method than the real structure of the genome. There might be a bias towards spurious predictions of microexon genes, or real microexon genes be frequently skipped because of their different structure.

One way to overcome this would be to restrict the search for microexon genes to genomes annotated created using ESTs or RNASeq data, or genomes that went through manual curation.

## Conclusion
We do think there is a phenomenon of microexon genes existing in flatworms. Our evidence towards this is based on the unlikeliness of a series of exons being short and modular, without a common generation mechanism or positive selection for such a pattern. We see the following:
- overabundance of microexon genes: flatworms come up at the top of `counts.tsv`
- overabundance of short exons that are modular: flatworms come up at the top of `exon_lengths_imbalance.tsv`

We are unable to say much about any individual microexon gene on our list, other that its structure is following the pattern we defined. However, the list taken as a whole could be enriched for other consequences of a generation mechanism or positive selection towards microexon genes, if it exists.
## Future work
More data could be cross-checked against our list of microexon genes: whether they are secreted, expressed in particular life stages, or whether different isoforms exist in different strains like in the case of SmPoMucs.

Extrapolating from <i>S. mansoni</i>, <i>H. microstoma</i>, and <i>S. mediterranea</i>, there are likely to be more microexon genes to be found in other flatworms missing from their current annotations - a potential motivation for further annotation projects.
