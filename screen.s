.section .data
screen_clear_seq: .asciz "\033[2J\033[H"  # ANSI escape sequence to clear the screen and reset cursor

.section .text
.global screen_clear
.global screen_print_char
.global screen_print_string
.global screen_set_cursor

# screen_clear: Clears the terminal screen
# Arguments: None
# Returns: None
screen_clear:
    pushq %rbp
    movq %rsp, %rbp

    lea screen_clear_seq(%rip), %rdi  # Load address of clear screen sequence
    call write_array                  # Use write_array to send escape sequence to stdout

    popq %rbp
    ret

# screen_print_char: Print a single character to the screen
# Arguments:
#   rdi: ASCII character to print
# Returns: None
screen_print_char:
    pushq %rbp
    movq %rsp, %rbp

    movq $1, %rdi                     # File descriptor (stdout)
    lea -1(%rsp), %rsi                # Temporary buffer for the character
    movb %dil, (%rsi)                 # Store the character in buffer
    movq $1, %rdx                     # Length (1 byte)
    call write                        # Call write to print the character

    popq %rbp
    ret

# screen_print_string: Print a null-terminated string to the screen
# Arguments:
#   rdi: Pointer to the null-terminated string
# Returns: None
screen_print_string:
    pushq %rbp
    movq %rsp, %rbp

    movq %rdi, %rsi                   # String pointer
.loop:
    movb (%rsi), %al                  # Load the current character
    testb %al, %al                    # Check if null terminator
    je .done                          # Exit if null terminator
    movq %rax, %rdi                   # Pass character to screen_print_char
    call screen_print_char            # Print character
    incq %rsi                         # Advance to the next character
    jmp .loop                         # Repeat for next character

.done:
    popq %rbp
    ret

# screen_set_cursor: Set cursor position on the screen
# Arguments:
#   rdi: Row position (1-based index)
#   rsi: Column position (1-based index)
# Returns: None
screen_set_cursor:
    pushq %rbp
    movq %rsp, %rbp

    # Escape sequence: "\033[row;colH"
    movq $1, %rdx                     # File descriptor (stdout)
    movq %rdi, %rax                   # Row position
    movq %rsi, %rbx                   # Column position
    lea -32(%rsp), %rsi               # Temporary buffer
    movb $0, (%rsi)                   # Null-terminate string

    # Build escape sequence
    lea screen_clear_seq(%rip), %rdi  # Start with ESC [
    call screen_print_string

    movq %rax, %rdx
