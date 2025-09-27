sys_execve equ 59
sys_exit equ 60
sys_write equ 1
sys_open equ 2
sys_read equ 0
sys_wait4 equ 61

global _start

; /bin/bash -c find / -iregex ".*\.\(xls\|csv\|pdf\|docx\)" -print0 2>>/dev/null 1>> output.txt 
section .bss
    buffer resb 900000
    bufferfile resb 999999999
    status resq 1
section .data

    arg0 DB "/bin/bash", 0
    arg1 DB "-c", 0
    arg2 DB 'find / -iregex ".*\.\(xls\|csv\|pdf\|docx\)" -print0 2>>/dev/null 1>> output.txt', 0
    envp DQ 0
    
    argv DQ arg0, arg1, arg2, 0 
    filename DB "output.txt",0
    
    

section .text

_start:

    MOV RAX, 57
    SYSCALL

;syscall pour execve
    CMP EAX, 0
    JZ child_process
    Call parent_process

process_path:
    ; R10 = début du buffer
    ; R11 = chemin courant du premier fichier
    ; RCX = fin du buffer

    cmp R11, RCX
    jge EXIT
    CALL next_path

next_path:
    mov al, [R10]
    test al,al
    JE increment
    inc r10
    CALL next_path

increment:
    inc r10
    CALL Open_path

Open_path:
    MOV R11, R10
    MOV RAX, sys_open
    MOV RDI, R11
    MOV RSI, 0
    SYSCALL
    CALL Read_path

Read_path:
    MOV RDI, RAX
    MOV RAX, sys_read
    LEA RSI, bufferfile
    MOV RDX, 999999999
    SYSCALL
    CALL process_path

parent_process:

    mov rbx, rax        ; Sauvegarde le PID de l'enfant
    mov rax, sys_wait4
    mov rdi, rbx        ; PID de l'enfant à attendre
    mov rsi, status     ; Pointeur vers le status
    mov rdx, 0          ; Options
    mov r10, 0          ; Pointeur vers rusage (NULL)
    SYSCALL

    MOV RAX, sys_open
    MOV RDI, filename
    MOV RSI, 0
    SYSCALL

    MOV RDI, RAX
    MOV RAX, sys_read
    LEA RSI, buffer
    MOV RDX, 20000
    SYSCALL
    LEA R10, [rel buffer] ;début du buffer
    LEA R11, [rel buffer] ;chemin courant du premier fichier
    LEA RCX, [buffer + rax] ;Fin du buffer
    Call Open_path



child_process:
    MOV RAX, sys_execve
    MOV RDI, arg0 ;Filename
    LEA RSI, [rel argv] ;const char *const *argv
    LEA RDX, [rel envp] ;envp
    SYSCALL
    call EXIT


EXIT:
    MOV RAX, sys_exit
    XOR RDI, RDI
    SYSCALL

