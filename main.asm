%include "io/io.inc"
%include "vertices/data.asm"
%include "vertices/construction.asm"
%include "vertices/helpers.asm"
    
extern malloc
extern exit

section .text
global CMAIN

CMAIN:
    mov         ebp, esp ; for correct debugging
    
    call        _construct_nodes
    
    push        dword [a]
    call        _travel
    add         esp, 8

    jmp         _ok_exit
    
_travel:
    push        ebp
    mov         ebp, esp
    
    push        dword [ebp + 8]
    
    call        _find_min_index
    pop         ebx
    imul        eax, 8
    add         eax, ebx
    add         eax, 4
    mov         eax, [eax]
    
    NEWLINE
    PRINT_STRING "MOVING FROM "
    PRINT_DEC   4, ebx
    PRINT_STRING " TO "
    PRINT_DEC   4, eax
    NEWLINE
    
    push        eax
    call        _travel
    
    mov         esp, ebp
    pop         ebp
    ret

_ok_exit:
    NEWLINE
    PRINT_STRING "OK EXIT"
    xor         eax, eax
    jmp         _exit
    
_exit:
    call exit
