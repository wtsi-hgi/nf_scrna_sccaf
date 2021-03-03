#!/usr/bin/env bash

mem=2400
queue=yesterday

# clean up previous run files
rm -f *.log
rm -f bsub.o
rm -f bsub.e
rm -f bjob.id

# start Nextflow via bsub:
bsub -G team151 \
     -R"select[mem>${mem}] rusage[mem=${mem}] span[hosts=1]" \
     -M ${mem} \
     -n 2 \
     -o bsub.o -e bsub.e \
     -q ${queue} \
     bash ./example_runtime/scripts/start_nextflow_lsf.sh > bjob.id

# get process PID
echo "Nextflow Bjob ID saved in file bjob.id"
echo kill with \"bkill ID_number\" command
echo "check logs files bsub.o, bsub.e and .nextflow.log"
