.MODEL SMALL
.STACK 100H
.DATA     
    op1   DB "Nhap cac so nguyen cach nhau boi dau cach : $"
    op2   DB 13,10,"Tong cac so la: $"
    str   DB 256 DUP('$') 
    sum   DW 0            ; Tong cac so
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX         ; Khoi tao DS

    ; In op1 yeu cau nhap so
    MOV AH, 9
    LEA DX, op1
    INT 21h

    ; Nhap chuoi so
    MOV AH, 10
    LEA DX, str        
    INT 21h
    
    ; ham xu ly bai toan
    CALL Tinhtong
    
    ; ham ket thuc chuong trinh
    MOV AH, 4CH
    INT 21h
MAIN ENDP

Tinhtong PROC         ; 12 34 56 
    LEA SI , str + 2  ; thanh SI tro toi vi tri bat dau chuoi str 
    MOV AX , 0        ; gan AX = 0 
    MOV BL , 10       ; he so nhan 
Cv:
    MOV DL , [SI]     ; '1'
    CMP DL , 20h      ; so sanh voi space
    JE Back          
    CMP DL , 13       ; so sanh voi Enter 
    JE  Print         
    MUL BL            ; AX = AX * 10  
    SUB DL , '0'      ; chuyen ky tu sang so  
    ADD AX , DX       ; AX = AX + DX            12 = 1*10 + 2  
    INC SI            ; sang chu so tiep theo
    JMP Cv     
Back:  
    INC SI            ; tang SI de bo qua dau space 
    ADD sum , AX      ; sum = sum + AX 
    MOV AX , 0        ; dat lai AX de sang so moi   
    JMP Cv 
        
Print:
     ADD sum , AX     ; + so cuoi cung vao sum 
     MOV AX , sum     ; gan gia tri cua sum cho AX
     MOV CX , 0       ; dat CX = 0 de su dung dem scs
     Lap1:
       MOV DX , 0
       DIV BX         ; AX = AX/BX 
       PUSH DX        ; luu so du vao stack
       INC CX         ; tang bien dem CX 
       CMP AX , 0     ; neu thuong AX = 0 thi dung lai 
       JNE Lap1       
       ; ham ngat loai 9 in op2
       MOV AH , 9 
       LEA DX , op2
       INT 21h 
     In1:
       POP DX         ; lay DX khoi stack
       ADD DL , '0'
       ; ham ngat loai 2 in ra tung ky tu
       MOV AH , 2
       INT 21H
       LOOP In1 
 RET
Tinhtong ENDP
END
