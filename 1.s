.section .data
TRUE: .byte 1     # Define boolean 1 (true)

.section .text
.global is_true

is_true:
    movb TRUE(%rip), %al   # Load TRUE into AL register
    ret                    # Return value
