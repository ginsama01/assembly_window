%include 'io_x64.asm'
extern ExitProcess


section .data
    msg1    db  "Enter string: ", 0xA,0x0

    msg2    db  "Enter substring: ", 0xA,0x0

    newline db  0xA, 0x0
    
    space   db  " ", 0x0

section .bss
    string      resb 100
    substring   resb 10
    trace       resb 100
    res         resb 8

section .text
	global Start

Start:
    ; read string
    sub rsp, 32
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, string
    mov rdx, 100
    call readStr
    add rsp, 32

    ; read substring
    sub rsp, 32
    mov rcx, msg2
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, substring
    mov rdx, 10
    call readStr
    add rsp, 32

    ; check substring
    sub rsp, 32
    mov rcx, string
    mov rdx, substring
    mov r8, trace
    call check_substr
    add rsp, 32
    mov [res], rax

    ; print value
    call print

exit:
    xor rcx, rcx
    call ExitProcess    ; call exit from win api

; Check substring in string
; Input:
;   %rcx: char* - string
;   %rdx: char* - substring
;   %r8: char* - store array of position where substring in string
; Output:
;   %rax: int - number of substring in string
check_substr:
    check_init:
        push rbp
        mov rbp, rsp

        ; for convert calling convention ^^
        mov rdi, rcx
        mov rsi, rdx
        mov rdx, r8
        xor rax, rax    ; number of substring in string
        xor r8, r8  ; index of string

    check_start:
        push r8     ; push to stack to store position if need later
        xor r9, r9  ; index of sub string
        xor rcx, rcx
        xor rbx, rbx

    check_main:
        ; get character of string
        mov cl, [rdi + r8]
        ; get character of substring
        mov bl, [rsi + r9]
        ; compare if character of substring is enter or null
        cmp bl, 0x0
        je is_substr
        cmp bl, 0xD
        je is_substr 
        ; compare if character of string is enter or null
        cmp cl, 0x0
        je check_done 
        cmp cl, 0xD
        je check_done
        cmp cl, bl
        jne not_substr
        ; next character
        inc r8
        inc r9
        jmp check_main
        
    
    is_substr:
        inc rax ; inc number of substring in string
        
        ; store position of substring
        pop r8
        mov [rdx], r8
        inc rdx

        inc r8 ; next character
        jmp check_start

    not_substr:
        pop r8
        inc r8 ; next character
        jmp check_start

    check_done:
        pop r8 
        mov rsp, rbp
        pop rbp
        ret

; Print result and trace position
; Input: none
; Output: none
print:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    %define num     rbp - 8
    mov r10, [res]
    mov qword [num], r10
    ; convert total time substring in string from decimal to string to print
    sub rsp, 32
    mov rcx, [res]
    mov rdx, res
    call decimal_to_string
    add rsp, 32

    sub rsp, 32
    mov rcx, res
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, newline
    call printStr
    add rsp, 32

    ; print position trace
    print_array:
        mov rax, trace
        cmp qword [num], 0
        je print_done

        print_loop:
            ; get position
            xor rbx, rbx
            mov bl, [rax]
            push rax    ; push rax to stack

            ; convert to string to print
            mov qword [res], 0
            
            sub rsp, 32
            mov rcx, rbx
            mov rdx, res
            call decimal_to_string
            add rsp, 32

            sub rsp, 32
            mov rcx, res
            call printStr
            add rsp, 32

            sub rsp, 32
            mov rcx, space
            call printStr
            add rsp, 32

            pop rax ;get rax from stack
            inc rax ; next element in trace array
        
            dec qword [num]
            cmp qword [num], 0
            jne print_loop

    print_done:
        mov rsp, rbp
        pop rbp
        ret