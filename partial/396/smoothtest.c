// Supplier test for #396: among n <= X such that every n-i (0<=i<=k) is y-smooth with y = n^theta,
// what fraction satisfy n(n-1)...(n-k) | C(2n,n)? If smoothness alone almost forces divisibility,
// a smooth-block construction (Balog-Wooley type) plus digit control is a plausible route.
// Build: gcc -O3 -o smoothtest smoothtest.c -lm   Run: ./smoothtest X KMAX theta
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
static uint32_t *spf;
static int carries(uint64_t n,uint64_t p){ int c=0,carry=0; while(n){ uint64_t d=n%p; int s=2*d+carry; carry=s>=(int)p; c+=carry; n/=p; } return c; }
static uint32_t lpf_big(uint64_t m){ uint32_t b=1; while(m>1){ uint32_t p=spf[m]; if(p>b)b=p; while(m%p==0)m/=p;} return b; }
int main(int argc,char**argv){
  uint64_t X=atoll(argv[1]); int KMAX=atoi(argv[2]); double th=atof(argv[3]);
  spf=calloc(X+1,4); for(uint64_t i=2;i<=X;i++) if(!spf[i]) for(uint64_t j=i;j<=X;j+=i) if(!spf[j]) spf[j]=i;
  for(int k=1;k<=KMAX;k++){ uint64_t smooth=0,good=0;
    for(uint64_t n=1000;n<=X;n++){ double y=pow((double)n,th); int sm=1;
      for(int i=0;i<=k;i++) if(lpf_big(n-i)>y){sm=0;break;}
      if(!sm) continue; smooth++;
      int need[128]={0}; int ok=1;
      for(int i=0;i<=k && ok;i++){ uint64_t m=n-i; while(m>1){ uint64_t p=spf[m]; int e=0; while(m%p==0){m/=p;e++;}
          if(p<=(uint64_t)k){ need[p]+=e; } else if(e>carries(n,p)){ok=0;break;} } }
      for(int p=2;p<=k && ok;p++) if(need[p]>carries(n,p)) ok=0;
      good+=ok; }
    printf("k=%d theta=%.2f: n<=%llu with all n-i n^theta-smooth: %llu, of which divisible: %llu (%.1f%%)\n",k,th,(unsigned long long)X,(unsigned long long)smooth,(unsigned long long)good,100.0*good/(smooth?smooth:1)); }
  return 0; }
