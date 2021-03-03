params {
  sccaf {
    run = true // whether to run 'sccaf' task
	  remove_workdir = false // // whether to remove all work dirs of this task when workflow{} is finished.
    copy_mode = "rellink" // choose "rellink", "symlink", "move" or "copy".
    // Make sure copy_mode is either "copy" or "move" when remove_workdir = true

    sample_collection_label = "superloading_scrna9323395"
    // sccaf CLI parameters:
	  anndata_slot_clustering = "leiden" // anndata.obs column name (slot) for initial cluster assignments
    accuracy_threshold = "0.91"        // target accuracy for stopping cluster mergers
    }

    on_complete_remove_workdirs = false // will remove work dirs (effectively un-caching) of selected tasks even if completed successfully. Make sure that copy_mode is also set to copy or move.
    on_complete_remove_workdir_failed_tasks = false // will remove work dirs of failed tasks (.exitcode file not 0)
    }
}
