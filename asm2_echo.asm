; Assemble: nasm -f win32 asm2_echo.asm -o asm2_echo.obj
; Link: GoLink.exe /console asm2_echo.obj kernel32.dll user32.dll
; Execute: asm2_echo.exe

NULL                equ 0
STD_OUTPUT_HANDLE   equ -11
STD_INPUT_HANDLE    equ -10

section .data
    msg1    db  "Enter string: ", 0xA,0xD
    len1    equ $- msg1

    msg2    db  "String entered is: ", 0xA,0xD
    len2    equ $- msg2

section .bss
    res     resb 32
    lpNumberOfCharsRead resb 32
    lpNumberOfCharsWritten resb 32

section .text
	global Start

extern ExitProcess, GetStdHandle, WriteConsoleA, ReadConsoleA

Start:
    ; Input string
    push STD_INPUT_HANDLE
    call GetStdHandle
    push NULL
    push lpNumberOfCharsRead
    push 32
    push res
    push eax
    call ReadConsoleA

    ;Print string
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    push NULL
    push lpNumberOfCharsWritten
    push 32
    push res
    push eax
    call WriteConsoleA

    push NULL
    call ExitProcess
 