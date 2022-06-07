
NULL                EQU 0
STD_OUTPUT_HANDLE   EQU -11
COLOR_WINDOW        EQU 5  
CS_HREDRAW          EQU 2
CS_VREDRAW          EQU 1
CW_USEDEFAULT       EQU 80000000h
IDC_ARROW           EQU 7F00h
IDI_APPLICATION     EQU 7F00h
SW_SHOWNORMAL       EQU 1
SW_SHOWDEFAULT      EQU 10
WM_CREATE           EQU 1
WM_DESTROY          EQU 2
WM_COMMAND          EQU 0111h
WM_TIMER            EQU 0113h
WS_OVERLAPPEDWINDOW EQU 0CF0000h
WS_EX_CLIENTEDGE    EQU 00000200h
WindowWidth         EQU 150
WindowHeight        EQU 50

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
extern SetTimer 
extern KillTimer
extern LoadIconA
extern LoadCursorA
extern RegisterClassExA
extern CreateWindowExA
extern ShowWindow
extern UpdateWindow
extern GetMessageA
extern TranslateMessage
extern DispatchMessageA
extern DefWindowProcA
extern PostQuitMessage
extern GetModuleHandleA

section .data
    firefox     db 'Firefox', 0x0
    chromium    db 'Chrome', 0x0
    edge        db 'Edge', 0x0
    opera       db 'Opera', 0x0
    safari      db 'Safari', 0x0
    newline     db 0xA
    ClassName   db 'AntiBrowser'

section .bss
    lpNumberOfCharsWritten  resb 100
    hInstance               resq 1

section .text
    global Start

Start:
    sub rsp, 8

    sub rsp, 32
    xor rcx, rcx 
    call GetModuleHandleA
    add rsp, 32
    mov qword [hInstance], rax

    call WinMain 

Exit:
    xor rcx, rcx
    call ExitProcess

WinMain: 
    push rbp
    mov rbp, rsp

    %define wc                 RBP - 136            ; WNDCLASSEX structure, 80 bytes
    %define wc.cbSize          RBP - 136            ; 4 bytes. Start on an 8 byte boundary
    %define wc.style           RBP - 132            ; 4 bytes
    %define wc.lpfnWndProc     RBP - 128            ; 8 bytes
    %define wc.cbClsExtra      RBP - 120            ; 4 bytes
    %define wc.cbWndExtra      RBP - 116            ; 4 bytes
    %define wc.hInstance       RBP - 112            ; 8 bytes
    %define wc.hIcon           RBP - 104            ; 8 bytes
    %define wc.hCursor         RBP - 96             ; 8 bytes
    %define wc.hbrBackground   RBP - 88             ; 8 bytes
    %define wc.lpszMenuName    RBP - 80             ; 8 bytes
    %define wc.lpszClassName   RBP - 72             ; 8 bytes
    %define wc.hIconSm         RBP - 64             ; 8 bytes. End on an 8 byte boundary

    %define msg                RBP - 56             ; MSG structure, 48 bytes
    %define msg.hwnd           RBP - 56             ; 8 bytes. Start on an 8 byte boundary
    %define msg.message        RBP - 48             ; 4 bytes
    %define msg.Padding1       RBP - 44             ; 4 bytes. Natural alignment padding
    %define msg.wParam         RBP - 40             ; 8 bytes
    %define msg.lParam         RBP - 32             ; 8 bytes
    %define msg.time           RBP - 24             ; 4 bytes
    %define msg.py.x           RBP - 20             ; 4 bytes
    %define msg.pt.y           RBP - 16             ; 4 bytes
    %define msg.Padding2       RBP - 12             ; 4 bytes. Structure length padding

    %define hWnd               RBP - 8              ; 8 bytes

    sub rsp, 144

    mov dword [wc.cbSize], 80
    mov dword [wc.style], CS_HREDRAW | CS_VREDRAW 
    mov qword [wc.lpfnWndProc], WndProc
    mov dword [wc.cbClsExtra], NULL
    mov dword [wc.cbWndExtra], NULL
    mov rax, qword [hInstance]
    mov qword [wc.hInstance], rax
    mov qword [wc.hbrBackground], COLOR_WINDOW + 1
    mov qword [wc.lpszMenuName], NULL
    mov qword [wc.lpszClassName], ClassName

    sub rsp, 32
    mov rcx, NULL
    mov rdx, IDI_APPLICATION
    call LoadIconA
    add rsp, 32
    mov qword [wc.hIcon], rax
    mov qword [wc.hIconSm], rax

    sub rsp, 32
    mov rcx, NULL
    mov rdx, IDC_ARROW
    call LoadCursorA
    add rsp, 32
    mov qword [wc.hCursor], rax

    sub rsp, 32
    lea rcx, [wc]
    call RegisterClassExA  
    add rsp, 32

    sub rsp, 96
    mov rcx, WS_EX_CLIENTEDGE
    mov rdx, ClassName
    mov r8, ClassName
    mov r9, WS_OVERLAPPEDWINDOW
    mov dword [rsp + 4*8], CW_USEDEFAULT
    mov dword [rsp + 5*8], CW_USEDEFAULT
    mov dword [rsp + 6*8], WindowWidth
    mov dword [rsp + 7*8], WindowHeight
    mov qword [rsp + 8*8], NULL
    mov qword [rsp + 9*8], NULL
    mov rax, qword [hInstance]
    mov qword [rsp + 10*8], rax
    mov qword [rsp + 11*8], NULL
    call CreateWindowExA
    add rsp, 96
    mov qword [hWnd], rax

    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, SW_SHOWDEFAULT
    call ShowWindow
    add rsp, 32

    sub rsp, 32
    mov rcx, qword [hWnd]
    call UpdateWindow
    add rsp, 32

MessageLoop:
    sub rsp, 32
    lea rcx, [msg]
    mov rdx, NULL
    mov r8, NULL
    mov r9, NULL
    call GetMessageA
    add rsp, 32

    cmp eax, 0
    je MessageDone

    sub rsp, 32
    lea rcx, [msg]
    call TranslateMessage
    add rsp, 32

    sub rsp, 32
    lea rcx, [msg]
    call DispatchMessageA
    add rsp, 32

    jmp MessageLoop

MessageDone:
    mov rsp, rbp
    pop rbp
    xor eax, eax
    ret
    
WndProc:
    push rbp
    mov rbp, rsp

    %define hWnd   RBP + 16                         ; Location of the shadow space setup by
    %define uMsg   RBP + 24                         ; the calling function
    %define wParam RBP + 32
    %define lParam RBP + 40

    mov qword [hWnd], rcx
    mov qword [uMsg], rdx
    mov qword [wParam], r8
    mov qword [lParam], r9

    cmp qword [uMsg], WM_DESTROY
    je WmDestroy

    cmp qword [uMsg], WM_CREATE
    je WmCreate 

    cmp qword [uMsg], WM_TIMER
    je WmTimer 

DefaultMessage:
    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, qword [uMsg]
    mov r8, qword [wParam]
    mov r9, qword [lParam]
    call DefWindowProcA
    add rsp, 32

    mov rsp, rbp
    pop rbp
    ret

WmCreate:
    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, 1
    mov r8, 5000
    mov r9, NULL
    call SetTimer
    add rsp, 32
    jmp WmEnd

WmTimer:
    call AntiBrowser
    jmp WmEnd

WmDestroy:
    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, 1
    call KillTimer
    add rsp, 32

    sub rsp, 32
    xor rcx, rcx
    call PostQuitMessage
    add rsp, 32

WmEnd:
    xor rax, rax
    mov rsp, rbp
    pop rbp
    ret


AntiBrowser:
    push rbp
    mov rbp, rsp

    sub rsp, 32
    mov rcx, EnumWindowsProc
    mov rdx, 0
    call EnumWindows
    add rsp, 32

    mov rsp, rbp
    pop rbp
    xor rax, rax
    ret

EnumWindowsProc:
    push rbp
    mov rbp, rsp

    ; local variable
    sub rsp, 112
    %define hWnd        RBP + 16
    %define lParam      RBP + 24
    %define windowtext  RBP - 96
    %define pid         RBP - 104
    %define processHandle RBP - 112
    mov qword [hWnd], rcx
    mov qword [lParam], rdx


    ; check if window is  visible
    sub rsp, 32
    mov rcx, [hWnd]
    call IsWindowVisible
    add rsp, 32
    cmp rax, 0
    je EnumRetTrue

    ; get window text name
    sub rsp, 32
    mov rcx, [hWnd]
    lea rdx, [windowtext]
    mov r8, 100
    call GetWindowTextA
    add rsp, 32

    sub rsp, 32
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle   ; 1 parameters, output to eax
    add rsp, 32

    sub rsp, 40
    mov rbx, rax
    lea rcx, [windowtext]
    call strlen
    mov r8, rax
    mov rcx, rbx
    lea rdx, [windowtext] 
    mov r9, lpNumberOfCharsWritten
    mov qword [rsp + 4*8], NULL
    call WriteConsoleA  ; call winapi, 5 parameters
    add rsp, 40

    sub rsp, 32
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle   ; 1 parameters, output to eax
    add rsp, 32

    sub rsp, 40
    mov rcx, rax
    mov rdx, newline 
    mov r8, 1
    mov r9, lpNumberOfCharsWritten
    mov qword [rsp + 4*8], NULL
    call WriteConsoleA  ; call winapi, 5 parameters
    add rsp, 40

    ; check if it's edge browser
    sub rsp, 32
    lea rcx, [windowtext] 
    lea rdx, [edge]
    call substring 
    add rsp, 32
    cmp rax, 0
    jne KillBrowser

    ; check if it's firefox browser
    sub rsp, 32
    lea rcx, [windowtext] 
    lea rdx, [firefox]
    call substring 
    add rsp, 32
    cmp rax, 0
    jne KillBrowser

    ; check if it's opera browser
    sub rsp, 32
    lea rcx, [windowtext] 
    lea rdx, [opera]
    call substring 
    add rsp, 32
    cmp rax, 0
    jne KillBrowser

    ; check if it's safari browser
    sub rsp, 32
    lea rcx, [windowtext] 
    lea rdx, [safari]
    call substring 
    add rsp, 32
    cmp rax, 0
    jne KillBrowser

    ;check if it's chromium browser
    sub rsp, 32
    lea rcx, [windowtext] 
    mov rdx, chromium
    call substring 
    add rsp, 32
    cmp rax, 0
    je EnumRetTrue

    KillBrowser:
        ; find process id
        sub rsp, 32
        mov rcx, [hWnd]
        lea rdx, [pid] 
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
        add rsp, 112
        mov rsp, rbp
        pop rbp
        ret


substring:
    push rbp
    mov rbp, rsp

    %define str1 rbp+16
    %define str2 rbp+24
    
    substring_start:
        mov [str1], rcx
        mov [str2], rdx

    substring_loop:
        mov rdi, [str1] 
        mov al, byte [rdi]
        mov rdi, [str2]
        mov bl, byte [rdi]

        cmp bl, 0
        je substring_true
        cmp al, 0
        je substring_false

        cmp al, bl
        jne substring_diff

        inc qword [str1]
        inc qword [str2]
        jmp substring_loop

    substring_diff:
        inc rcx
        jmp substring_start

    substring_true:
        mov rax, 1
        jmp substring_done
    
    substring_false:
        xor rax, rax

    substring_done:
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
