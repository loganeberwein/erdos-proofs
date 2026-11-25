# zero at n means e_n=0, so e_{n-1}=(n-1)/2. Going back: e_{m-1} = ((m-1) +/- e_m)/2 must be an integer in [0, m-1].
def chains(n,L):
    S={(n-1)//2} if (n-1)%2==0 else set()
    m=n-1
    for _ in range(L):
        T=set()
        for e in S:
            for sgn in (1,-1):
                q=(m-1)+sgn*e
                if q%2==0 and 0<=q//2<=m-1: T.add(q//2)
        S=T; m-=1
        if not S: return 0
    return len(S)
import random
if __name__=='__main__':
  for r in range(3,32,4):
      ok=[chains(n,12) for n in [r+32*random.randrange(10**9,10**10) for _ in range(200)]]
      print("n mod 32 =",r," fraction with a 12-step backward chain:",sum(1 for c in ok if c>0)/len(ok))
