.section .data
    MSG_LOOP_START: .asciz "Entering infinite loop...\n"
    MSG_LOOP_ITERATION: .asciz "Iteration: %d\n"

.section .bss
    iteration_count: .space 4  # Reserve space for iteration count (optional)

.section .text
.global while_loop
while_loop:
    # Function prologue
    pushq %rbp
    movq %rsp, %rbp

    # Print loop start message
    movq MSG_LOOP_START, %rdi
    call puts

    # Initialize iteration counter (optional)
    movl $0, iteration_count     # Set iteration_count = 0

.infinite_loop:
    # Print the current iteration (optional)
    movq MSG_LOOP_ITERATION, %rdi
    movl iteration_count, %esi   # Pass iteration_count as an argument
    call printf

    # Increment iteration count
    incl iteration_count         # iteration_count++

    # Perform operations inside the loop
    nop                          # Placeholder for loop operations

    # Jump back to the start of the loop
    jmp .infinite_loop

    # Function epilogue (unreachable, but included for completeness)
    movq %rbp, %rsp
    popq %rbp
    ret
