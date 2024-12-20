.section .text
.global string_length
.global string_concat
.global string_compare
.global string_slice

# string_length: Calculate the length of a null-terminated string
# Arguments:
#   rdi: Pointer to the null-terminated string
# Returns:
#   rax: Length of the string (number of characters, excluding null terminator)
string_length:
    pushq %rbp
    movq %rsp, %rbp

    xorq %rax, %rax            # Initialize length counter
.loop:
    movb (%rdi, %rax), %al     # Load current character
    testb %al, %al             # Check if null terminator
    je .done                   # Exit loop if null terminator found
    incq %rax                  # Increment length counter
    jmp .loop                  # Continue to next character

.done:
    popq %rbp
    ret

# string_concat: Concatenate two strings
# Arguments:
#   rdi: Pointer to the destination string
#   rsi: Pointer to the source string
# Returns:
#   rdi: Pointer to the destination string
string_concat:
    pushq %rbp
    movq %rsp, %rbp

    call string_length         # Get length of destination string
    movq %rax, %rcx            # Store length in rcx
    addq %rcx, %rdi            # Move destination pointer to end of string

.copy:
    movb (%rsi), %al           # Load character from source
    movb %al, (%rdi)           # Write character to destination
    testb %al, %al             # Check if null terminator
    je .done                   # Exit if null terminator found
    incq %rsi                  # Advance source pointer
    incq %rdi                  # Advance destination pointer
    jmp .copy                  # Repeat for next character

.done:
    popq %rbp
    ret

# string_compare: Compare two strings lexicographically
# Arguments:
#   rdi: Pointer to the first string
#   rsi: Pointer to the second string
# Returns:
#   rax: 0 if strings are equal, negative if first < second, positive if first > second
string_compare:
    pushq %rbp
    movq %rsp, %rbp

.compare:
    movb (%rdi), %al           # Load character from first string
    movb (%rsi), %bl           # Load character from second string
    subb %bl, %al              # Compare characters
    jne .done                  # Exit if characters differ
    testb %al, %al             # Check if null terminator
    je .done                   # Exit if both strings end
    incq %rdi                  # Advance first string pointer
    incq %rsi                  # Advance second string pointer
    jmp .compare               # Repeat for next character

.done:
    movsbl %al, %rax           # Zero-extend comparison result to rax
    popq %rbp
    ret

# string_slice: Extract a substring from a string
# Arguments:
#   rdi: Pointer to the source string
#   rsi: Start index (0-based)
#   rdx: Length of substring
#   rcx: Pointer to the destination buffer
# Returns:
#   rcx: Pointer to the destination buffer
string_slice:
    pushq %rbp
    movq %rsp, %rbp

    movq %rsi, %rax            # Start index
    addq %rdi, %rax            # Compute source pointer offset

.copy:
    cmpq $0, %rdx              # Check if length is zero
    je .done                   # Exit if no more characters to copy
    movb (%rax), %al           # Load character from source
    movb %al, (%rcx)           # Write character to destination
    incq %rax                  # Advance source pointer
    incq %rcx                  # Advance destination pointer
    decq %rdx                  # Decrement length
    jmp .copy                  # Repeat for next character

.done:
    movb $0, (%rcx)            # Null-terminate the substring
    popq %rbp
    ret
