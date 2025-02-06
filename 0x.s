MOV AX, 0x0  ; AX points to NULL (uninitialized state)
CMP AX, 0x0  ; Check if AX is still NULL
JZ HALT      ; If NULL, halt the CPU
