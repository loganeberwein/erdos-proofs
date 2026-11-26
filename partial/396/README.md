# Erdős Problem #396 — partial results

**Problem** ([erdosproblems.com/396](https://www.erdosproblems.com/396)). Is it true that for every k there is an n such that the product n(n−1)(n−2)⋯(n−k) divides the central binomial coefficient C(2n, n)? **Prize:** none on erdosproblems.com. The formal statement `Erdos396.erdos_396` (`∀ k, ∃ n, descFactorial n (k+1) ∣ centralBinom n`, google-deepmind/formal-conjectures) matches the problem (n ≤ k gives a zero product, which never divides). It is a live conjectures.io bounty target.

**Status of the problem** (as of 2026-11-25): open in the erdosproblems.com database. Known:
- n + 1 always divides C(2n,n) (Catalan numbers).
- Pomerance (2015): for each k ≥ 1, n + k | C(2n,n) for a set of n of density 1, and so does the product (n+1)⋯(n+k). For each k ≥ 0, n − k | C(2n,n) for infinitely many n, with upper density at most 1 − log 2.
- Ford–Konyagin (2021): for each fixed ℓ, n^ℓ | C(2n,n) on a set of positive density.
- The smallest n for each k is OEIS A375077, known for k ≤ 16 (a(16) ≈ 2.0·10¹⁶, J. Dehorty, July 2026). So the answer is yes for every k ≤ 16, and the open question is all k.

## Results here

1. **[Computed]** *Counts at three scales.* `count396.c` counts n ≤ X with n(n−1)⋯(n−k) | C(2n,n), exactly (Kummer: v_p(C(2n,n)) is the number of carries in n + n base p; primes p > k divide at most one block element and are checked per element, primes p ≤ k are summed over the block). It reproduces A375077 for k = 1..6 (2, 2480, 8178, 45153, 3648841, 7979090).

   | k | n ≤ 10⁶ | n ≤ 10⁷ | n ≤ 10⁸ |
   |---|---|---|---|
   | 1 | 12,028 | 131,467 | 1,393,355 |
   | 2 | 1,136 | 13,567 | 150,726 |
   | 3 | 121 | 1,323 | 15,625 |
   | 4 | 11 | 120 | 1,551 |
   | 5 | 0 | 14 | 159 |
   | 6 | 0 | 2 | 17 |

   Densities rise slowly (k = 1: 1.20%, 1.31%, 1.39% at 10⁶, 10⁷, 10⁸; ratio c_k/c_{k−1} ≈ 0.10–0.11 at 10⁸). [Heuristic] This is consistent with a positive limit c_k for each k, which would answer "yes". But log x changes only by a factor 1.33 across these scales, so a density decaying like (log x)^(−δ) cannot be ruled out, and the k = 5, 6 counts are too small to say anything. Verified independently by a referee with a separate Legendre-formula implementation and exact binomials (n ≤ 20000).
2. **[Proved]** *Every block element must be √(2n)-smooth.* If a prime p > √(2n) divides some n − i with 0 ≤ i ≤ k and p > 2i (automatic once n > 2k²), then n = pm + i with m < p/2, the base-p digits of n are (i, m), and doubling n produces no carry. (More generally, if p^e exactly divides n − i, the lowest e base-p digits of n are (i, 0, …, 0), so all needed carries must come from digit e + 1 upward.) So p ∤ C(2n,n), and the product does not divide. (Pomerance's 1 − log 2 bound is this fact for a single element.) Consequently a solution needs k + 1 consecutive integers with no prime factor above √(2n).
3. **[Computed]** *Smoothness is not enough.* Among 1000 ≤ n ≤ 2·10⁷ whose whole block n−k..n is n^θ-smooth, the share that satisfies the divisibility is 11% (k = 1), 3.5% (k = 2), 1.1% (k = 3) for θ = 0.5, and 19% for k = 1 at θ = 0.33 (20,711 blocks). The θ = 0.33 figures for k = 2, 3 rest on 406 and 9 blocks and are not meaningful. Note θ = 0.5 conditions on √n-smoothness, slightly stronger than the necessary √(2n)-smoothness of item 2. So the carry conditions, not only smoothness, decide the problem (`smoothtest.c`).
4. **[Reduction]** *Where the difficulty sits (contrast with the solved n + i version).* If p^e exactly divides n + i and p ≥ 2i, the lowest e base-p digits of n are those of p^e − i, namely p − i, p − 1, …, p − 1, so doubling n produces at least e carries automatically. This covers every prime p ≥ 2k; the small primes p < 2k are handled in Pomerance's density-1 result by a different mechanism (almost all n have about log n/(2 log p) carries in base p, far more than the bounded block exponent). For n − i the lowest digit is i < p/2 and never carries, so every prime p > 2k dividing the block must find its carries in higher digits of n. The load-bearing object of the solved version (the automatic lowest-digit carry) is exactly what the n − i version lacks.

## Kernel card

1. **Kernel, in plain terms.** For each k, show that infinitely many (or just one) n have both: (a) the k + 1 numbers n−k, …, n all free of prime factors above √(2n); and (b) for every prime p dividing the block, enough carries when n is doubled in base p to cover p's exponent in the block. [Likely] It is a real shrink: it isolates the two ingredients (joint anatomy of consecutive integers, and digit control for medium primes). It is the core, since every solution satisfies (a) and (b), and it is equivalent to the problem, not easier, unless one of the two ingredients is supplied.
2. **Missing primitive.** A lower bound (not an asymptotic) for k + 1 consecutive smooth integers, plus digit equidistribution on that set. Concretely: (A) #{n ≤ x : n − k, …, n all x^ε-smooth} ≫ x (or even ≫ x^{1−δ}); (B) among those n, few have a prime p ≤ x^ε dividing the block with too few carries (n has at least 1/ε digits in base p, so this is equidistribution of base-p digits restricted to the smooth set, plus a union bound). If every prime factor is below x^ε, the medium primes that Ford–Konyagin had to handle are absent by construction. (A) is known for pairs (natural-density results for n, n+1 both smooth at almost all scales, arXiv:2512.01739) but, as far as we know, open for three or more consecutive integers; Balog–Wooley give infinitely many smooth strings from polynomial families but no density.
3. **Required ingredients.** Multiplicative: the factorizations of n − i (smoothness, medium primes). Additive: the digits of n in base p (carries when doubling). They meet at one step: each prime p dividing n − i must see a carry in n + n at some digit above the lowest.
4. **Suppliers.**
   - (a) Ford–Konyagin's anatomy method: positive density for a single n − i; cost to extend is joint independence of large prime factors of consecutive integers, open in this strength.
   - (b) Balog–Wooley-type constructions of long strings of n^ε-smooth consecutive integers (polynomial families whose values factor), combined with equidistribution of the base-p digits of those polynomial values. If every prime factor is below n^ε, n has at least 1/ε base-p digits, and the expected number of carries is about 1/(2ε), comfortably above typical exponents. Cheap test of (b): item 3, where shrinking θ from 1/2 to 1/3 raises the conditional success rate for k = 1 from 11% to 19%, but it stays far from 100%, so digit control is a necessary second ingredient, not a by-product.
   - (c) A pure inclusion–exclusion lower bound: fails, since the union bound over the k + 1 block elements subtracts more than the main term; this does not show that full independence is needed, only that a one-sided lower bound for consecutive smoothness is.
5. **Dial.** k: the largest k for which existence is proved. Today k ≤ 16 by computation (A375077). The theorem needs all k. A positive-density statement for each fixed k (as Ford–Konyagin did for k = 0) would finish it.

## Routes tried and why they failed
- Exhaustive search for each k — proves one k at a time; cost grows by about ×10 per k (item 1), so it cannot reach all k.
- Smoothness alone (Balog–Wooley strings) — necessary but not sufficient (item 3).
- Copying Pomerance's n + i argument — fails at the lowest digit (item 4).

## Code
- `count396.c`: exact counts. Build `gcc -O3 -o count396 count396.c`; run `./count396 100000000 8` (needs 400 MB for X = 10⁸; KMAX must be ≤ 63 because of fixed array sizes). Logs: `count_1000000.log`, `count_10000000.log`, `count_100000000.log`.
- `smoothtest.c`: conditional test of item 3. Build `gcc -O3 -o smoothtest smoothtest.c -lm`; run `./smoothtest 20000000 3 0.5`. Log: `smoothtest.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review (an independent Claude instance re-implemented the counts, and corrected the n + i explanation, the kernel's independence claim and the statistics of item 3); it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
