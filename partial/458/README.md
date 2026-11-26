# Erdős Problem #458 — partial results

**Problem** ([erdosproblems.com/458](https://www.erdosproblems.com/458)). Write [1,…,N] for lcm(1,…,N) and p_k for the k-th prime. Is it true that [1,…,p_{k+1}−1] < p_k·[1,…,p_k] for every k ≥ 1? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open, marked falsifiable (one counterexample would disprove it). Erdős–Graham call it "almost certainly" true but beyond current methods: excluding two squares of primes in one gap is essentially Legendre's conjecture, and small primes cause further trouble. The forum thread (erdosproblems.com/forum/thread/458) has a check to p_{k+1} ≤ 10^12 (comment 1) and the product-of-bases equivalence of item 1 (comment 2).

Notation: g_k = p_{k+1} − p_k. A "power" means a proper prime power q^a, q prime, a ≥ 2.

## Results here
1. **[Reduction]** *Exact reformulation.* lcm(1..N) = ∏_q q^{⌊log_q N⌋}, so lcm(1..p_{k+1}−1)/lcm(1..p_k) = ∏ q over the powers q^a lying strictly inside (p_k, p_{k+1}), one factor per power. So #458 at k holds exactly when that product of bases is < p_k (this equivalence is forum comment 2). A single power has base q < √p_{k+1} < p_k, so only gaps containing two or more powers can fail. Checked by hand.
2. **[Computed]** *Exhaustive verification below 2^64.* No counterexample for any k with p_{k+1} < 2^64 ≈ 1.845·10^19. Method: segmented sieve for all primes q < 2^32; every q² and every q^a (a ≥ 3) below 2^64 generated and merged in order (203,481,024 powers: 203,280,221 prime squares, 200,803 higher powers); for each consecutive pair of powers the program searched for a prime between them, and for groups of ≥ 2 powers took p_k = prevprime of the first. Primality: deterministic Miller–Rabin with Sinclair's bases {2, 325, 9375, 28178, 450775, 9780504, 1795265022} (proven correct below 2^64), trial division by primes ≤ 97. An independent referee compared this test against gmpy2 on 28,018 values (random 64-bit numbers, near-square semiprimes, all 91 strong base-2 pseudoprimes below 3·10^6) with 0 mismatches, and recounted to 10^12 in separate Python/gmpy2 code with identical results. 256 chunks on 2 threads, about 13 minutes. Agrees with the forum comment's conclusion and closest case.

   | p_{k+1} below | gaps with ≥ 1 power | gaps with ≥ 2 powers |
   |---|---|---|
   | 10^12 | 80,065 | 5 |
   | 10^16 | 5,782,462 | 5 |
   | 2^64 | 203,481,019 | 5 |

   The only gaps below 2^64 with two powers (none has three): (7,11) ∋ 2^3, 3^2, ratio 6/7; (23,29) ∋ 5^2, 3^3, ratio 15/23; (113,127) ∋ 11^2, 5^3, ratio 55/113; (2179,2203) ∋ 3^7, 13^3, ratio 39/2179; (32749,32771) ∋ 181^2, 2^15, ratio 362/32749. Largest ratio overall: 6/7 at p_k = 7 (checked by hand: a gap with a single power has ratio q/p_k ≤ 2/3, attained at (3,5)).
3. **[Proved]** *Lemma 1 (spacing).* If g_k ≤ 2√p_k, the powers in (p_k, p_{k+1}) have distinct, pairwise coprime exponents. Proof: if q^a ≠ r^b in the gap had gcd(a,b) = d ≥ 2, both are d-th powers m^d < m′^d with m^d > p_k; for d = 2 their difference is ≥ 2m+1 > 2√p_k ≥ g_k, and for d ≥ 3 it is ≥ d·m^{d−1} > 3p_k^{2/3} ≥ 2√p_k. ∎ Checked by hand.
4. **[Proved]** *Lemma 2 (product).* If p_k ≥ 11, g_k ≤ 2√p_k and no power in the gap has exponent ≥ 5, the product of bases is < p_k. Proof: each base is < p_{k+1}^{1/a}; by Lemma 1 the exponents are pairwise coprime in {2,3,4}, so the exponent set is a singleton, {2,3} or {3,4}, and Σ 1/a ≤ 5/6. The product is < (p_k + 2√p_k)^{5/6}, which is < p_k iff p_k + 2√p_k < p_k^{6/5}: true at p_k = 11 (17.63 < 17.77) and beyond, false at 7 (handled in item 2). ∎ Boundary checked at 7 and 11.
5. **[Proved]** *Theorem A.* If p_k ≥ 11, g_k ≤ 2√p_k and #458 fails at k, the gap holds powers with pairwise coprime exponents whose reciprocals sum to more than log p_k / log(p_k + 2√p_k) (0.8356 at p_k = 11, increasing towards 1, so above 5/6). Hence at least three powers, at most one even exponent, at least two coprime odd exponents. For p_k > 2^64, where the bound exceeds 1 − 10^−11, the minimal patterns are {2,3,5}; {2,3} plus ≥ 2 exponents from {7,11,13,…}; and any pattern not containing both 2 and 3 needs ≥ 5 powers (e.g. {2,5,7,9,11}, {3,4,5,7,11}). For small p_k more patterns pass (at p_k = 11: {2,5,7}, {3,4,5,7}; {2,3,7} up to about p_k ≈ 250); these lie below 2^64 and are covered by item 2. Pattern list confirmed by a referee's exhaustive search over exponents ≤ 60. Extreme cases checked (empty gap, the aligned case 8, 9 ∈ (7,11), the {2,3} case).
6. **[Computed]** *Conditional sweep past 2^64.* Every q^b with b ≥ 5 and 2^64 < q^b < 10^30 was visited; for each, the exact enclosing prime gap was found with both endpoints proved prime by PARI isprime (APR-CL), and every power in that gap was listed. 90,496 such gaps; none contains a second power; largest ratio 3.8·10^{−16}. The one gap that straddles 2^64 itself, (2^64 − 59, 2^64 + 13), is covered by neither computation: it contains only 2^64, ratio 2/(2^64 − 59), checked separately. Combined with Theorem A: *if g_k ≤ 2√p_k whenever 2^64 < p_{k+1} < 10^30, then #458 holds for all k with p_{k+1} < 10^30.* This is conditional on that gap bound; it is not an unconditional verification to 10^30.
7. **[Proved]** *Conditional on ABC.* Under ABC, two coprime powers q^a, r^b near N with odd a, b ≥ 3, 5 are at least N^{7/15−ε} apart (apply ABC to q^a, r^b and their difference d, whose radical is ≤ q·r·d, giving d ≫ N^{1−1/a−1/b−ε}). Every odd coprime pair other than (3,5) gives exponent ≥ 11/21 > 1/2, so ABC plus g_k ≤ 2√p_k leaves only gaps holding exactly a prime square, a prime cube and a prime fifth power. So ABC plus g_k ≤ p_k^{7/15−δ} for all large k implies #458 for k ≥ k_0, with k_0 ineffective.
8. **[Proved]** *Exceptional set.* The number of k with p_k ≤ x where #458 fails is ≪ x^{1/5}/log x (powers q^b ≤ 2x with b ≥ 5, by Theorem A) plus #{k : g_k > 2√p_k, p_k ≤ x} ≪ x^{1/10+ε} (Heath-Brown, "The differences between consecutive primes, V", IMRN 2021: Σ_{g_n ≥ √p_n} g_n ≪ x^{3/5+ε}, applied dyadically; cited, not re-derived). So #458 holds for all k ≤ K outside a set of size ≪ K^{1/5}, against the trivial ≪ K^{1/2}. No published statement was found, but it is an easy observation.

## Kernel card

1. **Kernel, in plain terms.** #458 holds for all large k if both of these hold for every large N:
   - (K1, gaps) consecutive primes near N are less than 2√N apart;
   - (K2, mixed gap/near-coincidence) no prime-free stretch of fewer than 2√N consecutive integers near N contains three prime powers q^a, r^b, s^c with pairwise coprime exponents ≥ 2.

   [Certain] K1 + K2 imply #458 for large k (items 3–5). [Certain] This is a renaming, not a shrink: K1 is slightly stronger than Legendre's conjecture (Legendre only gives gaps ≲ 4√N), and K2 holds (heuristically) only because of its prime-free clause, so it is again a prime-gap statement, not a pure Diophantine one. Under ABC the residue shrinks to the single pattern {2,3,5} (item 7), a small conditional shrink. Erdős and Graham already identified the Legendre part. What the work here adds is the exact residual shape (item 5) and the computations, not a smaller kernel.
2. **Missing primitive.** Primes in every interval [N, N + 2√N]; the best known is length N^0.525 (Baker–Harman–Pintz). A separation route (|q^a − r^b| > 2√N) does not work for the pair (3,5): [Likely] heuristically pairs with |x³ − y⁵| < N^θ occur infinitely often for θ ≥ 7/15, so the ABC exponent 7/15 is essentially sharp. It can serve only for pairs other than (3,5).
3. **Required ingredients.** Multiplicative: the factorization of lcm into prime powers (item 1). Additive: where the prime powers sit relative to the primes. They interact only in the question "is there a prime between these two powers?", which is a short-interval prime question.
4. **Suppliers.** For (i): sieve plus zero-density estimates (stuck at 0.525); RH gives only √N log N, still too long by a log factor, so even RH does not settle K1. For (ii): abc gives N^{7/15−ε} separation (item 7), which pairs with a gap bound p^{7/15−δ}, a requirement stronger than K1. [Likely] No current unconditional supplier comes within a power of the target; RH comes within a log factor.
5. **Dial.** θ in "every interval [N, N + N^θ] contains a prime": 0.525 is known, and θ = 1/2 with constant 2 is needed. Separately, K2 is verified for every power q^b with b ≥ 5 below 10^30 (item 6).

## Routes tried and why they failed
- Zero-density version — trivial (only O(√x/log x) powers exist), so not worth stating as a result.
- Legendre-type gap bound g_k ≤ 2√p_k alone — qualitative wall: the residual case is a perfect-power near-coincidence (e.g. a prime cube and a prime fifth power within 2√N with no prime between), and no unconditional lower bound on |x^3 − y^5| beats a power of log.
- Any new idea about lcm's — cost wall: failure needs either a gap longer than ~2√p_k or three powers in one gap; excluding either needs Legendre-strength information on primes in short intervals.

## Code
The original scripts were lost; both were rewritten for this release and reproduce the published counts exactly.
- `gaps458.c`: the item 2 search. Build: `gcc -O3 -march=native -fopenmp gaps458.c -o gaps458 -lm`. Run: `./gaps458 1e12`, `./gaps458 1e16`, `./gaps458 2^64`. It uses deterministic Miller–Rabin with Sinclair's bases and splits the work into 256 chunks across all cores. 2^64 takes about 13 minutes on 2 cores. Logs: `run_1e12.log`, `run_1e16.log`, `run_2e64.log` (reports 203,481,024 powers, 203,481,019 gaps with ≥ 1 power, 5 gaps with ≥ 2 powers, no chunk-boundary straddles).
- `sweep_b5.py`: the item 6 sweep, using cypari2. Run: `python3 sweep_b5.py 2`. Log: `sweep_1e30.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
