section .data
    msg_init:  db "ULA Encoding Driver Initialized", 0
    msg_done:  db "ULA Encoding Completed", 0
    input_file: db "input.txt", 0
    output_file: db "ULA.ulac", 0
    ulac_header: db "ULAC", 0x09, 0x00  ; ULAC Magic Header + UTF-9 Version

    ; ASCII Table (0-127)
    ascii_table: db  0x00, 0x7F, 0x20, 0x21, 0x30, 0x39, 0x41, 0x5A, 0x61, 0x7A

    ; Latin-1 Table (128-255)
    latin1_table: db  0xA0, 0xFF, 0xC0, 0xD6, 0xD8, 0xF6, 0xF8, 0xFF

    ; UTF-8 Ranges (Multi-byte Encoding)
    utf8_table: db 0x00, 0x7F, 0xC2, 0xDF, 0xE0, 0xEF, 0xF0, 0xF4

section .bss
    ula_buffer: resb 8192  ; 8KB buffer for encoding operations
    input_buffer: resb 8192 ; 8KB input buffer
    file_descriptor: resq 1

section .text
global _start

_start:
    ; Print Initialization Message
    mov rdi, msg_init
    call print_string

    ; Open Input File
    mov rdi, input_file
    call open_file
    mov [file_descriptor], rax  ; Store file descriptor

    ; Read Input File
    mov rdi, [file_descriptor]
    mov rsi, input_buffer
    mov rdx, 8192
    call read_file

    ; Encode Input Data into ULA Format
    mov rdi, input_buffer
    mov rsi, ula_buffer
    call ula_encode

    ; Save Encoded Data to ULA Container File
    mov rdi, output_file
    call save_ula

    ; Print Completion Message
    mov rdi, msg_done
    call print_string

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

; ----------------------------------------------
; Function: ula_encode
; Converts ASCII, Latin-1, and UTF-8 to UTF-9
ula_encode:
    push rbp
    mov rbp, rsp
    mov rcx, 0

.encode_loop:
    mov al, [rdi + rcx]   ; Load input character
    test al, al
    jz .done

    cmp al, 0x7F
    jle .store_ascii       ; ASCII Character

    cmp al, 0xA0
    jge .store_latin1      ; Latin-1 Character

    ; Handle Multi-byte Unicode (UTF-8 Extension)
    jmp .next

.store_ascii:
    mov [rsi + rcx], al
    jmp .next

.store_latin1:
    mov [rsi + rcx], al
    jmp .next

.next:
    inc rcx
    jmp .encode_loop

.done:
    pop rbp
    ret

; ----------------------------------------------
; Function: save_ula
; Saves UTF-9 encoded data to `.ulac` container
save_ula:
    push rbp
    mov rbp, rsp

    ; Open File
    mov rdi, output_file
    call open_file
    mov rbx, rax   ; Store file descriptor

    ; Write ULAC Header
    mov rdi, rbx
    mov rsi, ulac_header
    mov rdx, 6
    call write_file

    ; Write Encoded Data
    mov rdi, rbx
    mov rsi, ula_buffer
    mov rdx, 8192
    call write_file

    pop rbp
    ret

; ----------------------------------------------
; Function: print_string
print_string:
    mov rax, 1
    mov rdi, 1
    mov rsi, rdi
    mov rdx, 64
    syscall
    ret




