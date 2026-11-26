# Erdős Problem #317 — partial results

**Problem** ([erdosproblems.com/317](https://www.erdosproblems.com/317)). (1) Is there c > 0 such that for every n ≥ 1 there are δ_k ∈ {−1, 0, 1} with 0 < |Σ_{k≤n} δ_k/k| < c/2ⁿ? (2) Is it true that for all sufficiently large n, every nonzero signed sum satisfies |Σ_{k≤n} δ_k/k| > 1/[1, …, n], where [1, …, n] = lcm(1, …, n)? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open. For (2), ≥ 1/[1,…,n] is trivial for nonzero sums (the sum is a multiple of 1/lcm), so (2) asks that the value ±1/lcm(1..n) is never attained for large n; it is attained for small n, e.g. 1/2 − 1/3 − 1/4 = −1/12. For (1), Kovač and van Doorn (forum comments) obtain nonzero sums below 2^(−n(log log log n)^(1+o(1))/log n); van Doorn's heuristic suggests this is the true order.

Notation: L = lcm(1, …, n); G = n!/L.

## Results here (part 2)
1. **[Reduction]** *Necessary congruences.* If Σ_{k≤n} δ_k/k = ±1/L, then for every prime p in (n/2, n]: δ_p ≠ 0 and L/p ≡ ±1 (mod p). Proof: multiply by L to get Σ δ_k·(L/k) = ±1. For k ≠ p, p divides L/k, because p is the only multiple of p in [1, n] (2p > n) and v_p(L) = 1. Reducing mod p leaves δ_p·(L/p) ≡ ±1 (mod p); hence δ_p = ±1 and L/p ≡ ±1. ∎ Checked by a fresh AI referee. This is about n/(2 log n) simultaneous congruences.
2. **[Reduction]** *Wilson reformulation.* For p in (n/2, n], L/p ≡ ±1 (mod p) is equivalent to G ≡ ±(n − p)! (mod p). Proof: v_p(n!) = v_p(L) = 1, so p ∤ G and n!/p = G·(L/p). Mod p, n!/p = (p−1)!·(p+1)(p+2)⋯n ≡ (−1)·(n−p)! by Wilson's theorem. So L/p ≡ ±1 iff G ≡ ∓(n−p)!, i.e. G ≡ ±(n−p)! (mod p). ∎
3. **[Computed]** *Part 2 holds for 5 ≤ n ≤ 3000* (pure Python): for each n from 3 to 3000, compute L/p mod p for every prime p in (n/2, n] as the product of the maximal prime powers q^e ≤ n, q ≠ p, reduced mod p, and test membership in {1, p − 1}. The congruences of item 1 hold for all such p only at n = 3, 4; so for every n in [5, 3000] some prime p in (n/2, n] violates them, and no signed sum equals ±1/L. Exhaustive in n. (Small cases re-checked independently with exact lcm for n < 400: survivors {3, 4}.)
4. **[Computed]** *Extension to 5 ≤ n ≤ 1,000,000* (C program, incremental): residues (L/p mod p) for the active primes p in (n/2, n] are updated as n passes each prime power (multiply by q) and initialised from scratch when n is prime; 64-bit arithmetic, products below p² ≤ 10¹². Reported: the condition fails at every n from 5 to 1,000,000. The original program was not preserved; item 4′ supersedes it with shipped, cross-validated code.

5. **[Computed]** *Extension to 5 ≤ n ≤ 10^10* (`wit317.c`, exhaustive in n). For every n the program exhibits a witness prime p in (n/2, n] with L/p mod p ∉ {1, p − 1}. It works with a group of the 8 largest primes at a rebuild point. Their residues L/p mod p are computed exactly by one sweep over all primes ≤ n, then updated by multiplying by q at every prime-power event q^e ≤ n. A witness p is dropped at n = 2p or when its residue becomes ±1; if no group member is usable, the group is rebuilt at the current n (8, 64, … primes, finally all of (n/2, n]). Up to 10^10 the group was rebuilt 32 times and never needed enlarging: at every n, one of the 8 primes that were largest at the most recent rebuild point (all still in (n/2, n]) is a witness. The last enlargement tier is capped at 65,536 primes; hitting the cap is reported as a failure, and it never happened. 2.6 minutes on one core. Cross-validation (`validate317.py`, exact lcm via Python integers, n ≤ 4000): with the forbidden set widened to [1, T] ∪ [p − T, p − 1] for T = 3, 6, 10, 20 (8, 18, 35, 51 survivors), the C program reports exactly the same survivor lists. With T = 1 both report none. All of those survivors are ≤ 63, where the group already holds every prime in (n/2, n], so this check does not exercise long incremental updates. A fresh AI referee therefore also logged every certified interval (n_start, n_end, p, r) and verified the log with separate exact code. Checks: p prime, p ≤ n_start, 2p > n_end, exact residue r ∉ {0, 1, p − 1} at both ends, no prime power inside the interval, and the intervals tile [5, N]. Up to 2·10^5: all 36,298 records checked, 0 bad. Up to 10^8: tiling and the no-event condition checked for all 11.5M records, residues for 289 sampled records, 0 bad.
6. **[Reduction]** *Top-prime form.* Let P be the product of the primes in (n/2, n] and L′ = L/P. The congruences of item 1 all hold if and only if L′·T ≡ 1 (mod P) for some T = Σ_p ε_p·P/p with ε_p ∈ {±1}. Proof: T ≡ ε_p·P/p (mod p), so L′·T ≡ (L′P/p)·ε_p (mod p), which is ≡ 1 iff L/p ≡ ε_p (mod p). ∎ In words, the inverse of L′ modulo P must land in a set of 2^{π(n)−π(n/2)} residues out of about e^{n/2}.

## Kernel card (part 2)

1. **Kernel, in plain terms.** For every large n, at least one of the two largest primes p in (n/2, n] has lcm(1, …, n)/p ≢ ±1 (mod p). [Certain] This implies part 2 (item 1). It is sufficient, not equivalent: part 2 could hold even if the congruences hold, because they are only necessary.
2. **Why two primes.** [Likely] Heuristically each residue is ±1 with probability 2/p. With only the largest prime, the expected number of failures diverges very slowly (the residue changes only at primes and prime powers, so the count behaves like Σ_p 2/p ≈ 2 log log x), so a one-prime kernel is probably false infinitely often. With two primes the sum Σ (2/p)² converges. [Certain] Direct counts (`top2_317.c`, exact residues, n ≤ 10^6): the top prime alone fails in 7 runs (n = 8, 11, 29, 169, 343, 787, 15773, each with residue 1), against about 4–5 expected from Σ2/p. The top two primes never both fail.
3. **Missing primitive.** A non-±1 value of L/p mod p, equivalently (by item 2) of (n − p)!·G^{−1} mod p, for some p in a short top range of primes. That is a joint statement about factorials modulo varying primes. Known results on factorials modulo p (Garaev–Luca–Shparlinski type) fix p and vary the argument; here both move together. [Guessing] An exponential-sum bound over primes p ∈ (n − H, n] for the function p ↦ (n − p)!/G mod p would suffice, but no such bound is known for H small.
4. **Certified wall.** [Certain] Shape-only arguments are blocked by the CRT fake model under Routes: an integer with the same size and the same top-prime structure as L can satisfy every congruence. A proof must use the exact value of L modulo p.
5. **Classification.** [Likely] Mostly a renaming, of Wilson/Wieferich type. What shrank is the number of primes that matter (two, against about n/(2 log n)) and the verified range (10^10 against 10^6).
6. **Dial.** How many top primes are needed, and how far n is verified.

## Results here (part 1)
None. Counting arguments get within a factor of about log n of the target and do not close it (rated Likely).

## Routes tried and why they failed
- Proving the congruences of item 1 fail for all large n — qualitative wall: for n = p prime the condition reads lcm(1..p−1) ≡ ±1 (mod p), essentially the product of all primes below p (with prime-power corrections) mod p, and no Wilson-type theorem exists for it.
- Size/shape arguments — fake model: by CRT one can build an integer with the same size and the same top-prime factorisation as L that satisfies every congruence, so any proof must use the exact value of L modulo p, not its shape. Same wall as #288's one-term case and #1059.
- Part 1 — blocked; a "no" answer needs anticoncentration lower bounds for signed harmonic sums, for which no method is known.

## Code
- The original scripts for items 3–4 were not preserved.
- `wit317.c` (item 5). Build: `gcc -O3 -march=native wit317.c -o wit317 -lm`. Run: `./wit317 1e10`. Logs: `run_1e6.log`, `run_1e9.log`, `run_1e10.log`.
- `validate317.py N T` (item 5 cross-validation, exact). Log: `validate_4000.log`.
- `top2_317.c` (kernel card item 2 counts). Log: `top2_1e6.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
