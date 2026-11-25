# Erdős Problem #261 — partial results

**Problem** ([erdosproblems.com/261](https://www.erdosproblems.com/261)). For a set A of positive integers write f(A) = Σ_{a∈A} a/2^a. The page does not label sub-questions; we number them as follows. (i) Are there infinitely many n such that n/2^n is a sum of at least 2 distinct terms a/2^a? (ii) Does this hold for *every* n? (iii) Is there a rational x such that x = f(A) for at least continuum (2^ℵ0) many infinite sets A? **Prize:** none listed.

**Status of the problem** (as of 2026-11-25): (i) is solved by Borwein and Loring, via the identity n/2^n = Σ_{n<k≤n+m} k/2^k for n = 2^(m+1) − m − 2. (ii) is open, checked for n ≤ 10,000. (iii) is open; the closest result we found is Tengely–Ulas–Zygadło (2020): infinitely many rationals have at least nine representations (computational construction starting from 1/32).

**All results below concern part (iii).** (The working session was first titled "261(ii)"; it attacked the continuum question, which is (iii) in the numbering above.) Part (ii) was not attacked.

## Results here

**1. [Reduction] Dyadic x reduce to an integer recurrence.** Proof sketch. Decide n = 1, 2, 3, … in order (ε_n = 1 iff n ∈ A). Let r_n be what is left of x before deciding n (r_1 = x), w_n = n/2^n and τ_n = Σ_{k≥n} w_k = (n+1)/2^(n−1).
- Since w_n ≤ τ_{n+1} for every n, a prefix extends to a set with sum exactly x iff 0 ≤ r_n ≤ τ_n at every step.
- Put d_n = 2^n r_n − (n+1), so |d_n| ≤ n+1. Then d_{n+1} = 2d_n + n(1 − 2ε_n); ε_n = 0 is allowed iff d_n ≤ 1, and ε_n = 1 is allowed iff d_n ≥ −1.
- |d_n| = n+1 means r_n = 0 (all later ε = 0: finite set) or r_n = τ_n (all later ε = 1: cofinite set). Call these states absorbed.
- If x is dyadic, then for n ≥ some n1, 2^n x is an even integer, so each d_n is an integer with d_n ≡ n+1 (mod 2). The non-absorbed states then follow e_{n+1} = |2e_n − n| with e_n = |d_n|. A genuine fork (both children non-absorbed, mirror images d ↦ −d) happens exactly when e_n = 0 (n odd). When e_n = 1 (n even) one child is absorbed and the other continues with e_{n+1} = n − 2. Every other step is forced.
- Consequence: a dyadic x has continuum many infinite representations iff some trunk of states has e_n = 0 infinitely often; otherwise it has countably many.
- **For x = 1:** d_1 = 0 and there is exactly one trunk. So x = 1 has continuum many representations iff the sequence e_1 = 0, e_{n+1} = |2e_n − n| has infinitely many zeros.
- Checks: every valid prefix for x = 1 was enumerated exactly (rational arithmetic) up to n = 90 and matched the recurrence; 300 random dyadic x in (0, 2) with denominator ≤ 2^8 were checked up to n = 70 with no failure. A fresh adversarial referee agent re-derived every step and brute-forced 8 values of x up to n = 60 and all k/2^j with j ≤ 6 up to n = 45: no counterexample. Its one correction is built in above: for general dyadic x there can be several trunks (13/16 starts with two), hence "some trunk".
- Sanity check: the Borwein–Loring identity is the special case where a zero at 2^(m+1) − m − 2 is followed by the next zero at 2^(m+1) − 1.

**2. [Computed] Zeros of e_n for x = 1.** Exhaustive direct iteration of e_{n+1} = |2e_n − n| (64-bit C) for all n up to about 2.1 × 10^11 (run stopped there). Exactly 17 zeros:
1, 3, 79, 235, 431, 1503, 2943, 6059, 6619, 18911, 54223, 302467995, 1772665631, 2148845167, 5145362667, 129465909327, 212089391807.

**3. [Proved] Corollary.** x = 1 has at least 2^17 = 131,072 representations x = f(A) with A infinite and not cofinite (plus countably many cofinite ones). Proof: each of the 17 zeros is a fork into two non-absorbed mirror branches, and a non-absorbed branch never becomes finite or cofinite. This is far short of continuum but exceeds the nine representations of Tengely–Ulas–Zygadło (literature check limited to that paper and the problem page).

**4. [Computed] Trunks appear to merge (sampled).** 2000 random starting states (start times up to 10^6, random admissible e) all merged with the x = 1 trunk by n = 2 × 10^8. Not a proof; if it holds in general, the dyadic case of (iii) is one yes/no question about one sequence.

**5. [Heuristic] Probably yes.** A random model gives probability about 1/n of a zero at step n; Σ 1/n diverges, predicting infinitely many zeros. It predicts about 26 zeros by 2 × 10^11 against 17 observed; gaps are heavy-tailed (none between 54223 and 3 × 10^8).

## Routes tried and why they failed
- Explicit self-regenerating families of zero times — qualitative wall: Borwein–Loring starts give exactly one more zero, then chaos. Exact big-integer runs after zeros at 2^k − 1 (k = 15, 16, 31, 32, 63, 64, 127) lose structure after 2–3 folds, because staying structured needs every intermediate offset + 2 to be a power of 2 while offsets grow by about k per cycle. A scan of starts 2^a + c (a = 6..34, |c| ≤ 300) found no regenerating family.
- Ergodic/probabilistic arguments — give at best "almost every real x", never a specific rational.
- Odd-denominator x — branching trees instead of one trunk, but the same deterministic return problem on every trunk.
- Finitely many swaps — gives some rational with ≥ 2^K representations for each K; stops short of continuum.
- Cantor–Bendixson (uncountable iff a perfect subtree exists) — only restates "infinitely many zeros".

Missing piece: a proof that one specific chaotic integer sequence returns to 0 infinitely often (Collatz-type wall).

## Code
Original first-session scripts not preserved. Second-session scripts here: `z.c` (zero search; `gcc -O3 z.c -o z && ./z 230000000000`), `back.py` (backward-chain test), `back3.py` (residue exclusion check).

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313

## Added 2026-11-25 (second session)
- **[Computed]** Independent rerun (`z.c`, exact 64-bit arithmetic) of e₁ = 0, e_{n+1} = |2eₙ − n| up to n = 2.3×10¹¹: exactly 17 zeros, 1, 3, 79, 235, 431, 1503, 2943, 6059, 6619, 18911, 54223, 302467995, 1772665631, 2148845167, 5145362667, 129465909327, 212089391807 (`zeros.txt`). The fraction of n < 10⁹ where the absolute value folds (2eₙ < n) is 0.49999.
- **[Proved, finite case check]** A zero at a large n forces e_{n−1} = (n−1)/2, and each earlier term must satisfy e_{m−1} = ((m−1) ± e_m)/2 with an integer result. Whether such a backward chain of length L exists depends only on n mod 2^(L+3) once n is large. Checking all residues (`back3.py`, 400 lifts per residue class mod 64): chains die within 3 steps for n ≡ 3, 7 (mod 16) and within 5 steps for n ≡ 11, 59 (mod 64). So every zero n ≥ 64 lies in {15, 27, 31, 43, 47, 63} mod 64. All 16 known zeros above 3 do.
- **[Computed]** Of random n ≡ 3 (mod 4) near 10¹², the fraction with a backward chain of length L is 0.50, 0.30, 0.17, 0.094, 0.051, 0.030 at L = 4, 8, 16, 32, 64, 128 (3000 samples), decaying roughly like L^(−0.83).
- **[Heuristic]** eₙ/n follows a perturbed tent map, r ↦ (n/(n+1))·|2r − 1|, and a zero is an exact hit of r = 1/2. Proving infinitely many zeros is therefore a shrinking-target statement for one specific orbit, the same kind of barrier as normality of a specific number.
