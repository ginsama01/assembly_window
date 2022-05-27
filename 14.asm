.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib      
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
include \masm32\include\Advapi32.inc
includelib \masm32\lib\Advapi32.lib
include \masm32\include\gdi32.inc
includelib \masm32\lib\gdi32.lib

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
.DATA                     
ClassName db "The Bouncing Ball Program", 0       
AppName db "BouncingBall", 0
EditClassName db "edit", 0

d_X dd 0
d_Y dd 0
x dd 0
y dd 0
x_right dd 0
y_bottom dd 0
old_X dd 0
old_Y dd 0
color dd 0

_SYSTEMTIME struct
wYear WORD 0;
wMonth WORD 0;
wDayOfWeek WORD 0;
wDay WORD 0;
wHour WORD 0;
wMinute WORD 0;
wSecond WORD 0;
wMilliseconds WORD 0;
_SYSTEMTIME ends

sys_time _SYSTEMTIME <>

.DATA?   
hInstance HINSTANCE ?   
CommandLine LPSTR ?		; Con tr? xâu ký t? ki?u ANSI (8-bit)
.const

.CODE            
start:
	mov x, 50
	mov y, 50
	invoke GetSystemTime, addr sys_time
	
	xor edx, edx
	xor eax, eax
	mov ax, sys_time.wMilliseconds
	xor ebx, ebx
	mov bx, sys_time.wSecond
	mul ebx
	mov bx, sys_time.wMinute
	mov ebx, 1000
	div ebx
	mov x, edx
	
	xor edx, edx
	xor eax, eax
	add ax, sys_time.wMilliseconds
	xor ebx, ebx
	mov bx, sys_time.wSecond
	mul ebx
	mov bx, sys_time.wMinute
	mov ebx, 1000
	div ebx
	mov y, edx
	
	xor eax, eax
	
	mov ax, sys_time.wMilliseconds;
	
	cmp eax, 30
	jle DIRECTION_X
		mov d_X, 5
	jmp END_DIRECTION_X
	DIRECTION_X:
		mov d_X, 5 
	END_DIRECTION_X:

	xor eax, eax
	mov ax, sys_time.wSecond;
	cmp eax, 30
	jle DIRECTION_Y
		mov d_Y, -5
	jmp END_DIRECTION_Y
	DIRECTION_Y:
		mov d_Y, 5 
	END_DIRECTION_Y:
	
	invoke GetModuleHandle, NULL   ; module handle return in eax
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
	invoke LoadIcon,NULL,IDI_EXCLAMATION
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax

	invoke RegisterClassEx, addr wc      
	invoke CreateWindowEx,WS_EX_CLIENTEDGE,\
				ADDR ClassName, ADDR AppName,\
				WS_OVERLAPPEDWINDOW OR WS_VISIBLE, CW_USEDEFAULT, CW_USEDEFAULT,\
                1000, 1000,\
				NULL, NULL, hInst, NULL
	mov   hwnd,eax
	; invoke ShowWindow, hwnd, CmdShow 
	; invoke UpdateWindow, hwnd 
	
	GET_MESSAGE_LOOP:
		invoke GetMessage, ADDR msg,NULL,0,0
		cmp eax, 0
		je GET_MESSAGE_END_LOOP
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
		jmp GET_MESSAGE_LOOP
	GET_MESSAGE_END_LOOP:
    mov eax,msg.wParam ; return (msg.wParam); standard return value
    ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM	
	LOCAL wc:WNDCLASSEX
	LOCAL hDC: HDC
	LOCAL brush: HBRUSH
	LOCAL hcn: RECT 			; hcn: hình ch? nh?t
	LOCAL temp_hcn: RECT
	cmp uMsg, WM_CREATE
	je SET_TIMER
	cmp uMsg, WM_TIMER
	je PROCESS_COMMAND
	cmp uMsg, WM_DESTROY
	je TURN_OFF_PROGRAM
	jmp Windows_handle_other_message
	ret

SET_TIMER:
	invoke SetTimer, hWnd, 1, 20, NULL
	ret

PROCESS_COMMAND:
	invoke GetDC, hWnd
	mov hDC, eax
	
	invoke GetStockObject, BLACK_BRUSH
	mov color, eax
	
	invoke SelectObject, hDC, color
	mov brush, eax
	
	mov eax, old_X
	mov temp_hcn.left, eax
	mov eax, old_Y
	mov	temp_hcn.top, eax
	mov eax, old_X
	add eax, 30
	mov	temp_hcn.right, eax
	mov eax, old_Y
	add eax, 30
	mov	temp_hcn.bottom, eax
	
	invoke FillRect, hDC, addr temp_hcn, brush
	
	invoke GetStockObject, GRAY_BRUSH
	mov color, eax 
	
	invoke SelectObject, hDC, color
	mov brush, eax
	
	mov eax, x
	add eax, 30
	mov x_right, eax
	mov eax, y
	add eax, 30
	mov y_bottom, eax
	invoke Ellipse, hDC, x, y , x_right , y_bottom
	
	push x
	pop old_X
	push y
	pop old_Y
	
	mov eax, x
	add eax, d_X
	mov x, eax
	mov eax, y
	add eax, d_Y
	mov y, eax
	
	invoke GetClientRect, hWnd, addr hcn
	mov eax, x
	add eax, 30
	cmp eax, hcn.right
	jg CONDITION_TRUE_1
	cmp x, 0
	jg END_IF_1
	CONDITION_TRUE_1:
		mov eax, d_X
		mov ebx, -1
		imul ebx
		mov d_X, eax
	END_IF_1:
	
	mov eax, y
	add eax, 30
	cmp eax, hcn.bottom
	jg CONDITION_TRUE_2
	cmp y, 0
	jg END_IF_2
	CONDITION_TRUE_2:
		mov eax, d_Y
		mov ebx, -1
		imul ebx
		mov d_Y, eax
	END_IF_2:
	
	invoke SelectObject, hDC, brush
	
	invoke ReleaseDC, hWnd, hDC
	ret
	
TURN_OFF_PROGRAM:
	invoke KillTimer, hWnd, 1 		; destroy the timer of event 1
	invoke PostQuitMessage, NULL	; end the program
	ret
Windows_handle_other_message: 
	invoke DefWindowProc, hWnd, uMsg, wParam, lParam
	ret
WndProc endp

end start