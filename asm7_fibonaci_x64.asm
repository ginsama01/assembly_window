%include 'io_x64.asm'
extern ExitProcess

section .data
    msg1    db  "Enter n ", 0xA, 0x0
    first_fibo  db "0 ", 0x0
    second_fibo db "1", 0x0
    space   db " ", 0x0

section .bss
    n           resb 8

section .text
    global Start

Start:
    ; read n and convert to decimal
    sub rsp, 32
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, n
    mov rdx, 8
    call readStr
    add rsp, 32

    sub rsp, 32
    mov rcx, n 
    call string_to_decimal
    mov [n], rax
    add rsp, 32

    ; print first fibo
    mov rax, [n]
    cmp rax, 1
    jb exit


    sub rsp, 32
    mov rcx, first_fibo
    call printStr
    add rsp, 32
    
    ; print second fibo
    mov rax, [n]
    cmp rax, 2
    jb exit

    sub rsp, 32
    mov rcx, second_fibo
    call printStr
    add rsp, 32

    ; calculate fibonacci and print
    sub rsp, 32
    mov rcx, [n]
    call cal_fibo
    add rsp, 32

exit:
    xor rcx, rcx
    call ExitProcess    ; call exit from win api


; Calculate fibonacci and print
; Input: 
;   %rcx: int - n-th fibonacci
; Output: none
cal_fibo:
    push rbp
    mov rbp, rsp
    ; for local variable
    sub rsp, 98
    %define num1    rbp - 30
    %define num2    rbp - 60
    %define sum     rbp - 90
    %define nnum    rbp - 98
    ; compare if n >= 3
    mov qword [nnum], rcx
    cmp qword [nnum], 3
    jb cal_done
    
    ; Have printed first and second fibo
    dec qword [nnum]
    dec qword [nnum]

    ; init fibo[n-1]
    mov qword [num2], 31h
    ; fibo[n-2]
    mov qword [num1], 30h
    
    
    cal_loop:
        sub rsp, 32
        lea rcx, [num1]
        lea rdx, [num2]
        lea r8, [sum]
        call calculate_sum
        add rsp, 32

        ; print fibonacci
        sub rsp, 32
        mov rcx, space
        call printStr
        add rsp, 32

        sub rsp, 32
        lea rcx, [sum]
        call printStr
        add rsp, 32
        
        ; num1 = num2
        sub rsp, 32
        lea rcx, [num2]
        lea rdx, [num1]
        call move
        add rsp, 32

        ; num2 = sum
        sub rsp, 32
        lea rcx, [sum]
        lea rdx, [num2]
        call move
        add rsp, 32

        ; check how many fibo need to calculate
        dec qword [nnum]
        cmp qword [nnum], 0
        je cal_done
        jmp cal_loop


    cal_done: 
        add rsp, 90
        mov rsp, rbp
        pop rbp
        ret

; Move from offset to offset
; Input:
;   %rcx: first offset
;   %rdx: second offset = first offset
; Output: none
move:
    push rbp
    mov rbp, rsp
    
    loop_move:
        xor rax, rax
        mov al, [rcx]
        cmp al, 0x0
        je done_move
        cmp al, 0xD
        je done_move
        mov [rdx], al
        inc rcx
        inc rdx
        jmp loop_move

    done_move:
        mov byte [rdx], 0x0
        mov rsp, rbp
        pop rbp
        ret


; Calculate sum of two string number
; Input:
;   %rcx: char* - first number
;   %rdx: char* - second number
;   %r8: char* - will store sum
; Output:
;   none
calculate_sum:
    push rbp
    mov rbp, rsp
    sub rsp, 60
    ; local variable
    %define num1 rbp - 30
    %define num2 rbp - 60
    
    ; change calling convention
    mov rdi, rcx
    mov rsi, rdx
    mov rdx, r8
    mov rbx, rdx

    ; num1 = rcx
    sub rsp, 32
    lea rdx, [num1]
    call move
    add rsp, 32

    ; num2 = rdx parameter
    sub rsp, 32
    mov rcx, rsi
    lea rdx, [num2]
    call move
    add rsp, 32

    ; calculate length of two string number
    sub rsp, 32
    lea rcx, [num1]
    call strlen
    add rsp, 32
    mov rsi, rax    ; store length of first number to rsi

    sub rsp, 32
    lea rcx, [num2]
    call strlen
    add rsp, 32
    mov rdi, rax    ; store length of second number to rdi

    mov rdx, rbx
    xor rax, rax
    xor rcx, rcx
    xor r9, r9      ; r9 for carry

    add_loop:
        ; if length of first number = 0
        cmp rsi, 0
        je add_case1
        ; if length of second number = 0
        cmp rdi, 0
        je add_case2

        ; get digit
        dec rsi
        dec rdi
        mov al, [num1 + rsi]
        sub al, 0x30
        mov bl, [num2 + rdi]
        sub bl, 0x30
        add al, bl
        add rax, r9  ; add carry
        cmp al, 10
        jae add_loop_carry
        xor r9, r9  ; set carry = 0
        jmp add_loop_continue

    add_loop_carry:
        mov r9, 1   ; set carry = 1
        sub al, 10

    add_loop_continue:
        add al, 0x30
        push rax
        inc rcx
        jmp add_loop

    add_case1:
        cmp rdi, 0
        je check_carry
        dec rdi
        mov al, [num2 + rdi]
        sub al, 0x30
        add rax, r9  ; add carry
        cmp al, 10
        jae add_case1_carry
        xor r9, r9  ; set carry = 0
        jmp add_case1_continue

    add_case1_carry:
        mov r9, 1   ; set carry = 1
        sub al, 10

    add_case1_continue:
        add al, 0x30
        push rax
        inc rcx
        jmp add_case1

    add_case2:
        cmp rsi, 0
        je check_carry
        dec rsi
        mov al, [num1 + rsi]
        sub al, 0x30
        add rax, r9  ; add carry
        cmp al, 10
        jae add_case2_carry
        xor r9, r9  ; set carry = 0
        jmp add_case2_continue

    add_case2_carry:
        mov r9, 1   ; set carry = 1
        sub al, 10

    add_case2_continue:
        add al, 0x30
        push rax
        inc rcx
        jmp add_case2

    check_carry:
        cmp r9, 1   ; if carry = 1
        jb create_sum

    add_carry:
        mov al, 31h
        push rax
        inc rcx

    create_sum:
        pop rax
        mov [rdx], al
        inc rdx
        loop create_sum

    add rsp, 60
    mov rsp, rbp
    pop rbp
    ret    