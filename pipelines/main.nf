nextflow.enable.dsl=2

// All inputs are read from Nextflow config file "inputs.nf",
//  which is located in upstream Gitlab "nextflow_ci" repo (at same branch name).
// Meaning that if you wish to run pipeline with different parameters,
// you have to edit+commit+push that "inputs.nf" file, then rerun the pipeline.

// main SCCAF pipeline once input channels are prepared:
//include { main_sccaf } from './main_sccaf.nf'
include { sccaf } from "${projectDir}/../modules/sccaf.nf"

/* process send_input_params_as_tuple_over_channel {
  output:
    tuple (
      path(params.sccaf_anndata_h5filnam),
      val(params.sccaf_anndata_slot),
      val(params.sccaf_accuracy_threshold),
      val(params.sccaf_sample_collection_label)
    ), emit: sscaf_meta_data
}
*/

workflow {

    log.info "input parameters are: $params"

    ch_anndata_file_clustering = Channel.fromPath(params.sccaf.anndata_h5filnam)
    ch_anndata_file_clustering.view()

    // run main sccaf pipeline:
    //ch_in = send_input_params_as_tuple_over_channel()
    sccaf(ch_anndata_file_clustering)

}

workflow.onError {
    log.info "Pipeline execution stopped with the following message: ${workflow.errorMessage}" }

workflow.onComplete {
    log.info "Pipeline completed at: $workflow.complete"
    log.info "Command line: $workflow.commandLine"
    log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"

    if (params.on_complete_remove_workdirs) {
	log.info "You have selected \"on_complete_remove_workdirs = true\"; will therefore attempt to remove work dirs of selected tasks (even if completed successfully.)"
	if (! file("${params.outdir}/work_dirs_to_remove.csv").isEmpty()) {
	    log.info "file ${params.outdir}/work_dirs_to_remove.csv exists and not empty ..."
	    file("${params.outdir}/work_dirs_to_remove.csv")
		.eachLine {  work_dir ->
		if (file(work_dir).isDirectory()) {
		    log.info "removing in work dir $work_dir ..."
		    file(work_dir).deleteDir()
		} } } }

    if (params.on_complete_remove_workdir_failed_tasks) {
	log.info "You have selected \"on_complete_remove_workdir_failed_tasks = true\"; will therefore remove work dirs of all tasks that failed (.exitcode file not 0)."
	// work dir and other paths are hardcoded here ... :
	def proc = "bash ./nextflow_ci/bin/del_work_dirs_failed.sh ${workDir}".execute()
	def b = new StringBuffer()
	proc.consumeProcessErrorStream(b)
	log.info proc.text
	log.info b.toString() }
}
