# Althöfer stochastic Collatz prize (and 3n±1 game) — partial results

**Problem** ([althofer.de/collatz-prizes.html](https://althofer.de/collatz-prizes.html), Prize 0). Start at an odd n. At each step flip a fair coin and replace n by odd(3n + 1) or odd(3n − 1), where odd(m) is m with all factors of 2 removed; 1 is absorbing (odd(3·1 ± 1) = 1). Does every start reach 1 with probability 1? **Prize:** 300 EUR, first proof before 2037-12-31.
Also covered: **Prize 3, the 3n±1 game** (500 EUR). Two players alternately replace n by odd(3n + 1) or odd(3n − 1); the mover who produces 1 wins. Prove that under optimal play the game always ends (no draws).

**Status of the problem** (as of 2026-11-25): both open. Althöfer's note "On 3n+3 dust" shows that numbers 2^k·u ± 1 trap the process for any fixed number of steps when k is large, so no finite residue-class ("cylinder") Lyapunov proof exists; the variant with 3n+1 and 3n+3 has a simple proof. A claimed proof for the game was later admitted to have gaps; the page lists it as open.

## Results here
Notation: for odd n > 1 let s = +1 if n ≡ 1 (mod 4), s = −1 if n ≡ 3 (mod 4); write n = 2^D·u + s with u odd and depth D = v₂(n − s) ≥ 2.

**1. [Proved] Greedy descent.** For odd n > 1, 4 | 3n + s, so odd(3n + s) ≤ (3n + 1)/4 < n. So the one-player version is trivial; all difficulty is in the coin (Prize 0) and the opponent (Prize 3).

**2. [Proved] Sibling relation.** With v = v₂(3n + s) ≥ 2: odd(3n − s) = (3n − s)/2 = 2^(v−1)·odd(3n + s) − s. Proof: 3n − s = (3n + s) − 2s, and 3n − s ≡ 2 (mod 4). The depth of the "bad" child is set by how far the "good" child fell.

**3. [Proved] Trap dynamics.** For D ≥ 3, odd(3n + s) = 3·2^(D−2)·u + s; for D ≥ 2, odd(3n − s) = 3·2^(D−1)·u + s. Proof: 3n + s = 3·2^D·u + 4s = 4(3·2^(D−2)u + s), and 3n − s = 2(3·2^(D−1)u + s). So inside a deep trap n is multiplied by about 3/4 or 3/2 while the depth drops by 2 or 1: expected log-drift +½·ln(9/8) ≈ +0.059 per step. This is the obstruction.
Checks for 1–3: 200,000 random n < 10^30, no violation; a fresh referee agent checked every odd n ≤ 2,000,001.

**4. [Reduction] Block-drift hypothesis implies Prize 0.** Hypothesis (H): there are K, δ > 0 and N₀ such that for every odd n ≥ N₀, E_n[ln X_T] ≤ ln n − δ with T = ⌈K ln n⌉. Then every start reaches 1 with probability 1.
Proof sketch: sample the chain at Y_{j+1} = X after T(Y_j) more steps if Y_j ≥ N₀, else after 1 step. W_j = ln Y_j ≥ 0 drops by δ in conditional expectation while Y_j ≥ N₀, so by optional stopping on the nonnegative supermartingale W_{j∧ρ} + δ(j∧ρ) the hitting time ρ of {Y < N₀} has E[ρ] ≤ W₀/δ; by the strong Markov property {< N₀} is visited infinitely often a.s. From any m < N₀ the greedy path (item 1) reaches 1 within N₀ steps with probability ≥ 2^(−N₀); using visits separated by ≥ N₀ steps, P(never absorbed) ≤ (1 − 2^(−N₀))^k for every k, hence 0.
Checked by a fresh adversarial referee agent: confirmed, minor bookkeeping notes only. All the difficulty sits in (H).

**5. [Computed] Evidence for (H).** Exact backward dynamic programming of E_n[ln X_t] (float32 storage) over every odd n < 2^20, band by band [2^(B−1), 2^B), up to about 20 steps:
- The worst n in every band is a pure trap 2^k ± 1; nothing chains traps better.
- The block length needed for negative worst-case drift is about 1.0–1.15 × ln n (trap model predicts 1.16).
- Peak gain per ln n rises from 0.028 to 0.045, consistent with the trap-model limit 0.057; the data cannot rule out other slow growth.
- Referee Monte Carlo on 2^D ± 1 up to D = 80 agrees.

**6. [Computed] Depth-corrected potential.** V = ln n + c·D(n) (c = 0.1, 0.25, exhaustive over the band [2^14, 2^15), up to 12 steps) cancels the simple trap; the worst case becomes a trap planted at a trap exit (21847 → 16385 = 2^14 + 1).

**7. [Proved] Spread of deep exits.** 3 has order 2^(L−2) modulo 2^L (L ≥ 3, standard). So among 2^(L−2) consecutive exponents j, at most one value 3^(j+1)·u + s can have depth ≥ L. This handles deep re-entry but not shallow traps (D = 2, 3).

**Later session (exact labels as recorded):**
- **[Computed]** Inside a trap n = 2^D·u − 1, every reachable value has the form 3^i·2^(D−j)·u − 1 (algebra, and both maps fix the 2-adic points +1 and −1).
- **[Computed]** Coin paths coalesce: 2^18 coin paths reach only about 200–340 distinct values from random 14–60-bit starts.
- **[Computed]** Exhaustive over all odd n in [2^13, 2^14) for 16 steps and [2^17, 2^18) for 13 steps: the worst total-variation distance of n_t mod 64 from uniform stays about 0.8 to 0.9, so random-affine-walk mixing (Chung–Diaconis–Graham type) cannot supply the needed randomness.
- **[Computed]** At trap exits (12 random trap starts, depths 8–64), the distance of n_t mod 16 from uniform stays 0.14–0.27 and does not shrink with depth.

**8. [Computed] The 3n±1 game, exhaustive small range.** Retrograde analysis on odd n < 2^30 (positions above 2^30 treated as unknown). Every odd n < 2^21 is decided (win/loss), with no draws there. Longest forced win: 61 moves, at n = 1,401,989. Losing positions are about 49% and come in runs of consecutive odd numbers (suggesting dependence on size, not 2-adic digits). No lemma was extracted.

## Routes tried and why they failed
- Finite residue-class (cylinder) Lyapunov function — counterexample: Althöfer's traps 2^k·u ± 1 (verified here, item 3).
- Depth-corrected potential ln n + c·D(n) — the worst case moves to traps planted at trap exits (item 6).
- Random-affine-walk mixing mod 2^L (Chung–Diaconis–Graham) — n_t mod 64 stays far from uniform for the worst n (later session).
- Exit randomness at shallow traps — no proof that the digits read at trap exits (v₂(3^(j+1)·u + s) and the next depth) cannot be rigged across many coin paths at once; order-of-3 spread (item 7) covers only deep exits. Qualitative wall.
- Proposed next step, not done: a collision bound P(two independent coin paths agree mod 2^L after ~K log n steps) ≤ C·2^(−L), which via Cauchy–Schwarz would bound trap frequency and give (H).
- Game: no 2-adic structure found in the win/loss labels.

## Code
Original scripts not preserved for items 1–8. Later-session scripts are in this folder: `tv.c` (exhaustive total-variation scan), `d.py` / `d4.py` (coalescence and trap-exit tests), `blk.py` / `adv.py` / `scan.py` (block-drift checks).

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313

## Added 2026-11-25 (second session): drift check
- **[Computed]** Block drift E[ln X_T] − ln n with T = ⌈1.2·ln n⌉, computed exactly over all coin paths (`blk.py`, `adv.py`, `scan.py`):
  - over every pure trap 2^k ± 1, k = 12..60, the worst value is −0.205 (at 2^30 + 1);
  - over 160 random trap starts 2^D·u ± 1 (D = 8..32, 20-bit u), the worst is −2.72;
  - over 24 hill-climbing searches (300 single-bit flips each) for the worst u, the worst is −0.996, at 2^24 − 1.
- **[Computed]** With T = ⌈1.5·ln n⌉, the worst over 2^k ± 1, k = 12..60, is −1.52.
- So the block-drift hypothesis in the reduction above holds numerically, with margin, for K = 1.5 on every start tested. This is sampled and adversarial-search evidence, not a proof.
