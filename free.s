.section .text
.global free_memory

free_memory:
    # Input: %rdi contains the pointer to memory to free
    call free
    ret
