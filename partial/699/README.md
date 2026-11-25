# Erdős Problem #699 — partial results

**Problem** ([erdosproblems.com/699](https://www.erdosproblems.com/699)). Is it true that for every 1 ≤ i < j ≤ n/2 there is a prime p ≥ i dividing both C(n,i) and C(n,j)? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open, marked falsifiable. Sylvester–Schur gives a prime p > i dividing C(n,i). Erdős–Szekeres conjectured that p ≥ i can be strengthened to p > i except in special cases; the strict version fails for i = 2 at certain powers of 2, for some i = 3 cases, and once for i ≥ 4 known to them: gcd(C(28,5), C(28,14)) = 2³·3³·5 (Guy B31).

Notation: a "strict counterexample" is (n, i, j) with no prime p > i dividing both binomials. g = gcd(n, j), n = v·g, j = u·g, so j/n = u/v in lowest terms and v ≥ 2.

## Results here
1. **[Reduction]** *Prime-gap reduction.* A prime p in (n − i, n] divides both C(n,i) and C(n,j): it appears in the numerators n(n−1)⋯(n−i+1) and n(n−1)⋯(n−j+1), and p > n − i ≥ n/2 ≥ j > i keeps it out of i! and j!. So a counterexample needs n − i + 1, …, n all composite. Checked by hand.
2. **[Proved]** *i = 2 always holds.* Since j < n there is a prime p with v_p(n) > v_p(j), and then p | C(n,j) because n/gcd(n,j) divides C(n,j). If p is odd, or p = 2 with 4 | n, then p | C(n,2) = n(n−1)/2. Otherwise j = n/2 with n ≡ 2 (mod 4), and any odd prime factor of n − 1 divides both binomials. ∎
3. **[Proved]** *Lemma A.* In a strict counterexample: (a) every prime > i dividing n also divides j, so v has only prime factors ≤ i; (b) for each 1 ≤ k < i with v ∤ k, every prime power p^e ‖ n − k with p > i divides one of the numbers uk − vr, r = 0, 1, …, k. Proof of (b): in base p, n ends in the digit k followed by e − 1 zeros. Kummer: p ∤ C(n,j) requires every base-p digit of j to be ≤ the matching digit of n, so j ≡ r (mod p^e) for some r ≤ k. Then p^e | v(j − r) − u(n − k) = uk − vr (using vj = un), and uk − vr = 0 only if v | k. ∎ Checked against all 9 known strict failures.
4. **[Proved]** *Theorem B (j = n/2, i.e. v = 2), except one subcase.* With v = 2 the numbers uk − vr are odd and below i, so every odd-offset number n−1, n−3, …, n−(2⌊i/2⌋−1) has no prime factor above i. By the Laishram–Shorey bound for products of consecutive odd numbers (difference-2 progressions have a prime factor > 2⌊i/2⌋), i must be an odd prime p dividing exactly one of those numbers, to the first power only (p² would make p divide C(n,p) and C(n,n/2), by Lucas). The cases p = 3 and p = 5 were excluded by hand (the hand argument is not preserved in the sources); this kills the whole 3^a + 1 family and (28, 5, 14). Remaining open: j = n/2 with i a prime ≥ 7. **Weakest step:** the Laishram–Shorey difference-2 result was used through a citation ([7] in their paper) that could not be opened directly; it was spot-checked for every odd start below 200,000 and run lengths ≤ 40, with no failure.
5. **[Computed]** *Counterexample searches* (all i and all j decided exactly; PARI factorizations; validated by recovering the known strict failures). No counterexample in any of:

   | Search | Range |
   |---|---|
   | every n | n ≤ 2.7·10^7, and 4.5·10^7 ≤ n ≤ 6.1·10^7 |
   | n near two 47-smooth numbers (distance ≤ 59), i ≤ 60 | up to 10^15 |
   | n near two 31-smooth numbers | up to 10^18 (no new pairs after 10^12) |
   | n near two 19-smooth numbers | up to 10^28 (all pairs below 3·10^8) |
   | i = 3, n within 2 of a smooth number | 7-smooth to 10^20; 13-smooth to 10^15 |

   The smooth-pair searches target the only shape Lemma A allows; they rely on close pairs of y-smooth numbers being finite (Størmer) and saturating early.
6. **[Computed]** *Strict-version failures found (validation):* (10,3,5), (16,2,6), (28,3,14), (28,5,14), (244,3,122), (512,2,147), (2048,2,713), (2188,3,1094), (1594324,3,797162). The last, n = 3^13 + 1, is recorded in the sources as new (not among the previously known strict failures).

## Routes tried and why they failed
- Size arguments alone — counterexample: (28,5,14) passes the natural size test (1080 ≥ 32), so sizes cannot beat a constraint many n satisfy.
- Lemma A for v ≥ 3 — qualitative wall: uk − vr reaches about v·k, so for large v the condition gives no size contradiction; n is then highly smooth, exactly where the strict version really fails (n = 512, 2048 with v = n). Needs bounds on solutions of the Lemma A divisibility equations (the role Størmer plays for smooth pairs).
- Bigger exhaustive searches — cost wall: more "verified to X" does not settle a falsifiable problem.

## Code
Original scripts not preserved. The sources name s699.c (exhaustive search), smooth.c / smooth128.c (smooth near-pairs), check.py (exact checker), lemA.py (Lemma A test), ls.py (Laishram–Shorey spot check).

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
