exception InvalidInput of string

type Part = {
  x: int
  m: int
  a: int
  s: int
}

type Operator = 
  | Lt
  | Gt

type Output = 
  | Accept
  | Reject
  | Goto of flow: string

type Rule = {
  fieldName: string
  operator: Operator
  value: int
  output: Output
}

type Workflow = {
  name: string
  rules: Rule list
  otherwise: Output
}

let parsePart (line: string) =
  let parseField (field: string) =
    let eq = field.Split [| '=' |]
    int eq.[1]
  let trimmed = line.Trim [| '{'; '}' |]
  let fs = trimmed.Split [| ',' |]
  {
    x = (parseField fs.[0])
    m = (parseField fs.[1])
    a = (parseField fs.[2])
    s = (parseField fs.[3])
  }

let parseWorkflow (line: string) =
  let split = line.Split [| '{' |]
  let name = split.[0]
  let body = split.[1].Trim [| '}' |]
  let rs, ow =
    body.Split [| ',' |]
    |> Array.toList
    |> List.partition (fun (l:string) -> l.Contains ':')
  let parseOutput (output: string) =
    match output with
    | "A" -> Accept
    | "R" -> Reject
    | flow -> Goto flow
  let parseRule (rule: string) =
    let co = rule.Split [| ':' |]
    let fn = co.[0].[0..0]
    let op =
      match co.[0].[1..1] with
      | "<" -> Lt
      | ">" -> Gt
      | _ -> raise (InvalidInput "Invalid operator")
    let value = int co.[0].[2..]
    let output = parseOutput co.[1]
    {
      fieldName = fn
      operator = op
      value = value
      output = output
    }
  let rules = List.map parseRule rs
  let otherwise = parseOutput ow.[0]
  {
    name = name
    rules = rules
    otherwise = otherwise
  }
  
let parseInput (content: string) =
  let partLines, flowLines = 
    content.Split [| '\n' |]
    |> Array.toList
    |> List.filter (fun l -> (String.length l) > 0)
    |> List.partition (fun (l:string) -> l[0] = '{')
  let parts = List.map parsePart partLines
  let flows =
    List.map parseWorkflow flowLines
    |> List.map (fun (w: Workflow) -> (w.name, w))
    |> Map.ofList
  (flows, parts)

let extractFieldValue (part: Part) (fieldName: string) =
  match fieldName with
  | "x" -> part.x
  | "m" -> part.m
  | "a" -> part.a
  | "s" -> part.s
  | _ -> raise (InvalidInput "Invalid rule") 

let route1 (flows: Map<string, Workflow>) (part: Part) (start: string) =
  let flow = Map.find start flows
  flow.rules
  |> List.tryFind (fun (r: Rule) -> 
    let v = extractFieldValue part r.fieldName
    match r.operator with
    | Lt -> v < r.value
    | Gt -> v > r.value)
  |> Option.map (fun r -> r.output)
  |> Option.defaultValue flow.otherwise

let rec route (flows: Map<string, Workflow>) (part: Part) (start: string) =
  let o = route1 flows part start
  match o with
  | Goto flow -> route flows part flow
  | _ -> o

let sumPart (part: Part) =
  part.x + part.m + part.a + part.s



type Range = {
  min: int
  max: int
}

type MultiPart = {
  x: Range
  m: Range
  a: Range
  s: Range
}

let splitRange (range: Range) (rule: Rule) =
  match rule.operator with
  | Lt ->
    if rule.value >= range.max then (Some range, None)
    elif rule.value < range.min then (None, Some range)
    else (
      Some { min = range.min; max = rule.value - 1 },
      Some { min = rule.value; max = range.max }
    )
  | Gt ->
    if rule.value <= range.min then (Some range, None)
    elif rule.value > range.max then (None, Some range)
    else (
      Some { min = rule.value + 1; max = range.max },
      Some { min = range.min; max = rule.value }
    )

let splitMultiPart (part: MultiPart) (rule: Rule) =
  match rule.fieldName with
  | "x" -> 
    let yes, no = splitRange part.x rule
    (
      Option.map (fun r -> { part with x = r }) yes,
      Option.map (fun r -> { part with x = r }) no
    )
  | "m" -> 
    let yes, no = splitRange part.m rule
    (
      Option.map (fun r -> { part with m = r }) yes,
      Option.map (fun r -> { part with m = r }) no
    )
  | "a" -> 
    let yes, no = splitRange part.a rule
    (
      Option.map (fun r -> { part with a = r }) yes,
      Option.map (fun r -> { part with a = r }) no
    )
  | "s" -> 
    let yes, no = splitRange part.s rule
    (
      Option.map (fun r -> { part with s = r }) yes,
      Option.map (fun r -> { part with s = r }) no
    )
  | _ -> raise (InvalidInput "Invalid rule") 

let rec multiRoute1 (rules: Rule list) (otherwise: Output) (part: MultiPart) =
  match rules with
  | rule :: rest -> 
    let yes, no = splitMultiPart part rule
    let this = 
      yes
      |> Option.map (fun p -> [ (rule.output, p) ])
      |> Option.defaultValue []
    let others = 
      no
      |> Option.map (fun p -> multiRoute1 rest otherwise p)
      |> Option.defaultValue []
    this @ others
  | [] -> [ (otherwise, part) ]

let rec multiRoute
  (flows: Map<string, Workflow>)
  (part: MultiPart)
  (Goto start) = 
  let flow = Map.find start flows
  let outputs = multiRoute1 flow.rules flow.otherwise part
  let finished, unfinished =
    List.partition (fun (o, _) -> o = Accept || o = Reject) outputs
  finished @ List.collect (fun (o, p) -> multiRoute flows p o) unfinished

let rsize (range: Range) =
  (int64 range.max) - (int64 range.min) + 1L

let comb (part: MultiPart) =
  (rsize part.x) * (rsize part.m) * (rsize part.a) * (rsize part.s) 



[<EntryPoint>]
let main (args : string[]) =
  let fileName = args.[0]
  let content = System.IO.File.ReadAllText fileName
  let (flows, parts) = parseInput content
  
  // printfn $"%A{flows} \n %A{parts}"
  
  let sum = 
    parts
    |> List.filter (fun p -> 
      let o = route flows p "in"
      // printfn $"{p} is {o}"
      o = Accept)
    |> List.map sumPart
    |> List.sum
    
  printfn $"sum: {sum}"
    
  let r = { min = 1; max = 4000 }
  let p = { x = r; m = r; a = r; s = r }

  // let f = Map.find "qqz" flows
  // let mr = multiRoute1 f.rules f.otherwise p
  
  let multiParts = multiRoute flows p (Goto "in")
  
  // printfn $"%A{multiParts}"  
  
  let combinations =
    multiParts
    |> List.filter (fun (o, _) -> o = Accept)
    |> List.map (fun (_, p) -> p)
    |> List.map comb
    |> List.sum
    
  printfn $"combinations: {combinations}"
  
  0

