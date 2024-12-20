.section .data
JKE_counter: .long 0        # Counter
MAX_COUNT: .long 50         # Max iterations

.section .text
.global PMLL_loop

PMLL_loop:
    pushq %rbp              # Save base pointer
    movq %rsp, %rbp         # Set stack pointer

    # Load JKE_counter and MAX_COUNT
    movl JKE_counter(%rip), %eax
    movl MAX_COUNT(%rip), %ebx

LOOP_START:
    # Compare JKE_counter with MAX_COUNT
    cmpl %ebx, %eax
    jge LOOP_END            # Exit loop if JKE_counter >= MAX_COUNT

    # Print or process JKE_counter (placeholder logic)
    call print_counter

    # Increment JKE_counter
    incl %eax
    movl %eax, JKE_counter(%rip)

    # Repeat loop
    jmp LOOP_START

LOOP_END:
    popq %rbp               # Restore base pointer
    ret

# Function to print the counter (uses printf.s)
print_counter:
    # (Placeholder) Logic for printing JKE_counter
    ret
