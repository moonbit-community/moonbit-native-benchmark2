enum Expr {
  Var(Int)
  Val(Int)
  Add(Expr, Expr)
  Mul(Expr, Expr)
}

fn dec(n : Int) -> Int {
  if n == 0 { 0 } else { n - 1 }
}

fn mk_expr(n : Int, v : Int) -> Expr {
  if n == 0 {
    if v == 0 {
      Var(1)
    } else {
      Val(v)
    }
  } else {
    Add(mk_expr(n - 1, v + 1), mk_expr(n - 1, dec(v)))
  }
}

fn Expr::append_add(e0 : Expr, e3 : Expr) -> Expr {
  match e0 {
    Add(e1, e2) => Add(e1, e2.append_add(e3))
    _ => Add(e0, e3)
  }
}

fn Expr::append_mul(e0 : Expr, e3 : Expr) -> Expr {
  match e0 {
    Mul(e1, e2) => Mul(e1, e2.append_mul(e3))
    _ => Mul(e0, e3)
  }
}

fn Expr::reassoc(e : Expr) -> Expr {
  match e {
    Add(e1, e2) => e1.reassoc().append_add(e2.reassoc())
    Mul(e1, e2) => e1.reassoc().append_mul(e2.reassoc())
    e => e
  }
}

fn Expr::const_folding(e : Expr) -> Expr {
  match e {
    Add(e1, e2) =>
      match (e1.const_folding(), e2.const_folding()) {
        (Val(a), Val(b)) => Val(a + b)
        (Val(a), Add(e, Val(b))) => Add(Val(a + b), e)
        (Val(a), Add(Val(b), e)) => Add(Val(a + b), e)
        (e1, e2) => Add(e1, e2)
      }
    Mul(e1, e2) =>
      match (e1.const_folding(), e2.const_folding()) {
        (Val(a), Val(b)) => Val(a * b)
        (Val(a), Mul(e, Val(b))) => Mul(Val(a * b), e)
        (Val(a), Mul(Val(b), e)) => Mul(Val(a * b), e)
        (e1, e2) => Mul(e1, e2)
      }
    e => e
  }
}

fn eval(self : Expr) -> Int {
  match self {
    Val(n) => n
    Var(_) => 0
    Add(e1, e2) => e1.eval() + e2.eval()
    Mul(e1, e2) => e1.eval() * e2.eval()
  }
}

fn main {
  let e = mk_expr(20, 1)
  let v1 = e.eval()
  let v2 = e.reassoc().const_folding().eval()
  println("\{v1} \{v2}")
}
