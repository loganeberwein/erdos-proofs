# Changes relative to openai/LongGapsBetweenPrimes

**Upstream:** <https://github.com/openai/LongGapsBetweenPrimes>, commit
`03a1190d0bc5502d9f54eeb60ad3e45e22b0df0b`.
Copyright OpenAI, Apache-2.0 (see [LICENSE](LICENSE)). Modified by Logan Eberwein.

The exact diff of `LongGapsBetweenPrimes.lean` against that commit is
[`../short_translates_divisor.diff`](../short_translates_divisor.diff).

**No existing statement or proof was changed.** The only edits to
`LongGapsBetweenPrimes.lean` are additions: three declarations, placed right after
`short_translates`, and two `#print axioms` commands at the end of the file.

## Additions to `LongGapsBetweenPrimes.lean`

### 1. `eventually_sieveY_mul_floor_lt_primorial` (helper lemma)

```lean
lemma eventually_sieveY_mul_floor_lt_primorial : ∀ᶠ x : ℝ in Filter.atTop,
    sieveY x * ⌊x⌋₊ < primorial ⌊x⌋₊
```

A strengthening of the existing `eventually_sieveY_lt_primorial`, proved the same way
(Chebyshev's θ bound) with one extra `log x / x → 0` term. It is needed for the
`p * ⌊x⌋₊ < …` bound below.

### 2. `short_translates_divisor_with_sieveDelta` (strong form)

```lean
theorem short_translates_divisor_with_sieveDelta : ∀ᶠ x : ℝ in Filter.atTop,
    ∀ H : ℕ, x < H → (H : ℝ) ≤ x * (Real.log x) ^ 2 →
    ∀ S : Finset ℕ, S ⊆ Finset.Icc 1 H → (S.card : ℝ) ≤ sieveDelta * x →
    ∀ b : ℕ, b < primorial ⌊x⌋₊ →
    ∃ t : ℕ, 1 ≤ t ∧ (t : ℝ) ≤ Real.exp x ∧
      ∀ s ∈ S, ∃ p : ℕ, p.Prime ∧ x ^ 6 < p ∧ (p : ℝ) ≤ Real.exp (x / (Real.log x) ^ 5) ∧
        ⌊x⌋₊ < p ∧ p * ⌊x⌋₊ < b + primorial ⌊x⌋₊ * t + s ∧
        p ∣ b + primorial ⌊x⌋₊ * t + s
```

Same hypotheses as `short_translates_with_sieveDelta`. The proof follows that theorem's
proof and keeps the auxiliary prime that the original only used to rule out primality:

- `exists_linear_roots` gives, for each auxiliary prime, roots forcing
  `p ∣ b + Q * (n + 1) + s`.
- `eventually_simultaneous_roots` (through `finite_simultaneous_roots`) gives one `n`
  hitting every element of `S`.
- `mem_auxiliaryPrimes` gives the range `sieveZ x < p ≤ sieveY x`.

### 3. `short_translates_divisor` (minimal form, derived from 2)

```lean
theorem short_translates_divisor :
    ∃ δ : ℝ, 0 < δ ∧ δ < 1 / 2 ∧ ∀ᶠ x : ℝ in Filter.atTop,
      ∀ H : ℕ, x < H → (H : ℝ) ≤ x * (Real.log x) ^ 2 →
      ∀ S : Finset ℕ, S ⊆ Finset.Icc 1 H → (S.card : ℝ) ≤ δ * x →
      ∀ b : ℕ, b < primorial ⌊x⌋₊ →
      ∃ t : ℕ, 1 ≤ t ∧ (t : ℝ) ≤ Real.exp x ∧
        ∀ s ∈ S, ∃ p : ℕ, p.Prime ∧ ⌊x⌋₊ < p ∧
          p * ⌊x⌋₊ < b + primorial ⌊x⌋₊ * t + s ∧
          p ∣ b + primorial ⌊x⌋₊ * t + s
```

The witness is δ = `sieveDelta`, the same δ used by `short_translates`.

## Other changes

- `lakefile.toml`: added `lean_lib`s `Erdos1139Cover` and `Erdos1139Sketch` and added them to
  `defaultTargets`. The `require` blocks, `lean-toolchain` and `lake-manifest.json` are
  unchanged.
- New file `Erdos1139Cover.lean`: the covering construction, `eventually_cover_residues`.
- New file `Erdos1139Sketch.lean`: the reduction and the final theorem `erdos_1139`, whose
  statement is copied verbatim from google-deepmind/formal-conjectures.
- Upstream `README.md` renamed to `UPSTREAM_README.md`.

## The covering construction (`Erdos1139Cover.lean`)

`eventually_cover` in `Erdos1139Sketch.lean` is now proved from

```lean
theorem eventually_cover_residues (C δ : ℝ) (hC : 1 ≤ C) (hδ : 0 < δ) :
    ∀ᶠ x : ℝ in atTop, ∀ H : ℕ, x / 4 ≤ H → (H : ℝ) ≤ 3 * C * x →
      ∃ a : ℕ → ℕ, (∀ p ∈ ⌊x⌋₊.primesLE, a p < p) ∧
        (∀ j ∈ Finset.Icc 1 H, ∃ p ∈ ⌊x⌋₊.primesLE, j % p = a p) ∧
        ((((Finset.Icc 1 H).filter (fun j =>
          ((⌊x⌋₊.primesLE).filter (fun p => j % p = a p)).card = 1)).card : ℝ) ≤ δ * x)
```

Compared with the written plan, three parameters changed:

1. **The sieve runs at scale `y = x/4` instead of `x/2`.** Mathlib's Chebyshev bounds
   (`Chebyshev.theta_ge`, `Chebyshev.theta_le_log4_mul_x`) cancel exactly on `(x/2, x]` and
   give no lower bound for the number of primes there. On `(x/4, x]` they give at least
   `x / (4 log x)` primes (`eventually_card_top_primes`).
2. **Each survivor gets one prime of `(x/4, x]`, not two.** A survivor hit by only that prime
   is counted in `S₁`; `S₁` is still at most `δ x` by step 3.
3. **The positions hit exactly once are bounded with a fixed finite prime set `F`.** `F` is
   independent of `x`, chosen from the divergence of `∑ 1/p` so that `∑_{p ∈ F} 1/p` is large,
   with residue `0` on `F`. A second-moment (Chebyshev inequality) bound
   (`few_divisors_card_mul_le`) shows few `j ≤ H` have at most one divisor in `F`. This
   replaces the upper-bound sieve with `w = (log x)^4`.

The file sets `maxSynthPendingDepth 1` and `linter.mathlibStandardSet false`, overriding the
lakefile. With the lakefile's values, elaboration of this file ran past 7 GB of memory
without finishing. Neither option affects what is proved.

## Verification record

Earlier record (`LongGapsBetweenPrimes.lean` alone, on `main`): built on 2026-11-14 (Windows 11,
x86_64) with `lake exe cache get` then `lake build`, 8709 jobs, no warnings in that file,
51 min 30 s wall clock. `LongGapsBetweenPrimes.lean` alone took 2551 s (993 s in an earlier
checkout; the difference is disk contention).

Full proof, on branch `full-formalization-1139`, built on 2026-11-14 with `lake build`:

- **Lean:** `Lean (version 4.33.0, x86_64-w64-windows-gnu, commit d8b18978322de05a8f3dba51ef03cf5461676c17, Release)`
- **Mathlib:** `db584cd6d46c92f209a44c0f1c829460d327499d` (pinned in `lake-manifest.json`)
- **Result:** `Build completed successfully (8711 jobs).` Exit code 0. `Erdos1139Cover` built in
  850 s and `Erdos1139Sketch` in 1288 s. The only warning is a style lint in
  `Erdos1139Sketch.lean` (a `show` that changes the goal; `change` is preferred).
- **Forbidden keywords:** `grep -nwE 'sorry|admit|native_decide'` and `grep -nE '^\s*axiom\s'`
  on `LongGapsBetweenPrimes.lean`, `Erdos1139Cover.lean` and `Erdos1139Sketch.lean` find
  nothing except the word "`sorry`-free" in the module docstring of `Erdos1139Sketch.lean`.

Axiom output:

```
'Erdos1139Sketch.erdos_1139' depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos1139Cover.eventually_cover_residues' depends on axioms: [propext, Classical.choice, Quot.sound]
'LongGapsBetweenPrimes.short_translates' depends on axioms: [propext, Classical.choice, Quot.sound]
'LongGapsBetweenPrimes.short_translates_divisor' depends on axioms: [propext, Classical.choice, Quot.sound]
'LongGapsBetweenPrimes.short_translates_divisor_with_sieveDelta' depends on axioms: [propext, Classical.choice, Quot.sound]
'LongGapsBetweenPrimes.long_prime_gaps' depends on axioms: [propext, Classical.choice, Quot.sound]
```
