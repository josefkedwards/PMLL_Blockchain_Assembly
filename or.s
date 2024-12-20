.section .data
OR_RESULT: .byte 0       # Placeholder for OR result

.section .text
.global bool_or

bool_or:
    # Input: %al contains first boolean, %bl contains second boolean
    orb %bl, %al           # Perform bitwise OR between %al and %bl
    movb %al, OR_RESULT(%rip)  # Store the result in OR_RESULT
    ret                    # Return to caller
