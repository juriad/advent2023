use "collections"
use "debug"

class val Take
	let red: U64
	let green: U64
	let blue: U64
	
	new val create(red': U64, green': U64, blue': U64) =>
		red = red'
		green = green'
		blue = blue'
		
	fun isValid(max: Take): Bool =>
		(red <= max.red) and (green <= max.green) and (blue <= max.blue)
		
	fun add(other: Take) : Take =>
		Take(red + other.red, green + other.green, blue + other.blue)
		
	fun op_or(other: Take) : Take =>
		Take(red.max(other.red), green.max(other.green), blue.max(other.blue))
		
	fun box string() : String iso^ =>
		red.string() + " red, " + green.string() + " green, " + blue.string() + " blue"
		
	fun power() : U64 =>
		red * green * blue

class Game
	let id: U64
	let takes: List[Take]
	
	new create(id': U64, takes': List[Take]) =>
		id = id'
		takes = takes'
		
	fun isValid(max: Take): Bool =>
		takes.every( {(t: Take): Bool => t.isValid(max) } )
		
	fun min(): Take =>
		takes.fold[Take]( {(acc: Take, t: Take): Take => acc or t }, Take(0, 0, 0))
		
	fun box string() : String iso^ =>
		"Game " + id.string() + ": " + "; ".join(takes.values())

primitive GameParser
	fun parseTake(str: String): Take => 
		let cubes = List[String].from(str.split_by(", "))
		cubes.flat_map[Take]( {(s: String): List[Take] => 
			let color_count = s.split_by(" ")
			try
				let count = color_count(0) ? .u64() ?
				let color = color_count(1) ?
				let take = match color
					| "red" => Take(count, 0, 0)
					| "green" => Take(0, count, 0)
					| "blue" => Take(0, 0, count)
				else
					error
				end
				List[Take].unit(take)
			else
				List[Take]
			end
		} ).fold[Take]( {(acc: Take, t: Take): Take => acc + t }, Take(0, 0, 0))

	fun parseGame(line: String) : Game ? =>
		let head_rest = line.split_by(": ")
		let head = head_rest(0) ?
		let game_id = head.split_by(" ")
		let id = game_id(1) ? .u64() ?
		let rest = head_rest(1) ?
		let takes_str = List[String].from(rest.split_by("; "))
		let takes = takes_str.map[Take]( {(s: String): Take => GameParser.parseTake(s) } )
		Game(id, takes)
		
	fun parseInput(input: String) : List[Game]^ =>
		let lines = List[String].from(input.split_by("\n"))
		lines.flat_map[Game]( {(line: String): List[Game] =>
			try
				List[Game].unit(GameParser.parseGame(line) ?)
			else
				List[Game]
			end
		} )

actor Main
	new create(env: Env) => env.input(
		object iso is InputNotify
			fun ref apply(data: Array[U8] iso) =>
				let max = Take(12, 13, 14)
			
				let input : String val = String.from_iso_array(consume data)
				let games = GameParser.parseInput(input)
				
				// env.out.print("\n".join(games.values()))
				
				let sum_valid_ids = games
					.filter( {(g: Game box): Bool => g.isValid(max) } )
					.fold[U64]( {(acc: U64, g: Game box): U64 => acc + g.id }, 0)
					
				env.out.print(sum_valid_ids.string())
				
				let sum_min_powers = games
					.fold[U64]( {(acc: U64, g: Game box): U64 => acc + g.min().power() }, 0)
				
				env.out.print(sum_min_powers.string())

			fun ref dispose() =>
				None
		end,
		51200)

