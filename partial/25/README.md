# Erdős Problem #25 — partial results

**Problem** ([erdosproblems.com/25](https://www.erdosproblems.com/25)). Take moduli 1 ≤ n₁ < n₂ < … and for each one a residue aᵢ (mod nᵢ). Class i strikes the integers n ≥ nᵢ with n ≡ aᵢ (mod nᵢ). Let A be the set of integers never struck. Must A have a logarithmic density, i.e. does (1/log x)·Σ_{n≤x, n∈A} 1/n converge? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open. Known cases: all aᵢ = 0 (Davenport–Erdős: sets of multiples have a log density); Σ 1/nᵢ < ∞ and pairwise coprime moduli (Chojecki, 2026). #25 is the one-residue-per-modulus special case of #486; Shouqiao Wang (2026, with GPT-5.6) claims a disproof of #486 using many residues per modulus, which does not transfer to #25 (see below). No independent check of Wang's claim was recorded.

Notation: B = struck set; μ = long-run density of the union of the classes (limit of the densities of finite truncations); H(x) = Σ_{n≤x} 1/n.

## Results here
1. **[Proved]** *Lower bound.* The lower log density of B is at least μ. Sketch: the truncation B_K (classes with nᵢ ≤ K) is a subset of B and agrees with a periodic set of density μ_K beyond n_K, so it has log density μ_K; let K → ∞. So only the upper bound is open. Checked by hand.
2. **[Reduction]** *Lemma L ⇒ #25.* Lemma L: for every finite family (distinct moduli, one residue each) and every x ≥ 1, Σ_{n≤x, n∈B} 1/n ≤ μ·H(x); equivalently survivors carry harmonic mass ≥ (1−μ)·H(x). Lemma L implies D(s): Σ_{n∈B} n^(−s) ≤ μ·ζ(s) for all s > 1, and D(s) for all finite families implies #25 by the Davenport–Erdős limit/Tauberian argument. The Tauberian step was sketched, not written out in full.
3. **[Proved]** *Lemma 2 (residue-0 case of Lemma L, finite-x Davenport–Erdős).* If R is closed under taking divisors (exactly the survivor sets when every aᵢ = 0) and has density r, then Σ_{n≤y, n∈R} 1/n ≥ r·H(y) for every y. Proved by hand; no independent referee. Novelty unchecked (may be folklore). Proof: induct on the number of primes dividing the moduli, proving the statement inside the universe U of integers coprime to a finite excluded set of primes (harmonic sums and densities taken relative to U; base case R = U).
   1. Pick a prime p dividing some modulus; write n = pᵏm with p ∤ m.
   2. Let Rₖ = {m : pᵏm ∈ R}. Divisor-closure gives R₀ ⊇ R₁ ⊇ …, so relative densities r₀ ≥ r₁ ≥ ….
   3. Each Rₖ is divisor-closed in U' = U ∩ {p ∤ m} and involves one prime fewer, so by induction its harmonic sum up to y/pᵏ is ≥ rₖhₖ, where hₖ = harmonic sum of U' up to y/pᵏ; also h₀ ≥ h₁ ≥ ….
   4. With weights wₖ = p^(−k)(1 − 1/p) (summing to 1): r = Σ wₖrₖ and H_U(y) = Σ p^(−k)hₖ.
   5. Both (rₖ) and (hₖ) are non-increasing, so Chebyshev's sum inequality gives Σ wₖrₖhₖ ≥ (Σ wₖrₖ)(Σ wₖhₖ); dividing by (1 − 1/p) is the claim. ∎
4. **[Proved]** *Two classes.* For any two classes (k = 2), D(s) holds for every s > 1 ("Zeta-Rogers" for k = 2: comparison with the all-zero family). Rated Likely/Certain in the chat; every step checked by the author's AI tool, no independent agent. Sketch, with D(θ) = ζ(s) − ζ(s, θ), θ = first term / difference:
   - Incompatible classes: each class has θ ≥ 1, reducing to L^(1−s)(1/q₁ + 1/q₂) ≤ q₁^(−s) + q₂^(−s), a dilation inequality (L/qᵢ ≥ 1).
   - Compatible classes: equivalent to q₁^(−s)D(θ₁) + q₂^(−s)D(θ₂) ≥ L^(−s)D(θ₁₂). If θ₁₂ ≤ 1 the right side is ≤ 0. Otherwise use D(θ₁₂) ≤ s(r/L)ζ(s+1), D(θ_m) ≥ s(r/q_m)(ζ(s+1) − 1) for the larger modulus q_m, and L/q_m ≥ 2, so it suffices that 2^(s+1)(ζ(s+1) − 1) ≥ ζ(s+1), true term by term since 2/(j+1) ≥ 1/j. Nested classes cancel.
5. **[Proved]** *Three classes at s → 1* (the s → 1 form of D(s)). Computer-assisted; rated Likely: logic complete, small cases checked in floating point, not exact arithmetic. Expand by inclusion–exclusion; digamma bounds 1/(2x) < log x − ψ(x) < 1/x bound each triple term by 1/c₁₂₃, paid by the three pair bonuses 1/(2c_ij); compatible nested pairs are redundant. What remains, log q₁/q₁ + log q₂/q₂ + log q₃/q₃ ≥ D(q₂) + 2D(q₃) with D(q) = (γ + log 3q)/(2q), holds analytically except for modulus triples (2,3,4), (2,3,5), (2,3,6), (2,4,5), (3,4,5), which are covered by the exhaustive check of all 197,838 three-class families with moduli ≤ 15 and lcm ≤ 1500 (rigorous lower bound minimum 0.24).
6. **[Computed]** *k = 3, all s.* D(s) checked on all 21,569 three-class families with moduli in {2,3,4,5,6,8,9,10,12}, at 37 values of s in (1, 6], via the exact Hurwitz-zeta form Σ_{n∈B} n^(−s) = L^(−s) Σ_f ζ(s, f/L). Exhaustive over that set; no violation; tightest case the all-zero {2,3,5} as s → 1.
7. **[Computed]** *Adversarial search for D(s).* 20 hill-climbs seeded with {0 mod 2, 0 mod 3, 2 mod 5}-type families, 30,000 such families with moduli dividing 27,720: no counterexample, smallest margin 0.579·μ. Lemma L itself: hill climbs and structured families, moduli up to a few thousand, x up to ~10⁶; worst min slack/μ = 0.4254 (Eratosthenes sieve of primes ≤ 211 at x = 222). Sampled/local, not exhaustive.
8. **[Computed]** *Counterexample to two targets.* The family {0 mod 2, 0 mod 3, 2 mod 5} refutes (a) **R** (the shifted family's weighted excess is at most that of the all-zero family 0 mod 2, 0 mod 3, 0 mod 5) for geometric weights zⁿ and (b) **D(z)**: P(G ∈ B) ≤ μ for geometric G. Both families have density 11/15; among integers prime to 6 the shifted class sits at 7, 17 mod 30 versus 5, 25, so as z → 1 the shifted excess is 0.2 above the multiples', and P(G ∈ B) exceeds μ by 7·10⁻⁴ near z ≈ 0.98. Evaluated (floating point) from the exact one-period formula with L = lcm of the moduli. (R with weights n^(−s) passed all 32,076 three-class families with moduli ≤ 12.)
9. **[Heuristic]** For the Eratosthenes sieve by primes ≤ y the s → 1 margin is (1 − μ)·Σ_{p≤y} log p/(p − 1) → e^(−γ); guessed sharp constant.

## Routes tried and why they failed
- Comparison with the residue-0 family at every x (harmonic weights) — counterexample {0 mod 2, 0 mod 3, 2 mod 17} at x = 53.
- R / D(z) with counting or geometric weights — counterexample {0 mod 2, 0 mod 3, 2 mod 5} (item 8).
- Compressing one prime / one residue at a time — counterexample at x = 12; thousands of families have no monotone path to residue 0.
- Term-by-term inclusion–exclusion bounds — qualitative wall (Legendre sieve): rigorous bound for Eratosthenes is −0.04 at y = 200 while true slack ≈ 0.5.
- Pointwise (profinite) positivity of the s = 1 identity — fails at 3 classes, e.g. 0 mod 2, 0 mod 3, 1 mod 5, 1 mod 40.
- Block-by-block domination — killed by a toy test: residue-0 moduli in (√Q, Q/4] plus a later class 0 mod q; the later class's excess is ≥ (1−w′)(H(√Q) − 1), measured 1.78, 2.79, 3.08, 5.41 at Q = 2¹⁰, 2¹⁴, 2¹⁸, 2²², i.e. order log Q, while the route needed ≤ (log Q)^(1−ε). The route fails on a true (residue-0) case.
- Potential-function (Φ) certificates — cost wall: certified the "primes > 7 shifted to 2" family to P ≈ 800, failed at P = 809 by −0.0006 (true slack 0.77μ).
- Lemma L for all late-progression unions (several residues per modulus allowed) — false: Wang's #486 blocks lie in that class, so any proof must use one residue per distinct modulus.
- Also dead: zeta analogue of Rogers' theorem, averaging over dilations n ↦ pn, Wang-type inverse theorem, increasing-concave order, monotonicity of P(G ∈ B) in z.

## Code
Original scripts not preserved.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
