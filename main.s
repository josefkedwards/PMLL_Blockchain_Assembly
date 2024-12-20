.section .text
.global _start         # Entry point for the program

_start:
    # Save base pointer and set up stack frame
    pushq %rbp
    movq %rsp, %rbp

    # Initialize variables or configurations
    call init_variables      # Initialize global variables (from variable.s)

    # Initialize graph system
    call init_graph          # Call graph initialization (from Create_Graph.s)

    # Run the main Persistent Memory Logic Loop
    call PMLL_loop           # Call the main loop (from pmll.s)

    # Exit program
    call exit_program        # Clean up and exit (defined below)

exit_program:
    # System call for exiting the program
    movq $60, %rax           # syscall: exit
    xorq %rdi, %rdi          # status: 0
    syscall                  # Make the system call

    # Restore base pointer and return
    popq %rbp
    ret
