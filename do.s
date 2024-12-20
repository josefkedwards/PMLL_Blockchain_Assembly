.section .data
DO_COUNTER:    .quad 0          # Counter for iterations
MAX_ITERATIONS: .quad 5         # Maximum number of iterations
LOOP_MSG:      .asciz "Iteration %d\n"
END_MSG:       .asciz "Do-While loop complete\n"

.section .text
.global do_while_loop

# do_while_loop Implementation
# Executes the loop body at least once before checking the condition
do_while_loop:
    pushq %rbp                   # Save base pointer
    movq %rsp, %rbp              # Set up stack pointer

    movq DO_COUNTER(%rip), %rax  # Load counter into %rax

do_loop_start:
    # Execute loop body
    movq %rax, %rsi              # Move counter value to %rsi for printf
    lea LOOP_MSG(%rip), %rdi     # Load the loop message
    call print_phrase            # Print the message

    # Increment counter
    incq %rax
    movq %rax, DO_COUNTER(%rip)  # Update DO_COUNTER

    # Check condition: if counter < MAX_ITERATIONS
    movq MAX_ITERATIONS(%rip), %rbx
    cmpq %rbx, %rax
    jl do_loop_start             # Jump back if condition is true

    # Loop complete
    lea END_MSG(%rip), %rdi      # Load end message
    call print_phrase            # Print the end message

    popq %rbp                    # Restore base pointer
    ret                          # Return to caller
