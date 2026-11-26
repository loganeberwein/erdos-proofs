// Erdős #396: for each k = 1..KMAX, list/count n <= X with n(n-1)...(n-k) | C(2n,n).
// Kummer: v_p(C(2n,n)) = number of carries when adding n + n in base p.
// Condition: for every prime p, sum_{i=0..k} v_p(n-i) <= carries_p(n). A prime p > k divides at most
// one block element, so the check is per element; primes p <= k are summed over the block.
// Factorisation by a smallest-prime-factor table. Build: gcc -O3 -o count396 count396.c
// Run: ./count396 X KMAX   (KMAX <= 63)
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
static uint32_t *spf;
static int carries(uint64_t n,uint64_t p){ int c=0,carry=0; while(n){ uint64_t d=n%p; int s=2*d+carry; carry = s>=(int)p; c+=carry; n/=p; } return c; }
int main(int argc,char**argv){
  uint64_t X=atoll(argv[1]); int KMAX=atoi(argv[2]);
  spf=calloc(X+1,4); for(uint64_t i=2;i<=X;i++) if(!spf[i]){ for(uint64_t j=i;j<=X;j+=i) if(!spf[j]) spf[j]=i; }
  // ok[n] bit k set iff the block n-k..n works (we test k incrementally: block for k extends block for k-1)
  uint64_t cnt[64]={0}; uint64_t first[64]={0};
  for(uint64_t n=2;n<=X;n++){
    // small-prime totals accumulate; we check k = 1..KMAX as long as the condition holds
    int need[64]={0}; // need[p] for p < 64 (k <= 63 so primes <= k < 64)
    for(int k=0;k<=KMAX && k<(int)n;k++){
      uint64_t m=n-k; int ok=1;
      while(m>1){ uint64_t p=spf[m]; int e=0; while(m%p==0){m/=p;e++;}
        if(p<=(uint64_t)KMAX){ need[p]+=e; }
        else if(e>carries(n,p)){ ok=0; break; } }
      if(!ok) break;
      // primes p <= k (< 64): check accumulated need for primes that are <= current k, and for primes > k
      // that are still small (<= KMAX) treat them like large ones for this k
      int good=1;
      for(int p=2;p<=KMAX;p++){ if(!need[p]) continue;
        // need[p] is the exact total exponent of p over the block, so this test is exact for every p <= KMAX
        if(need[p]>carries(n,p)){ good=0; break; } }
      if(!good) break;
      if(k>=1){ cnt[k]++; if(!first[k]) first[k]=n; }
    }
  }
  for(int k=1;k<=KMAX;k++) printf("k=%d: count(n<=%llu)=%llu  smallest n=%llu\n",k,(unsigned long long)X,(unsigned long long)cnt[k],(unsigned long long)first[k]);
  return 0; }
