enum Color {
  Red
  Black
}

enum Node {
  Leaf
  Node(Color, Node, Int, Bool, Node)
}

fn balance1(kv : Int, vv : Bool, t : Node, n : Node) -> Node {
  match n {
    Node(_, Node(Red, l, kx, vx, r1), ky, vy, r2) => Node(Red, Node(Black, l, kx, vx, r1), ky, vy, Node(Black, r2, kv, vv, t))
    Node(_, l1, ky, vy, Node(Red, l2, kx, vx, r)) => Node(Red, Node(Black, l1, ky, vy, l2), kx, vx, Node(Black, r, kv, vv, t))
    Node(_, l,  ky, vy, r)                        => Node(Black, Node(Red, l, ky, vy, r), kv, vv, t)
    _ => Leaf
  }
}

fn balance2(t : Node, kv : Int, vv : Bool, n : Node) -> Node {
  match n {
    Node(_, Node(Red, l, kx1, vx1, r1), ky, vy, r2)  => Node(Red, Node(Black, t, kv, vv, l), kx1, vx1, Node(Black, r1, ky, vy, r2))
    Node(_, l1, ky, vy, Node(Red, l2, kx2, vx2, r2)) => Node(Red, Node(Black, t, kv, vv, l1), ky, vy, Node(Black, l2, kx2, vx2, r2))
    Node(_, l, ky, vy, r)                            => Node(Black, t, kv, vv, Node(Red, l, ky, vy, r))
    _ => Leaf
  }
}

fn is_red(self : Node) -> Bool {
  match self {
    Node(Red, _, _, _, _) => true
    _ => false
  }
}

fn ins(self : Node, kx : Int, vx : Bool) -> Node {
  match self {
    Leaf => Node(Red, Leaf, kx, vx, Leaf)
    Node(Red, a, ky, vy, b) =>
      if kx < ky {
        Node(Red, a.ins(kx, vx), ky, vy, b)
      } else if ky == kx {
        Node(Red, a, kx, vx, b)
      } else {
        Node(Red, a, ky, vy, b.ins(kx, vx))
      }
    Node(Black, a, ky, vy, b) =>
      if kx < ky {
        if a.is_red() {
          balance1(ky, vy, b, a.ins(kx, vx))
        } else {
          Node(Black, a.ins(kx, vx), ky, vy, b)
        }
      } else if kx == ky {
        Node(Black, a, kx, vx, b)
      } else {
        if b.is_red() {
          balance2(a, ky, vy, b.ins(kx, vx))
        } else {
          Node(Black, a, ky, vy, b.ins(kx, vx))
        }
      }
  }
}

fn set_black(self : Node) -> Node {
  match self {
    Node(_, l, k, v, r) => Node(Black, l, k, v, r)
    e => e
  }
}

fn insert(self : Node, k : Int, v : Bool) -> Node {
  if self.is_red() {
    self.ins(k, v).set_black()
  } else {
    self.ins(k, v)
  }
}

fn fold[X](self : Node, f : (Int, Bool, X) -> X, d : X) -> X {
  match self {
    Leaf => d
    Node(_, l, k, v, r) => r.fold(f, f(k, v, l.fold(f, d)))
  }
}

typealias List[X] = @immut/list.T[X]

fn mk_map(freq : Int, n : Int) -> List[Node] {
  loop n, Leaf, @immut/list.Nil {
    0, m, acc => Cons(m, acc)
    n, m, acc => {
      let m1 = m.insert(n, n % 10 == 0)
      continue n - 1, m1, if n % freq == 0 { Cons(m1, acc) } else { acc }
    }
  }
}

fn main {
  let ms = mk_map(5, 4200000)
  let v = @immut/list.unsafe_head(ms).fold(fn { _, v, r => if v { r + 1 } else { r } }, 0)
  println(v)
}
