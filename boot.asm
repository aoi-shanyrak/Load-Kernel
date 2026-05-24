[BITS 16]
[ORG 0x7C00]


%define SECTOR_COUNT     2
%define KERNEL_LOAD_ADDR 0x7E00


start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti


load_kernel:
    mov ah, 0x02
    mov al, SECTOR_COUNT
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, KERNEL_LOAD_ADDR
    int 0x13
    jc  disk_error
    
hello:
    mov si, hello_msg
    call    print_string

end:
    jmp end


disk_error:
    mov si, disk_error_msg
    call    print_string
    jmp     end


print_string:
    lodsb
    test  al, al
    jz    .done
    mov   ah, 0x0E
    int   0x10
    jmp   print_string
.done:
    ret


disk_error_msg:
    db 'Disk read error!', 0x0A, 0x0D, 0

hello_msg: 
    db 'Hello, World!', 0x0A, 0x0D, 0


times 510-($-$$) db 0
dw 0xAA55

