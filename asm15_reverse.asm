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

%define wc                 EBP - 80             ; WNDCLASSEX structure. 48 bytes
%define wc.cbSize          EBP - 80
%define wc.style           EBP - 76
%define wc.lpfnWndProc     EBP - 72
%define wc.cbClsExtra      EBP - 68
%define wc.cbWndExtra      EBP - 64
%define wc.hInstance       EBP - 60
%define wc.hIcon           EBP - 56
%define wc.hCursor         EBP - 52
%define wc.hbrBackground   EBP - 48
%define wc.lpszMenuName    EBP - 44
%define wc.lpszClassName   EBP - 40
%define wc.hIconSm         EBP - 36

%define msg                EBP - 32             ; MSG structure. 28 bytes
%define msg.hwnd           EBP - 32             ; Breaking out each member is not necessary
%define msg.message        EBP - 28             ; in this case, but it shows where each
%define msg.wParam         EBP - 24             ; member is on the stack
%define msg.lParam         EBP - 20
%define msg.time           EBP - 16
%define msg.pt.x           EBP - 12
%define msg.pt.y           EBP - 8

%define hWnd               EBP - 4

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
    hInstance       resd 1
    CommandLine     resd 1
    hwndEdit        resd 1
    hwndShow        resd 1
    buffer          resb 1024
    revstr          resb 1024


section .text 
    global Start 

Start:
    push NULL
    call GetModuleHandleA
    mov dword [hInstance], eax

    call GetCommandLineA
    mov dword [CommandLine], eax

    call WinMain

exit:
    push NULL
    call ExitProcess

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
    mov dword [wc.hbrBackground], COLOR_WINDOW + 1
    mov dword [wc.lpszMenuName], NULL
    mov dword [wc.lpszClassName], ClassName

    push IDI_APPLICATION
    push NULL
    call LoadIconA
    mov dword [wc.hIcon], eax
    mov dword [wc.hIconSm], eax

    push IDC_ARROW
    push NULL
    call LoadCursorA
    mov dword [wc.hCursor], eax
    
    lea eax, [wc]
    push eax
    call RegisterClassExA

    push NULL
    push dword [hInstance]
    push NULL
    push NULL
    push WindowHeight
    push WindowWidth
    push CW_USEDEFAULT
    push CW_USEDEFAULT
    push WS_OVERLAPPEDWINDOW
    push AppName
    push ClassName
    push WS_EX_CLIENTEDGE
    call CreateWindowExA
    mov dword [hWnd], eax

    push SW_SHOWDEFAULT
    push dword [hWnd]
    call ShowWindow

    push dword [hWnd]
    call UpdateWindow

MessageLoop:
    lea eax, [msg]
    push NULL
    push NULL
    push NULL
    push eax
    call GetMessageA
    cmp eax, 0
    je MessageDone

    lea eax, [msg]
    push eax
    push dword [hWnd]
    call IsDialogMessageA
    cmp eax, 0
    jne MessageLoop

    lea eax, [msg]
    push eax
    call TranslateMessage

    lea eax, [msg]
    push eax
    call DispatchMessageA

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

    cmp dword [uMsg], WM_DESTROY
    je WmDestroy 

    cmp dword [uMsg], WM_CREATE
    je WmCreate 

    cmp dword [uMsg], WM_COMMAND
    je WmCommand

DefaultMessage:
    push dword [lParam]
    push dword [wParam]
    push dword [uMsg]
    push dword [hWnd]
    call DefWindowProcA

    mov esp, ebp
    pop ebp
    ret 16

WmCreate:
    push NULL
    push dword [hInstance]
    push EditID
    push dword [hWnd]
    push 25
    push WindowWidth - 75
    push 40
    push 25
    mov eax, WS_CHILD | WS_VISIBLE | WS_BORDER | ES_LEFT | ES_AUTOHSCROLL
    push eax
    push NULL
    push EditClassName
    push WS_EX_CLIENTEDGE
    call CreateWindowExA
    mov dword [hwndEdit], eax

    push dword [hwndEdit]
    call SetFocus

    push NULL
    push dword [hInstance]
    push ShowID
    push dword [hWnd]
    push 25
    push WindowWidth - 75
    push WindowHeight - 100
    push 25
    push WS_CHILD | WS_VISIBLE | WS_BORDER | ES_READONLY | ES_AUTOHSCROLL
    push NULL
    push EditClassName
    push WS_EX_CLIENTEDGE
    call CreateWindowExA
    mov dword [hwndShow], eax
    jmp WmEnd

WmCommand:
    mov eax, dword [wParam]
    cmp ax, EditID
    jne WmEnd

    push 1024
    push buffer
    push dword [hwndEdit]
    call GetWindowTextA

    push buffer
    push revstr
    call RevStr

    push revstr
    push dword [hwndShow]
    call SetWindowTextA

    jmp WmEnd
WmDestroy:
    push NULL
    call PostQuitMessage

WmEnd:
    xor eax, eax
    mov esp, ebp
    pop ebp 
    ret 16

RevStr:
    push ebp
    mov ebp, esp

    xor eax, eax
    xor ecx, ecx
    mov ebx, [ebp + 8]
    mov edx, [ebp + 12]

    next_char:
        mov al, [edx]
        cmp al, 0x0
        je before_reverse
        cmp al, 0xA
        je before_reverse
        push eax
        inc edx
        inc ecx
        jmp next_char
    
    before_reverse:
        mov dword [ebx], 0
        cmp ecx, 0
        je reverse_done

    reverse:
        pop eax
        mov [ebx], eax
        inc ebx
        loop reverse
    
    reverse_done:
        mov esp, ebp
	    pop ebp
        ret
    



