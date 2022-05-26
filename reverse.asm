.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib      
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

.DATA                     
ClassName db "reverse", 0       
AppName db "Reverse Text", 0
EditClassName db "edit", 0

.DATA?   
hInstance HINSTANCE ?   
CommandLine LPSTR ?
hwndEdit HWND ?
hwndEdit2 HWND ?
buffer db 255 dup(?)
strRev db 255 dup(?)

.const
EditID equ 1
EditID2 equ 2

.CODE            
start:
	invoke GetModuleHandle, NULL   
	mov hInstance,eax
	invoke GetCommandLine                
	mov CommandLine,eax
	invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT 
	invoke ExitProcess, eax   

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX 
	LOCAL msg:MSG
	LOCAL hwnd:HWND

	mov   wc.cbSize,SIZEOF WNDCLASSEX  
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra,NULL
	mov   wc.cbWndExtra,NULL
	push  hInstance
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_WINDOW+1
	mov   wc.lpszMenuName,NULL
	mov   wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	invoke RegisterClassEx, addr wc      
	invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR ClassName, ADDR AppName, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT,\
                300, 180, NULL, NULL, hInst, NULL
	mov   hwnd,eax
	invoke ShowWindow, hwnd, CmdShow 
	invoke UpdateWindow, hwnd 
loopp:
	invoke GetMessage, ADDR msg,NULL,0,0
	cmp eax, 0
	je outloop
	invoke TranslateMessage, ADDR msg
	invoke DispatchMessage, ADDR msg
	jmp loopp
outloop:
    mov eax,msg.wParam
    ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	cmp uMsg, WM_DESTROY
	je heree
	cmp uMsg, WM_CREATE
	je hereee
	cmp uMsg, WM_COMMAND
	je hereeee
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	ret
hereeee:
	mov eax, wParam
	cmp ax, EditID
	jne outif
	invoke GetWindowText,hwndEdit,ADDR buffer,512
	cmp dword ptr[buffer],0
	je setNULL
	push offset buffer
	push offset strRev
	call revStr
	invoke SetWindowText,hwndEdit2,ADDR strRev
	jmp outif
setNULL:
	invoke SetWindowText,hwndEdit2,NULL
	jmp outif
	
hereee:
	invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                        ES_AUTOHSCROLL,\
                        50,35,175,25,hWnd,EditID,hInstance,NULL
	mov  hwndEdit,eax
	invoke SetFocus, hwndEdit
	invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or WS_BORDER or ES_READONLY or\
                        ES_AUTOHSCROLL,\
                        50,70,175,25,hWnd,EditID2,hInstance,NULL
	mov  hwndEdit2,eax
	jmp 	outif

heree:
	invoke PostQuitMessage, NULL
outif:
	xor eax, eax
	ret
WndProc endp

revStr proc
	push ebp
	mov ebp, esp

	mov edx, [ebp+12]
	mov ebx, [ebp+8]
	mov ecx, 254
	dec ecx
loopp:
	xor eax, eax
	mov al, byte ptr[edx+ecx]
	cmp eax, 0ah
	je outiff
	cmp eax, 0
	je outiff
	mov BYTE ptr[ebx],al
	inc ebx
outiff:
	dec ecx
	cmp ecx, 0
	jge loopp

	mov BYTE ptr[ebx],0
	xor ecx, ecx
	mov esp, ebp
	pop ebp
	ret
revStr endp

end start