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
    movsd xmm0, qword [double_value]
.section .data
    ; Fundamental mathematical constants
    pi:          .double 3.14159265358979323846   # π (pi) - ratio of circumference to diameter
    e:           .double 2.71828182845904523536   # e (euler's number) - base of natural logarithm
    phi:         .double 1.61803398874989484820   # φ (phi) - golden ratio
    
    ; Square roots of common numbers
    sqrt2:       .double 1.41421356237309504880   # √2 - diagonal of unit square
    sqrt3:       .double 1.73205080756887729352   # √3 - height of equilateral triangle
    sqrt5:       .double 2.23606797749978969640   # √5 - used in golden ratio calculation
    
    ; Natural logarithms
    ln2:         .double 0.69314718055994530942   # ln(2) - natural log of 2
    ln10:        .double 2.30258509299404568402   # ln(10) - natural log of 10
    
    ; Other useful constants
    gamma:       .double 0.57721566490153286061   # γ (gamma) - Euler-Mascheroni constant
    tau:         .double 6.28318530717958647693   # τ (tau) - 2π, full circle in radians

    movsd xmm0, qword [pi]      # Load pi into xmm0
    movsd xmm1, qword [phi]     # Load phi into xmm1
    movsd xmm2, qword [sqrt2]   # Load square root of 2 into xmm2  # Load floating point value
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

;------------------------------------------------------------------------------
; print_string - Prints a null-terminated string to stdout
;
; Description:
; Safely prints a null-terminated string to standard output with proper
; error handling and stack frame management.
;
; Parameters:
; rdi - Address of the null-terminated string to print
;
; Returns:
; rax - Number of bytes written (if successful)
; On error: Exits program with status code 1
;
; Clobbers:
; rax, rcx, rdx, rsi
;
; Notes:
; - Automatically calculates string length
; - Preserves base pointer
; - Handles syscall errors
;------------------------------------------------------------------------------
print_string:
push rbp # Save base pointer
mov rbp, rsp # Set up stack frame
mov rax, 1 # syscall: sys_write
mov rdi, 1 # File descriptor (stdout)
mov rsi, rdi # Message address from parameter
mov rdx, 0 # Initialize length
mov rcx, rsi # Copy string address
.strlen: # Calculate string length
cmp byte [rcx], 0 # Check for null terminator
je .print # If found, print string
inc rdx # Increment length
inc rcx # Move to next character
jmp .strlen # Continue counting
.print:
syscall
cmp rax, 0 # Check for error
jl .error # Handle error if negative
pop rbp # Restore base pointer
ret
.error:
mov rax, 60 # Exit on error
mov rdi, 1 # Error code 1
syscall

