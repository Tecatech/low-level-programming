    .arch   armv8-a
    
    .text
    .align  2
    .global image_rotation_arm64
    .type   image_rotation_arm64, %function
    .equ    input_buffer, 16
    .equ    output_buffer, 24
    .equ    input_width, 32
    .equ    input_height, 40
    .equ    rotation_angle, 48
    .equ    output_width, 56
    .equ    output_height, 64
    .equ    cosine_value, 72
    .equ    sine_value, 80
image_rotation_arm64:
    sub     sp, sp, #88
    stp     x29, x30, [sp]
    mov     x29, sp
    str     x0, [x29, input_buffer]
    str     x1, [x29, input_width]
    str     x2, [x29, input_height]
    str     d0, [x29, rotation_angle]
    str     x3, [x29, output_width]
    str     x4, [x29, output_height]
    bl      cos
    str     d0, [x29, cosine_value]
    ldr     d0, [x29, rotation_angle]
    bl      sin
    str     d0, [x29, sine_value]
    ldr     d1, [x29, cosine_value]
    ldr     x2, [x29, input_width]
    ldr     x3, [x29, input_height]
    ldr     x4, [x29, output_width]
    ldr     x5, [x29, output_height]
    mov     x6, #3
    mul     x0, x4, x5
    mul     x0, x0, x6
    mov     x1, #1
    bl      calloc
    str     x0, [x29, output_buffer]
    ldr     x0, [x29, input_buffer]
    ldr     x1, [x29, output_buffer]
    ldr     x2, [x29, input_width]
    ldr     x3, [x29, input_height]
    ldr     x4, [x29, output_width]
    ldr     x5, [x29, output_height]
    ldr     d0, [x29, sine_value]
    ldr     d1, [x29, cosine_value]
    lsr     x2, x2, #1
    lsr     x3, x3, #1
    lsr     x4, x4, #1
    lsr     x5, x5, #1
    scvtf   d2, x2
    scvtf   d3, x3
    ldr     x7, [x29, input_width]
    ldr     x8, [x29, input_height]
    ldr     x9, [x29, output_width]
    ldr     x10, [x29, output_height]
0:
    mov     x11, #-1
1:
    add     x11, x11, #1
    cmp     x9, x11
    ble     3f
    mov     x12, #-1
2:
    add     x12, x12, #1
    cmp     x10, x12
    ble     1b
    sub     x13, x11, x4
    scvtf   d4, x13
    fneg    d5, d4
    sub     x14, x12, x5
    scvtf   d6, x14
    fneg    d7, d6
    fmul    d8, d0, d6
    fmul    d9, d1, d4
    fadd    d10, d8, d9
    fadd    d11, d2, d10
    fmul    d8, d0, d5
    fmul    d9, d1, d6
    fadd    d12, d8, d9
    fadd    d4, d3, d12
    fcvtzs  x15, d11
    fcvtzs  x16, d4
    cmp     x15, #0
    ccmp    x7, x15, #4, ge
    ble     2b
    cmp     x16, #0
    ccmp    x8, x16, #4, ge
    ble     2b
    madd    x17, x7, x16, x15
    mul     x18, x6, x17
    madd    x19, x9, x12, x11
    mul     x20, x6, x19
    ldrb    w21, [x0, x18]
    strb    w21, [x1, x20]
    add     x18, x18, #1
    add     x20, x20, #1
    ldrb    w21, [x0, x18]
    strb    w21, [x1, x20]
    add     x18, x18, #1
    add     x20, x20, #1
    ldrb    w21, [x0, x18]
    strb    w21, [x1, x20]
    b       2b
3:
    ldr     x0, [x29, output_buffer]
    ldp     x29, x30, [sp], #88
    ret
    .size   image_rotation_arm64, . - image_rotation_arm64
