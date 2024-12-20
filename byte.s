.section .data
BYTE_BUFFER: .space 256      # Temporary buffer for byte operations (256 bytes)

.section .text
.global read_byte
.global write_byte
.global copy_byte
.global compare_byte

# Read a single byte from memory
# Input: %rdi = address
# Output: %al = byte at address
read_byte:
    movb (%rdi), %al         # Read the byte from memory into %al
    ret

# Write a single byte to memory
# Input: %rdi = address, %sil = byte value
write_byte:
    movb %sil, (%rdi)        # Write the byte value to the address
    ret

# Copy a single byte from source to destination
# Input: %rdi = source address, %rsi = destination address
copy_byte:
    movb (%rdi), %al         # Read the byte from source
    movb %al, (%rsi)         # Write the byte to destination
    ret

# Compare two bytes
# Input: %rdi = address 1, %rsi = address 2
# Output: %al = 0 if equal, 1 if not equal
compare_byte:
    movb (%rdi), %al         # Load byte from address 1
    cmpb (%rsi), %al         # Compare with byte at address 2
    sete %al                 # Set %al to 1 if not equal, 0 if equal
    ret
