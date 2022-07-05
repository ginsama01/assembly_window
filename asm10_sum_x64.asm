; Sample input:
; 74 2881 23 471 8824
; Sample output:
; Sum of old numbers: 
; 3375
; Sum of even numbers: 
; 8898

%include 'io_x64.asm'
extern ExitProcess

section .data
    msg1    db  "Sum of old numbers: ", 0xA, 0x0

    msg2    db  "Sum of even numbers: ", 0xA, 0x0

    newline db  "", 0xA, 0x0

section .bss
    digit   resb 1
    sum1    resb 13
    sum2    resb 13

section .text
    global Start

Start:
    call read_array
    
    ; print sum of old numbers
    sub rsp, 32
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, [sum1]
    mov rdx, sum1
    call decimal_to_string
    add rsp, 32

    sub rsp, 32
    mov rcx, sum1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, newline
    call printStr
    add rsp, 32

    ; print sum of even numbers
    sub rsp, 32
    mov rcx, msg2
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, [sum2]
    mov rdx, sum2
    call decimal_to_string
    add rsp, 32

    sub rsp, 32
    mov rcx, sum2
    call printStr
    add rsp, 32

exit:
    xor rcx, rcx
    call ExitProcess    ; call exit from win api


; Read array then calculate sum of old, even
; Input: none
; Output: none
read_array:
    read_init:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        %define isOld   rbp - 8

        mov qword [sum1], 0
        mov qword [sum2], 0

    read_start:
        xor rax, rax
        xor rdx, rdx
        xor r8, r8

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
        je read_check
        cmp rcx, " "    ; if space character
        je read_check
        
        sub cl, 0x30
        push rcx
        mov rcx, 10 
        mul rcx
        pop rcx     
        add rax, rcx

        ; check even or old
        cmp cl, 0
        je even
        cmp cl, 2
        je even
        cmp cl, 4
        je even
        cmp cl, 6
        je even
        cmp cl, 8
        je even
        mov qword [isOld], 1
        jmp read_num

    even:
        mov qword [isOld], 0
        jmp read_num

    read_check:
        ; if number is old
        cmp qword [isOld], 1
        je add_old

    add_even:
        add qword [sum2], rax
        ; check if enter character
        cmp rcx, 0xD
        je done_read
        jmp read_start

    add_old:
        add qword [sum1], rax
        ; check if enter character
        cmp rcx, 0xD
        je done_read
        jmp read_start

    done_read:
        add rsp, 8
        mov rsp, rbp
        pop rbp
        ret