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
    
    mov ah , 10 
    lea dx , str 
    int 21h 
        
    mov ah , 9
    lea dx , op2
    int 21h  
    
    mov dl , [str+1] 
    add dl , '0' 
    mov ah , 2 
    int 21h 
    
    mov ah , 4ch
    int 21h 
    
main endp
end
