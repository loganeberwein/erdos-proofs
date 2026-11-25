# Erdős Problem #203 — partial results

**Problem** ([erdosproblems.com/203](https://www.erdosproblems.com/203)). Is there an integer m ≥ 1 with gcd(m, 6) = 1 such that every number 2^k·3^l·m + 1 (k, l ≥ 0) is composite? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open; the page says it cannot be resolved by a finite computation and cites no partial results. Context: odd m with every 2^k·m + 1 composite are Sierpiński numbers (see #1113).

Note on sources: this write-up is drawn from a summary record of the work; the original derivations and the verification script were not available when it was compiled, so most items below give statements and sketches only.

## Results here
1. **[Reduction]** *Equivalent form.* m works exactly when m, 3m, 9m, 27m, … are all Sierpiński numbers. Proof: for fixed l, "2^k·(3^l m) + 1 composite for all k" is the statement that 3^l·m (odd) is Sierpiński; take all l. ∎
2. **[Reduction]** *Period reformulation.* A covering argument for m repeats with some period L in (k, l). A prime p > 3 is usable at period L exactly when 2^L ≡ 3^L ≡ 1 (mod p), so the usable primes are the prime factors of gcd(2^L − 1, 3^L − 1). That gcd is small and factors completely. **[Computed]** For L = 232,792,560 it has 4,697 bits and 322 prime factors.
3. **[Proved]** *Head-and-tail lemma.* Split the usable primes into a head and a tail. The uncovered fraction of the (k, l) grid is at least U − Σ_{tail p} u_p/h(p), where U is the head's uncovered fraction and u_p is the largest head-uncovered fraction in any coset of Λ_p + M. The symbols Λ_p, M and h(p) are defined in the original work, which is not preserved; the record gives only this statement, without definitions or proof.
4. **[Computed]** *No covering with small period (computer-assisted).* No covering exists with period L ≤ 120,000: every m leaves at least 10% of the grid uncovered. Also at L = 5040 (uncovered fraction ≥ 0.2281) and L = 720720 (≥ 0.1152), and all their divisors. Status in the sources: certain subject to re-running the verification script verify203.py, which is not preserved, so this item should be re-run before it is relied on.
5. **[Proved]** *Algebraic-factorization lemma.* As recorded: if m = c^q with q odd and p ≡ 1 (mod q), every prime p dividing 2^k·3^l·m + 1 forces 2^k·3^l to be a q-th power mod p, so algebraic factorization tricks add nothing beyond the grid cells they already cover. Proof not preserved here.

## Routes tried and why they failed
- Proving that no m exists — qualitative wall: it would need a prime in every family 2^k·3^l·m + 1, which is out of reach even for m = 1 (an Artin/primes-in-sparse-sequences type barrier).
- Coverings at bounded period (items 2–4) — cost wall: the usable primes at period L are the factors of gcd(2^L − 1, 3^L − 1), and the supply of primes with small h(p) on the 2–3 grid is too thin; every period checked leaves ≥ 10% uncovered. A theorem excluding coverings at every period would need a Balister–Bollobás–Morris–Sahasrabudhe–Tiba-type distortion argument adapted to the grid.
- Algebraic factorizations — no gain (item 5).
- What could settle it: an explicit construction of m.

## Code
Original scripts not preserved (the sources name verify203.py for item 4).

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
