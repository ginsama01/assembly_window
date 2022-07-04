; Assemble: nasm -f win64 asm1_hello_x64.asm -o asm1_hello_x64.obj
; Link: GoLink.exe /console asm1_hello.obj kernel32.dll user32.dll
; Execute: asm1_hello_x64.exe

NULL        equ 0
STD_OUTPUT_HANDLE equ -11
section	.text	     ;Code Segment
   global Start     ;must be declared for linker (ld)

extern ExitProcess, GetStdHandle, WriteConsoleA                 ; from library

Start:	   ;tells linker entry point

    sub rsp, 32 ; for shadow space
    mov rcx, STD_OUTPUT_HANDLE    ; first parameter
    call GetStdHandle   ; Retrieves a handle to the specified standard device (standard input, standard output, or standard error).  
    add rsp, 32

    sub rsp, 40 ; shadow space for 5 parameters
    mov rcx, rax ;rax is output of GetStdHandle, mov to rcx, it's first parameter of WriteConsoleA, a handle to the console screen buffer.
    mov rdx, msg ; A pointer to a buffer that contains characters to be written to the console screen buffer
    mov r8, len ; The number of characters to be written.
    mov r9, lpNumberOfCharsWritten ; A pointer to a variable that receives the number of characters actually written.
    mov qword [rsp + 4 * 8], NULL ; lpReserved Reserved; must be NULL.
    call WriteConsoleA ; Writes a character string to a console screen buffer beginning at the current cursor location.
    add rsp, 40

    push NULL
    call ExitProcess    ; call exit from win api

section	.data       ;Data Segment
    msg db 'Hello, World!', 0xa, 0xD, 0x0  ;string to be printed
    len equ $ - msg     ;length of the string, $ means the current location,
		    ;so subtract the location of the msg, we have len of msg

section .bss
    lpNumberOfCharsWritten resb 32

