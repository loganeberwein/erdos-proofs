// Erdős #317 kernel check (written by an AI referee): for every n in [5,N], test whether the largest prime <= n (top-1) or one of the two largest primes <= n (top-2) is a witness, i.e. has L/p mod p not in {1,p-1}. Exact residues by direct product. Build: gcc -O2 top2_317.c -o top2_317. Run: ./top2_317 1000000
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
typedef uint64_t u64;
static char*comp; static u64*pr; static long np; static int *ppq; // ppq[x]=q if x=q^e (e>=1) else 0
static u64 res(u64 p,u64 m){ u64 r=1; for(long i=0;i<np&&pr[i]<=m;i++){u64 q=pr[i]; if(q==p) continue; u64 v=q; while(v<=m/q) v*=q; r=(r*(v%p))%p;} return r; }
int main(int c,char**v){ u64 N=strtoull(v[1],0,10); comp=calloc(N+2,1); pr=malloc(8*(N/2+10)); ppq=calloc(N+2,sizeof(int));
 for(u64 i=2;i<=N+1;i++) if(!comp[i]){ pr[np++]=i; for(u64 j=i*i;j<=N+1;j+=i) comp[j]=1; for(u64 x=i;x<=N+1;x*=i){ ppq[x]=i; if(x>(N+1)/i) break;} }
 long f1=0,f2=0,f1states=0; // f1: n where top prime fails; f2: n where both top-2 fail
 for(long i=2;i<np-1 && pr[i]<=N;i++){ u64 p1=pr[i],p2=pr[i-1],nx=pr[i+1]; if(2*p2<=p1) continue;
   u64 r1=res(p1,p1), r2=res(p2,p1); int prev1=-1;
   for(u64 n=p1;n<nx && n<=N;n++){ if(n>p1 && ppq[n]){ u64 q=ppq[n]; r1=r1*(q%p1)%p1; if(q!=p2) r2=r2*(q%p2)%p2; }
     if(n<5) continue; int b1=(r1==1||r1==p1-1), b2=(r2==1||r2==p2-1)||(2*p2<=n);
     if(b1){ f1++; if(prev1!=1){ f1states++; printf("top1 fail n=%llu p=%llu r=%llu\n",(unsigned long long)n,(unsigned long long)p1,(unsigned long long)r1);} }
     if(b1&&b2){ f2++; printf("TOP2 FAIL n=%llu p1=%llu p2=%llu\n",(unsigned long long)n,(unsigned long long)p1,(unsigned long long)p2);} prev1=b1; } }
 printf("N=%llu top1-fail n count=%ld (distinct runs %ld), top2-fail n count=%ld\n",(unsigned long long)N,f1,f1states,f2); }
