.section .data
MALLOC_RESULT: .quad 0       # Placeholder for the pointer returned by malloc

.section .text
.global malloc_memory

malloc_memory:
    # Input: %rdi contains the size of memory to allocate (in bytes)
    # Output: Address of allocated memory is stored in %rax

    # Call malloc from libc
    call malloc

    # Store the result in MALLOC_RESULT
    movq %rax, MALLOC_RESULT(%rip)

    # Return to caller
    ret
