import LongGapsBetweenPrimes

/-!
# Sketch: Erdős Problem 1139 from `short_translates_divisor`

INCOMPLETE: top-level structure only. Every `sorry` is tagged `TODO(n)` naming the planned gap;
this file is *not* a proof of Erdős Problem 1139.
The target statement is copied from google-deepmind/formal-conjectures,
`FormalConjectures/ErdosProblems/1139.lean` (there `Ω` is `ArithmeticFunction.cardFactors`).
-/

open Filter
open scoped ArithmeticFunction.Omega

namespace Erdos1139Sketch

open LongGapsBetweenPrimes

/-- Integers with at most two prime factors counted with multiplicity. -/
def AlmostPrime2 (n : ℕ) : Prop := 0 < n ∧ Ω n ≤ 2

/-! ### Elementary arithmetic step (no analytic input) -/

/-- If two distinct primes divide `n` and their product is `< n`, then `Ω n ≥ 3`. -/
lemma three_le_cardFactors_of_two_primes {n p q : ℕ} (hp : p.Prime) (hq : q.Prime)
    (hpq : p ≠ q) (hpn : p ∣ n) (hqn : q ∣ n) (hlt : p * q < n) : 3 ≤ Ω n := by
  sorry -- TODO(1): `p * q ∣ n`, `n = p * q * m` with `2 ≤ m`, `Ω` is additive on products.

/-! ### Covering construction (Section "residue choice" of the proof) -/

/-- Parameters: `H = ⌊3Cx⌋`, `w = (log x)^4`, `z = exp (log x / log log x)`. -/
noncomputable def runLength (C x : ℝ) : ℕ := ⌊3 * C * x⌋₊

/-- The output of the residue choice: residues `a p` for primes `p ≤ x` such that
(i) every position in `[1, H]` is hit at least once,
(ii) the set `S₁` of positions hit exactly once has size `≤ δ x`. -/
structure CoverData (x : ℝ) (H : ℕ) (δ : ℝ) where
  a : ℕ → ℕ
  a_lt : ∀ p ∈ (⌊x⌋₊).primesLE, a p < p
  hit : ∀ j ∈ Finset.Icc 1 H, ∃ p ∈ (⌊x⌋₊).primesLE, j % p = a p
  S₁ : Finset ℕ
  S₁_def : S₁ = (Finset.Icc 1 H).filter
    (fun j => ((⌊x⌋₊).primesLE.filter (fun p => j % p = a p)).card = 1)
  S₁_card : (S₁.card : ℝ) ≤ δ * x

/-- The covering lemma. Needs, still to be formalized:
* TODO(2) greedy residue choice for `w < p ≤ z` (the file's `greedy_residue_classes`
  and `eventually_greedy_product_bound` are close relatives and may be reusable);
* TODO(3) smooth-number count for survivors (cf. `eventually_smooth_count`);
* TODO(4) "double hit" step: primes in `(x/2, x]` number `≳ x / (2 log x)` (Chebyshev),
  enough to give each remaining unhit position two distinct hits;
* TODO(5) upper-bound sieve: the number of `j ≤ H` with exactly one prime factor in
  `[2, w] ∪ (z, x/2]` (hit by `a_p = 0`) is `o(x)`, hence `≤ δ x` eventually. -/
lemma eventually_cover (C : ℝ) (hC : 1 ≤ C) (δ : ℝ) (hδ : 0 < δ) :
    ∀ᶠ x : ℝ in atTop, Nonempty (CoverData x (runLength C x) δ) := by
  sorry -- TODO(2)-(5): greedy residues, smooth count, double hits, upper-bound sieve.

/-! ### Assembling one long run -/

/-- For large `x` there is `N ≤ exp (2x + o(x))` such that every `n ∈ (N, N + H]`
has `Ω n ≥ 3`. -/
lemma eventually_long_run (C : ℝ) (hC : 1 ≤ C) :
    ∀ᶠ x : ℝ in atTop, ∃ N : ℕ,
      (N : ℝ) ≤ Real.exp (3 * x) ∧
      ∀ j ∈ Finset.Icc 1 (runLength C x), 3 ≤ Ω (N + j) := by
  obtain ⟨δ, hδ, -, hshort⟩ := short_translates_divisor
  filter_upwards [eventually_cover C hC δ hδ, hshort,
    Filter.eventually_ge_atTop (2 : ℝ)] with x ⟨cd⟩ htrans hx
  -- TODO(6) parameter bookkeeping: `x < H` and `H ≤ x (log x)^2` for `H = ⌊3Cx⌋`.
  have hH₁ : x < (runLength C x : ℝ) := sorry -- TODO(6): `x < ⌊3Cx⌋`.
  have hH₂ : (runLength C x : ℝ) ≤ x * (Real.log x) ^ 2 := sorry -- TODO(6): `⌊3Cx⌋ ≤ x (log x)^2`.
  -- CRT: `b ≡ -a p (mod p)` for all `p ≤ x`, `b < primorial ⌊x⌋` (as in
  -- `eventually_prime_gaps_in_x`, via `Nat.chineseRemainderOfFinset`).
  obtain ⟨b, hb, hbcong⟩ : ∃ b < primorial ⌊x⌋₊,
      ∀ p ∈ (⌊x⌋₊).primesLE, p ∣ b + cd.a p := sorry -- TODO(7), copy from the file
  obtain ⟨t, ht, htx, hdiv⟩ := htrans _ hH₁ hH₂ cd.S₁
    (by rw [cd.S₁_def]; exact Finset.filter_subset _ _) cd.S₁_card b hb
  refine ⟨b + primorial ⌊x⌋₊ * t, sorry, ?_⟩ -- TODO(8): `primorial ⌊x⌋ ≤ 4^x`, `t ≤ e^x`.
  intro j hj
  by_cases h1 : j ∈ cd.S₁
  · -- hit exactly once by some small `q ≤ x`; `short_translates_divisor` gives `p > ⌊x⌋`,
    -- so `p ≠ q`, and `q * p ≤ ⌊x⌋ * p < N + j`.
    obtain ⟨p, hp, hpx, hplt, hpdvd⟩ := hdiv j h1
    obtain ⟨q, hq, hqj⟩ := cd.hit j hj
    -- TODO(9): `q ∣ N + j` from the CRT congruence and `q ∣ primorial`.
    have hqdvd : q ∣ b + primorial ⌊x⌋₊ * t + j := sorry -- TODO(9): `q ∣ N + j` via CRT.
    have hqprime : q.Prime := (Nat.mem_primesLE.mp hq).2
    have hqx : q ≤ ⌊x⌋₊ := (Nat.mem_primesLE.mp hq).1
    exact three_le_cardFactors_of_two_primes hqprime hp (by omega) hqdvd hpdvd
      (by nlinarith [Nat.mul_le_mul_right p hqx])
  · -- hit by at least two distinct small primes `q₁ ≠ q₂ ≤ x`, and
    -- `q₁ q₂ ≤ x² < primorial ⌊x⌋ ≤ N + j`.
    sorry -- TODO(10): extract the two hits from `¬ (card = 1)` and `card ≥ 1`;
          -- `x^2 < primorial ⌊x⌋` for large `x`.

/-! ### From runs to the `limsup` -/

/-- TODO(11): a run of `H` consecutive integers in `(N, N + H]` with `Ω ≥ 3` forces a gap
`u (k+1) - u k ≥ H + 1` with `u k ≤ N`, hence `k + 1 ≤ N + 1`. Uses `Nat.nth` / `Nat.count`
facts as in the file's `consecutivePrimes_eq_nth`, plus infinitude of `AlmostPrime2`. -/
lemma gap_of_run {N H : ℕ} (hN : 1 ≤ N) (hrun : ∀ j ∈ Finset.Icc 1 H, 3 ≤ Ω (N + j)) :
    letI u := Nat.nth AlmostPrime2
    ∃ k : ℕ, k ≤ N ∧ (H : ℝ) ≤ (u (k + 1) : ℝ) - u k := by
  sorry -- TODO(11): run of `Ω ≥ 3` gives a gap in `Nat.nth AlmostPrime2`.

/-- TODO(12): `EReal` `limsup` is `⊤` once, for every `M`, the ratio exceeds `M`
frequently. Choose `C = M`, use `H = ⌊3Mx⌋`, `log (k + 1) ≤ log (N + 1) ≤ 3x + 1`. -/
theorem erdos_1139 :
    letI u := Nat.nth (fun n ↦ 0 < n ∧ Ω n ≤ 2)
    atTop.limsup (fun k : ℕ ↦ (((u (k + 1) : ℝ) - (u k : ℝ)) / Real.log (↑k + 1) : EReal))
      = ⊤ := by
  -- For each real `M ≥ 1`, apply `eventually_long_run M`, then `gap_of_run`, to get
  -- infinitely many `k` with ratio `≥ 3Mx / (3x + 1) ≥ M / 2`. Conclude with
  -- `Filter.le_limsup_of_frequently_le` / `EReal` order lemmas.
  sorry -- TODO(12): EReal `limsup` bookkeeping from `eventually_long_run` and `gap_of_run`.

end Erdos1139Sketch
