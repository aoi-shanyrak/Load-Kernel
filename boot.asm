[BITS 16]
[ORG 0x7C00]


start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    
hello:
    mov si, hello_msg
    call print_string


end:
    jmp $


print_string:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret


hello_msg: 
    db 'Hello, World!', 0x0A, 0x0D, 0


times 510-($-$$) db 0
dw 0xAA55

