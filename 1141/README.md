# Erdős Problem #1141: 1722 is the largest

**Problem** ([erdosproblems.com/1141](https://www.erdosproblems.com/1141), OEIS [A214583](https://oeis.org/A214583)). Call $n$ *good* if $n-k^2$ is prime for every $k$ with $k^2<n$ and $\gcd(k,n)=1$. Erdős asked whether a specific number is the largest good $n$; the number he named (968) is wrong, and the known good numbers end at 1722. Alexeev–Putterman–Sawhney–Sellke–Valiant (arXiv:2604.06609) proved there are only finitely many, but their argument is ineffective (it goes through Siegel's theorem).

**Result.** Assuming GRH for Dirichlet L-functions (now proved by Alpöge, 2026), the good $n \ge 2$ are exactly the 41 terms of A214583, so **1722 is the largest**.

**Proof in plain terms.**
1. Every good $n>4$ is even and not a perfect square (look at $k=1$).
2. For such $n$, GRH gives a small prime $p$, at most about $4(\log 4n)^2$, with $p\nmid n$ and $n$ a square mod $p$. This uses the explicit bounds of Lippmann–McGown.
3. Then $p$ divides $n-k^2$ for two residue classes of $k$ mod $p$. A sieve count shows at least two such $k<\sqrt n$ coprime to $n$ whenever $n\ge1.165\cdot10^{12}$. At most one of them can give $n-k^2=p$, so some $n-k^2$ is composite and $n$ is not good.
4. A computer search of every $n<1.18\cdot10^{12}$ finds only the 41 known terms.

**Status.** Written proof: `paper/erdos1141.pdf`. Not machine-checked in Lean. The numerical parts (step 3 for $1.165\cdot10^{12}\le n\le10^{20050}$, and step 4) are computer verifications; the code and logs are in `code/`.

**Files** (`code/`)
- `s.c`: exhaustive search. Build with `gcc -O3 -o s s.c`, run with `./s LO HI`.
- `lemA2.py`, `final2.py`: interval verification of Lemmas A and B. They import `n0.py` and `final.py`; run `python3 final2.py`.
- `tail.py`: sanity check of the tail inequalities ($n\ge10^{20050}$).
- `search_logs.txt`: search output for $[2,1.18\cdot10^{12})$, with no gaps.

**AI use.** Claude (Anthropic) was used as a tool to write the code, run the computations, and act as an adversarial referee in two independent review passes. The findings of those passes were fixed and are listed in the paper. Claude is not an author.

**Credits.** APSSV for finiteness; Pollack for the input they used; Alpöge for GRH; Lippmann–McGown, Bennett–Martin–O'Bryant–Rechnitzer, Robin, and Rosser–Schoenfeld for the explicit estimates.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
