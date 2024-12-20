.section .data
XOR_RESULT: .byte 0       # Placeholder for XOR result

.section .text
.global bool_xor

bool_xor:
    # Input: %al contains first boolean, %bl contains second boolean
    xorb %bl, %al           # Perform bitwise XOR between %al and %bl
    movb %al, XOR_RESULT(%rip)  # Store the result in XOR_RESULT
    ret                     # Return to caller
