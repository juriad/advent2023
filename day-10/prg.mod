MODULE hello;

FROM FIO IMPORT
	File,
	OpenToRead, 
	Close,
	EOF,
	WasEOLN,
	ReadChar;
	
FROM StrIO IMPORT
	WriteString,
	WriteLn;

FROM NumberIO IMPORT
	WriteInt,
	WriteCard;
	
FROM Args IMPORT
	GetArg,
	Narg;

TYPE
	Dir = (Left, Right, Up, Down, Start, Loop);
	Dirs = PACKEDSET OF Dir;
	Grid = ARRAY [0..257],[0..257] OF Dirs;

VAR
	FN: ARRAY [1..256] OF CHAR;
	SUCCESS: BOOLEAN;
	F: File;
	C: CHAR;
	W, H: CARDINAL;
	X, Y: CARDINAL;
	SX, SY: CARDINAL;
	DIRS: Dirs;
	GRID: Grid;
	STEPS: CARDINAL;
	INTERNAL: CARDINAL;
	
PROCEDURE Walk(
	VAR GRID: Grid; 
	Y, X: CARDINAL;
	DIR: Dir;
	START: BOOLEAN;
	STEPS: CARDINAL
	): CARDINAL;
VAR
	DIRS: Dirs;
BEGIN
	(*
	WriteString("Walk: ");
	WriteCard(STEPS, 4);
	WriteCard(Y, 4);
	WriteCard(X, 4);
	*)

	DIRS := GRID[Y][X];
	GRID[Y][X] := DIRS + Dirs{Loop};
	IF (NOT START) AND (Start IN DIRS) THEN
		(*WriteLn;*)
		RETURN STEPS;
	END;
	
	(*
	WriteCard(DIRS, 8);
	*)
	DIRS := DIRS - Dirs{DIR};
	(*
	WriteCard(DIRS, 8);
	WriteLn;
	*)
	
	IF Up IN DIRS THEN
		(*WriteString("GoUp");*)
		RETURN Walk(GRID, Y-1, X, Down, FALSE, STEPS + 1);
	ELSIF Down IN DIRS THEN
		(*WriteString("GoDown");*)
		RETURN Walk(GRID, Y+1, X, Up, FALSE, STEPS + 1);
	ELSIF Left IN DIRS THEN
		(*WriteString("GoLeft");*)
		RETURN Walk(GRID, Y, X-1, Right, FALSE, STEPS + 1);
	ELSIF Right IN DIRS THEN
		(*WriteString("GoRight");*)
		RETURN Walk(GRID, Y, X+1, Left, FALSE, STEPS + 1);
	ELSE
		RETURN 999;
	END;
END Walk;

PROCEDURE CountInternal(
	VAR GRID: Grid;
	W, H: CARDINAL
	): CARDINAL;
VAR
	I, O, L: CARDINAL;
	LAST: Dir;
	DIRS: Dirs;
BEGIN
	I := 0;
	O := 0;
	
	FOR Y := 1 TO H DO
		L := 0;
		FOR X := 1 TO W DO
			DIRS := GRID[Y][X];
			IF Loop IN DIRS THEN
				IF Right IN DIRS THEN
					IF Left IN DIRS THEN
						;
					ELSE
						L := L + 1;
						IF Up IN DIRS THEN
							LAST := Up;
						ELSE
							LAST := Down;
						END;
					END;
				ELSIF Left IN DIRS THEN
					IF LAST IN DIRS THEN
						L := L + 1;
					ELSE
						;
					END;
				ELSE
					L := L + 1;
				END;
			ELSIF ODD(L) THEN
				(*
				WriteString("Internal; Y, X:");
				WriteCard(Y, 6);
				WriteCard(X, 6);
				WriteLn;
				*)
				I := I + 1;
			ELSE
				O := O + 1;
			END;
		END;
	END;
	
	RETURN I;
END CountInternal;

BEGIN
	W := 0;
	H := 0;
	SUCCESS := GetArg(FN, 1);
	
	F := OpenToRead(FN);
	WHILE NOT EOF(F) DO
		C := ReadChar(F);
		IF WasEOLN(F) THEN
			INC(H);
		END;
		IF H = 0 THEN
			INC(W);
		END;
	END;
	Close(F);
	
	(*
	WriteString("W, H:");
	WriteCard(W, 6);
	WriteCard(H, 6);
	WriteLn;
	*)
	
	FOR X := 0 TO W+1 DO
		GRID[0][X] := Dirs{};
		GRID[H+1][X] := Dirs{};
	END;
	FOR Y := 0 TO W+1 DO
		GRID[Y][0] := Dirs{};
		GRID[Y][X+1] := Dirs{};
	END;
	
	F := OpenToRead(FN);
	Y := 1;
	X := 1;
	LOOP
		C := ReadChar(F);
		IF WasEOLN(F) THEN
			INC(Y);
			X := 1;
			(*
			WriteLn;
			*)
		ELSIF NOT EOF(F) THEN
			CASE C OF
				'.': DIRS := Dirs{}; |
				'|': DIRS := Dirs{Up, Down}; |
				'-': DIRS := Dirs{Left, Right}; |
				'7': DIRS := Dirs{Left, Down}; |
				'F': DIRS := Dirs{Right, Down}; |
				'J': DIRS := Dirs{Left, Up}; |
				'L': DIRS := Dirs{Right, Up}; |
				'S': DIRS := Dirs{Start}; SY := Y; SX := X;
			END;
			(*
			WriteCard(ORD(C), 4);
			WriteCard(DIRS, 3);
			*)
			GRID[Y][X] := DIRS;
			INC(X);
		ELSE
			EXIT;
		END;
	END;
	Close(F);	

	IF Down IN GRID[SY-1][SX] THEN
		(*WriteString("Up");*)
		GRID[SY][SX] := GRID[SY][SX] + Dirs{Up};
	END;
	IF Up IN GRID[SY+1][SX] THEN
		(*WriteString("Down");*)
		GRID[SY][SX] := GRID[SY][SX] + Dirs{Down};
	END;
	IF Right IN GRID[SY][SX-1] THEN
		(*WriteString("Left");*)
		GRID[SY][SX] := GRID[SY][SX] + Dirs{Left};
	END;
	IF Left IN GRID[SY][SX+1] THEN
		(*WriteString("Right");*)
		GRID[SY][SX] := GRID[SY][SX] + Dirs{Right};
	END;
	(*
	WriteLn;
	
	WriteString("SY, SX:");
	WriteCard(SY, 6);
	WriteCard(SX, 6);
	WriteLn;
	*)
	
	STEPS := Walk(GRID, SY, SX, Start, TRUE, 0);
	
	WriteCard(STEPS / 2, 6);
	WriteLn;
	
	INTERNAL := CountInternal(GRID, W, H);
	
	WriteCard(INTERNAL, 6);
	WriteLn;
	
END hello.
