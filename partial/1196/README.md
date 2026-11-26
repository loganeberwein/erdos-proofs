# Erdős Problem #1196: blind control run

**Problem** ([erdosproblems.com/1196](https://www.erdosproblems.com/1196)). Let A ⊂ [x, ∞) be a primitive set of integers (no element divides another). Is Σ_{a∈A} 1/(a log a) < 1 + o(1) as x → ∞?

**Why this folder exists.** This is the control problem of a 10-problem benchmark of the shrink-to-kernel method. The problem was solved in 2026, so it is not a bounty target. The run below used only the problem statement; the known solution was read only after the blind section was written. The comparison is at the end. Caveat: we knew the problem had been solved and by whom, but not how.

## Blind run (written before reading the solution)

1. **[Certain] Erdős's cone argument loses exactly a factor e^γ.** For a ∈ A let S_a be the set of n = a·m where every prime of m is ≥ P(a), the largest prime of a. In other words, n has a as a prefix when its primes are listed in increasing order. The prefixes of a fixed n form a divisor chain, so for primitive A the sets S_a are disjoint. The density of S_a is (1/a)∏_{p<P(a)}(1 − 1/p) ≈ e^{−γ}/(a log P(a)) ≥ e^{−γ}/(a log a). Summing gives Σ 1/(a log a) ≤ e^γ ≈ 1.78. Two losses: the Mertens constant, and log P(a) against log a for smooth a.
2. **[Reduction] Kernel as a random divisor chain.**
   - Suppose a random increasing divisor chain of integers (a random process that multiplies by primes) visits each n ≥ x with probability h(n) ≥ (1 − o(1))/(n log n). Then the theorem follows: a chain meets a primitive set at most once, so Σ_{a∈A} h(a) ≤ 1. [Certain]
   - [Likely] The converse also holds. By fractional Dilworth / LP duality on finite truncations, the best primitive-set bound equals the best such chain measure. So the kernel is essentially equivalent to the problem, in a constructive form.
3. **[Computed] The natural chain fails exactly on smooth states.**
   - The prefix chain multiplies by primes in nondecreasing order. Hitting probabilities h(n) = 1/(n log n) force the transition probabilities q(m, p) = log m/(p log(mp)) for p ≥ P(m).
   - These are sub-stochastic at m iff Σ_{p≥P(m)} q(m, p) ≤ 1. That sum is ≈ log(1 + log m/log P(m)), which is ≤ 1 iff log P(m)/log m ≥ 1/(e − 1) ≈ 0.582.
   - Numerical check (`prefix1196.py`, primes to 10^7 plus a Mertens tail): sums 0.93 at ratio 0.61, 1.09–1.10 at ratio 0.50, 1.57 at 0.25 and 3.63 at 0.025, matching the prediction.
4. **Kernel card (blind).**
   - *Kernel:* a random increasing divisor chain whose probability of visiting n is at least (1 − o(1))/(n log n) for every n ≥ x, including smooth n.
   - *Missing primitive:* a way to route mass into smooth numbers (log P(n)/log n < 0.582) without overspending at the states that feed them. The prefix order spends mass greedily on large primes. A chain that may insert small primes late, or that averages over orderings, is the natural candidate.
   - *Dial:* the smallest smoothness ratio at which the chain is still sub-stochastic. The prefix chain reaches 0.582; the theorem needs ratio 0, uniformly in the limit x → ∞.
   - *Expected hard part:* [Guessing] the smooth numbers, and the interaction between scales.

## Comparison with the known solution

Written after the blind section, from the problem page, Tao's blog announcement and the arXiv paper (Alexeev, Barreto, Li, Lichtman, Price, Shah, Tang, Tao, *Primitive sets and von Mangoldt chains: Erdős Problem #1196 and beyond*, arXiv:2605.00301, May 2026).

- **Known solution.** GPT-5.4 Pro, prompted by Liam Price (April 2026), proved the bound 1 + O(1/log x); it has been verified in Lean. The proof uses a Markov chain on the integers in which each step divides the current number by a prime power q with von Mangoldt weight Λ(q). This "downwards von Mangoldt chain" avoids the e^γ loss of the earlier "downwards Mertens chain" arguments. The identity Σ_{d|n} Λ(d) = log n makes the outflow at n exactly 1/(n log n), and Mertens' theorem controls the inflow.
- **Did the blind kernel match the expert hard part?** Yes, closely.
  - [Certain] Blind item 2's object (a random divisor chain whose visit probabilities are at least 1/(n log n), with primitivity giving disjointness) is the object the proof uses.
  - [Certain] Blind item 3's prefix chain, which multiplies primes in increasing order, is in effect the Mertens chain of the earlier literature. Blind item 1 identified its e^γ loss.
  - [Certain] The blind missing primitive was to route mass without respecting the order of primes, so that smooth numbers are not starved. That is exactly what the von Mangoldt weights do: any prime-power factor can be removed, weighted by Λ(q), and the divisor-sum identity balances the books.
- **What the blind run did not find.** The supplier itself. It named "insert small primes late, or average over orderings" as the candidate, but did not reach von Mangoldt weights, the identity Σ_{d|n} Λ(d) = log n, or the choice of a downward rather than upward chain. Per the method, that step is left to people (here it came from GPT-5.4 Pro, organized by Lichtman and Tao).
- **Verdict for the benchmark.** [Likely] On a problem whose answer is known, shrink-to-kernel located the correct object, the correct failure of the classical construction, and the exact property the missing idea had to supply. The gap between kernel and proof was one supplier choice. This is the strongest evidence in the benchmark that the kernels it outputs point at the real hard step.

## Code
- `prefix1196.py` (item 3). Log: `prefix1196.log`.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
