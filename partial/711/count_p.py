"""G5p: possible-image set for (d0,x1,x2,w) using every local check that does not name d1,d2:
x1,x2,w,u2=2x2-w,u1=2x1-u2 all in U, u1 in S_d0, and both w-u2 and u2-u1 nonzero with a prime
factor in P (the window). Brute-force-checked against a direct loop on small configs."""
import numpy as np
def G5p(P, B, K):
    J = np.arange(K); pts = B[:, None] + J[None, :] * P[:, None]; H = int(pts.max()) + 1
    deg = np.bincount(pts.ravel(), minlength=H); Uarr = np.flatnonzero(deg); inU = deg > 0
    divP = np.zeros(H, bool)
    for p in P: divP[p::p] = True                            # |t| < H, t != 0
    c = np.zeros(H, np.int64)                                 # c[u2] = #{w in U: (u2+w)/2 in U, divP(|w-u2|)}
    for u2 in Uarr:
        w = Uarr[((Uarr + u2) % 2 == 0) & (Uarr != u2)]
        ok = inU[(w + u2) // 2] & divP[np.abs(w - u2)]
        c[u2] = ok.sum()
    tot = 0
    s_all = pts.ravel()                                       # each (d0, s) once
    for s in s_all:
        u2 = Uarr[((Uarr + s) % 2 == 0) & (Uarr != s)]
        ok = inU[(u2 + s) // 2] & divP[np.abs(u2 - s)]
        tot += int(c[u2[ok]].sum())
    return tot
def brute(P, B, K):
    S = {p: set(b + j*p for j in range(K)) for p, b in zip(P, B)}; U = set().union(*S.values())
    dv = lambda t: t != 0 and any(abs(t) % p == 0 for p in P); n = 0
    for d0 in P:
        for x1 in U:
            for x2 in U:
                for w in U:
                    u2 = 2*x2 - w; u1 = 2*x1 - u2
                    if u2 in U and u1 in S[d0] and dv(w - u2) and dv(u2 - u1): n += 1
    return n
if __name__ == '__main__':
    import subprocess
    for v, K, sd in [(300, 3, 1), (500, 4, 2)]:
        out = subprocess.run(['./search', str(v), str(v//4), str(K), '10', str(sd), 'r'], capture_output=True, text=True).stdout
        a = np.array([list(map(int, l.split())) for l in out.strip().split('\n')[1:]])
        f, b = G5p(a[:, 0], a[:, 1], K), brute(list(a[:, 0]), list(a[:, 1]), K); print(v, K, f, b); assert f == b
    print('G5p brute-force check passed')
