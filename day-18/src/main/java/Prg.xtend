import java.util.*
import java.nio.file.*
import static extension DirExtensions.*

enum Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

class DirExtensions {
	def static toDir(String dir) {
		switch(dir) {
			case 'U',
			case '3': Dir.UP
			case 'D',
			case '1': Dir.DOWN
			case 'L',
			case '2': Dir.LEFT
			case 'R',
			case '0': Dir.RIGHT
			default: throw new RuntimeException('Wrong direction ' + dir)
		}
	}
	
	def static dr(Dir dir) {
		switch(dir) {
			case Dir.UP: -1
			case Dir.DOWN: 1
			default: 0
		}
	}
	
	def static dc(Dir dir) {
		switch(dir) {
			case Dir.LEFT: -1
			case Dir.RIGHT: 1
			default: 0
		}
	}
}

class Point {
	public val long r
	public val long c
	
	new(long r, long c) {
		this.r = r
		this.c = c
	}
	
	override toString() {
		'[' + r + ', ' + c + ']'
	}
	
	def move(Move move) {
		new Point (r + move.count * move.dir.dr(),
			c + move.count * move.dir.dc())
	}
}

class Move {
	public val Dir dir
	public val long count
	
	new(Dir dir, long count) {
		this.dir = dir
		this.count = count
	}
	
	def static fromString(String line) {
		val parts = line.split(" ")
		val dir = parts.get(0).toDir()
		val count = Long.parseLong(parts.get(1))
		new Move(dir, count)
	}
	
	def static fromBrokenString(String line) {
		val parts = line.split(" ")
		val cnt = parts.get(2).substring(2, 7)
		val dir = parts.get(2).substring(7, 8)
		new Move(dir.toDir(), Long.parseLong(cnt, 16))
	}
	
	override toString() {
		dir + ' ' + count
	}
}

class Sweep {
	val SortedMap<Long, SortedSet<Long>> starts = new TreeMap
	val SortedMap<Long, SortedSet<Long>> ends = new TreeMap
	val SortedSet<Long> breaks = new TreeSet
	
	var Point p = new Point(0L, 0L)
	var trench = 0L
	
	def dig(Move move) {
		val pp = p
		p = p.move(move)
		
		if (move.dir == Dir.LEFT) {
			starts.computeIfAbsent(p.c) [new TreeSet].add(p.r)
			ends.computeIfAbsent(pp.c) [new TreeSet].add(p.r)
			breaks.add(p.c)
			breaks.add(pp.c)
		} else if (move.dir == Dir.RIGHT) {
			starts.computeIfAbsent(pp.c) [new TreeSet].add(p.r)
			ends.computeIfAbsent(p.c) [new TreeSet].add(p.r)
			breaks.add(p.c)
			breaks.add(pp.c)
		}
		
		if (move.dir == Dir.RIGHT || move.dir == Dir.DOWN) {
			trench += move.count
		}
	}
	
	def fill() {
		var area = 0L
		val SortedSet<Long> active = new TreeSet
		
		var bb = Long.MIN_VALUE
		for (b : breaks) {
			var ee = Long.MIN_VALUE
			var inside = false
			// println('break ' + b)
			for (e : active) {
				if (inside) {
					inside = false
					val a = (b - bb) * (e - ee)
					// println('between ' + ee + ' and ' + e + ' = ' + a)
					area += a
				} else {
					inside = true
				}
				ee = e;
			}
			if (ends.containsKey(b)) {
				active.removeAll(ends.get(b))
			}
			if (starts.containsKey(b)) {
				active.addAll(starts.get(b))
			}
			bb = b;
		}
		area+trench+1
	}
}

class Prg {

	def static calculateArea(List<Move> moves) {
		val g = new Sweep
		for (m : moves) {
			g.dig(m)
		}
		val area = g.fill()
		println(area)
	}

	def static void main(String[] args) {
		val moves1 = Files.lines(Paths.get(args.get(0)))
			.map [Move.fromString(it)]
			.toList()
		calculateArea(moves1)
		
		val moves2 = Files.lines(Paths.get(args.get(0)))
			.map [Move.fromBrokenString(it)]
			.toList()
		calculateArea(moves2)
		
	}
}

