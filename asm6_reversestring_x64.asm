%include 'io_x64.asm'
extern ExitProcess

section .data
    msg1    db  "Enter string: ", 0xA, 0x0
    msg2    db  "Reverse string: ", 0xA, 0x0

section .bss
    string      resb 256
    res         resb 256

section .text
    global Start

Start:
    ; enter string
    sub rsp, 32
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, string
    mov rdx, 256
    call readStr
    add rsp, 32

    ; reverse string
    sub rsp, 32
    mov rcx, string
    mov rdx, res
    call reverse_string
    add rsp, 32

    ; print reverse string
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

; Reverse string
; Input:
;   %rcx: char* - string to reverse
;   %rdx: char* - store string after reverse
; Output: none
reverse_string:
    reverse_init:
        push rbp
        mov rbp, rsp

        ; change calling convention
        mov rdi, rcx
        mov rsi, rdx

        xor rax, rax
        xor rcx, rcx    ; for count characters
    
    next_char:
        mov al, [rdi]   ; get character
        ; if character is null or enter
        cmp al, 0x0     
        je reverse
        cmp al, 0xA
        je reverse
        push rax    ; push character to stack
        inc rdi     ; next character
        inc rcx     ; inc count
        jmp next_char
    
    reverse:
        pop rax     ;get charcater from stack
        mov [rsi], rax  ; mov to end string
        inc rsi     ; next position in end string
        loop reverse
    
    reverse_done:
        mov rsp, rbp
        pop rbp
        ret