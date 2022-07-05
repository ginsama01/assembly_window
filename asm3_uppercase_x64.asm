
%include 'io_x64.asm'
extern ExitProcess
section .data
    msg1    db  "Enter string: ", 0xA,0x0

    msg2    db  "Uppercase string is: ", 0xA,0x0

section .bss
    inp_str resq 4

section .text
    global Start

Start:
    
    ; Enter input string
    sub rsp, 32 ; for shadow space
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, inp_str
    mov rdx, 32
    call readStr
    add rsp, 32

    ; Uppercase string
    mov rcx, inp_str    ; move address of inp_str to rcx register
    call upper_string

    ; print uppercase string
    sub rsp, 32 ; for shadow space
    mov rcx, msg2
    call printStr
    add rsp, 32

    sub rsp, 32 ; for shadow space
    mov rcx, inp_str
    call printStr
    add rsp, 32

exit:
	xor rcx, rcx
    call ExitProcess    ; call exit from win api

; upper string
; input:
;   %rcx: char* - string to upper
; output:
; none
upper_string:
    upper_init:
        push rbp
        mov rbp, rsp
    
    upper_main:
        mov al, [rcx]   ; rcx is the pointer, so [rcx] is the current char
        cmp al, 0x0     ; check if al is null, it means end of string
        je upper_done         
        cmp al, 'a'     ; check if current char >= 'a' character, if no, go next character
        jb upper_next_char
        cmp al, 'z'     ; check if current char <= 'a' character, if no, go next character
        ja upper_next_char
        sub al, 0x20    ; move AL upper case, the distance between 
                        ; uppercase and lowercase letters is 20h in ASCII
        mov [rcx], al   ; write current character back to string, then go to nextChar

    upper_next_char:
        inc rcx         ; rcx is pointer to inp_str, so inc rcx means point to next char
        jmp upper_main

    upper_done:
        mov rsp, rbp
        pop rbp
        ret             ; return to position that upperString was called
