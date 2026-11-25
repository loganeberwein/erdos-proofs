# Erdős Problem #317 — partial results

**Problem** ([erdosproblems.com/317](https://www.erdosproblems.com/317)). (1) Is there c > 0 such that for every n ≥ 1 there are δ_k ∈ {−1, 0, 1} with 0 < |Σ_{k≤n} δ_k/k| < c/2ⁿ? (2) Is it true that for all sufficiently large n, every nonzero signed sum satisfies |Σ_{k≤n} δ_k/k| > 1/[1, …, n], where [1, …, n] = lcm(1, …, n)? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open. For (2), ≥ 1/[1,…,n] is trivial for nonzero sums (the sum is a multiple of 1/lcm), so (2) asks that the value ±1/lcm(1..n) is never attained for large n; it is attained for small n, e.g. 1/2 − 1/3 − 1/4 = −1/12. For (1), Kovač and van Doorn (forum comments) obtain nonzero sums below 2^(−n(log log log n)^(1+o(1))/log n); van Doorn's heuristic suggests this is the true order.

Notation: L = lcm(1, …, n); G = n!/L.

## Results here (part 2)
1. **[Reduction]** *Necessary congruences.* If Σ_{k≤n} δ_k/k = ±1/L, then for every prime p in (n/2, n]: δ_p ≠ 0 and L/p ≡ ±1 (mod p). Proof: multiply by L to get Σ δ_k·(L/k) = ±1. For k ≠ p, p divides L/k, because p is the only multiple of p in [1, n] (2p > n) and v_p(L) = 1. Reducing mod p leaves δ_p·(L/p) ≡ ±1 (mod p); hence δ_p = ±1 and L/p ≡ ±1. ∎ (Rated Likely in the chat; the three-line argument is reproduced here and was not independently reviewed.) This is about n/(2 log n) simultaneous congruences.
2. **[Reduction]** *Wilson reformulation.* For p in (n/2, n], L/p ≡ ±1 (mod p) is equivalent to G ≡ ±(n − p)! (mod p). Proof: v_p(n!) = v_p(L) = 1, so p ∤ G and n!/p = G·(L/p). Mod p, n!/p = (p−1)!·(p+1)(p+2)⋯n ≡ (−1)·(n−p)! by Wilson's theorem. So L/p ≡ ±1 iff G ≡ ∓(n−p)!, i.e. G ≡ ±(n−p)! (mod p). ∎
3. **[Computed]** *Part 2 holds for 5 ≤ n ≤ 3000* (pure Python): for each n from 3 to 3000, compute L/p mod p for every prime p in (n/2, n] as the product of the maximal prime powers q^e ≤ n, q ≠ p, reduced mod p, and test membership in {1, p − 1}. The congruences of item 1 hold for all such p only at n = 3, 4; so for every n in [5, 3000] some prime p in (n/2, n] violates them, and no signed sum equals ±1/L. Exhaustive in n. (Small cases re-checked independently with exact lcm for n < 400: survivors {3, 4}.)
4. **[Computed]** *Extension to 5 ≤ n ≤ 1,000,000* (C program, incremental): residues (L/p mod p) for the active primes p in (n/2, n] are updated as n passes each prime power (multiply by q) and initialised from scratch when n is prime; 64-bit arithmetic, products below p² ≤ 10¹². Reported: the condition fails at every n from 5 to 1,000,000. No independent cross-validation of this program is recorded beyond its range overlapping the Python check.

## Results here (part 1)
None. Counting arguments get within a factor of about log n of the target and do not close it (rated Likely).

## Routes tried and why they failed
- Proving the congruences of item 1 fail for all large n — qualitative wall: for n = p prime the condition reads lcm(1..p−1) ≡ ±1 (mod p), essentially the product of all primes below p (with prime-power corrections) mod p, and no Wilson-type theorem exists for it.
- Size/shape arguments — fake model: by CRT one can build an integer with the same size and the same top-prime factorisation as L that satisfies every congruence, so any proof must use the exact value of L modulo p, not its shape. Same wall as #288's one-term case and #1059.
- Part 1 — blocked; a "no" answer needs anticoncentration lower bounds for signed harmonic sums, for which no method is known.

## Code
Original scripts not preserved.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
