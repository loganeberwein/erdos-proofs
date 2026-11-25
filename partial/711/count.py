"""Path and image counts for a configuration {(p, b_p)}, S_p = {b_p + j p : 0<=j<K}.
Definitions (see README):
 P3 = #{(d,u,e,w): d!=e, u in S_d∩S_e, w in S_e, w!=u, idx_e(w)≡idx_e(u) mod 2}; image (d, x=(u+w)/2, w).
 P5 = #{(d0,u1,d1,u2,d2,w): d0!=d1, d1!=d2, u1∈S_d0∩S_d1, u2∈S_d1∩S_d2, u1!=u2 same parity in S_d1,
        w∈S_d2, w!=u2 same parity in S_d2}; image (d0, x1=(u1+u2)/2, x2=(u2+w)/2, w).
 For primes in [v,2v) with H<v^2 both encodings are injective (kappa=1), so #images = P3, P5.
 Possible-image sets (what an a-priori count must bound):
 G3  = #{(d,x,w): x,w∈U, 2x-w∈S_d}
 G5  = #{(d0,x1,x2,w): x1,x2,w∈U, 2x1-2x2+w∈S_d0}
 G5u = G5 with the extra constraint u2=2x2-w ∈ U   (a 'cleverer' set)
"""
import numpy as np, sys, json
from numpy.fft import rfft, irfft

def load(fn):
    a = np.loadtxt(fn, skiprows=1, dtype=np.int64); return a[:, 0], a[:, 1]

def conv(a, b):
    n = len(a) + len(b) - 1; m = 1 << (n - 1).bit_length()
    return np.rint(irfft(rfft(a, m) * rfft(b, m), m)[:n]).astype(np.int64)

def counts(P, B, K):
    N = len(P); J = np.arange(K)
    pts = (B[:, None] + J[None, :] * P[:, None])            # N x K
    H = int(pts.max()) + 1
    deg = np.bincount(pts.ravel(), minlength=H)
    U = int((deg > 0).sum())
    c = (K - (J % 2) + 1) // 2                               # same-parity indices incl. self
    Ftot = np.bincount(pts.ravel(), weights=np.broadcast_to(c - 1, pts.shape).ravel(), minlength=H)
    dm1 = deg[pts] - 1                                       # N x K
    F = Ftot[pts] - (c - 1)[None, :]                         # exclude d2=d1
    par = (J[:, None] % 2 == J[None, :] % 2) & (J[:, None] != J[None, :])
    P3 = int((dm1[:, :, None] * par[None]).sum())
    P5 = int(np.einsum('ni,ij,nj->', dm1.astype(float), par.astype(float), F))
    ind = (deg > 0).astype(np.float64)
    # G3: sum_s deg(s) #{(x,w): 2x - w = s}
    d2 = np.zeros(2 * H); d2[::2] = ind                     # positions 2x
    g3 = conv(d2, ind[::-1])                                 # index t -> 2x - w + (H-1)
    s = np.arange(H)
    G3 = int((deg * g3[s + H - 1]).sum())
    # G5: sum_s deg(s) #{(x1,x2,w): 2x1-2x2+w = s}
    d2r = d2[::-1].copy()                                    # -2x2 (offset 2H-1)
    t = conv(conv(d2, d2r), ind)                             # 2x1-2x2+w + (2H-1)
    G5 = int((deg * t[s + 2 * H - 1]).sum())
    # G5u: u2=2x2-w must be in U: cu(u) = #{(x2,w): 2x2-w=u} for u in U
    cu = g3[s + H - 1] * ind                                 # function of u in [0,H)
    # need sum_s deg(s) sum_x1 cu(2x1 - s): conv of d2 with reversed cu
    t2 = conv(d2, cu[::-1])                                  # 2x1 - u + (H-1)
    G5u = int((deg * t2[s + H - 1]).sum())
    return dict(N=N, K=K, U=U, H=H, maxdeg=int(deg.max()), P3=P3, P5=P5, G3=G3, G5=G5, G5u=G5u,
                NK5=N * K**5, NU_U2=N * U + U * U)

if __name__ == '__main__':
    P, B = load(sys.argv[1]); print(json.dumps(counts(P, B, int(sys.argv[2]))))
