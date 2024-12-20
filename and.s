.section .data
AND_RESULT: .byte 0      # Placeholder for AND result

.section .text
.global bool_and

bool_and:
    # Input: %al contains first boolean, %bl contains second boolean
    andb %bl, %al          # Perform bitwise AND between %al and %bl
    movb %al, AND_RESULT(%rip)  # Store the result in AND_RESULT
    ret                    # Return to caller
