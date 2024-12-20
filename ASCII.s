.section .data
digit_table: .asciz "0123456789"       # Lookup table for digits
ascii_space: .byte 32                  # ASCII code for space
ascii_zero:  .byte 48                  # ASCII code for '0'

.section .text
.global int_to_ascii
.global ascii_to_int
.global ascii_concat

# int_to_ascii: Convert an integer to an ASCII string
# Arguments:
#   rdi: Integer to convert
#   rsi: Pointer to output buffer (must be preallocated)
# Returns:
#   None (writes ASCII string into the buffer)
int_to_ascii:
    pushq %rbp
    movq %rsp, %rbp

    movq %rdi, %rax                  # Load input integer
    lea digit_table(%rip), %rdx      # Load digit table
    movq %rsi, %rdi                  # Output buffer pointer

    xorq %rcx, %rcx                  # Digit counter
.loop:
    xorq %rdx, %rdx                  # Clear remainder register
    movq $10, %rbx                   # Divisor (base 10)
    divq %rbx                        # rax = rax / 10, rdx = rax % 10
    addb $48, %dl                    # Convert remainder to ASCII ('0' + remainder)
    movb %dl, (%rdi,%rcx)            # Store ASCII digit in buffer
    incq %rcx                        # Increment digit counter
    cmpq $0, %rax                    # Check if quotient is zero
    jne .loop                        # Continue if quotient is not zero

    movq %rcx, %rax                  # Save digit count
    movq %rdi, %rsi                  # Pointer to buffer
    call reverse_array               # Reverse the buffer for correct order

    popq %rbp
    ret

# ascii_to_int: Convert an ASCII string to an integer
# Arguments:
#   rdi: Pointer to ASCII string
# Returns:
#   rax: Converted integer
ascii_to_int:
    pushq %rbp
    movq %rsp, %rbp

    xorq %rax, %rax                  # Clear rax (result)
    xorq %rcx, %rcx                  # Clear rcx (multiplier)
.loop:
    movb (%rdi,%rcx), %dl            # Load current character
    cmpb $0, %dl                     # Check for null terminator
    je .done                         # Exit loop if null terminator is reached
    subb $48, %dl                    # Convert ASCII to digit ('0' = 48)
    imulq $10, %rax                  # Multiply result by 10
    addq %rdx, %rax                  # Add current digit to result
    incq %rcx                        # Move to next character
    jmp .loop

.done:
    popq %rbp
    ret

# ascii_concat: Concatenate two ASCII strings
# Arguments:
#   rdi: Pointer to destination buffer
#   rsi: Pointer to first string
#   rdx: Pointer to second string
# Returns:
#   None (writes concatenated string to destination buffer)
ascii_concat:
    pushq %rbp
    movq %rsp, %rbp

    movq %rdi, %rax                  # Destination buffer
    movq %rsi, %rcx                  # First string pointer

    # Copy first string
.copy_first:
    movb (%rcx), %dl                 # Load character
    cmpb $0, %dl                     # Check for null terminator
    je .copy_second                  # Jump to second string if null
    movb %dl, (%rax)                 # Write character to destination
    incq %rcx                        # Advance first string pointer
    incq %rax                        # Advance destination pointer
    jmp .copy_first

.copy_second:
    movq %rdx, %rcx                  # Load second string pointer

.copy_loop:
    movb (%rcx), %dl                 # Load character
    cmpb $0, %dl                     # Check for null terminator
    je .done                         # Exit if null terminator
    movb %dl, (%rax)                 # Write character to destination
    incq %rcx                        # Advance second string pointer
    incq %rax                        # Advance destination pointer
    jmp .copy_loop

.done:
    movb $0, (%rax)                  # Null-terminate destination string
    popq %rbp
    ret
