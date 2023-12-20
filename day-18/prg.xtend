enum Dir {
	UP(-1, 0),
	DOWN(1, 0),
	LEFT(0, -1),
	RIGHT(0, 1)
	
	public val dr
	public val dc
	
	new(dr, dc) {
		this.dr = dr
		this.dc = dc
	}
	
	def static fromString(String dir) {
		switch(dir) {
			case 'U': return UP
			case 'D': return DOWN
			case 'L': return LEFT
			case 'R': return RIGHT
		}
		throw new RuntimeException('Wrong direction ' + dir)
	}
}

class Move {
	public val Dir dir
	public val int count
	public val String color
	
	new(Dir dir, int count, String color) {
		this.dir = dir
		this.count = count
		this.color = color
	}
	
	def static fromString(String line) {
		val parts = line.split(" ")
		val dir = Dir.fromString(parts.get(0))
		val count = Integer.parseInt(parts.get(1))
		val color = parts.get(2).substring(1, 7)
		return new Move(dir, count, color)
	}
}

class Grid {
	var cr;
	var cc;
	val Map<Integer, Set<Integer>> rows = newLinkedHashMap()
	
	new() {
		dig(0, 0)
		cr = 0
		cc = 0
	}
	
	private def dig(int r, int c) {
		val row = rows.computeIfAbsent(r) [newLinkedHashSet()]
		row.add(c)
	}
	
	public dig(Move move) {
		for (i : 1..move.count) {
			cr += move.dir.dr
			cc += move.dir.dc
			dig(cr, cc)
		}
		System.out.println('[' + cr + ', ' + cc + ']')
	}
}

class Prg {

	def static void main(String[] args) {
		println("Hello World 2")
	}
}
