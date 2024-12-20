.section .data
MAX_NODES: .int 1024               # Maximum nodes allowed
EDGE_STR_SIZE: .int 256            # Maximum edge string length

.section .bss
graph_structure: .resb 128         # Placeholder for graph structure (pointer storage)

.section .text
.global create_graph
.global write_node
.global connect_nodes
.global destroy_graph

# Create a graph
create_graph:
    # Input: %edi = size, %rsi = graph_type (pointer to string)
    push %rbp                       # Save base pointer
    mov %rsp, %rbp                  # Set stack frame

    mov $128, %rdi                  # Allocate memory for Graph structure
    call malloc
    mov %rax, graph_structure       # Store pointer to the allocated Graph structure

    # Initialize Graph structure
    movl $0, (%rax)                 # node_count = 0
    movl $0, 4(%rax)                # edge_count = 0

    mov %rsi, 8(%rax)               # type = strdup(graph_type)
    call strdup
    mov %rax, 8(%rax)

    # Allocate memory for nodes and edges
    mov %edi, %esi                  # size -> second arg
    shl $3, %esi                    # size * sizeof(char *)
    call malloc
    mov %rax, 12(%rax)              # nodes = malloc(size * sizeof(char *))

    mov %edi, %esi                  # size -> second arg
    shl $3, %esi                    # size * sizeof(char *)
    call malloc
    mov %rax, 16(%rax)              # edges = malloc(size * sizeof(char *))

    leave
    ret                             # Return Graph pointer in %rax

# Write a node to the graph
write_node:
    # Input: %rdi = graph, %rsi = node_data
    push %rbp
    mov %rsp, %rbp

    mov (%rdi), %ecx                # Load node_count
    mov MAX_NODES, %edx
    cmpl %edx, %ecx                 # Compare node_count with MAX_NODES
    jge node_error_capacity         # If exceeded, jump to error

    # Allocate memory for node_data
    mov %rsi, %rdi                  # Copy node_data pointer
    call strdup
    mov %rax, (%rdi, %rcx, 8)       # nodes[node_count] = strdup(node_data)

    incl %ecx                       # Increment node_count
    mov %ecx, (%rdi)                # Save back to graph->node_count

    leave
    ret

node_error_capacity:
    # Print error message
    mov $error_msg_capacity, %rdi
    call printf
    xor %eax, %eax                  # Return -1
    leave
    ret

# Connect two nodes with an edge
connect_nodes:
    # Input: %rdi = graph, %esi = node1_idx, %edx = node2_idx
    push %rbp
    mov %rsp, %rbp

    # Validate indices
    mov (%rdi), %ecx                # Load node_count
    cmpl %esi, %ecx
    jl invalid_node_indices
    cmpl %edx, %ecx
    jl invalid_node_indices

    # Create edge string
    mov $EDGE_STR_SIZE, %rdi        # Allocate memory for edge string
    call malloc
    mov %rax, %r8                   # Save pointer to edge string

    # Format: "node1 -> node2"
    mov (%rdi, %esi, 8), %rsi       # Load nodes[node1_idx]
    mov (%rdi, %edx, 8), %rdx       # Load nodes[node2_idx]
    mov $edge_format, %rdi
    call snprintf

    # Store edge in graph->edges
    mov (%rdi, %rcx, 8), %r9        # Load edges[edge_count]
    mov %r8, (%r9)
    incl %ecx                       # Increment edge_count
    mov %ec
