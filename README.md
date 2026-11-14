# Erdős problem proofs

Proofs of problems from [erdosproblems.com](https://www.erdosproblems.com), with Lean 4
formalizations where available. Each problem lives in its own folder, named by its
number on erdosproblems.com (for example [`1139/`](1139/)). A folder holds a README with
the statement, a plain-language proof summary and the verification status; a `paper/`
folder for the written proof; and, where one exists, a self-contained Lean project in
`lean/`. A folder's status says exactly what is machine-checked and what is not.

**Author:** Logan Eberwein, Independent Researcher, ORCID
[0009-0004-5650-9313](https://orcid.org/0009-0004-5650-9313)

## Problems

| Problem | Status | Paper | Lean |
|---|---|---|---|
| [#1139](https://www.erdosproblems.com/1139) | Proof posted; Lean verification of the key input complete; full formalization in progress | [`1139/paper/`](1139/paper/) | [`1139/lean/`](1139/lean/) |

## AI use

AI tools (Claude, ChatGPT, Claude Code) are used as tools, not authors. Each problem
folder states exactly how they were used for that problem, and credits prior human and
AI-assisted work.

## Layout for new problems

```
NNNN/
  README.md      statement, links, proof summary, verification status, AI use, credits
  paper/         written proof (PDF)
  lean/          standalone Lake project, if any (its own lean-toolchain and manifest)
.github/workflows/lean-NNNN.yml   CI for that Lean project
```

## License

Apache-2.0 (see [LICENSE](LICENSE)). Some folders contain modified third-party code;
see [NOTICE](NOTICE).
