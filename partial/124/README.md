# Erdős Problem #124 — partial results

**Problem** ([erdosproblems.com/124](https://www.erdosproblems.com/124)). For d ≥ 2 and k ≥ 0 let P(d, k) be the set of sums of distinct powers d^i with i ≥ k (0/1-digit numbers in base d divisible by d^k). Let 3 ≤ d₁ < … < d_r with Σ 1/(d_i − 1) ≥ 1. (1) Is every large integer a sum Σ c_i a_i with c_i ∈ {0,1}, a_i ∈ P(d_i, 0)? (2) If also gcd(d₁, …, d_r) = 1, is the same true with a_i ∈ P(d_i, k) for every k ≥ 1? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): part (1) resolved positively (proof by Aristotle, via Alexeev, formalised in Lean). Part (2) is the Burr–Erdős–Graham–Li conjecture (1996), proved by them for {3, 4, 7}; open in general. Pomerance: Σ 1/(d_i − 1) ≥ 1 is necessary.

Equivalently: merge all powers d^j (j ≥ k, d ∈ D) into one sorted list s₁ ≤ s₂ ≤ … (with multiplicity); the question is whether its subset sums contain all large integers.

## Results here
1. **[Proved]** *Reduction lemma.* Let σ_m = s₁ + … + s_m and suppose the subset sums of s₁, …, s_m contain [G, σ_m − G], and every later term satisfies s_{j+1} ≤ σ_j − 2G + 1. Then every integer ≥ G is representable. Proof: induction on j; if the subset sums of the first j terms contain [G, σ_j − G], then adding s_{j+1} yields [G, σ_j − G] ∪ [G + s_{j+1}, σ_{j+1} − G], and these overlap or abut because G + s_{j+1} ≤ σ_j − G + 1. ∎ Checked by hand.
2. **[Proved]** *Automatic tail when Σ 1/(d − 1) > 1.* Put η = Σ 1/(d−1) − 1 > 0 and C = Σ d^k/(d−1). For any term x, the powers of each base d that are ≥ d^k and < x sum to at least (x − d^k)/(d − 1), so the sum σ of terms before x satisfies σ − x ≥ ηx − C. Hence the tail condition holds for all x ≥ X₀ = (2G − 1 + C)/η, and each fixed (D, k) with η > 0 becomes a finite computation. (Assumes no coincident powers between bases, true for {3, 4, 5}.)
3. **[Computed]** *{3, 4, 5} satisfies part (2) for k = 1, 2, 3.* Method: subset-sum bitset over all terms up to a bound B, increased until B > 3X₀; largest exception F found, G = F + 1; then an exhaustive check that the subset sums of the terms below X₀ contain [G, σ − G], plus item 2 for the tail (first 40 tail terms also checked numerically). Last exceptions: 79 (k = 1), 77,613 (k = 2), 4,330,731 (k = 3). Exact integer arithmetic. Novelty not checked against the literature.
4. **[Computed]** Exception lists were also computed (subset-sum bitsets to 3·10⁶; to 3·10⁷ for {3,4,7} and {3,4,5} at k = 3) for {3,4,7}, {3,5,7,13}, {3,5,6,21}, {3,4,10,19}, {3,4,8,43}, {3,4,5}. For 7 base/modulus pairs and k ≤ 11, 0/1-digit numbers in base a hit every residue mod b^k after about 1.2·log₂ b·k digits (no hidden residue obstruction).
5. **[Proved]** *Thickness observation (computation part).* The Cantor set of 0/1-digit numbers in base d (digits 0, 1 after the point) has Newhouse thickness τ = 1/(d − 2), so τ/(1 + τ) = 1/(d − 1). Hence Erdős's condition Σ 1/(d_i − 1) ≥ 1 is exactly Σ τ_i/(1 + τ_i) ≥ 1.
6. **[Heuristic]** *Astels link.* Astels' theorem gives an interval in a sum of Cantor sets when Σ τ_i/(1 + τ_i) ≥ 1, so the size side of the problem matches a classical criterion (match rated Likely; whether Tao's forum comment already makes this link was not checked).
7. **[Heuristic]** For {3, 4, 5} the last exception is about 1.3, 21.6, 20.0 times 60^k (60 = 3·4·5), suggesting residue constraints mod ∏ d^k drive the threshold. One base set only.

## Routes tried and why they failed
- Unit swaps / absorption (pairs of disjoint high-power sets differing by 1, to fill gaps of size ≤ C) — cost wall: each swap's largest term stops counting toward Brown's inequality, and the room at that scale is only (s − 1) times it (s = Σ 1/(d−1)); the two analyses in the chat put the threshold at s ≥ 2 and s ≥ 5/3 respectively, while {3, 4, 5} has s = 13/12.
- Uniform residue lemma via Erdős–Mauduit–Sárközy — inapplicable: needs gcd(q, g(g − 1)) = 1 (base 4 mod 3^k fails) and moduli ≤ exp(c√log x), far below what is needed.
- Single-base Fourier bounds combined by Hölder — fails quantitatively: gives ≈ 0.87 for {3, 4, 5}, a proof needs > 1, so cross-base interaction must be used.
- Shmerkin's L^q convolution theorem plus Brown's gap bound — the count beats the error only if √(N/N_H)·N_H^(−ε/2) > C + 1; the ε-loss (and even an exact version) does not close it. Parked next to Furstenberg ×2×3-type problems.

## Code
Original scripts not preserved.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
