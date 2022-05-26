; nasm -f win64 asm13_peheader.asm -o asm13_peheader.obj
; GoLink.exe /console asm13_peheader.obj kernel32.dll user32.dll

; Structures' definitions
struc IMAGE_DOS_HEADER
    .e_magic    resw 1 
    .e_cblp     resw 1
    .e_cp       resw 1
    .e_crlc     resw 1
    .e_cparhdr  resw 1
    .e_minalloc resw 1
    .e_maxalloc resw 1
    .e_ss       resw 1
    .e_sp       resw 1
    .e_csum     resw 1
    .e_ip       resw 1
    .e_cs       resw 1
    .e_lfarlc   resw 1
    .e_ovno     resw 1
    .e_res      resw 4
    .e_oemid    resw 1
    .e_oeminfo  resw 1
    .e_res2     resw 10
    .e_lfanew   resd 1
endstruc

struc IMAGE_NT_HEADER
    .Signature              resd 1
    .FileHeader             resb 20
    .OptionalHeader         resb 240
endstruc

struc IMAGE_FILE_HEADER
    .Machine                resw 1
    .NumberOfSections       resw 1
    .TimeDateStamp          resd 1
    .PointerToSymbolTable   resd 1
    .NumberOfSymbols        resd 1
    .SizeOfOptionalHeader   resw 1
    .Characteristics        resw 1
endstruc

struc IMAGE_OPTIONAL_HEADER
    .Magic                        resw 1
    .MajorLinkerVersion           resb 1
    .MinorLinkerVersion           resb 1
    .SizeOfCode                   resd 1
    .SizeOfInitializedData        resd 1
    .SizeOfUninitializedData      resd 1
    .AddressOfEntryPoint          resd 1
    .BaseOfCode                   resd 1
    .BaseOfData                   resd 1
    .ImageBase                    resd 1
    .SectionAlignment             resd 1
    .FileAlignment                resd 1
    .MajorOperatingSystemVersion  resw 1
    .MinorOperatingSystemVersion  resw 1
    .MajorImageVersion            resw 1
    .MinorImageVersion            resw 1
    .MajorSubsystemVersion        resw 1
    .MinorSubsystemVersion        resw 1
    .Win32VersionValue            resd 1
    .SizeOfImage                  resd 1
    .SizeOfHeaders                resd 1
    .CheckSum                     resd 1
    .Subsystem                    resw 1
    .DllCharacteristics           resw 1
    .SizeOfStackReserve           resd 1
    .SizeOfStackCommit            resd 1
    .SizeOfHeapReserve            resd 1
    .SizeOfHeapCommit             resd 1
    .LoaderFlags                  resd 1
    .NumberOfRvaAndSizes          resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress          resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.Size                    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress          resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.Size                    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.VirtualAddress        resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.Size                  resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.VirtualAddress       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.Size                 resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.VirtualAddress        resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.Size                  resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.VirtualAddress       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.Size                 resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.VirtualAddress           resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.Size                     resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.VirtualAddress    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.Size              resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.VirtualAddress       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.Size                 resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.VirtualAddress             resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.Size                       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.VirtualAddress     resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.Size               resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.VirtualAddress    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.Size              resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.VirtualAddress             resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.Size                       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.VirtualAddress    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.Size              resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.VirtualAddress  resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.Size            resd 1
endstruc

struc IMAGE_SECTION_HEADER
    .Name                   resb 8
    .VirtualSize            resd 1
    .VirtualAddress         resd 1
    .SizeOfRawData          resd 1
    .PointerToRawData       resd 1
    .PointerToRelocations   resd 1
    .PointerToLinenumbers   resd 1
    .NumberOfRelocations    resw 1
    .NumberOfLinenumbers    resw 1
    .Characteristics        resd 1
endstruc

struc IMAGE_OPTIONAL_HEADER64
    .Magic                        resw 1
    .MajorLinkerVersion           resb 1
    .MinorLinkerVersion           resb 1
    .SizeOfCode                   resd 1
    .SizeOfInitializedData        resd 1
    .SizeOfUninitializedData      resd 1
    .AddressOfEntryPoint          resd 1
    .BaseOfCode                   resd 1
    .ImageBase                    resq 1
    .SectionAlignment             resd 1
    .FileAlignment                resd 1
    .MajorOperatingSystemVersion  resw 1
    .MinorOperatingSystemVersion  resw 1
    .MajorImageVersion            resw 1
    .MinorImageVersion            resw 1
    .MajorSubsystemVersion        resw 1
    .MinorSubsystemVersion        resw 1
    .Win32VersionValue            resd 1
    .SizeOfImage                  resd 1
    .SizeOfHeaders                resd 1
    .CheckSum                     resd 1
    .Subsystem                    resw 1
    .DllCharacteristics           resw 1
    .SizeOfStackReserve           resq 1
    .SizeOfStackCommit            resq 1
    .SizeOfHeapReserve            resq 1
    .SizeOfHeapCommit             resq 1
    .LoaderFlags                  resd 1
    .NumberOfRvaAndSizes          resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress          resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.Size                    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress          resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.Size                    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.VirtualAddress        resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.Size                  resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.VirtualAddress       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.Size                 resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.VirtualAddress        resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.Size                  resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.VirtualAddress       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.Size                 resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.VirtualAddress           resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.Size                     resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.VirtualAddress    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.Size              resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.VirtualAddress       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.Size                 resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.VirtualAddress             resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.Size                       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.VirtualAddress     resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.Size               resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.VirtualAddress    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.Size              resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.VirtualAddress             resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.Size                       resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.VirtualAddress    resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.Size              resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.VirtualAddress  resd 1
    .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.Size            resd 1
endstruc

struc IMAGE_IMPORT_DESCRIPTOR
    .OriginalFirstThunk     resd 1    ; 0 for terminating null import descriptor, RVA to original unbound IAT (PIMAGE_THUNK_DATA)
    .TimeDateStamp          resd 1    ; 0 if not bound,
                                ; -1 if bound, and real date\time stamp
                                ;    in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT (new BIND)
                                ;    O.W. date/time stamp of DLL bound to (Old BIND)
    .ForwarderChain         resd 1  ; -1 if no forwarders
    .Name                   resd 1
    .FirstThunk             resd 1  ; RVA to IAT (if bound this IAT has actual addresses)
endstruc

struc IMAGE_EXPORT_DIRECTORY
    .Characteristics            resd 1
    .TimeDateStamp              resd 1
    .MajorVersion               resw 1
    .MinorVersion               resw 1
    .Name                       resd 1
    .Base                       resd 1
    .NumberOfFunctions          resd 1
    .NumberOfNames              resd 1
    .AddressOfFunctions         resd 1
    .AddressOfNames             resd 1
    .AddressOfNameOrdinals      resd 1

; Macro for easier life
; print field of struc by base address, struct type, field name, and size in bytes (to print as hex)
%macro printField 4
    lea rcx, [%2_MSG%3]
    call strPrint


    mov rax, %1
    mov rbx, %2%3
    xor rcx, rcx

    %if %4 == 1
    mov cl, [rax+rbx]
    %elif %4 == 2
    mov cx,  [rax+rbx]
    %elif %4 == 4
    mov ecx, [rax+rbx]
    %elif %4 == 8
    mov rcx, [rax+rbx]
    %endif

    mov rdx, %4
    call nHexPrint
    lea rcx, [clrf]
    call strPrint

%endmacro

extern GetStdHandle
extern ReadConsoleA
extern WriteConsoleA
extern ExitProcess
extern GetFileSize
extern ReadFile
extern WriteFile
extern HeapAlloc
extern HeapFree
extern HeapDestroy
extern GetProcessHeap
extern CreateFileA


section .data 
    clrf db 0dh, 0ah, 0
    space db 20h, 0
    minus db '-', 0
    inputMsg db 'Enter file path: ', 0
    fileErrorMsg db 'Cannot read file or not PE32/32+ file', 0ah, 0dh, 0
    tab db 9, 0
    hex db '0123456789abcdef', 0
    dataDirectoryMsg db '*******  DATA DIRECTORY *******', 0Ah, 0Dh, 0

    IMAGE_DOS_HEADER_MSG:
        db '******* DOS HEADER *******', 0Ah, 0Dh, 0
        .e_magic db 9, 'e_magic: 0x', 0
        .e_cblp db 9, 'e_cblp: 0x', 0
        .e_cp db 9, 'e_cp: 0x', 0
        .e_crlc db 9, 'e_crlc: 0x', 0
        .e_cparhdr db 9, 'e_cparhdr: 0x', 0
        .e_minalloc db 9, 'e_minalloc: 0x', 0
        .e_maxalloc db 9, 'e_maxalloc: 0x', 0
        .e_ss db 9, 'e_ss: 0x', 0
        .e_sp db 9, 'e_sp: 0x', 0
        .e_csum db 9, 'e_csum: 0x', 0
        .e_ip db 9, 'e_ip: 0x', 0
        .e_cs db 9, 'e_cs: 0x', 0
        .e_lfarlc db 9, 'e_lfarlc: 0x', 0
        .e_ovno db 9, 'e_ovno: 0x', 0
        .e_oemid db 9, 'e_oemid: 0x', 0
        .e_oeminfo db 9, 'e_oeminfo: 0x', 0
        .e_lfanew db 9, 'e_lfanew: 0x', 0
    IMAGE_NT_HEADER_MSG:
        db '******* NT HEADER *******', 0Ah, 0Dh, 0
        .Signature db 9, 'Signature: 0x', 0

    IMAGE_FILE_HEADER_MSG:
        db '******* COFF FILE HEADER *******', 0Ah, 0Dh, 0
        .Machine                db 9, 'Machine: 0x', 0
        .NumberOfSections       db 9, 'NumberOfSections: 0x', 0
        .TimeDateStamp          db 9, 'TimeDateStamp: 0x', 0
        .PointerToSymbolTable   db 9, 'PointerToSymbolTable: 0x', 0
        .NumberOfSymbols        db 9, 'NumberOfSymbols: 0x', 0
        .SizeOfOptionalHeader   db 9, 'SizeOfOptionalHeader: 0x', 0
        .Characteristics        db 9, 'Characteristics: 0x', 0

    IMAGE_OPTIONAL_HEADER_MSG:
        db '******* OPTIONAL HEADER *******', 0Ah, 0Dh, 0
        .Magic                        db 9, 'Magic: 0x', 0
        .MajorLinkerVersion           db 9, 'MajorLinkerVersion: 0x', 0
        .MinorLinkerVersion           db 9, 'MinorLinkerVersion: 0x', 0
        .SizeOfCode                   db 9, 'SizeOfCode: 0x', 0
        .SizeOfInitializedData        db 9, 'SizeOfInitializedData: 0x', 0
        .SizeOfUninitializedData      db 9, 'SizeOfUninitializedData: 0x', 0
        .AddressOfEntryPoint          db 9, 'AddressOfEntryPoint: 0x', 0
        .BaseOfCode                   db 9, 'BaseOfCode: 0x', 0
        .BaseOfData                   db 9, 'BaseOfData: 0x', 0
        .ImageBase                    db 9, 'ImageBase:', 0
        .SectionAlignment             db 9, 'SectionAlignment: 0x', 0
        .FileAlignment                db 9, 'FileAlignment: 0x', 0
        .MajorOperatingSystemVersion  db 9, 'MajorOperatingSystemVersion: 0x', 0
        .MinorOperatingSystemVersion  db 9, 'MinorOperatingSystemVersion: 0x', 0
        .MajorImageVersion            db 9, 'MajorImageVersion: 0x', 0
        .MinorImageVersion            db 9, 'MinorImageVersion: 0x', 0
        .MajorSubsystemVersion        db 9, 'MajorSubsystemVersion: 0x', 0
        .MinorSubsystemVersion        db 9, 'MinorSubsystemVersion: 0x', 0
        .Win32VersionValue            db 9, 'Win32VersionValue: 0x', 0
        .SizeOfImage                  db 9, 'SizeOfImage: 0x', 0
        .SizeOfHeaders                db 9, 'SizeOfHeaders: 0x', 0
        .CheckSum                     db 9, 'CheckSum: 0x', 0
        .Subsystem                    db 9, 'Subsystem: 0x', 0
        .DllCharacteristics           db 9, 'DllCharacteristics: 0x', 0
        .SizeOfStackReserve           db 9, 'SizeOfStackReserve: 0x', 0
        .SizeOfStackCommit            db 9, 'SizeOfStackCommit: 0x', 0
        .SizeOfHeapReserve            db 9, 'SizeOfHeapReserve: 0x', 0
        .SizeOfHeapCommit             db 9, 'SizeOfHeapCommit: 0x', 0
        .LoaderFlags                  db 9, 'LoaderFlags: 0x', 0
        .NumberOfRvaAndSizes          db 9, 'NumberOfRvaAndSizes: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress          db 9, 'Export Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.Size                    db 9, 'Export Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress          db 9, 'Import Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.Size                    db 9, 'Import Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.VirtualAddress        db 9, 'Resource Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.Size                  db 9, 'Resource Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.VirtualAddress       db 9, 'Exception Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.Size                 db 9, 'Exception Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.VirtualAddress        db 9, 'Security Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.Size                  db 9, 'Security Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.VirtualAddress       db 9, 'Relocation Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.Size                 db 9, 'Relocation Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.VirtualAddress           db 9, 'Debug Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.Size                     db 9, 'Debug Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.VirtualAddress    db 9, 'Architechture Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.Size              db 9, 'Architechture Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.VirtualAddress       db 9, 'Reserved: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.Size                 db 9, 'Reserved: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.VirtualAddress             db 9, 'TLS Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.Size                       db 9, 'TLS Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.VirtualAddress     db 9, 'Configuration Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.Size               db 9, 'Configuration Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.VirtualAddress    db 9, 'Bound Import Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.Size              db 9, 'Bound Import Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.VirtualAddress             db 9, 'Import Address Table Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.Size                       db 9, 'Import Address Table Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.VirtualAddress    db 9, 'Delay Import Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.Size              db 9, 'Delay Import Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.VirtualAddress  db 9, '.NET MetaData Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.Size            db 9, '.NET MetaDataDirectory Size: 0x', 0



    IMAGE_OPTIONAL_HEADER64_MSG:
        db '******* OPTIONAL HEADER *******', 0Ah, 0Dh, 0
        .Magic                        db 9, 'Magic: 0x', 0
        .MajorLinkerVersion           db 9, 'MajorLinkerVersion: 0x', 0
        .MinorLinkerVersion           db 9, 'MinorLinkerVersion: 0x', 0
        .SizeOfCode                   db 9, 'SizeOfCode: 0x', 0
        .SizeOfInitializedData        db 9, 'SizeOfInitializedData: 0x', 0
        .SizeOfUninitializedData      db 9, 'SizeOfUninitializedData: 0x', 0
        .AddressOfEntryPoint          db 9, 'AddressOfEntryPoint: 0x', 0
        .BaseOfCode                   db 9, 'BaseOfCode: 0x', 0
        .ImageBase                    db 9, 'ImageBase:', 0
        .SectionAlignment             db 9, 'SectionAlignment: 0x', 0
        .FileAlignment                db 9, 'FileAlignment: 0x', 0
        .MajorOperatingSystemVersion  db 9, 'MajorOperatingSystemVersion: 0x', 0
        .MinorOperatingSystemVersion  db 9, 'MinorOperatingSystemVersion: 0x', 0
        .MajorImageVersion            db 9, 'MajorImageVersion: 0x', 0
        .MinorImageVersion            db 9, 'MinorImageVersion: 0x', 0
        .MajorSubsystemVersion        db 9, 'MajorSubsystemVersion: 0x', 0
        .MinorSubsystemVersion        db 9, 'MinorSubsystemVersion: 0x', 0
        .Win32VersionValue            db 9, 'Win32VersionValue: 0x', 0
        .SizeOfImage                  db 9, 'SizeOfImage: 0x', 0
        .SizeOfHeaders                db 9, 'SizeOfHeaders: 0x', 0
        .CheckSum                     db 9, 'CheckSum: 0x', 0
        .Subsystem                    db 9, 'Subsystem: 0x', 0
        .DllCharacteristics           db 9, 'DllCharacteristics: 0x', 0
        .SizeOfStackReserve           db 9, 'SizeOfStackReserve: 0x', 0
        .SizeOfStackCommit            db 9, 'SizeOfStackCommit: 0x', 0
        .SizeOfHeapReserve            db 9, 'SizeOfHeapReserve: 0x', 0
        .SizeOfHeapCommit             db 9, 'SizeOfHeapCommit: 0x', 0
        .LoaderFlags                  db 9, 'LoaderFlags: 0x', 0
        .NumberOfRvaAndSizes          db 9, 'NumberOfRvaAndSizes: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress          db 9, 'Export Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.Size                    db 9, 'Export Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress          db 9, 'Import Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.Size                    db 9, 'Import Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.VirtualAddress        db 9, 'Resource Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.Size                  db 9, 'Resource Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.VirtualAddress       db 9, 'Exception Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.Size                 db 9, 'Exception Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.VirtualAddress        db 9, 'Security Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.Size                  db 9, 'Security Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.VirtualAddress       db 9, 'Relocation Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.Size                 db 9, 'Relocation Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.VirtualAddress           db 9, 'Debug Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.Size                     db 9, 'Debug Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.VirtualAddress    db 9, 'Architechture Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.Size              db 9, 'Architechture Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.VirtualAddress       db 9, 'Reserved: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.Size                 db 9, 'Reserved: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.VirtualAddress             db 9, 'TLS Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.Size                       db 9, 'TLS Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.VirtualAddress     db 9, 'Configuration Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.Size               db 9, 'Configuration Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.VirtualAddress    db 9, 'Bound Import Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.Size              db 9, 'Bound Import Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.VirtualAddress             db 9, 'Import Address Table Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.Size                       db 9, 'Import Address Table Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.VirtualAddress    db 9, 'Delay Import Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.Size              db 9, 'Delay Import Directory Size: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.VirtualAddress  db 9, '.NET MetaData Directory RVA: 0x', 0
        .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.Size            db 9, '.NET MetaDataDirectory Size: 0x', 0

    IMAGE_SECTION_HEADER_MSG:
        db '******* SECTION HEADER *******', 0Ah, 0Dh, 0
        .Name                   db 9, 'Name: ', 0
        .VirtualSize            db 9, 'VirtualSize: 0x', 0
        .VirtualAddress         db 9, 'VirtualAddress: 0x', 0
        .SizeOfRawData          db 9, 'SizeOfRawData: 0x', 0
        .PointerToRawData       db 9, 'PointerToRawData: 0x', 0
        .PointerToRelocations   db 9, 'PointerToRelocation: 0x', 0 
        .PointerToLinenumbers   db 9, 'PointerToLinenumbers: 0x', 0
        .NumberOfRelocations    db 9, 'NumberOfRelocations: 0x', 0
        .NumberOfLinenumbers    db 9, 'NumberOfLinenumbers: 0x', 0
        .Characteristics        db 9, 'Characteristics: 0x', 0

    IMAGE_IMPORT_DIRECTORY_MSG:
        db '******* IMPORT DIRECTORY *******', 0Ah, 0Dh, 0


    IMAGE_EXPORT_DIRECTORY_MSG:
        db '******* EXPORT DIRECTORY *******', 0Ah, 0Dh, 0

section .bss 
    nCharRead resd 1
    nCharWritten resd 1
    filePath resb 255
    fileHandle resq 1
    fileSize resq 1
    fileDat resq 1
    dosHeader resq 1
    ntHeader resq 1
    fileHeader resq 1
    optionalHeader resq 1
    sectionHeader resq 1
    importRVA resd 1
    exportRVA resd 1
    importSection resq 1
    exportSection resq 1
    nSections resq 1
    importDirectory resq 1
    importDescriptor resq 1
    exportDirectory resq 1
    exportDescriptor resq 1
    nExportNames resd 1
    names resq 1
    tmp resq 1
section .text
    global Start
Start:
    lea rcx, [inputMsg]
    call strPrint

    lea rcx, [filePath] 
    call strRead

    ; call create file then allocate heap for read file size
    lea rcx, [filePath] 
    mov rdx, 80000000h ; dwDesiredAcess = GENERIC_READ
    xor r8, r8
    xor r9, r9
    sub rsp, 48h
    mov qword [rsp+0x20], 3 ; OPEN_EXISTING
    mov qword [rsp+0x28], 80h; FILE_ATTRIBUTE_NORMAL
    mov qword [rsp+0x30], 0
    call CreateFileA
    add rsp, 48h

    cmp rax, -1
    je fileError
    mov [fileHandle], rax

    mov rcx, [fileHandle]
    xor rdx, rdx
    sub rsp, 28h
    call GetFileSize
    mov [fileSize], rax

    call GetProcessHeap
    mov rcx, rax
    xor rdx, rdx
    mov r8, [fileSize]
    call HeapAlloc
    mov [fileDat], rax
    mov [dosHeader], rax

    mov rcx, [fileHandle]
    mov rdx, [fileDat]
    mov r8, [fileSize]
    lea r9, [nCharRead]
    mov qword [rsp+20h], 0
    call ReadFile
    add rsp, 28h

    mov rax, [fileDat]
    cmp word [rax], 0x5a4d ; MZ
    jne fileError

; --------- Print DOS HEADER
    lea rcx, IMAGE_DOS_HEADER_MSG
    call strPrint


    ; base address, struct type, fieldname, size in byte
    printField [dosHeader], IMAGE_DOS_HEADER, .e_magic, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_cblp, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_cp, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_crlc, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_cparhdr, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_minalloc, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_maxalloc, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_ss, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_sp, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_csum, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_ip, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_cs, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_lfarlc, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_ovno, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_oemid, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_oeminfo, 2 
    printField [dosHeader], IMAGE_DOS_HEADER, .e_lfanew, 4 


; --------- Print NT HEADER (contains File Header and Optional Header)
    mov rbx, [dosHeader]
    add rbx, IMAGE_DOS_HEADER.e_lfanew
    xor rax, rax
    mov eax, [rbx]
    mov rbx, [fileDat]
    add rax, rbx
    mov [ntHeader], rax

    lea rcx, [IMAGE_NT_HEADER_MSG]
    call strPrint
    printField [ntHeader], IMAGE_NT_HEADER, .Signature, 4


; --------- Print COFF FILE HEADER
    mov rax, [ntHeader] 
    add rax, IMAGE_NT_HEADER.FileHeader
    mov [fileHeader], rax

    lea rcx, [IMAGE_FILE_HEADER_MSG]
    call strPrint
    printField [fileHeader], IMAGE_FILE_HEADER, .Machine, 2
    printField [fileHeader], IMAGE_FILE_HEADER, .NumberOfSections, 2
    printField [fileHeader], IMAGE_FILE_HEADER, .TimeDateStamp, 4
    printField [fileHeader], IMAGE_FILE_HEADER, .PointerToSymbolTable, 4
    printField [fileHeader], IMAGE_FILE_HEADER, .NumberOfSymbols, 4
    printField [fileHeader], IMAGE_FILE_HEADER, .SizeOfOptionalHeader, 2
    printField [fileHeader], IMAGE_FILE_HEADER, .Characteristics, 2

    mov rbx, [fileHeader]
    add rbx, IMAGE_FILE_HEADER.NumberOfSections
    xor rax, rax
    mov ax, [rbx]
    mov [nSections], rax


; --------- Print OPTIONAL HEADER
    lea rcx, [IMAGE_OPTIONAL_HEADER_MSG]
    call strPrint
    
    mov rax, [ntHeader] 
    add rax, IMAGE_NT_HEADER.OptionalHeader
    mov [optionalHeader], rax

    cmp word [rax], 0x020B
    je OH64
    cmp word [rax], 0x010B
    je OH32

    jmp fileError

OH32:
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .Magic, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MajorLinkerVersion, 1
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MinorLinkerVersion, 1
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfCode, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfInitializedData, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfUninitializedData, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .AddressOfEntryPoint, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .BaseOfCode, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .BaseOfData, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .ImageBase, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SectionAlignment, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .FileAlignment, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MajorOperatingSystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MinorOperatingSystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MajorImageVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MinorImageVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MajorSubsystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .MinorSubsystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .Win32VersionValue, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfImage, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfHeaders, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .CheckSum, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .Subsystem, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DllCharacteristics, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfStackReserve, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfStackCommit, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfHeapReserve, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .SizeOfHeapCommit, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .LoaderFlags, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .NumberOfRvaAndSizes, 4

    lea rcx, dataDirectoryMsg
    call strPrint

    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER, .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.Size, 4
    
	mov rbx, [optionalHeader]
    add rbx, IMAGE_OPTIONAL_HEADER.DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress
    mov ebx, [rbx]
    mov [importRVA], ebx

    mov rbx, [optionalHeader]
    add rbx, IMAGE_OPTIONAL_HEADER.DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress
    mov ebx, [rbx]
    mov [exportRVA], ebx

    mov rax, [optionalHeader]
    add rax, 224 ; size of optional header
    mov [sectionHeader], rax
    mov [tmp], rax

    jmp printSectionHeader
OH64: 
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .Magic, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MajorLinkerVersion, 1
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MinorLinkerVersion, 1
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfCode, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfInitializedData, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfUninitializedData, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .AddressOfEntryPoint, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .BaseOfCode, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .ImageBase, 8
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SectionAlignment, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .FileAlignment, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MajorOperatingSystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MinorOperatingSystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MajorImageVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MinorImageVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MajorSubsystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .MinorSubsystemVersion, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .Win32VersionValue, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfImage, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfHeaders, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .CheckSum, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .Subsystem, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DllCharacteristics, 2
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfStackReserve, 8
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfStackCommit, 8
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfHeapReserve, 8
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .SizeOfHeapCommit, 8
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .LoaderFlags, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .NumberOfRvaAndSizes, 4

    lea rcx, dataDirectoryMsg
    call strPrint

    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_RESOURCE.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_EXCEPTION.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_SECURITY.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BASERELOC.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DEBUG.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_ARCHITECTURE.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_GLOBALPTR.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_TLS.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_IAT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT.Size, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.VirtualAddress, 4
    printField [optionalHeader], IMAGE_OPTIONAL_HEADER64, .DataDirectory.IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR.Size, 4
    
    mov rbx, [optionalHeader]
    add rbx, IMAGE_OPTIONAL_HEADER64.DataDirectory.IMAGE_DIRECTORY_ENTRY_IMPORT.VirtualAddress
    mov ebx, [rbx]
    mov [importRVA], ebx

    mov rbx, [optionalHeader]
    add rbx, IMAGE_OPTIONAL_HEADER64.DataDirectory.IMAGE_DIRECTORY_ENTRY_EXPORT.VirtualAddress
    mov ebx, [rbx]
    mov [exportRVA], ebx

    mov rax, [optionalHeader]
    add rax, 240 ; size of optional header 64
    mov [sectionHeader], rax
    mov [tmp], rax

; --------- Print SECTION HEADER
printSectionHeader:

    lea rcx, [IMAGE_SECTION_HEADER_MSG]
    call strPrint

printSectionHeaderLoop:
    cmp qword [nSections], 0
    je printImportDirectory
    ; je tetse
    mov rcx, [sectionHeader] 
    call strPrint
    lea rcx, [clrf]
    call strPrint

    printField [sectionHeader], IMAGE_SECTION_HEADER, .VirtualSize, 4
    printField [sectionHeader], IMAGE_SECTION_HEADER, .VirtualAddress, 4
    printField [sectionHeader], IMAGE_SECTION_HEADER, .SizeOfRawData, 4
    printField [sectionHeader], IMAGE_SECTION_HEADER, .PointerToRawData, 4
    printField [sectionHeader], IMAGE_SECTION_HEADER, .PointerToRelocations, 4
    printField [sectionHeader], IMAGE_SECTION_HEADER, .PointerToLinenumbers, 4
    printField [sectionHeader], IMAGE_SECTION_HEADER, .NumberOfRelocations, 2
    printField [sectionHeader], IMAGE_SECTION_HEADER, .NumberOfLinenumbers, 2
    printField [sectionHeader], IMAGE_SECTION_HEADER, .Characteristics, 4

    ; check if import/export table is in this section
    mov rax, [sectionHeader]
    add rax, IMAGE_SECTION_HEADER.VirtualAddress
    mov eax, [rax]
    cmp [importRVA], eax
    jl findExportSection
    mov rax, [sectionHeader]
    add rax, IMAGE_SECTION_HEADER.VirtualAddress
    mov eax, [rax]
    mov rbx, [sectionHeader]
    add eax, [rbx+IMAGE_SECTION_HEADER.VirtualSize]
    cmp [importRVA], eax
    jge findExportSection
    mov rax, [sectionHeader]
    mov [importSection], rax

findExportSection:
    mov rax, [sectionHeader]
    add rax, IMAGE_SECTION_HEADER.VirtualAddress
    mov eax, [rax]
    cmp [exportRVA], eax
    jl printSHStep ; condition false, move to next ID
    mov rax, [sectionHeader]
    add rax, IMAGE_SECTION_HEADER.VirtualAddress
    mov eax, [rax]
    mov rbx, [sectionHeader]
    add eax, [rbx+IMAGE_SECTION_HEADER.VirtualSize]
    cmp [exportRVA], eax
    jge printSHStep
    mov rax, [sectionHeader]
    mov [exportSection], rax


printSHStep:
    add qword [sectionHeader], 40 ; sizeof section header
    dec qword [nSections] ; decrease counter
    jmp printSectionHeaderLoop

    

; --------- Print IMPORT DIRECTORY
printImportDirectory:

    cmp dword [importRVA], 0
    je printExportDirectory
    lea rcx, [IMAGE_IMPORT_DIRECTORY_MSG]
    call strPrint

    ; import directory address = fileAddressInMemory + importSection->PointerToRawData + importRVA - importSection.VA
    xor rax, rax
    mov eax, [importRVA]
    mov [importDirectory], rax
    mov rax, [fileDat]
	
    add [importDirectory], rax
    mov rax, [importSection]
    xor rbx, rbx
    mov ebx, [rax+IMAGE_SECTION_HEADER.VirtualAddress]
	
    sub [importDirectory], rbx
    mov ebx, [rax+IMAGE_SECTION_HEADER.PointerToRawData]
    add [importDirectory], rbx
    mov rax, [importDirectory]
    mov [importDescriptor], rax

printImportDirectoryLoop: 
    
    mov rax, [importDescriptor]
    add rax, IMAGE_IMPORT_DESCRIPTOR.Name
    mov eax, [rax]
    xor rcx, rcx
    mov ecx, -1
    and rax, rcx

    mov r12, rax
    cmp rax, 0
    je printExportDirectory

    lea rcx, [tab]
    call strPrint
    ; calculate offset of name from nameRVA
    ; mov rbx, [importDirectory]
    ; xor rax, rax
    ; mov eax, [importRVA]
    ; sub rbx, rax
    ; add rbx, r12
    ; mov rcx, rbx
    ; call strPrint
    mov rcx, r12
    call rvaToOffset
    add rax, [fileDat]
    mov rcx, rax
    call strPrint


    lea rcx, [clrf]
    call strPrint
    add qword [importDescriptor], 20 ; size of descriptor
    jmp printImportDirectoryLoop


; --------- Print EXPORT DIRECTORY
printExportDirectory:
    cmp dword [exportRVA], 0
    je exit
    lea rcx, [IMAGE_EXPORT_DIRECTORY_MSG]
    call strPrint

    ; calculate offset of export descriptor by rva, then print functions' names
    xor rcx, rcx
    mov ecx, [exportRVA]
    call rvaToOffset
    add rax, [fileDat]

    mov ebx, [rax+IMAGE_EXPORT_DIRECTORY.NumberOfNames]
    mov [nExportNames], ebx
    xor rcx, rcx
    mov ecx, [rax+IMAGE_EXPORT_DIRECTORY.AddressOfNames]
    call rvaToOffset
    add rax, [fileDat]
    mov [names], rax

printExportDirectoryLoop: 
    cmp dword [nExportNames], 0
    je exit
    lea rcx, [tab]
    call strPrint


    mov rbx, [names]
    xor rcx, rcx
    mov ecx, [rbx]
    call rvaToOffset
    add rax, [fileDat]
    mov rcx, rax
    call strPrint
    lea rcx, [clrf]
    call strPrint


    add qword [names], 4
    dec dword [nExportNames]
    jmp printExportDirectoryLoop
    


    


fileError:
    lea rcx, fileErrorMsg
    call strPrint
    
exit:

    xor rcx, rcx
    call ExitProcess



; ***********   HELPER FUNCTIONS
; print hex byte stored in cl
hexBytePrint:
    push rbp
    mov rbp, rsp
    and rcx, 0xff
    push rcx
    shr rcx, 4 ; take higher nibble to print first
    movzx rax, byte [hex+rcx]
    push 0 ; local variable for printing character
    mov byte [rsp], al
    lea rcx, [rsp]
    call strPrint
    pop rcx
    pop rcx
    and rcx, 0xf
    movzx rax, byte [hex+rcx]
    push 0 ; local variable for printing character
    mov byte [rsp], al
    lea rcx, [rsp]
    call strPrint
    
    leave
    ret

; print n-bytes stored in rcx as hex (read as little endian)
nHexPrint:
    push rbp
    mov rbp, rsp

    mov r8, rdx
    mov r9, rcx
hexPrintLoop:
    cmp r8, 0
    je nHexPrintEnd
    dec r8
    mov rdi, r9
    mov rcx, 8
    imul ecx, r8d
    shr rdi, cl
    mov rcx, rdi
    push r8
    push r9
    call hexBytePrint
    pop r9
    pop r8
    jmp hexPrintLoop


nHexPrintEnd:
    leave
    ret


rvaToOffset:
    push rbp
    mov rbp, rsp
    

    sub rsp, 16
    %define rva rbp-8 
    %define sectionHeaders rbp-16
    
    mov [rva], rcx
    mov rax, [tmp]
    mov [sectionHeaders], rax
    mov rbx, [fileHeader]
    add rbx, IMAGE_FILE_HEADER.NumberOfSections
    xor rax, rax
    mov ax, [rbx]
    mov [nSections], rax
findSectionLoop:
    cmp qword [nSections], 0
    je leavervaToOffset

    ; check if RVA is in this section
    mov rax, [sectionHeaders]
    add rax, IMAGE_SECTION_HEADER.VirtualAddress
    mov eax, [rax]
    xor rcx, rcx
    mov ecx, -1
    and rbx, rcx
    cmp [rva], rax
    jl printSectionStep
    mov rax, [sectionHeaders]
    add rax, IMAGE_SECTION_HEADER.VirtualAddress
    mov eax, [rax]
    mov rbx, [sectionHeaders]
    add eax, [rbx+IMAGE_SECTION_HEADER.VirtualSize]
    cmp [rva], rax
    jge printSectionStep
    
    ; if rva in range then calculate file offset
    mov rbx, [sectionHeaders]
    add rbx, IMAGE_SECTION_HEADER.PointerToRawData
    mov ebx, [rbx]
    xor rcx, rcx
    mov ecx, -1
    and rbx, rcx
    mov rax, [rva]
    add rax, rbx

    mov rbx, [sectionHeaders]
    add rbx, IMAGE_SECTION_HEADER.VirtualAddress
    mov ebx, [rbx]
    xor rcx, rcx
    xor rcx, rcx
    mov ecx, -1
    and rbx, rcx
    sub rax, rbx
    jmp leavervaToOffset



printSectionStep:
    add qword [sectionHeaders], 40 ; sizeof section header
    dec qword [nSections] ; decrease counter
    jmp findSectionLoop
    
leavervaToOffset:
    leave
    ret

extern VirtualAlloc
extern VirtualFree
 ; dword strToNum(lpvoid* buf)
strToNum:
    ; prolouge, set up stack, preserve callee saved registers
    push rbp
    mov rbp, rsp
    push rbx

    xor rax, rax
    mov rbx, rcx
    xor rcx, rcx

    ; rcx as counter variable
    ; rbx contains buffer's offset
    checkDoneSTN:
    cmp byte [rbx+rcx], 0 ; check if meet \0
    jz doneSTN ; jump if meet \0
    xor rdx, rdx
    mov r8, 10
    mul r8 ; mul rax by 10 then add digit later
    xor rdx, rdx ; set rdx to 0
    mov dl, [rbx+rcx] ; load character with address contain in rbx+rcx then
    cmp dl, '9'
    jg notValid
    cmp dl, '0'
    jl notValid
    sub dl, '0' ; convert to number
    add rax, rdx ; add to rax to return later
    inc rcx ; move to next character
    jmp checkDoneSTN ; loop 

    ; not a valid numeric string, return 0
    notValid: 
    xor rax, rax
    ; epilouge: restore stack then return to saved rip
    doneSTN:
    pop rbx
    leave ; rsp <- rbp and pop rbp from stack
    ret ; return to saved rip

 ; ; void numToStr(dword num, lpvoid* buf)
numToStr:
    ; epilogue
    push rbp
    mov rbp, rsp

    push rbx ; preserve rbx
    mov rax, rcx ; rax <- num param
    xor rcx, rcx
    mov r8, rdx ; r8 <- output buffer address param
    
    ; loop to divide rax by 10 until equal 0, remainder push to stack then pop to reverse string's digits
    divideLoop:
    inc rcx ; rcx as counter
    xor rdx, rdx
    mov rbx, 10
    div rbx ; div rdx:rax by 10, remainder stored in rdx
    add dl, '0' ; convert remainder to character
    movzx rdx, dl ; move zero extend
    push rdx ; push character onto stack
    cmp rax, 0 ; check if string terminated
    jnz divideLoop ; loop

    popChrLoop: ; loop RCX time to pop char from stack to buffer to reverse string 
    pop rax ; pop character into rax
    mov byte [r8], al ; r8 contains upper output buffer address
    inc r8

    loop popChrLoop

    ; epilogue
    pop rbx
    leave
    ret

strRead: ; read string from sdtin into buffer, return string's length (clrf stripped)

    push rbp
    mov rbp, rsp

    push rcx ; preserve output buffer
    sub rsp, 28h ; shadow space, alignment
    mov rdx, rcx ; move output buffer address to rdx
    mov rcx, -10 
    call GetStdHandle
    add rsp, 28h


    mov rcx, rax ; hConsoleInput 
    mov r8, 255 ; nNumberOfCharsToRead
    lea r9, [nCharRead] ; lpNumberOfCharsRead
    push 0
    sub rsp, 20h ; shadow space
    call ReadConsoleA
    add rsp, 28h
    xor rax, rax
    mov eax, dword [nCharRead]
    pop rdx
    mov byte [rdx+rax-2], 0 ; strip clrf
    sub rax, 2
    leave ; clean the stack then restore saved-rbp
    ret

uint64Read:
    push rbp
    mov rbp, rsp

    ; call VirtualAlloc function to allocate dynamic memory region to store temporary string
    xor rcx, rcx ; lpAddress - starting address of region to allocate, set to NULL to let the system decides
    mov rdx, 25 ; dwSize - size of the region in bytes
    mov r8, 0x00001000
    or r8, 0x00002000 ; flAllocationType - type of memory allocation MEM_COMMIT | MEM_RESERVE
    mov r9, 0x04 ; flProtect - PAGE_READWRITE flag
    sub rsp, 20h ; shadow space
    call VirtualAlloc
    add rsp, 20h
    
    push rax ; preserve base memory
    sub rsp, 28h ; shadow space + stack alignment
    mov rcx, rax
    call strRead
    add rsp, 28h

    pop rcx
    push rcx ; base address of buffer
    sub rsp, 28h
    call strToNum
    add rsp, 28h


    ; VirtualFree
    pop rcx ; lpAddress - base memory to be free 
    push rax ; preserve return number
    mov rdx, 0 ; dwSize - size of region to be freed, because dwFreeType parameter is MEM_RELEASE, this parameter must be 0, free the entire region that is reserved in the initial allocation call 
    mov r8, 0x00008000 ; dwFreeType -  MEM_RELEASE
    sub rsp, 28h
    call VirtualFree
    add rsp, 28h
    pop rax; return number

    leave
    ret

int64Read:
    push rbp
    mov rbp, rsp

    ; call VirtualAlloc function to allocate dynamic memory region to store temporary string
    xor rcx, rcx ; lpAddress - starting address of region to allocate, set to NULL to let the system decides
    mov rdx, 25 ; dwSize - size of the region in bytes
    mov r8, 0x00001000
    or r8, 0x00002000 ; flAllocationType - type of memory allocation MEM_COMMIT | MEM_RESERVE
    mov r9, 0x04 ; flProtect - PAGE_READWRITE flag
    sub rsp, 20h ; shadow space
    call VirtualAlloc
    add rsp, 20h
    
    push rax ; preserve base memory
    sub rsp, 28h ; shadow space + stack alignment
    mov rcx, rax
    call strRead
    add rsp, 28h

    pop rcx
    push rcx ; base address of buffer
    cmp byte [rcx], '-'
    jnz IRLabel1
    inc rcx

    sub rsp, 28h
    call strToNum
    add rsp, 28h
    neg rax
    jmp IRLabel2

IRLabel1:
    sub rsp, 28h
    call strToNum
    add rsp, 28h

IRLabel2:
    ; VirtualFree
    pop rcx ; lpAddress - base memory to be free 
    push rax ; preserve return number
    mov rdx, 0 ; dwSize - size of region to be freed, because dwFreeType parameter is MEM_RELEASE, this parameter must be 0, free the entire region that is reserved in the initial allocation call 
    mov r8, 0x00008000 ; dwFreeType -  MEM_RELEASE
    sub rsp, 28h
    call VirtualFree
    add rsp, 28h
    pop rax; return number

    leave
    ret

uint64Print:
    push rbp
    mov rbp, rsp

    push rcx

    ; call VirtualAlloc function to allocate dynamic memory region to store temporary string
    xor rcx, rcx ; lpAddress - starting address of region to allocate, set to NULL to let the system decides
    mov rdx, 25 ; dwSize - size of the region in bytes
    mov r8, 0x00001000
    or r8, 0x00002000 ; flAllocationType - type of memory allocation MEM_COMMIT | MEM_RESERVE
    mov r9, 0x04 ; flProtect - PAGE_READWRITE flag
    sub rsp, 28h ; shadow space
    call VirtualAlloc
    add rsp, 28h

    
    pop rcx ; qword to convert
    push rax ; preserve
    mov rdx, rax ; string buffer
    sub rsp, 28h
    call numToStr
    add rsp, 28h

    pop rcx ; base address
    push rcx ; restore again
    sub rsp, 28h
    call strPrint
    add rsp, 28h

    ; VirtualFree
    pop rcx ; lpAddress - base memory to be free 
    mov rdx, 0 ; dwSize - size of region to be freed, because dwFreeType parameter is MEM_RELEASE, this parameter must be 0, free the entire region that is reserved in the initial allocation call 
    mov r8, 0x00008000 ; dwFreeType -  MEM_RELEASE
    sub rsp, 20h
    call VirtualFree
    add rsp, 20h


    leave 
    ret

int64Print:
    push rbp
    mov rbp, rsp

    push rcx

    ; call VirtualAlloc function to allocate dynamic memory region to store temporary string
    xor rcx, rcx ; lpAddress - starting address of region to allocate, set to NULL to let the system decides
    mov rdx, 25 ; dwSize - size of the region in bytes
    mov r8, 0x00001000
    or r8, 0x00002000 ; flAllocationType - type of memory allocation MEM_COMMIT | MEM_RESERVE
    mov r9, 0x04 ; flProtect - PAGE_READWRITE flag
    sub rsp, 28h ; shadow space
    call VirtualAlloc
    add rsp, 28h

    
    mov rcx, [rsp] ; int64 number
    push rax
    test rcx, rcx
    jns positive
    ; if rcx contains negative value
    lea rcx, [minus]
    sub rsp, 20h
    call strPrint
    add rsp, 20h
    neg qword [rsp+8]

positive:
    mov rdx, [rsp] ;buffer
    mov rcx, [rsp+8]; number to convert
    sub rsp, 28h
    call numToStr
    add rsp, 28h

    mov rcx, [rsp]
    sub rsp, 28h
    call strPrint
    add rsp, 28h

    ; VirtualFree
    mov rcx, [rsp] ; lpAddress - base memory to be free 
    add rsp, 16
    mov rdx, 0 ; dwSize - size of region to be freed, because dwFreeType parameter is MEM_RELEASE, this parameter must be 0, free the entire region that is reserved in the initial allocation call 
    mov r8, 0x00008000 ; dwFreeType -  MEM_RELEASE
    sub rsp, 20h
    call VirtualFree
    add rsp, 20h


    leave 
    ret



strPrint:
    push rbp
    mov rbp, rsp 
    push rbx ; callee saved register
    mov rbx, rcx ; store value of rcx into rbx

    sub rsp, 28h ; shadow space, stack alignment
    ; get string's len
    mov rcx, rbx
    call strlen
    add rsp, 28h
    mov rdx, rax ; store string's length in rdx

    mov rcx, -11
    sub rsp, 28h
    call GetStdHandle
    add rsp, 28h


    mov rcx, rax ; stdout handle
    mov r8, rdx ; string's length
    mov rdx, rbx ; buffer's pointer
    lea r9, [nCharWritten] ; pointer to return number of chars written
    push 0
    sub rsp, 20h
    call WriteConsoleA
    add rsp, 28h ; deallocate shadow space and function's parameter

    pop rbx ; restore rbx (calle saved register)
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
