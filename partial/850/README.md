# Erdős Problem #850 — partial results

**Problem** ([erdosproblems.com/850](https://www.erdosproblems.com/850), the Erdős–Woods conjecture). Can there be two distinct integers x, y such that x and y have the same prime factors, x+1 and y+1 have the same prime factors, and x+2 and y+2 have the same prime factors? **Prize:** none listed.
**Status of the problem** (as of 2026-11-25): open; not resolvable by a finite computation. For two steps (x, x+1) the family x = 2(2^r − 1), y = x(x+2) works, as does Makowski's x = 75, y = 1215 (also found by Bolan and by Dubickas); no other two-step examples are known (OEIS A343101). Shorey–Tijdeman: a strong form of ABC due to Baker implies the answer for three steps is no.

Notation: rad(N) = product of the distinct primes dividing N.

Note on sources: this write-up is drawn from a summary record of the work; the original derivations were not available when it was compiled. The proofs below are short and were re-checked by hand while writing.

## Results here
1. **[Reduction]** *Key reduction.* If x < y is a solution, every prime dividing x, x+1 or x+2 divides y − x (it divides both x+i and y+i). So rad(x(x+1)(x+2)) divides y − x, and since the prime sets agree, rad(y(y+1)(y+2)) = rad(x(x+1)(x+2)) ≤ y − x < y. With n = y + 1 this says rad((n−1)n(n+1)) < n − 1. Hence #850 (answer "no") follows from: **for every n ≥ 2, rad((n−1)n(n+1)) ≥ n − 1.**
2. **[Proved]** *Special cases of that inequality.* It holds whenever one of n−1, n, n+1 is squarefree (its radical is the number itself, ≥ n − 1), and for odd n whenever (n−1)/2 or (n+1)/2 is squarefree (say s = (n−1)/2: if s is odd then n − 1 = 2s is squarefree; if s is even then rad(n−1) = s, and the odd n ≥ 3, coprime to n ± 1, contributes a further factor ≥ 3, so the radical is ≥ 3(n−1)/2; the same for (n+1)/2). Checked by hand.
3. **[Proved]** *Why two steps work and three fail for the known family.* For x = 2(2^r − 1), y = x(x+2): x + 2 = 2^{r+1}, so y = 2^{r+2}(2^r − 1) has the primes of x; y + 1 = (x+1)², with the primes of x+1. This works because 2 is both a shift and a prime. The third step would need y + 2 = (x+1)² + 1 to have the prime set {2}, i.e. be a power of 2; but x + 1 is odd, so (x+1)² + 1 ≡ 2 (mod 4) and exceeds 2. The polynomial analogue is impossible even for two steps (Mason–Stothers).
4. **[Computed]** *Numerics.* rad((n−1)n(n+1)) ≥ n − 1 for every n ≤ 2·10^7 (exhaustive); the ratio rad((n−1)n(n+1))/(n−1) is never below about 4.4, attained at n = 49 (rad(48·49·50) = 210 = 4.375·48).

## Routes tried and why they failed
- Unconditional proof of item 1's inequality — qualitative wall: it is a quality-2 case of abc (three consecutive integers all made of high prime powers). The best unconditional radical bound (Stewart–Yu) gives only about (log n)^3.
- AI-generated "full proofs" of the inequality — failed verification: confident proofs resting on fabricated citations, repeatedly. Test for any claimed proof: plug in 1024, 3^7 or 2·3^20 wherever it bounds a radical.

## Code
Original scripts not preserved.

## AI use
Claude (Anthropic) was used as a tool for the mathematics, computation and adversarial review; it is not an author.

Author: Logan Eberwein, Independent Researcher, ORCID 0009-0004-5650-9313
