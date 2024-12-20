.section .data
    MSG_IF_TRUE:  .asciz "Condition is true: a < b\n"
    MSG_IF_FALSE: .asciz "Condition is false: a >= b\n"

.section .bss
    a: .space 4      # Reserve space for variable a
    b: .space 4      # Reserve space for variable b

.section .text
.global if_else
if_else:
    # Function prologue
    pushq %rbp
    movq %rsp, %rbp

    # Initialize variables
    movl $5, a       # a = 5
    movl $10, b      # b = 10

    # Compare a and b
    movl a, %eax     # Load a into eax
    cmpl b, %eax     # Compare b with a
    jl .if_true      # Jump to true block if a < b

.else_block:
    # Print message for false condition
    movq MSG_IF_FALSE, %rdi
    call puts
    jmp .if_end      # Skip the true block

.if_true:
    # Print message for true condition
    movq MSG_IF_TRUE, %rdi
    call puts

.if_end:
    # Function epilogue
    movq %rbp, %rsp
    popq %rbp
    ret
