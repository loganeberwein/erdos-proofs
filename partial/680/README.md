# Erdős Problem #680 — partial results (part i)

**Problem** ([erdosproblems.com/680](https://www.erdosproblems.com/680)). (i) Is it true that for every large n there is some k ≥ 1 such that the smallest prime factor of n + k exceeds k² + 1? (ii) Can one show this fails if k² + 1 is replaced by e^{(1+ε)√k} + C_ε? **Prize:** none. Both parts are formalized in google-deepmind/formal-conjectures as `Erdos680.erdos_680.parts.i` (`∀ᶠ n in atTop, ∃ k ≠ 0, (n + k).minFac > k^2 + 1`) and `parts.ii`, and both are live conjectures.io bounty targets. This folder treats part (i); the formal statement matches it.

**Status of the problem** (as of 2026-11-25): open.

## Results here

1. **[Computed]** *Exact exceptions below 2·10⁸.* Let k(n) be the least k with lpf(n + k) > k² + 1. Only k with k² + 1 < n + k can work, so n is an exception iff no such k works. For 1 ≤ n ≤ 2·10⁸ the exceptions are exactly n ∈ {1, 3, 7, 13, 23, 31, 113, 115}. Exhaustive, using a smallest-prime-factor table (`rec680.c`).
2. **[Computed]** *k(n) stays tiny.* The record values of k(n) up to 2·10⁸ are listed in `rec680_2e8.log`. The largest is k(92529139) = 162, against √n ≈ 9619 available and (log n)² ≈ 336. Every record is attained with n + k prime, just after a large prime gap.
3. **[Proved]** *A prime in (n, n + √n − 1] suffices.* If p = n + k is prime with k ≤ √n − 1, then k² + 1 ≤ n − 2√n + 2 < p. So part (i) follows from "prime gaps after n are below √n for all large n", an Oppermann-strength statement (open even under RH).
4. **[Proved]** *For large k only primes can help.* If lpf(n + k) > k² and k⁴ > n + k, then n + k has at most one prime factor (two would multiply to more than k⁴), so n + k is prime. Hence for k > (2n)^{1/4} the only witnesses are primes, and a witness that is not prime must have k ≤ (2n)^{1/4} with n + k free of primes up to k².
5. **[Proved, from the literature]** *Unconditionally, part (i) holds with k² replaced by k^1.904.* Baker–Harman–Pintz (2001) give a prime in [x, x + x^0.525] for all large x, so some p = n + k with k ≤ n^0.525 is prime, and lpf(n + k) = p > n ≥ k^{1/0.525} ≥ k^1.904.
6. **[Proved, from the literature plus the 2026 proof of RH]** *Part (i) holds with k² replaced by about k²/(4·log²(k+2)).* Dudek–Grenié–Molteni (Int. J. Number Theory 12 (2016), arXiv:1503.05403, Thm 1.1) prove under RH: for x ≥ 2 there is a prime in (x − c√x·log x, x + c√x·log x) with c = 1/2 + 2/log x. Choose x with x − c√x·log x = n: the prime p = n + k has 1 ≤ k < 2c√x·log x = (1 + o(1))√n·log n. Since f(k) = k²/log²(k+2) is increasing, f(k) ≤ f(k_max) = (4 + o(1))·n, so lpf(n + k) = p > n ≥ (1/4 − ε)·k²/log²(k+2) for all large n. RH status: Alpöge's Lean proof of RH (released 20 Nov 2026) was certified by the Lean FRO and Mathlib Initiative (leanprover-community blog, "Lean verification of the Riemann Hypothesis"), and google-deepmind/formal-conjectures now marks `riemannHypothesis` as solved, citing [Al26]. Our independent referee's web search did not surface these pages, so if that proof were ever withdrawn this item becomes conditional on RH. Either way it is a short chain of known results, not a new idea: it shows the problem asks to remove a factor of log²k.

## Kernel card

1. **Kernel, in plain terms.** Every large n has, within distance k of it, a number whose prime factors all exceed k², for some k. By items 3–6, two sufficient routes exist:
   - (a) Prime gaps after n are below √n for all large n (Oppermann strength). Under RH the gap is at most about √n·log n, so this misses by a log factor.
   - (b) For some k ≤ (2n)^{1/4}, the number n + k has no prime factor up to k².
   [Likely] The kernel is sufficient, not core: part (i) does not obviously imply (a). Route (a) is a famous open problem (Oppermann/Legendre type), so it is not easier. Route (b) is the genuinely narrower target.
2. **Missing primitive.** For route (b): find, in an interval of length L next to an arbitrary n, an integer with no prime factor up to L². Known: Iwaniec's bound on Jacobsthal's function guarantees an integer free of primes up to about c·√L in every interval of length L. The target needs primes up to L², a gap of a factor 4 in the exponent. Route (b) cannot hold for every interval: with primes up to L² available, Jacobsthal-type constructions make whole intervals much longer than L have small factors. What protects the conjecture is the size of n. The Chinese remainder theorem lets an n of size e^{(1+o(1))K log K} kill every k ≤ K (give the k-th value its own prime p_k ≤ k² + 1), so it kills about log n/log log n values of k (explicit examples: n ≈ 1.26·10¹³ with k(n) = 22). The witness must therefore come from k between about log n/log log n and n^{1/4}, where n's residues are not adversarial but also not controlled. A proof must explain why n's residues modulo the primes up to k² cannot conspire for every k in that range.
3. **Required ingredients.** Multiplicative: the small prime factors of n + k (all must be above k²). Additive: the shift by k, with a threshold that grows with k. They meet in the residues of n modulo primes up to k², which n fixes once and for all.
4. **Suppliers.**
   - (a) Prime-gap bounds: RH gives √n·log n; to drop the log needs pair-correlation-type input (Dudek–Grenié–Molteni note it would give o(√x·log x)). Cost: an unproved conjecture.
   - (b) Jacobsthal-type sieve bounds: exponent 1/2 known (Iwaniec), 2 needed.
   - (c) An averaging argument over k: show that the number of k ≤ K with n + k free of primes up to k² is positive for every n, using the large sieve over the moduli ∏_{p ≤ k²} p. This fails because those moduli are far beyond √K.

   Cheap test of (a) versus (b): composite witnesses matter. The records of k(n) (item 2) are prime witnesses, but at the start of each record prime gap below 2·10⁸ the least witness is composite and tiny: after the prime 189695659 (gap 234) the witness is k = 4, n + 4 = 139·1364717; after 122164747 (gap 222) it is k = 4, n + 4 = 59·163·12703. With prime witnesses only, the maximum of k(n) below 2·10⁸ would be 234, not 162, and for 200 ≤ n ≤ 2·10⁶ about 73% of n have a composite least witness (referee's computation). So route (b) is what keeps k(n) small in practice, while route (a) is the cleaner sufficient statement.
5. **Dial.** The exponent e in "lpf(n + k) > k²/(log k)^e for some k": item 6 gives e = 2 using RH (now proved); without RH, item 5 gives exponent 1.904 in place of 2. The problem needs e = 0 with exponent 2.

## Routes tried and why they failed
- RH-based prime gaps — fall short by (log k)², see item 6 (a qualitative wall: removing the log needs more than RH).
- Sieve on a short interval — the needed sifting range (L²) is far beyond any sieve's reach (√L).
- Searching for exceptions — none above 115 up to 2·10⁸, and k(n) never exceeds 162 there.

## Code
- `rec680.c`: records of k(n) and the exceptional n. Build `gcc -O3 -o rec680 rec680.c`; run `./rec680 200000000` (about 800 MB). Log: `rec680_2e8.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review (an independent Claude instance re-derived items 1–4 with separate code, and corrected the derivation in item 6, the Iwaniec and CRT statements, and a wrong claim that composite witnesses are never needed); it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
