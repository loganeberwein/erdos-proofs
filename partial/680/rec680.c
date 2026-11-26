// Erdős #680: k(n) = least k >= 1 with lpf(n+k) > k^2 + 1. Lists record values of k(n) for n <= N.
// n is BAD if no k works (only k with k^2+1 < n+k can work, since lpf(n+k) <= n+k).
// lpf via a smallest-prime-factor table (uint32) up to N + 10^5. Build: gcc -O3 -o rec680 rec680.c
// Run: ./rec680 N
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
int main(int argc,char**argv){
  uint64_t N=atoll(argv[1]), M=N+100000;
  uint32_t *spf=calloc(M+1,4);
  for(uint64_t i=2;i<=M;i++) if(!spf[i]) for(uint64_t j=i;j<=M;j+=i) if(!spf[j]) spf[j]=(uint32_t)i;
  uint64_t best=0;
  for(uint64_t n=1;n<=N;n++){
    uint64_t k=1; int found=0;
    for(;k*k+1<n+k;k++){ uint64_t m=n+k; if(m>M){printf("ran past table at n=%llu\n",(unsigned long long)n);return 1;}
      if((uint64_t)spf[m] > k*k+1){found=1;break;} }
    if(!found){ printf("BAD n=%llu (no k works)\n",(unsigned long long)n); continue; }
    if(k>best){ best=k; printf("record: n=%llu k(n)=%llu  n+k=%llu lpf=%u\n",(unsigned long long)n,(unsigned long long)k,(unsigned long long)(n+k),spf[n+k]); fflush(stdout); }
  }
  printf("max k(n) for n<=%llu is %llu\n",(unsigned long long)N,(unsigned long long)best);
  return 0; }
