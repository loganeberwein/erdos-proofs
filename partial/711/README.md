# Erdős Problem #711 — partial results

**Problem** (https://www.erdosproblems.com/711). Let f(n,m) be the least L such that the interval (m, m+L) contains distinct integers a_1, …, a_n with k dividing a_k for every k ≤ n. Part (i): prove max_m f(n,m) ≤ n^{1+o(1)}. Part (ii): prove max_m (f(n,m) − f(n,n)) → ∞. **Prize:** Erdős offered 1000 rupees for either part (the site lists this as $78).
**Status of the problem** (as of 2026-11-25): open. Part (ii) was answered yes by van Doorn (2026), who showed f(n,m) − f(n,n) ≫ n·log n/log log n for some m. Part (i) is open. Erdős–Pomerance (1980) proved max_m f(n,m) ≪ n^{3/2}. Chen–Korsky (arXiv 2607.26450) improved this to n^{4/3+o(1)} and proved a lower bound of n·exp(c·log n/log log n) for the prime-moduli version. So the open question is whether the exponent 4/3 can be pushed down to 1. Everything below is about part (i).

**The core problem in plain terms.** Take the primes p in a window (v, 2v] (or [v, 1.25v) below). Give each prime p a starting point b_p with 0 ≤ b_p < p, and mark the K points b_p, b_p + p, …, b_p + (K−1)p. Call the marked set U and let N be the number of primes. You need to show that at least N points get marked (|U| ≥ N) as soon as K is a small power of v. Chen–Korsky's method gets this once K ≥ N^{1/3+o(1)}, which is where the exponent 4/3 comes from. The target is K ≥ N^{o(1)}.

## Results here

1. **[Reduction]** *CRT reformulation as Hall's condition (prime moduli).* Fix a finite set P of primes and a length H. As m runs over the integers, the offsets b_p ∈ [0,p) defined by m+1+b_p ≡ 0 (mod p) take every value in ∏_p [0,p), by CRT. The multiples of p in (m, m+H] are exactly m+1+b_p+jp for j ≥ 0 with b_p + jp ≤ H−1. So Hall's condition for the moduli P fails at some m exactly when some choice of offsets gives |⋃_p {b_p + jp : j ≥ 0, b_p + jp < H}| < |P|. Proof: the CRT bijection plus the definition of Hall's condition, applied to every subset of P. A failure on a prime set only ever gives a *lower* bound on f, never an upper bound. Checked by a fresh adversarial agent, which ruled it VALID.

2. **[Proved]** *Longer paths in Chen–Korsky's Lemma 2.1 give a worse exponent with the natural encoding.* Setup: N progressions S_d of length L with distinct differences d, union U, and κ = max_{0<t≤H} #{d : d | t}. Lemma 2.1 counts length-3 paths S_d – u – S_e – w. The lower bound is ≳ N L³ when |U| ≤ N, by Cauchy–Schwarz on the degrees. For the upper bound, encode the path as (d, x, w) with x = (u+w)/2. Split each S_e into parity halves so that x ∈ S_e ⊂ U. The encoding is at most κ-to-one, since e | 2(w−x). Its image lies in {(d,x,w) : x, w ∈ U, 2x − w ∈ S_d}, and that set has ≲ κN² elements. Together these give L³ ≲ κ²N. The same scheme for length-5 paths S_{d0} – u1 – S_{d1} – u2 – S_{d2} – w uses midpoints x1 = (u1+u2)/2 and x2 = (u2+w)/2 and the encoding (d0, x1, x2, w). The lower bound is ≳ N L⁵. The image lies in {x1, x2, w ∈ U, 2x1 − 2x2 + w ∈ S_{d0}}, which has one extra free U-coordinate. The count is #paths ≲ κ³N³, so L⁵ ≲ κ³N² and L ≲ N^{2/5}, worse than N^{1/3}. (The earlier session wrote this as "L⁵ ≲ κ³N³", which only gives 2/5 if the left side is read as N·L⁵.) Checked by a fresh adversarial agent: VALID. That agent also noted that a cleverer encoding with ≈ N² images is not ruled out. Such an encoding would give L ≲ N^{1/5}, and so exponent 6/5. Item 6 tests this.

3. **[Reduction]** *Arithmetic Kakeya ⇒ (i) for prime moduli, with a caveat.* Suppose U contains an L-term progression of difference p for every prime p in a set P ⊂ [v, 2v] with |P| = N, and L < v. Then for each k ≥ 2 and each 1 ≤ t ≤ (L−1)/(k−1), U contains a k-term progression of difference p·t, and the N·⌊(L−1)/(k−1)⌋ products p·t are pairwise distinct. (Two such products are equal only if p = p′, because t < v.) So a bound of the form "|D| ≤ C_ε|A|^{1+ε} whenever A contains a k(ε)-term progression of every difference in D" gives N L/k ≲ |U|^{1+ε}, and hence |U| ≥ N once L ≳ k N^ε. **Caveat:** the fresh adversarial agent ruled the core step valid but found that the sum over dyadic ranges of p, as first written, was broken. The proposed fix is to run the argument once on all primes above (L−1)/(k−1), with no dyadic split. That fix has not been independently checked. **More importantly**, the hypothesis is an arithmetic-Kakeya statement, and the full arithmetic Kakeya conjecture is known to imply the Kakeya conjecture in every dimension. This is a reduction to a harder problem, not progress.

4. **[Proved]** *Per-prime compression bound.* Let q be prime and f : (Z/q)^* → Z/q any function, and let s_j = |{f(a) + j a : a ∈ (Z/q)^*}| for j ∈ Z/q. Then Σ_j 1/s_j ≤ 2. Proof: each ordered pair a ≠ a′ satisfies f(a) + ja = f(a′) + ja′ for exactly one j, since j(a − a′) = f(a′) − f(a). That gives (q−1)(q−2) collisions in total. By Cauchy–Schwarz, direction j has at least (q−1)²/s_j − (q−1) of them. Summing over j gives Σ_j (q−1)²/s_j ≤ (q−1)(q−2) + q(q−1) = 2(q−1)², so Σ_j 1/s_j ≤ 2. The parabola f(a) = a² comes close to equality. Checked exhaustively for q = 5, 7, on random f for q ≤ 13, and by a fresh adversarial agent. Only this per-prime statement survives. Its use in a global ceiling (Routes, item E) was withdrawn.

5. **[Computed]** *Searches from the earlier session.* These used a best-response local search over the offsets b_p (sampled, not exhaustive): up to 400 primes and v ≤ 16,000. They found Hall failures (|U| < N) only for K ≤ 3. Separately, simulated annealing on the per-prime problem (sampled) found best compression ≈ 0.18, flat for q = 61 to 601. **[Heuristic]** That excludes the q^{−1/4} decay a polynomial counterexample built this way would need, but not a decay as slow as q^{−0.04}. It also only covers constructions where colliding points share the same step index j.

6. **[Computed]** *This session: the length-5 image test.*

   *Definitions used.* Primes p ∈ [v, 1.25v) (narrow window as in Chen–Korsky), N = #primes, S_p = {b_p + jp : 0 ≤ j < K}, U = ⋃ S_p, H = max U + 1 < 1.25Kv. A length-5 path is (d0, u1, d1, u2, d2, w) with the following conditions:
   - d0 ≠ d1 and d1 ≠ d2 (d0 = d2 is allowed);
   - u1 ∈ S_{d0} ∩ S_{d1} and u2 ∈ S_{d1} ∩ S_{d2};
   - u1 ≠ u2, and their indices in S_{d1} have the same parity;
   - w ∈ S_{d2}, w ≠ u2, and their indices in S_{d2} have the same parity.

   Its image is (d0, x1, x2, w) with x1 = (u1+u2)/2 and x2 = (u2+w)/2. Write P5 for the number of paths. The three "possible-image" sets an a-priori count would have to bound are:
   - G5 = #{(d0, x1, x2, w) : x1, x2, w ∈ U, 2x1 − 2x2 + w ∈ S_{d0}} (the natural set);
   - G5u = G5 restricted to u2 = 2x2 − w ∈ U;
   - G5p = G5u restricted further to u1 ∈ U (automatic) and to both w − u2 and u2 − u1 being nonzero multiples of a window prime. This uses every local check that does not name d1 or d2.

   P3 and G3 = #{(d,x,w) : x, w ∈ U, 2x − w ∈ S_d} are the length-3 analogues.

   *Exact fact used.* Every t with 0 < t < H < v² has at most one prime factor ≥ v. So κ = 1, and the length-3 and length-5 encodings are both injective: d2 is the window prime dividing w − u2, and d1 is the one dividing u2 − u1. Hence #distinct images = P5 exactly, and any encoding that is at most κ^{O(1)}-to-one has at least P5 images. Brute-force enumeration confirmed #images = P5, P3 and the values of G3, G5, G5u and G5p on three small configurations (N = 12 to 25).

   *Configurations.* For each v ∈ {500, 1000, …, 512000} and K ∈ {3, 4, 6}, a C rebuild of the earlier session's best-response search was run. Each prime's offset is moved to minimize new points, ties go toward already-covered points, 10% of offsets are kicked every 5 sweeps, and the best configuration over 20 sweeps is kept. Runs used 2 random starts plus 1 Chen–Korsky start b_p = p² mod Q, and the minimum |U| is reported. Sizes v ≤ 128000 used all three starts. The added sizes (v = 256000, 512000 for K = 3 and v = 256000 for K = 4) used one random start and 15 sweeps. Unsearched random offsets serve as a baseline. Both cores were used and no run took more than 2.5 minutes. Sizes with N ≥ 30 are fitted: 10 sizes for K = 3, 9 for K = 4, 7 for K = 6.

   *Near-extremal configurations, K = 3* (|U| < N from N = 119 on):

   | N | \|U\|/N | P5 (= #images) | P5/N² | G5 | G5/N² | G5/(N\|U\|³/v) | G5p/N² |
   |---|---|---|---|---|---|---|---|
   | 36 | 1.11 | 740 | 0.57 | 9.9e3 | 7.6 | 4.28 | 1.09 |
   | 64 | 1.06 | 1964 | 0.48 | 3.8e4 | 9.3 | 3.77 | 0.88 |
   | 119 | 0.92 | 4068 | 0.29 | 1.6e5 | 11.2 | 4.00 | 0.57 |
   | 222 | 0.93 | 6548 | 0.13 | 5.9e5 | 12.0 | 2.39 | 0.24 |
   | 400 | 0.86 | 9722 | 0.061 | 2.4e6 | 14.7 | 2.27 | 0.12 |
   | 771 | 0.81 | 137322 | 0.23 | 1.6e7 | 26.9 | 2.73 | 0.42 |
   | 1424 | 0.79 | 96914 | 0.048 | 5.5e7 | 27.1 | 1.75 | 0.083 |
   | 2696 | 0.68 | 71436 | 0.0098 | 2.4e8 | 33.0 | 1.81 | 0.026 |
   | 5083 | 0.70 | 652274 | 0.025 | 1.2e9 | 44.7 | 1.29 | 0.046 |
   | 9629 | 0.63 | 4238736 | 0.046 | 6.0e9 | 64.6 | 1.40 | 0.078 |

   (Full tables for all K and the random baseline are in `analysis.txt`, `analysis2.txt` and `analysis3.txt`.)

   *Fits* (least squares in log–log; rms of residuals in log units):
   - **G5, near-extremal.** Free power law: exponent 2.38 / 2.46 / 2.53 (K = 3/4/6, rms 0.11/0.13/0.06). N³(log N)^b with b = −3.7/−3.1/−2.5: rms 0.14/0.10/0.07. N²(log N)^b with b = +2.2/+2.6/+2.8: rms 0.17/0.20/0.10. On these raw fits alone the data cannot rule out N^{2+o(1)}, N^{2.4} or N^{3−o(1)}. Two things separate them. First, G5 stays within a factor 1.3–4.3 of the chance-coincidence count N|U|³/v at every size and every K, and that count is ≈ N³/(4 ln v) when |U| ≈ N. Second, the local slopes rise at the largest sizes: 2.48, 2.58 for K = 3 and 2.68, 2.89 for K = 4.
   - **G5, random baseline.** Exponent 2.81. N³(log N)^{−1.0 to −1.2} fits with rms 0.02–0.05, against rms 0.14–0.28 for N² times a log power.
   - **G3, near-extremal.** Stays within a factor 1.0–4.3 of N|U|²/v + NK², which is ≈ N²/log v. This is Chen–Korsky's N² bound, close to tight on these configurations.
   - **P5 (actual images), near-extremal.** Exponent 1.40 / 1.48 / 1.52. P5/N² falls from about 0.5–1 to 0.01–0.2. The fits are noisy for K = 3 (rms 0.67).
   - **G5p, near-extremal.** Exponent 1.40 / 1.67 / 1.78. The fit N²(log N)^{−1.2 to −1.9} is as good as or better than the free power law (rms 0.06–0.15). **On the random baseline**, the local slope of G5p rises steadily: 1.1 → 2.02 for K = 3 over N = 36 to 9629, and it is still rising at the end.

   **[Heuristic]** *Verdict on the 6/5 route.*
   - (a) The natural length-5 encoding is dead. Its possible-image set behaves like N|U|³/v, which is N^{3−o(1)} under |U| ≈ N. This is the Claim C count, now seen on near-extremal configurations and not only random ones.
   - (b) A cleverer encoding is not refuted, but nothing here supports one. The actual image count (= P5) is well below N², but only because K ≤ 6 sits far below the regime that matters. The inequality P5 ≲ N² can only bite when K ≳ N^{1/5}, and at those K the search cannot find any |U| ≤ N (at K = 6, |U|/N ≈ 2.4). So by construction this test cannot refute the route.
   - (c) The only set found with about N² elements is G5p. It needs both inner steps to be window-prime multiples with midpoints in U. Bounding G5p a priori by N² is itself an incidence count for 3-term progressions inside U, of the same kind as the target. On random configurations its local slope is still climbing through 2.

   Net: the 6/5 route stays open only in the weak sense that nothing here refutes it. The cheap test cannot settle it, and nothing here gives a mechanism for it.

## Routes tried and why they failed
- Szemerédi–Trotter / planar Furstenberg incidence bounds — need K ≥ N; useless at K = N^{o(1)} (cost wall).
- Chen–Korsky length-3 path count — exponent 4/3. The count {(d,x,w)} is ≈ N² even on random configurations, so the loss is in the counting step itself.
- Length-5 paths with the natural encoding (d0, x1, x2, w) — the image set is N^{3−o(1)}, giving exponent 7/5 (L ≲ N^{2/5}), worse than 4/3 (Result 2, confirmed by Result 6).
- Length-5 paths with a cleverer encoding (target exponent 6/5) — not refuted; numerics cannot reach the regime that decides it; the only N²-sized candidate set needs an a-priori incidence bound as hard as the problem (Result 6, open).
- Arithmetic Kakeya — would give exponent 1, but the hypothesis is Kakeya-hard in every dimension (qualitative wall; Result 3).
- Known Katz–Tao-type arithmetic Kakeya bounds — exponent about 1.40, worse than 4/3.
- Claim E, "constructions built from residues mod small primes cannot beat n·exp(O(log n/log log n))" — **withdrawn**. The adversarial agent found the step from the per-prime bound (Result 4) to the actual union invalid. The per-prime bound only controls collisions between points with the same step index j. It says nothing about collisions between different step indices, or about passing from residues to integers. The agent also claimed every relevant collision is cross-index once j > Q/2. That overstates it: in Chen–Korsky's own construction K stays below Q/2, so same-index collisions are what it uses. But that does not rescue Claim E. It remains a guess.
- Direct search for Hall failures — finds |U| < N only at K = 3 (here up to N = 9629, |U|/N = 0.63). Too small a range for exponents.

## Code
All in this folder; Python 3 + numpy, gcc.
- `search.c` (compiled to `search`) — best-response local search. Usage: `./search v D K sweeps seed r|c`. It prints `N |U|` followed by one `p b_p` line per prime. This is a C rebuild of the earlier session's `search711.py`, using the same move rule.
- `run.sh`, `run_big.sh` — generate all configurations into `cfg/` on 2 cores (about 1.2 and 2.4 minutes).
- `count.py` — P3, P5, G3, G5 and G5u for one configuration, with FFT convolutions for the G-counts. Usage: `python3 count.py cfg/<file> K`.
- `count_p.py` — G5p. Running it directly also runs a brute-force check.
- `brute.py` — brute-force check of `count.py`: it enumerates paths and their distinct images, and enumerates the possible-image sets directly.
- `analyze.py`, `analyze2.py`, `analyze3.py` — build `results.json` and the fits. Their output is in `analysis.txt`, `analysis2.txt` and `analysis3.txt`. Run them in that order.
- The earlier session's scripts (`search711.py`, `shear.py`, `checkB.py`) were not preserved. Results 4 and 5 rest on the outputs recorded in that session.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
