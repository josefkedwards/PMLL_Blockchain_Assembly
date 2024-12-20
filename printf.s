.section .text
.global printf

printf:
    pushq %rbp                     # Save base pointer
    movq %rsp, %rbp                # Set stack pointer to base pointer
    subq $128, %rsp                # Allocate stack space for local variables

    movq %rdi, -8(%rbp)            # Store format string pointer
    leaq 16(%rbp), %rdi            # Load address of variadic arguments
    movq %rdi, -16(%rbp)           # Store argument pointer

    # Parse the format string
printf_parse:
    movq -8(%rbp), %rsi            # Load format string pointer
    movb (%rsi), %al               # Get the current character
    testb %al, %al                 # Check if null-terminator
    je printf_done                 # If null, we're done

    cmpb $37, %al                  # Check for '%'
    je printf_format               # If '%', process formatting

    # Print regular characters
    pushq %rsi                     # Save format string pointer
    movq %rsi, %rdi                # Pass character to write_array
    call write_array               # Write character
    popq %rsi                      # Restore format string pointer

    addq $1, %rsi                  # Move to the next character
    movq %rsi, -8(%rbp)            # Update format string pointer
    jmp printf_parse               # Repeat

# Process format specifiers
printf_format:
    addq $1, %rsi                  # Move to the character after '%'
    movb (%rsi), %al               # Load the specifier
    cmpb $115, %al                 # Check for 's' (string)
    je printf_string
    cmpb $100, %al                 # Check for 'd' (integer)
    je printf_integer
    cmpb $120, %al                 # Check for 'x' (hexadecimal)
    je printf_hexadecimal

    # Unsupported specifier
    movq $-1, %rax                 # Error return value
    jmp printf_done

printf_string:
    movq -16(%rbp), %rdi           # Load argument pointer
    movq (%rdi), %rsi              # Get the string argument
    call string                    # Call string handler
    addq $8, -16(%rbp)             # Move to the next argument
    addq $1, %rsi                  # Move to the next format character
    movq %rsi, -8(%rbp)            # Update format string pointer
    jmp printf_parse

printf_integer:
    movq -16(%rbp), %rdi           # Load argument pointer
    movq (%rdi), %rsi              # Get the integer argument
    call integer                   # Convert and print integer
    addq $8, -16(%rbp)             # Move to the next argument
    addq $1, %rsi                  # Move to the next format character
    movq %rsi, -8(%rbp)            # Update format string pointer
    jmp printf_parse

printf_hexadecimal:
    movq -16(%rbp), %rdi           # Load argument pointer
    movq (%rdi), %rsi              # Get the hexadecimal argument
    call hex                       # Convert and print hexadecimal
    addq $8, -16(%rbp)             # Move to the next argument
    addq $1, %rsi                  # Move to the next format character
    movq %rsi, -8(%rbp)            # Update format string pointer
    jmp printf_parse

printf_done:
    movq $0, %rax                  # Return 0 (success)
    leave
    ret
