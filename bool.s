.section .data
AND_RESULT: .byte 0    # Placeholder for AND result
OR_RESULT:  .byte 0    # Placeholder for OR result
NOT_RESULT: .byte 0    # Placeholder for NOT result

.section .text
.global bool_and
.global bool_or
.global bool_not

# Logical AND
bool_and:
    movb %al, %bl           # Copy first boolean to BL
    andb %bl, %al           # Perform bitwise AND with second boolean
    movb %al, AND_RESULT(%rip)  # Store result
    ret

# Logical OR
bool_or:
    movb %al, %bl           # Copy first boolean to BL
    orb %bl, %al            # Perform bitwise OR with second boolean
    movb %al, OR_RESULT(%rip)   # Store result
    ret

# Logical NOT
bool_not:
    movb %al, %bl           # Copy input boolean to BL
    notb %bl                # Flip bits
    andb $1, %bl            # Ensure only boolean range
    movb %bl, NOT_RESULT(%rip)  # Store result
    ret
