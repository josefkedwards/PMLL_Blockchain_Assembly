    .section .bss
array_space:    .space 1024                  # Reserve space for an array (256 integers, 4 bytes each)

    .section .text
    .global init_array
    .global write_array
    .global read_array

# Initialize Array
# Parameters:
#   RDI - Address of the array
#   RSI - Size of the array (number of elements)
#   RDX - Initial value for all elements
init_array:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set up stack frame

    movq $0, %rcx                            # Counter for initialization

.init_loop:
    cmpq %rcx, %rsi                          # Check if counter equals size
    je .done_init                            # Exit loop if done

    movq %rdx, (%rdi, %rcx, 4)               # Write initial value into the array
    incq %rcx                                # Increment counter
    jmp .init_loop                           # Repeat for the next element

.done_init:
    popq %rbp                                # Restore base pointer
    ret                                      # Return

# Write to Array
# Parameters:
#   RDI - Address of the array
#   RSI - Index to write (0-based)
#   RDX - Value to write
write_array:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set up stack frame

    movq %rdx, (%rdi, %rsi, 4)               # Write value to array[index]

    popq %rbp                                # Restore base pointer
    ret                                      # Return

# Read from Array
# Parameters:
#   RDI - Address of the array
#   RSI - Index to read (0-based)
# Returns:
#   RAX - Value at the specified index
read_array:
    pushq %rbp                               # Save base pointer
    movq %rsp, %rbp                          # Set up stack frame

    movq (%rdi, %rsi, 4), %rax               # Load value from array[index] into RAX

    popq %rbp                                # Restore base pointer
    ret                                      # Return
