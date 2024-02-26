%ifndef NODE_HELPERS
%define NODE_HELPERS

%include "io/io.inc"

_print_node_info:
    push        ebp
    mov         ebp, esp
    
    mov         eax, [ebp + 8]
    mov         edx, [eax]
    
    PRINT_STRING "Addr: "
    PRINT_HEX   4, eax
    NEWLINE
    PRINT_STRING "Size: "
    PRINT_DEC   4, edx
    NEWLINE

    xor         ecx, ecx
    .loop_start:
        mov         ebx, ecx
        imul        ebx, 8
        add         ebx, eax
        add         ebx, 4
        
        PRINT_HEX   4, [ebx]
        PRINT_STRING " - "
        add         ebx, 4
        PRINT_DEC   4, [ebx]
        NEWLINE        
        
        inc         ecx
        cmp         ecx, edx
        jl          .loop_start
        
        mov         esp, ebp
        pop         ebp
        ret
        
        
_find_min_index:
    push        ebp
    mov         ebp, esp
    
    mov         eax, [ebp + 8]
    push        eax                 ; [ebp - 4] - address
    push        dword [eax]         ; [ebp - 8] - elements count
    push        dword 2147483647    ; [ebp - 12] - min index
    xor         ecx, ecx            ; counter
    
    .loop_start:
        mov         eax, ecx
        imul        eax, 8
        add         eax, [ebp - 4]
        add         eax, 8
        mov         eax, [eax]
        
        cmp         eax, dword [ebp - 12]
        jl          .set_new_index
           
     .continue:
        inc         ecx
        cmp         ecx, [ebp - 8]
        jl          .loop_start
        jmp         .loop_end
        
     .set_new_index:
        mov         dword [ebp - 12], eax
        mov         ebx, ecx
        jmp         .continue
        
    .loop_end:
    
    mov         eax, ebx
    
    mov         esp, ebp
    pop         ebp
    ret
        
%endif