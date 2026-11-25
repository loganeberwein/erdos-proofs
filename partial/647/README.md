# Erdős Problem #647 — partial results

**Problem** ([erdosproblems.com/647](https://www.erdosproblems.com/647)). Let τ(m) be the number of divisors of m. Is there an n > 24 with max_{m<n} (m + τ(m)) ≤ n + 2? (Picture: each m "covers" the numbers up to m + τ(m) − 2; is any n > 24 left uncovered?) **Prize:** $44 (for an example).

**Status of the problem** (as of 2026-11-25): open. The problem page reports no search beyond n = 24 and no claimed solution. Erdős notes that a fixed-window version follows from Schinzel's Hypothesis H.

## Results here

**1. [Computed] No solution in 25 ≤ n ≤ 10^10 (exhaustive).** Segmented sieve computing τ(m) exactly for every m, keeping the running maximum R = max_{m<n}(m + τ(m)) and testing R ≤ n + 2 for every n up to 10^10 (split across cores in ranges [2, 10^8), [10^8, 5·10^9), [5·10^9, 10^10)). Cross-check: an independent Python brute force (sympy divisor counts) agrees exactly up to 2·10^5, where the only solutions are n ∈ {3, 4, 5, 6, 8, 10, 12, 24}.

**2. [Proved] Necessary condition: a Cunningham-type prime chain.** If n > 24 is a solution, then n − 1, (n − 2)/2 and (n − 4)/4 are all prime. Sketch: the condition requires (n − k) + τ(n − k) ≤ n + 2, i.e. τ(n − k) ≤ k + 2, for every k ≥ 1. k = 1: τ(n−1) ≤ 3, so n − 1 is 2, 4, a prime or a prime square; for n > 24 it is odd, so n is even. k = 2: n − 2 is even with τ(n−2) ≤ 4, so n − 2 ∈ {2, 4, 8} or n − 2 = 2p with p an odd prime; hence n ≡ 0 (mod 4). Then n − 1 ≡ 3 (mod 4) is not an odd square, so n − 1 is prime. k = 4: n − 4 ≡ 0 (mod 4) with τ(n−4) ≤ 6 forces n − 4 = 4q with q prime (or n − 4 ∈ {8, 16, 32}, all with n ≤ 36, excluded by item 1). Writing q = (n − 4)/4, the primes q, 2q + 1 = (n−2)/2, 4q + 3 = n − 1 form a doubling chain (each is twice the previous plus 1). For n = 24 the chain is 5 → 11 → 23 (with 2 → 5 below it), which is why 24 works. Status: stated in-session as following from elementary divisor counting; the case argument above was written out afterwards and has not been independently refereed.

**3. [Computed] Deficit statistics.** With deficit d(n) = R − n (a solution needs d ≤ 2), counted on windows [10^6, 1.2·10^6], [10^8, 1.2·10^8], [10^9, 1.1·10^9], [10^10, 1.01·10^10]:
- For fixed slack D, the share of n with d(n) ≤ D falls about 15–35× per factor of 10 in n (faster than 1/n).
- The smallest deficit seen is about 12 near 10^8 and 17–20 near 10^10.

**4. [Heuristic] Probably no further solution.** Each n is covered about log n times on average, giving escape probability roughly 1/n before the extra small-m constraints; extrapolating the deficit data suggests fewer than 10^−3 expected solutions above 10^10 in total. Evidence only.

## Routes tried and why they failed
- Proving "yes" (constructing a solution) — qualitative wall: needs prime chains of Sophie Germain/Cunningham type (q, 2q + 1, …) in specified positions, whose infinitude is unproved; Hypothesis H would give a window version.
- Proving "no" via the Chinese remainder theorem — a number with many divisors within distance y gets only about y^(0.69/log log y) divisors, not the ~y needed.
- Smooth numbers in short intervals — known results need windows of length about √n; the problem needs windows of length (log n)^C (about (log n)^1.4).
- Sieve upper bounds on the prime chains — the bound grows with N instead of shrinking, so it cannot exclude solutions.
- Shadows of highly composite numbers alone — too sparse relative to their divisor counts.
- GRH — no help; the obstruction is simultaneous primality, not zero locations.
Missing primitive: every n has some m within about (log n)^1.4 below it with τ(m) larger than its distance to n.

## Code
Original scripts not preserved. The search was a C segmented sieve (segments of 2^22, trial division by primes ≤ √HI to build τ, running max of m + τ(m)).

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
