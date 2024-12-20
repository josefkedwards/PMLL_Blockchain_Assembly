.section .data
prompt_message: .asciz "Enter command: "      # Command prompt
error_message:  .asciz "ERROR: %s\n"          # Error message format
output_format:  .asciz "%s\n"                 # Output format for results
input_buffer:   .space 256                    # Buffer for user input

.section .text
.global window_input
.global window_output
.global window_clear
.global window_error

# Read user input from terminal
# Output:
#   Stores input string in input_buffer
window_input:
    pushq %rbp
    movq %rsp, %rbp

    movq $prompt_message, %rdi   # Prompt user
    call printf

    lea input_buffer(%rip), %rsi # Input buffer
    movq $256, %rdx              # Buffer size
    call fgets                   # Read input

    popq %rbp
    ret

# Print output to terminal
# Arguments:
#   rdi: Address of string to print
window_output:
    pushq %rbp
    movq %rsp, %rbp

    movq $output_format, %rsi    # Format string
    call printf

    popq %rbp
    ret

# Print error message
# Arguments:
#   rdi: Error message string
window_error:
    pushq %rbp
    movq %rsp, %rbp

    movq $error_message, %rsi    # Format string
    call printf

    popq %rbp
    ret

# Clear the terminal screen
window_clear:
    pushq %rbp
    movq %rsp, %rbp

    movq $0x1, %rax              # sys_ioctl syscall
    movq $0x1, %rdi              # stdout file descriptor
    movq $0x5401, %rsi           # TIOCSWINSZ (clear screen)
    syscall

    popq %rbp
    ret
