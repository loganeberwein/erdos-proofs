# Erdős Problem #458 — partial results

**Problem** ([erdosproblems.com/458](https://www.erdosproblems.com/458)). Write [1,…,N] for lcm(1,…,N) and p_k for the k-th prime. Is it true that [1,…,p_{k+1}−1] < p_k·[1,…,p_k] for every k ≥ 1? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open, marked falsifiable (one counterexample would disprove it). Erdős–Graham call it "almost certainly" true but beyond current methods: excluding two squares of primes in one gap is essentially Legendre's conjecture, and small primes cause further trouble. No partial results are attributed on the page.

Notation: g_k = p_{k+1} − p_k. A "power" means a proper prime power q^a, q prime, a ≥ 2.

## Results here
1. **[Reduction]** *Exact reformulation.* lcm(1..N) = ∏_q q^{⌊log_q N⌋}, so lcm(1..p_{k+1}−1)/lcm(1..p_k) = ∏ q over the powers q^a lying strictly inside (p_k, p_{k+1}), one factor per power. So #458 at k holds exactly when that product of bases is < p_k. A single power has base q < √p_{k+1} < p_k, so only gaps containing two or more powers can fail. Checked by hand.
2. **[Computed]** *Exhaustive verification below 2^64.* No counterexample for any k with p_{k+1} < 2^64 ≈ 1.845·10^19. Method: segmented sieve for all primes q < 2^32; every q² and every q^a (a ≥ 3) below 2^64 generated and merged in order (203,481,024 powers: 203,280,221 prime squares, 200,803 higher powers); for each consecutive pair of powers the program searched for a prime between them, and for groups of ≥ 2 powers took p_k = prevprime of the first. Primality: deterministic Miller–Rabin with Sinclair's bases {2, 325, 9375, 28178, 450775, 9780504, 1795265022} (proven correct below 2^64), Montgomery arithmetic, trial division by primes ≤ 97; agreed with sympy on 33,010 test values including strong base-2 pseudoprimes such as 3825123056546413051. 256 chunks on 2 threads, about 80 minutes. The 10^12 counts reproduce an earlier run and the forum comment exactly.

   | p_{k+1} below | gaps with ≥ 1 power | gaps with ≥ 2 powers |
   |---|---|---|
   | 10^12 | 80,065 | 5 |
   | 10^16 | 5,782,462 | 5 |
   | 2^64 | 203,481,019 | 5 |

   The only gaps below 2^64 with two powers (none has three): (7,11) ∋ 2^3, 3^2, ratio 6/7; (23,29) ∋ 5^2, 3^3, ratio 15/23; (113,127) ∋ 11^2, 5^3, ratio 55/113; (2179,2203) ∋ 3^7, 13^3, ratio 39/2179; (32749,32771) ∋ 181^2, 2^15, ratio 362/32749. Largest ratio overall: 6/7 at p_k = 7.
3. **[Proved]** *Lemma 1 (spacing).* If g_k ≤ 2√p_k, the powers in (p_k, p_{k+1}) have distinct, pairwise coprime exponents. Proof: if q^a ≠ r^b in the gap had gcd(a,b) = d ≥ 2, both are d-th powers m^d < m′^d with m^d > p_k; for d = 2 their difference is ≥ 2m+1 > 2√p_k ≥ g_k, and for d ≥ 3 it is ≥ d·m^{d−1} > 3p_k^{2/3} ≥ 2√p_k. ∎ Checked by hand.
4. **[Proved]** *Lemma 2 (product).* If p_k ≥ 11, g_k ≤ 2√p_k and no power in the gap has exponent ≥ 5, the product of bases is < p_k. Proof: each base is < p_{k+1}^{1/a}; by Lemma 1 the exponents are pairwise coprime in {2,3,4}, so the exponent set is a singleton, {2,3} or {3,4}, and Σ 1/a ≤ 5/6. The product is < (p_k + 2√p_k)^{5/6}, which is < p_k iff p_k + 2√p_k < p_k^{6/5}: true at p_k = 11 (17.63 < 17.77) and beyond, false at 7 (handled in item 2). ∎ Boundary checked at 7 and 11.
5. **[Proved]** *Theorem A.* If p_k ≥ 11, g_k ≤ 2√p_k and #458 fails at k, the gap holds powers with pairwise coprime exponents whose reciprocals sum to at least 1 − log(1 + 2/√p_k)/log p_k. Hence at least three powers, at most one even exponent, at least two coprime odd exponents (≥ 3 and ≥ 5). Minimal patterns: {2,3,5}; {2,3} plus two or more exponents from {7,11,13,…}; or patterns without 3 needing ≥ 5 powers. Extreme cases checked (empty gap, the aligned case 8, 9 ∈ (7,11), the {2,3} case).
6. **[Computed]** *Conditional sweep past 2^64.* Every q^b with b ≥ 5 and 2^64 < q^b < 10^30 was visited; for each, the exact enclosing prime gap was found with both endpoints proved prime by PARI isprime (APR-CL), and every power in that gap was listed. 90,496 such gaps; none contains a second power; largest ratio 3.8·10^{−16}. Combined with Theorem A: *if g_k ≤ 2√p_k whenever 2^64 < p_{k+1} < 10^30, then #458 holds for all k with p_{k+1} < 10^30.* This is conditional on that gap bound; it is not an unconditional verification to 10^30.
7. **[Proved]** *Conditional on ABC.* Under ABC, two coprime powers q^a, r^b near N with odd a, b ≥ 3, 5 are at least N^{7/15−ε} apart (apply ABC to q^a, r^b and their difference d, whose radical is ≤ q·r·d; only this one-line sketch survives in the sources). So ABC plus g_k ≤ p_k^{7/15−δ} for all large k implies #458 for k ≥ k_0, with k_0 ineffective.
8. **[Proved]** *Exceptional set.* The number of k with p_k ≤ x where #458 fails is ≪ x^{1/5}/log x (powers q^b ≤ 2x with b ≥ 5, by Theorem A) plus #{k : g_k > 2√p_k, p_k ≤ x} ≪ x^{1/10+ε} (Heath-Brown's Σ_{g_n ≥ √p_n} g_n ≪ x^{3/5+ε}, applied dyadically; cited, not re-derived). So #458 holds for all k ≤ K outside a set of size ≪ K^{1/5}, against the trivial ≪ K^{1/2}. No published statement was found, but it is an easy observation.

## Routes tried and why they failed
- Zero-density version — trivial (only O(√x/log x) powers exist), so not worth stating as a result.
- Legendre-type gap bound g_k ≤ 2√p_k alone — qualitative wall: the residual case is a perfect-power near-coincidence (e.g. a prime cube and a prime fifth power within 2√N with no prime between), and no unconditional lower bound on |x^3 − y^5| beats a power of log.
- Any new idea about lcm's — cost wall: failure needs either a gap longer than ~2√p_k or three powers in one gap; excluding either needs Legendre-strength information on primes in short intervals.

## Code
Original scripts not preserved. The sources name them: gaps458.c (2^64 search) and sweep_b5.py (PARI-proved sweep to 10^30), with raw outputs full_2e64.txt and sweep_1e30.txt.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
