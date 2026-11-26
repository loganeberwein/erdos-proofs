// Erdős #458: find every prime gap (p_k, p_{k+1}) below LIMIT containing >= 2 proper prime powers.
// #458 at k fails iff the product of the bases of the powers strictly inside (p_k, p_{k+1}) is >= p_k.
// A single power q^a has q < sqrt(p_{k+1}) < p_k, so only gaps holding >= 2 powers can fail.
// Method: list all proper prime powers q^a (a >= 2) below LIMIT in increasing order; for each consecutive
// pair (P1, P2) decide whether a prime lies strictly between them (deterministic 64-bit Miller-Rabin).
// Pairs with no prime between them chain into groups lying in one gap; each group is reported with
// p_k = prevprime(first power) and the ratio (product of bases)/p_k.
// Parallel: the range of square bases q is split into NCHUNK chunks processed by an OpenMP loop.
// Build: gcc -O3 -march=native -fopenmp gaps458.c -o gaps458 -lm
// Run:   ./gaps458 LIMIT_LOG2_OR_DECIMAL   e.g. ./gaps458 1e16   or  ./gaps458 2^64
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
typedef unsigned __int128 u128;
typedef uint64_t u64;

static inline u64 mulmod(u64 a, u64 b, u64 m){ return (u64)((u128)a*b % m); }
static u64 powmod(u64 a, u64 e, u64 m){ u64 r=1; a%=m; while(e){ if(e&1) r=mulmod(r,a,m); a=mulmod(a,a,m); e>>=1;} return r; }
static int sprp(u64 n, u64 a){ a%=n; if(!a) return 1; u64 d=n-1; int s=0; while(!(d&1)){d>>=1;s++;}
  u64 x=powmod(a,d,n); if(x==1||x==n-1) return 1; for(int i=1;i<s;i++){ x=mulmod(x,x,n); if(x==n-1) return 1; } return 0; }
static const int SP[]={2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97};
static int isprime(u64 n){
  if(n<2) return 0;
  for(int i=0;i<25;i++){ if(n==(u64)SP[i]) return 1; if(n%SP[i]==0) return 0; }
  if(n<9409) return 1;
  static const u64 B[]={2,325,9375,28178,450775,9780504,1795265022}; // Sinclair: deterministic below 2^64
  for(int i=0;i<7;i++) if(!sprp(n,B[i])) return 0;
  return 1;
}
// is there a prime p with lo < p < hi ?
static int prime_between(u64 lo, u64 hi){ for(u64 n=lo+1; n<hi; n++) if(isprime(n)) return 1; return 0; }
static u64 prevprime(u64 n){ for(u64 m=n-1;;m--) if(isprime(m)) return m; }

typedef struct { u64 v; u64 base; } pw;
static int cmp(const void*a,const void*b){ u64 x=((pw*)a)->v,y=((pw*)b)->v; return x<y?-1:x>y; }

static u64 LIMIT; static int FULL64=0; static int straddles=0; // a straddle means counts are not exact: the program then exits non-zero
static int below(u64 v){ return FULL64 ? 1 : v < LIMIT; }

// small prime list up to 2^16 for segmented sieving of bases up to 2^32
static int *smallp; static int nsmall;

int main(int argc,char**argv){
  if(argc<2){ fprintf(stderr,"usage: %s LIMIT (e.g. 1e16 or 2^64)\n",argv[0]); return 1; }
  u64 QMAX; // square bases q < QMAX
  if(!strcmp(argv[1],"2^64")){ FULL64=1; QMAX=4294967296ULL; LIMIT=0; }
  else { long double L=strtold(argv[1],0); LIMIT=(u64)L; QMAX=(u64)sqrtl(L); while((u128)QMAX*QMAX<LIMIT) QMAX++; while(QMAX>0 && (u128)(QMAX-1)*(QMAX-1)>=LIMIT) QMAX--; }
  // QMAX: smallest integer with QMAX^2 >= LIMIT (bases q < QMAX give q^2 < LIMIT)
  int SL=65536; char*c=calloc(SL+1,1); smallp=malloc(sizeof(int)*SL); nsmall=0;
  for(int i=2;i<=SL;i++){ if(!c[i]){ smallp[nsmall++]=i; for(long j=(long)i*i;j<=SL;j+=i) c[j]=1; } }
  // higher powers q^a, a>=3, below LIMIT (or 2^64): bases up to cube root
  size_t hcap=1<<20, hn=0; pw*H=malloc(sizeof(pw)*hcap);
  u64 cr=(u64)cbrtl(FULL64? 18446744073709551615.0L : (long double)LIMIT)+2;
  char*cc=calloc(cr+1,1);
  for(u64 q=2;q<=cr;q++){ if(cc[q]) continue; for(u64 j=q*q;j<=cr;j+=q) cc[j]=1;
    u128 v=(u128)q*q*q; while(v < ((u128)1<<64) && (FULL64 || (u64)v<LIMIT)){ if(hn==hcap){hcap*=2;H=realloc(H,sizeof(pw)*hcap);} H[hn].v=(u64)v; H[hn].base=q; hn++; v*=q; } }
  qsort(H,hn,sizeof(pw),cmp);
  int NCHUNK=256; u64 step=(QMAX+NCHUNK-1)/NCHUNK;
  u64 tot_pow=0, tot_g1=0, tot_g2=0, tot_sq=0;
  long double worst=0; u64 worst_pk=0;
  FILE*out=stdout;
  #pragma omp parallel for schedule(dynamic,1) reduction(+:tot_pow,tot_g1,tot_g2,tot_sq)
  for(int ch=0; ch<NCHUNK; ch++){
    u64 qlo = (u64)ch*step, qhi=(u64)(ch+1)*step; if(qlo<2) qlo=2; if(qhi>QMAX) qhi=QMAX; if(qlo>=qhi) continue;
    // value range of this chunk: [qlo^2, qhi^2) ; last chunk extends to LIMIT (or 2^64)
    u128 Vlo=(u128)qlo*qlo, Vhi=(ch==NCHUNK-1||qhi==QMAX)? (FULL64? ((u128)1<<64) : (u128)LIMIT) : (u128)qhi*qhi;
    if(ch==0) Vlo=0;
    // sieve bases [qlo, qhi)
    u64 len=qhi-qlo; char*s=calloc(len,1);
    for(int i=0;i<nsmall;i++){ u64 p=smallp[i]; if(p*p>=qhi) break; u64 st=((qlo+p-1)/p)*p; if(st<p*p) st=p*p; for(u64 j=st;j<qhi;j+=p) s[j-qlo]=1; }
    // merge squares with higher powers in [Vlo,Vhi)
    size_t hi_i=0; { size_t a=0,b=hn; while(a<b){ size_t m=(a+b)/2; if((u128)H[m].v<Vlo) a=m+1; else b=m; } hi_i=a; }
    u64 qi=0; while(qi<len && s[qi]) qi++;
    // group state
    u64 prev=0, gfirst=0; int gcount=0; long double gprod=1; u64 nloc_pow=0,nloc_g1=0,nloc_g2=0,nloc_sq=0;
    static __thread char buf[1<<16]; int bl=0; buf[0]=0; // groups are rare (5 below 2^64); 64 KB is ample
    for(;;){
      u64 v,b; int have=0;
      u128 sv = (qi<len)? (u128)(qlo+qi)*(qlo+qi) : (u128)-1;
      u128 hv = (hi_i<hn && (u128)H[hi_i].v<Vhi)? (u128)H[hi_i].v : (u128)-1;
      if(sv==(u128)-1 && hv==(u128)-1) break;
      if(sv<hv){ v=(u64)sv; b=qlo+qi; qi++; while(qi<len && s[qi]) qi++; nloc_sq++; }
      else { v=(u64)hv; b=H[hi_i].base; hi_i++; }
      have=1; (void)have;
      nloc_pow++;
      if(prev && !prime_between(prev,v)){ gcount++; gprod*=b; }
      else {
        if(gcount>=2){ nloc_g2++; u64 pk=prevprime(gfirst); long double r=gprod/pk;
          bl+=snprintf(buf+bl,sizeof(buf)-bl,"GROUP p_k=%llu first=%llu count=%d prod=%.0Lf ratio=%.6Lg\n",(unsigned long long)pk,(unsigned long long)gfirst,gcount,gprod,r); }
        if(prev) nloc_g1++;
        gfirst=v; gcount=1; gprod=b;
      }
      prev=v;
    }
    // finish the last group of this chunk: it may continue into the next chunk's first power
    // (handled conservatively: check the pair (prev, first power of next range) and report any straddle)
    {
      u64 nq=qhi; // next square base: next prime >= qhi
      while(!isprime(nq)) nq++;
      u128 ns=(u128)nq*nq; u128 nh=(hi_i<hn)? (u128)H[hi_i].v : (u128)-1;
      u128 nxt = ns<nh? ns: nh;
      int straddle = (nxt < ((u128)1<<64)) && (FULL64 || nxt<(u128)LIMIT) && prev && !prime_between(prev,(u64)nxt);
      if(straddle){
        #pragma omp atomic
        straddles++;
      } if(straddle) bl+=snprintf(buf+bl,sizeof(buf)-bl,"STRADDLE chunk=%d prev=%llu next=%llu (group continues)\n",ch,(unsigned long long)prev,(unsigned long long)(u64)nxt);
      if(gcount>=2){ nloc_g2++; u64 pk=prevprime(gfirst);
        bl+=snprintf(buf+bl,sizeof(buf)-bl,"GROUP p_k=%llu first=%llu count=%d prod=%.0Lf ratio=%.6Lg\n",(unsigned long long)pk,(unsigned long long)gfirst,gcount,gprod,gprod/pk); }
      if(prev) nloc_g1++;
    }
    free(s);
    tot_pow+=nloc_pow; tot_g1+=nloc_g1; tot_g2+=nloc_g2; tot_sq+=nloc_sq;
    #pragma omp critical
    { fputs(buf,out); fprintf(stderr,"chunk %d done powers=%llu\n",ch,(unsigned long long)nloc_pow); fflush(out); }
  }
  printf("LIMIT=%s powers=%llu (squares %llu, higher %llu) gaps_with_>=1_power=%llu gaps_with_>=2_powers=%llu\n",
    argv[1],(unsigned long long)tot_pow,(unsigned long long)tot_sq,(unsigned long long)(tot_pow-tot_sq),(unsigned long long)tot_g1,(unsigned long long)tot_g2);
  if(straddles){ printf("WARNING: %d chunk-boundary straddles; counts above are not exact\n",straddles); return 2; }
  return 0;
}
