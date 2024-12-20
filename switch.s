.section .data
CASE_RESULT:    .quad 0         # Placeholder for storing case result
DEFAULT_MSG:    .asciz "Default case executed\n"

.section .text
.global switch_case

# switch_case Implementation
# Input:
#   %rdi - Value to switch on
# Output:
#   Executes the corresponding case block or the default block
switch_case:
    pushq %rbp                   # Save base pointer
    movq %rsp, %rbp              # Set stack pointer

    # Compare value in %rdi with each case
    cmpq $1, %rdi                # Check if value matches case 1
    je case_1
    cmpq $2, %rdi                # Check if value matches case 2
    je case_2
    cmpq $3, %rdi                # Check if value matches case 3
    je case_3

    # Default case
    jmp default_case

case_1:
    lea case_1_msg(%rip), %rdi   # Load case 1 message
    call print_phrase            # Call print function
    jmp switch_end

case_2:
    lea case_2_msg(%rip), %rdi   # Load case 2 message
    call print_phrase            # Call print function
    jmp switch_end

case_3:
    lea case_3_msg(%rip), %rdi   # Load case 3 message
    call print_phrase            # Call print function
    jmp switch_end

default_case:
    lea DEFAULT_MSG(%rip), %rdi  # Load default case message
    call print_phrase            # Call print function

switch_end:
    popq %rbp                    # Restore base pointer
    ret                          # Return to caller

# Messages for each case
.section .rodata
case_1_msg:
    .asciz "Case 1 executed\n"
case_2_msg:
    .asciz "Case 2 executed\n"
case_3_msg:
    .asciz "Case 3 executed\n"
