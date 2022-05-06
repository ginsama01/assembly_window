.386        ; telling the assembler to use 80386 instruction set
.model flat, STDCALL    ; specifies memory model of your program
                        ; Win32 have only one model, FLAT
                        ; stdcall means our parameters are pushed from left to right

option casemap :none    ; this means our labels will be case sensitive

include \masm32\include\masm32rt.inc ; include library that include all needed library

.data?                  ; Data segment
    res db 32 dup(?)    ; initialize res variable 32 bytes
 
.code                   ; this directive tell MASM where the code begin
    
    uppercase proc      ; procedure
        lea ecx, res    ; move address of res to ecx register
        mov al, [ecx]   ; ecx is the pointer, so [ecx] is the current char
        .while TRUE
            .break .if (al == 10)   ; check if null character
            .break .if (al == 13)   ; check if enter character
            .if (al >= 97)
                .if (al <= 122)
                    sub al, 32      ; uppercase
                    mov [ecx], al   ; write current character back to string
                .endif
            .endif
            inc ecx                 ; next character
            mov al, [ecx]
        .endw   
        ret
    uppercase endp
    
    start:              ;the code entry point of the program
        invoke StdIn, addr res, 32 ; call StdIn
        invoke uppercase
        invoke StdOut, addr res ; call StdOut
        invoke ExitProcess, 0   ; exit program
    end start           ;the code end point of the program

    