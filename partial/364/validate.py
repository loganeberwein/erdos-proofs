# Non-vacuous validation of the Pell reduction: brute force lists every t <= 2*10^5 with t^2 - 1
# powerful; the Pell walk (all squarefree B < 4000, which covers B^3 <= t^2, keeping solutions with
# B | Y) must list exactly the same t. (The extra conditions 4 | t and "t powerful" are then applied
# separately in pell364.py.)
from sympy import factorint
from gmpy2 import mpz, isqrt
def powerful(n): return all(e>=2 for e in factorint(n).values())
N=2*10**5
brute=sorted(t for t in range(2,N+1) if powerful(t*t-1))
def sqfree(n):
    p=2
    while p*p<=n:
        if n%(p*p)==0: return False
        p+=1
    return True
def fund(D):
    a0=isqrt(D); m,d,a=0,1,a0; h1,h=1,a0; k1,k=0,1
    while h*h-D*k*k!=1:
        m=d*a-m; d=(D-m*m)//d; a=(a0+m)//d; h1,h=h,a*h+h1; k1,k=k,a*k+k1
    return h,k
pell=set()
for B in range(2,4000):
    if not sqfree(B): continue
    x1,y1=fund(mpz(B)); x,y=x1,y1
    while x<=N:
        if y%B==0: pell.add(int(x))
        x,y=x*x1+B*y*y1, x*y1+y*x1
print(len(brute),"values:",brute); print("match:",brute==sorted(pell))
