    .arch armv8-a
    
    .data
msg1:
    .string "Argument: "
msg2:
    .string "%lf"
msg3:
    .string "arcsin(%.10g) = %.10g\n"
msg4:
    .string "custom_arcsin(%.10g) = %.10g\n"
msg5:
    .string "Invalid argument!\n"
msg6:
    .string "w"
msg7:
    .string "Precision: "
msg8:
    .string "%.0lf %.10lf\n"
errmsg1:
    .string "Usage: %s filename\n"
errmsg2:
    .string "Error occurred when opening output file!\n"
    
    .text
    .align  2
    .global custom_arcsin
    .type   custom_arcsin, %function
    .equ    output, 16
custom_arcsin:
    stp     x29, x30, [sp, #-24]!
    mov     x29, sp
    str     x0, [x29, output]
    fmov    d17, d0
    fmov    d18, d1
    fmov    d0, #1.0
    fmov    d1, #1.0
    fsub    d0, d0, d1
    fmov    d1, d17
    ldr     x0, [x29, output]
    adr     x1, msg8
    bl      fprintf
    ldr     x0, [x29, output]
    fmov    d0, d17
    fmov    d1, d18
    fmov    d2, d0
    fmov    d3, d0
    fmul    d4, d0, d0
    fmov    d5, #1.0
    fmov    d6, #2.0
    fmov    d7, #4.0
    fmov    d8, d5
0:
    fmov    d9, d3
    fmul    d10, d6, d8
    fsub    d11, d10, d5
    fadd    d12, d5, d10
    fmul    d2, d2, d4
    fmul    d2, d2, d10
    fmul    d2, d2, d11
    fdiv    d2, d2, d8
    fdiv    d2, d2, d8
    fdiv    d2, d2, d7
    fmov    d13, d2
    fdiv    d13, d13, d12
    fadd    d3, d3, d13
    fmov    d17, d0
    fmov    d18, d1
    fmov    d19, d2
    fmov    d20, d3
    fmov    d21, d4
    fmov    d22, d8
    fmov    d23, d9
    fmov    d0, d8
    fmov    d1, d13
    adr     x1, msg8
    bl      fprintf
    cmp     x0, #0
    blt     1f
    fsub    d13, d20, d23
    fmov    d0, d13
    bl      fabs
    ldr     x0, [x29, output]
    fmov    d5, #1.0
    fmov    d6, #2.0
    fmov    d7, #4.0
    fmov    d1, d18
    fmov    d2, d19
    fmov    d3, d20
    fmov    d4, d21
    fmov    d8, d22
    fmov    d9, d23
    fadd    d8, d5, d8
    fmov    d13, d0
    fmov    d0, d17
    fcmp    d1, d13
    blt     0b
    fmov    d0, d3
    ldp     x29, x30, [sp], #24
    ret
1:
    mov     x0, #-1
    fmov    d0, d3
    ldp     x29, x30, [sp], #24
    ret
    .size   custom_arcsin, . - custom_arcsin
    
    .global main
    .type   main, %function
    .equ    arg, 16
    .equ    res, 24
    .equ    prec, 32
    .equ    filename, 40
    .equ    filestruct, 48
main:
    sub     sp, sp, #56
    stp     x29, x30, [sp]
    mov     x29, sp
    cmp     w0, #2
    beq     1f
    ldr     x2, [x1]
    adr     x0, stderr
    ldr     x0, [x0]
    adr     x1, errmsg1
    bl      fprintf
0:
    mov     w0, #1
    ldp     x29, x30, [sp]
    add     sp, sp, #56
    ret
1:
    ldr     x0, [x1, #8]
    str     x0, [x29, filename]
    adr     x1, msg6
    bl      fopen
    cbnz    x0, 2f
    ldr     x0, [x29, filename]
    bl      perror
    b       0b
2:
    str     x0, [x29, filestruct]
    adr     x0, msg1
    bl      printf
    adr     x0, msg2
    add     x1, x29, arg
    bl      scanf
    cmp     x0, #1
    bne     3f
    ldr     d0, [x29, arg]
    bl      fabs
    fmov    d1, #1.0
    fcmp    d0, d1
    bgt     3f
    adr     x0, msg7
    bl      printf
    adr     x0, msg2
    add     x1, x29, prec
    bl      scanf
    cmp     x0, #1
    bne     3f
    ldr     d0, [x29, prec]
    bl      fabs
    fmov    d1, #1.0
    fcmp    d0, d1
    bgt     3f
    ldr     d0, [x29, arg]
    bl      asin
    str     d0, [x29, res]
    adr     x0, msg3
    ldr     d0, [x29, arg]
    ldr     d1, [x29, res]
    bl      printf
    ldr     x0, [x29, filestruct]
    ldr     d0, [x29, arg]
    ldr     d1, [x29, prec]
    bl      custom_arcsin
    cmp     x0, #-1
    beq     4f
    str     d0, [x29, res]
    adr     x0, msg4
    ldr     d0, [x29, arg]
    ldr     d1, [x29, res]
    bl      printf
    mov     x0, #0
    ldp     x29, x30, [sp], #56
    ret
3:
    ldr     x0, [x29, filestruct]
    bl      fclose
    adr     x0, msg5
    bl      printf
    b       0b
4:
    adr     x0, stderr
    ldr     x0, [x0]
    adr     x1, errmsg2
    bl      fprintf
    b       0b
    .size   main, . - main
