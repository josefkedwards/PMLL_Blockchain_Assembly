.section .data
test_space: .space 1024    # 1KB of testing memory
log_buffer: .space 256     # Logging buffer for debug messages

.section .text
.global test_env_setup

test_env_setup:
    # Initialize test environment
    movq $0, %rax
    movq test_space(%rip), %rdi
    movq $1024, %rcx        # Clear 1KB of memory
test_env_clear:
    movb $0, (%rdi)         # Set memory to NULL
    incq %rdi
    loop test_env_clear

    # Log setup completion
    lea log_buffer(%rip), %rdi
    movq $debug_message, %rsi
    call printf             # Print debug message
    ret

debug_message:
    .asciz "Test environment setup complete.\n"
