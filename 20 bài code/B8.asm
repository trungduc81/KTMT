.model small
.stack 100h
.data
    op1 DB "Nhap so he 10 : $"
    op2 DB 13,10,"Chuyen sang he 16 : $"
    str DB  6 dup('$') 
.code
Main proc
    MOV AX , @data
    MOV DS , AX
    
    mov ax , '#'
    push ax             ; stack = {#}

    ; In chuoi op1
    lea dx , op1
    mov ah , 9
    int 21h
    
    ; Nhap so duoi dang chuoi        
    lea dx , str
    mov ah , 10
    int 21h
    
    ; Chuyen chuoi thanh so
    mov cl , [str+1]    ; So ky tu cua chuoi
    mov ch, 0          
    lea si , str+2      ; Tro den ky tu dau tien
    mov ax , 0
    mov bx , 10
    
cv:
    mul bx              ; ax = ax * 10
    mov dl, [si]
    sub dl , '0'         
    add ax , dx         ; ax = ax + dx
    inc si
    loop cv
    
    ; Chuyen so thap phan sang he 16
    mov cx , 16         ; He so chia la 16
    
hex:   
    mov dx , 0 
    div cx              ; Chia DX:AX cho CX. Thuong trong AX, du trong DX
    push dx             ; Day so du vao stack
    cmp ax , 0
    jne hex             ; Tiep tuc lap neu thuong AX khac 0
    
    ; In thong bao ket qua
    mov ah , 9
    lea dx , op2
    int 21h
    
Print:
    pop dx              ; Lay so du tu stack vao DX (so du nam trong DL)
    cmp dx, '#'
    je finish
    cmp dl, 10
    jl so           ; Neu nho hon hoac bang 9 thi la so
    
chu:                 ; Truong hop la chu (A-F)
    add dl, 'A' - 10    ; Chuyen 10 thanh A
    jmp inkytu
    
so:                  ; Truong hop la so (0-9)
    add dl, '0'         ; chuyen thanh ky tu 

inkytu:
    mov ah, 2           
    int 21h             ; In ky tu trong DL
    jmp Print
    
finish:
    mov ah , 4ch
    int 21h
main endp
end
