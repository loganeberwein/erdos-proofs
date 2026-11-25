# Erdős Problem #634 — partial results

**Problem** ([erdosproblems.com/634](https://www.erdosproblems.com/634)). For which N can some triangle be cut into N congruent triangles? **Prize:** $25.

**Status of the problem** (as of 2026-11-25): open (the page notes a finite computation cannot settle it). Recent literature, not ours:
- Primes are settled: Beeson and Roşu (arXiv 2607.23453, v4 of Nov 11, 2026; proofs formalized in Lean) prove a prime N works exactly when N = 2, N = 3 or N ≡ 1 (mod 4). Paliy and Bonfioli have overlapping work.
- Bonfioli's census (GitHub ElVec1o/erdos634_primes_and_N200, release v6.0, Nov 18, 2026) reports every N ≤ 200 decided; 27 values up to 1000 remain open, the smallest being 236, 280, 284, 332, 351, 423, 444. Not independently checked here.
- Structure: Laczkovich reduced the possible tile shapes to finitely many types; for each type comparing areas gives N = j²·N₀(e, f, …). Constructions work once the target is large relative to the tile (Zhang: n²ab for large n); exclusions so far cover thin bands (e.g. Bonfioli's W-gap theorem, M(f − e) < f).

## Results here
No lemma was proved. The only new item is one computation on the public census data.

**1. [Computed] Square-class pattern in the open list.** Downloaded Bonfioli's v6.0 undecided list for N ≤ 10^6 (52,045 open non-squarefree values; the census reports about 771 further open squarefree values, not analysed here) and factored each value as N = j²·c with c squarefree (sympy). Exhaustive over that list:
- The largest class, 15,720 values, has core c ≡ 11 (mod 12).
- Among the smallest open values are 236 = 4·59, 284 = 4·71, 332 = 4·83, 423 = 9·47 and 531 = 9·59; the cores 47, 59, 71, 83 are all primes ≡ 11 (mod 12).
- These cores have the form N₀ = 3f² − e², the base value for the tile (ef, f² − e², f²) family. For (e, f) = (1, 2) the tile (2, 3, 4) was checked to satisfy 3α + 2β = π.

**2. [Heuristic]** Beeson–Roşu appear to exclude j = 1 for this family, so the frontier is small j ≥ 2 (first open case 236 = 2²·59). This reading of their result was not verified line by line.

## Routes tried and why they failed
- Signed-direction (Dehn-type) functionals and area integrality — qualitative wall: these are linear tests nearly independent of the scale j, so they give exclusion bands, never a size threshold.
- Self-similar tilings (Snover et al.: n², n² + m², 3n²) — already used; caps out quickly.
- Larger exhaustive searches (Bonfioli handled 135 with about 1.3M nodes) — cost wall, and cannot decide infinitely many N.
- Conway–Lagarias tiling groups / Thurston height functions (the only candidate whose output is a threshold) — not tested: it depends on whether tilings with these tiles use finitely many edge directions when α is an irrational multiple of π, which was not checked. Toy test proposed (build the height function for the (2, 3, 4) tile and re-derive the j = 1 exclusion or one W-gap band), not run.
Missing primitive: a scale-dependent certificate of non-tileability that rules out size j below a threshold and fails above it.

## Code
Original scripts not preserved. The analysis was a short Python script: read the census file, compute j and the squarefree core of each value with sympy.factorint, tally cores mod 12.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
