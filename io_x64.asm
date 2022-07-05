
NULL        equ 0
STD_OUTPUT_HANDLE equ -11
STD_INPUT_HANDLE equ -10

extern GetStdHandle, WriteConsoleA, ReadConsoleA

; calculate strlen of string
; input: 
;   %rcx: char* - string
; output: 
;   %rax: int - string length
strlen:
    strlen_init:
        push rbp
        mov rbp, rsp

        ; reset value 
        xor rax, rax

    strlen_loop:
        ; if null character
        cmp byte [rcx], 0
        je strlen_done
        inc rcx
        inc rax
        jmp strlen_loop

    strlen_done:
        mov rsp, rbp
        pop rbp
        ret

; print string to stdout
; input: 
;   %rcx: char* - string to print
; output: 
;   none
printStr:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    ; local variable
    %define len     rbp - 8
    %define lpChar  rbp - 16
    mov rsi, rcx    ; store string   
    sub rsp, 32
    call strlen
    add rsp, 32
    mov qword [len], rax

    sub rsp, 32 ; for shadow space
    mov rcx, STD_OUTPUT_HANDLE    ; first parameter
    call GetStdHandle   ; Retrieves a handle to the specified standard device (standard input, standard output, or standard error).  
    add rsp, 32

    sub rsp, 40 ; shadow space for 5 parameters
    mov rcx, rax ;rax is output of GetStdHandle, mov to rcx, it's first parameter of WriteConsoleA, a handle to the console screen buffer.
    mov rdx, rsi ; A pointer to a buffer that contains characters to be written to the console screen buffer
    mov r8, [len] ; The number of characters to be written.
    lea r9, [lpChar] ; A pointer to a variable that receives the number of characters actually written.
    mov qword [rsp + 4 * 8], NULL ; lpReserved Reserved; must be NULL.
    call WriteConsoleA ; Writes a character string to a console screen buffer beginning at the current cursor location.
    add rsp, 40

    add rsp, 16
    mov rsp, rbp
    pop rbp
    ret

; read string from stdin
; input:
;   %rcx: char* - string to read
;   %rdx: int - string length
; output:
;   none
readStr:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    ; local variable
    %define len     rbp - 8
    %define lpChar  rbp - 16
    mov qword [len], rdx

    sub rsp, 32 ; for shadow space
    mov rsi, rcx
    mov rcx, STD_INPUT_HANDLE ; The standard device
    call GetStdHandle
    add rsp, 32 ; for shadow space

    sub rsp, 40
    mov rcx, rax    ; A handle to the console input buffer.
    mov rdx, rsi    ; A pointer to a buffer that receives the data read from the console input buffer
    mov r8, [len]   ; The number of characters to be read.
    lea r9, [lpChar]; A pointer to a variable that receives the number of characters actually read.
    mov qword [rsp + 4 * 8], NULL ; A pointer to a CONSOLE_READCONSOLE_CONTROL 
    call ReadConsoleA
    add rsp, 40

    add rsp, 16
    mov rsp, rbp
    pop rbp
    ret

; Convert string to decimal number
; Input: 
;   %rcx: char* - string to convert
; Output: 
;   %rax: int - decimal number
string_to_decimal:
    std_init:
        push rbp
        mov rbp, rsp

        mov rdi, rcx
        xor rax, rax    ; rax = 0
        xor rcx, rcx    ; rcx = 0
        xor rdx, rdx    ; rdx = 0
    
    std_continue:
        mov cl, [rdi]   ; Get digit character
        cmp cl, 0x0     ; Check if null character
        je std_done
        cmp cl, 0xD     ; Check if enter character
        je std_done
        sub cl, 0x30    ; Convert character to digit in decimal

        ; rax = rax * 10 + rcx
        push rcx    ; push rcx value to stack
        mov rcx, 10 
        mul rcx
        pop rcx     ; get value from stack
        add rax, rcx

        inc rdi
        jmp std_continue

    std_done:
        mov rsp, rbp
        pop rbp
        ret 

; Convert decimal number to string
; Input: 
;   %rcx: int - decimal number 
;   %rdx: char* - string will store value
; Output: none
decimal_to_string:
    dts_init:
        push rbp
        mov rbp, rsp
   
        mov rsi, rdx    ; string will store value
        mov rax, rcx    ; decimal number
        xor rcx, rcx    ; rcx = 0
    
    dts_continue:
        xor rdx, rdx    ; rdx = 0 for divider
       
        ; Divide 10, remainder is digit, push it to stack to reverse. Using rcx for count number of digits.
        push rcx
        mov rcx, 10
        div rcx
        pop rcx
        push rdx
        inc rcx
        cmp rax, 0      ; if rax = 0, end
        je dts_done
        jmp dts_continue
    
    dts_done:
        pop rdx     ; get digit
        add rdx, 0x30   ; convert to ascii
        mov [rsi], rdx  ; move digit value in ascii to rsi pointer
        inc rsi         ; increase pointer to next character
        loop dts_done
    
    dts_end:
        mov rsp, rbp
        pop rbp
        ret