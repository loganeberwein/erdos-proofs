# Independent brute-force cross-check of search366.c for N <= 10^6 using sympy factorization.
from sympy import factorint
N=10**6
def full(n,k): return all(e>=k for e in factorint(n).values())
F3=[m for m in range(1,N+1) if full(m,3)]
print("3-full count", len(F3))
print("366 hits", [m-1 for m in F3 if m>1 and full(m-1,2)])
print("reverse", [m for m in F3 if full(m+1,2)])
