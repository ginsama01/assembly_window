%include 'io_x64.asm'
extern ExitProcess

section .data
    msg1    db  "Chon 1 trong 4 tuy chon: ", 0xA, 0x0

    msg2    db  "1. Cong ", 0xA, 0x0

    msg3    db  "2. Tru ", 0xA, 0x0

    msg4    db  "3. Nhan ", 0xA, 0x0

    msg5    db  "4. Chia ", 0xA, 0x0

    msg6    db  "Nhap hai toan hang, moi toan hang tren mot dong ", 0xA, 0x0

    msg7    db  "So chia khong hop le ", 0xA, 0x0

    msg8    db  "Ket qua la: ", 0xA, 0x0

    newline db  "", 0xA, 0x0

section .bss
    ope     resb 2
    num1    resb 11
    num2    resb 11
    res     resb 11

section .text
    global Start

Start:

    ; print message
    sub rsp, 32
    mov rcx, msg1
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, msg2
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, msg3
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, msg4
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, msg5
    call printStr
    add rsp, 32
   
    ; read operation
    sub rsp, 32
    mov rcx, ope
    mov rdx, 5
    call readStr
    add rsp, 32

    ; read number and convert to decimal
    sub rsp, 32
    mov rcx, msg6
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, num1
    mov rdx, 11
    call readStr
    add rsp, 32

    sub rsp, 32
    mov rcx, num2
    mov rdx, 11
    call readStr
    add rsp, 32

    ; convert num1 string to decimal number
    sub rsp, 32
    mov rcx, num1
    call string_to_decimal
    add rsp, 32
    mov [num1], rax

    ; convert num2 string to decimal number
    sub rsp, 32
    mov rcx, num2
    call string_to_decimal
    add rsp, 32
    mov [num2], rax

    ; case for operation
    mov al, [ope]
    cmp al, '1'
    je add_ope 

    cmp al, '2'
    je sub_ope

    cmp al, '3'
    je mul_ope

    cmp al, '4'
    je div_ope

print:
    ; print result
    sub rsp, 32
    mov rcx, msg8
    call printStr
    add rsp, 32

    sub rsp, 32
    mov rcx, res
    call printStr
    add rsp, 32

exit:
    xor rcx, rcx
    call ExitProcess    ; call exit from win api


add_ope:
    mov rax, [num1]
    add rax, [num2]

    sub rsp, 32
    mov rcx, rax
    mov rdx, res
    call decimal_to_string
    add rsp, 32
    jmp print

sub_ope:
    mov rax, [num1]
    sub rax, [num2]

    sub rsp, 32
    mov rcx, rax
    mov rdx, res
    call decimal_to_string
    add rsp, 32
    jmp print

mul_ope:
    xor rdx, rdx
    mov rax, [num1]
    mov rbx, [num2]
    mul rbx

    sub rsp, 32
    mov rcx, rax
    mov rdx, res
    call decimal_to_string
    add rsp, 32
    jmp print

div_ope:
    xor rdx, rdx
    mov rax, [num1]
    mov rbx, [num2]
    cmp rbx, 0
    je invalid
    div rbx

    sub rsp, 32
    mov rcx, rax
    mov rdx, res
    call decimal_to_string
    add rsp, 32
    jmp print


    invalid:
        sub rsp, 32
        mov rcx, msg7
        call printStr
        add rsp, 32
        jmp exit