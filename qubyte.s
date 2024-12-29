.section .data
qubyte:   .space 64           # Allocate 64 bytes (8 qubits * 8 bytes each)
alpha:    .float 0.707        # Coefficient for |0>
beta:     .float 0.707        # Coefficient for |1>

.section .text
.global main
main:
    # Initialize the qubyte to a superposition state
    call init_qubyte

    # Apply quantum operations
    call hadamard_qubyte       # Apply Hadamard gate to each qubit
    call measure_qubyte        # Measure all qubits into classical byte
    ret

# Function: init_qubyte
# Initialize all qubits in the qubyte
init_qubyte:
    mov rax, qubyte            # Load qubyte address
    mov rbx, 0                 # Index register
init_loop:
    mov [rax + rbx], alpha     # Set alpha coefficient
    mov [rax + rbx + 4], beta  # Set beta coefficient
    add rbx, 8                 # Move to next qubit
    cmp rbx, 64                # Check if all 8 qubits initialized
    jl init_loop
    ret

# Function: hadamard_qubyte
# Apply Hadamard gate to all qubits
hadamard_qubyte:
    mov rax, qubyte            # Load qubyte address
    mov rbx, 0                 # Index register
h_loop:
    call hadamard_gate         # Apply Hadamard gate (external function)
    add rbx, 8                 # Move to next qubit
    cmp rbx, 64                # Check if all 8 qubits processed
    jl h_loop
    ret

# Function: measure_qubyte
# Measure all qubits into classical byte
measure_qubyte:
    mov rax, qubyte            # Load qubyte address
    mov rbx, 0                 # Index register
    xor rcx, rcx               # Clear classical byte register
m_loop:
    call measure_qubit         # Measure single qubit (external function)
    shl rcx, 1                 # Shift left to make space for next bit
    add rbx, 8                 # Move to next qubit
    cmp rbx, 64                # Check if all 8 qubits measured
    jl m_loop
    mov [result], rcx          # Store measured result in classical byte
    ret
