Install nasm and ld 

Run:
```
nasm -f elf64 -o prg.o prg.asm
ld -o prg prg.o
./prg <input
```
