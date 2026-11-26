# Partial results

Partial results, reductions, verified computations and documented dead ends from an AI-assisted research program on open problems with cash prizes, mostly Erdős problems (erdosproblems.com). Complete solutions live in the numbered folders at the top level of this repository (for example 1139/, 1141/). Nothing here claims to solve the problem it is filed under.

Every item in every folder carries exactly one label:
- **[Proved]**: full argument given, plus how it was checked (by hand, by a fresh adversarial AI referee, or by brute force on small cases).
- **[Reduction]**: an exact equivalence or implication, with proof.
- **[Computed]**: exact range and method, and whether the search was exhaustive or sampled.
- **[Heuristic]** or **[Conjecture]**: evidence only.

Each folder also lists the routes that were tried and why they failed. They are recorded so nobody has to repeat them.

| Folder | Problem | Prize | Strongest item |
|---|---|---|---|
| 25 | Erdős #25 (log density after removing one residue class per modulus) | – | [Proved] Lemma 2 (residue-0 case at every finite x); counterexample family to two natural targets |
| 64 | Erdős #64 (cycle of length 2^k at min degree 3) | $1000 | [Reduction] conjecture ⇔ f(k) ≥ 2^(k+1) |
| 124 | Erdős #124 (BEGL conjecture) | – | [Computed] bases {3,4,5} satisfy k = 1, 2, 3 |
| 203 | Erdős #203 | – | [Computed] no covering with period ≤ 120,000 |
| 261 | Erdős #261 (sums of a/2^a) | – | [Reduction] continuum question for x = 1 ⇔ infinitely many zeros of e_{n+1} = \|2e_n − n\|; 17 zeros to 2.3×10^11; zeros forced into 6 residues mod 64 |
| 273 | Erdős #273 (coverings by moduli p−1) | – | [Reduction] parity reduction and 2-adic path reframing |
| 288 | Erdős #288 (harmonic sums of two intervals) | – | [Proved] no prime in (N/2, N]; [Computed] all endpoints ≤ 7000 |
| 317 | Erdős #317 part 2 | – | [Computed] n ≤ 10^6 |
| 366 | Erdős #366 (2-full n, 3-full n+1) | – (conjectures.io bounty target) | [Computed] none with n < 10^24; none of any size on 655 of 671 shape curves (b ≤ 100, K ≤ 3888) |
| 458 | Erdős #458 | – | [Computed] no counterexample below 2^64; [Proved] conditional theorem |
| 488 | Erdős #488 | – | [Proved] max A ≤ n < 4·min A |
| 634 | Erdős #634 (triangles cut into N congruent triangles) | $25 | [Computed] structure of the open cases |
| 647 | Erdős #647 | £25 | [Computed] no solution in (24, 10^10] |
| 684 | Erdős #684 | – | [Proved] exceptional-set bound |
| 699 | Erdős #699 | – | [Proved] j = n/2 case except i a prime ≥ 7 |
| 711 | Erdős #711(i) | ₹1000 | [Reduction] CRT/Hall form; [Computed] the natural length-5 path encoding grows like N^3 |
| 835 | Erdős #835 | – | [Proved] symmetry-matching lemma; 176 symmetry types at k = 16 |
| 850 | Erdős #850 | – | [Reduction] to rad((n−1)n(n+1)) ≥ n−1 |
| 985 | Erdős #985 | – | follows from the literature under GRH (not our theorem) |
| althofer-9n1 | Althöfer 9n+1 prize | €50 | [Computed] no positive cycle with minimum < 4·10^6 and length ≤ 300 |
| althofer-stochastic-collatz | Althöfer stochastic Collatz prize | €300 | [Reduction] prize ⇐ block-drift lemma; [Computed] the lemma holds with margin on every start tested |

AI use: Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
