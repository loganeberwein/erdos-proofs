# Erdős Problem #1139

## Statement

Let $u_1 < u_2 < \cdots$ be the positive integers with at most two prime factors, counted
with multiplicity (that is, $\Omega(u_k) \le 2$). Is it true that

$$\limsup_{k\to\infty} \frac{u_{k+1}-u_k}{\log k} = \infty \;?$$

- Problem page: <https://www.erdosproblems.com/1139>
- Forum thread: <https://www.erdosproblems.com/forum/thread/1139>
- Formal statement (google-deepmind/formal-conjectures):
  <https://google-deepmind.github.io/formal-conjectures/FormalConjectures/ErdosProblems/1139.html>
- Key input, OpenAI, *Improved Long Gaps Between Primes*:
  <https://cdn.openai.com/pdf/51126fac-1b68-4128-9666-c908bcc16033/long_gaps.pdf>

## Proof summary (plain language)

Fix $C \ge 1$ and a large $x$. We build a run of about $3Cx$ consecutive integers, each
with at least three prime factors, located below roughly $e^{2x}$. That gives gaps of
size about $(3C/2)\log k$ in the sequence $u_k$, and since $C$ is arbitrary the limsup is
infinite.

1. **Erdős–Rankin construction.** For each prime $p \le x$ choose a residue $a_p$. Then
   pick $b$ by the Chinese remainder theorem with $b \equiv -a_p \pmod p$, so $p$
   divides $b + Qt + j$ whenever $j \equiv a_p \pmod p$, where $Q = \prod_{p \le x} p$.
2. **Small primes hit almost every position twice.** Residue $a_p = 0$ for the small and
   medium primes, a greedy choice for an intermediate range, and the primes in
   $(x/2, x]$ together make sure every position $j \in [1, H]$ is hit, and all but
   $o(x)$ positions are hit by at least two distinct primes.
3. **Two chosen prime factors give three.** If two distinct chosen primes $p, q \le x$
   divide $n = b + Qt + j$, then $pq \le x^2$, which is far smaller than $n$. So
   $n = pq \cdot m$ with $m \ge 2$, and $\Omega(n) \ge 3$.
4. **Positions hit only once.** The set $S_1$ of positions hit exactly once has size
   $o(x)$, so at most $\delta x$. A strengthened form of OpenAI's Proposition 1.2 then
   gives a $t$ such that every $b + Qt + s$, $s \in S_1$, has an extra prime factor
   $p > \lfloor x \rfloor$ with $p\lfloor x \rfloor < b + Qt + s$. Together with the
   small prime $q \le \lfloor x \rfloor$ that hits $s$, this gives two distinct primes
   whose product is below the number, so again $\Omega \ge 3$. **This strengthened
   proposition is verified in Lean in this folder.**

## Verification status

| Component | Status |
|---|---|
| Strengthened Proposition 1.2 (`short_translates_divisor`, `short_translates_divisor_with_sieveDelta`) | **Lean-verified** (axioms: `propext`, `Classical.choice`, `Quot.sound` only) |
| The case of positions hit exactly once (step 4) | Formalized in the sketch [`lean/Erdos1139Sketch.lean`](lean/Erdos1139Sketch.lean), modulo the sketch's other gaps |
| Lemmas 2 to 5 (covering, greedy step, double hits, upper-bound sieve) | Written proof in the paper; not yet formalized |
| Full Lean proof of `erdos_1139` | In progress, on branch `full-formalization-1139` |

> **The sketch is incomplete.** `Erdos1139Sketch.lean` compiles, but it contains `sorry`s.
> Each one is tagged `TODO(n)` with the gap it stands for. It is **not** a formal proof of
> Erdős Problem #1139. Only `LongGapsBetweenPrimes.lean` is sorry-free, and CI enforces that.

What was changed relative to OpenAI's repository, with the exact Lean statements and the
axiom output, is in [`lean/CHANGES.md`](lean/CHANGES.md). The diff is
[`short_translates_divisor.diff`](short_translates_divisor.diff).

## Building

Requires [elan](https://github.com/leanprover/elan). The toolchain (Lean v4.33.0) and
Mathlib revision are pinned by `lean/lean-toolchain` and `lean/lake-manifest.json`.

```sh
cd 1139/lean
lake exe cache get
lake build
```

A local build takes roughly 20 to 60 minutes after the Mathlib cache is downloaded. The
GitHub Actions workflow [`lean-1139.yml`](../.github/workflows/lean-1139.yml) runs the same
build on GitHub's runners and may take over an hour. It fails if `sorry`, `admit` or
`native_decide` appears in `LongGapsBetweenPrimes.lean`.

## AI assistance

- The argument was worked out with **Claude** (Anthropic).
- The estimates were reviewed with **ChatGPT** (OpenAI).
- **Claude Code** (Anthropic) built OpenAI's Lean project and extended it with the new
  theorems, and wrote the formalization sketch.
- The key input is OpenAI's Proposition 1.2 (*Short translates*) and its Lean
  formalization in [openai/LongGapsBetweenPrimes](https://github.com/openai/LongGapsBetweenPrimes).
  The paper's abstract says "The proof is due to GPT 6 Astra."

The author checked and takes responsibility for everything posted here. AI tools are not
authors.

## Prior work and credits

From the [forum thread](https://www.erdosproblems.com/forum/thread/1139):

- **Przemek Chojecki** ([28 Jan 2026](https://www.erdosproblems.com/forum/thread/1139#post-3873))
  reformulated the problem as a 2-fold covering problem: if residue classes with distinct
  primes cover every $j \in [1, n]$ at least twice, CRT gives an interval of integers with
  $\Omega \ge 3$. Earlier comments by Chojecki and **Terence Tao** connected the problem
  to Erdős–Rankin and Maynard / Ford–Green–Konyagin–Tao prime-gap methods and to
  Problem #689. **Woett** surveyed the literature.
- **gavinsherry** ([29 Apr 2026](https://www.erdosproblems.com/forum/thread/1139#post-6015))
  posted an AI-assisted covering-reduction note as a
  [GitHub Gist](https://gist.github.com/gavinsherry/59208407035b37acc83b4165305a88b5). It
  gives a threefold sparse-cover criterion and a twofold small-prime criterion.
- **Liam Price** ([19 Jun 2026](https://www.erdosproblems.com/forum/thread/1139#post-7063))
  posted a claimed solution produced with GPT Pro, using a different (Green–Tao based)
  hypergraph-covering argument. **Nat Sothanaphan** screened it and found no issues apart
  from a typo.
