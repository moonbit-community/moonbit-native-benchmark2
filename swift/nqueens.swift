indirect enum List<T> {
  case Nil
  case Cons(T,List<T>)
}

func len<T>( _ xs : List<T> ) -> Int64 {
  var n : Int64 = 0;
  var cur : List<T> = xs
  while true {
    switch(cur) {
      case .Nil: return n
      case let .Cons(_,xx): do {
        n += 1
        cur = xx
      }
    }
  }
}

func safe( _ queen : Int64, _ xs : List<Int64> ) -> Bool {
  var cur : List<Int64> = xs
  var diag : Int64 = 1
  while true {
    switch(cur) {
      case .Nil: return true
      case let .Cons(q,xx): do {
        if (queen == q || queen == (q + diag) || queen == (q - diag)) {
          return false
        }
        diag += 1
        cur = xx
      }
    }
  }
}

// todo: use while?
func appendSafe( _ k : Int64, _ soln : List<Int64>, _ solns : List<List<Int64>> ) -> List<List<Int64>> {
  var acc = solns
  var n = k
  while(n > 0) {
    if (safe(n,soln)) {
      acc = .Cons(.Cons(n,soln),acc)
    }
    n -= 1;
  }
  return acc
}


func extend( _ n : Int64, _ solns : List<List<Int64>> ) -> List<List<Int64>> {
  var acc : List<List<Int64>> = .Nil
  var cur = solns
  while(true) {
    switch(cur) {
      case .Nil: return acc
      case let .Cons(soln,rest): do {
        acc = appendSafe(n,soln,acc)
        cur = rest
      }
    }
  }
}

func findSolutions(_ n : Int64 ) -> List<List<Int64>> {
  var k = 0
  var acc : List<List<Int64>> = .Cons(.Nil,.Nil)
  while( k < n ) {
    acc = extend(n,acc)
    k += 1
  }
  return acc
}

func nqueens(_ n : Int64) -> Int64 {
  return len(findSolutions(n))
}

print(nqueens(13))
