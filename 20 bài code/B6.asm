; 6. Viết chương trình hợp ngữ Assembly cho phép nhập một chuỗi các ký tự kết thúc bởi "# "và yêu cầu in ra màn hình chuỗi ký tự đó theo thứ tự ngược lại.								

.MODEL SMALL
.STACK 100H
.DATA
    str DB 256 DUP('$') 
    op1 DB "Nhap chuoi ket thuc bang dau # : $" 
    op2 DB 13,10,"Output : $"
.CODE
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX 
    
    ; In op1
    MOV AH, 9 
    LEA DX, op1 
    INT 21H 
    
    ; nhap chuoi bang ham ngat loai 10
    MOV AH, 10 
    LEA DX, str 
    INT 21H  
    
    CALL REVERSE
    
    MOV AH, 4CH 
    INT 21H 
MAIN ENDP

REVERSE PROC
    LEA SI, str + 2 ; Tro thanh ghi SI toi str[2]
    
Lap1:
    MOV DL, [SI] 
    ; nhay toi nhan Demo1 neu toi duoc ky tu #
    CMP DL, '#'     
    JE  Demo1
    INC SI
    JMP Lap1
    
Demo1:
    ; In thông báo op2
    MOV AH, 9 
    LEA DX, op2 
    INT 21H 
    
In1:
    CMP SI, OFFSET str + 1  ; Kiem tra xem da ve str[1] hay chua 
    JE  EXIT                ; Neu da ve str[1] thi thoat 
    
    ; In ký tu
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    
    DEC SI          ; Lùi con tro
    JMP In1
    
EXIT: 
    RET 
REVERSE ENDP
END 
