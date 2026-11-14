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

- `lakefile.toml`: added `lean_lib` `Erdos1139Sketch` and added it to `defaultTargets`.
  The `require` blocks, `lean-toolchain` and `lake-manifest.json` are unchanged.
- New file `Erdos1139Sketch.lean`: an **incomplete** top-level sketch of Erdős #1139. It
  contains `sorry`s, each tagged `TODO(n)` with the gap it stands for.
- Upstream `README.md` renamed to `UPSTREAM_README.md`.

## Verification record

VERIFICATION_RECORD_PLACEHOLDER
