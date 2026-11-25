# Erdős Problem #288 — partial results

**Problem** ([erdosproblems.com/288](https://www.erdosproblems.com/288)). Are there only finitely many pairs of intervals of positive integers I₁, I₂ such that Σ_{n∈I₁} 1/n + Σ_{n∈I₂} 1/n is an integer? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open, even when |I₂| = 1 (one interval plus a single term 1/m). The one-interval version (a harmonic sum over one interval is never an integer, apart from the trivial {1}) is classical.

## Results here
1. **[Proved]** *Prime-in-top-half lemma.* Let N be the largest integer in I₁ ∪ I₂, N ≥ 4. No prime p in (N/2, N] lies in I₁ ∪ I₂. Proof: p is the only multiple of p in [1, N] since 2p > N. If p lies in exactly one interval, the sum is (integer-free part) + 1/p + (terms with denominators prime to p), so its p-adic valuation is −1; if p lies in both, the p-part is 2/p and p is odd, so again the valuation is −1. Either way the sum is not an integer. Checked by hand.
   - **Corollary.** By Bertrand's postulate (N/2, N] contains a prime, so the interval containing N cannot reach below N/2; it lies inside a run of consecutive composites ending at N, hence has length at most the prime gap there, ≤ N^0.525 for large N (Baker–Harman–Pintz).
2. **[Heuristic]** The other interval must then have harmonic sum close to 1 (mod 1), and every prime in its own top half must divide some element of the short interval; this forces its top end below roughly N^0.53. Argued in the chat and rated Likely; no complete proof written.
3. **[Reduction]** *One-term case (I₂ = {m}).* Let D be the reduced denominator of Σ_{n∈I₁} 1/n. For an integer total, adding 1/m must cancel every prime of D; for each prime p in the top half of I₁ this gives the congruence D/p ≡ −1 (mod p) (stated in the chat without a written-out derivation; not independently checked). Heuristically this holds with probability about ∏ 1/p over those primes, so finitely many solutions are expected, but no method proves a specific integer avoids such residue classes.
4. **[Computed]** *Exhaustive search to endpoints 7000.* All intervals [a, b] with 1 ≤ a ≤ b ≤ 7000 (about 24.5 million) were hashed by their harmonic sum modulo two primes P₁ = 2147483647 and P₂ = 2147483629 (both > 7000, so all inverses exist). Every pair whose hashed sum equals an integer k ∈ {1, …, 29} (covers all possible totals, since each interval sum is ≤ H(7000) < 10) was a candidate, and every candidate was verified with exact rational arithmetic. Hash collisions can only add false candidates, so the search is exhaustive. A direct exact-arithmetic search (fractional-part matching) to b ≤ 800 agreed. Result: exactly 7 solutions, all tiny, each with a single-number interval; the non-obvious ones are 1/2 + 1/3 + 1/6 = 1, 1 + 1/2 + 1/3 + 1/6 = 2, and 1/3 + 1/4 + 1/5 + 1/6 + 1/20 = 1.

## Routes tried and why they failed
- p-adic argument at primes in (N/2, N] — gives item 1 but only bounds the long interval's length; it cannot exclude short intervals in prime gaps.
- One-term case via congruences D/p ≡ −1 (mod p) — qualitative wall: requires showing a specific integer avoids specific residue classes modulo many primes at once; same wall as #317 part 2 (lcm(1..n)/p ≡ ±1 mod p) and #1059.

## Code
Original scripts not preserved.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
