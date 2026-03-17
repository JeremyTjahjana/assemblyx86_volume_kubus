section .data
    result db "Volume kubus adalah: ", 0
    newline db 10, 0
    
section .bss
    input resb 10
    buffer resb 12
    
section .text
    global _start

_start:
    ; Baca input dari user 
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, input      ; buffer untuk input
    mov rdx, 10         ; maximum bytes to read
    syscall
    
    ; Konversi string ke integer
    mov rsi, input
    xor rax, rax
    xor rbx, rbx
    
convert_input:
    mov bl, [rsi]
    cmp bl, 10          ; cek newline
    je hitung_volume
    cmp bl, 0           ; cek null terminator
    je hitung_volume
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rsi
    jmp convert_input
    
hitung_volume:
    ; Hitung volume kubus (sisi^3)
    mov rbx, rax        ; simpan sisi
    mul rbx             ; sisi * sisi
    mul rbx             ; (sisi^2) * sisi = sisi^3
    
    ; Simpan hasil volume
    push rax
    
    ; Tampilkan teks hasil
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, result     ; "Volume kubus adalah: "
    mov rdx, 20         ; panjang teks
    syscall
    
    ; Ambil kembali hasil volume
    pop rax
    
    ; Tampilkan angka volume
    call print_number
    
    ; Tampilkan newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Keluar program
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; return 0
    syscall

; Fungsi untuk mencetak angka
print_number:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    
    mov rcx, 10
    mov rdi, buffer + 11
    mov byte [rdi], 0   ; null terminator
    
    ; Handle kasus angka 0
    test rax, rax
    jnz .convert
    mov byte [rdi-1], '0'
    dec rdi
    jmp .print
    
.convert:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .convert
    
.print:
    ; Hitung panjang string
    mov rsi, rdi
    mov rdx, buffer + 11
    sub rdx, rsi
    
    ; Tampilkan angka
    mov rax, 1
    mov rdi, 1
    syscall
    
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret