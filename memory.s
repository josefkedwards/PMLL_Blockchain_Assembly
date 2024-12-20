.section .data
MEMORY_START: .quad 0       # Base address of allocated memory
MEMORY_SIZE:  .quad 0       # Size of the allocated memory

.section .text
.global allocate_memory
.global deallocate_memory
.global read_memory
.global write_memory

# Allocate Memory
# Input: %rdi = size in bytes
# Output: MEMORY_START contains the base address of the allocated memory
allocate_memory:
    call malloc             # Call malloc to allocate memory
    movq %rax, MEMORY_START(%rip)  # Store the allocated address
    movq %rdi, MEMORY_SIZE(%rip)   # Store the size of the allocated memory
    ret

# Deallocate Memory
# Input: None (uses MEMORY_START)
deallocate_memory:
    movq MEMORY_START(%rip), %rdi  # Load the address of the memory to free
    call free                      # Call free to release memory
    movq $0, MEMORY_START(%rip)    # Reset MEMORY_START
    movq $0, MEMORY_SIZE(%rip)     # Reset MEMORY_SIZE
    ret

# Read from Memory
# Input: %rdi = offset
# Output: %rax = value at MEMORY_START + offset
read_memory:
    movq MEMORY_START(%rip), %rcx  # Load base address of memory
    addq %rdi, %rcx                # Add offset to base address
    movq (%rcx), %rax              # Read value from memory
    ret

# Write to Memory
# Input: %rdi = offset, %rsi = value
write_memory:
    movq MEMORY_START(%rip), %rcx  # Load base address of memory
    addq %rdi, %rcx                # Add offset to base address
    movq %rsi, (%rcx)              # Write value to memory
    ret
