; nasm -f win32 asm14_bouncingball.asm -o asm14_bouncingball.obj
; GoLink.exe /console asm14_bouncingball.obj kernel32.dll user32.dll gdi32.dll
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



%define wc                  EBP - 80            ; WNDCLASSEX structure. 48 bytes
%define wc.cbSize           EBP - 80            ; The size, in bytes, of this structure.
%define wc.style            EBP - 76            ; The class style(s)
%define wc.lpfnWndProc      EBP - 72            ; A pointer to the window procedure
%define wc.cbClsExtra       EBP - 68            ; The number of extra bytes to allocate following the window-class structure
%define wc.cbWndExtra       EBP - 64            ; The number of extra bytes to allocate following the window instance.
%define wc.hInstance        EBP - 60            ; A handle to the instance that contains the window procedure for the class.
%define wc.hIcon            EBP - 56            ; A handle to the class icon. This member must be a handle to an icon resource.
%define wc.hCursor          EBP - 52            ; A handle to the class cursor. 
%define wc.hbrBackground    EBP - 48            ; A handle to the class background brush.
%define wc.lpszMenuName     EBP - 44            ; Pointer to a null-terminated character string that specifies the resource name of the class menu, as the name appears in the resource file.
%define wc.lpszClassName    EBP - 40            ; A pointer to a null-terminated string or is an atom. 
%define wc.hIconSm          EBP - 36            ; A handle to a small icon that is associated with the window class.

%define msg                 EBP - 32             ; MSG structure. 28 bytes
%define msg.hwnd            EBP - 32             ; Breaking out each member is not necessary
%define msg.message         EBP - 28             ; in this case, but it shows where each
%define msg.wParam          EBP - 24             ; member is on the stack
%define msg.lParam          EBP - 20
%define msg.time            EBP - 16
%define msg.pt.x            EBP - 12
%define msg.pt.y            EBP - 8

%define hWnd                EBP - 4

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
    hInstance       resd 1
    CommandLine     resd 1
    hwndEdit        resd 1
    hwndShow        resd 1
    hDC             resd 1
    brush           resd 1
    stepX           resd 1
    stepY           resd 1
    curX            resd 1
    curY            resd 1
    oldX            resd 1
    oldY            resd 1
    temp            resq 4
    rect            resq 4

struc RECT
    .left           resd 1
    .top            resd 1
    .right          resd 1
    .bottom         resd 1

section .text 
    global Start 

Start:
    call InitValue  
    push NULL
    call GetModuleHandleA  ; Retrieves a module handle for the specified module. The module must have been loaded by the calling process
    mov dword [hInstance], eax

    call GetCommandLineA    ; Retrieves the command-line string for the current process.
    mov dword [CommandLine], eax

    call WinMain

exit:
    push NULL
    call ExitProcess

InitValue:
    mov dword [stepX], 5
    mov dword [stepY], 5
    mov dword [curX], 0
    mov dword [curY], 0
    mov dword [oldX], 0
    mov dword [oldY], 0
    ret

WinMain:
    ; Set up a stack frame
    ; Space for 80 bytes of local variables
    push ebp
    mov ebp, esp
    sub esp, 80

    mov dword [wc.cbSize], 48
    mov dword [wc.style], CS_HREDRAW | CS_VREDRAW   
    mov dword [wc.lpfnWndProc], WndProc
    mov dword [wc.cbClsExtra], NULL
    mov dword [wc.cbWndExtra], NULL
    mov eax, dword [hInstance]
    mov dword [wc.hInstance], eax
    push WHITE_BRUSH
    call GetStockObject ; pen, brush, fonts, ...
    mov dword [wc.hbrBackground], eax
    mov dword [wc.lpszMenuName], NULL
    mov dword [wc.lpszClassName], ClassName

    push IDI_APPLICATION    
    push NULL
    call LoadIconA  ; load icon
    mov dword [wc.hIcon], eax
    mov dword [wc.hIconSm], eax

    push IDC_ARROW
    push NULL
    call LoadCursorA    ; load cursor
    mov dword [wc.hCursor], eax

    lea eax, [wc]
    push eax
    call RegisterClassExA   ; register a window class for createwindow

    push NULL
    push dword [hInstance]
    push NULL
    push NULL
    push WindowHeight
    push WindowWidth
    push CW_USEDEFAULT  
    push CW_USEDEFAULT
    push WS_OVERLAPPEDWINDOW | WS_VISIBLE
    push AppName
    push ClassName
    push WS_EX_CLIENTEDGE
    call CreateWindowExA    ; create window
    mov dword [hWnd], eax

    push SW_SHOWDEFAULT
    push dword [hWnd]
    call ShowWindow ; Sets the specified window's show state.

    push dword [hWnd]
    call UpdateWindow ;The UpdateWindow function updates the client area of the specified window by sending a WM_PAINT message to the window if the window's update region is not empty.

MessageLoop:
    lea eax, [msg]
    push NULL
    push NULL
    push NULL
    push eax
    call GetMessageA    ; Retrieves a message from the calling thread's message queue.
    cmp eax, 0
    je MessageDone  

    lea eax, [msg]
    push eax
    call TranslateMessage   ; Translates virtual-key messages into character messages. 

    lea eax, [msg]
    push eax
    call DispatchMessageA   ; Dispatches a message to a window procedure. It is typically used to dispatch a message retrieved by the GetMessage function.

    jmp MessageLoop

MessageDone:
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret

%define hWnd    EBP + 8                         ; Location of the 4 passed parameters from
%define uMsg    EBP + 12                        ; the calling function
%define wParam  EBP + 16                        ; We can now access these parameters by name
%define lParam  EBP + 20

WndProc:
    ; Set up a stack frame
    push ebp
    mov ebp, esp
    ; catch message
    cmp dword [uMsg], WM_DESTROY
    je WmDestroy

    cmp dword [uMsg], WM_CREATE
    je WmCreate

    cmp dword [uMsg], WM_TIMER
    je WmTimer
    

DefaultMessage:
    push dword [lParam]
    push dword [wParam]
    push dword [uMsg]
    push dword [hWnd]
    call DefWindowProcA ; Calls the default window procedure to provide default processing for any window messages that an application does not process

    mov esp, ebp
    pop ebp
    ret 16

WmCreate:
    push NULL
    push 100
    push 1
    push dword [hWnd]
    call SetTimer
    jmp WmEnd

WmTimer:
    ; get dc for drawing
    push dword [hWnd]
    call GetDC  ; The GetDC function retrieves a handle to a device context (DC) for the client area of a specified window or for the entire screen.
    mov dword [hDC], eax

    ; use pure white
    push WHITE_BRUSH
    call GetStockObject ; The GetStockObject function retrieves a handle to one of the stock pens, brushes, fonts, or palettes.

    push eax
    push hDC
    call SelectObject   ; The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type.

    ; cover old ellipse
    mov dword [brush], eax
    mov eax, dword [oldX]
    mov dword [temp + RECT.left], eax
    mov ebx, dword [oldY] 
    mov dword [temp + RECT.top], ebx
    add eax, BallSize
    mov dword [temp + RECT.right], eax
    add ebx, BallSize
    mov dword [temp + RECT.bottom], ebx

    push dword [brush]
    push temp
    push dword [hDC]
    call FillRect   ; draw rectangle

    ; use new color to draw new ellipse
    push DC_BRUSH
    call GetStockObject 

    push eax
    push dword [hDC]
    call SelectObject
    mov dword [brush], eax

    ; Set red color to brush
    push RGB_RED
    push dword [hDC]
    call SetDCBrushColor

    ; draw new ellipse
    mov eax, dword [curX]
    add eax, BallSize
    mov ebx, dword [curY]
    add ebx, BallSize
    push ebx
    push eax
    push dword [curY]
    push dword [curX]
    push dword [hDC]
    call Ellipse    ; draw ellipse

    ; update values
    mov eax, dword [curX]
    mov dword [oldX], eax
    mov ebx, dword [curY]
    mov dword [oldY], ebx
    add eax, dword [stepX]
    mov dword [curX], eax
    add ebx, dword [stepY]
    mov dword [curY], ebx

    ; get window size
    push rect
    push dword [hWnd]
    call GetClientRect

    compareChangeX:
        mov eax, dword [curX]
        mov ebx, eax
        add ebx, BallSize
        cmp ebx, dword [rect + RECT.right]
        jae changeDirectX
        cmp eax, 0
        jbe changeDirectX
        jmp compareChangeY
    changeDirectX:
        mov ecx, dword [stepX]
        xor edx, edx 
        sub edx, ecx 
        mov dword [stepX], edx 

    compareChangeY:
        mov eax, [curY]
        mov ebx, eax
        add ebx, BallSize
        cmp ebx, dword [rect + RECT.bottom]
        jae changeDirectY
        cmp eax, 0
        jbe changeDirectY
        jmp WmTimerContinue

    changeDirectY:
        mov ecx, [stepY]
        xor edx, edx
        sub edx, ecx 
        mov dword [stepY], edx 
    
    WmTimerContinue: 
        push dword [brush] 
        push dword [hDC] 
        call SelectObject 

        push dword [hDC]
        push dword [hWnd] 
        call ReleaseDC
        jmp WmEnd


WmDestroy:
    push 1
    push dword [hWnd]
    call KillTimer

    push NULL
    call PostQuitMessage

WmEnd:
    xor eax, eax
    mov esp, ebp
    pop ebp 
    ret 16