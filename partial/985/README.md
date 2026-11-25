# Erdős Problem #985 — partial results

**Problem** ([erdosproblems.com/985](https://www.erdosproblems.com/985)). Is it true that for every odd prime p there is a prime q < p that is a primitive root mod p (its powers run through every nonzero residue mod p)? **Prize:** none known to us.
**Status of the problem** (as of 2026-11-25): listed as open. Unconditionally, the best bound for the least prime primitive root ĝ(p) is O(p^3.1) (Ha, 2015), far above p. Conditionally on GRH, McGown–Treviño–Trudgian (Funct. Approx. Comment. Math. 55(2), 2016; arXiv:1508.05182) prove ĝ(p) < √p − 2 for every p > 2791, building on the computation of Cohen–Oliveira e Silva–Trudgian for 2791 < p < 2.5·10¹⁵. The formal-conjectures statement `erdos_985` (p prime, p ≠ 2, some prime q < p of order p − 1) matches the problem.

## Results here
**Label: follows from the literature — not our theorem.** Nothing below is a new proof; it records that the existing pieces chain together, plus our own finite check.

1. **[Reduction]** *GRH ⇒ #985 (McGown–Treviño–Trudgian).* Under GRH, ĝ(p) < √p − 2 < p for all p > 2791. The analytic input is a lemma about non-principal Dirichlet characters mod p; the Dedekind zeta function is not used (read from the paper; rated Likely). So GRH for Dirichlet L-functions suffices.
2. **[Reduction]** *GRH input.* Alpöge's 2026 proof of GRH for Dirichlet L-functions (formalised in Lean) supplies that hypothesis. At the time of our work its Lean statement reportedly matched, but its axioms had not been audited and no human review of the proof was recorded. #985 is settled exactly to the extent that proof holds.
3. **[Computed]** *Finite range p ≤ 3,000,000.* For every odd prime p ≤ 3·10⁶, the least prime q < p with q^((p−1)/r) ≢ 1 (mod p) for every prime r | p − 1 was found (Python/sympy, exhaustive over primes). Every such p has a prime primitive root below p. For p ≤ 2791 the largest least prime primitive root is 53, at p = 2791. For 2791 < p ≤ 3·10⁶ no p has ĝ(p) ≥ √p − 2, consistent with the published threshold (a cross-check only, far short of 2.5·10¹⁵).
4. **[Reduction]** Combining 1–3: if Alpöge's GRH holds, every odd prime has a prime primitive root below it.

## Routes tried and why they failed
- Unconditional proof — qualitative wall: primitive roots are not closed under multiplication (unlike the least quadratic non-residue, which is automatically prime), and finding a prime below the modulus in a union of residue classes needs zero-density input of roughly Linnik-exponent-below-1 strength — the GRH-strength input this chain uses.
- A new proof route was not attempted: any solved-analogue or supplier search would rebuild the existing argument.

Weakest links, in order: (i) Alpöge's GRH (unaudited at the time); (ii) the inherited computation for 2791 < p < 2.5·10¹⁵ (refereed, but only cross-checked here to 3·10⁶). No adversarial agent was run, since nothing here is our construction. A fully machine-checked chain (Lean GRH → formalised MTT with explicit Bach bounds, sieve and certified computation → finite check) is a possible future project, not done.

## Code
Original scripts not preserved.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
