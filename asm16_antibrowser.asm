
NULL        equ 0
STD_OUTPUT_HANDLE equ -11
extern EnumWindows 
extern ExitProcess
extern GetStdHandle
extern WriteConsoleA
extern GetWindowTextA
extern GetClassNameA

section .data
    msg2    db "Hello", 0xa, 0xd, 0x0
    len2    equ $ -msg2
    newline db  0xa, 0x0
    lennl   equ $ - newline
section .bss
    EnumWinProc     resq 1
    lpNumberOfCharsWritten resb 32
    lpString        resb 31


section .text
    global Start

Start:
    sub rsp, 32
    mov rcx, EnumWindowsProc
    mov rdx, 0
    call EnumWindows
    add rsp, 32
    xor rcx, rcx
    call ExitProcess

%define hWnd        RBP + 16
%define lParam      RBP + 24
EnumWindowsProc:
    push rbp
    mov rbp, rsp

    mov qword [hWnd], rcx
    mov qword [lParam], rdx

    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, lpString
    mov r8, 30
    call GetClassNameA
    add rsp, 32

    

    sub rsp, 40
    mov rcx, rax
    mov rdx, lpString
    mov r8, 30
    mov r9, lpNumberOfCharsWritten
    mov qword [rsp + 32], NULL
    call WriteConsoleA
    add rsp, 40

    sub rsp, 32
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    add rsp, 32

    sub rsp, 40
    mov rcx, rax
    mov rdx, newline
    mov r8, lennl
    mov r9, lpNumberOfCharsWritten
    mov qword [rsp + 32], NULL
    call WriteConsoleA
    add rsp, 40
    mov rsp, rbp
    pop rbp
    mov rax, 1
    ret 