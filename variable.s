.section .data
char_var: .byte 0              # Character variable (1 byte)
int_var: .long 0               # Integer variable (4 bytes)
float_var: .long 0x00000000    # Float variable (4 bytes, IEEE 754)
double_var: .quad 0x0000000000000000 # Double variable (8 bytes, IEEE 754)
void_var:                     # Void, represented as an absence of value

.section .text
.global set_variables
.global get_variables

# Function to set values to variables
set_variables:
    pushq %rbp
    movq %rsp, %rbp

    # Set char_var
    movb $65, char_var(%rip)   # ASCII 'A'

    # Set int_var
    movl $12345, int_var(%rip) # Example integer value

    # Set float_var
    movl $0x3F800000, float_var(%rip) # 1.0 in IEEE 754 single precision

    # Set double_var
    movq $0x3FF0000000000000, double_var(%rip) # 1.0 in IEEE 754 double precision

    popq %rbp
    ret

# Function to retrieve and use variable values
get_variables:
    pushq %rbp
    movq %rsp, %rbp

    # Get char_var
    movb char_var(%rip), %al  # Load char_var into %al
    call print_char           # Example usage (print)

    # Get int_var
    movl int_var(%rip), %eax  # Load int_var into %eax
    call print_int            # Example usage (print)

    # Get float_var
    movl float_var(%rip), %eax # Load float_var into %eax
    call print_float           # Example usage (print)

    # Get double_var
    movq double_var(%rip), %rax # Load double_var into %rax
    call print_double           # Example usage (print)

    popq %rbp
    ret
