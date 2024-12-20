.section .data
    MSG_COUNTER_START: .asciz "JKE_counter cycle start: %d\n"
    MSG_COUNTER_END: .asciz "JKE_counter cycle end.\n"
    MAX_COUNTER: .int 50

.section .bss
    temp_memory: .space 16  # Reserve space for temporary variables

.section .text
.global JKE_counter_loop
JKE_counter_loop:
    # Function prologue
    pushq %rbp
    movq %rsp, %rbp

    # Initialize JKE_counter to 0
    movl $0, %eax                # JKE_counter = 0
    movl MAX_COUNTER, %ebx       # Load MAX_COUNTER (50) into EBX for comparison

.loop_start:
    # Print the current value of JKE_counter
    movq MSG_COUNTER_START, %rdi # Message format string
    movl %eax, %esi              # Pass JKE_counter as an argument
    call printf

    # Perform operations inside the loop (can call external logic here)
    # Placeholder for loop operations:
    nop                          # No operation (replace with actual operations)

    # Increment JKE_counter
    incl %eax                    # JKE_counter++

    # Check if JKE_counter < 50
    cmpl %ebx, %eax              # Compare JKE_counter and MAX_COUNTER
    jl .loop_start               # Jump back if JKE_counter < 50

    # Loop complete
    movq MSG_COUNTER_END, %rdi   # Print end message
    call puts

    # Function epilogue
    movq %rbp, %rsp
    popq %rbp
    ret
