global _start

section .data

	filetoopen DB "/home/kali/Documents/LearningAssembly/OpenFile/LoremIpsum", 0

section .bss
	buffer resb 50000

section .text

_start:

;OpenFile
	MOV RAX, 257
	MOV RDI, -100
	LEA RSI, [rel filetoopen]
	XOR RDX, RDX ;readOnly = 0
	XOR R10, R10 ;mode = 0 utile si pas en readOnly
	SYSCALL

;READ
	MOV RDI, RAX ;Le file description présent dans RAX après le SYSCALL Openat
	MOV RAX, 0
	LEA rsi, [rel buffer]
	MOV RDX, 40000
	SYSCALL
;Exit
	MOV RAX, 60
	XOR RDI, RDI
	SYSCALL


