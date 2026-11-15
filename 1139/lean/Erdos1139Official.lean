/-
Copyright 2026 The Formal Conjectures Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-/
-- Copied from google-deepmind/formal-conjectures,
-- `FormalConjectures/ErdosProblems/1139.lean` at commit
-- 7db2ea3b91bfbd0ab620215163e6c488bbb916d5. Adaptations, and nothing else:
-- * `module` / `public import FormalConjecturesUtil` / `@[expose] public section` replaced by
--   `import Erdos1139Sketch` (this project does not use the module system or that library);
-- * the attribute `@[category research open, question, AMS 11]` removed, because it is defined
--   in `FormalConjecturesUtil`; it is a documentation tag with no logical content;
-- * the upstream placeholder proof replaced by `exact Erdos1139Sketch.erdos_1139`.
-- The statement itself is unchanged, character for character.
import Erdos1139Sketch
/-!
# Erdős Problem 1139

*Reference:* [erdosproblems.com/1139](https://www.erdosproblems.com/1139)
-/

open Nat Filter
open scoped ArithmeticFunction.Omega
open scoped Topology

namespace Erdos1139

/--
Let $1\leq u_1 < u_2 < \cdots$ be the sequence of integers with at most $2$ prime factors.
Is it true that $$\limsup_{k \to \infty} \frac{u_{k+1}-u_k}{\log k}=\infty?$$
-/
theorem erdos_1139 :
    letI u := Nat.nth (fun n ↦ 0 < n ∧ Ω n ≤ 2)
    atTop.limsup (fun k : ℕ ↦ (((u (k + 1) : ℝ) - (u k : ℝ)) / Real.log (↑k + 1) : EReal)) = ⊤ := by
  exact Erdos1139Sketch.erdos_1139

end Erdos1139

#print axioms Erdos1139.erdos_1139
