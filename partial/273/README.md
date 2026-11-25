# Erdős Problem #273 — partial results

**Problem** ([erdosproblems.com/273](https://www.erdosproblems.com/273)). Is there a covering system (finitely many congruences r_i mod m_i with distinct moduli, every integer satisfying at least one) all of whose moduli are of the form p − 1 with p ≥ 5 prime? **Prize:** none known to us.
**Status of the problem** (as of 2026-11-25): open (statement as in the formal-conjectures entry). It sits in the Erdős–Selfridge cluster: coverings with distinct moduli from a restricted set with divergent reciprocal sum. The odd-moduli version (Erdős–Selfridge) is open; odd squarefree moduli are impossible (Balister–Bollobás–Morris–Sahasrabudhe–Tiba, distortion method).

## Results here
1. **[Reduction]** *Parity reduction.* Every p − 1 is even, so a congruence r mod (p − 1) only hits integers of the parity of r. Writing n = 2k + ε, the congruences with r ≡ ε (mod 2) become k ≡ (r − ε)/2 (mod m), m = (p − 1)/2. Hence a covering for #273 exists iff Z can be split into two coverings of Z, using disjoint sets of half-moduli m with 2m + 1 prime, m ≥ 2. The half-modulus m = 2 (modulus 4, p = 5) can be used by at most one of the two. Consequence: if no covering of Z with distinct moduli m ≥ 3, 2m + 1 prime exists, then #273 has answer **no**. Proof checked by hand.
2. **[Reduction]** *2-adic path reframing.* Write each modulus m = 2^v·u with u odd. By CRT, r mod m is a 2-adic cylinder (one class mod 2^v) times an odd congruence r mod u. The system covers Z iff for every 2-adic integer x, the odd congruences whose cylinders contain x cover Z/U (U = product of the odd parts). Each path needs its own odd covering; a congruence with v factors of 2 lies on a 2^(−v) fraction of paths.
3. **[Proved]** *Repeat budgets* (in the reduced problem, m ≥ 3 with 2m + 1 prime). Odd part 3 occurs only as m = 3·2^v with 3·2^(v+1) + 1 prime: v ∈ {0, 1, 4, 5, 7, 11, 17, 29, …}. Copies with v ≥ 1 cover at most Σ 2^(−v) = 0.6021 of paths (union bound), so at least **39.8%** of paths carry odd part 3 at most once. For odd part 5 the extra-copy measure is at most 0.2659, so at least **13.2%** of paths carry both 3 and 5 at most once. (Values recomputed with v up to 200.)
4. **[Proved]** *No fixed-weighting certificate.* For any probability measure on Z/M, every modulus m has a residue class of weight ≥ 1/m, and Σ 1/m over allowed moduli diverges (it contains Σ 2/(p−1)). So no fixed measure (LP-dual certificate) can rule out a covering; a non-existence proof must adapt to the covering, as the distortion method does.
5. **[Computed]** *Searches* (greedy plus local search over divisors of M; not exhaustive, so they give upper bounds on the best uncovered share only):
   - With m = 2 allowed, a covering of one parity class exists easily: 25 moduli at M = 720,720.
   - Without m = 2, no covering found: uncovered share 0.94%, 0.57%, 0.40%, 0.23% for M from 720,720 up to 12,972,960; uncovered count rises 6,784 → 29,972.
   - Varying the power of 2 in M: 2⁴ 0.59%, 2⁵ 0.41%, 2⁶ 0.30%, 2⁷ 0.25%, 2⁸ 0.235%; adding the prime 17 (M ≈ 73.5 million) gives 0.224%. 87% of uncovered numbers fell in one parity class.
   - In a greedy solution at M = 4,324,320 (32 paths), the worst path has one copy of odd part 3 and 2% uncovered despite odd budget Σ 1/u = 1.90; covered paths had budget ≈ 1.63 but usually two copies of 3.
   - Distortion-method tail bound T(P₀) for moduli with a prime factor > P₀: 1.20, 0.66, 0.39, 0.038, 0.014, 0.0042, 0.0011 at P₀ = 3, 5, 7, 47, 97, 199, 499. Greedy uncovered share with P₀-smooth moduli: 15%, 3.0%, 0.6% at P₀ = 3, 5, 7.
6. **[Heuristic]** Extrapolating both trends, they would cross only near P₀ ≈ 10⁵ (about 9,600 primes), out of reach. The gap shrinking like ∏(1 − c/q) would push toward a covering existing; the plateau near 0.2% pushes the other way. Our lean: undecided (earlier 70/30 "no" withdrawn).

## Routes tried and why they failed
- Greedy/local search without m = 2 — never completes; evidence only.
- Distortion method with uniform constants — cost wall: tail bound 15–60× larger than the uncovered share it must beat.
- Distortion with per-prime δ plus exact small-prime treatment — would need ~20× sharper constants.
- Backtracking at lcm above 10⁸ — not run; contradicted by the plateau.
- Missing lemma (would finish "no" with item 3): an odd system using each small odd part once leaves an explicit positive share uncovered. This is a quantitative Erdős–Selfridge statement, proved only for squarefree odd moduli; path systems include 9, 63, 81.

## Code
Original scripts not preserved.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
