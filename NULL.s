.section .data
null_byte:
    .byte 0x00                # NULL representation

.section .text
.global is_null
.global set_null
.global clear_null

# Function: is_null
# Description: Check if a given pointer or value is NULL.
# Inputs:
#   rdi - Address of the value to check
# Outputs:
#   al - 1 if NULL, 0 otherwise
is_null:
    pushq %rbp
    movq %rsp, %rbp

    movb (rdi), %al           # Load the value at the address
    cmpb $0x00, %al           # Compare with NULL byte
    sete %al                  # Set AL to 1 if equal, 0 otherwise
    leave
    ret

# Function: set_null
# Description: Set a given pointer or value to NULL.
# Inputs:
#   rdi - Address of the value to set to NULL
set_null:
    pushq %rbp
    movq %rsp, %rbp

    movb $0x00, (rdi)         # Set the value at the address to NULL byte
    leave
    ret

# Function: clear_null
# Description: Clear NULL status by setting a non-NULL value.
# Inputs:
#   rdi - Address of the value
#   rsi - New value to set
clear_null:
    pushq %rbp
    movq %rsp, %rbp

    movb %sil, (rdi)          # Store the new value in the address
    leave
    ret
