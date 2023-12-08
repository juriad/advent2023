# Progress

Each day I use a different programming language.

## Day 1 - NASM

I always wanted to write a bigger program in assembly, and this was a great opportunity.
Reading and writing syscalls are well documented and working with one byte at a time was good enough.
I did not dare to write functions because I did not want to adhere to conventions.

The implementation of the first part could reside almost completely in registers.
The second part required a rewrite that used stack.
Some parts needed to be uesd twice, so they were either duplicated or jumped to with appropriate flags.

## Day 2 - Pony

This time the installation of Pony worked (I banned it years ago due to compilation issues).
Pony has an intesting take on memory safety; the programmer needs to convince the compiler that the operations are safe.
Its syntax is a bit verbose around generics.
Its actor model seems capable (athough I did not use it).

I wanted a language where it is easy to process more than a byte of input at a time, and I don't have many such left.
Parsing the input took most of the effort.
Getting the results then reused constructs that I alrady knew and so took only minutes.

## Day 3 - Hare

Hmm, weird that I have not heard about Hare before; it is somewhat low-level language that hides the complexity similar to Go.
It uses lots of modern features (expressions, type system, error handling) but lacks in memory management where ownership is not enforced.

The task required looking at neighborhood on the grid, which was quite easy in the first part.
The second part required some collection of gears and their subsequent processing.
Luckily I avoided parsing the numbers twice.

## Day 4 - Hy

Coming home late, I wanted a simpler language.
Hy is Python with Lisp syntax.
It is verbose but still concise.

The task itself was easy; the language has support for sets which makes the computation trivial.
The hardest part was to not get lost in parentheses.

## Day 5 - Pike

After a few unsuccessful choices of languages, I settled for Pike.
It is very readable, simplistic, with good documentation describing everything from the very beginning.
But the documentation is not complete; some parts were hard to find such as how to parse string to int, or split a string.
Fortunately the input and output was easy.

The first implementation was keeping track of the history of each seed, I was hoping that it will be useful for the second part; it was not.
I wanted to read the input only once, which meant that I needed to simulate both parts at the same time.
Some errors were caused by interval artithmetics.

## Day 6 - K(ona)

Very terse language where you feel great accomplishment after writing few characters and it works.
It rarely works on the first attemp.
The error messages are pretty bad in comparison to APL/BQN.

This task was perfect for an array based languages that has been on my list for a while.
I found a mathematical solution which could be doable with a pencil on a paper.
The second part surprised me; I guessed something with maximizing distance.

## Day 7 - Arturo

There were quite a few WTF moments during reading of the documentation as the syntax looks very arbitrary, but in the end it makes sense.
I appreciate the decent standard library as well as easy input and output.

I liked the task; I was fighting with sort function until I resorted to encode the value into a number instead of arrays.
In the second part it was enough just to try all possible values of the jokers.

# Lists

## Language pool

- ATS - cannot install
- C#
- CDuce
- CLIPS
- CoffeeScript
- Constraint Handling Rules
- Csh
- Emojicode
- F#
- F*
- Fetlang
- Fish
- Fleng
- High Level Assembly
- J
- LogTalk
- m4
- o:XML
- Occam
- Oz
- Pizza
- Samora
- Swift (parallel scripting language)
- TeX
- TypeScript
- Umple
- WolframScript
- xHarbour
- Xtend

## Used languages

- Ada
- Algol 68
- APL
- Arturo
- AWK
- Ballerina
- Bash
- (Free)Basic
- BC
- Boo
- BQN
- C
- C++
- Ceylon
- Chapel
- Closure
- Cobol
- Cobra
- ColdFusion Markup Language (CFML)
- Concurnas
- Crystal
- D
- Dart
- Dylan
- E
- Eiffel
- Elixir
- (Open)Euphoria
- Erlang
- Factor
- Fantom
- Flix
- Forth
- Fortran
- Gambas
- Genie
- Go
- Golo
- Gosu
- Groovy
- Hare
- Haskell
- Haxe
- Hy
- Icon
- Io
- Ivy (jhallen)
- Java
- JavaScript
- jq
- JudoScript
- Julia
- K(ona)
- Kotlin
- LDPL
- (Common)Lisp
- (UCB)Logo
- Lua
- Matlab (Octave)
- Mercury
- Minizinc
- MoonScript
- NASM
- Neko
- Nial
- Nim
- Objective-C
- OCaml
- OSTRAJava
- (Free)Pascal
- Perl
- PHP(7)
- PicoLisp
- Pike
- Pony
- PostScript
- Powershell
- (SWI)Prolog
- PureScript
- Python
- R
- Racket
- Raku
- Rebol
- Red
- Rexx
- Ring
- Ruby
- Rust
- Scala
- Sed
- Seed7
- SETL
- Simula
- S-Lang
- SNOBOL
- SQL
- Squirrel
- Standard ML
- Swift
- TCL
- TXL
- Unison
- Vala
- Vim Script
- XSLT
- Yeti
- Yoix
- Zig

## Missing letters

- Q
- W

## Banned languages

- Self - does not have 64bit distribution
- XQuery - not powerful enough
- Oberon - cannot compile standard library
- Goby - Does not have documentation (404)
- Smalltalk - Could start GUI but could not do anything; poor documentation maybe
- Scratch, Snap! - Cannot be run from a command line
- Oz, Mozart - incompatible with Boost 1.7
- FoxPro - not for Linux
- ActionScript - Cannot be downloaded
- Pure - requires different version of LLVM which fails to compile
- Eta - too close to Haskell on JVM
- Joy - does not compile, almost no documentation
- Whiley - could not make the example to work; it does not produce a class file
- Kit - discontinued, crucial parts of documentations are missing
- Snowball - not really a programming language
- Unicon - cannot compile
- Jelly - not standalone language
- Miranda - fails to build
- Noop - you can't code anything interesting in Noop yet
- Cilk - just a library for C++ which adds parallelism
- Gri - can only work with constant memory
- Hume - only on archive
- Processing - just a Java "library"
- Limbo - language for Inferno operating system
- Nu - could not figure out input
- Sather - no doc how to work with strings
- Ksh - too close to a regular Shell/Bash
- Whiley - cannot handle input
- Cool - school course, does not exists
- eC - almost no documentation
- ParaSail - could not figure out standard library (input)
- Tea - archived; does not have documentation
- Nickel - configuration, does not have input
- Ezhil - non ascii, non English
- Nemerle - Mono crashes
- Futhark - unusable input
- SAC - poor documentation, crashing compiler
- LoLa - cannot build
- Carbon - not ready for use
- Cyclone - only 32bit
- Oxygene - non-free
- Cuneiform - no documentations
- BETA - no download, discontinued
- BeanShell - fails with NPE
- S# - cannot find it again
- AMPL - non-free
- C-- - no input/output
- X10 - cannot compile - cannot find type Array
- Comal - cannot build OpenComal
- Pico - too weak input
- Ivy (for Bitcoin) - no input/output
- Solidity - no input/output
- Zsh - just a shell
- AmbientTalk - not much of input, cannot work with files
- Alice - dialect of Standard ML
- ML - just a family of languages
- Modula-2 - does not download
- J# - discontinued
- Wyvern - too poor documentation
- Hamler - did not manage to build
- ReasonML - not even tutorial can be build
- ABC - cannot make work with termcap/curses
- BCPL - almost no documentation; cannot find how to do input
- CLU - cannot make run
- Idris - version 2 is incomplete, version 1 does not run (missing library)
- Mojo - not for Arch Linux
- PascalABC.NET - fails to install
- Eel - not even example works
- rc - not available
- Elm - designed to run in browser, no I/O
- FlooP - no documentation, looks like it does not have I/O
- Harbour - cannot build and not for arch linux
- Mouse - cannot obtain
- Falcon - cannot build; compilation errors
