%ifndef VERTICES_CONSTRUCTION
%define VERTICES_CONSTRUCTION

%include "io/io.inc"

%include "vertices/data.asm"
%include "vertices/visited_vertices_list.asm"

extern exit
extern calloc

section .text
    
; 1 - elements count
; 2 - vertex name
%macro ALLOC_NODE 2
    mov         ebx, %1
    imul        ebx, 8
    add         ebx, 4
    push        ebx
    call        malloc
    test        eax, eax
    jz          _bad_alloc_exit
    add         esp, 4
    mov         [%2], eax
    mov         DWORD [eax], %1
    
    inc         DWORD [esp]
%endmacro

_construct_nodes:
    
    push        DWORD 0  ; vertices count
    ALLOC_NODE  1, a_ptr ; e
    
    ALLOC_NODE  3, e_ptr ; c b x
    
    ALLOC_NODE  1, b_ptr ; c
    
    ALLOC_NODE  2, c_ptr ; x n
    
    ALLOC_NODE  2, x_ptr ; n o    
    
    ALLOC_NODE  2, n_ptr ; a o
    
    ALLOC_NODE  2, o_ptr ; e m
   
    ALLOC_NODE  2, m_ptr ; d f

    ALLOC_NODE  3, d_ptr ; e a

    ALLOC_NODE  3, g_ptr ; n b f

    ALLOC_NODE  1, f_ptr ; l   

    ALLOC_NODE  2, l_ptr ; b a 
    
; alloc visited vertices list
    pop         ecx
    push        4
    push        ecx
    call        calloc
    test        eax, eax 
    jz          _bad_alloc_exit
    
    mov         [visited_vertices_ptr], eax
    mov         ecx, [esp]
    mov         [visited_vertices_count], ecx
    add         esp, 8  
      
    call        _init_nodes
    ret
    
; 1 - vertex to which we are adding
; 2 - vertex being added
; 3 - transition cost
%macro ADD_NODE 3
    mov         eax, [%1]
    mov         edx, [%2]
    mov         DWORD [eax + ecx], edx
    add         ecx, 4
    mov         DWORD [eax + ecx], %3
    add         ecx, 4
%endmacro 

_init_nodes:
    ; ecx - offset counter
    mov         ecx, 4 
     
    ADD_NODE    a_ptr, e_ptr, 3
    mov         ecx, 4
    
    ADD_NODE    e_ptr, c_ptr, 3
    ADD_NODE    e_ptr, b_ptr, 4
    ADD_NODE    e_ptr, x_ptr, 5
    mov         ecx, 4
    
    ADD_NODE    b_ptr, c_ptr, 2
    mov         ecx, 4
    
    ADD_NODE    c_ptr, x_ptr, 3  
    ADD_NODE    c_ptr, n_ptr, 5
    mov         ecx, 4
    
    ADD_NODE    x_ptr, n_ptr, 2
    ADD_NODE    x_ptr, o_ptr, 4
    mov         ecx, 4
    
    ADD_NODE    n_ptr, a_ptr, 6 
    ADD_NODE    n_ptr, o_ptr, 4
    mov         ecx, 4
    
    ADD_NODE    o_ptr, e_ptr, 6
    ADD_NODE    o_ptr, m_ptr, 1
    mov         ecx, 4
    
    ADD_NODE    m_ptr, d_ptr, 1 
    ADD_NODE    m_ptr, f_ptr, 2
    mov         ecx, 4
    
    ADD_NODE    d_ptr, e_ptr, 7
    ADD_NODE    d_ptr, g_ptr, 3  
    ADD_NODE    d_ptr, a_ptr, 9
    mov         ecx, 4
    
    ADD_NODE    g_ptr, n_ptr, 6 
    ADD_NODE    g_ptr, b_ptr, 5
    ADD_NODE    g_ptr, f_ptr, 2
    mov         ecx, 4
    
    ADD_NODE    f_ptr, l_ptr, 2
    mov         ecx, 4
    
    ADD_NODE    l_ptr, b_ptr, 7 
    ADD_NODE    l_ptr, a_ptr, 10
    mov         ecx, 4  
    ret
    
%endif

_bad_alloc_exit:
    NEWLINE
    PRINT_STRING "BAD ALLOC EXIT"
    mov         eax, 1
    call        exit