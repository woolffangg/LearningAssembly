
section .bss
	buffer resb  8

section .data
	message DB "Inserer votre entier: ", 0
	message_length equ $ - message

section .text

global _start


_start:

;write
	MOV RAX, 1
	MOV RDI, 1
	MOV RSI, message
	MOV RDX, message_length
	SYSCALL
;read

	MOV RAX, 0
	MOV RDI, 0
	MOV RSI, buffer
	MOV RDX, 8
	SYSCALL

	MOV R10b, byte[buffer]
	ADD R10, 10

Loop:
	CMP byte[buffer], R10b
	JAE EXIT
;write du buffer

	MOV RAX, 1
	MOV RDI, 1
	XOR RSI,RSI
	MOV rsi, buffer
	MOV RDX, 8
	SYSCALL

	MOV R9b, byte[buffer]
	ADD R9, 1
	MOV byte[buffer], R9b
	JMP Loop

EXIT:
;exit
	MOV RAX, 60
	XOR RDI,RDI
	SYSCALL
