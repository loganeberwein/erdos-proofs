# Erdős Problem #647 — partial results

**Problem** ([erdosproblems.com/647](https://www.erdosproblems.com/647)). Let τ(m) be the number of divisors of m. Is there an n > 24 with max_{m<n} (m + τ(m)) ≤ n + 2? (Picture: each m "covers" the numbers up to m + τ(m) − 2; is any n > 24 left uncovered?) **Prize:** $44 (for an example).

**Status of the problem** (as of 2026-11-25): open. The problem page reports no search beyond n = 24 and no claimed solution. Erdős notes that a fixed-window version follows from Schinzel's Hypothesis H.

## Results here

**1. [Computed] No solution in 25 ≤ n ≤ 10^10 (exhaustive).** Segmented sieve computing τ(m) exactly for every m, keeping the running maximum R = max_{m<n}(m + τ(m)) and testing R ≤ n + 2 for every n up to 10^10 (split across cores in ranges [2, 10^8), [10^8, 5·10^9), [5·10^9, 10^10)). Cross-check: an independent Python brute force (sympy divisor counts) agrees exactly up to 2·10^5, where the only solutions are n ∈ {3, 4, 5, 6, 8, 10, 12, 24}.

**2. [Proved] Necessary condition: a Cunningham-type prime chain.** If n > 24 is a solution, then n − 1, (n − 2)/2 and (n − 4)/4 are all prime. Sketch: the condition requires (n − k) + τ(n − k) ≤ n + 2, i.e. τ(n − k) ≤ k + 2, for every k ≥ 1. k = 1: τ(n−1) ≤ 3, so n − 1 is 2, 4, a prime or a prime square; for n > 24 it is odd, so n is even. k = 2: n − 2 is even with τ(n−2) ≤ 4, so n − 2 ∈ {2, 4, 8} or n − 2 = 2p with p an odd prime; hence n ≡ 0 (mod 4). Then n − 1 ≡ 3 (mod 4) is not an odd square, so n − 1 is prime. k = 4: n − 4 ≡ 0 (mod 4) with τ(n−4) ≤ 6 forces n − 4 = 4q with q prime (or n − 4 ∈ {4, 8, 16, 32}, all with n ≤ 36, excluded by item 1). Writing q = (n − 4)/4, the primes q, 2q + 1 = (n−2)/2, 4q + 3 = n − 1 form a doubling chain (each is twice the previous plus 1). For n = 24 the chain is 5 → 11 → 23 (with 2 → 5 below it), which is why 24 works. Checked by brute force (item 2′ validation) and by a fresh AI referee.

**2′. [Proved] Stronger necessary condition: a 4-term prime chain.** If n > 72 is a solution then, with q = (n − 4)/4 as in item 2, either
- q = 2w + 1 and w, 2w + 1, 4w + 3, 8w + 7 are all prime (n = 8w + 8), or
- q = 4w + 1 and w, 4w + 1, 8w + 3, 16w + 7 are all prime (n = 16w + 8).

Proof: take k = 8, so τ(n − 8) ≤ 10, and n − 8 = 4(q − 1). Write q − 1 = 2^v·w with w odd and v ≥ 1, so τ(n − 8) = (v + 3)·τ(w). If w = 1, then q = 2^v + 1 is a Fermat prime with v ≤ 7, so q ∈ {3, 5, 17} and n ∈ {16, 24, 72}. If w is prime, 2(v + 3) ≤ 10 gives v ∈ {1, 2}. If τ(w) ≥ 3, then 3(v + 3) ≤ 10 is impossible. ∎ Only k ∈ {1, 2, 4, 8} are used. Validation (`validate647.py`, exact τ sieve): every n in (72, 10^7] that passes the four conditions τ(n − k) ≤ k + 2 for k ∈ {1, 2, 4, 8} is one of 284 chains of exactly these two forms. The chain search below finds the same 284. Mod 3 and mod 5 force w ≡ 14 (mod 15) in the first form and w ≡ 7 (mod 15) in the second (apart from w = 5 in the first form, which gives n = 48; the second form has no small exception). Chain form is equivalent to passing the k ∈ {1, 2, 4, 8} filter (τ(n − 8) = 8 in the first form and 10 in the second), which is why the counts match. A fresh AI referee checked every case of item 2′, re-derived the 284 independently, and checked `fullcheck` against an independent full-range τ computation on all 284 chains to 10^7 and on 24 chains just above 10^12.

**1′. [Computed] No solution in 25 ≤ n ≤ 10^12 (exhaustive via item 2′).** `chain647.c` enumerates every w for which one of the two 4-prime chains holds with n ≤ 10^12. It uses a wheel modulo 2·3·…·19, trial division to 1223, then deterministic 64-bit Miller–Rabin. For each chain it checks the full condition τ(n − k) ≤ k + 2 for every 1 ≤ k ≤ 16384, with an exact segmented divisor-count sieve on [n − 16384, n). The code is valid for n ≤ 2.5·10^13 (its sieve primes stop at 5·10^6); beyond that it could only report a false SOLUTION, never miss one. Larger k need no check: for m < 2^45, the Nicolas–Robin bound τ(m) ≤ m^{1.5379·log 2/log log m} gives τ(m) < 16,000, so m + τ(m) < n for m < n − 16384.
   Result: 2,493,794 four-prime chains with n ≤ 10^12 (1,645,715 of the first form, 848,079 of the second), and every one fails the full condition. Together with the exhaustive item 1 this covers every n in [25, 10^12], 100× past the earlier limit.

**3. [Computed] Deficit statistics.** With deficit d(n) = R − n (a solution needs d ≤ 2), counted on windows [10^6, 1.2·10^6], [10^8, 1.2·10^8], [10^9, 1.1·10^9], [10^10, 1.01·10^10]:
- For fixed slack D, the share of n with d(n) ≤ D falls about 15–35× per factor of 10 in n (faster than 1/n).
- The smallest deficit seen is about 12 near 10^8 and 17–20 near 10^10.

**4. [Heuristic] Probably no further solution.** Each n is covered about log n times on average, giving escape probability roughly 1/n before the extra small-m constraints; extrapolating the deficit data suggests fewer than 10^−3 expected solutions above 10^10 in total. Evidence only.

## Kernel card

1. **Kernel, in plain terms.** *Yes direction (wins the prize):* find a 4-prime chain (item 2′) for which every number n − k with k ≤ about (log n)^1.4 has at most k + 2 divisors. *No direction:* show every large n has some m slightly below it with τ(m) > n − m + 2. A sufficient form: for some A, every interval of length (log x)^A below x contains a number with more than (log x)^A divisors. [Likely] Any A slightly above 1.4 works heuristically. Numbers with ω ≥ 2.02·log log x have density about (log x)^{−0.40}, so a window of length (log x)^{1.4} expects about (log x)^1 of them; 1.4 is exactly the threshold.
2. **What shrank.** [Certain] Candidates shrank from every n to 4-term Cunningham-type chains (item 2′). [Likely] By the Bateman–Horn heuristic that is about one n in (log n)^4; the count to 10^11 is 365k, against 243k from that estimate. The search reached 10^11 in 2 minutes on 2 cores, against the earlier exhaustive sieve's 10^10.
3. **Missing primitive (no direction).** A lower bound for the number of divisors that holds in *every* interval of polylogarithmic length, not just almost every one. Matomäki–Radziwiłł-type results give almost all short intervals; excluding the exceptional intervals is the wall.
4. **Certified wall.** [Certain] Any argument that uses only finitely many k fails. By Erdős's remark, Hypothesis H predicts infinitely many n that pass every condition with k ≤ K, for each fixed K. A proof of "no" must therefore use constraints whose number grows with n. Any finite-window sieve or congruence argument satisfies all its own ingredients in the Hypothesis-H model, so it cannot work unless it disproves Hypothesis H for that system of forms. A referee gave the explicit system: n = M·t with M = lcm(1..K)², where n − k = k·(Mt/k − 1) has τ = 2τ(k) ≤ k + 2 whenever the second factor is prime, and the K forms are admissible.
5. **Same primitive as #891.** [Likely] Both kernels ask to show that a growing family of linear forms cannot all have few prime factors. In #891 the forms are evaluated at 3-smooth numbers; here they are n − k at a prime chain.
6. **Dial.** For the yes direction: the search bound, now 10^12. For the no direction: the window exponent A, where a proof for all intervals is needed and only almost-all intervals are known.

## Routes tried and why they failed
- Proving "yes" (constructing a solution) — qualitative wall: needs prime chains of Sophie Germain/Cunningham type (q, 2q + 1, …) in specified positions, whose infinitude is unproved; Hypothesis H would give a window version.
- Proving "no" via the Chinese remainder theorem — a number with many divisors within distance y gets only about y^(0.69/log log y) divisors, not the ~y needed.
- Smooth numbers in short intervals — known results need windows of length about √n; the problem needs windows of length (log n)^C (about (log n)^1.4).
- Sieve upper bounds on the prime chains — the bound grows with N instead of shrinking, so it cannot exclude solutions.
- Shadows of highly composite numbers alone — too sparse relative to their divisor counts.
- GRH — no help; the obstruction is simultaneous primality, not zero locations.
Missing primitive: every n has some m within about (log n)^1.4 below it with τ(m) larger than its distance to n.

## Code
- The original 10^10 sieve script (item 1) was not preserved. It was a C segmented sieve: segments of 2^22, trial division by primes ≤ √HI to build τ, and a running max of m + τ(m).
- `chain647.c` (item 1′). Build: `gcc -O3 -march=native -fopenmp chain647.c -o chain647 -lm`. Run: `./chain647 1e12 [BRANCH]`. Logs: `run_1e11.log`, `run_1e12_branch1.log`, `run_1e12_branch2.log` (the 10^12 run was split after an interruption). Lines starting `near` would mark chains with window deficit ≤ 6; there are none up to 10^12.
- `validate647.py` (item 2′ validation and the brute-force solution list up to 10^7). Log: `validate_1e7.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
