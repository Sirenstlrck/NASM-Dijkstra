%ifndef VERTICES_DATA
%define VERTICES_DATA

section .data    
    ; list of pointers to vertices, where the first  4 bytes are reserved for  
    ; the number of vertices to which one can transition from this vertex
    
    ; following this are records of 8 bytes each. The first  4 bytes of the record -  
    ; a pointer to another vertex, and the last - the "cost" of passing to it
    
    a_ptr DD 0
    e_ptr DD 0
    b_ptr DD 0
    c_ptr DD 0
    x_ptr DD 0
    n_ptr DD 0
    o_ptr DD 0
    m_ptr DD 0
    d_ptr DD 0
    g_ptr DD 0
    f_ptr DD 0
    l_ptr DD 0    
%endif
