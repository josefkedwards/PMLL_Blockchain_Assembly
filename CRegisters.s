.section .data
msg_classical: .asciz "Classical Registers Initialized\n"

.section .bss
stack_base: .space 1024      # Reserve 1KB Stack Memory
heap_base: .space 4096       # Reserve 4KB Heap Memory

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
