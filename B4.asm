;4. Viết chương trình hợp ngữ Assembly cho phép nhập 1 ký tự viết thường và in ra màn hình chữ hoa của ký tự đó.							

.Model Small 
.Stack 100 
.data
    op1 DB "Nhap 1 ky tu viet thuong : $"          ; nhan op1 
    op2 DB 13,10,"Ky tu chuyen sang chu hoa : $"   ; nhan op2    
    tmp DB ?  

.code
MAIN PROC  
    
    MOV AX , @data     ; khoi dau thanh ghi DS
    MOV DS, AX         ; tro thanh ghi DS ve dau doan data              
    
    ; ham ngat AH loai 9 de in ra xau ky tu 
    MOV AH , 9         
    
    ; in ra nhan op1 
    LEA DX , op1       
    INT 21h 
    
    MOV AH , 1        ; ham ngat AH loai 1 de nhap 1  ky tu  
    
    ; nhap 1 ky tu         
    INT 21h 
    MOV tmp , AL      ; gan gia tri cua ky tu dang luu trong AL cho bien tmp      
    
    ; in nhan op2 
    MOV AH , 9 
    LEA DX , op2       
    INT 21h      
    
    SUB tmp , 32      ;  in hoa kem  in thuong 32 dv trong he thap phan nen ta tru di 32
    
    ; ham ngat AH loai 2 in 1 ky tu
    MOV AH , 2 
    MOV DL , tmp    
    INT 21h 
    
    ; ham ket thuc chuong trinh 
    MOV AH , 4CH      
    INT 21h   
    
MAIN ENDP 
END
