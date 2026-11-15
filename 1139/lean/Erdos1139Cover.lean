import LongGapsBetweenPrimes

/-!
# Erdős Problem 1139: the covering construction

`eventually_cover_residues` gives, for large `x` and `x/4 ≤ H ≤ 3Cx`, residues `a p < p`
for the primes `p ≤ x` such that every `j ∈ [1, H]` is hit and at most `δ x` positions are hit
exactly once. It feeds `Erdos1139Sketch.eventually_cover`.

* Step 4 (`exists_few_divisors_small`): a second-moment bound shows that, for a fixed finite
  set `F` of primes with `∑_{p ∈ F} 1/p` large, few `j ≤ H` have at most one divisor in `F`.
* Steps 1–2 (`combine_greedy_residues_zero`): residue `0` for the primes of
  `zeroCoverPrimes (x/4)` and the greedy choice of `LongGapsBetweenPrimes` for the auxiliary
  primes, both at scale `x/4`.
* Step 3 (`eventually_card_top_primes`, `eventually_survivors_le_top`): the primes in
  `(x/4, x]` outnumber the survivors, so each survivor gets its own prime.
-/

-- The lakefile sets `maxSynthPendingDepth = 3` and enables the Mathlib linter set. With either
-- of them this file does not finish elaborating in reasonable time (it runs past 7 GB of
-- memory), so both are restored to Lean's defaults here. Neither option affects soundness.
set_option maxSynthPendingDepth 1
set_option linter.mathlibStandardSet false

open Filter

namespace Erdos1139Cover

/-! ### Step 4: few positions have at most one small prime divisor (second moment) -/

lemma Icc_one_eq_Ioc (H : ℕ) : Finset.Icc 1 H = Finset.Ioc 0 H :=
  Finset.Icc_add_one_left_eq_Ioc 0 H

lemma card_filter_dvd (H d : ℕ) :
    ((Finset.Icc 1 H).filter (fun j => d ∣ j)).card = H / d := by
  rw [Icc_one_eq_Ioc]
  exact Nat.Ioc_filter_dvd_card_eq_div H d

lemma div_sub_one_le_cast_div (H d : ℕ) (hd : 0 < d) :
    (H : ℝ) / d - 1 ≤ ((H / d : ℕ) : ℝ) := by
  have hdR : (0 : ℝ) < d := by exact_mod_cast hd
  have h1 : (H : ℝ) = d * ((H / d : ℕ) : ℝ) + ((H % d : ℕ) : ℝ) := by
    exact_mod_cast (Nat.div_add_mod H d).symm
  have h2 : ((H % d : ℕ) : ℝ) < d := by exact_mod_cast Nat.mod_lt H hd
  rw [sub_le_iff_le_add, div_le_iff₀ hdR]
  nlinarith

lemma card_filter_dvd_pair_le {p q : ℕ} (hp : p.Prime) (hq : q.Prime) (H : ℕ) :
    (((Finset.Icc 1 H).filter (fun j => p ∣ j ∧ q ∣ j)).card : ℝ) ≤
      (if p = q then (H : ℝ) / q else 0) + (H : ℝ) / p * (1 / q) := by
  by_cases hpq : p = q
  · subst hpq
    rw [if_pos rfl]
    simp only [and_self]
    rw [card_filter_dvd]
    have h1 : ((H / p : ℕ) : ℝ) ≤ (H : ℝ) / p := Nat.cast_div_le
    have h2 : 0 ≤ (H : ℝ) / p * (1 / p) := by positivity
    linarith
  · have hcop : Nat.Coprime p q := (Nat.coprime_primes hp hq).mpr hpq
    have hfilter : (Finset.Icc 1 H).filter (fun j => p ∣ j ∧ q ∣ j) =
        (Finset.Icc 1 H).filter (fun j => p * q ∣ j) := by
      apply Finset.filter_congr
      intro j _
      exact ⟨fun h => hcop.mul_dvd_of_dvd_of_dvd h.1 h.2,
        fun h => ⟨dvd_of_mul_right_dvd h, dvd_of_mul_left_dvd h⟩⟩
    rw [hfilter, card_filter_dvd, if_neg hpq, zero_add]
    calc ((H / (p * q) : ℕ) : ℝ) ≤ (H : ℝ) / ((p * q : ℕ) : ℝ) := Nat.cast_div_le
      _ = (H : ℝ) / p * (1 / q) := by rw [Nat.cast_mul, div_mul_div_comm, mul_one]

/-- Second moment: the integers `j ≤ H` divisible by at most one prime of `F` number at most
`(H s + 2 s |F|) / (s - 1)^2`, where `s = ∑_{p ∈ F} 1/p`. -/
lemma few_divisors_card_mul_le (F : Finset ℕ) (hF : ∀ p ∈ F, p.Prime) (H : ℕ)
    (hs : 1 ≤ ∑ p ∈ F, (1 : ℝ) / p) :
    (((Finset.Icc 1 H).filter (fun j => (F.filter (fun p => p ∣ j)).card ≤ 1)).card : ℝ) *
        ((∑ p ∈ F, (1 : ℝ) / p) - 1) ^ 2 ≤
      H * (∑ p ∈ F, (1 : ℝ) / p) + 2 * (∑ p ∈ F, (1 : ℝ) / p) * F.card := by
  classical
  set s := ∑ p ∈ F, (1 : ℝ) / p with hs_def
  set I := Finset.Icc 1 H with hI
  let X : ℕ → ℝ := fun j => ∑ p ∈ F, if p ∣ j then (1 : ℝ) else 0
  have hX : ∀ j, ((F.filter (fun p => p ∣ j)).card : ℝ) = X j := by
    intro j
    simp only [X, Finset.natCast_card_filter]
  have hsumX : ∑ j ∈ I, X j = ∑ p ∈ F, ((I.filter (fun j => p ∣ j)).card : ℝ) := by
    simp only [X]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro p _
    rw [Finset.natCast_card_filter]
  have hsq : ∀ j, X j ^ 2 = ∑ p ∈ F, ∑ q ∈ F, (if p ∣ j ∧ q ∣ j then (1 : ℝ) else 0) := by
    intro j
    simp only [X, sq, Finset.sum_mul_sum]
    apply Finset.sum_congr rfl
    intro p _
    apply Finset.sum_congr rfl
    intro q _
    by_cases h1 : p ∣ j <;> by_cases h2 : q ∣ j <;> simp [h1, h2]
  have hsumX2 : ∑ j ∈ I, X j ^ 2 =
      ∑ p ∈ F, ∑ q ∈ F, ((I.filter (fun j => p ∣ j ∧ q ∣ j)).card : ℝ) := by
    simp only [hsq]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro p _
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro q _
    rw [Finset.natCast_card_filter]
  have hHs : ∑ p ∈ F, (H : ℝ) / p = H * s := by
    rw [hs_def, Finset.mul_sum]
    simp_rw [mul_one_div]
  have hsumX_ge : (H : ℝ) * s - F.card ≤ ∑ j ∈ I, X j := by
    rw [hsumX]
    calc (H : ℝ) * s - F.card = ∑ p ∈ F, ((H : ℝ) / p - 1) := by
          rw [Finset.sum_sub_distrib, hHs]
          simp
      _ ≤ _ := Finset.sum_le_sum fun p hp => by
          rw [card_filter_dvd]
          exact div_sub_one_le_cast_div H p (hF p hp).pos
  have hsumX2_le : ∑ j ∈ I, X j ^ 2 ≤ (H : ℝ) * s + H * s ^ 2 := by
    rw [hsumX2]
    calc _ ≤ ∑ p ∈ F, ∑ q ∈ F,
            ((if p = q then (H : ℝ) / q else 0) + (H : ℝ) / p * (1 / q)) :=
          Finset.sum_le_sum fun p hp => Finset.sum_le_sum fun q hq =>
            card_filter_dvd_pair_le (hF p hp) (hF q hq) H
      _ = ∑ p ∈ F, ((H : ℝ) / p + (H : ℝ) / p * s) := by
          apply Finset.sum_congr rfl
          intro p hp
          rw [Finset.sum_add_distrib, Finset.sum_ite_eq, if_pos hp, ← Finset.mul_sum]
      _ = (H : ℝ) * s + H * s ^ 2 := by
          rw [Finset.sum_add_distrib, ← Finset.sum_mul, hHs]
          ring
  have hcardI : (I.card : ℝ) = H := by simp [hI]
  have hs0 : 0 ≤ s := by linarith
  have hvar : ∑ j ∈ I, (X j - s) ^ 2 ≤ H * s + 2 * s * F.card := by
    have hexp : ∑ j ∈ I, (X j - s) ^ 2 =
        ∑ j ∈ I, X j ^ 2 - 2 * s * ∑ j ∈ I, X j + I.card * s ^ 2 := by
      rw [Finset.mul_sum, ← Finset.sum_sub_distrib,
        show (I.card : ℝ) * s ^ 2 = ∑ _j ∈ I, s ^ 2 by rw [Finset.sum_const, nsmul_eq_mul],
        ← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro j _
      ring
    rw [hexp, hcardI]
    have hprod := mul_nonneg hs0 (sub_nonneg.mpr hsumX_ge)
    nlinarith
  set T := I.filter (fun j => (F.filter (fun p => p ∣ j)).card ≤ 1)
  have hpt : ∀ j ∈ T, (s - 1) ^ 2 ≤ (X j - s) ^ 2 := by
    intro j hj
    have h1 := (Finset.mem_filter.mp hj).2
    have hXj : X j ≤ 1 := by rw [← hX]; exact_mod_cast h1
    have hX0 : 0 ≤ X j := by rw [← hX]; positivity
    nlinarith [mul_nonneg (sub_nonneg.mpr hXj) (by linarith : 0 ≤ 2 * s - 1 - X j)]
  calc (T.card : ℝ) * (s - 1) ^ 2 = ∑ _j ∈ T, (s - 1) ^ 2 := by
        rw [Finset.sum_const, nsmul_eq_mul]
    _ ≤ ∑ j ∈ T, (X j - s) ^ 2 := Finset.sum_le_sum hpt
    _ ≤ ∑ j ∈ I, (X j - s) ^ 2 :=
        Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
          (fun _ _ _ => sq_nonneg _)
    _ ≤ _ := hvar

/-- The reciprocals of the primes have unbounded partial sums. -/
lemma exists_primes_recip_ge (M : ℝ) :
    ∃ n : ℕ, M ≤ ∑ p ∈ (Finset.range n).filter Nat.Prime, (1 : ℝ) / p := by
  by_contra h
  push Not at h
  apply not_summable_one_div_on_primes
  apply summable_of_sum_range_le (c := M)
  · exact Set.indicator_nonneg (fun n _ => by positivity)
  · intro n
    have := (h n).le
    rw [Finset.sum_filter] at this
    simpa only [Set.indicator_apply, Set.mem_ofPred_eq] using this

/-- For every `C, δ > 0` there is a fixed finite set of primes `F` such that, eventually, at most
`δ x` integers `j ≤ H ≤ 3 C x` are divisible by at most one prime of `F`. -/
lemma exists_few_divisors_small (C δ : ℝ) (hC : 0 ≤ C) (hδ : 0 < δ) :
    ∃ n : ℕ, ∀ᶠ x : ℝ in atTop, ∀ H : ℕ, (H : ℝ) ≤ 3 * C * x →
      ((((Finset.Icc 1 H).filter (fun j =>
        (((Finset.range n).filter Nat.Prime).filter (fun p => p ∣ j)).card ≤ 1)).card : ℝ)
        ≤ δ * x) := by
  obtain ⟨n, hn⟩ := exists_primes_recip_ge (2 + 24 * C / δ)
  refine ⟨n, ?_⟩
  set F := (Finset.range n).filter Nat.Prime
  set s := ∑ p ∈ F, (1 : ℝ) / p with hs_def
  filter_upwards [eventually_ge_atTop (8 * F.card / δ), eventually_ge_atTop (0 : ℝ)]
    with x hxF hx0 H hH
  have hFp : ∀ p ∈ F, p.Prime := fun p hp => (Finset.mem_filter.mp hp).2
  have hs2 : 2 ≤ s := by
    have : 0 ≤ 24 * C / δ := by positivity
    linarith
  have hmain := few_divisors_card_mul_le F hFp H (by linarith)
  rw [← hs_def] at hmain
  set c := ((((Finset.Icc 1 H).filter (fun j =>
        (F.filter (fun p => p ∣ j)).card ≤ 1)).card : ℝ))
  have hc0 : 0 ≤ c := Nat.cast_nonneg _
  have hF8 : 8 * (F.card : ℝ) ≤ δ * x := by
    rw [div_le_iff₀ hδ] at hxF
    linarith
  have hsC : 24 * C ≤ δ * s := by
    have := (div_le_iff₀ hδ).mp (show 24 * C / δ ≤ s by linarith)
    linarith
  -- From `c (s-1)^2 ≤ s (H + 2|F|)` and `(s-1)^2 ≥ s^2/4` we get `c s ≤ 4 (H + 2|F|)`.
  have hcs : c * s ≤ 4 * ((H : ℝ) + 2 * F.card) := by
    have hsq : s ^ 2 / 4 ≤ (s - 1) ^ 2 := by nlinarith
    have h1 : c * (s ^ 2 / 4) ≤ s * ((H : ℝ) + 2 * F.card) := by
      calc c * (s ^ 2 / 4) ≤ c * (s - 1) ^ 2 := mul_le_mul_of_nonneg_left hsq hc0
        _ ≤ _ := by linarith
    have hs0 : 0 < s := by linarith
    have : s * (c * s) ≤ s * (4 * ((H : ℝ) + 2 * F.card)) := by nlinarith
    exact le_of_mul_le_mul_left this hs0
  have hs0 : 0 < s := by linarith
  -- `δ x s ≥ 12 C x + δ x ≥ 4 (3 C x + 2 |F|)`.
  have hgoal : c * s ≤ (δ * x) * s := by
    have hxs : 12 * C * x + δ * x ≤ δ * x * s := by nlinarith
    nlinarith
  exact le_of_mul_le_mul_right hgoal hs0


/-! ### Steps 1–2: zero residues and the greedy step, remembering the zero residues -/

open LongGapsBetweenPrimes in
/-- Variant of `combine_greedy_residues` that also records `a p = 0` on the zero-residue primes. -/
lemma combine_greedy_residues_zero (S ps₀ ps₁ : Finset ℕ) (hdisj : Disjoint ps₀ ps₁)
    (hpos : ∀ p ∈ ps₀ ∪ ps₁, 0 < p) :
    ∃ a : ℕ → ℕ, (∀ p ∈ ps₀ ∪ ps₁, a p < p) ∧ (∀ p ∈ ps₀, a p = 0) ∧
      ((survivors S (ps₀ ∪ ps₁) a).card : ℝ) ≤
        ((survivors S ps₀ (fun _ => 0)).card : ℝ) * ∏ p ∈ ps₁, (1 - 1 / (p : ℝ)) := by
  classical
  obtain ⟨b, hb, hcard⟩ := greedy_residue_classes
    (survivors S ps₀ (fun _ => 0)) ps₁ (fun p hp => hpos p (Finset.mem_union_right _ hp))
  let a : ℕ → ℕ := fun p => if p ∈ ps₁ then b p else 0
  refine ⟨a, ?_, ?_, ?_⟩
  · intro p hp
    by_cases hp₁ : p ∈ ps₁
    · simpa [a, hp₁] using hb p hp₁
    · simpa [a, hp₁] using hpos p hp
  · intro p hp
    have hp₁ : p ∉ ps₁ := Finset.disjoint_left.mp hdisj hp
    simp [a, hp₁]
  · have hsubset : survivors S (ps₀ ∪ ps₁) a ⊆
        survivors (survivors S ps₀ (fun _ => 0)) ps₁ b := by
      intro n hn
      obtain ⟨hnS, hn⟩ := Finset.mem_filter.mp hn
      refine Finset.mem_filter.mpr ⟨Finset.mem_filter.mpr ⟨hnS, ?_⟩, ?_⟩
      · intro p hp
        have hp₁ : p ∉ ps₁ := Finset.disjoint_left.mp hdisj hp
        simpa [a, hp₁] using hn p (Finset.mem_union_left _ hp)
      · intro p hp
        simpa [a, hp] using hn p (Finset.mem_union_right _ hp)
    exact (Nat.cast_le.mpr (Finset.card_le_card hsubset)).trans hcard

/-! ### Step 3: many primes in `(x/4, x]` (Chebyshev) -/

lemma primesLE_subset_of_le {m n : ℕ} (h : m ≤ n) : m.primesLE ⊆ n.primesLE := by
  intro p hp
  obtain ⟨hpm, hp⟩ := Nat.mem_primesLE.mp hp
  exact Nat.mem_primesLE.mpr ⟨hpm.trans h, hp⟩

/-- Eventually there are at least `x / (4 log x)` primes in `(⌊x/4⌋, ⌊x⌋]`. -/
lemma eventually_card_top_primes : ∀ᶠ x : ℝ in atTop,
    x / (4 * Real.log x) ≤ ((⌊x⌋₊.primesLE \ ⌊x / 4⌋₊.primesLE).card : ℝ) := by
  have hsmall := (isLittleO_log_rpow_atTop (by norm_num : (0 : ℝ) < 1 / 2)).bound
    (show (0 : ℝ) < 1 / 100 by norm_num)
  filter_upwards [hsmall, eventually_ge_atTop (10000 : ℝ)] with x hlog hx
  have hx0 : 0 < x := by linarith
  have hx1 : 1 ≤ x := by linarith
  have hL0 : 0 < Real.log x := Real.log_pos (by linarith)
  have hsqrt : Real.sqrt x * Real.sqrt x = x := Real.mul_self_sqrt hx0.le
  have hsq0 : 0 ≤ Real.sqrt x := Real.sqrt_nonneg x
  -- `log x ≤ √x / 100`.
  have hlog' : Real.log x ≤ Real.sqrt x / 100 := by
    rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg hL0.le,
      abs_of_nonneg (Real.rpow_nonneg hx0.le _), ← Real.sqrt_eq_rpow] at hlog
    linarith
  -- `√x ≥ 100`, so `√x ≤ x / 100`.
  have hsqrt100 : 100 ≤ Real.sqrt x := by
    rw [show (100 : ℝ) = Real.sqrt 10000 by
      rw [show (10000 : ℝ) = 100 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]]
    exact Real.sqrt_le_sqrt hx
  have hsqrtx : Real.sqrt x ≤ x / 100 := by nlinarith
  set n := ⌊x⌋₊
  set m := ⌊x / 4⌋₊
  have hn1 : (x - 1 : ℝ) ≤ n := by linarith [Nat.lt_floor_add_one x]
  have hnx : (n : ℝ) ≤ x := Nat.floor_le hx0.le
  have hn0 : (1 : ℝ) ≤ n := by linarith
  have hmn : m ≤ n := Nat.floor_mono (by linarith)
  have hsplit := Finset.sum_sdiff (f := fun p : ℕ => Real.log p) (primesLE_subset_of_le hmn)
  rw [← Chebyshev.theta_eq_sum_primesLE_log, ← Chebyshev.theta_eq_sum_primesLE_log] at hsplit
  have hθn := Chebyshev.theta_ge n
  have hθm : Chebyshev.theta m ≤ Real.log 4 * m :=
    Chebyshev.theta_le_log4_mul_x (Nat.cast_nonneg m)
  have hm : (m : ℝ) ≤ x / 4 := Nat.floor_le (by linarith)
  have hlog4 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.log_pow]; norm_num
  have hlog2 : Real.log 2 < 0.7 := by
    have := Real.log_two_lt_d9; norm_num at this ⊢; linarith
  have hlog2' : 0.69 < Real.log 2 := by
    have := Real.log_two_gt_d9; norm_num at this ⊢; linarith
  -- Error terms.
  have hlogn : Real.log n ≤ Real.log x := Real.log_le_log (by linarith) hnx
  have hlogn1 : Real.log ((n : ℝ) + 1) ≤ Real.log 2 + Real.log x := by
    rw [← Real.log_mul (by norm_num) hx0.ne']
    exact Real.log_le_log (by linarith) (by linarith)
  have hsqrtn : Real.sqrt n ≤ Real.sqrt x := Real.sqrt_le_sqrt hnx
  have hlogn0 : 0 ≤ Real.log n := Real.log_nonneg hn0
  have herr : 2 * Real.sqrt n * Real.log n ≤ x / 50 := by
    calc 2 * Real.sqrt n * Real.log n ≤ 2 * Real.sqrt x * (Real.sqrt x / 100) := by
          gcongr
          exact hlogn.trans hlog'
      _ = x / 50 := by rw [mul_assoc, mul_div_assoc', hsqrt]; ring
  -- The sum over the top primes is at least `x / 4`.
  have htop : x / 4 ≤ ∑ p ∈ n.primesLE \ m.primesLE, Real.log p := by
    have h1 : ∑ p ∈ n.primesLE \ m.primesLE, Real.log p =
        Chebyshev.theta n - Chebyshev.theta m := by linarith
    rw [h1]
    have hlx : Real.log x ≤ x / 10000 := by nlinarith
    nlinarith
  -- Each summand is at most `log x`.
  have hbound : ∑ p ∈ n.primesLE \ m.primesLE, Real.log p ≤
      ((n.primesLE \ m.primesLE).card : ℝ) * Real.log x := by
    rw [← nsmul_eq_mul, ← Finset.sum_const]
    apply Finset.sum_le_sum
    intro p hp
    obtain ⟨hpn, hp⟩ := Nat.mem_primesLE.mp (Finset.mem_sdiff.mp hp).1
    exact Real.log_le_log (by exact_mod_cast hp.pos)
      ((by exact_mod_cast hpn : (p : ℝ) ≤ n).trans hnx)
  rw [div_le_iff₀ (by positivity)]
  nlinarith

/-! ### Assembling the covering -/

open LongGapsBetweenPrimes in
/-- The final size comparison: the survivors of the greedy sieve at scale `x/4` are fewer than
the primes in `(x/4, x]`. -/
lemma eventually_survivors_le_top (C : ℝ) (hC : 0 ≤ C) : ∀ᶠ x : ℝ in atTop,
    ∀ H : ℕ, (H : ℝ) ≤ 3 * C * x →
    (Real.log 4 + 2) * H / Real.log (x / 4) *
      (10 * smoothScaleConstant * Real.exp 6 * Real.log (Real.log (x / 4)) ^ 2 /
        (Real.log (x / 4) * Real.log (Real.log (Real.log (x / 4))))) ≤ x / (4 * Real.log x) := by
  have hq : Tendsto (fun x : ℝ => x / 4) atTop atTop := tendsto_id.atTop_div_const (by norm_num)
  set c1 := (Real.log 4 + 2) * (10 * smoothScaleConstant * Real.exp 6) with hc1
  have hc1pos : 0 < c1 := by
    have := smoothScaleConstant_pos
    have : 0 < Real.log 4 := Real.log_pos (by norm_num)
    positivity
  have hratio : Tendsto (fun x : ℝ => Real.log (Real.log x) ^ 2 / Real.log x) atTop (nhds 0) := by
    have h := (Real.tendsto_pow_log_div_mul_add_atTop 1 0 2 one_ne_zero).comp
      Real.tendsto_log_atTop
    simp only [one_mul, add_zero] at h
    exact h
  filter_upwards [hq.eventually eventually_cover_parameters,
    hratio.eventually_le_const (show (0 : ℝ) < 1 / (48 * c1 * (C + 1)) by positivity),
    eventually_ge_atTop (16 : ℝ)] with x hpar hK hx16 H hH
  obtain ⟨hy, hLy, hLLy, hLLLy, -, -, -, -, -⟩ := hpar
  have hx0 : 0 < x := by linarith
  have hA : 0 < Real.log x := Real.log_pos (by linarith)
  set A := Real.log x
  set B := Real.log (Real.log x)
  set Ly := Real.log (x / 4)
  set LLy := Real.log (Real.log (x / 4))
  set LLLy := Real.log (Real.log (Real.log (x / 4)))
  have hLy : A / 2 ≤ Ly := by
    have h4 : Real.log 4 ≤ A / 2 := by
      have : Real.log 16 ≤ A := Real.log_le_log (by norm_num) hx16
      have h16 : Real.log 16 = 2 * Real.log 4 := by
        rw [show (16 : ℝ) = 4 ^ 2 by norm_num, Real.log_pow]; norm_num
      linarith
    have : Ly = A - Real.log 4 := by
      simp only [Ly, A]; rw [Real.log_div hx0.ne' (by norm_num)]
    linarith
  have hLLyB : LLy ≤ B := by
    apply Real.log_le_log (by linarith)
    exact Real.log_le_log (by linarith) (by linarith)
  have hLLy0 : 0 ≤ LLy := by linarith
  have hH0 : (0 : ℝ) ≤ H := Nat.cast_nonneg H
  have hKB : 48 * c1 * (C + 1) * B ^ 2 ≤ A := by
    have := (div_le_iff₀ hA).mp hK
    rw [div_mul_eq_mul_div, one_mul, le_div_iff₀ (by positivity)] at this
    linarith
  have hlhs : (Real.log 4 + 2) * H / Ly *
      (10 * smoothScaleConstant * Real.exp 6 * LLy ^ 2 / (Ly * LLLy)) =
      c1 * (H * LLy ^ 2) / (Ly ^ 2 * LLLy) := by
    have : Ly ≠ 0 := by linarith
    have : LLLy ≠ 0 := by linarith
    rw [hc1]
    field_simp
  rw [hlhs]
  calc c1 * (H * LLy ^ 2) / (Ly ^ 2 * LLLy) ≤ c1 * (3 * C * x * B ^ 2) / ((A / 2) ^ 2 * 1) := by
        apply div_le_div₀ (by positivity)
        · apply mul_le_mul_of_nonneg_left _ hc1pos.le
          apply mul_le_mul hH (pow_le_pow_left₀ hLLy0 hLLyB 2) (by positivity) (by positivity)
        · positivity
        · apply mul_le_mul (pow_le_pow_left₀ (by positivity) hLy 2) hLLLy (by norm_num)
            (by positivity)
    _ ≤ x / (4 * A) := by
        rw [div_le_div_iff₀ (by positivity) (by positivity)]
        have hxA : 0 ≤ x * A := by positivity
        have := mul_le_mul_of_nonneg_left hKB hxA
        nlinarith [mul_nonneg hxA (sq_nonneg B), mul_nonneg (mul_nonneg hxA (sq_nonneg B)) hc1pos.le]

open LongGapsBetweenPrimes in
/-- The covering construction. For large `x` and `x/4 ≤ H ≤ 3Cx` there are residues `a p < p`
for the primes `p ≤ x` such that every `j ∈ [1, H]` is hit, and at most `δ x` positions are hit
exactly once.

* Steps 1–2: zero residues and the greedy choice, both at scale `y = x/4` (`combine_greedy_residues_zero`,
  `eventually_zeroSurvivors_bound`, `eventually_greedy_product_bound`).
* Step 3: each survivor gets its own prime from `(⌊x/4⌋, ⌊x⌋]` (`eventually_card_top_primes`).
* Step 4: a position hit exactly once has at most one divisor in a fixed finite set `F` of primes
  with residue zero (`exists_few_divisors_small`). -/
theorem eventually_cover_residues (C δ : ℝ) (hC : 1 ≤ C) (hδ : 0 < δ) :
    ∀ᶠ x : ℝ in atTop, ∀ H : ℕ, x / 4 ≤ H → (H : ℝ) ≤ 3 * C * x →
      ∃ a : ℕ → ℕ, (∀ p ∈ ⌊x⌋₊.primesLE, a p < p) ∧
        (∀ j ∈ Finset.Icc 1 H, ∃ p ∈ ⌊x⌋₊.primesLE, j % p = a p) ∧
        ((((Finset.Icc 1 H).filter (fun j =>
          ((⌊x⌋₊.primesLE).filter (fun p => j % p = a p)).card = 1)).card : ℝ) ≤ δ * x) := by
  classical
  obtain ⟨n, hFsmall⟩ := exists_few_divisors_small C δ (by linarith) hδ
  have hq : Tendsto (fun x : ℝ => x / 4) atTop atTop := tendsto_id.atTop_div_const (by norm_num)
  have hW : ∀ᶠ x : ℝ in atTop, n ≤ coverW (x / 4) := by
    have : Tendsto (fun x : ℝ => (Real.log (x / 4)) ^ 4) atTop atTop :=
      (tendsto_pow_atTop (by norm_num)).comp (Real.tendsto_log_atTop.comp hq)
    filter_upwards [this.eventually_ge_atTop (n : ℝ)] with x hx
    exact Nat.le_floor hx
  filter_upwards [hq.eventually eventually_cover_parameters,
    hq.eventually eventually_zeroSurvivors_bound, hq.eventually eventually_greedy_product_bound,
    eventually_card_top_primes, hFsmall, hW, eventually_survivors_le_top C (by linarith),
    (Real.tendsto_log_atTop.comp hq).eventually_ge_atTop (12 * C),
    eventually_ge_atTop (1 : ℝ)]
    with x hpar hzero hgreedy htop hF hWn hsize hlogC hx1 H hHlow hHup
  simp only [Function.comp_apply] at hlogC
  set y := x / 4 with hy_def
  obtain ⟨hy2, hLy, _, _, _, _, _, hZlow, hZhigh⟩ := hpar
  have hy0 : 0 < y := by linarith
  have hy1 : 1 < y := by linarith
  have hyx : y ≤ x := by linarith
  have hLy0 : 0 < Real.log y := by linarith
  have hZ : coverZ y ≤ ⌊y⌋₊ := coverZ_le_floor hy0 hZhigh
  have hWZ : coverW y ≤ coverZ y := coverW_le_coverZ hy1 hZlow
  set ps₀ := zeroCoverPrimes y with hps₀_def
  set ps₁ := auxiliaryPrimes (coverW y) (coverZ y) with hps₁_def
  have hps₀ : ps₀ ⊆ ⌊y⌋₊.primesLE := zeroCoverPrimes_subset hy0.le (hWZ.trans hZ)
  have hps₁ : ps₁ ⊆ ⌊y⌋₊.primesLE := by
    intro p hp
    obtain ⟨hp, _, hpZ⟩ := mem_auxiliaryPrimes.mp hp
    exact Nat.mem_primesLE.mpr ⟨hpZ.trans hZ, hp⟩
  have hsmall : ps₀ ∪ ps₁ ⊆ ⌊y⌋₊.primesLE := Finset.union_subset hps₀ hps₁
  have hyxP : ⌊y⌋₊.primesLE ⊆ ⌊x⌋₊.primesLE := primesLE_subset_of_le (Nat.floor_mono hyx)
  obtain ⟨a, ha, ha0, hcard⟩ := combine_greedy_residues_zero (Finset.Icc 1 H) ps₀ ps₁
    (zeroCoverPrimes_disjoint y) (fun p hp => (Nat.mem_primesLE.mp (hsmall hp)).2.pos)
  set U := survivors (Finset.Icc 1 H) (ps₀ ∪ ps₁) a with hU_def
  set Top := ⌊x⌋₊.primesLE \ ⌊y⌋₊.primesLE with hTop_def
  -- Size of `H` relative to `y`.
  have hHy : (H : ℝ) ≤ y * Real.log y ^ 2 := by
    have h1 : 12 * C ≤ Real.log y ^ 2 := by nlinarith
    calc (H : ℝ) ≤ 3 * C * x := hHup
      _ = y * (12 * C) := by rw [hy_def]; ring
      _ ≤ y * Real.log y ^ 2 := mul_le_mul_of_nonneg_left h1 hy0.le
  -- The survivors are at most as many as the top primes.
  have hl4 : 0 < Real.log 4 := Real.log_pos (by norm_num)
  have hprod0 : 0 ≤ ∏ p ∈ ps₁, (1 - 1 / (p : ℝ)) := by
    apply Finset.prod_nonneg
    intro p hp
    have hp1 : (1 : ℝ) ≤ p := by exact_mod_cast (auxiliaryPrimes_prime hp).one_lt.le
    exact sub_nonneg.mpr ((div_le_one (by linarith)).mpr hp1)
  have hUcard : (U.card : ℝ) ≤ (Top.card : ℝ) := by
    calc (U.card : ℝ) ≤ ((zeroSurvivors y H).card : ℝ) * ∏ p ∈ ps₁, (1 - 1 / (p : ℝ)) := hcard
      _ ≤ ((Real.log 4 + 2) * H / Real.log y) *
          (10 * smoothScaleConstant * Real.exp 6 * Real.log (Real.log y) ^ 2 /
            (Real.log y * Real.log (Real.log (Real.log y)))) :=
          mul_le_mul (hzero H hHlow hHy) hgreedy hprod0
            (div_nonneg (by positivity) hLy0.le)
      _ ≤ x / (4 * Real.log x) := hsize H hHup
      _ ≤ Top.card := htop
  -- An injection from the survivors into the top primes.
  obtain ⟨e⟩ : Nonempty (U ↪ Top) := Function.Embedding.nonempty_of_card_le (by
    simp only [Fintype.card_coe]
    exact_mod_cast hUcard)
  let g : ℕ → ℕ := fun u => if h : u ∈ U then (e ⟨u, h⟩).val else 0
  have hgTop : ∀ u ∈ U, g u ∈ Top := fun u hu => by
    simp only [g, dif_pos hu]
    exact (e ⟨u, hu⟩).property
  have hginj : ∀ u ∈ U, ∀ v ∈ U, g u = g v → u = v := by
    intro u hu v hv h
    simp only [g, dif_pos hu, dif_pos hv] at h
    exact congrArg Subtype.val (e.injective (Subtype.ext h))
  let a' : ℕ → ℕ := fun p => if p ∈ ps₀ ∪ ps₁ then a p else
    if h : ∃ u ∈ U, g u = p then h.choose % p else 0
  have hgval : ∀ u ∈ U, a' (g u) = u % g u := by
    intro u hu
    have hnot : g u ∉ ps₀ ∪ ps₁ := fun h => (Finset.mem_sdiff.mp (hgTop u hu)).2 (hsmall h)
    have hex : ∃ v ∈ U, g v = g u := ⟨u, hu, rfl⟩
    simp only [a', if_neg hnot, dif_pos hex]
    rw [hginj _ hex.choose_spec.1 u hu hex.choose_spec.2]
  refine ⟨a', ?_, ?_, ?_⟩
  · intro p hp
    have hp0 := (Nat.mem_primesLE.mp hp).2.pos
    by_cases h1 : p ∈ ps₀ ∪ ps₁
    · simp only [a', if_pos h1]
      exact ha p h1
    · simp only [a', if_neg h1]
      split_ifs with h2
      · exact Nat.mod_lt _ hp0
      · exact hp0
  · intro j hj
    by_cases hjU : j ∈ U
    · exact ⟨g j, (Finset.mem_sdiff.mp (hgTop j hjU)).1, (hgval j hjU).symm⟩
    · have hnot : ¬ ∀ p ∈ ps₀ ∪ ps₁, j % p ≠ a p := fun h =>
        hjU (by rw [hU_def, survivors, Finset.mem_filter]; exact ⟨hj, h⟩)
      push Not at hnot
      obtain ⟨p, hp, hjp⟩ := hnot
      refine ⟨p, hyxP (hsmall hp), ?_⟩
      simp only [a', if_pos hp]
      exact hjp
  · set F := (Finset.range n).filter Nat.Prime with hF_def
    have hsub : (Finset.Icc 1 H).filter
          (fun j => ((⌊x⌋₊.primesLE).filter (fun p => j % p = a' p)).card = 1) ⊆
        (Finset.Icc 1 H).filter (fun j => (F.filter (fun p => p ∣ j)).card ≤ 1) := by
      intro j hj
      obtain ⟨hjI, hj1⟩ := Finset.mem_filter.mp hj
      refine Finset.mem_filter.mpr ⟨hjI, ?_⟩
      rw [← hj1]
      apply Finset.card_le_card
      intro p hp
      obtain ⟨hpF, hpj⟩ := Finset.mem_filter.mp hp
      obtain ⟨hpn, hpprime⟩ := Finset.mem_filter.mp hpF
      have hp₀ : p ∈ ps₀ := by
        rw [hps₀_def, zeroCoverPrimes]
        exact Finset.mem_union_left _
          (Nat.mem_primesLE.mpr ⟨(Finset.mem_range.mp hpn).le.trans hWn, hpprime⟩)
      have hpsmall : p ∈ ps₀ ∪ ps₁ := Finset.mem_union_left _ hp₀
      refine Finset.mem_filter.mpr ⟨hyxP (hsmall hpsmall), ?_⟩
      simp only [a', if_pos hpsmall, ha0 p hp₀]
      exact Nat.mod_eq_zero_of_dvd hpj
    calc _ ≤ (((Finset.Icc 1 H).filter (fun j => (F.filter (fun p => p ∣ j)).card ≤ 1)).card : ℝ) :=
          by exact_mod_cast Finset.card_le_card hsub
      _ ≤ δ * x := hF H hHup

end Erdos1139Cover
