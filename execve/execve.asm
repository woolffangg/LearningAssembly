sys_execve equ 59
sys_exit equ 60
sys_write equ 1
sys_open equ 2
sys_read equ 0

global _start

; /bin/bash -c find / -iregex ".*\.\(xls\|csv\|pdf\|docx\)" -print0 2>>/dev/null 1>> output.txt 
section .bss
    buffer resb 20000
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


parent_process:

    MOV RAX, sys_open
    MOV RDI, filename
    MOV RSI, 0
    SYSCALL

    MOV RDI, RAX
    MOV RAX, sys_read
    LEA RSI, buffer
    MOV RDX, 20000
    SYSCALL

    CALL EXIT



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

