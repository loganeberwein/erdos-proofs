// Search n in [lo,hi) with: n - k^2 prime for all k<sqrt(n), gcd(k,n)=1.  Segmented sieve; small k checked via sieve window, larger k via deterministic Miller-Rabin.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
typedef uint64_t u64; typedef unsigned __int128 u128;
static u64 mulm(u64 a,u64 b,u64 m){return (u128)a*b%m;}
static u64 powm(u64 a,u64 e,u64 m){u64 r=1;while(e){if(e&1)r=mulm(r,a,m);a=mulm(a,a,m);e>>=1;}return r;}
static int mr(u64 n){ if(n<2)return 0; static const u64 P[]={2,3,5,7,11,13,17,19,23,29,31,37};
 for(int i=0;i<12;i++){if(n%P[i]==0)return n==P[i];}
 u64 d=n-1;int s=0;while(!(d&1)){d>>=1;s++;}
 for(int i=0;i<12;i++){u64 x=powm(P[i],d,n);if(x==1||x==n-1)continue;int ok=0;for(int r=1;r<s;r++){x=mulm(x,x,n);if(x==n-1){ok=1;break;}}if(!ok)return 0;}return 1;}
static u64 gcd(u64 a,u64 b){while(b){u64 t=a%b;a=b;b=t;}return a;}
int main(int argc,char**argv){
 u64 lo=strtoull(argv[1],0,10), hi=strtoull(argv[2],0,10);
 const u64 KB=200;              // window extends back by KB^2
 const u64 W=1ULL<<26;
 u64 sq=(u64)sqrtl((long double)hi)+2;
 char*base=calloc(sq+1,1); u64*pr=malloc(sizeof(u64)*(sq/2+10)); u64 np=0;
 for(u64 i=2;i<=sq;i++){ if(!base[i]){pr[np++]=i; for(u64 j=i*i;j<=sq;j+=i)base[j]=1;} }
 char*seg=malloc(W+KB*KB+16); u64 found=0, tested=0;
 for(u64 L=lo; L<hi; L+=W){
   u64 R=L+W; if(R>hi)R=hi;
   u64 S0 = L> KB*KB ? L-KB*KB : 0; u64 len=R-S0;
   memset(seg,1,len);
   for(u64 i=0;i<np;i++){u64 p=pr[i]; if(p*p>=R)break; u64 st=(S0+p-1)/p*p; if(st<p*p)st=p*p; for(u64 j=st;j<R;j+=p)seg[j-S0]=0;}
   for(u64 x=S0;x<2&&x<R;x++)seg[x-S0]=0;
   for(u64 n=(L<3?3:L); n<R; n++){
     if(!seg[n-1-S0]) continue;              // k=1
     tested++;
     int ok=1;
     for(u64 k=2; k*k<n; k++){
       if(gcd(k,n)!=1) continue;
       u64 v=n-k*k; int isp = (k<KB && v>=S0) ? seg[v-S0] : mr(v);
       if(!isp){ok=0;break;}
     }
     if(ok){found++; printf("FOUND %llu\n",(unsigned long long)n); fflush(stdout);}
   }
 }
 fprintf(stderr,"range [%llu,%llu): candidates with n-1 prime: %llu, found %llu\n",(unsigned long long)lo,(unsigned long long)hi,(unsigned long long)tested,(unsigned long long)found);
}
