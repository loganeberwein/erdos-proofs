// Erdős #647: search for n > 24 with max_{m<n} (m + tau(m)) <= n + 2, far past the exhaustive 10^10,
// using the necessary condition proved in the README (item 2'): for n > 72 a solution has n = 4q + 4 with
// q = 2w+1 (branch 1: w, 2w+1, 4w+3, 8w+7 all prime, n = 8w+8) or q = 4w+1
// (branch 2: w, 4w+1, 8w+3, 16w+7 all prime, n = 16w+8).
// For every chain found, the full condition tau(n-k) <= k+2 is checked for 1 <= k <= K by an exact
// segmented divisor-count sieve on [n-K, n); K = 16384 exceeds max tau(m) for m < 2^45 (Nicolas-Robin bound).
// Build: gcc -O3 -march=native -fopenmp chain647.c -o chain647 -lm
// Run:   ./chain647 NMAX [BRANCH]
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
typedef unsigned __int128 u128; typedef uint64_t u64;
static inline u64 mulmod(u64 a,u64 b,u64 m){return (u64)((u128)a*b%m);}
static u64 powmod(u64 a,u64 e,u64 m){u64 r=1;a%=m;while(e){if(e&1)r=mulmod(r,a,m);a=mulmod(a,a,m);e>>=1;}return r;}
static int sprp(u64 n,u64 a){a%=n;if(!a)return 1;u64 d=n-1;int s=0;while(!(d&1)){d>>=1;s++;}u64 x=powmod(a,d,n);if(x==1||x==n-1)return 1;for(int i=1;i<s;i++){x=mulmod(x,x,n);if(x==n-1)return 1;}return 0;}
static int *P; static int NP;
static int isprime(u64 n){ if(n<2)return 0; for(int i=0;i<60&&i<NP;i++){u64 p=P[i]; if(n==p)return 1; if(n%p==0)return 0;} if(n<(u64)P[59]*P[59])return 1;
  static const u64 B[]={2,325,9375,28178,450775,9780504,1795265022}; for(int i=0;i<7;i++) if(!sprp(n,B[i])) return 0; return 1; }
#define K 16384
// exact check: tau(n-k) <= k+2 for all 1<=k<=K (and k<n). Returns smallest failing k, or 0 if none.
static int fullcheck(u64 n, int *mindef_out){
  u64 lo = n>K? n-K : 1; int len=(int)(n-lo);
  u64 *rem=malloc(sizeof(u64)*len); int *tau=malloc(sizeof(int)*len);
  for(int i=0;i<len;i++){rem[i]=lo+i; tau[i]=1;}
  u64 lim=(u64)sqrtl((long double)n)+1;
  for(int i=0;i<NP && (u64)P[i]<=lim;i++){ u64 p=P[i]; u64 st=((lo+p-1)/p)*p;
    for(u64 m=st;m<n;m+=p){ int idx=(int)(m-lo); int e=0; while(rem[idx]%p==0){rem[idx]/=p;e++;} tau[idx]*=(e+1);} }
  int fail=0, mind=1<<30;
  for(int i=0;i<len;i++){ if(rem[i]>1) tau[i]*=2; u64 m=lo+i; int k=(int)(n-m); int def=tau[i]-k; // m + tau(m) - n
    if(def>mind) {} if(def>2 && (!fail || k<fail)) fail=k; }
  // deficit of this n restricted to the window: max(m + tau(m)) - n
  int best=-(1<<30); for(int i=0;i<len;i++){ int k=(int)(n-(lo+i)); int d=tau[i]-k; if(d>best) best=d; }
  *mindef_out=best; free(rem); free(tau); return fail;
}
int main(int argc,char**argv){
  u64 NMAX=(u64)strtold(argv[1],0);
  int SL=5000000; char*c=calloc(SL+1,1); P=malloc(sizeof(int)*SL); NP=0;
  for(int i=2;i<=SL;i++) if(!c[i]){P[NP++]=i; for(long j=(long)i*i;j<=SL;j+=i)c[j]=1;}
  // wheel over primes 3..19 (w odd handled by including 2: w must be odd prime > 19, so w odd)
  const int WP[]={2,3,5,7,11,13,17,19}; u64 M=1; for(int i=0;i<8;i++) M*=WP[i];
  long long A[2][4]={{1,2,4,8},{1,4,8,16}}, C[2][4]={{0,1,3,7},{0,1,3,7}};
  u64 nmul[2]={8,16}, nadd[2]={8,8};
  int b0=0,b1=2; if(argc>2){ b0=atoi(argv[2])-1; b1=b0+1; } // optional: run one branch only (1 or 2)
  for(int br=b0;br<b1;br++){
    u64 WMAX=(NMAX-nadd[br])/nmul[br];
    // small w (<= 19) directly
    // admissible residues mod M
    int *res=malloc(sizeof(int)*M/10+1000000); long nr=0;
    for(u64 r=0;r<M;r++){ int ok=1; for(int i=0;i<8&&ok;i++){ u64 p=WP[i]; for(int f=0;f<4;f++) if((A[br][f]*(r%p)+C[br][f])%p==0){ok=0;break;} } if(ok) res[nr++]=(int)r; }
    long long chains=0, surv=0; u64 lastn=0;
    printf("branch %d: admissible residues %ld / %llu, w <= %llu\n",br+1,nr,(unsigned long long)M,(unsigned long long)WMAX); fflush(stdout);
    // w <= 19 by hand
    for(u64 w=2; w<=19 && w<=WMAX; w++){ int ok=1; for(int f=0;f<4;f++) if(!isprime(A[br][f]*w+C[br][f])) ok=0;
      if(ok){ u64 n=nmul[br]*w+nadd[br]; int md; int fk=fullcheck(n,&md); chains++; printf("small chain w=%llu n=%llu fails_at_k=%d deficit=%d\n",(unsigned long long)w,(unsigned long long)n,fk,md); if(!fk) printf("SOLUTION n=%llu\n",(unsigned long long)n);} }
    #pragma omp parallel for schedule(dynamic,64) reduction(+:chains,surv)
    for(long ri=0; ri<nr; ri++){
      for(u64 w=res[ri]; w<=WMAX; w+=M){ if(w<=19) continue;
        int ok=1;
        for(int i=8;i<200 && ok;i++){ u64 p=P[i]; for(int f=0;f<4;f++){ u64 v=A[br][f]*w+C[br][f]; if(v%p==0 && v!=p){ok=0;break;} } }
        if(!ok) continue;
        for(int f=0;f<4 && ok;f++) if(!isprime(A[br][f]*w+C[br][f])) ok=0;
        if(!ok) continue;
        chains++;
        u64 n=nmul[br]*w+nadd[br]; int md; int fk=fullcheck(n,&md);
        if(!fk){ surv++;
          #pragma omp critical
          { printf("SOLUTION n=%llu (branch %d, w=%llu)\n",(unsigned long long)n,br+1,(unsigned long long)w); fflush(stdout);} }
        else if(md<=6){
          #pragma omp critical
          { printf("near n=%llu branch %d w=%llu window_deficit=%d first_fail_k=%d\n",(unsigned long long)n,br+1,(unsigned long long)w,md,fk); fflush(stdout);} }
      }
    }
    printf("branch %d done: 4-prime chains=%lld solutions=%lld\n",br+1,chains,surv); fflush(stdout);
    free(res);
  }
  return 0;
}
