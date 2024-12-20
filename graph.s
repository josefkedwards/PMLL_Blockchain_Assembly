    .section .data
# Graph metadata
graph_type:     .asciz "memory"           # Example graph type (e.g., memory, emotional)
max_nodes:      .long 1024                # Maximum nodes allowed
max_edges:      .long 1024                # Maximum edges allowed

# Graph structure
node_count:     .long 0                   # Current number of nodes
edge_count:     .long 0                   # Current number of edges
nodes:          .space 1024 * 8           # Array to store node pointers (1024 nodes max)
edges:          .space 1024 * 16          # Array to store edges (1024 edges max)

    .section .text
    .global init_graph
    .global write_node
    .global connect_nodes
    .global destroy_graph

# Initialize Graph
# Parameters: RDI - graph type
init_graph:
    pushq %rbp                          # Save base pointer
    movq %rsp, %rbp                     # Set new base pointer

    movq $0, node_count(%rip)           # Reset node count
    movq $0, edge_count(%rip)           # Reset edge count
    movq %rdi, graph_type(%rip)         # Set graph type

    movq nodes(%rip), %rax              # Allocate memory for nodes
    movq edges(%rip), %rdx              # Allocate memory for edges

    popq %rbp                           # Restore base pointer
    ret

# Write Node
# Parameters: RDI - pointer to node data
write_node:
    pushq %rbp                          # Save base pointer
    movq %rsp, %rbp                     # Set new base pointer

    movl node_count(%rip), %eax         # Get current node count
    cmpl max_nodes(%rip), %eax          # Compare with max nodes
    jae .error                          # If exceeded, jump to error

    movq nodes(%rip), %rcx              # Base address of nodes array
    movq %rdi, (%rcx, %rax, 8)          # Add node data to array
    incl node_count(%rip)               # Increment node count

    jmp .done

.error:
    movq $-1, %rax                      # Return -1 for error
    jmp .exit

.done:
    movq $0, %rax                       # Return 0 for success

.exit:
    popq %rbp                           # Restore base pointer
    ret

# Connect Nodes
# Parameters: RDI - node1 index, RSI - node2 index
connect_nodes:
    pushq %rbp                          # Save base pointer
    movq %rsp, %rbp                     # Set new base pointer

    movl node_count(%rip), %eax         # Get current node count
    cmpl %edi, %eax                     # Validate node1 index
    jae .error                          # If invalid, jump to error
    cmpl %esi, %eax                     # Validate node2 index
    jae .error                          # If invalid, jump to error

    movq edges(%rip), %rcx              # Base address of edges array
    leaq (%rdi, %rsi, 8), %rax          # Create edge (node1 -> node2)
    movq %rax, (%rcx, edge_count(%rip), 16) # Add edge to edges array
    incl edge_count(%rip)               # Increment edge count

 
