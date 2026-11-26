# Erdős #458, conditional sweep past 2^64 (item 6 of the README).
# For every prime power q^b with b >= 5 and 2^64 < q^b < 10^30, find the prime gap (p_k, p_{k+1})
# containing it, prove both endpoints prime (PARI isprime: APR-CL certificate), and list every
# proper prime power strictly inside the gap. Reports any gap holding >= 2 powers and the largest
# ratio (product of bases)/p_k seen.
# Run: python3 sweep_b5.py [WORKERS]   (needs cypari2)
import sys
from multiprocessing import Pool
LO, HI = 2**64, 10**30

def targets():
    import cypari2
    pari = cypari2.Pari()
    out = []
    b = 5
    while 2**b < HI:
        q = 2
        while True:
            v = q**b
            if v >= HI:
                break
            if v > LO:   # 2^64 itself is checked separately (README item 6)
                out.append((q, b))
            q = int(pari.nextprime(q + 1))
        b += 1
    return out

def work(chunk):
    import cypari2
    pari = cypari2.Pari()
    pari.allocatemem(2 * 10**8, silent=True)
    res = []
    for q, b in chunk:
        v = q**b
        p = int(pari.precprime(v - 1))
        P = int(pari.nextprime(v + 1))
        assert pari.isprime(p) and pari.isprime(P)          # proved prime (APR-CL in PARI isprime)
        pows = []
        for n in range(p + 1, P):
            k = int(pari.ispower(n))
            if k >= 2:
                # n = r^k with k maximal; n is a proper prime power iff r is prime
                r = int(pari.sqrtnint(n, k))
                if pari.isprime(r):
                    pows.append((n, r, k))
        prod = 1
        for _, r, _ in pows:
            prod *= r
        res.append((q, b, p, P, pows, prod / p))
    return res

if __name__ == "__main__":
    W = int(sys.argv[1]) if len(sys.argv) > 1 else 2
    T = targets()
    print(f"targets (q^b, b>=5, 2^64<q^b<10^30): {len(T)}", flush=True)
    chunks = [T[i::64] for i in range(64)]
    gaps = set(); multi = []; worst = 0.0
    with Pool(W) as pool:
        for res in pool.imap_unordered(work, chunks):
            for q, b, p, P, pows, r in res:
                gaps.add(p)
                if len(pows) >= 2:
                    multi.append((p, P, pows))
                worst = max(worst, r)
    print(f"distinct gaps visited: {len(gaps)}")
    print(f"gaps containing >= 2 proper prime powers: {len(multi)}")
    for m in multi:
        print("MULTI", m)
    print(f"largest ratio (product of bases)/p_k: {worst:.3e}")
