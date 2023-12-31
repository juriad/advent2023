import * as fs from 'fs';

interface Stack<T> {
  push: (v: T) => void,
  pop: () => T | undefined,
  isEmpty: () => boolean
}
type MakeStack = <T>() => Stack<T>

const FOREST = '#'
const FLAT = '.'
const WEST = '<'
const EAST = '>'
const SOUTH = 'v'
const NORTH = '^'

type Forest = typeof FOREST
type Flat = typeof FLAT
type Slope = typeof WEST | typeof EAST
  | typeof NORTH | typeof SOUTH
type Path = Flat | Slope
type Tile = Forest | Path

function isPath(t: Tile): t is Path {
  return t !== FOREST
}

interface Point {
  x: number,
  y: number 
}

interface Grid<T> {
  readonly width: number,
  readonly height: number,
  inRange: (p: Point) => boolean,
  get: (p: Point) => T,
  set: (p: Point, v: T) => void,
}
type MakeGrid = <T>(
  width: number, 
  height: number,
  def: T
) => Grid<T>

interface Steps {
  readonly start: number
  step: (prev: number) => number,
  isValid: (s: number) => boolean,
  length: () => number,
  valid: any
}
type MakeSteps = () => Steps

const Stack: MakeStack = <T>() => {
  let len = 0
  let arr: T[] = []
  return {
    push: (v: T) => {
      if (len === arr.length) {
        arr.push(v)
      } else {
        arr[len] = v
      }
      len++
    },
    pop: () => {
      if (len === 0) {
        return undefined
      } else {
        len--
        return arr[len]
      }
    },
    isEmpty: () => len === 0
  }
}

const Grid: MakeGrid = <T>(
  width: number, 
  height: number,
  def: T
) => {
  let arr = Array(width * height).fill(def)
  let inRange = (p: Point) => 
    p.x >= 0 && p.x < width
      && p.y >= 0 && p.y < height
  return {
    width,
    height,
    inRange,
    get: (p: Point) => {
      if (inRange(p)) {
        return arr[p.y * width + p.x]
      }
      throw new Error("out of range")
    },
    set: (p: Point, v: T) => {
      if (inRange(p)) {
        arr[p.y * width + p.x] = v
        return
      }
      throw new Error("out of range")
    }
  }
}

interface Interval {
  from: number,
  to: number | undefined
}

const Steps: MakeSteps = () => {
  let last = -1
  let valid: Interval[] = [{from: 0, to: undefined}]
  return {
    start: -1,
    step: (prev: number) => {
      if (prev !== last) {
        valid = valid
          .filter(i => i.from <= prev)
          .map(i => i.to !== undefined && i.to <= prev
            ? i : {...i, to: prev})
        valid.push({from: last + 1, to: undefined})
      }
      last++
      return last
    },
    isValid: (s: number) => valid.some(i => 
      i.from <= s && (i.to === undefined || i.to >= s)),
    length: () => valid
      .map(i => 
        (i.to === undefined ? last : i.to) - i.from + 1)
      .reduce((a, b) => a + b, 0),
    valid: () => valid
  }
}

const go = (p: Point, s: Slope): Point => {
  switch(s) {
    case WEST: return {...p, x: p.x - 1}
    case EAST: return {...p, x: p.x + 1}
    case SOUTH: return {...p, y: p.y + 1}
    case NORTH: return {...p, y: p.y - 1}
  }
}

type Neighbors = (g: Grid<Tile>, p: Point) => Point[]

const slippery: Neighbors = (g, p) => {
  const t = g.get(p)
  switch (t) {
    case FOREST: throw new Error("Not on path")
    case FLAT: return [
        go(p, WEST), go(p, EAST), 
        go(p, NORTH), go(p, SOUTH)
      ].filter(n => g.inRange(n))
      .filter(n => g.get(n) !== FOREST)
    default: return [go(p, t)]      
  }
}

const flat: Neighbors = (g, p) => {
  const t = g.get(p)
  switch (t) {
    case FOREST: throw new Error("Not on path")
    default: return [
        go(p, WEST), go(p, EAST), 
        go(p, NORTH), go(p, SOUTH)
      ].filter(n => g.inRange(n))
      .filter(n => g.get(n) !== FOREST)
  }
}

interface Game {
  tiles: Grid<Tile>,
  start: Point,
  end: Point
}

const findPath = (g: Grid<Tile>, y: number): Point | undefined => {
  for (let x = 0; x < g.width; x++) {
    const p = {x, y}
    if (isPath(g.get(p))) {
      return p
    }
  }
  return undefined
}

const loadGame = (fileName: string): Game => {
  const f = fs.readFileSync(fileName, 'utf8').trim();
  const g = f.split('\n').map((l: string) => l.split(''))

  const grid = Grid<Tile>(g[0].length, g.length, FOREST)
  for (let y = 0; y < g.length; y++) {
    const row = g[y]
    for (let x = 0; x < row.length; x++) {
      const t = row[x]
      switch (t) {
        case FOREST:
        case FLAT:
        case WEST:
        case EAST:
        case SOUTH:
        case NORTH:
          grid.set({x, y}, t)
          break
        default: throw new Error("Not a tile")
      }
    }
  }
  
  const start = findPath(grid, 0)
  if (start === undefined) throw new Error("Has no start")
  const end = findPath(grid, grid.height - 1)
  if (end === undefined) throw new Error("Has no end")
  
  return {
    tiles: grid,
    start,
    end
  }
}

interface Crumb {
  point: Point,
  prev: number 
}

const printGrid = (tiles: Grid<Tile>, trail: Grid<number>, steps: Steps): void => {
  for (let y = 0; y < tiles.height; y++) {
    for (let x = 0; x < tiles.width; x++) {
      const p = {x, y}
      const t = tiles.get(p)
      const s = steps.isValid(trail.get(p))
      process.stdout.write(s ? 'O' : t)
    }
    process.stdout.write('\n')
  }
}

const findLongestPath = ({tiles, start, end}: Game, neighbors: Neighbors): number | undefined => {
  const steps = Steps()
  const trail = Grid(
    tiles.width, tiles.height, steps.start)
  const stack: Stack<Crumb> = Stack()
  
  let maxLength = undefined
  stack.push({point: start, prev: steps.start})
  let ends = 0
  
  while (!stack.isEmpty()) {
    const {point, prev} = stack.pop()!
    const cur = steps.step(prev)
    trail.set(point, cur)
    
    if (prev !== cur - 1) {
      // console.log("Returned")
    }
    
    // console.log(point, prev, cur)
    
    if (point.x === end.x && point.y === end.y) {
      const len = steps.length() - 1
      ends++
      // console.log("Found end at", len)
      // printGrid(tiles, trail, steps)
      if (maxLength === undefined || maxLength < len) {
        console.log("Found end at", len, ends)
        maxLength = len
      }
    } else {
      const next = neighbors(tiles, point)
        .filter(p => !steps.isValid(trail.get(p)))
      if (next.length > 1) {
        // console.log("At fork",cur, point, next)
        // printGrid(tiles, trail, steps)
      }
      next.forEach(p => stack.push({point: p, prev: cur}))
    }
  }
  
  return maxLength
}

// console.log(process.argv)
const game = loadGame(process.argv[2])
// console.log(game)
console.log(findLongestPath(game, slippery))
console.log(findLongestPath(game, flat))

