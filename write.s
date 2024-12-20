    .section .data
char_buffer:     .space 1                    # Reserve 1 byte for a single character

    .section .text
    .global write_string
    .global write_char

# Write String
# Parameters: 
#   RDI - Address of the null-terminated string
write_string:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set up stack frame

.loop:                                       # Loop through the string
    movb (%rdi), %al                         # Load current character into AL
    testb %al, %al                           # Check if null terminator (0)
    je .done                                 # Exit loop if end of string
    movq $1, %rax                            # System call number for write
    movq $1, %rdi                            # File descriptor for stdout
    lea char_buffer(%rip), %rsi              # Address of the buffer
    movb %al, (%rsi)                         # Store character in buffer
    movq $1, %rdx                            # Write 1 byte
    syscall                                  # Make the system call
    incq %rdi                                # Move to the next character
    jmp .loop                                # Repeat for the next character

.done:
    popq %rbp                                # Restore base pointer
    ret                                      # Return

# Write Character
# Parameters: 
#   RDI - Character to write
write_char:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set up stack frame

    movq $1, %rax                            # System call number for write
    movq $1, %rdi                            # File descriptor for stdout
    lea char_buffer(%rip), %rsi              # Address of the buffer
    movb %dil, (%rsi)                        # Store character in buffer
    movq $1, %rdx                            # Write 1 byte
    syscall                                  # Make the system call

    popq %rbp                                # Restore base pointer
    ret                                      # Return
