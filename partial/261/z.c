#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
// e_1=0, e_{n+1}=|2e_n - n|; print n with e_n=0; also count fraction of n with 2e_n<n (fold) up to 1e9
int main(int c,char**v){ uint64_t N=strtoull(v[1],0,10); int64_t e=0; uint64_t below=0;
  for(uint64_t n=1;n<N;n++){ if(e==0){printf("%llu\n",(unsigned long long)n);fflush(stdout);}
    int64_t d=2*e-(int64_t)n; if(d<0){d=-d; if(n<1000000000ULL) below++;} e=d; }
  fprintf(stderr,"fold fraction(n<1e9)=%.6f\n",below/1e9); }
