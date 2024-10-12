# MoonBit native benchmark

You must have the following dependencies installed:

- MoonBit
- `ocaml`, `javac` & `java`, `swiftc`
- GNU time or compatible alternative

To build and execute the benchmarks, just run (in repo root directory):

```bash
ulimit -s unlimited # make stack size unlimited to prevent overflow
./run.sh
```

you can run a specific benchmark with:

```bash
./run.sh <benchmark-source-file-name-without-ext>
```

The benchmarks are ported from <https://github.com/koka-lang/koka/tree/dev/test/bench>.
