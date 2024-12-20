.section .data
    MSG_FOR_START: .asciz "Starting for loop...\n"
    MSG_FOR_ITER: .asciz "Iteration: %d\n"

.section .bss
    counter: .space 4  # Reserve space for the loop counter

.section .text
.global for_loop
for_loop:
    # Function prologue
    pushq %rbp
    movq %rsp, %rbp

    # Print start message
    movq MSG_FOR_START, %rdi
    call puts

    # Initialize loop counter
    movl $0, counter       # counter = 0

.for_condition:
    # Compare counter < 10
    cmpl $10, counter      # Compare counter and 10
    jge .for_exit          # Exit if counter >= 10

    # Print iteration message (optional)
    movq MSG_FOR_ITER, %rdi
    movl counter, %esi     # Pass counter as the second argument
    call printf

    # Perform operations inside the loop
    nop                    # Placeholder for loop body

    # Increment counter
    incl counter           # counter++

    # Jump back to condition
    jmp .for_condition

.for_exit:
    # Loop exit (optional cleanup here)
    nop                    # Placeholder for exit actions

    # Function epilogue
    movq %rbp, %rsp
    popq %rbp
    ret
