.386        ; telling the assembler to use 80386 instruction set
.model flat, STDCALL    ; specifies memory model of your program
                        ; Win32 have only one model, FLAT
                        ; stdcall means our parameters are pushed from left to right

option casemap :none    ; this means our labels will be case sensitive

include \masm32\include\masm32rt.inc ; include library that include all needed library

.data 
    num1 dd 0
    num2 dd 0

.data?                  ; Data segment
    res  db 32 dup(?)
 
.code                   ; this directive tell MASM where the code begin

    start:              ;the code entry point of the program
        mov num1, sval(input())   ; input number
        mov num2, sval(input())   ; input number
        mov eax, num1
        add eax, num2
        invoke dwtoa, eax, addr res ; convert register value to string ascii
        invoke StdOut, addr res ; call StdOut
        invoke ExitProcess, 0   ; exit program
    end start           ;the code end point of the program