process sccaf {
  tag "${sample_collection_label}"
  publishDir "${params.outdir}/sccaf/${sample_collection}/", mode: "${params.sccaf.copy_mode}", overwrite: true,
  saveAs: {filename -> filename.replaceFirst("sccaf_${sample_collection_label}/","") }

  when:
  params.sccaf.run

  input:
  tuple val(sample_collection_label), path(anndata_file_name), val(anndata_slot_for_initial_cluster_assignment), val(accuracy_threshold), val(n_cores)

  output:
  tuple val(sample_collection_label), path("sccaf_${samplename_collection_label}/*"), emit: output_dir
  path("sccaf_${sample_collection_label}/rounds.txt"), emit: optimization_rounds_txt

  script:
  """
  umask 2 # make files group_writable

  sccaf -i ${anndata_file_name} --optimise -s ${anndata_slot_for_initial_cluster_assignment} -a ${accuracy_threshold} -c ${n_cores} --produce-rounds-summary
  # eventually run with --skip-assessment
  # -a: Accuracy threshold for convergence of the optimisation procedure.
  """
}
