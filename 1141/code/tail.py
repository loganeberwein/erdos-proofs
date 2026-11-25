# Tail: all n >= 1e20050, t = log n. Every bound below is monotone in t; checked on a grid then argued.
from mpmath import mp, mpf, log, exp, sqrt, euler
mp.dps=30
def ok(t):
    L=t+log(4); ll=log(t)
    w=mpf('1.3841')*t/ll                      # Robin: omega(n) <= 1.3841 log n/loglog n, n>=3
    # Lemma A at x=(2L)^2: x/2 - 0.047 sx - 2 w log x - A sx - 2.07766 sx > 0
    x=(2*L)**2; sx=2*L; A=max(mpf('6.9'),mpf('0.874')*L)
    small = mpf('0.24')*x/log(x) - (w+1)   # f in {5,8} via BMOR
    lemA = x/2 - mpf('0.047')*sx - 2*w*log(x) - A*sx - mpf('2.07766')*sx
    # Lemma B: per class >= T0*phi - 2^w, T0 >= sqrt(n)/(6x)-2, phi >= 1/(e^g loglog n + 2.51/loglog n)
    phi = 1/(exp(euler)*ll + mpf('2.51')/ll)
    logmain = log(exp(t/2)/(6*x) - 2) + log(phi)  # exact, includes the -2
    log2w = w*log(2)
    return min(lemA, small), logmain - log2w
t0 = 20050*log(10)
for t in [t0, t0*2, t0*10, t0*1e3, t0*1e9, t0*1e50]:
    a,b = ok(t); print(float(t), float(a)>0, float(a), float(b))
