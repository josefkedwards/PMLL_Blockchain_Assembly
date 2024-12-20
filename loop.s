.section .data
start_val:    .long 0       # Starting value of the loop
end_val:      .long 10      # Ending value of the loop
increment:    .long 1       # Increment step
current_val:  .long 0       # Current loop value (updated during iterations)

.section .text
.global _start

# Function: loop
# Implements a generic loop structure
# Input: start_val, end_val, increment
# Updates current_val during each iteration
loop:
    # Load start_val into current_val
    movl start_val, %eax       # eax = start_val
    movl %eax, current_val     # current_val = eax

.loop_start:
    # Compare current_val with end_val
    movl current_val, %eax     # eax = current_val
    cmpl end_val, %eax         # Compare eax with end_val
    jge .loop_end              # Exit loop if current_val >= end_val

    # Perform loop body (external function call or inline operation)
    call loop_body             # Call the external loop body logic

    # Increment current_val
    movl current_val, %eax     # eax = current_val
    addl increment, %eax       # eax += increment
    movl %eax, current_val     # current_val = eax

    # Jump back to the start of the loop
    jmp .loop_start

.loop_end:
    ret                        # Return from loop function

# Placeholder for loop body logic
# Customize this with actual operations (e.g., calculations, I/O)
loop_body:
    # Example: Print the current_val (requires external syscall setup)
    movl $1, %eax              # syscall: write
    movl $1, %edi              # file descriptor: stdout
    movl current_val, %esi     # message pointer (example value)
    syscall                    # Make system call
    ret
