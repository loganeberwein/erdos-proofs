// For every odd n in [2^(B-1),2^B): exact distribution over 2^T coin paths of n_t mod 64 (t=1..T),
// TV distance to uniform on odd residues; also exact E[ln n_t - ln n]. Report per t the max TV over n (+argmax) and max drift.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#define L 64
static int T; static double H[40][L];
static void dfs(uint64_t n,int t,double w){
  if(t==T) return;
  for(int s=-1;s<=1;s+=2){ uint64_t m=3*n+s; while(!(m&1)) m>>=1;
    H[t+1][m&(L-1)]+=w*0.5; dfs(m,t+1,w*0.5);} }
static double LG[40]; static void dfl(uint64_t n,int t,double w,double l0){
  if(t==T) return;
  for(int s=-1;s<=1;s+=2){ uint64_t m=3*n+s; while(!(m&1)) m>>=1;
    LG[t+1]+=w*0.5*(log((double)m)-l0); dfl(m,t+1,w*0.5,l0);} }
int main(int c,char**v){ int B=atoi(v[1]); T=atoi(v[2]);
  double mx[40]={0}, md[40]; uint64_t am[40]={0}, ad[40]={0}; for(int i=0;i<40;i++) md[i]=-1e9;
  for(uint64_t n=(1ULL<<(B-1))+1;n<(1ULL<<B);n+=2){
    for(int t=0;t<=T;t++) for(int r=0;r<L;r++) H[t][r]=0;
    dfs(n,0,1.0);
    for(int t=1;t<=T;t++){ double tv=0; for(int r=1;r<L;r+=2) tv+=fabs(H[t][r]-2.0/L); tv*=0.5;
      if(tv>mx[t]){mx[t]=tv;am[t]=n;} }
    for(int t=0;t<=T;t++) LG[t]=0; dfl(n,0,1.0,log((double)n));
    for(int t=1;t<=T;t++) if(LG[t]>md[t]){md[t]=LG[t];ad[t]=n;}
  }
  printf("B=%d\n",B);
  for(int t=1;t<=T;t++) printf(" t=%2d maxTV=%.3f at n=%llu   maxDrift=%+.3f at n=%llu\n",t,mx[t],(unsigned long long)am[t],md[t],(unsigned long long)ad[t]);
}
