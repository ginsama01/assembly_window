; Assemble: nasm -f win32 asm1_hello.asm -o asm1_hello.obj
; Link: GoLink.exe /console asm1_hello.obj kernel32.dll user32.dll
; Execute: asm1_hello.exe

NULL        equ 0
STD_OUTPUT_HANDLE equ -11
section	.text	     ;Code Segment
   global Start     ;must be declared for linker (ld)

extern ExitProcess, GetStdHandle, WriteConsoleA                 ; from library

Start:	            ;tells linker entry point
    push STD_OUTPUT_HANDLE
    call GetStdHandle   ; 1 parameters, output to eax

    push NULL
    push lpNumberOfCharsWritten
    push len
    push msg
    push eax
    call WriteConsoleA  ; call winapi, 5 parameters

    push NULL
    call ExitProcess    ; call exit from win api

section	.data       ;Data Segment
    msg db 'Hello, World!', 0xa  ;string to be printed
    len equ $ - msg     ;length of the string, $ means the current location,
		    ;so subtract the location of the msg, we have len of msg

section .bss
    lpNumberOfCharsWritten resb 32
