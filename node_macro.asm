%ifndef NODE_MACRO
%define NODE_MACRO

%include "node_data.asm"

extern exit
section .text 
_bad_alloc_exit:
    mov         eax, 1
    call        exit
    
; Первый аргумент - кол-во элементов
; Второй аргумент - имя
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
    mov         dword [eax], %1
%endmacro

; Первый - Узел, к которому добавляем
; Второй - Узел, который добавляем
; Третий - Цена перехода
%macro ADD_NODE 3
    mov         eax, [%1]
    mov edx, [%2]
    mov         dword [eax+ebx], edx
    add         ebx, 4
    mov         dword [eax+ebx], %3
    add         ebx, 4
%endmacro   

%endif

