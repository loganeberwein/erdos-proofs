# Erdős Problem #364 — partial results

**Problem** ([erdosproblems.com/364](https://www.erdosproblems.com/364)). Can three consecutive integers all be powerful (every prime factor appears at least squared)? Erdős, Mollin and Walsh conjectured no. **Prize:** none on erdosproblems.com. The formal statement `Erdos364.erdos_364` (`¬ ∃ n, Powerful n ∧ Powerful (n+1) ∧ Powerful (n+2)`, google-deepmind/formal-conjectures) matches the problem and is a live conjectures.io bounty target.

**Status of the problem** (as of 2026-11-25): open. Known: four consecutive powerful numbers are impossible (one is 2 mod 4). If a triple exists its smallest term is 7, 27 or 35 mod 36 (Beckon 2019). Conditional on abc there are only finitely many triples. Special families centered at a perfect cube are excluded (Chan 2025; Ma 2026; and others). Any triple contains a consecutive powerful pair, and the list of all such pairs below 10²² (OEIS A060355) contains none that extends to a triple.

## Results here

1. **[Reduction]** *Triples are Pell solutions.* If n, n+1, n+2 are powerful, the middle term t = n+1 is divisible by 4 (two even terms would include one ≡ 2 mod 4), n and n+2 are odd and coprime, and t² − 1 = n(n+2) = B·Y² where B = bf is squarefree and B | Y (writing n = a²b³, n+2 = e²f³ with b, f squarefree). So (t, Y) solves the Pell equation t² − B·Y² = 1. Conversely, if t is even and powerful and t² − 1 = BY² with B squarefree and B | Y, then t − 1 and t + 1 are coprime with powerful product, so all three are powerful. Every positive Pell solution is a power of the fundamental one, found by the continued fraction of √B.
2. **[Computed]** *No triple with b·f ≤ 10⁶ and middle term below 10⁵⁰⁰⁰.* For every squarefree B in [2, 10⁶] and every Pell solution t < 10⁵⁰⁰⁰ (77,049,720 solutions in total), the conditions 4 | t, B | Y and "no prime ≤ 10⁴ divides t exactly once" were tested. Two solutions survived (B = 1671, a 4056-digit t; B = 161231, a 1281-digit t). Trial division up to 10⁸ then found a prime dividing each exactly once (227257 and 114997), so neither is powerful. The reduction was validated against brute force (`validate.py`, log `validate.log`): for t ≤ 2·10⁵ the Pell walk lists exactly the same 12 values of t with t² − 1 powerful (3, 17, 26, 99, …, 114243). Run parameters are in `pell_params.txt`; an independent referee recomputed both survivors and confirmed the eliminating primes.
   In plain terms: a triple below 10⁵⁰⁰⁰ must have b·f > 10⁶, where b and f are the squarefree "cube parts" of the outer terms. Infinitely many families B are untouched. Under the naive independence model this region carries about 99.5% of the expected mass beyond 10²², but that model already predicts about 10⁻¹¹ triples, so this is weak evidence: a counterexample, if one exists, is by definition not generic.
3. **[Proved]** *Polynomial analogue: none.* Over ℂ[t], if f, f+1, f+2 were powerful and nonconstant, Mason–Stothers on f(f+2) + 1 = (f+1)² gives 2 deg f ≤ deg rad(f(f+1)(f+2)) − 1 ≤ (3/2) deg f − 1, impossible. (Even two consecutive powerful polynomials are impossible: deg f ≤ deg f/2 + deg f/2 − 1. So the polynomial world is far more rigid than the integers, where consecutive powerful pairs are infinite.)
4. **[Proved]** *Fake world where triples exist.* In F₃[t], t⁶ − 1 = (t² − 1)³, t⁶, and t⁶ + 1 = (t² + 1)³ are three consecutive powerful polynomials. Any argument valid over F₃[t] cannot prove the conjecture; a proof must use characteristic 0, the way the derivative does in item 3.
5. **[Reduction]** *abc gives finiteness only.* rad(n(n+1)(n+2)) < (n+1)^{3/2}, so the abc triple (n(n+2), 1, (n+1)²) has quality above 4/3: abc implies finitely many triples. Unconditional effective abc (Stewart–Yu) gives nothing here.
6. **[Heuristic]** Treating powerfulness of n, n+1, n+2 as independent events of probability about (c₂/2)·n^{−1/2} (c₂ = ζ(3/2)/ζ(3)), the expected number of triples above 10²² is about 2.6·10⁻¹¹; local correlations (only n ≡ 3 mod 4 survives at p = 2, and similar factors at every prime) multiply this by about 0.31, giving about 8·10⁻¹². The conjecture is almost certainly true.

## Kernel card

1. **Kernel, in plain terms.** Rule out triples whose two outer terms have large non-square parts (b·f > 10⁶), and all triples above 10⁵⁰⁰⁰. [Certain] This is a renaming plus a smaller search space, not an easier statement: it is equivalent to the original given items 1–2. Original implies kernel trivially (core).
2. **Missing primitive.** An effective, uniform lower bound on |t² − 1 − B·Y²|-type near-coincidences across all B at once, i.e. an effective abc-type inequality (n+1)² ≤ κ·rad(n(n+1)(n+2))^{4/3−δ} with an explicit constant. Per-B tools settle each Pell family quickly (item 2 walks 7.7·10⁷ solutions in minutes); nothing gives uniformity in B. It must fail in the F₃[t] fake (item 4).
3. **Required ingredients.** Multiplicative: the shapes a²b³ of all three terms. Additive: the two "+1" relations, combined into t² − 1 = n(n+2). They interact only in the Pell equation, and characteristic 0 must enter there.
4. **Suppliers.** (a) Pell/Lucas-sequence methods (show the x-coordinates of t² − BY² = 1 are never powerful): work per B with congruence sieves, not uniformly. (b) The modular method: would need a fixed large exponent, absent here. (c) Effective abc: only subexponential bounds exist. Cheap test of (a): item 2, where per-B elimination is cheap; the cost lies only in B being unbounded. Cheap test of (c): Stewart–Yu with rad ≈ c^{3/4} gives log c ≪ c^{1/4+ε}, true for all c, so no bound.
5. **Dial.** The exponent κ in an effective bound c ≤ C·rad^κ on these triples; the theorem needs κ < 4/3, while today only subexponential bounds exist. Same cluster and same missing primitive as Erdős #366 (see `../366`).

## Routes tried and why they failed
- Search for triples — cannot prove nonexistence; the heuristic predicts nothing will be found.
- Pell families by B — easy per B, but B is unbounded (qualitative wall).
- abc — finiteness only, not effective.

## Code
- `pell364.py`: Pell-family test. Run (two parts in parallel): `python3 pell364.py 1000000 5000 10000 0 2` and `... 1 2`. Logs: `pell_p0.log`, `pell_p1.log`. Needs gmpy2.
- `follow.py`: eliminates survivors by deeper trial division: `python3 follow.py survivors.txt 100000000`.
- `validate.py`: brute-force validation of the Pell reduction on small numbers (needs sympy). Log: `validate.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review (a separate Claude instance refereed the claims, caught a vacuous validation script, a block bug in `follow.py`, and an overstated coverage claim, all fixed); it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
