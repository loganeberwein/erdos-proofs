// Erdős #366 search. Enumerates every 3-full m <= N as m = a^3 b^4 c^5 (b, c squarefree, coprime;
// unique representation) and tests whether m-1 is 2-full (the problem) and whether m+1 is 2-full
// (the reverse pairs, used as validation: must find 8 and 12167).
// 2-full test of x: strip every prime p <= B (B^5 >= x); a prime dividing exactly once => not 2-full.
// The leftover r has all prime factors > B and r < B^5, so r is 2-full iff r is 1, a square, or a cube.
// Build: gcc -O3 -fopenmp -o search366 search366.c -lm   Run: ./search366 N_exponent
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
typedef unsigned __int128 u128;
static int *pr; static int np; static uint64_t *pw64; // 2^64 mod p
static uint32_t modp(u128 x,int i){uint64_t hi=x>>64,lo=(uint64_t)x;uint32_t p=pr[i];
  return (uint32_t)(( (u128)(hi%p)*pw64[i] + lo%p)%p);}
static u128 isqrt128(u128 x){ if(!x) return 0; u128 r=(u128)sqrtl((long double)x);
  while(r*r>x) r--; while((r+1)*(r+1)<=x) r++; return r;}
static u128 icbrt128(u128 x){ if(!x) return 0; u128 r=(u128)cbrtl((long double)x);
  while(r*r*r>x) r--; while((r+1)*(r+1)*(r+1)<=x) r++; return r;}
static int twofull(u128 x){ if(x==0) return 0;
  for(int i=0;i<np;i++){ uint32_t p=pr[i]; if(modp(x,i)) continue;
    x/=p; if(modp(x,i)) return 0; do x/=p; while(!modp(x,i)); if(x==1) return 1; }
  if(x==1) return 1; u128 s=isqrt128(x); if(s*s==x) return 1; u128 c=icbrt128(x); return c*c*c==x;}
static int sqfree(uint64_t n){for(uint64_t p=2;p*p<=n;p++){if(n%(p*p)==0)return 0;} return 1;}
static uint64_t gcd(uint64_t a,uint64_t b){while(b){uint64_t t=a%b;a=b;b=t;}return a;}
int main(int argc,char**argv){
  int e=atoi(argv[1]); u128 N=1; for(int i=0;i<e;i++) N*=10;
  long double Bd=powl((long double)N*1.0000001L,0.2L)+2; int B=(int)Bd;
  char*s=calloc(B+1,1); pr=malloc(sizeof(int)*(B+1)); np=0;
  for(int i=2;i<=B;i++) if(!s[i]){pr[np++]=i; for(long j=(long)i*i;j<=B;j+=i) s[j]=1;}
  pw64=malloc(8*np); for(int i=0;i<np;i++){ u128 t=((u128)1<<64)%pr[i]; pw64[i]=(uint64_t)t; }
  long double Nl=(long double)N;
  uint64_t cmax=(uint64_t)powl(Nl,0.2L)+1;
  long long cnt=0, hits=0, rev=0;
  for(uint64_t c=1;c<=cmax;c++){ if(!sqfree(c)) continue; u128 c5=(u128)c*c*c*c*c; if(c5>N) break;
    uint64_t bmax=(uint64_t)powl(Nl/(long double)c5,0.25L)+1;
    #pragma omp parallel for schedule(dynamic,1) reduction(+:cnt,hits,rev)
    for(uint64_t b=1;b<=bmax;b++){ if(!sqfree(b)||gcd(b,c)!=1) continue; u128 k=(u128)b*b*b*b*c5; if(k>N) continue;
      uint64_t amax=(uint64_t)cbrtl(Nl/(long double)k)+2;
      for(uint64_t a=1;a<=amax;a++){ u128 m=(u128)a*a*a*k; if(m>N) break; cnt++;
        if(m>1 && twofull(m-1)){ hits++;
          #pragma omp critical
          { unsigned long long lo=(unsigned long long)((m-1)%1000000000000000000ULL), hi=(unsigned long long)((m-1)/1000000000000000000ULL);
            printf("HIT n=%llu%018llu (2-full) n+1 3-full\n",hi,lo); fflush(stdout);} }
        if(twofull(m+1)){ rev++;
          #pragma omp critical
          { unsigned long long lo=(unsigned long long)(m%1000000000000000000ULL), hi=(unsigned long long)(m/1000000000000000000ULL);
            if(hi) printf("REV m=%llu%018llu (3-full) m+1 2-full\n",hi,lo); else printf("REV m=%llu (3-full) m+1 2-full\n",lo); fflush(stdout);} } } } }
  printf("N=1e%d  3-full numbers checked=%lld  hits(366)=%lld  reverse pairs=%lld  trial primes<=%d\n",e,cnt,hits,rev,B);
  return 0;}
