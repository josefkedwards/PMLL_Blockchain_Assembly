.section .text
.global IO_write
.global IO_read
.global IO_print

# Write data to a file descriptor
# Parameters:
#   %rdi: file descriptor
#   %rsi: buffer (pointer to data)
#   %rdx: size of the data
IO_write:
    movq $1, %rax            # System call number for write
    syscall                  # Invoke system call
    ret

# Read data from a file descriptor
# Parameters:
#   %rdi: file descriptor
#   %rsi: buffer (pointer to store data)
#   %rdx: size to read
IO_read:
    movq $0, %rax            # System call number for read
    syscall                  # Invoke system call
    ret

# Print a formatted string
# Parameters:
#   %rdi: pointer to format string
#   %rsi, %rdx, %rcx, ... : Arguments for the format string
IO_print:
    pushq %rbp               # Save base pointer
    movq %rsp, %rbp          # Set stack pointer
    call printf              # Call printf from printf.s
    popq %rbp                # Restore base pointer
    ret
