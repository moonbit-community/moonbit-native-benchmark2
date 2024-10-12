typealias List[X] = @immut/list.T[X]

fn safe(queen : Int, diag : Int, xs : List[Int]) -> Bool {
  match xs {
    Nil => true
    Cons(q, qs) => queen != q && queen != q + diag && queen != q - diag && safe(queen, diag + 1, qs)
  }
}

fn append_safe(queen : Int, xs : List[Int], xss : List[List[Int]]) -> List[List[Int]] {
  if queen <= 0 {
    xss
  } else if safe(queen, 1, xs) {
    append_safe(queen - 1, xs, Cons(Cons(queen, xs), xss))
  } else {
    append_safe(queen - 1, xs, xss)
  }
}

fn extend(queen : Int, acc : List[List[Int]], xss : List[List[Int]]) -> List[List[Int]] {
  match xss {
    Nil => acc
    Cons(xs, rest) => extend(queen, append_safe(queen, xs, acc), rest)
  }
}

fn find_solutions(n : Int, queen : Int) -> List[List[Int]] {
  if queen == 0 {
    Cons(Nil, Nil)
  } else {
    extend(n, Nil, find_solutions(n, queen - 1))
  }
}

fn queens(n : Int) -> Int {
  find_solutions(n, n).length()
}

fn main {
  println(queens(13))
}
