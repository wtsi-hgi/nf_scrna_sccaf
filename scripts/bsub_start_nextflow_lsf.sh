#!/usr/bin/env bash

# clean up previous run files
rm -f *.log
rm -f bsub.o
rm -f bsub.e
rm -f bjob.id

# start Nextflow via bsub:
mem=4000
bsub -G team151 \
     -R'select[mem>${mem}] rusage[mem=${mem}] span[hosts=1]' \
     -M ${mem} \
     -n 2 \
     -o bsub.o -e bsub.e \
     -q basement \
     bash scripts/start_nextflow_lsf.sh > bjob.id

# get process PID
echo "Nextflow Bjob ID saved in file bjob.id"
echo kill with \"bkill ID_number\" command
echo "check logs files bsub.o, bsub.e and .nextflow.log"
