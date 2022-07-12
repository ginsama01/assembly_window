; nasm -f win64 asm15_reverse_x64.asm -o asm15_reverse_x64.obj
; GoLink.exe /console asm15_reverse_x64.obj kernel32.dll user32.dll
; .\asm15_reverse_x64.exe
%include 'io_x64.asm'
STD_OUTPUT_HANDLE   EQU -11
COLOR_WINDOW        EQU 5                       ; Constants
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
SW_SHOWDEFAULT      EQU 10
WM_CREATE           EQU 1
WM_DESTROY          EQU 2
WM_COMMAND          EQU 0111h
WS_EX_COMPOSITED    EQU 2000000h
WS_OVERLAPPEDWINDOW EQU 0CF0000h
WS_EX_CLIENTEDGE    EQU 00000200h
WS_CHILD            EQU 40000000h
WS_BORDER           EQU 00800000h
WS_VISIBLE          EQU 10000000h
ES_LEFT             EQU 0h
ES_AUTOHSCROLL      EQU 128
ES_READONLY         EQU 2048
WindowWidth         EQU 300
WindowHeight        EQU 200
EditID              EQU 1
ShowID              EQU 2


extern GetModuleHandleA
extern GetCommandLineA
extern GetWindowTextA
extern SetWindowTextA
extern ExitProcess
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
extern SetFocus
extern GetStdHandle
extern WriteConsoleA
extern IsDialogMessageA

section .data 
    ClassName       db "reverse", 0h
    AppName         db "Reverse String", 0h
    EditClassName   db  "edit", 0h

    

section .bss 
    hInstance       resq 1
    CommandLine     resq 1
    hwndEdit        resq 1
    hwndShow        resq 1
    buffer          resb 1024
    revstr          resb 1024


section .text 
    global Start 

Start:
    sub rsp, 32
    xor rcx, rcx
    call GetModuleHandleA  ; Retrieves a module handle for the specified module. The module must have been loaded by the calling process
    add rsp, 32
    mov qword [hInstance], rax

    call GetCommandLineA    ; Retrieves the command-line string for the current process.
    mov qword [CommandLine], rax

    call WinMain

exit:
    xor rcx, rcx
    call ExitProcess

WinMain:
    ; Set up a stack frame
    ; Space for 80 bytes of local variables
    push rbp
    mov rbp, rsp
    sub rsp, 136

    %define wc                 RBP - 136            ; WNDCLASSEX structure, 80 bytes
    %define wc.cbSize          RBP - 136            ; 4 bytes. Start on an 8 byte boundary. The size, in bytes, of this structure.
    %define wc.style           RBP - 132            ; 4 bytes. The class style(s)
    %define wc.lpfnWndProc     RBP - 128            ; 8 bytes. A pointer to the window procedure
    %define wc.cbClsExtra      RBP - 120            ; 4 bytes. The number of extra bytes to allocate following the window-class structure
    %define wc.cbWndExtra      RBP - 116            ; 4 bytes. The number of extra bytes to allocate following the window instance.
    %define wc.hInstance       RBP - 112            ; 8 bytes. A handle to the instance that contains the window procedure for the class.
    %define wc.hIcon           RBP - 104            ; 8 bytes. A handle to the class icon. This member must be a handle to an icon resource.
    %define wc.hCursor         RBP - 96             ; 8 bytes. A handle to the class cursor. 
    %define wc.hbrBackground   RBP - 88             ; 8 bytes. A handle to the class background brush.
    %define wc.lpszMenuName    RBP - 80             ; 8 bytes. Pointer to a null-terminated character string that specifies the resource name of the class menu, as the name appears in the resource file.
    %define wc.lpszClassName   RBP - 72             ; 8 bytes. A pointer to a null-terminated string or is an atom. 
    %define wc.hIconSm         RBP - 64             ; 8 bytes. End on an 8 byte boundary. A handle to a small icon that is associated with the window class.

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
    call LoadIconA  ; load icon
    add rsp, 32
    mov qword [wc.hIcon], rax
    mov qword [wc.hIconSm], rax

    sub rsp, 32
    mov rcx, NULL
    mov rdx, IDC_ARROW
    call LoadCursorA    ; load cursor
    add rsp, 32
    mov qword [wc.hCursor], rax
    
    ; register a window class for createwindow
    sub rsp, 32
    lea rcx, [wc]
    call RegisterClassExA  
    add rsp, 32 

    sub rsp, 96
    mov rcx, WS_EX_CLIENTEDGE
    mov rdx, ClassName
    mov r8, AppName
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
    call CreateWindowExA    ; create window
    add rsp, 96
    mov qword [hWnd], rax

    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, SW_SHOWDEFAULT
    call ShowWindow ; Sets the specified window's show state.
    add rsp, 32

    sub rsp, 32
    mov rcx, qword [hWnd]
    call UpdateWindow ;The UpdateWindow function updates the client area of the specified window by sending a WM_PAINT message to the window if the window's update region is not empty.
    add rsp, 32

MessageLoop:
    sub rsp, 32
    lea rcx, [msg]
    mov rdx, NULL
    mov r8, NULL
    mov r9, NULL
    call GetMessageA    ; Retrieves a message from the calling thread's message queue.
    add rsp, 32

    cmp rax, 0
    je MessageDone 

    sub rsp, 32
    lea rcx, [msg]
    call TranslateMessage   ; Translates virtual-key messages into character messages. 
    add rsp, 32

    sub rsp, 32
    lea rcx, [msg]
    call DispatchMessageA   ; Dispatches a message to a window procedure. It is typically used to dispatch a message retrieved by the GetMessage function.
    add rsp, 32

    jmp MessageLoop

MessageDone:
    add rsp, 136
    mov rsp, rbp
    pop rbp
    xor rax, rax
    ret

WndProc:
    ; Set up a stack frame
    push rbp
    mov rbp, rsp

    %define hWnd   RBP + 16                         ; Location of the shadow space setup by
    %define uMsg   RBP + 24                         ; the calling function
    %define wParam RBP + 32
    %define lParam RBP + 40

    ; parameters
    mov qword [hWnd], rcx
    mov qword [uMsg], rdx
    mov qword [wParam], r8
    mov qword [lParam], r9

    ; catch message
    cmp qword [uMsg], WM_DESTROY
    je WmDestroy

    cmp qword [uMsg], WM_CREATE
    je WmCreate

    cmp qword [uMsg], WM_COMMAND
    je WmCommand

DefaultMessage:
    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, qword [uMsg]
    mov r8, qword [wParam]
    mov r9, qword [lParam]
    call DefWindowProcA ; Calls the default window procedure to provide default processing for any window messages that an application does not process
    add rsp, 32

    mov rsp, rbp
    pop rbp
    ret 

WmCreate:
    sub rsp, 32
    mov rcx, ClassName
    call printStr
    add rsp, 32
    
    sub rsp, 96
    mov rcx, WS_EX_CLIENTEDGE
    mov rdx, EditClassName
    mov r8, NULL
    mov r9, WS_CHILD | WS_VISIBLE | WS_BORDER | ES_LEFT | ES_AUTOHSCROLL
    mov dword [rsp + 4*8], 25
    mov dword [rsp + 5*8], 40
    mov dword [rsp + 6*8], WindowWidth - 75
    mov dword [rsp + 7*8], 25
    mov rax, qword [hWnd]
    mov qword [rsp + 8*8], rax
    mov qword [rsp + 9*8], EditID
    mov rax, qword [hInstance]
    mov qword [rsp + 10*8], rax
    mov qword [rsp + 11*8], NULL
    call CreateWindowExA
    add rsp, 96
    mov qword [hwndEdit], rax

    sub rsp, 32
    mov rcx, qword [hwndEdit]
    call SetFocus
    add rsp, 32

    sub rsp, 96
    mov rcx, WS_EX_CLIENTEDGE
    mov rdx, EditClassName
    mov r8, NULL
    mov r9, WS_CHILD | WS_VISIBLE | WS_BORDER | ES_READONLY | ES_AUTOHSCROLL
    mov dword [rsp + 4*8], 25
    mov dword [rsp + 5*8], WindowHeight - 100
    mov dword [rsp + 6*8], WindowWidth - 75
    mov dword [rsp + 7*8], 25
    mov rax, qword [hWnd]
    mov qword [rsp + 8*8], rax
    mov qword [rsp + 9*8], ShowID
    mov rax, qword [hInstance]
    mov qword [rsp + 10*8], rax
    mov qword [rsp + 11*8], NULL
    call CreateWindowExA
    add rsp, 96
    mov qword [hwndShow], rax
    jmp WmEnd

WmCommand:
    mov rax, qword [wParam]
    cmp ax, EditID
    jne WmEnd

    sub rsp, 32
    mov rcx, qword [hwndEdit]
    mov rdx, buffer
    mov r8, 1024
    call GetWindowTextA
    add rsp, 32

    sub rsp, 32
    mov rcx, buffer
    mov rdx, revstr
    call reverse_string
    add rsp, 32

    sub rsp, 32
    mov rcx, qword [hwndShow]
    mov rdx, revstr
    call SetWindowTextA
    add rsp, 32

    jmp WmEnd
WmDestroy:
    sub rsp, 32
    mov rcx, NULL
    call PostQuitMessage
    add rsp, 32

WmEnd:
    xor rax, rax
    mov rsp, rbp
    pop rbp 
    ret 16

; Reverse string
; Input:
;   %rcx: char* - string to reverse
;   %rdx: char* - store string after reverse
; Output: none
reverse_string:
    reverse_init:
        push rbp
        mov rbp, rsp

        ; change calling convention
        mov rdi, rcx
        mov rsi, rdx

        xor rax, rax
        xor rcx, rcx    ; for count characters
    
    next_char:
        mov al, [rdi]   ; get character
        ; if character is null or enter
        cmp al, 0x0     
        je reverse
        cmp al, 0xA
        je reverse
        push rax    ; push character to stack
        inc rdi     ; next character
        inc rcx     ; inc count
        jmp next_char
    
    reverse:
        pop rax     ;get charcater from stack
        mov [rsi], rax  ; mov to end string
        inc rsi     ; next position in end string
        loop reverse
    
    reverse_done:
        mov rsp, rbp
        pop rbp
        ret
    



