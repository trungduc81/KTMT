;(asembly) Hiển thị lời chào Tiếng Anh và Tiếng Việt trên emu8086

.Model Small ; Kieu kich thuoc bo nho Small
.Stack 100   ; Kich thuoc ngan xep 100 bytes 
.Data  ; du lieu ma chuong trinh su dung o ben duoi 
     CRLF   DB 13,10,'$' ; ma ASCII 13 la lui dau dong , 10 la xuong dong  
     ChaoVN DB "Xin chao!$" ; nhan ChaoVN cho chuoi Xin chao 
     ChaoE  DB "Hello!$" ; nhan ChaoE cho chuoi Hello! 
.Code   
MAIN PROC ; thu tuc chinh      
    
    ; khoi tao DS 
    MOV AX , @Data     ; khoi dau thanh ghi DS
    MOV DS , AX        ; tro thanh ghi DS ve dau doan Data   
    
    MOV AH , 9 ; ham 9 cua ngat 21 in 1 chuoi ky tu 
    
    LEA DX , ChaoE    ; in chuoi Xin chao! 
    INT 21H            
    
    LEA DX , CRLF      ; lui dau dong roi xuong dong 
    INT 21H     
    
    LEA DX , ChaoVN     ; in chuoi Hello! 
    INT 21H 
    
    MOV AH , 4CH       ; ham ngat chuong trinh 
    INT 21H 
    
MAIN ENDP 
END    
    
