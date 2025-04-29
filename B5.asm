;5. Viết chương trình hợp ngữ Assembly cho phép nhập 1 chuỗi ký tự, in ra màn hình chuỗi ký tự đó theo dạng viết hoa và viết thường.								

.MODEL SMALL
.STACK 100H
.DATA
    str DB 256 dup('$') ;khoi tao chuoi str
    op1 DB "Nhap chuoi ky tu: $"
    op2 DB 13,10,"Chuyen thanh in thuong: $"
    op3 DB 13,10,"Chuyen thanh in hoa: $"   
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX ;khoi tao thanh ghi ds
     
    ; ham ngat loai 9 in 1 xau ky tu
    MOV AH, 9   
    LEA DX, op1 
    INT 21H 
    
    ; ham ngat loai 10 nhap 1 xau ky tu 
    MOV AH, 10
    LEA DX, str
    INT 21H  
    
    ; In thong bao 1
    MOV AH, 9 
    LEA DX, op2
    INT 21H
    CALL LOWER  ;hien xau str chu thuong
    
    ; In chuoi in hoa:
    MOV AH, 9
    LEA DX, op3 ;hien thong bao op3
    INT 21H
    CALL UPPER  
    
    MOV AH, 4ch
    INT 21H
MAIN ENDP 

LOWER PROC  
    ; dung thanh ghi SI tro toi str[2] 
    ; thanh ghi SI dung de doc du lieu cua chuoi/mang tu nguon
    LEA SI, str + 2  
    
LAP1:  ;1 xau : kiem tra tung ky tu mot 
    MOV DL, [SI]   ; gan dia chi tu o nho duoc tro boi SI sang thanh ghi DL
    CMP DL, 13     ; compare voi ky tu Enter (ket thuc chuoi)
    JE EXIT1       ; jump equal (nhay neu bang)
    CMP DL, 'A'    ; compare
    JL IN1         ; jump less (nhay neu nho hon)
    CMP DL, 'Z'    ; compare
    JG IN1         ; jump greater (nhay neu lon hon)
    ADD DL, 32     ; chuyen ky tu hoa thanh thuong
IN1: 
    ; ham ngat loai 2 in ky tu 
    MOV AH, 2 
    INT 21H  
    INC SI         ; tang con tro len 1 don vi   
    JMP LAP1       ; jump not equal (nhay neu khong bang)
EXIT1:
    RET           ; return
LOWER ENDP     

UPPER PROC
    LEA SI, str + 2
LAP2:
    MOV DL, [SI]
    CMP DL, 13    ; compare voi ky tu Enter (ket thuc chuoi)
    JE EXIT2      ; jump equal (nhay neu bang)
    CMP DL, 'a'
    JL IN2
    CMP DL, 'z'
    JG IN2
    SUB DL, 32    ; chuyen ky tu thuong thanh ky tu hoa
IN2:
    MOV AH, 2
    INT 21H
    INC SI
    JMP LAP2
EXIT2:
    RET
UPPER ENDP

END 
