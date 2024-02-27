%ifndef VISITED_VERTICES_LIST
%define VISITED_VERTICES_LIST

%include "io/io.inc"

section .data 

    visited_vertices_ptr dd 0
    visited_vertices_count dd 0
    
section .text


_show_visited_vertices:
    xor         ecx, ecx
    
    .loop_start:
        mov         ebx, ecx
        imul        ebx, 4
        add         ebx, [visited_vertices_ptr]
        
        NEWLINE
        PRINT_DEC 4, [ebx]
        
        inc         ecx
        cmp         ecx, [visited_vertices_count]
        jl          .loop_start
        
    ret

; args: address of vertex
_add_visited_vertex:
    push        ebp
    mov         ebp, esp
    
    mov         eax, [ebp + 8] ; vertex address
    
    xor         ecx, ecx
    .loop_start:
        mov         ebx, ecx
        imul        ebx, 4
        add         ebx, [visited_vertices_ptr]
        
        cmp         DWORD [ebx], 0
        je          .add_vertex
        
        cmp         DWORD [ebx], eax
        je          .vertex_already_added
        
        inc         ecx
        cmp         ecx, [visited_vertices_count]
        jl          .loop_start
        jmp         .out_of_range
        
        .add_vertex:
        mov         DWORD [ebx], eax
        jmp         .loop_end
        
        .out_of_range:
        NEWLINE
        PRINT_STRING "Visited vertices out of range"
        mov         eax, 1
        call        exit
        
        .vertex_already_added:
        NEWLINE
        PRINT_STRING "Vertex already added"
        mov         eax, 1
        call        exit
        
    .loop_end:
    
    mov         esp, ebp
    pop         ebp
    ret

; args: address of vertex
; eax - result
_is_vertex_visited:
    push        ebp
    mov         ebp, esp
    
    mov         eax, [ebp + 8] ; vertex address
    
    xor         ecx, ecx
    .loop_start:
        mov         ebx, ecx
        imul        ebx, 4
        add         ebx, [visited_vertices_ptr]
        
        cmp         DWORD [ebx], eax
        je          .found
        
        inc         ecx
        cmp         ecx, [visited_vertices_count]
        jl          .loop_start
        jmp         .not_found
    
        .not_found:
        xor         eax, eax
        jmp         .loop_end
        
        .found:
        mov         eax, 1
        jmp         .loop_end
        
    .loop_end:
    
    mov         esp, ebp
    pop         ebp
    ret

; args: address of vertex
; result: eax - value; ebx - pointer; ecx - index
; index = -1 if not found
_find_min_not_visited_vertex_index:
    push        ebp
    mov         ebp, esp
    
    mov         eax, [ebp + 8]
    
    push        eax                 ; [ebp - 4] - address
    push        DWORD [eax]         ; [ebp - 8] - elements count
    push        DWORD 2147483647    ; [ebp - 12] - min value
    push        DWORD -1            ; [ebp - 16] - min index
    push        DWORD 0             ; [ebp - 20] - min address

    xor         ecx, ecx
    .loop_start:
        mov         ebx, ecx
        imul        ebx, 8
        add         ebx, [ebp - 4]
        add         ebx, 4
        
        push        ebx
        push        ecx
        push        DWORD [ebx]
        call        _is_vertex_visited
        add         esp, 4
        pop         ecx
        pop         ebx
        test        eax, eax
        jnz         .continue
        
        mov         eax, [ebx + 4]
        cmp         eax, [ebp - 12]
        jl          .new_min
          
       
        .continue:
        inc         ecx
        cmp         ecx, [ebp - 8]
        jl          .loop_start  
        jmp         .loop_end
        
        .new_min:
        mov         eax, [ebx]
        mov         [ebp - 20], eax
        mov         [ebp - 16], ecx
        mov         eax, [ebx + 4]
        mov         [ebp - 12], eax
        jmp         .continue
        
    .loop_end:
    
    pop         ebx
    pop         ecx
    pop         eax
    
    mov         esp, ebp
    pop         ebp
    ret
        
%endif