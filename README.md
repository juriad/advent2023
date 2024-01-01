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

## Day 8 - FGHC (Fleng)

Same syntax as Prolog but is inherently parallel? That is something to try.
Some parts are not obvious from the documentation, such as how to use streams.
Unfortunately, the language is hard to debug; I spent hours trying to find why it deadlocks.
I had wrong order of parameters.

The task was nice that it could use static size of an array - just interpret all locations in base26.
The second part has bad explanation - it is not clear why the paths never visit another end.
It is also weird that there is no prefix to the loop.
I guess the simplification is given by the author and we are lucky that we don't need to work more.

## Day 9 - CoffeeScript

I banned a lot of languages today; way too many and so I had to choose a simple language to catch up.
Not knowing anything about CoffeeScript I was worried that it will be too similar to JavaSxcript; it was not.
I was suprised how natural it felt, but I also understand why the community chose TypeScript instead.
They tried to put all ideas, good or bad into the language.

So easy task was nice.
I did not care about detection all zeros; I went all the way down.
The second part just needed two reverses, cute.

## Day 10 - Modula-2

I read about Modula-2 getting support from GCC last year.
The development is slower than I anticipated; it is merged in master but not official release yet.
I had to compile my own GCC with suppoer for Modula-2.
The language is pretty straghtforward; I liked the suport for types (enums, sets).
On the other hand GCC does not support the extension of dynamic arrays.
There are still a few issues and I will be filing bug reports.

I liked that I could represent the capabilities of every tile with a set (bit mask in fact).
The second task made me remmeber the sweeping algorithm; there was just extra care needed due to horizontal pipes.

## Day 11 - Turing Plus

While Modula was compiling yesterday, I prepared another language as a backup, which I ended up using today.
Turing Plus is decent, does its job.
I liked the support for dynamic arrays and no hassle input and output.

Immediately after reading the task, I knew how to represent the galaxy - list of points and list of sizes of rows and columns in prefix arrays.
This allows to compute distances in constant time.
The second part was expected and easy.
I just had to switch from using ints to reals because my poor ints overflowed.

## Day 12 - Guile

Another dialect of Lisp/Scheme.
How easy it is to get lost in the parentheses.
I missed some basic functions like fold, zip, flatten.
The input processing was also hard until I figured out that I can use non-existing delimiter and just read the whole file at once.

I knew that I will need to use dynamic programming for this task.
The algorithm is pretty easy but has lots of details of counting indices.
The languages where even simpest arithmetics needs tripple checking did not help.
The more I was surprised that it worked on the first trial.
The second part was then just a trivial extension.

## Day 13 - Fish

More modern implementation of shell; I like it.
There is no need for awkward quoting, subshells are easier too.
The built-in commands are powerful enough to be generally useful.

After preview task that was rather hard, this was an easy one.
Even the twist with one smudge was solvable with just replacing the comparison function and employing a tiny regexp.

## Day 14 - Swift (parallel scripting language)

It is hard to program with single assignment to variables.
All things can be emulated via recursion but some are too painful.
On top of that, the language is ridiculously slow while it is at the same time trying to melt the CPU.
It manages to perform about 3 cycles a minute but if I add extra length checks that force synchronization, it runs twice as fast.
I also found a bug in the compiler, where it incorrectly  detects cicular dependency between procedures.

The task required just simple walk through 2D array and computing the result of the tilt.
The second wants again to find a period and apply it to find a value too far in the future.
I looked for the period manually.

## Day 15 - High Level Assembly

Seamingly nice language, has huge documentation but few examples.
It assumes lots of prior knowledge.
Some errors are cryptical and often stem from sinly such instruction not existing.

I was excited about the task because that hash calculation will be so easy in assembly.
Just process it character at a time, no memory management.
I hugely underestimated the second part.
That required pretty much complete rework.
I had to implement linked lists in assembly.

## Day 16 - Reason

Quite pleasant language with rich enough library and documentation.
It is not completely functional but it is reasonably close.
The only negative was that it does not have a generic print function for debugging.

The task was quite simple flood algorithm, in my case implemented using a stack.
I reused the idea of bitsets to mark from which direction a beam comes to a tile.
The second part was easier than expected; I assumed that we will be tilting mirrors again.

## Day 17 - Pizza

Pizza is a dead branch of Java.
From today's perspective it does not bring much new.
It goes a bit further with algebraic data types and functions but modern Java probably does it better.
Its tiny library has quite archaic and inconvenient API.

I did not attempt to implemet any sophisticated algorithm, just flooding with a queue.
But I focused on modeling of the task, which paid off in the second part, where it was trivial to extend.

## Day 18 - Xtend

The language tries to fix some issues of Java, some successfully.
For example the idea that everything is an expression is nice.
But its main feature extension function are quite meh.

The idea of colors made me implement a simple array-based map with some flood-filling.
This turned out to be bad and needed to be reimplemented for the second task.
Counting how much the trench adds to the area was interesting.

## Day 19 - F#

Like a lot of other functional languages, once it compiles, it usually gives the correct answer.
F# is really nice, only lacking on some bits of documentation where it refers to C#.
I wonder if there is syntax for record field accessor function.

I liked the task; it was worth saving a nice functional language for it.
The representation of the domain was easy in F# and none of the algorithms were hard either.

## Day 20 - CLIPS

I came accross this language last year but it was too late.
I bough the physical book and studied it extensively.
It feels like one step further than Prolog - you communicate between predicates via facts.
The language is pretty decent, just the string library could be richer.

The simulation was fun, debugging signals was easy with the rule-based program.
It was also easy to add intercepting rules for the second part where again the least common multiple needed to be found.

## Day 21 - LEAN

I came accross this language when looking at F\*.
It quite nicely extends pretty ordinary functional language with proofs.
I struggled with working with Fin arithmetics, so I just used Nat.

I implemented the first part with Arrays but Lists proved to be faster.
The second part utlized the fact that we are searching in a square.
We just need to compute how many of those squares of each particular type are fully enclosed.

## Day 22 - C#

After waisting at least a day trying two languages, I settled for something easy.
C# is quite pleasant but compared to Java (especially after 17) it has little to offer.
Its naming convention and code style will forever feel foreign.

Representation was half of success in this task.
A simple recursive algorithm worked and no sophisticated graph traversal was needed.

## Day 23 - TypeScript

I hope that the last two days wil be easy; I don't have ny convenient language left.
TypeScript really elevates JavaScript to a usable language.
There are a few hickups (such as typing object decomposition) and weird enums, but overall good.

I simply implemented a stack-based walkk-through.
Instead of returning and picking up crumbs, I instead remembered which sections belong to the valid path.
The second part ran slowly but it finished while I was taking a break to eat.

## Day 24 - VB.Net

Visual Basic is just a verbose cousin of C#; there is little reason to use it because of that.
On the other hand it automatically provides very rich library to those who migrate from some Basics.

Nice repetition of linear algebra from school.
The first part was just easy manipulation with lines.
I was worried that some lines could be parallel with the exes, so my solution is a bit more precise.
I also did need to divide anywhere and since the velocities were small, it worked fine.
The second part was a beast.
At first sight it looked like a system of non-linear equations but a clever substitution makes it linear.
The extra variable is compensated by having more input data that needed.
I had to implement rational numbers and matrix-based solution of system of linear equations.
At least the system was fairly small, just 5 variables.

# Lists

## Language pool

- Csh
- Inform 7
- m4
- MUMPS
- TeX

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
- C#
- Ceylon
- Chapel
- CLIPS
- Closure
- Cobol
- Cobra
- CoffeeScript
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
- F#
- Factor
- Fantom
- FGHC
- Fish
- Flix
- Forth
- Fortran
- Gambas
- Genie
- Go
- Golo
- Gosu
- Groovy
- Guile
- Hare
- Haskell
- Haxe
- High Level Assembly
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
- Lean
- (Common)Lisp
- (UCB)Logo
- Lua
- Matlab (Octave)
- Mercury
- Minizinc
- Modula-2
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
- Pizza
- Pony
- PostScript
- Powershell
- (SWI)Prolog
- PureScript
- Python
- R
- Racket
- Raku
- Reason
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
- Swift (parallel scripting language)
- TCL
- TypeScript
- Turing Plus
- TXL
- Unison
- Vala
- VB.Net
- Vim Script
- XSLT
- Xtend
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
- FoxPro - not for Linux
- ActionScript - Cannot be downloaded
- Eta - too close to Haskell on JVM
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
- Ksh - too close to a regular Shell/Bash
- Whiley - cannot handle input
- Cool - school course, does not exists
- eC - almost no documentation
- ParaSail - could not figure out standard library (input)
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
- J# - discontinued
- Wyvern - too poor documentation
- Hamler - did not manage to build
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
- Occam - cannot build; compilation error
- Emojicode - fails to compile
- Fetlang - does not have functions, jump nor pointers
- J - installs but does not seem to work
- Umple - not a programming language, used for modeling
- o:XML - very abandoned, 404, no idea how to execute
- WolframScript - requires account
- harbour - fails to build
- CDuce - seems to be incompatible with newer version of OCaml
- Samora - barely works; does not parse any more advanced program
- Sather - does not compile
- Hack - does not compile
- NESL - does not compile; and issues with Common Lisp after fixing C
- Zonnon - website does not load, probably does not exist anymore
- Tea - archived; cannot be downloaded
- ATS - cannot install, fails to build
- Constraint Handling Rules - not standalone
- PL/I - did manage to compile example but not to run it
- LFE - not even the hello world works
- LogTalk - could not figure out input and parsing strings
- Oz, Mozart - cannot figure how to use I/O
- F* - no description of library and I/O
- Coq - cannot figure I/O
- Dafny - does not have I/O library yet
- Pict - cannot compile, prebuild has old dependencies on libc
- Whiley - has no way to process input yet
- Pure - requires different version of LLVM which fails to compile
- Joy - does not compile, almost no documentation
- Misty - no I/O yet
