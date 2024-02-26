%include "io.inc"
%include "node_data.asm"
%include "node_construction.asm"
    
extern malloc
extern exit

section .text
global CMAIN

CMAIN:
    mov         ebp, esp ; for correct debugging
    ;write your code here
    
    call        _construct_nodes
    
    push        dword [a]
    call        _travel
    add         esp, 8

    jmp         _ok_exit

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
    .print_node_info_loop:
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
        jl          .print_node_info_loop
        
        mov         esp, ebp
        pop         ebp
        ret

_find_min_index:

    push        ebp
    mov         ebp, esp
    
    mov         eax, [ebp + 8]
    push        eax                 ; [esp+8] - address
    push        dword [eax]         ; [esp+4] - elements count
    push        dword 2147483647    ; [esp] - minIndex
    xor         ecx, ecx            ; counter
    
    .find_min_index_loop_start:
        mov         eax, ecx
        imul        eax, 8
        add         eax, [esp+8]
        add         eax, 8
        mov         eax, [eax]
        
        cmp         eax, dword [esp]
        jl          .find_min_index_loop_new_index
           
     .find_min_index_loop_continue:
        inc         ecx
        cmp         ecx, [esp+4]
        jl          .find_min_index_loop_start
        jmp         .find_min_index_loop_end
        
     .find_min_index_loop_new_index:
        mov         dword [esp], eax
        mov         ebx, ecx
        jmp         .find_min_index_loop_continue
        
    .find_min_index_loop_end:
        
    mov         eax, ebx
    
    mov         esp, ebp
    pop         ebp
    ret
    
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
