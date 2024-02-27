%include "io/io.inc"
%include "vertices/data.asm"
%include "vertices/construction.asm"
%include "vertices/visited_vertices_list.asm"
    
extern malloc
extern exit

section .text
global CMAIN

CMAIN:
    mov         ebp, esp ; for correct debugging
    
    call        _construct_nodes
    
    push        DWORD [a_ptr]
    push        DWORD [b_ptr]
    call        _dijkstra
    add         esp, 8

    jmp         _ok_exit
    
_dijkstra:
    push        ebp
    mov         ebp, esp
    
    push        DWORD [ebp + 12] ; [ebp - 4] - from
    push        DWORD [ebp + 8]  ; [ebp - 8] - to
    push        DWORD 0          ; [ebp - 12] - accumulator

    mov         ebx, [ebp - 4]
    
    .loop_start:
        cmp         ebx, [ebp - 8]
        je          .destination_reached
        
        NEWLINE
        PRINT_STRING "Moving from "
        PRINT_DEC   4, ebx
        push        ebx
        call        _add_visited_vertex
        call        _find_min_not_visited_vertex_index 
        add         esp, 4
        PRINT_STRING " to "
        PRINT_DEC   4, ebx
        PRINT_STRING " at cost of "
        PRINT_DEC   4, eax
        NEWLINE
       
        pop         edx
        add         edx, eax
        push        edx  

        cmp         ecx, -1
        jne         .loop_start
        jmp         .destination_not_reached
        
        .destination_reached:
        NEWLINE
        PRINT_STRING "Destination reached at a cost of "
        PRINT_DEC   4, [ebp - 12]
        NEWLINE
        jmp         .loop_end
        
        .destination_not_reached:
        NEWLINE
        PRINT_STRING "Destination not reached"
        NEWLINE
        jmp         .loop_end
        
    .loop_end:

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
