#!/usr/bin/env bash

# activate Nextflow conda env
# conda init bash
# eval "$(conda shell.bash hook)"
# conda activate nextflow

# run nextflow main.nf with inputs and lsf config:
export NXF_OPTS="-Xms2G -Xmx2G"
nextflow run ./nextflow_ci/pipelines/main.nf \
      -c ./nextflow_ci/nextflow.config -c inputs.nf -profile lsf \
      --nf_ci_loc $PWD -resume
