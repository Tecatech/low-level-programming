    .arch armv8-a
    
    .data
    .align  3
n:
    .byte   4
matrix:
    .quad   1, 9, 7, 5
    .quad   6, 8, 5, 3
    .quad   9, 5, 4, 6
    .quad   4, 3, 1, 2
    
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
    adr     x0, n
    ldrb    w0, [x0]
    sub     w1, w0, #1
    add     w2, w0, #1
    mul     w3, w0, w1
    mul     w4, w1, w2
    adr     x5, matrix
    mov     w6, w1
_rows_diag_sort:
    subs    w6, w6, #1
    beq     _columns_diag_sort
    b       _balance_shift
_columns_diag_sort:
    add     w6, w0, w6
    cmp     w3, w6
    beq     exit
    sub     w1, w1, #1
_balance_shift:
    mov     w7, w1
    b       _initial_element_handler
_selection_sort_finish:
    ldr     x15, [x5, x11, lsl #3]
    cmp     x10, x15
    bge     _elements_reversal
    b       _diag_sort_type_definition
_elements_reversal:
    str     x10, [x5, x11, lsl #3]
    str     x15, [x5, x9, lsl #3]
_diag_sort_type_definition:
    sub     w7, w7, #1
    sdiv    w16, w11, w2
    msub    w17, w2, w16, w11
    madd    w18, w0, w17, w11
    cmp     w4, w18
    blt     _columns_diag_sort_entry
_rows_diag_sort_entry:
    cmp     w6, w7
    beq     _rows_diag_sort
    b       _initial_element_handler
_columns_diag_sort_entry:
    cmp     w7, #0
    beq     _columns_diag_sort
_initial_element_handler:
    mov     w8, w6
    mov     w9, w6
    ldr     x10, [x5, x9, lsl #3]
_final_element_handler:
    add     w11, w2, w8
    sdiv    w12, w11, w0
    msub    w13, w0, w12, w11
    cmp     w7, w13
    beq     _selection_sort_finish
    mov     w8, w11
    ldr     x14, [x5, x8, lsl #3]
    cmp     x10, x14
    bge     _final_element_handler
    mov     w9, w8
    mov     x10, x14
    b       _final_element_handler
exit:
    mov     x0, #0
    mov     x8, #93
    svc     #0
    .size   _start, .-_start