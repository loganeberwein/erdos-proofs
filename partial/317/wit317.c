// Erdős #317 part 2: for every n in [5, N], exhibit a prime p in (n/2, n] with L/p mod p not in {1, p-1},
// where L = lcm(1..n). By README item 1 this rules out a signed sum equal to ±1/L.
// Residue r_p(n) = prod over primes q != p of q^{floor(log_q n)} mod p  (= L/p mod p for n >= p).
// Witness groups: at a switch point n_s, take the B largest primes <= n_s and compute their residues by one
// sweep over all primes <= n_s; then move n upward, multiplying each residue by q at every prime-power
// event q^e <= n. A group member p stays usable while p > n/2 and r_p is not ±1. When none is usable,
// switch (recompute at the current n). If the B-group finds no witness, retry with 8B, 64B, ... and
// finally all primes in (n/2, n]; a total failure is reported as a SURVIVOR.
// Build: gcc -O3 -march=native wit317.c -o wit317 -lm
// Run:   ./wit317 N        (validation mode: ./wit317 N T, see validate317.py)
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
typedef unsigned __int128 u128; typedef uint64_t u64;
static inline u64 mm(u64 a,u64 b,u64 m){return (u64)((u128)a*b%m);}
static u64 N; static u64 T=1; static u64 SQ; static int *SP; static int NSP; // primes up to sqrt(N)
// segmented prime iterator over [lo, hi)
#define SEG (1u<<22)
typedef void (*cb)(u64 q, void*);
static void each_prime(u64 lo, u64 hi, cb f, void*ctx){
  static unsigned char s[SEG];
  if(lo<2) lo=2;
  for(u64 a=lo; a<hi; a+=SEG){ u64 b=a+SEG<hi? a+SEG:hi; memset(s,0,b-a);
    for(int i=0;i<NSP;i++){ u64 p=SP[i]; if(p*p>=b) break; u64 st=((a+p-1)/p)*p; if(st<p*p) st=p*p; for(u64 j=st;j<b;j+=p) s[j-a]=1; }
    for(u64 x=a;x<b;x++) if(!s[x-a]) f(x,ctx); }
}
static int is_small_prime_based(u64 x){ if(x<2) return 0; for(int i=0;i<NSP && (u64)SP[i]*SP[i]<=x;i++) if(x%SP[i]==0) return 0; return 1; }
typedef struct { int m; u64 p[1<<16]; u64 r[1<<16]; u64 n; } grp;
static grp G;
static u64 qpow_le(u64 q, u64 n){ u64 v=q, e=1; (void)e; while((u128)v*q<=n) v*=q; return v; } // q^{floor(log_q n)}
static void sweep_cb(u64 q, void*ctx){ grp*g=ctx; u64 v=qpow_le(q,g->n); for(int i=0;i<g->m;i++) if(g->p[i]!=q) g->r[i]=mm(g->r[i], v % g->p[i], g->p[i]); }
// collect largest primes <= n into group (count m), restricted to p > n/2
static void build(u64 n, int m){
  G.m=0; G.n=n;
  for(u64 x=n; x>n/2 && G.m<m; x--) if(is_small_prime_based(x)){ G.p[G.m]=x; G.r[G.m]=1; G.m++; }
  each_prime(2, n+1, sweep_cb, &G);
}
// T = 1 is the real test (forbidden residues 1 and p-1); larger T widens the forbidden band [1,T] U [p-T,p-1] for validation only
static int usable(int i,u64 n){ u64 p=G.p[i], r=G.r[i]; return p>n/2 && p<=n && !(r>=1 && r<=T) && !(r+T>=p); }
static int any_usable(u64 n){ for(int i=0;i<G.m;i++) if(usable(i,n)) return 1; return 0; }
// events: prime powers q^e (e>=1) in increasing order; at each, multiply residues by q (skip p==q).
typedef struct { u64 v,q; } ev; static ev *H; static size_t HN;
static int cmpev(const void*a,const void*b){u64 x=((ev*)a)->v,y=((ev*)b)->v;return x<y?-1:x>y;}
static u64 cur; static long long switches=0, fallbacks=0, survivors=0;
static void check_range(u64 a, u64 b){ // all n in [a,b] have the same residues; verify a witness exists for each n
  // usability changes only at n = 2p; walk the breakpoints
  u64 n=a;
  while(n<=b){
    if(!any_usable(n)){
      switches++;
      int m=8; for(;;){ build(n, m); if(any_usable(n)) break; fallbacks++;
        if(G.m < m){ survivors++; printf("SURVIVOR n=%llu (no witness among all primes in (n/2,n])\n",(unsigned long long)n); fflush(stdout); break; }
        if(m==(1<<16)){ printf("GROUP LIMIT at n=%llu\n",(unsigned long long)n); survivors++; break; }
        m*=8; if(m>(1<<16)) m=1<<16; }
    }
    // next breakpoint: smallest 2p > n among usable members
    if(!any_usable(n)){ n++; continue; } // survivor already reported; check the next n
    u64 nb=b+1; for(int i=0;i<G.m;i++) if(usable(i,n)){ u64 e=2*G.p[i]; if(e<nb) nb=e; }
    // all n in [n, nb-1] keep that member usable? only that member; recheck at nb
    n=nb;
  }
}
int main(int argc,char**argv){
  N=(u64)strtold(argv[1],0); if(argc>2) T=strtoull(argv[2],0,10);
  SQ=(u64)sqrtl((long double)N)+2;
  char*c=calloc(SQ+1,1); SP=malloc(sizeof(int)*(SQ+1)); NSP=0;
  for(u64 i=2;i<=SQ;i++) if(!c[i]){SP[NSP++]=(int)i; for(u64 j=i*i;j<=SQ;j+=i)c[j]=1;}
  // higher prime powers q^e, e>=2, <= N
  size_t cap=1<<20; H=malloc(sizeof(ev)*cap); HN=0;
  for(int i=0;i<NSP;i++){ u64 q=SP[i]; u128 v=(u128)q*q; while(v<=N){ if(HN==cap){cap*=2;H=realloc(H,sizeof(ev)*cap);} H[HN].v=(u64)v; H[HN].q=q; HN++; v*=q; } }
  qsort(H,HN,sizeof(ev),cmpev);
  // initial state at n = 4: lcm(1..4)=12; start group empty so first check builds
  G.m=0; cur=4;
  // main merge of primes > 4 and higher powers > 4, in segments
  size_t hi=0; while(hi<HN && H[hi].v<=4) hi++;
  static unsigned char s[SEG];
  for(u64 a=5; a<=N; a+=SEG){ u64 b=a+SEG<=N+1? a+SEG : N+1; memset(s,0,b-a);
    for(int i=0;i<NSP;i++){ u64 p=SP[i]; if(p*p>=b) break; u64 st=((a+p-1)/p)*p; if(st<p*p) st=p*p; for(u64 j=st;j<b;j+=p) s[j-a]=1; }
    for(u64 x=a;x<b;x++){
      int isp=!s[x-a]; int isH = (hi<HN && H[hi].v==x);
      if(!isp && !isH) continue;
      if(x>cur+1) check_range(cur+1,x-1);
      u64 q = isp? x : H[hi].q; if(isH) hi++;
      for(int i=0;i<G.m;i++) if(G.p[i]!=q) G.r[i]=mm(G.r[i], q % G.p[i], G.p[i]);
      check_range(x,x); cur=x;
    }
    if(((a/SEG)&255)==0){ fprintf(stderr,"n=%llu switches=%lld\n",(unsigned long long)b,switches); }
  }
  if(cur<N) check_range(cur+1,N);
  printf("N=%llu: every n in [5,N] has a witness prime p in (n/2,n] with L/p mod p not in {1,p-1}; group rebuilds=%lld, enlargements=%lld, survivors=%lld\n",
    (unsigned long long)N,switches,fallbacks,survivors);
  return 0;
}
