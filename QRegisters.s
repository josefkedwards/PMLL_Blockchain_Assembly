.section .bss
qubits: .space 64            # 8 qubits (each 8 bytes)
quantum_register: .space 8   # Placeholder for Quantum Register

.section .data
msg_quantum: .asciz "Quantum Registers Initialized\n"
alpha: .float 0.707          # Coefficient for |0>
beta: .float 0.707           # Coefficient for |1>

.section .text
.global _start

_start:
    # Print initialization message
    mov rdi, msg_quantum
    call print_string

    # Initialize Quantum Registers
    call init_qubits
    call apply_hadamard
    call measure_qubits

    # Exit Program
    mov rax, 60              # syscall: exit()
    xor rdi, rdi             # Exit code 0
    syscall

# === INIT: Set Qubits to Superposition ===
init_qubits:
    mov rax, qubits
    mov rbx, 0
init_loop:
    mov [rax + rbx], alpha     # Set |0> coefficient
    mov [rax + rbx + 4], beta  # Set |1> coefficient
    add rbx, 8
    cmp rbx, 64
    jl init_loop
    ret

# === Apply Hadamard Gate to Each Qubit ===
apply_hadamard:
    mov rax, qubits
    mov rbx, 0
h_loop:
    call hadamard_gate         # External Hadamard gate function
    add rbx, 8
    cmp rbx, 64
    jl h_loop
    ret

# === Measure Qubits into Classical Bits ===
measure_qubits:
    mov rax, qubits
    mov rbx, 0
    xor rcx, rcx               # Clear classical bit register
m_loop:
    call measure_qubit         # External function for measurement
    shl rcx, 1                 # Shift left for next bit
    add rbx, 8
    cmp rbx, 64
    jl m_loop
    mov [quantum_register], rcx  # Store measured classical bits
    ret

print_string:
    mov rax, 1                 # syscall: sys_write
    mov rdi, 1                 # File descriptor (stdout)
    mov rsi, rdi               # Message address
    mov rdx, 100               # Max length
    syscall
    ret
