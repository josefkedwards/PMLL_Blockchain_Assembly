.section .data
# Define Words and Phrases
noun:     .asciz "cat"
verb:     .asciz "chases"
object:   .asciz "mouse"
article:  .asciz "The"
adjective: .asciz "quick"
sentence_buffer: .space 256   # Buffer to construct the sentence

# Newline for output
newline:  .asciz "\n"

.section .text
.global English_start          # Entry point for English runtime
.global construct_sentence     # Constructs an English sentence
.global print_sentence         # Outputs the constructed sentence

English_start:
    pushq %rbp                 # Save base pointer
    movq %rsp, %rbp            # Set stack pointer for the function

    # Call functions to construct and print a sentence
    call construct_sentence
    call print_sentence

    # Exit gracefully
    movq $60, %rax             # System call for exit
    xorq %rdi, %rdi            # Exit code 0
    syscall                    # Exit system call

# Function: construct_sentence
# Constructs a simple sentence like "The quick cat chases the mouse."
construct_sentence:
    pushq %rbp
    movq %rsp, %rbp

    # Initialize buffer pointer
    lea sentence_buffer(%rip), %rdi

    # Add article
    lea article(%rip), %rsi
    call append_word

    # Add space
    movb $32, (%rdi)
    incq %rdi

    # Add adjective
    lea adjective(%rip), %rsi
    call append_word

    # Add space
    movb $32, (%rdi)
    incq %rdi

    # Add noun
    lea noun(%rip), %rsi
    call append_word

    # Add space
    movb $32, (%rdi)
    incq %rdi

    # Add verb
    lea verb(%rip), %rsi
    call append_word

    # Add space
    movb $32, (%rdi)
    incq %rdi

    # Add object
    lea object(%rip), %rsi
    call append_word

    # Add newline
    lea newline(%rip), %rsi
    call append_word

    popq %rbp
    ret

# Function: append_word
# Appends a word (null-terminated string) to the buffer
append_word:
    pushq %rbp
    movq %rsp, %rbp

    # RDI: buffer pointer
    # RSI: word pointer
.loop:
    movb (%rsi), %al            # Load character from word
    testb %al, %al              # Check for null terminator
    je .done                    # Exit loop if null terminator
    movb %al, (%rdi)            # Copy character to buffer
    incq %rdi                   # Advance buffer pointer
    incq %rsi                   # Advance word pointer
    jmp .loop                   # Repeat for the next character

.done:
    popq %rbp
    ret

# Function: print_sentence
# Prints the constructed sentence
print_sentence:
    pushq %rbp
    movq %rsp, %rbp

    lea sentence_buffer(%rip), %rdi  # Load buffer pointer
    call write_string               # Call write_string from C.s

    popq %rbp
    ret
