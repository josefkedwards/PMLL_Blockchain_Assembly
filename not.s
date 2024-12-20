.section .data
NOT_RESULT: .byte 0       # Placeholder for NOT result

.section .text
.global bool_not

bool_not:
    # Input: %al contains the boolean value
    cmpb $0, %al            # Compare %al with 0
    sete %al                # Set %al to 1 if %al == 0, else set %al to 0
    movb %al, NOT_RESULT(%rip)  # Store the result in NOT_RESULT
    ret                     # Return to caller
