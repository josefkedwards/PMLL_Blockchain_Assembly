.section .data
debug_message: .asciz "DEBUG: %s\n"        # Format for debug messages
debug_value:   .asciz "DEBUG: %s = %d\n"  # Format for variable value

.section .text
.global debug_string
.global debug_register
.global debug_memory

# Print a debug message
# Arguments:
#   rdi: Address of string to print
debug_string:
    pushq %rbp
    movq %rsp, %rbp
    movq $debug_message, %rsi   # Format string
    call printf
    popq %rbp
    ret

# Print a register value
# Arguments:
#   rdi: Register name (string)
#   rsi: Register value
debug_register:
    pushq %rbp
    movq %rsp, %rbp
    movq $debug_value, %rdx     # Format string
    call printf
    popq %rbp
    ret

# Print memory contents
# Arguments:
#   rdi: Memory address
#   rsi: Number of bytes to print
debug_memory:
    pushq %rbp
    movq %rsp, %rbp

    movq %rdi, %rsi             # Start address
    movq %rsi, %rdx             # Number of bytes
    call print_memory_range     # Call helper function

    popq %rbp
    ret

# Helper function: Print memory range
# Arguments:
#   rdi: Start address
#   rsi: Number of bytes
print_memory_range:
    pushq %rbp
    movq %rsp, %rbp

    movq %rsi, %rcx             # Counter
debug_loop:
    cmpq $0, %rcx
    je debug_done
    movb (%rdi), %al
    call putchar                # Print byte
    incq %rdi                   # Move to next byte
    decq %rcx                   # Decrement counter
    jmp debug_loop

debug_done:
    popq %rbp
    ret
