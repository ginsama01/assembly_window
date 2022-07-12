; nasm -f win64 asm14_bouncingball_x64.asm -o asm14_bouncingball_x64.obj
; GoLink.exe /console asm14_bouncingball_x64.obj kernel32.dll user32.dll gdi32.dll
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
WM_TIMER            EQU 0113h
WM_SIZE             EQU 0005h
WS_EX_COMPOSITED    EQU 2000000h
WS_OVERLAPPEDWINDOW EQU 0CF0000h
WS_EX_CLIENTEDGE    EQU 00000200h
WS_CHILD            EQU 40000000h
WS_BORDER           EQU 00800000h
WS_VISIBLE          EQU 10000000h
ES_LEFT             EQU 0h
ES_AUTOHSCROLL      EQU 128
ES_READONLY         EQU 2048
WHITE_BRUSH         EQU 0
GRAY_BRUSH          EQU 2
DC_BRUSH            EQU 18
RGB_RED             EQU 000000FFh
WindowWidth         EQU 300
WindowHeight        EQU 200
BallSize            EQU 30
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
extern GetStockObject
extern SetTimer 
extern GetDC 
extern SelectObject 
extern FillRect
extern Ellipse
extern GetClientRect
extern ReleaseDC
extern KillTimer
extern SetDCBrushColor

section .data 
    ClassName       db "ball", 0h
    AppName         db "Bouncing Ball", 0h
    EditClassName   db  "edit", 0h


section .bss 
    hInstance       resq 1
    CommandLine     resq 1
    hwndEdit        resq 1
    hwndShow        resq 1
    hDC             resq 1
    brush           resq 1
    stepX           resq 1
    stepY           resq 1
    curX            resq 1
    curY            resq 1
    oldX            resq 1
    oldY            resq 1
    temp            resq 4
    rect            resq 4

struc RECT
    .left           resq 1
    .top            resq 1
    .right          resq 1
    .bottom         resq 1

section .text 
    global Start 

Start:
    call InitValue
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

InitValue:
    push rbp
    mov rbp, rsp

    mov dword [stepX], 5
    mov dword [stepY], 5
    mov dword [curX], 0
    mov dword [curY], 0
    mov dword [oldX], 0
    mov dword [oldY], 0
    
    mov rsp, rbp
    pop rbp
    ret

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
    sub rsp, 32
    mov rcx, WHITE_BRUSH
    call GetStockObject ; pen, brush, fonts, ...
    add rsp, 32
    mov qword [wc.hbrBackground], rax
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
    mov r9, WS_OVERLAPPEDWINDOW | WS_VISIBLE
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

    cmp qword [uMsg], WM_TIMER
    je WmTimer
    

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
    mov rcx, qword [hWnd]
    mov rdx, 1
    mov r8, 100
    mov r9, NULL
    call SetTimer
    add rsp, 32
    jmp WmEnd

WmTimer:
    ; get dc for drawing
    sub rsp, 32
    mov rcx, qword [hWnd]
    call GetDC  ; The GetDC function retrieves a handle to a device context (DC) for the client area of a specified window or for the entire screen.
    add rsp, 32
    mov qword [hDC], rax

    ; use pure white
    sub rsp, 32
    mov rcx, WHITE_BRUSH
    call GetStockObject ; The GetStockObject function retrieves a handle to one of the stock pens, brushes, fonts, or palettes.
    add rsp, 32

    sub rsp, 32
    mov rcx, hDC
    mov rdx, rax
    call SelectObject   ; The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type.
    add rsp, 32

    ; cover old ellipse
    mov qword [brush], rax
    mov rax, qword [oldX]
    mov qword [temp + RECT.left], rax
    mov rbx, qword [oldY] 
    mov qword [temp + RECT.top], rbx
    add rax, BallSize
    mov qword [temp + RECT.right], rax
    add rbx, BallSize
    mov qword [temp + RECT.bottom], rbx

    sub rsp, 32
    mov rcx, qword [hDC]
    mov rdx, temp
    mov r8, qword [brush]
    call FillRect   ; draw rectangle
    add rsp, 32

    ; use new color to draw new ellipse
    sub rsp, 32
    mov rcx, DC_BRUSH
    call GetStockObject 
    add rsp, 32

    sub rsp, 32
    mov rcx, qword [hDC]
    mov rdx, rax
    call SelectObject
    add rsp, 32
    mov qword [brush], rax

    ; Set red color to brush
    sub rsp, 32
    mov rcx, qword [hDC]
    mov rdx, RGB_RED
    call SetDCBrushColor
    add rsp, 32

    ; draw new ellipse
    mov rax, qword [curX]
    add rax, BallSize
    mov rbx, qword [curY]
    add rbx, BallSize


    sub rsp, 40
    mov rcx, qword [hDC]
    mov rdx, qword [curX]
    mov r8, qword [curY]
    mov r9, rax
    mov qword [rsp + 4*8], rbx
    call Ellipse    ; draw ellipse
    add rsp, 40

    ; update values
    mov rax, qword [curX]
    mov qword [oldX], rax
    mov rbx, qword [curY]
    mov qword [oldY], rbx
    add rax, qword [stepX]
    mov qword [curX], rax
    add rbx, qword [stepY]
    mov qword [curY], rbx

    ; get window size
    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, rect
    call GetClientRect
    add rsp, 32

    compareChangeX:
        mov rax, qword [curX]
        mov rbx, rax
        add rbx, BallSize
        cmp rbx, qword [rect + RECT.right]
        jae changeDirectX
        cmp rax, 0
        jbe changeDirectX
        jmp compareChangeY
    changeDirectX:
        mov rcx, qword [stepX]
        xor rdx, rdx 
        sub rdx, rcx 
        mov qword [stepX], rdx 

    compareChangeY:
        mov rax, [curY]
        mov rbx, rax
        add rbx, BallSize
        cmp rbx, qword [rect + RECT.bottom]
        jae changeDirectY
        cmp rax, 0
        jbe changeDirectY
        jmp WmTimerContinue

    changeDirectY:
        mov rcx, [stepY]
        xor rdx, rdx
        sub rdx, rcx 
        mov qword [stepY], rdx 
    
    WmTimerContinue: 
        sub rsp, 32
        mov rcx, qword [hDC]
        mov rdx, qword [brush]
        call SelectObject 
        add rsp, 32

        sub rsp, 32
        mov rcx, qword [hWnd]
        mov rdx, qword [hDC]
        call ReleaseDC
        add rsp, 32

        jmp WmEnd


WmDestroy:
    sub rsp, 32
    mov rcx, qword [hWnd]
    mov rdx, 1
    call KillTimer
    add rsp, 32

    sub rsp, 32
    mov rcx, NULL
    call PostQuitMessage
    add rsp, 32

WmEnd:
    xor rax, rax
    mov rsp, rbp
    pop rbp 
    ret 