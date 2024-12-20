.section .data
FALSE: .byte 0    # Define boolean 0 (false)

.section .text
.global is_false

is_false:
    movb FALSE(%rip), %al  # Load FALSE into AL register
    ret                    # Return value
