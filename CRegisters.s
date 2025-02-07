.section .data
msg_classical: .asciz "Classical Registers Initialized\n"

.section .bss
stack_base: .space 8192      # Reserve 8KB Stack Memory
heap_base: .space 16384       # Reserve 16KB Heap Memory, we are getting to the eventual 64x memory architecture in modern computers fyi

.section .text
.global _start

_start:
    # Print initialization message
    mov rdi, msg_classical
    call print_string

    # Classical CPU Registers
    mov rax, 0x1             # Load value into RAX
    mov rbx, 0x2             # Load value into RBX
    mov rcx, 0x3             # Load value into RCX
    mov rdx, 0x4             # Load value into RDX

    # Floating Point Example
    movsd xmm0, qword [double_value]  # Load floating point value
    movsd xmm1, qword [double_value]

    # Stack Pointer Example
    mov rsp, stack_base      # Set stack pointer
    push rax                 # Push RAX onto stack
    pop rbx                  # Pop into RBX

    # End program
    mov rax, 60              # syscall: exit()
    xor rdi, rdi             # Exit code 0
    syscall

print_string:
    mov rax, 1               # syscall: sys_write
    mov rdi, 1               # File descriptor (stdout)
    mov rsi, rdi             # Message address
    mov rdx, 100             # Max length
    syscall
    ret

.section .data
double_value: .double 3.14159  # Example floating point value

.section .bss
stack_base: .space 8192      # Reserve 8KB Stack Memory (for function calls)
heap_base: .space 16384      # Reserve 16KB Heap Memory (for dynamic allocation)

.section .data
msg_classical: .asciz "Classical Registers Initialized\n"
msg_stack: .asciz "Stack operation successful\n"
msg_error: .asciz "Error occurred!\n"
double_value: .double 3.14159  

.section .text
.global _start

# === Entry Point ===
_start:
    # Print Initialization Message
    mov rdi, msg_classical
    call print_string

    # === Classical Register Initialization ===
    mov rax, 0x1            # General-Purpose Registers
    mov rbx, 0x2
    mov rcx, 0x3
    mov rdx, 0x4

    # === Floating Point Registers ===
    movsd xmm0, qword [double_value]  # Load floating point value
    movsd xmm1, qword [double_value]

    # === Stack Operations ===
    mov rsp, stack_base      # Set Stack Pointer
    push rax                 # Push RAX onto stack
    pop rbx                  # Pop into RBX
    mov rdi, msg_stack       # Stack success message
    call print_string

    # === Heap Operations (Simulated) ===
    mov rax, heap_base       # Load heap base address
    mov qword [rax], 42      # Store value in heap memory

    # Validate Heap Value
    cmp qword [rax], 42
    jne heap_error           # If not 42, jump to error handling

    # === Program Exit ===
    call exit_program
    ret

heap_error:
    mov rdi, msg_error
    call print_string
    call exit_error
    ret

# === Print String Function ===
print_string:
    push rbp                 # Save Base Pointer
    mov rbp, rsp             # Set Up Stack Frame
    mov rax, 1               # syscall: sys_write
    mov rdi, 1               # File Descriptor (stdout)
    mov rdx, 0               # Initialize Length Counter
    mov rcx, rsi             # Copy Message Address

    # Calculate String Length
strlen_loop:
    cmp byte [rcx], 0        # Check for Null Terminator
    je print_execute         # If Found, Proceed to Print
    inc rdx                  # Increment Length Counter
    inc rcx                  # Move to Next Character
    jmp strlen_loop          # Continue Counting

print_execute:
    syscall                  # Execute sys_write
    cmp rax, 0               # Check for Errors
    jl print_error           # Handle Error if Negative
    pop rbp                  # Restore Base Pointer
    ret

print_error:
    mov rdi, msg_error       # Load Error Message
    call print_string
    call exit_error
    ret

# === Program Exit Function ===
exit_program:
    mov rax, 60              # syscall: exit
    xor rdi, rdi             # Exit Code 0
    syscall
    ret

# === Error Exit Function ===
exit_error:
    mov rax, 60              # syscall: exit
    mov rdi, 1               # Exit Code 1 (Error)
    syscall
    ret

