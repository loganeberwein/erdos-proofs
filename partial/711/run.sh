#!/bin/bash
# Build configurations on both cores. Each job: v D K sweeps seed init
cd "$(dirname "$0")"
jobs=()
for K in 3 4 6; do for v in 500 1000 2000 4000 8000 16000 32000 64000 128000; do
  [ $K -eq 6 ] && [ $v -eq 128000 ] && continue
  for s in 1 2; do jobs+=("$v $((v/4)) $K 20 $s r"); done
  jobs+=("$v $((v/4)) $K 20 1 c" "$v $((v/4)) $K 0 9 r")
done; done
printf '%s\n' "${jobs[@]}" | xargs -P 2 -L 1 bash -c './search $0 $1 $2 $3 $4 $5 > cfg/v$0_K$2_sw$3_s$4_$5.txt'
