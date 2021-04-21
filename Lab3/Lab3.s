    .arch armv8-a
    
    .data
msg1:
    .ascii  "Source string: "
    .equ    msg1_size, . - msg1
str:
    .skip   1024
msg2:
    .ascii  "Result string: '"
res:
    .skip   1024
word_size:
    .skip   4
    
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
    mov     x0, #1
    adr     x1, msg1
    mov     x2, msg1_size
    mov     x8, #64
    svc     #0
    mov     x0, #0
    adr     x1, str
    mov     x2, #1023
    mov     x8, #63
    svc     #0
    cmp     x0, #0
    ble     _exit
    adr     x1, str
    sub     x0, x0, #1
    strb    wzr, [x1, x0]
    adr     x3, res
    mov     x4, x3
    adr     x5, word_size
    mov     x6, x5
    mov     w7, #10
_initial_element_handler:
    ldrb    w0, [x1], #1
    cbz     w0, _result_string_output
    cmp     w0, ' '
    beq     _initial_element_handler
    mov     w9, #0
    cmp     x3, x4
    beq     _word_sorting
_word_sorting_entry:
    mov     w10, ' '
    strb    w10, [x3], #1
    mov     x5, x6
    cbnz    w9, _word_sorting_finish
_word_sorting:
    strb    w0, [x3], #1
    add     w9, w9, #1
    ldrb    w0, [x1], #1
    cbz     w0, _word_sorting_entry
    cmp     w0, ' '
    bne     _word_sorting
    b       _word_sorting_entry
_word_sorting_finish:
    udiv    w11, w9, w7
    msub    w10, w7, w11, w9
    add     w10, w10, '0'
    strb    w10, [x5], #1
    mov     w9, w11
    cbnz    w9, _word_sorting_finish
_final_element_handler:
    ldrb    w10, [x5, #-1]!
    strb    w10, [x3], #1
    cmp     x5, x6
    bne     _final_element_handler
    cbnz    w0, _initial_element_handler
_result_string_output:
    mov     w0, '\''
    strb    w0, [x3], #1
    mov     w0, '\n'
    strb    w0, [x3], #1
    mov     x0, #1
    adr     x1, msg2
    sub     x2, x3, x1
    mov     x8, #64
    svc     #0
_exit:
    mov     x0, #0
    mov     x8, #93
    svc     #0
    .size   _start, . - _start
