# Open problems

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24241058.svg)](https://doi.org/10.5281/zenodo.24241058)

Proofs, partial results, verified computations and documented dead ends on open
mathematical problems, mostly Erdős problems ([erdosproblems.com](https://www.erdosproblems.com))
and other problems with cash prizes. Complete solutions live in numbered top-level
folders, named by the problem's number on erdosproblems.com. Everything short of a
solution lives in [`partial/`](partial/), where every item carries exactly one label:
[Proved], [Reduction], [Computed], or [Heuristic]/[Conjecture]. The routes that failed are
recorded too, so nobody has to repeat them.

**Author:** Logan Eberwein, Independent Researcher, ORCID
[0009-0004-5650-9313](https://orcid.org/0009-0004-5650-9313)

## Solutions

| Problem | Status | Paper | Lean |
|---|---|---|---|
| [#1139](https://www.erdosproblems.com/1139) | Proof posted; complete Lean proof of the formal-conjectures statement (release [1139-v2.0](https://github.com/loganeberwein/open-problems/releases/tag/1139-v2.0)) | [`1139/paper/`](1139/paper/) | [`1139/lean/`](1139/lean/) |
| [#1141](https://www.erdosproblems.com/1141) | 1722 is the largest good number, assuming GRH for Dirichlet L-functions (proved by Alpöge, 2026); not machine-checked | [`1141/paper/`](1141/paper/) | none |

## Partial results

See [`partial/README.md`](partial/README.md) for the index: 20 problems so far, including
the Althöfer Collatz-variant prizes. Nothing in `partial/` claims to solve the problem it
is filed under.

## AI use

AI tools (Claude, ChatGPT, Claude Code) are used as tools, not authors. Each folder
states exactly how they were used for that problem, and credits prior human and
AI-assisted work.

## Layout

```
NNNN/
  README.md   statement, links, proof summary, verification status, AI use, credits
  paper/      written proof (PDF)
  lean/       standalone Lake project, if any (its own lean-toolchain and manifest)
partial/NNNN/
  README.md   labelled results, failed routes, code description
  code and logs
```

## License

Apache-2.0 (see [LICENSE](LICENSE)). Some folders contain modified third-party code;
see [NOTICE](NOTICE).
