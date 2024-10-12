#!/bin/sh

set -e

alias gtime="/usr/bin/env time -f '%e %M'"
all_bench="rbtree rbtree_ck deriv nqueens cfold"

build_ocaml() {
  cd ocaml
  for bench in $all_bench; do
    ocamlopt.opt -O2 $bench.ml -o $bench.exe
  done
  cd ..
}

build_moonbit() {
  cd moonbit
  moon build --target native --release
  moon build --target wasm-gc --release
  moon build --target wasm --release
  cd ..
}

build_java() {
  cd java
  for bench in $all_bench; do
    javac -d bin $bench.java
  done
  cd ..
}

build_swift() {
  cd swift
  for bench in $all_bench; do
    swiftc -O -whole-module-optimization -o $bench.exe $bench.swift
  done
  cd ..
}

build() {
  echo "building MoonBit benchmarks..."
  build_moonbit
  echo "building OCaml benchmarks..."
  build_ocaml
  echo "building Java benchmarks..."
  build_java
  echo "building Swift benchmarks..."
  build_swift
}

run() {
  bench=$1

  echo -n 'native     : '
  gtime ./moonbit/target/native/release/build/$bench/$bench.exe 1>mbt.out
  if [ "$bench" != "cfold" ]; then
    echo -n 'wasm-gc(v8): '
    gtime moonrun ./moonbit/target/wasm-gc/release/build/$bench/$bench.wasm 1>wasm-gc.out
    if [ "$bench" != "rbtree_ck" ]; then
      echo -n 'wasm1(v8)  : '
      gtime moonrun ./moonbit/target/wasm/release/build/$bench/$bench.wasm 1>wasm1.out
    fi
  fi
  echo -n 'OCaml      : '
  gtime ./ocaml/$bench.exe 1>ocaml.out
  java_flag=""
  if [ "$bench" = "cfold" ]; then
    java_flag="-Xss128M"
  fi
  echo -n "java       : "
  gtime java --class-path java/bin $java_flag $bench 1>java.out
  # echo -n "graal      : "
  # gtime ./$1.java.exe 1>graal.out
  echo -n "swift      : "
  gtime ./swift/$bench.exe 1>swift.out
  diff --color ocaml.out mbt.out
  if [ "$bench" != "cfold" ]; then
    diff --color ocaml.out wasm-gc.out
    if [ "$bench" != "rbtree_ck" ]; then
      diff --color ocaml.out wasm1.out
    fi
  fi
  diff --color ocaml.out java.out
  diff --color ocaml.out swift.out
}

build
if [ "$1" = all -o "$1" = "" ]; then
  for bench in $all_bench; do
    echo "==== $bench ===="
    run $bench
  done
else
  run $1
fi
