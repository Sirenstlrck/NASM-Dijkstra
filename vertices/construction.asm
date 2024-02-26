%ifndef NODE_CONSTRUCTION
%define NODE_CONSTRUCTION

%include "vertices/data.asm"

extern exit

section .text
    
; 1 - elements count
; 2 - vertex name
%macro ALLOC_NODE 2
    mov         ecx, %1
    imul        ecx, 8
    add         ecx, 4
    push        ecx
    call        malloc
    test        eax, eax
    jz          _bad_alloc_exit
    add         esp, 4
    mov         [%2], eax
    mov         dword [eax], %1
%endmacro

;  1 - vertex to which we are adding
;  2 - vertex being added
;  3 - ransition cost
%macro ADD_NODE 3
    mov         eax, [%1]
    mov         edx, [%2]
    mov         dword [eax+ecx], edx
    add         ecx, 4
    mov         dword [eax+ecx], %3
    add         ecx, 4
%endmacro 

_construct_nodes:
    ALLOC_NODE  1, a ; e
    
    ALLOC_NODE  3, e ; c b x
    
    ALLOC_NODE  1, b ; c
    
    ALLOC_NODE  2, c ; x n
    
    ALLOC_NODE  2, x ; n o    
    
    ALLOC_NODE  2, n ; a o
    
    ALLOC_NODE  2, o ; e m
   
    ALLOC_NODE  2, m ; d f
    
    ALLOC_NODE  2, d ; e a
    
    ALLOC_NODE  3, g ; n b f
    
    ALLOC_NODE  1, f ; l   
    
    ALLOC_NODE  2, l ; b a 
    
    call _init_nodes
    ret
    
_init_nodes:
    ; ecx - offset counter
    mov         ecx, 4 
     
    ADD_NODE    a, e, 3
    mov         ecx, 4
    
    ADD_NODE    e, c, 3
    ADD_NODE    e, b, 4
    ADD_NODE    e, x, 5
    mov         ecx, 4
    
    ADD_NODE    b, c, 2
    mov         ecx, 4
    
    ADD_NODE    c, x, 3  
    ADD_NODE    c, n, 5
    mov         ecx, 4
    
    ADD_NODE    x, n, 2
    ADD_NODE    x, o, 4
    mov         ecx, 4
    
    ADD_NODE    n, a, 6 
    ADD_NODE    n, o, 4
    mov         ecx, 4
    
    ADD_NODE    o, e, 6
    ADD_NODE    o, m, 1
    mov         ecx, 4
    
    ADD_NODE    m, d, 1 
    ADD_NODE    m, f, 2
    mov         ecx, 4
    
    ADD_NODE    d, e, 7
    ADD_NODE    d, g, 3  
    ADD_NODE    d, a, 9
    mov         ecx, 4
    
    ADD_NODE    g, n, 6 
    ADD_NODE    g, b, 5
    ADD_NODE    g, f, 2
    mov         ecx, 4
    
    ADD_NODE    f, l, 2
    mov         ecx, 4
    
    ADD_NODE    l, b, 7 
    ADD_NODE    l, a, 10
    mov         ecx, 4  
    ret
    
%endif

_bad_alloc_exit:
    NEWLINE
    PRINT_STRING "BAD ALLOC EXIT"
    mov         eax, 1
    call        exit