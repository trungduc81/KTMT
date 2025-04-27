 ; 2. Viết chương trình hợp ngữ Assembly cho phép nhập 1 ký tự và in ra màn hình ký tự đó.	

.Model Small 
.Stack 100 
.data
    op1 DB "Nhap 1 ky tu : $"              ; nhan op1 
    op2 DB 13,10,"Ky tu vua nhap la : $"   ; nhan op2    
    tmp DB ? 

.code
MAIN PROC  
    
    MOV AX , @data     ; khoi dau thanh ghi DS
    MOV DS, AX         ; tro thanh ghi DS ve dau doan data              
    
    MOV AH , 9         ; ham ngat AH loai 9 de in ra xau ky tu 
    
    LEA DX , op1       ; in ra nhan op1 
    INT 21h 
    
    MOV AH , 1         ; ham ngat AH loai 1 de nhap 1 ky tu tu ban phim 
    INT 21h            ; luc nay ky tu duoc luu o thanh ghi AL
    MOV tmp , AL        ; gan gia tri dang luu o AL sang bien tmp     
    
    MOV AH , 9         ; ham ngat loai 9 in ra 1 xau ky tu 
    
    LEA DX , op2       ; in ra nhan op2 
    INT 21h  
    
    MOV AH , 2         ; ham ngat AH loai 2 de in ra 1 ky tu 
    
    MOV DL , tmp       ; lay du lieu tu thanh ghi AL chuyen sang thanh ghi DL 
    INT 21h            ; in ra ky tu   
    
    MOV AH , 4CH       ; ham ngat chuong trinh 
    INT 21h 
    
MAIN ENDP 
END
