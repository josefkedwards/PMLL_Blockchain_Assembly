section .data
    ; Define node structure and data
    node1_value db "Node1", 0
    node2_value db "Node2", 0
    node3_value db "Node3", 0

    ; Reserve memory for pointers (next nodes)
    node1_next dq 0
    node2_next dq 0
    node3_next dq 0

section .bss
    ; Reserve space for a temporary pointer
    current_node resq 1

section .text
    global _start

_start:
    ; Link the nodes
    mov rax, node2
    mov [node1_next], rax
    mov rax, node3
    mov [node2_next], rax

    ; Set the starting node
    mov rax, node1
    mov [current_node], rax

print_nodes:
    ; Load the current node
    mov rax, [current_node]
    test rax, rax
    jz end_program ; If no more nodes, exit

    ; Print the value
    mov rdi, 1          ; STDOUT
    mov rsi, [rax]      ; Address of node value
    mov rdx, 5          ; Length of string
    mov rax, 0x1        ; syscall: write
    syscall

    ; Move to the next node
    add rax, 8          ; Address of "next" pointer
    mov rax, [rax]      ; Load next node address
    mov [current_node], rax
    jmp print_nodes

end_program:
    ; Exit the program
    mov rax, 0x3c       ; syscall: exit
    xor rdi, rdi        ; Exit code 0
    syscall

section .rodata
node1:
    dq node1_value
    dq node1_next
node2:
    dq node2_value
