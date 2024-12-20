    .section .data
pointer_data:     .space 8                 # Reserve 8 bytes for the pointer data

    .section .text
    .global init_pointer
    .global assign_pointer
    .global dereference_pointer

# Initialize Pointer
# Parameters: RDI - Address to initialize pointer
init_pointer:
    pushq %rbp                            # Save base pointer
    movq %rsp, %rbp                       # Set new base pointer

    movq $0, pointer_data(%rip)           # Set the pointer data to 0
    movq %rdi, pointer_data(%rip)         # Store the address in the pointer

    popq %rbp                             # Restore base pointer
    ret                                   # Return

# Assign Value to Pointer
# Parameters: RDI - Pointer address, RSI - Value to assign
assign_pointer:
    pushq %rbp                            # Save base pointer
    movq %rsp, %rbp                       # Set new base pointer

    movq pointer_data(%rip), %rax         # Load pointer data (address)
    movq %rsi, (%rax)                     # Assign value to the memory location

    popq %rbp                             # Restore base pointer
    ret                                   # Return

# Dereference Pointer
# Parameters: RDI - Pointer address
# Returns: RAX - Value at the pointer address
dereference_pointer:
    pushq %rbp                            # Save base pointer
    movq %rsp, %rbp                       # Set new base pointer

    movq pointer_data(%rip), %rax         # Load pointer data (address)
    movq (%rax), %rax                     # Dereference and load value into RAX

    popq %rbp                             # Restore base pointer
    ret                                   # Return value
