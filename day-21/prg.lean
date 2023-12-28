/- list based implementation -/

def map2d2 (main: List Char) (l: Char) (up: List Char) (down: List Char) (outside: Char)
  (fn : Char -> Char -> Char -> Char -> Char -> Char) : List Char :=
  match main with
  | [] => []
  | c :: [] => 
    match up, down with
    | u :: _, d :: _ => (fn c l outside u d) :: []
    | _, _ => panic! "unaligned up or down"   
  | c :: r :: rest =>
    match up, down with
    | u :: urest, d :: drest => (fn c l r u d) :: (map2d2 (r :: rest) c urest drest outside fn)
    | _, _ => panic! "unaligned up or down"   
    

def map2d1 (main: List (List Char)) (u: List Char) (outside : Char)
  (fn : Char -> Char -> Char -> Char -> Char -> Char) : List (List Char) :=
  match main with
  | [] => []
  | c :: [] =>
    let d := List.map (fun _ => outside) c
    (map2d2 c outside u d outside fn) :: []
  | c :: d :: rest =>
    (map2d2 c outside u d outside fn) :: (map2d1 (d :: rest) c outside fn)
    
def map2d (map: List (List Char)) (outside : Char)
  (fn : Char -> Char -> Char -> Char -> Char -> Char) : List (List Char) :=
  match map with
  | [] => []
  | row :: _ =>
    let u := List.map (fun _ => outside) row
    map2d1 map u outside fn

abbrev Lap : Type := List (List Char)

def readLap (fileName: String) : IO Lap := do
  let lines <- IO.FS.lines ⟨fileName⟩
  let chars := List.map
    (fun line => String.toList line)
    (Array.toList lines)
  pure chars
  
def biggerLap (map: Lap) (count: Nat) :=
  let wide := List.map
    (fun row =>
      let r := List.replace row 'S' '.'
      let side := List.join (List.replicate count r)
      side ++ row ++ side)
    map
  let r := List.map
    (fun row => List.replace row 'S' '.')
    wide
  let side := List.join (List.replicate count r)
  side ++ wide ++ side

def stepLap (map: Lap) :=
  map2d map '#' (fun c l r u d => 
    match c with
    | '#' => '#'
    | _ => if l = 'S' || r = 'S' || u = 'S' || d = 'S' then 'S' else '.')

def countLap (map: Lap) : Nat :=
  List.foldl
    (fun (a: Nat) (row: List Char) => 
      List.foldl
        (fun (b: Nat) (col: Char) =>
          if col = 'S' then b + 1 else b
        )
        a
        row
    )
    0
    map

def strLap (map: Lap) : String :=
  let chars := List.foldr
    (fun row a =>
      List.foldr
        (fun col b =>
          col :: b
        )
        ('\n' :: a)
        row
    )
    ([]: List Char)
    map
  List.asString chars

/- general -/

partial def readLines (stream : IO.FS.Stream) : IO (List String) := do
  let line <- stream.getLine
  match line with
  | "" => pure []
  | _ => do
    let rest <- readLines stream
    pure (line :: rest)
    
def steps2 (count: Nat) (fn: a -> a) (map: a) : a :=
  match count with
  | Nat.zero => map
  | Nat.succ c => fn (steps2 c fn map)

/- main logic -/

def task2 (steps: Nat) :=
  let x := 3703 /- the first square -/
  let y := 3617 /- its pair -/
  let a := 3632 /- filler 1 -/
  let b := 3632 /- filler 2 = filler 1 in count -/
  let n := (steps - 65) / 131
  let xx := n * n + n + n + 1 /- number of x shapes -/
  let yy := n * n /- number of y shapes -/
  let aa := n * n + n /- number of a shapes -/
  let bb := n * n + n /- number of b shapes -/
  let res := xx * x + yy * y + aa * a + bb * b
  res

def main (args: List String) : IO Unit :=
  if let [arg, tms, cnt] := args then do
    let times := 
      match String.toNat? tms with
      | some t => t
      | none => panic! "invalid times"
    IO.println s!"{task2 26501365}"
    let count := 
      match String.toNat? cnt with
      | some c => c
      | none => panic! "invalid count"
    let m <- readLap arg
    /-let o := findOrigin m-/
    let b := biggerLap m times
    let s := steps2 count stepLap b
    let c := countLap s
    IO.println s!"{c}"
    -- IO.println s!"{strLap s}"
  else
    IO.println "error"

