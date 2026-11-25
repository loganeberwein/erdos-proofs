# Erdős Problem #488 — partial results

**Problem** ([erdosproblems.com/488](https://www.erdosproblems.com/488)). Let A be a finite set of positive integers and B the set of all multiples of elements of A. Write f(x) = |B ∩ [1,x]|. Is it true that f(m)/m < 2·f(n)/n for every m > n ≥ max A? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open, marked falsifiable. The constant 2 is best possible (A = {a}, n = 2a−1, m = 2a). Source: Erdős [Er61, Er66], Guy E5. The [Er61] variant with a ∤ n has counterexamples (Cambie; Alexeev and Aristotle), which do not touch this version. The forum thread reports the cases 2 ∈ A and a "tripod" family proved, 13 failed approaches and checks of 25,000+ cases; its PDFs were not read for this work.

## Results here
1. **[Proved]** *Window theorem.* If max A ≤ n < 4·min A, then (n+1)·f(m) ≤ 2m·f(n) for every m > n; in particular f(m)/m < 2f(n)/n, i.e. #488 holds at this n. Proof (largest-divisor partition). Let G = B ∩ [1,n], so |G| = f(n).
   1. Each b ∈ B ∩ [1,m] has a largest divisor g in G. Write b = g·y and k = ⌊n/g⌋. If y had a divisor j with 2 ≤ j ≤ k, then j·g ∈ G (it is ≤ n and a multiple of an element of A), divides b and exceeds g. So y has no divisor in [2, k].
   2. Hence f(m) ≤ Σ_{g∈G} R(k, m/g), where R(k, Y) = #{y ≤ Y : y has no divisor in [2,k]}.
   3. Every g ∈ G is ≥ min A > n/4, so k ≤ 3. As g > n/(k+1) and g is an integer, g ≥ (n+1)/(k+1). With z = m/(n+1) ≥ 1, m/g ≤ (k+1)z, and: k = 1: R ≤ 2z; k = 2 (odd y ≤ 3z): R ≤ (3z+1)/2 ≤ 2z; k = 3 (y ≤ 4z coprime to 6): R ≤ (4z+2)/3 ≤ 2z.
   4. Summing, f(m) ≤ 2z·|G| = 2m·f(n)/(n+1). ∎
   Checked by hand, and by brute force: 254,364 direct checks with n < 4·min A (random A with min A < 60, |A| ≤ 5, m up to 20n+20), no violation, 60 cases of exact equality. Novelty unchecked against the forum PDFs.
2. **[Proved]** *Reduction: large elements can be dropped (for the sharpened form S below).* If S holds at n for A′ = {a ∈ A : a ≤ n/2}, it holds at n for A. The sources record this statement as proved but not its argument; the following reconstruction was checked by hand. Each a ∈ A with n/2 < a ≤ n that is not a multiple of another element adds exactly 1 to f(n) (its only multiple ≤ n is a) and at most ⌊m/a⌋ ≤ 2m/(n+1) to f(m). So (n+1)f(m) ≤ (n+1)f′(m) + 2m ≤ 2m·f′(n) + 2m = 2m·f(n), one element at a time.
3. **[Conjecture]** *Two sharpenings, each implying #488.* S: (n+1)·f(m) ≤ 2m·f(n); U: (⌊n/2⌋+1)·f(m) ≤ m·f(n) (U implies S, S implies #488). S is scale-invariant and tight for singletons. No violation on all primitive A ⊆ [2,22] with |A| ≤ 4 (m up to 40·max A) plus hill-climbing over sets of up to 10 elements below 500; sampled beyond that range.
4. **[Computed]** *Peel induction (numerical only).* In every tested case some element of A can be removed while S survives with margin ≥ 0.25 (random primitive A below 80 with up to 6 elements, several n each; adversarial hill-climbs; structured families u·({2} ∪ odd primes ≤ 2t+1)). There is no rule for which element to peel and no proof.

## Routes tried and why they failed
- Halving induction U(⌊n/2⌋) ⇒ U(n) — counterexample to the needed doubling lemma f(2h) ≥ 2f(h): A = {3,4}, h = 9 gives f(18) = 9 < 10. The sparse version with constant c(h) ("Lemma D") is false too, with 59,852 counterexamples in the exhaustive small-case test.
- Statement W (on average the divisors of b lying in G sum to ≥ ⌊n/2⌋+1) — holds in all 65,696 cases tested, but it is U plus exact boundary terms, i.e. a renaming.
- Largest-divisor partition for k = ⌊n/g⌋ ≥ 4 — counterexample to the per-element bound under the S threshold first at n = 9, g = 2, m = 14; for large k, R has density ≈ ∏_{p≤k}(1−1/p) ≈ 0.56/log k ≫ 2/(k+1). Fake object: if each g's leftover multiples were exactly the rough y, Σ R would grow like log log n, which would break even A = {2}.
- What is missing — qualitative wall: joint control of the divisors of b in G that are not multiples of its largest G-divisor (those g′ with lcm(g, g′) > n).

## Code
Original scripts not preserved. The sources name search.py, exh.py, excess.py, stress.py, peel.py, peel2.py (first pass) and lemD.py, W.py, perel.py, perelS.py (second pass).

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
