NULL                equ 0
STD_OUTPUT_HANDLE   equ -11
STD_INPUT_HANDLE    equ -10

extern ExitProcess, GetStdHandle, WriteConsoleA, ReadConsoleA

section .data
    res     dd 0

section .bss
    string      resb 100
    substring   resb 10
    trace       resb 100
    lpNumberOfCharsRead resb 100
    lpNumberOfCharsWritten resb 100

section .text
	global Start

Start:
    call read_string
    call read_substring    
    ; esi is string pointer
    mov esi, 0
    ; res is pointed by edx register
    mov edx, res
    ; trace is pointed by ecx register
    mov ecx, trace
    call check_substr
    call print
    jmp exit

read_string:
    ; Enter string
    push STD_INPUT_HANDLE
    call GetStdHandle
    push NULL
    push lpNumberOfCharsRead
    push 100
    push string
    push eax
    call ReadConsoleA
    ; Return
    ret

read_substring:
    ; Enter substring
    push STD_INPUT_HANDLE
    call GetStdHandle
    push NULL
    push lpNumberOfCharsRead
    push 10
    push substring
    push eax
    call ReadConsoleA
    ; Return
    ret

check_substr:
    push esi
    ; edi is substring pointer
    xor edi, edi
    xor eax, eax
    xor ebx, ebx
    check:
        ; get character of string
        mov al, [string + esi]
        ; get character of substring
        mov bl, [substring + edi]
        ; compare if character of substring is enter or null
        cmp bl, 0x0
        je is_substr
        cmp bl, 0xA
        je is_substr 
        ; compare if character of string is enter or null
        cmp al, 0x0
        je check_done 
        cmp al, 0xA
        je check_done
        cmp al, bl
        jne not_substr
        ; next character
        inc esi
        inc edi
        jmp check
        
    
    is_substr:
        pop esi
        mov [ecx], esi
        inc ecx
        mov al, [edx]
        add al, 1
        mov [edx], al
        inc esi
        jmp check_substr

    not_substr:
        pop esi
        inc esi
        jmp check_substr

    check_done:
        pop esi 
        ret

print:
    mov eax, [res]
    mov esi, [res]
    mov ebx, res
    call decimal_to_string
    mov byte [ebx], 0xA

    ;Print string
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    push NULL
    push lpNumberOfCharsWritten
    push 4
    push res
    push eax
    call WriteConsoleA

    print_array:
        mov eax, trace
     
        print_loop:
            xor ebx, ebx
            mov bl, [eax]
            push eax
            mov eax, ebx
            xor ebx, ebx
            mov [res], ebx
            mov ebx, res
            call decimal_to_string
            mov byte [ebx], ' '
            push STD_OUTPUT_HANDLE
            call GetStdHandle
            push NULL
            push lpNumberOfCharsWritten
            push 4
            push res
            push eax
            call WriteConsoleA
            pop eax
            inc eax
            dec esi
            cmp esi, 0x0
            jne print_loop

    print_done:
        ret

; Convert decimal number to string
; Input: eax register
; Output: ebx pointer   
decimal_to_string:
    xor ecx, ecx    ; ecx = 0
    
    dts_continue:
        xor edx, edx    ; edx = 0 for divider
        ; Divide 10, remainder is digit, push it to stack to reverse. Using ecx for count number of digits.
        push ecx
        mov ecx, 10
        div ecx
        pop ecx
        push edx
        inc ecx
        cmp eax, 0      ; if eax = 0, end
        je dts_done
        jmp dts_continue
    
    dts_done:
        pop edx     ; get digit
        add edx, 0x30   ; convert to ascii
        mov [ebx], edx  ; move digit value in ascii to ebx pointer
        inc ebx         ; increase pointer to next character
        loop dts_done
    
    ret

exit:
    push NULL
    call ExitProcess