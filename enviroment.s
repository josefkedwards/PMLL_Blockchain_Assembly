.section .data
prod_space: .space 4096    # 4KB of production memory

.section .text
.global env_setup

env_setup:
    # Initialize production environment
    movq $0, %rax
    movq prod_space(%rip), %rdi
    movq $4096, %rcx        # Clear 4KB of memory
prod_env_clear:
    movb $0, (%rdi)         # Set memory to NULL
    incq %rdi
    loop prod_env_clear

    # Environment ready message
    movq $prod_ready_msg, %rdi
    call printf             # Print production ready message
    ret

prod_ready_msg:
    .asciz "Production environment initialized.\n"
