; 7. Viet chuong trinh Asssembly chuyen doi 1 so tu he 10 sang he nhi phan
.Model Small
.Stack 100
.Data  
    op1 DB 10,13, 'So da nhap dang nhi phan: $'
    str DB 5 dup ('$'); nhap vao 1 chuoi toi da 5 ky tu
.Code
MAIN PROC
    MOV AX, @Data
    MOV DS, AX         ;khoi tao thanh ghi ds
    
    MOV AX, '#'   
    PUSH AX            ;push dau #  vao trong stack      
    
    ;Nhap so dang chuoi:    
    MOV AH, 10
    LEA DX, str   
    INT 21h    
    
    ;Chuyen chuoi thanh so:
    MOV CL, [str+1]    ; lay so ky tu cua chuoi 
    LEA SI, str+2      ; tro den dia chi cua ky tu dau tien cua chuoi str
    MOV AX, 0          ; AX=0 
    MOV BX, 10         ; BX=10 la he so nhan 
    
    Decimal:
        ; chuyen chuoi thanh so     123;0*10+1 1*10+2; 12*10+3
        MUL BX         ; AX = AX * 10
        MOV DL, [SI]   ; gan DL bang ky tu ma SI dang tro toi
        SUB DL, '0'    ; Chuyen ky tu thanh so
        ADD AX, DX     ; AX = AX + DX
        INC SI         ; Tang SI len 1 don vi
        LOOP Decimal 
        
    ;Chuyen thanh so nhi phan: 10- 1010
    MOV CL, 2 ; he so chia  
    
    Binary: 
        ;chuyen so thap phan sang nhi phan va day cac so vao stack
        MOV AH, 0  ; dat phan du = 0 qua moi lan lap
        DIV CL     ; AX = AX / 2 
        PUSH AX    ; day AX vao stack 
        CMP AL, 0  ; so sanh thuong khac 0 thi tiep tuc chia
        JNE Binary  ; nhay neu khong bang 
        
    ; ham ngat loai 9 in op1
    MOV AH, 9
    LEA DX, op1   
    INT 21h 
    
    MOV AH, 2
    Print:
        POP DX  ;lay tung phan tu trong ngan xep
        CMP DX, '#'
        JE Finish  ;jump equal ( nhay neu bang )
        MOV DL, DH  ;lay duoc so tu ngan xep   :1 0 1 0
        ADD DL, '0' ; chuyen tu so sang ky tu
        INT 21h     ; in ra man hinh 
        JMP Print
    Finish:
        MOV AH, 4Ch
        INT 21h        
MAIN ENDP
END
