# Erdős Problem #64 — partial results

**Problem** ([erdosproblems.com/64](https://www.erdosproblems.com/64), Erdős–Gyárfás). If every vertex of a finite graph has degree at least 3, must the graph contain a cycle whose length is a power of 2 (4, 8, 16, 32, …)? **Prize:** $1000.

**Status of the problem** (as of 2026-11-25): open. Known results (literature, not ours):
- Liu and Montgomery: true when the minimum degree exceeds some (large) absolute constant.
- Every graph with minimum degree ≥ 3 on at most 23 vertices has a 4-cycle or an 8-cycle; any cubic counterexample has at least 30 vertices. Markström-type cubic graphs on 24 vertices avoid both 4- and 8-cycles.
- Special classes settled: e.g. diameter 2, no long induced paths, planar 3-connected cubic graphs, and (2026) every Cayley graph of odd order; at least 4/7 of the vertices of a minimal counterexample have degree exactly 3.
- With f(k) as below: f(3) = 24, f(4) ≤ 78, f(5) ≤ 450, f(6) ≤ 32,640, and in general f(k) ≤ 15 × (order of the smallest known cubic graph of girth 2^(k−2) + 1) (arXiv 2609.04686).

## Results here

**1. [Reduction] Threshold reformulation.** Let f(k) be the fewest vertices of a graph with minimum degree ≥ 3 and no cycle of length 4, 8, …, 2^k. Then the conjecture holds iff f(k) ≥ 2^(k+1) for every k ≥ 2.
Proof. (⇐ by contrapositive) A counterexample G on n vertices, with 2^k ≤ n < 2^(k+1), has no cycle of length 4, …, 2^k, so f(k) ≤ n < 2^(k+1). (⇒ by contrapositive) A graph with minimum degree ≥ 3 avoiding 4, …, 2^k on fewer than 2^(k+1) vertices cannot contain a cycle of length 2^(k+1) or more, so it avoids every power of 2 and is a counterexample. Checked by hand in-session; no independent referee.
Against the known bounds above, the budgets 16, 32, 64, 128 are far below 24, 78, 450, 32,640; the general bound grows doubly exponentially while the budget doubles, so a counterexample (if any) is not a "large girth plus gadgets" object.

**2. [Computed] Adversarial search in the window 28–31 vertices (sampled, not exhaustive).** Simulated annealing over graphs with a fixed degree sequence, using edge-switch moves, minimizing a weighted count of 4-, 8- and 16-cycles (exact cycle counts by DFS). Under 32 vertices, a graph with no 4-, 8- or 16-cycle would be a counterexample.
- Validation: at 24 vertices (cubic) the search rediscovered graphs with no 4- or 8-cycle in 3 of 7 restarts, matching Markström. (An earlier weighting that over-penalized 16-cycles failed this test and was corrected.)
- Results, lowest number of 16-cycles left after all 4- and 8-cycles were removed:

| Vertices | Degree sequence | Restarts | Fewest 16-cycles |
|---|---|---|---|
| 28 | cubic | 3 | 208 |
| 30 | cubic | 5 | 210 |
| 31 | one degree-4 vertex, rest cubic | 3 | 322 |

- Coverage: 11 random-start runs in total; graphs with several degree-4 vertices (or higher degrees) were not tried. No counterexample found. The best states are about 200 sixteen-cycles away from a counterexample, which suggests this window is empty, but this is evidence only.

**3. [Heuristic]** The doubly exponential gap between f(k) constructions and the 2^(k+1) budget is the strongest evidence that the conjecture is true.

## Routes tried and why they failed
- Liu–Montgomery expansion plus "adjusters" (places where a path can be lengthened by 2) — qualitative wall: cubic graphs can be tree-like, with no expansion and too few adjusters.
- Local-density arguments (diameter 2, induced paths, planar cases) — counterexample to the method: Markström-type graphs avoid 4 and 8.
- Symmetry (odd-order Cayley graphs) — general graphs have no symmetry.
- Missing piece identified, not supplied: one cycle carrying about a/2 independent "lengthen by 2" spots, so its lengths cover every even number in [a, 2a] (which contains a power of 2). The best known degree-3 statement is far weaker (two cycle lengths differing by 1 or 2).
- Candidate suppliers named but not costed or tested: 2-vertex-cut decompositions with sumset bounds on cycle lengths; an expander/Liu–Montgomery argument for graphs with no small cuts.

## Code
Original scripts not preserved. The search was a single C program: random graph with the given degree sequence by stub matching, simulated annealing with double-edge switches, energy W4·c4 + W8·c8 + c16 with exact DFS cycle counts (working weights W4 = 100000, W8 = 5000).

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
