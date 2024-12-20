    .section .data
array_storage:     .space 1024               # Reserve 1024 bytes for array storage
array_base:        .quad 0                   # Store the base address of the array

    .section .text
    .global init_array
    .global write_array
    .global read_array

# Initialize Array
# Parameters: None
# Returns: RAX - Base address of the array
init_array:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set new base pointer

    leaq array_storage(%rip), %rax           # Load address of array storage
    movq %rax, array_base(%rip)              # Save base address to array_base
    movq %rax, %rax                          # Return base address in RAX

    popq %rbp                                # Restore base pointer
    ret                                      # Return

# Write to Array
# Parameters: RDI - Index, RSI - Value
write_array:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set new base pointer

    leaq array_storage(%rip), %rax           # Load base address of the array
    movq %rdi, %rbx                          # Index in RDI
    imulq $8, %rbx, %rbx                     # Multiply index by size of data (8 bytes)
    addq %rbx, %rax                          # Calculate address for index
    movq %rsi, (%rax)                        # Store value in the array

    popq %rbp                                # Restore base pointer
    ret                                      # Return

# Read from Array
# Parameters: RDI - Index
# Returns: RAX - Value at index
read_array:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set new base pointer

    leaq array_storage(%rip), %rax           # Load base address of the array
    movq %rdi, %rbx                          # Index in RDI
    imulq $8, %rbx, %rbx                     # Multiply index by size of data (8 bytes)
    addq %rbx, %rax                        
