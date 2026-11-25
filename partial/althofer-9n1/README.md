# Althöfer 9n+1 prize ("9n+1 from 1") — partial results

**Problem** ([althofer.de/collatz-prizes.html](https://althofer.de/collatz-prizes.html), Prize 2). Start at 1. Repeatedly apply n ↦ odd(9n + 1), where odd(m) is m with all factors of 2 removed: 1 → 5 → 23 → 13 → 59 → 133 → 599 → 337 → … Prove that this sequence tends to infinity. **Prize:** 50 EUR, deadline 2037-12-31. A proof would also settle Prize 1 (25 EUR: some odd X ≥ 5 and some start whose odd(Xn + 1) orbit diverges).

**Status of the problem** (as of 2026-11-25): open. The closest proved single-orbit divergence is Althöfer–Zipproth (2025) for ⌊√2·n⌋ + 4, which rests on (√2)² = 2; no analogue exists for 9n+1.

## Results here

**1. [Reduction] Divergence ⇔ no repeat.** The orbit of 1 tends to infinity iff it never repeats a value. Proof: if it repeats, it is eventually periodic and bounded. If it never repeats, each of the finitely many positive integers below any bound B occurs at most once, so all but finitely many terms exceed B. Checked by hand.

**2. [Proved] Three "fake worlds" where the analogue fails** (each shows something a proof must use; one-line checks, by hand):
- Negative integers: odd(9·(−1) + 1) = odd(−8) = −1, a loop. So positivity must be used.
- 2-adic integers: x = −1/7 gives 9x + 1 = −2/7, odd part −1/7, a fixed point. So 2-adic information alone is not enough.
- Carry-free arithmetic (F₂[x], 9 ↦ x³ + 1, 2 ↦ x): 1 ↦ (x³ + 1) + 1 = x³ ↦ 1 after removing x³. So the carries in "+1" must be controlled.

**3. [Computed] No small positive loop.** For every odd start n < 4·10^6, the orbit was followed for up to 300 steps, stopping early if it dropped below n. No orbit returned to its start. Hence no positive cycle has its minimum below 4·10^6 and length at most 300. Exhaustive over that range; Python, split over 2 cores.

**4. [Computed] The orbit of 1 for 200,000 steps.** Exact big-integer iteration. After 200,000 steps the value has about 235,000 bits, growing 1.1766 bits per step against log₂9 − 2 ≈ 1.1699 for a random model. The halving counts follow the geometric 1/2, 1/4, 1/8, … law closely (100,204 ones, 50,184 twos, 24,978 threes, …). The deepest later drop below any earlier term was about 19 bits.

**5. [Heuristic]** For a random walk with this drift to fall back from 235,000 bits has probability around 10^−53,000, so a disproof by computation is hopeless; only a proof can settle the prize.

## Routes tried and why they failed
- Althöfer–Zipproth carried residue (the √2 trick) — qualitative wall: needs 9^r to be a power of 2; impossible (9 and 2 are multiplicatively independent).
- Baker / linear forms in logarithms — bounds the minimum of a loop with k odd steps, but never prevents the orbit from entering one huge loop.
- Subspace theorem / S-unit equations — finiteness for a fixed number of terms; the loop equation has k terms with k unbounded.
- Furstenberg ×2×3, Host, Tao's "almost all" Collatz results — average over starting points; no single-orbit version.
- Undecidability (Conway, Kurtz–Simon) — does not decide a specific instance, and the prize does not accept it.
- Every quantitative dial (loops up to some size, dip bounds, runs of large halvings) stops short: the orbit can always enter a loop beyond the bound. Barrier type: pseudorandomness of one fixed orbit (Mahler 3/2 and normality class).
- Possible small result, not done: an explicit bound "no positive 9n+1 loop has fewer than K odd steps" via continued fractions of log₂9 (Simons–de Weger method for 3x+1). It would not win the prize.

## Code
Original scripts not preserved. Both computations are a few lines of Python: n = 9n + 1, then strip trailing zero bits (n >>= v₂(n)), with multiprocessing for the cycle search.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
