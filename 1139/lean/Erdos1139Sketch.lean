import LongGapsBetweenPrimes

/-!
# Erdős Problem 1139 from `short_translates_divisor` (formalization in progress)

INCOMPLETE. The only remaining `sorry` is `eventually_cover`, tagged `TODO(2)-(5)`: the
covering construction (greedy residues, smooth-number count, double hits from primes in
`(x/2, x]`, and the upper-bound sieve for positions hit exactly once). Everything else,
including the reduction of `erdos_1139` to `eventually_cover`, is proved. This file is
therefore *not* yet a proof of Erdős Problem 1139.

The target statement is copied verbatim from google-deepmind/formal-conjectures,
`FormalConjectures/ErdosProblems/1139.lean` (there `Ω` is `ArithmeticFunction.cardFactors`).
-/

open Filter
open scoped ArithmeticFunction.Omega

namespace Erdos1139Sketch

open LongGapsBetweenPrimes

/-- Integers with at most two prime factors counted with multiplicity. -/
def AlmostPrime2 (n : ℕ) : Prop := 0 < n ∧ Ω n ≤ 2

instance : DecidablePred AlmostPrime2 := fun n =>
  inferInstanceAs (Decidable (0 < n ∧ Ω n ≤ 2))

/-! ### Elementary arithmetic -/

/-- TODO(1), closed. If two distinct primes divide `n` and their product is `< n`, then
`Ω n ≥ 3`. -/
lemma three_le_cardFactors_of_two_primes {n p q : ℕ} (hp : p.Prime) (hq : q.Prime)
    (hpq : p ≠ q) (hpn : p ∣ n) (hqn : q ∣ n) (hlt : p * q < n) : 3 ≤ Ω n := by
  have hcop : Nat.Coprime p q := (Nat.coprime_primes hp hq).mpr hpq
  obtain ⟨m, rfl⟩ := hcop.mul_dvd_of_dvd_of_dvd hpn hqn
  have hpq0 : p * q ≠ 0 := Nat.mul_ne_zero hp.ne_zero hq.ne_zero
  have hm : 1 < m := by
    by_contra h
    push Not at h
    interval_cases m <;> simp at hlt
  rw [ArithmeticFunction.cardFactors_mul hpq0 (by omega),
    ArithmeticFunction.cardFactors_mul hp.ne_zero hq.ne_zero,
    ArithmeticFunction.cardFactors_apply_prime hp, ArithmeticFunction.cardFactors_apply_prime hq]
  have := ArithmeticFunction.cardFactors_pos_iff_one_lt.mpr hm
  omega

/-- TODO(10a), closed. `⌊x⌋² < primorial ⌊x⌋` eventually. -/
lemma eventually_floor_mul_floor_lt_primorial : ∀ᶠ x : ℝ in atTop,
    ⌊x⌋₊ * ⌊x⌋₊ < primorial ⌊x⌋₊ := by
  have hlog : Tendsto (fun x : ℝ => Real.log x ^ 6 / x) atTop (nhds 0) := by
    simpa using Real.tendsto_pow_log_div_mul_add_atTop 1 0 6 one_ne_zero
  filter_upwards [eventually_sieveY_mul_floor_lt_primorial, eventually_ge_atTop (3 : ℝ),
    hlog.eventually_le_const (by norm_num : (0 : ℝ) < 1)] with x hY hx hlx
  have hx0 : 0 < x := by linarith
  have hL : 0 < Real.log x := Real.log_pos (by linarith)
  have h6 : Real.log x ^ 6 ≤ x := by
    have := (div_le_iff₀ hx0).mp hlx
    linarith
  have hle : Real.log x ≤ sieveUpperLog x := by
    unfold sieveUpperLog
    rw [le_div_iff₀ (by positivity)]
    calc Real.log x * Real.log x ^ 5 = Real.log x ^ 6 := by ring
      _ ≤ x := h6
  have hxY : x ≤ Real.exp (sieveUpperLog x) :=
    calc x = Real.exp (Real.log x) := (Real.exp_log hx0).symm
      _ ≤ _ := Real.exp_le_exp.mpr hle
  have hfl : ⌊x⌋₊ ≤ sieveY x := Nat.floor_mono hxY
  calc ⌊x⌋₊ * ⌊x⌋₊ ≤ sieveY x * ⌊x⌋₊ := Nat.mul_le_mul_right _ hfl
    _ < _ := hY

/-! ### Covering construction -/

/-- The run length `H = ⌊3Cx⌋`. -/
noncomputable def runLength (C x : ℝ) : ℕ := ⌊3 * C * x⌋₊

/-- TODO(6), closed. `x < ⌊3Cx⌋ ≤ x (log x)^2` eventually. -/
lemma eventually_runLength_bounds (C : ℝ) (hC : 1 ≤ C) : ∀ᶠ x : ℝ in atTop,
    x < (runLength C x : ℝ) ∧ (runLength C x : ℝ) ≤ x * Real.log x ^ 2 := by
  filter_upwards [eventually_ge_atTop (1 : ℝ),
    Real.tendsto_log_atTop.eventually_ge_atTop (3 * C)] with x hx hL
  have h3C : 0 ≤ 3 * C * x := by positivity
  have h3x : 3 * x ≤ 3 * C * x := by nlinarith
  unfold runLength
  constructor
  · have := Nat.lt_floor_add_one (3 * C * x)
    linarith
  · calc (⌊3 * C * x⌋₊ : ℝ) ≤ 3 * C * x := Nat.floor_le h3C
      _ ≤ x * Real.log x ^ 2 := by
        have hL1 : 1 ≤ Real.log x := by linarith
        have : 3 * C ≤ Real.log x ^ 2 := by nlinarith
        nlinarith

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

/-- The covering lemma (Lemmas 2 to 5 of the paper). Not yet formalized. It needs:
* TODO(2) greedy residue choice for `w < p ≤ z` (`greedy_residue_classes`,
  `eventually_greedy_product_bound` in `LongGapsBetweenPrimes` are close relatives);
* TODO(3) smooth-number count for survivors (cf. `eventually_smooth_count`);
* TODO(4) double hits: primes in `(x/2, x]` are numerous enough (Chebyshev) to give each
  remaining unhit position two distinct hits;
* TODO(5) upper-bound sieve: the positions hit exactly once number `o(x)`. -/
lemma eventually_cover (C : ℝ) (hC : 1 ≤ C) (δ : ℝ) (hδ : 0 < δ) :
    ∀ᶠ x : ℝ in atTop, Nonempty (CoverData x (runLength C x) δ) := by
  sorry -- TODO(2)-(5): greedy residues, smooth count, double hits, upper-bound sieve.

/-! ### Chinese remainder step and bookkeeping -/

/-- TODO(7), closed. CRT: a shift `b < primorial n` with `p ∣ b + a p` for all `p ≤ n`. -/
lemma exists_crt_shift (n : ℕ) (a : ℕ → ℕ) (ha : ∀ p ∈ n.primesLE, a p < p) :
    ∃ b < primorial n, ∀ p ∈ n.primesLE, p ∣ b + a p := by
  have hcop : (↑n.primesLE : Set ℕ).Pairwise Nat.Coprime := by
    intro p hp q hq hpq
    exact (Nat.coprime_primes (Nat.mem_primesLE.mp hp).2 (Nat.mem_primesLE.mp hq).2).mpr hpq
  let b := Nat.chineseRemainderOfFinset (fun p => p - a p) (fun p => p) n.primesLE
    (fun p hp => (Nat.mem_primesLE.mp hp).2.ne_zero) hcop
  refine ⟨b.val, ?_, fun p hp => ?_⟩
  · simpa only [primorial_eq_prod_primesLE] using
      Nat.chineseRemainderOfFinset_lt_prod (fun p => p - a p) (fun p => p)
        (fun p hp => (Nat.mem_primesLE.mp hp).2.ne_zero) hcop
  · apply Nat.dvd_of_mod_eq_zero
    calc (b.val + a p) % p = ((p - a p) + a p) % p := by
          rw [Nat.add_mod, b.property p hp, ← Nat.add_mod]
      _ = 0 := by rw [Nat.sub_add_cancel (ha p hp).le, Nat.mod_self]

/-- TODO(9), closed. A prime `q ≤ n` hitting `j` divides `b + primorial n * t + j`. -/
lemma dvd_shift_of_hit {n b t j q : ℕ} {a : ℕ → ℕ} (hq : q ∈ n.primesLE)
    (hb : q ∣ b + a q) (hj : j % q = a q) : q ∣ b + primorial n * t + j := by
  have hqQ : q ∣ primorial n :=
    (Nat.mem_primesLE.mp hq).2.dvd_primorial_iff.mpr (Nat.mem_primesLE.mp hq).1
  have hj' : j = a q + q * (j / q) := by
    rw [← hj]
    exact (Nat.mod_add_div j q).symm
  rw [hj', show b + primorial n * t + (a q + q * (j / q)) =
    (b + a q) + primorial n * t + q * (j / q) by ring]
  exact dvd_add (dvd_add hb (dvd_mul_of_dvd_left hqQ t)) (dvd_mul_right q _)

/-- TODO(8), closed. Size of the shifted base point: `N ≤ 2 e^{4x}`. -/
lemma shift_le {x : ℝ} (hx : 0 ≤ x) {b t : ℕ} (hb : b < primorial ⌊x⌋₊)
    (ht : (t : ℝ) ≤ Real.exp x) :
    ((b + primorial ⌊x⌋₊ * t : ℕ) : ℝ) ≤ 2 * Real.exp (4 * x) := by
  have hQbound : (primorial ⌊x⌋₊ : ℝ) ≤ Real.exp (3 * x) := by
    calc
      (primorial ⌊x⌋₊ : ℝ) ≤ (4 : ℝ) ^ ⌊x⌋₊ := by exact_mod_cast primorial_le_four_pow ⌊x⌋₊
      _ ≤ Real.exp 3 ^ ⌊x⌋₊ := by
        gcongr
        linarith [Real.add_one_le_exp (3 : ℝ)]
      _ = Real.exp (3 * (⌊x⌋₊ : ℝ)) := by rw [← Real.exp_nat_mul, mul_comm]
      _ ≤ Real.exp (3 * x) := by gcongr; exact Nat.floor_le hx
  calc
    ((b + primorial ⌊x⌋₊ * t : ℕ) : ℝ) = (b : ℝ) + (primorial ⌊x⌋₊ : ℝ) * t := by
      push_cast; ring
    _ ≤ (primorial ⌊x⌋₊ : ℝ) * (1 + Real.exp x) := by
      have hb' : (b : ℝ) ≤ primorial ⌊x⌋₊ := by exact_mod_cast hb.le
      nlinarith [mul_le_mul_of_nonneg_left ht (Nat.cast_nonneg (primorial ⌊x⌋₊))]
    _ ≤ Real.exp (3 * x) * (2 * Real.exp x) :=
      mul_le_mul hQbound (by linarith [Real.one_le_exp hx]) (by positivity) (Real.exp_nonneg _)
    _ = 2 * Real.exp (4 * x) := by
      rw [show (4 : ℝ) * x = 3 * x + x by ring, Real.exp_add]
      ring

/-! ### Assembling one long run -/

/-- For large `x` there is `N ≥ primorial ⌊x⌋`, `N ≤ 2 e^{4x}`, such that every
`n ∈ (N, N + ⌊3Cx⌋]` has `Ω n ≥ 3`. Proved from `eventually_cover` and
`short_translates_divisor`. -/
lemma eventually_long_run (C : ℝ) (hC : 1 ≤ C) :
    ∀ᶠ x : ℝ in atTop, ∃ N : ℕ, primorial ⌊x⌋₊ ≤ N ∧ (N : ℝ) ≤ 2 * Real.exp (4 * x) ∧
      ∀ j ∈ Finset.Icc 1 (runLength C x), 3 ≤ Ω (N + j) := by
  obtain ⟨δ, hδ, -, hshort⟩ := short_translates_divisor
  filter_upwards [eventually_cover C hC δ hδ, hshort, eventually_runLength_bounds C hC,
    eventually_floor_mul_floor_lt_primorial, eventually_ge_atTop (2 : ℝ)]
    with x ⟨cd⟩ htrans ⟨hH₁, hH₂⟩ hsq hx
  obtain ⟨b, hb, hbcong⟩ := exists_crt_shift ⌊x⌋₊ cd.a cd.a_lt
  obtain ⟨t, ht, htx, hdiv⟩ := htrans _ hH₁ hH₂ cd.S₁
    (by rw [cd.S₁_def]; exact Finset.filter_subset _ _) cd.S₁_card b hb
  have hQN : primorial ⌊x⌋₊ ≤ b + primorial ⌊x⌋₊ * t :=
    (Nat.le_mul_of_pos_right _ ht).trans (Nat.le_add_left _ _)
  refine ⟨b + primorial ⌊x⌋₊ * t, hQN, shift_le (by linarith) hb htx, ?_⟩
  intro j hj
  by_cases h1 : j ∈ cd.S₁
  · -- Hit exactly once by a small prime `q ≤ ⌊x⌋`; the new theorem supplies `p > ⌊x⌋`.
    obtain ⟨p, hp, hpx, hplt, hpdvd⟩ := hdiv j h1
    obtain ⟨q, hq, hqj⟩ := cd.hit j hj
    have hqdvd := dvd_shift_of_hit (t := t) hq (hbcong q hq) hqj
    have hqprime : q.Prime := (Nat.mem_primesLE.mp hq).2
    have hqx : q ≤ ⌊x⌋₊ := (Nat.mem_primesLE.mp hq).1
    refine three_le_cardFactors_of_two_primes hqprime hp (by omega) hqdvd hpdvd ?_
    calc q * p ≤ ⌊x⌋₊ * p := Nat.mul_le_mul_right _ hqx
      _ = p * ⌊x⌋₊ := Nat.mul_comm _ _
      _ < _ := hplt
  · -- TODO(10b), closed. Hit by at least two distinct small primes.
    have hcard : 1 < ((⌊x⌋₊).primesLE.filter (fun p => j % p = cd.a p)).card := by
      have hne : ((⌊x⌋₊).primesLE.filter (fun p => j % p = cd.a p)).Nonempty := by
        obtain ⟨q, hq, hqj⟩ := cd.hit j hj
        exact ⟨q, Finset.mem_filter.mpr ⟨hq, hqj⟩⟩
      have h1' : ((⌊x⌋₊).primesLE.filter (fun p => j % p = cd.a p)).card ≠ 1 := by
        intro h
        apply h1
        rw [cd.S₁_def]
        exact Finset.mem_filter.mpr ⟨hj, h⟩
      have := hne.card_pos
      omega
    obtain ⟨q₁, hq₁, q₂, hq₂, hne⟩ := Finset.one_lt_card.mp hcard
    obtain ⟨hq₁m, hq₁j⟩ := Finset.mem_filter.mp hq₁
    obtain ⟨hq₂m, hq₂j⟩ := Finset.mem_filter.mp hq₂
    refine three_le_cardFactors_of_two_primes (Nat.mem_primesLE.mp hq₁m).2
      (Nat.mem_primesLE.mp hq₂m).2 hne
      (dvd_shift_of_hit hq₁m (hbcong q₁ hq₁m) hq₁j)
      (dvd_shift_of_hit hq₂m (hbcong q₂ hq₂m) hq₂j) ?_
    calc q₁ * q₂ ≤ ⌊x⌋₊ * ⌊x⌋₊ :=
          Nat.mul_le_mul (Nat.mem_primesLE.mp hq₁m).1 (Nat.mem_primesLE.mp hq₂m).1
      _ < primorial ⌊x⌋₊ := hsq
      _ ≤ _ := by omega

/-! ### From runs to the `limsup` -/

lemma almostPrime2_infinite : (Set.ofPred AlmostPrime2).Infinite :=
  Nat.infinite_setOfPred_prime.mono fun p (hp : p.Prime) =>
    show AlmostPrime2 p from ⟨hp.pos, by rw [ArithmeticFunction.cardFactors_apply_prime hp]; omega⟩

/-- TODO(11), closed. A run of `Ω ≥ 3` on `(N, N + H]` gives a gap in `Nat.nth AlmostPrime2`
straddling it. -/
lemma gap_of_run {N H : ℕ} (hN : 1 ≤ N) (hrun : ∀ j ∈ Finset.Icc 1 H, 3 ≤ Ω (N + j)) :
    ∃ k : ℕ, k + 1 = Nat.count AlmostPrime2 (N + 1) ∧
      Nat.nth AlmostPrime2 k ≤ N ∧ N + H < Nat.nth AlmostPrime2 (k + 1) := by
  have hinf := almostPrime2_infinite
  have h1 : AlmostPrime2 1 := ⟨one_pos, by simp⟩
  have hc : 1 ≤ Nat.count AlmostPrime2 (N + 1) := by
    have h2 : Nat.count AlmostPrime2 2 = Nat.count AlmostPrime2 1 + 1 := by
      rw [Nat.count_succ, if_pos h1]
    have := Nat.count_monotone AlmostPrime2 (show 2 ≤ N + 1 by omega)
    omega
  refine ⟨Nat.count AlmostPrime2 (N + 1) - 1, by omega, ?_, ?_⟩
  · have := Nat.nth_lt_of_lt_count (p := AlmostPrime2)
      (show Nat.count AlmostPrime2 (N + 1) - 1 < Nat.count AlmostPrime2 (N + 1) by omega)
    omega
  · rw [show Nat.count AlmostPrime2 (N + 1) - 1 + 1 = Nat.count AlmostPrime2 (N + 1) by omega]
    have hge := Nat.le_nth_count hinf (N + 1)
    have hmem : AlmostPrime2 (Nat.nth AlmostPrime2 (Nat.count AlmostPrime2 (N + 1))) :=
      Nat.nth_mem_of_infinite hinf _
    by_contra hle
    push Not at hle
    set m := Nat.nth AlmostPrime2 (Nat.count AlmostPrime2 (N + 1))
    have hj : m - N ∈ Finset.Icc 1 H := Finset.mem_Icc.mpr ⟨by omega, by omega⟩
    have h3 := hrun _ hj
    rw [show N + (m - N) = m by omega] at h3
    have hmem' : 0 < m ∧ Ω m ≤ 2 := hmem
    omega

/-- Erdős Problem 1139, in the exact form of formal-conjectures. Proved here modulo
`eventually_cover` (TODO(2)-(5)). TODO(12), the `EReal` bookkeeping, is closed. -/
theorem erdos_1139 :
    letI u := Nat.nth (fun n ↦ 0 < n ∧ Ω n ≤ 2)
    atTop.limsup (fun k : ℕ ↦ (((u (k + 1) : ℝ) - (u k : ℝ)) / Real.log (↑k + 1) : EReal))
      = ⊤ := by
  show atTop.limsup (fun k : ℕ ↦ (((Nat.nth AlmostPrime2 (k + 1) : ℝ) -
    (Nat.nth AlmostPrime2 k : ℝ)) / Real.log (↑k + 1) : EReal)) = ⊤
  rw [EReal.eq_top_iff_forall_lt]
  intro M
  refine lt_of_lt_of_le (EReal.coe_lt_coe_iff.mpr (lt_add_one M)) ?_
  apply le_limsup_of_frequently_le'
  rw [Filter.frequently_atTop]
  intro K
  set R : ℝ := |M| + 1 with hR
  have hR0 : 1 ≤ R := by have := abs_nonneg M; linarith
  have hMR : M + 1 ≤ R := by have := le_abs_self M; linarith
  set C : ℝ := 2 * R + 2 with hCdef
  have hC : 1 ≤ C := by linarith
  obtain ⟨x, hrun, hsq, hfl, hx⟩ := ((eventually_long_run C hC).and
    (eventually_floor_mul_floor_lt_primorial.and
      ((tendsto_nat_floor_atTop.eventually_ge_atTop (Nat.nth AlmostPrime2 (K + 1) + 1)).and
        (eventually_ge_atTop (2 : ℝ))))).exists
  obtain ⟨N, hQN, hNb, hrunN⟩ := hrun
  have hN1 : 1 ≤ N := (primorial_pos _).trans_le hQN
  obtain ⟨k, hk, hku, hku1⟩ := gap_of_run hN1 hrunN
  have hKN : Nat.nth AlmostPrime2 (K + 1) < N + 1 := by
    have := Nat.le_mul_self ⌊x⌋₊
    omega
  have hKk : K + 1 < k + 1 := by
    rw [hk]
    exact (Nat.lt_nth_iff_count_lt almostPrime2_infinite).mpr hKN
  have hk1 : k + 1 ≤ N + 1 := hk ▸ Nat.count_le AlmostPrime2
  refine ⟨k, by omega, ?_⟩
  rw [← EReal.coe_sub, ← EReal.coe_div, EReal.coe_le_coe_iff]
  have hx0 : 0 < x := by linarith
  have hlogpos : 0 < Real.log ((k : ℝ) + 1) := Real.log_pos (by
    have : (1 : ℝ) ≤ k := by exact_mod_cast (show 1 ≤ k by omega)
    linarith)
  have hlogle : Real.log ((k : ℝ) + 1) ≤ 4 * x + 2 := by
    have hkN : (k : ℝ) + 1 ≤ 3 * Real.exp (4 * x) := by
      have : ((k + 1 : ℕ) : ℝ) ≤ ((N + 1 : ℕ) : ℝ) := by exact_mod_cast hk1
      push_cast at this
      linarith [Real.one_le_exp (show 0 ≤ 4 * x by linarith)]
    calc Real.log ((k : ℝ) + 1) ≤ Real.log (3 * Real.exp (4 * x)) :=
          Real.log_le_log (by positivity) hkN
      _ = Real.log 3 + 4 * x := by
          rw [Real.log_mul (by norm_num) (Real.exp_pos _).ne', Real.log_exp]
      _ ≤ 4 * x + 2 := by
          have := Real.log_le_sub_one_of_pos (show (0 : ℝ) < 3 by norm_num)
          linarith
  have hH : 3 * C * x - 1 ≤ (runLength C x : ℝ) := by
    have := Nat.lt_floor_add_one (3 * C * x)
    unfold runLength
    linarith
  have hgap : (runLength C x : ℝ) ≤
      (Nat.nth AlmostPrime2 (k + 1) : ℝ) - (Nat.nth AlmostPrime2 k : ℝ) := by
    have : runLength C x + Nat.nth AlmostPrime2 k ≤ Nat.nth AlmostPrime2 (k + 1) := by omega
    have : ((runLength C x + Nat.nth AlmostPrime2 k : ℕ) : ℝ) ≤ Nat.nth AlmostPrime2 (k + 1) := by
      exact_mod_cast this
    push_cast at this
    linarith
  rw [le_div_iff₀ hlogpos]
  calc (M + 1) * Real.log ((k : ℝ) + 1) ≤ R * (4 * x + 2) :=
        mul_le_mul hMR hlogle hlogpos.le (by linarith)
    _ ≤ 3 * C * x - 1 := by rw [hCdef]; nlinarith
    _ ≤ _ := hH.trans hgap

end Erdos1139Sketch
