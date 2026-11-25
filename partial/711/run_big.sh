#!/bin/bash
# Extra sizes for the K=3/K=4 fits (one restart each, 15 sweeps), two cores.
cd "$(dirname "$0")"
printf '%s\n' "512000 128000 3 15 1 r" "256000 64000 3 15 1 r" "256000 64000 4 15 1 r" "512000 128000 3 0 9 r" "256000 64000 3 0 9 r" "256000 64000 4 0 9 r" \
 | xargs -P 2 -L 1 bash -c './search $0 $1 $2 $3 $4 $5 > cfg/v$0_K$2_sw$3_s$4_$5.txt'
