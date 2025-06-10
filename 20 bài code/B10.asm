.model small
.stack 100h
.data
    op1 DB "Nhap chuoi ky tu: $"
    op2 DB 13,10,"Do dai chuoi: $"
    str DB 50 dup('$')
.code
Main proc
    MOV AX , @data
    MOV DS , AX

    mov ah , 9
    lea dx , op1
    int 21h

    lea dx , str
    mov ah , 10
    int 21h

    mov ah , 9
    lea dx , op2
    int 21h

    
    mov al , [str+1]
    mov ah , 0       
    mov bl , 10
    div bl              

    push ax             
    cmp al, 0           
    je donvi       

    mov dl, al
    add dl, '0'
    mov ah, 2
    int 21h

donvi:
    pop ax              
    mov dl, ah          
    add dl, '0'
    mov ah, 2
    int 21h
    mov ah , 4ch
    int 21h

main endp
end
