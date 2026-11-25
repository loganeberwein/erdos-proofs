/* Best-response local search minimising |U|, U = union_p {b_p + j p : 0<=j<K},
   p prime in [v, v+D). Rebuild of the earlier session's search711.py (same move:
   per-prime best response = fewest new points, ties broken toward piling onto
   heavily covered points, random tie choice; kick 10% every 5 sweeps).
   Init: 'r' random offsets or 'c' Chen-Korsky style b_p = p^2 mod Q.
   Usage: search v D K sweeps seed init(r|c)  -> prints N |U| then b_p list.  */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static unsigned long long s_;
static unsigned long long rnd(void){ s_^=s_<<13; s_^=s_>>7; s_^=s_<<17; return s_; }
int main(int argc,char**argv){
  int v=atoi(argv[1]),D=atoi(argv[2]),K=atoi(argv[3]),sweeps=atoi(argv[4]);
  s_=0x9E3779B97F4A7C15ULL*(unsigned long long)(atoi(argv[5])+1); char init=argv[6][0];
  int top=v+D; char*isp=calloc(top+1,1); for(int i=2;i<=top;i++) isp[i]=1;
  for(int i=2;(long)i*i<=top;i++) if(isp[i]) for(int j=i*i;j<=top;j+=i) isp[j]=0;
  int N=0; int*P=malloc(sizeof(int)*top); for(int p=v;p<top;p++) if(isp[p]) P[N++]=p;
  long H=(long)K*top; int*cnt=calloc(H,sizeof(int)); int*b=malloc(sizeof(int)*N),*best_b=malloc(sizeof(int)*N);
  long Q=1; int sp[]={3,5,7,11,13,17,19,23,29,31,37,41,43,47};
  for(int i=0;i<14;i++) if(Q*sp[i]<v) Q*=sp[i];
  for(int i=0;i<N;i++){ b[i]= init=='c' ? (int)(((long)P[i]*P[i])%Q % P[i]) : (int)(rnd()%P[i]);
    for(int j=0;j<K;j++) cnt[b[i]+(long)j*P[i]]++; }
  long U=0; for(long x=0;x<H;x++) U+=cnt[x]>0; long bestU=U; memcpy(best_b,b,sizeof(int)*N);
  int*cand=malloc(sizeof(int)*top); int*ord=malloc(sizeof(int)*N);
  for(int sw=0;sw<sweeps;sw++){
    for(int i=0;i<N;i++) ord[i]=i;
    for(int i=N-1;i>0;i--){int j=rnd()%(i+1);int t=ord[i];ord[i]=ord[j];ord[j]=t;}
    for(int t=0;t<N;t++){ int i=ord[t],p=P[i];
      for(int j=0;j<K;j++) cnt[b[i]+(long)j*p]--;
      long bs=1L<<62; int nc=0;
      for(int r=0;r<p;r++){ long nw=0,pile=0; for(int j=0;j<K;j++){int c=cnt[r+(long)j*p]; nw+=(c==0); pile+=c;}
        long sc=nw*1000000L-pile; if(sc<bs){bs=sc;nc=0;} if(sc==bs) cand[nc++]=r; }
      b[i]=cand[rnd()%nc]; for(int j=0;j<K;j++) cnt[b[i]+(long)j*p]++; }
    U=0; for(long x=0;x<H;x++) U+=cnt[x]>0;
    if(U<bestU){bestU=U; memcpy(best_b,b,sizeof(int)*N);}
    if(sw%5==4 && sw<sweeps-1) for(int k=0;k<(N/10>0?N/10:1);k++){ int i=rnd()%N,p=P[i];
      for(int j=0;j<K;j++) cnt[b[i]+(long)j*p]--; b[i]=rnd()%p; for(int j=0;j<K;j++) cnt[b[i]+(long)j*p]++; }
  }
  printf("%d %ld\n",N,bestU); for(int i=0;i<N;i++) printf("%d %d\n",P[i],best_b[i]); return 0; }
