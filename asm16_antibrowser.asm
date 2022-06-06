
NULL        equ 0
STD_OUTPUT_HANDLE equ -11
extern EnumWindows 
extern ExitProcess
extern GetStdHandle
extern WriteConsoleA
extern GetWindowTextA
extern GetClassNameA
extern IsWindowVisible
extern GetWindowThreadProcessId
extern OpenProcess
extern TerminateProcess
extern CloseHandle

section .data
    firefox db 'MozillaWindowClass', 0
    chromium db 'Chrome_WidgetWin_1', 0

section .bss
    pid         resb 8
    classname   resb 100
    processHandle   resb 8

section .text
    global Start

Start:
    sub rsp, 32
    mov rcx, EnumWindowsProc
    mov rdx, 0
    call EnumWindows
    add rsp, 32
    xor rcx, rcx
    call ExitProcess


EnumWindowsProc:
    push rbp
    mov rbp, rsp

    ; local variable
    %define hWnd        RBP + 16
    %define lParam      RBP + 24
    mov qword [hWnd], rcx
    mov qword [lParam], rdx

    ; check if window is visible
    sub rsp, 32
    mov rcx, [hWnd]
    call IsWindowVisible
    add rsp, 32
    cmp rax, 0
    je EnumRetTrue

    ; get class name
    sub rsp, 32
    mov rcx, [hWnd]
    mov rdx, classname
    mov r8, 100
    call GetClassNameA

    ; check if it's firefox browser
    sub rsp, 32
    mov rcx, classname 
    mov rdx, firefox
    call strcmp 
    add rsp, 32
    cmp rax, 0
    jne KillBrowser
    jmp EnumRetTrue
    ; check if it's chromium browser
    ; sub rsp, 32
    ; mov rcx, classname 
    ; mov rdx, chromium
    ; call strcmp 
    ; add rsp, 32
    ; cmp rax, 0
    ; je EnumRetTrue

    KillBrowser:
        ; find process id
        sub rsp, 32
        mov rcx, [hWnd]
        mov rdx, pid 
        call GetWindowThreadProcessId
        add rsp, 32
        
        ; open process
        sub rsp, 32
        mov rcx, 1
        mov rdx, 0
        mov r8, [pid]
        call OpenProcess
        add rsp, 32

        ; Terminate process
        mov [processHandle], rax
        cmp qword [processHandle], 0
        je EnumRetFalse

        sub rsp, 32
        mov rcx, [processHandle]
        mov rdx, 1
        call TerminateProcess
        add rsp, 32

        ; Close process
        sub rsp, 32
        mov rcx, [processHandle]
        call CloseHandle
        add rsp, 32

    EnumRetTrue:
        mov rax, 1
        jmp EnumDone

    EnumRetFalse:
        xor rax, rax

    EnumDone:
        mov rsp, rbp
        pop rbp
        ret


strcmp:
    push rbp
    mov rbp, rsp

    %define str1 rbp+16
    %define str2 rbp+24
    mov [str1], rcx
    mov [str2], rdx

    call strlen
    mov r8, rax
    mov rcx, [str2]
    call strlen
    cmp r8, rax
    jne strcmp_false
    
    strcmp_loop:
        mov rcx, [str1] 
        mov al, byte [rcx]
        mov rcx, [str2]
        mov bl, byte [rcx]

        cmp al, 0
        je strcmp_true
        cmp al, bl
        jne strcmp_false
        inc qword [str1]
        inc qword [str2]
        jmp strcmp_loop


    strcmp_true:
        mov rax, 1
        jmp strcmp_done
    
    strcmp_false:
        xor rax, rax

    strcmp_done:
        mov rsp, rbp
        pop rbp
        ret

strlen:
    push rbp
    mov rbp, rsp

    mov rax, rcx
    strlen_loop:
        cmp byte [rax], 0
        je strlen_done
        inc rax
        jmp strlen_loop

    strlen_done:
        sub rax, rcx ; return len to rax by offset subtraction

        mov rsp, rbp
        pop rbp
        ret
