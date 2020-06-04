cwlVersion: v1.0
class: Workflow
doc: |
  This workflow compares two groups of sequences by running two steps: \n
    1. a MSA aligment to calculate a distance matrix \n
    2. generate and plot a phylogenetic tree annotated by group labels \n
  \n
  For more information please see: \n


inputs:
  fasta_1:
    type: File
  fasta_2:
    type: File
  group_name_1:
    type: string
    default: "group1"
  group_name_2:
    type: string
    default: "group2"
  msa_method:
    type: 
      type: enum
      symbols:
        - ClustalW
        - ClustalOmega
        - Muscle
    default: "ClustalW"
  seq_type:
    type: 
      type: enum
      symbols:
        - protein
        - dna
        - rna
    default: "protein"
  distance_method:
    type: 
      type: enum
      symbols:
        - identity
        - similarity
    default: "identity"
  color_by_group:
    type: boolean
    default: True
 
steps:
  calc_msa_and_dist_mat:
      # doc: samtools sort - sorting of filtered bam file by read name
      run: "../tools/calc_msa_and_dist_mat.cwl"
      in:
        fasta_1: fasta_1
        fasta_2: fasta_2
        group_name_1: group_name_1
        group_name_2: group_name_2
        msa_method: msa_method
        seq_type: seq_type
        distance_method: distance_method
      out:
        - dist_tsv
        - dist_rds
       
  generate_tree_and_visualize:
    # doc: bedtools bamtobed
    run: "../tools/generate_tree_and_visualize.cwl"
    in:
      dist_rds:
        source: calc_msa_and_dist_mat/dist_rds
      color_by_group: color_by_group
    out:
      - tree_plot

outputs:
  dist_tsv:
    type: File
    outputSource: calc_msa_and_dist_mat/dist_tsv
  tree_plot:
    type: File
    outputSource: generate_tree_and_visualize/tree_plot