global _start

section .text


_start:

	mov rax, 1
	mov rdi, 1
	mov rsi, my_string
	mov rdx, my_string_length
	SYSCALL

	MOV rax, 60
	xor rdi,rdi
	SYSCALL

section .data

	my_string: DB "Hello World",0x0A, 0x00
	my_string_length: EQU  0x0D
