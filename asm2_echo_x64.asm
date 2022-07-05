
%include 'io_x64.asm'
extern ExitProcess

section .data
    msg1    db  "Enter string: ", 0xA,0x0
    msg2    db  "String entered is: ", 0xA,0x0

section .bss
    res     resb 32

section .text
	global Start

Start:
    ; enter string
    sub rsp, 32 ; for shadow space
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, res
    mov rdx, 32
    call readStr
    add rsp, 32

    ;Print string
    sub rsp, 32
    mov rcx, msg2
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, res
    call printStr
    add rsp, 32

exit:
    xor rcx, rcx
    call ExitProcess    ; call exit from win api