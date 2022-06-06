bits 64
default rel

extern CreateWindowExA 
extern DefWindowProcA
extern DispatchMessageA
extern ExitProcess
extern GetWindowTextA
extern GetMessageA
extern GetModuleHandleA
extern IsDialogMessageA
extern InvalidateRect
extern KillTimer
extern PostQuitMessage
extern RegisterClassExA
extern ShowWindow
extern SetWindowTextA
extern TranslateMessage
extern UpdateWindow
extern SetTimer
extern EnumWindows
extern GetWindowThreadProcessId
extern IsWindowVisible
extern GetClassNameA
extern OpenProcess
extern TerminateProcess
extern CloseHandle


COLOR_WINDOW        EQU 5                       
CS_BYTEALIGNWINDOW  EQU 2000h
CS_HREDRAW          EQU 2
CS_VREDRAW          EQU 1
CW_USEDEFAULT       EQU 80000000h
IDC_ARROW           EQU 7F00h
IDI_APPLICATION     EQU 7F00h
IMAGE_CURSOR        EQU 2
IMAGE_ICON          EQU 1
LR_SHARED           EQU 8000h
NULL                EQU 0
SW_SHOWNORMAL       EQU 1
WM_DESTROY          EQU 2
WM_PAINT            EQU 15
WS_EX_COMPOSITED    EQU 2000000h
WS_OVERLAPPEDWINDOW EQU 0CF0000h
WS_VISIBLE          EQU 0x10000000
WS_CHILD            EQU 0x40000000
WS_BORDER           EQU 0x00800000
WM_COMMAND          EQU 0x0111
WM_CREATE           EQU 0x0001
WM_TIMER            EQU 0x0113
EN_CHANGE           EQU 0x0300
SS_LEFT             EQU 0x00000010
WS_EX_CLIENTEDGE equ 0x00000200


struc WNDCLASSEX
    cbSize            resd      1
    style             resd      1
    lpfnWndProc       resq      1
    cbClsExtra        resd      1
    cbWndExtra        resd      1
    hInstance         resq      1
    hIcon             resq      1
    hCursor           resq      1
    hbrBackground     resq      1
    lpszMenuName      resq      1
    lpszClassName     resq      1
    hIconSm           resq      1
endstruc


struc PAINTSTRUCT
    hdc resq 1
    fErase resd 1
    rcPaint resd 4
    fRestore resd 1
    fIncUpdate resd 1
    rebReserved resb 32
    padding resd 1
endstruc

struc RECT
    .left resd 1
    .top resd 1
    .right resd 1
    .bottom resd 1
endstruc


global main


section .data
    ballX dq 50
    ballY dq 100
    RADIUS dq 30
    WindowWidth dq 300
    WindowHeight dq 50
    clrf db 0dh, 0ah, 0
    space db 20h, 0
    minus db '-', 0
    caption db '64-bit hello!', 0
    message db 'Hello World!', 0
    className db 'antiBrowser', 0
    windowName db 'Anti Browser', 0
    firefox db 'MozillaWindowClass', 0
    chromium db 'Chrome_WidgetWin_1', 0
    stat db 'STATIC', 0
    edit db 'EDIT', 0
    empt db '',0

    dir dq 2
    idx dq 1, -1, -1, 1
    idy dq 1, 1, -1, -1

    wcex:
    istruc WNDCLASSEX
        at cbSize,            dd      80
        at style,             dd      CS_HREDRAW | CS_VREDRAW | CS_BYTEALIGNWINDOW
        at lpfnWndProc,       dq      ?
        at cbClsExtra,        dd      0
        at cbWndExtra,        dd      0
        at hInstance,         dq      ?
        at hIcon,             dq      0
        at hCursor,           dq      ?
        at hbrBackground,     dq      COLOR_WINDOW+1
        at lpszMenuName,      dq      0
        at lpszClassName,     dq      ?
        at hIconSm,           dq      0

    iend

    txt db 100

section .bss
    hInst resq 1
    hwnd resq 1
    msg resb 48
    textBox resq 1
    textField resq 1

section .text
global main

main:
    xor ecx, ecx
    sub rsp, 0x28
    call GetModuleHandleA
    add rsp, 0x20

    mov qword [hInst], rax
    call WinMain

    xor ecx, ecx
    call ExitProcess

WinMain:
    push rbp
    mov rbp, rsp


    lea rax, WndProc
    mov [wcex + lpfnWndProc], rax

    mov rax, [hInst]
    mov [wcex + hInstance], rax

    lea rax, className
    mov [wcex + lpszClassName], rax


    lea rcx, [wcex]
    sub rsp, 0x20
    call RegisterClassExA
    add rsp, 0x20

    mov ecx, WS_EX_COMPOSITED
    lea rdx, [className]
    lea r8, [windowName]
    mov r9d, WS_OVERLAPPEDWINDOW

    push 0
    mov rax, [hInst]
    push rax
    push 0
    push 0
    mov rbx, [WindowHeight]
    push rbx
    mov rbx, [WindowWidth]
    push rbx
    mov rax, CW_USEDEFAULT
    push rax
    push rax
    
    sub rsp, 0x20
    call CreateWindowExA
    add rsp, 0x20 + 64
    
    mov [hwnd], rax
    
    mov rcx, [hwnd]
    mov edx, SW_SHOWNORMAL
    sub rsp, 0x20
    call ShowWindow
    add rsp, 0x20

    mov rcx, [hwnd]
    sub rsp, 0x20
    call UpdateWindow
    add rsp, 0x20


msgLoop:
    lea rcx, msg
    xor rdx, rdx
    xor r8, r8
    xor r9, r9
    sub rsp, 0x20
    call GetMessageA
    add rsp, 0x20
    cmp rax, 0
    je done

    lea rcx, msg
    sub rsp, 0x20
    call TranslateMessage
    add rsp, 0x20

    lea rcx, msg
    sub rsp, 0x20
    call DispatchMessageA
    add rsp, 0x20

    jmp msgLoop

done:
    xor rax, rax
    leave
    ret
    

WndProc:
    push  rbp
    mov   rbp, rsp

    %define hWnd rbp + 16
    %define uMsg rbp + 24
    %define wParam rbp + 32
    %define lParam rbp + 40

    mov qword [hWnd], rcx
    mov qword [uMsg], rdx
    mov qword [wParam], R8
    mov qword [lParam], R9

    sub rsp, 80 ; local variable for hdc and painstruct
    %define hdc1 rbp - 8
    %define ps rbp - 80

    cmp qword [uMsg], WM_CREATE
    je WMCREATE

    cmp qword [uMsg], WM_TIMER
    je WMTIMER

    cmp   qword [uMsg], WM_DESTROY
    je    WMDESTROY



DefaultMessage:
    mov   rcx, qword [hWnd]
    mov   rdx, qword [uMsg]
    mov   r8, qword [wParam]
    mov   r9, qword [lParam]
    sub rsp, 0x20
    call  DefWindowProcA

    leave
    ret

WMCREATE:
    mov rcx, [hWnd]
    mov rdx, 1
    mov r8, 5000
    mov r9, 0
    sub rsp, 0x20
    call SetTimer
    add rsp, 0x20

    jmp WndProcEnd

WMTIMER:
    lea rcx, killBrowser
    xor rdx, rdx
    call EnumWindows

    jmp WndProcEnd

WMDESTROY:
    mov rcx, [hWnd]
    mov rdx, 1
    sub rsp, 0x20
    call KillTimer
    add rsp, 0x20

    xor   ecx, ecx
    sub   rsp, 0x20
    call  PostQuitMessage
    add   rsp, 0x20

WndProcEnd:
    xor eax, eax
    leave
    ret

; callback function for EnumWindow, check for classname, if is browser then call terminate process
killBrowser:
    push rbp
    mov rbp, rsp
    
    %define hwnd rbp + 16
    %define lparam rbp + 24

    sub rsp, 120
    %define pid rbp - 8 
    %define className rbp - 112 ; buffer for storing class name
    %define procHandle rbp - 120

    mov [hwnd], rcx
    mov [lparam], rdx
    
    mov rcx, [hwnd]
    lea rdx, [pid]
    sub rsp, 0x28
    call GetWindowThreadProcessId
    add rsp, 0x28
    
    ; check if window is visible
    mov rcx, [hwnd]
    sub rsp, 0x28
    call IsWindowVisible
    add rsp, 0x28
    cmp rax, 0
    je retTrueKB

    mov rcx, [hwnd]
    lea rdx, [className]
    mov r8, 100
    sub rsp, 0x28
    call GetClassNameA
    add rsp, 0x28

    lea rcx, [className]
    lea rdx, [chromium]
    sub rsp, 0x28
    call strcmp ; check chromium based browser class name (maybe include electron-based app)
    add rsp, 0x28
    cmp rax, 0
    jz kill
    ; check firefox class name
    lea rcx, [className]
    lea rdx, [firefox]
    sub rsp, 0x28
    call strcmp
    add rsp, 0x28
    cmp rax, 0
    jnz retTrueKB

kill:
    mov rcx, 1
    mov rdx, 0
    mov r8, [pid]
    sub rsp, 0x28
    call OpenProcess
    add rsp, 0x28

    mov [procHandle], rax
    cmp qword [procHandle], 0
    je retFalseKB
    mov rcx, [procHandle]
    mov rdx, 1
    sub rsp, 0x28
    call TerminateProcess
    add rsp, 0x28

    mov rcx, [procHandle]
    sub rsp, 0x28
    call CloseHandle
    add rsp, 0x28
    jmp retTrueKB


retTrueKB:
    mov rax, 1
    jmp leaveKB
retFalseKB:
    xor rax, rax

leaveKB:
    leave
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
    jne retFalseSC
cmpLoop:
    mov rcx, [str1] 
    mov al, byte [rcx]
    mov rcx, [str2]
    mov bl, byte [rcx]

    cmp al, 0
    je retTrueSC
    cmp al, bl
    jnz retFalseSC
    inc qword [str1]
    inc qword [str2]
    jmp cmpLoop


retTrueSC:
    xor rax, rax
    jmp leaveSC
retFalseSC:
    mov rax, 1
leaveSC:
    leave
    ret

strlen:
    push rbp
    mov rbp, rsp

    mov rax, rcx
    checkLoop:
    cmp byte [rax], 0
    jz strlenFns
    inc rax
    jmp checkLoop

    strlenFns:
    sub rax, rcx ; return len to rax by offset subtraction

    leave
    ret
