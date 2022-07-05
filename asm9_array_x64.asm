; Sample input
; 6777 7117 6627 12664 8818
; Max number: 
; 12664
; Min number: 
; 6627
%include 'io_x64.asm'
extern ExitProcess

section .data
    msg1    db  "Max number: ", 0xA, 0x0

    msg2    db  "Min number: ", 0xA, 0x0

    newline db  "", 0xA, 0x0

section .bss
    digit   resb 11
    min     resb 11
    max     resb 11
    
section .text
    global Start

Start:
    ; read array in decimal then find min, max
    call read_array
    
    ; print max
    sub rsp, 32
    mov rcx, [max]
    mov rdx, max
    call decimal_to_string
    add rsp, 32

    sub rsp, 32
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, max
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, newline
    call printStr
    add rsp, 32

    ; print min
    sub rsp, 32
    mov rcx, [min]
    mov rdx, min
    call decimal_to_string
    add rsp, 32

    sub rsp, 32
    mov rcx, msg2
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, min
    call printStr
    add rsp, 32


exit:
    xor rcx, rcx
    call ExitProcess    ; call exit from win api

; Read array then find min, max
; Input: none
; Output: none
read_array:
    read_init:
        push rbp
        mov rbp, rsp

        mov qword [max], 0
        mov qword [min], 0xffffffffffffffff

    read_start:
        xor rax, rax
        xor rdx, rdx

    read_num:
        ; read array element digit by digit
        push rax
        sub rsp, 32
        mov rcx, digit
        mov rdx, 1
        call readStr
        add rsp, 32

        pop rax
        
        xor rcx, rcx
        mov cl, [digit]
        cmp rcx, 0xD    ; if enter character
        je check_min
        cmp rcx, " "    ; if space character
        je check_min
        
        sub cl, 0x30
        push rcx
        mov rcx, 10 
        mul rcx
        pop rcx     
        add rax, rcx
        jmp read_num


    check_min:
        ; if number < min
        cmp rax, qword [min]
        jb update_min

    check_max:
        cmp rax, qword [max]
        ja update_max
        ; check if enter character
        cmp rcx, 0xD
        je done_read
        jmp read_start

    update_min:
        mov qword [min], rax
        jmp check_max

    update_max:
        mov qword [max], rax
        ; check if enter character
        cmp rcx, 0xD
        je done_read
        jmp read_start

    done_read:
        mov rsp, rbp
        pop rbp
        ret