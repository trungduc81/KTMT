; 3. Viết chương trình hợp ngữ Assembly cho phép nhập 1 chuỗi ký tự và in ra màn hình chuỗi ký tự đó.						

.Model Small 
.Stack 100 
.data
    op1 DB "Nhap 1 chuoi ky tu : $"              ; nhan op1 
    op2 DB 13,10,"Chuoi ky tu vua nhap la : $"   ; nhan op2    
    str DB 100 dup('$')                          ; chuoi str chua 100 ky tu 

.code
MAIN PROC  
    
    MOV AX , @data     ; khoi dau thanh ghi DS
    MOV DS, AX         ; tro thanh ghi DS ve dau doan data              
    
    ; ham ngat AH loai 9 de in ra xau ky tu 
    MOV AH , 9         
    
    ; in ra nhan op1 
    LEA DX , op1       
    INT 21h 
    
    MOV AH , 10        ; ham ngat AH loai 10 de nhap 1 chuoi ky tu 
    LEA DX , str       ; tro den dia chi dau str 
    INT 21h            
    
    ; in nhan op2 
    MOV AH , 9 
    LEA DX , op2       
    INT 21h      
    
    LEA DX , str + 2  ; do str[0] luu kich thuoc toi da , str[1] luu kich thuoc thuc 
    INT 21h           ; in chuoi vua nhap 
    
    ; ham ket thuc chuong trinh 
    MOV AH , 4CH      
    INT 21h   
    
MAIN ENDP 
END
