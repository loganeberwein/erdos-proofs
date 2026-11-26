# Erdős Problem #891 — partial results

**Problem** ([erdosproblems.com/891](https://www.erdosproblems.com/891)). Let p₁ = 2 < p₂ < … be the primes and k ≥ 2. Is it true that, for all large n, every interval [n, n + p₁⋯p_k) contains an integer with more than k distinct prime factors? It is open even for k = 2: must every 6 consecutive large integers include one with at least 3 distinct prime factors? **Prize:** none. The formal statement `Erdos891.erdos_891` (all k ≥ 2, with ω = number of distinct prime factors) matches the problem and is a live conjectures.io bounty target. The k = 2 case is the formal variant `erdos_891.variants.case_k_2`.

**Status of the problem** (as of 2026-11-25): open. Schinzel deduced from Pólya's theorem (gaps between k-smooth numbers are unbounded) that the statement holds with p₁⋯p_k replaced by p₁⋯p_{k−1}·p_{k+1}. Weisenberg observed that Dickson's conjecture implies it fails with p₁⋯p_k − 1 in place of p₁⋯p_k, so the length p₁⋯p_k would be exactly sharp.

## Results here

1. **[Proved]** *Anchor reduction (all k).* An interval of length P_k = p₁⋯p_k contains exactly one multiple m₀ of P_k, and ω(m₀) ≥ k. If every element of the interval has ω ≤ k, then ω(m₀) = k, so m₀ has no prime factor beyond p₁, …, p_k: m₀ is a p_k-smooth multiple of P_k. So every counterexample interval sits next to one of the sparse numbers 2^{a₁}3^{a₂}⋯p_k^{a_k} (all a_i ≥ 1). This is the mechanism behind Schinzel's use of Pólya's theorem.
2. **[Proved]** *For k = 2, three forms must be prime powers.* Write m₀ = 6u with u = 2^x·3^y. Uniformly for every anchor: for d ∈ {±2, ±3, ±4}, the part of m₀ + d coprime to 6 must be a prime power or 1, since m₀ + d already has a prime factor 2 or 3. When x ≥ 2 and y ≥ 1 (that is, 4 | u and 3 | u; m₀ = 2^a3^b with a ≥ 3, b ≥ 2), each of the six positions of the window forces three of the numbers 3u ± 1, 2u ± 1, 3u/2 ± 1 to be prime powers, because they are coprime to 6 and appear multiplied by 2, 3 or 4 inside the window:
   - window m₀..m₀+5 or m₀−1..m₀+4: 3u+1, 2u+1, 3u/2+1;
   - window m₀−5..m₀ or m₀−4..m₀+1: 3u−1, 2u−1, 3u/2−1;
   - window m₀−2..m₀+3: 3u−1, 3u+1, 2u+1;
   - window m₀−3..m₀+2: 2u−1, 3u−1, 3u+1.
3. **[Computed]** *k = 2 holds for every n from 4373 to 10¹⁰⁰.* By item 1 it suffices to examine the six windows around every number 2^a·3^b (a, b ≥ 1) up to 10¹⁰⁰ + 5. For each window, some element was proved to have ω ≥ 3: by finding 3 distinct primes below 10⁵, or 2 of them plus a cofactor > 1, or 1 plus a cofactor proved composite and not a prime power (Miller–Rabin plus exact root extraction), or by full factorisation when below 10¹⁵. No window was left undecided. The windows in which all six elements have ω ≤ 2 are exactly those starting at the n listed in `windows_1e100.log`, the largest being n = 4372: 4372 = 2²·1093, 4373 (prime), 4374 = 2·3⁷, 4375 = 5⁴·7, 4376 = 2³·547, 4377 = 3·1459. Independently re-checked by a fresh AI referee: rerun output byte-identical; a sieve for ω to 10^6 finds exactly the same 69 failing placements; separate code (sympy isprime and perfect_power, small primes below 10^4) certified all 207,032 placements with 4373 ≤ n ≤ 10^100.
4. **[Computed]** *No covering system kills the k = 2 forms at small periods.* For each window type in item 2, with exponents (x, y) taken modulo M and all primes p ≤ 5·10⁶ whose multiplicative orders of 2 and 3 divide M, the share of residue pairs (x, y) where none of the three forms is divisible by such a p stays at 3.0–6.2% for M = 2520. It decreases only slowly with M (9–19% at M = 12), so a covering-congruence proof of k = 2 is not visible at these periods (`cover891.py`). The share is not monotone in M (for the first window type it is 2.6% at M = 720 but 3.0% at M = 2520, because 720 does not divide 2520). For M = 12, 360, 720 and 2520 the prime lists are complete: gcd(2^M − 1, 3^M − 1) divided by the listed primes leaves 1. This rules out coverings of the triples only; a covering could also use the other window elements m₀ ± 1, m₀ ± 5.
5. **[Heuristic]** *Finitely many counterexamples for k = 2.* Each window type needs three numbers of size about u to be prime powers simultaneously, with probability about (log u)⁻³, while there are about s numbers u = 2^x3^y with log u ≈ s. The expected number of counterexamples, Σ s·s⁻³, converges, so the k = 2 statement is almost certainly true, consistent with item 3.

## Kernel card

1. **Kernel, in plain terms (k = 2).** For all large m₀ = 2^a·3^b (a, b ≥ 1) and each of the six window positions, at least one of the three listed numbers m₀ + d (d ∈ {±2, ±3, ±4}) has a part coprime to 6 that is not a prime power. For a ≥ 3, b ≥ 2 these are the triples of item 2 (for example 3u − 1, 3u + 1, 2u + 1); the families a ∈ {1, 2} and b = 1 give separate one-parameter forms (for a = 1: 3^b ± 1 with powers of 2 removed, and 3^b ± 2). [Certain] The kernel implies the k = 2 case but is strictly stronger: a referee found anchors where a whole triple consists of prime powers yet the window still fails, e.g. u = 157,464, j = 3, where 944,783 = 7·139·971. [Likely] It is still a real shrink, and it is a statement about prime values of three linear forms evaluated at 3-smooth numbers, which isolates exactly what is missing. For general k the same reduction replaces 3-smooth numbers by p_k-smooth multiples of P_k and triples by larger sets of forms.
2. **Missing primitive.** A way to prove that linear forms evaluated along a multiplicative semigroup ({2^x3^y}) cannot be simultaneously prime infinitely often. Available tools prove compositeness only by algebraic factorisation (x^m + 1 for odd m, as for Fermat numbers) or by covering congruences (Sierpiński numbers). Item 4 indicates no covering exists at moderate periods, and algebraic factorisation fails because the forms mix the bases 2 and 3.
3. **Required ingredients.** Multiplicative: the anchor m₀ is smooth (item 1). Additive: the window's neighbours m₀ ± d. They interact in the forms c·u ± 1, which must have few prime factors.
4. **Suppliers.**
   - (a) Covering congruences: cheap test in item 4, uncovered share about 3% at M = 2520; probably no covering, as in Erdős #203's 2^k3^l m + 1 (see `../203`).
   - (b) Algebraic factorisation (Aurifeuillian-type identities) for special exponent classes: covers only thin subsets of (x, y).
   - (c) Linear forms in logarithms (Baker) with S-unit equations: controls when a form equals a fixed prime power, not when it is some prime.

   None supplies primality obstructions for generic exponents. The problem is in the same family as "finitely many primes of the form 2^x3^y ± 1 in pairs", which is open.
5. **Dial.** For k = 2: the verified range, now 10¹⁰⁰ (from item 3, essentially free to extend because the anchors are sparse), and the uncovered share in item 4, which would need to reach 0 for a covering proof. For the full problem: the largest k for which the statement is proved, today none.

## Routes tried and why they failed
- Covering systems for the k = 2 triples — uncovered share plateaus near 3% (item 4).
- Pólya/Schinzel — gives the statement only for the longer window p₁⋯p_{k−1}p_{k+1}.

## Code
- `windows891.py`: exhaustive k = 2 check via item 1. Run `python3 windows891.py 100` (needs gmpy2, sympy). Logs: `windows_1e30.log`, `windows_1e100.log`.
- `cover891.py`: covering search. Run `python3 cover891.py 2520 5000000`. Log: `cover891.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
