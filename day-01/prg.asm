; 1. User-level applications use as integer registers for passing the sequence %rdi, %rsi, %rdx, %rcx, %r8 and %r9.
;    The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9.
; 2. A system-call is done via the syscall instruction. The kernel destroys registers %rcx and %r11.
; 3. The number of the syscall has to be passed in register %rax.
; 4. System-calls are limited to six arguments, no argument is passed directly on the stack.
; 5. Returning from the syscall, register %rax contains the result of the system-call. 
;    A value in the range between -4095 and -1 indicates an error, it is -errno.

global _start

section .text   

_start:
  ; current - 48
  xor r12, r12
  push r12
  
  xor r13, r13
  
  ;; first part
  
  ; first - 40
  mov r12, 12345
  push r12
  ; last - 32
  xor r12, r12
  push r12
  ; sum - 24
  xor r12, r12
  push r12
  
  ;; second part
  
  ; first - 16
  mov r12, 12345
  push r12
  ; last - 8
  xor r12, r12
  push r12
  ; sum - 0
  xor r12, r12
  push r12

read:

  ; read one char into stack
  mov rax, 0 ; read
  mov rdi, 0 ; stdin
  mov rsi, rsp ; stack
  add rsi, 48
  mov rdx, 1 ; 1 byte
  syscall
  
  cmp rax, 0
  jz eof
  
  mov r12, [rsp + 48]
  
  cmp r12, 48
  jl newline
  
  cmp r12, 57
  jg letter
  
  mov r14, r12
  
  xor r13, r13
  
digit:
  
  ; update last
  
  cmp r12, 57
  jg update_last_2
  
  mov [rsp + 32], r12
  sub qword [rsp + 32], 48
  
update_last_2:
  
  mov [rsp + 8], r14
  sub qword [rsp + 8], 48
  
  ; update first
  
  cmp r12, 57
  jg have_first_1
  
  cmp qword [rsp + 40], 12345
  jl have_first_1
  
  mov [rsp + 40], r12
  sub qword [rsp + 40], 48

have_first_1:

  cmp qword [rsp + 16], 12345
  jl have_first_2
 
  mov [rsp + 16], r14
  sub qword [rsp + 16], 48

have_first_2:

  jmp read

letter:

  shl r13, 8
  add r13, r12
  
  mov r14, r13
  mov r15, 0xffffff
  and r14, r15 
  
  mov r15, 0x6f6e65 ; one
  cmp r14, r15
  jne not_one
  
  mov r14, 49
  jmp digit
  
not_one:

  mov r15, 0x74776f ; two
  cmp r14, r15
  jne not_two
  
  mov r14, 50
  jmp digit
  
not_two:

  mov r15, 0x736978 ; six
  cmp r14, r15
  jne not_six
  
  mov r14, 54
  jmp digit

not_six:

  mov r14, r13
  mov r15, 0xffffff
  shl r15, 8
  or r15, 0xff
  and r14, r15
  
  mov r15, 0x666f75 ; fou
  shl r15, 8
  or r15, 0x72
  cmp r14, r15 
  jne not_four
  
  mov r14, 52
  jmp digit

not_four:

  mov r15, 0x666976 ; fiv
  shl r15, 8
  or r15, 0x65
  cmp r14, r15
  jne not_five
  
  mov r14, 53
  jmp digit
  
not_five:

  mov r15, 0x6e696e ; nin
  shl r15, 8
  or r15, 0x65
  cmp r14, r15
  jne not_nine
  
  mov r14, 57
  jmp digit
  
not_nine:

  mov r14, r13
  mov r15, 0xffffff
  shl r15, 16
  or r15, 0xffff
  and r14, r15
  
  mov r15, 0x746872 ; thr
  shl r15, 16
  or r15, 0x6565
  cmp r14, r15
  jne not_three
  
  mov r14, 51
  jmp digit

not_three:

  mov r15, 0x736576 ; sev
  shl r15, 16
  or r15, 0x656e
  cmp r14, r15
  jne not_seven
  
  mov r14, 55
  jmp digit

not_seven:

  mov r15, 0x656967 ; eig
  shl r15, 16
  or r15, 0x6874
  cmp r14, r15
  jne not_eight
  
  mov r14, 56
  jmp digit
  
not_eight:

  jmp read
  
newline:
  mov rax, [rsp + 40]
  mov r12, 10
  mul r12
  add rax, [rsp + 32]
  add [rsp + 24], rax
  
  mov qword [rsp + 40], 12345
  
  mov rax, [rsp + 16]
  mov r12, 10
  mul r12
  add rax, [rsp + 8]
  add [rsp + 0], rax
  
  mov qword [rsp + 16], 12345
  
  xor r13, r13
  
  jmp read

eof:

  mov r14, 1
  mov r15, [rsp + 24]
  
print:

  cmp r15, 1
  jl print0
  
  cmp r15, 10
  jl print1
  
  cmp r15, 100
  jl print2
  
  cmp r15, 1000
  jl print3
  
  cmp r15, 10000
  jl print4
  
  cmp r15, 100000
  jl print5
    
  jmp print6
  
print0:

  add rax, 48
  mov [rsp + 48], rax
  
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  mov rdx, 1
  syscall
  
  jmp printed
  
print6:
  
  mov r12, 100000
  mov rax, r15
  xor rdx, rdx
  div r12
  mov r15, rdx
  
  add rax, 48
  mov [rsp + 48], rax
  
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  add rsi, 48
  mov rdx, 1
  syscall
  
print5:
  
  mov r12, 10000
  mov rax, r15
  xor rdx, rdx
  div r12
  mov r15, rdx
  
  add rax, 48
  mov [rsp + 48], rax
  
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  add rsi, 48
  mov rdx, 1
  syscall

print4:
  
  mov r12, 1000
  mov rax, r15
  xor rdx, rdx
  div r12
  mov r15, rdx
  
  add rax, 48
  mov [rsp + 48], rax
  
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  add rsi, 48
  mov rdx, 1
  syscall
  
print3:
  
  mov r12, 100
  mov rax, r15
  xor rdx, rdx
  div r12
  mov r15, rdx
  
  add rax, 48
  mov [rsp + 48], rax
  
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  add rsi, 48
  mov rdx, 1
  syscall
  
print2:
  
  mov r12, 10
  mov rax, r15
  xor rdx, rdx
  div r12
  mov r15, rdx
  
  add rax, 48
  mov [rsp + 48], rax
  
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  add rsi, 48
  mov rdx, 1
  syscall 
  
print1:
  
  mov rax, r15
  add rax, 48
  mov [rsp + 48], rax
  
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  add rsi, 48
  mov rdx, 1
  syscall

  jmp printed
  

printed:

  mov qword [rsp + 48], 10

  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  add rsi, 48
  mov rdx, 1
  syscall



  inc r14
  
  cmp r14, 3
  je end
  
  mov r15, [rsp + 0]
  jmp print

end:

  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );
