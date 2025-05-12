; Game Tic Tac Toe 
; Created by Tran Duc Trung 
.MODEL small           ; che do bo nho small
.STACK 100h           ; kich thuoc ngan xep 100
.DATA
      CRLF DB 13,10,"$"  ; dau xuong dong
      space DB 32,"$" ; dau cach 
      pipe DB " | $"  ; dau ke doc    
      line DB 13,10,"-----------",13,10,32,"$"   ;  
      
      arr DB 32 , 32 , 32        
          DB 32 , 32 , 32
          DB 32 , 32 , 32   
             
      ; chuoi in ra ten game    
     tictac DB "---------------------------",13,10         
           DB "|       TIC TAC TOE       |",13,10 
           DB "---------------------------",13,10,13,10
           DB "Player 1  : X   Player 2 : O",13,10,13,10,"$"   
              
      ; chuoi in ra luot cua 2 nguoi choi       
      play1 DB 13,10,13,10,"Player 1 turn : ",13,10,13,10,"$"  
      play2 DB 13,10,13,10,"Player 2 turn : ",13,10,13,10,"$" 
      
      ;chuoi in ra cau lenh nhap nuoc di 
      pos DB "Enter your move (1-9) : $"     
      
      ; chuoi in ra nguoi chien thang
      winner1 DB 13,10,13,10,"Player 1 is winner !$" 
      winner2 DB 13,10,13,10,"Player 2 is winner !$"
      draw    DB 13,10,13,10,"The game is a draw !$"   
      
      ; chuoi thong bao khi nhap input sai 
      invalid DB 13,10,"Invalid input! Please enter 1-9.",13,10,"$" 
      ocp DB 13,10,"This cell is already occupied! Please choose another one.",13,10,"$"
      
      ; cac bien de dieu khien tro choi 
      turn DB 1 ; danh dau luot choi 
      endg DB 0  ; bien danh dau trang thai ket thuc game
      char DB 88 ; ky tu cua luot choi ( bat dau = X co ma ASCII 88 )       

.CODE
MAIN PROC    
    ; khoi tao thanh ghi ds
    MOV AX , @data
    MOV DS , AX    
    
    Call print_title     ; in tieu de     
    
    MOV SI , OFFSET arr  ; tro SI toi mang de bat dau tro choi 
    MOV CX , 9           ; lap 9 lan vi so luong luot choi toi da la 9 
 
 ; vong lap luan phien luot choi    
 game_loop:
    MOV AL , turn 
    CMP AL , 1           ; neu turn = 1 thi la luot cua player 1 
    JE call_player_1     
    call player_2        ; neu turn != 1 thi goi ham con player_2
    JMP done             ; nhay toi label done de goi map de in ban co    
    
 call_player_1:
    call player_1 
    
 done:
    call map 

; nhap nuoc di    
input:
    MOV AH , 9              
    LEA DX , CRLF        ; xuong dong
    INT 21h
    LEA DX , pos         ; in cau lenh yeu cau nhap nuoc di
    INT 21h     
    
    MOV AH , 1           ; ham cho phep nhap 1 ky tu 
    INT 21h 
    SUB AL , 48          ; chuyen ky tu so thanh gia tri so 
    CMP AL , 1           ; neu input khong nam trong khoang [1,9] 
    JL ivl
    CMP AL,9
    JG ivl               
    
    MOV BL , AL
    DEC BL               ; chi so cua mang = input -1 
    
    MOV AH , 9           ; xuong dong 
    LEA DX , CRLF
    INT 21h              
    
    MOV SI , OFFSET arr
    CMP [SI+BX] , 32     ; kiem tra xem da co nuoc di trong o hay chua
    JNE occupied         ; nhay toi label occupied neu nhu da co   
       
    MOV AL , turn
    CMP AL , 0           ; neu nhu turn = 0 thi nhay toi label if
    JE if
    MOV [SI+BX] , 'O'    ; danh dau la O 
    JMP continue
 
 if:
    MOV [SI+BX] , 'X'    ; danh dau la X     
    
 continue:  
    call check           ; kiem tra xem co nguoi thang khong 
    
    MOV AL , endg        ; endg = 1 thi co nguoi thang 
    CMP AL , 1    
    JE break 
    
    call check_draw      ; kiem tra xem co hoa khong
    
    MOV AL , endg        ; endg = 2 thi hoa nhau 
    CMP AL , 2 
    JE break 
    
    loop game_loop       ; neu khong co nguoi thang hoac hoa , lap lai 
   
 ivl:
    MOV AH , 9           ; in thong bao nhap nuoc di khong hop le 
    LEA DX , invalid
    INT 21h
    jmp input            ; quay tro lai label input 
 
 break:                                                      
    ; ham ngat 4ch ket thuc chuong trinh
    MOV AH , 4ch 
    INT 21h 
MAIN ENDP

; ham print_title de in tieu de game
print_title PROC  
    MOV AX , @data
    MOV DS , AX
    ;ham ngat loai 9 de in ra tieu de
    MOV AH , 9 
    MOV DX , OFFSET tictac
    INT 21h 
    ret 
print_title ENDP    

;ham player_1 co tac dung chuan bi cho luot danh cua player 1
player_1 PROC
    MOV AX , @data
    MOV DS , AX  
    
    ; in chuoi play1 
    MOV AH , 9 
    LEA DX , play1
    INT 21h       
    
    MOV char , 88   ; dat char = 'X'   
    MOV turn , 0    ; doi gia tri turn de toi luot player 2
    ret
player_1 ENDP

;ham player_2 chuan bi cho luot danh cua player 2 
player_2 PROC 
    MOV AX , @data
    MOV DS , AX
    
    MOV AH,9
    LEA DX,play2
    INT 21h
    
    MOV char , 79 ; dat char = 'O'
    MOV turn , 1  
    ret
player_2 ENDP  

; ham map in ra trang thai ban co hien tai
map PROC
    MOV AX , @data
    MOV DS , AX
    
    MOV SI , OFFSET arr  ; tro toi ban co 
    
    MOV AH , 9 
    LEA DX , space     ; in dau cach 
    INT 21h       
    MOV DL , [SI]      ; in gia tri o dau tien 
    MOV AH , 2
    INT 21h        
    MOV AH , 9         ; in ke doc 
    LEA DX , pipe 
    INT 21h         
    MOV DL , [SI+1]    ; in gia tri o thu 2 
    MOV AH , 2 
    INT 21h            
    MOV AH , 9 
    LEA DX , pipe
    INT 21h
    MOV DL , [SI+2]    ; in gia tri o thu 3 
    MOV AH , 2 
    INT 21h
    MOV AH , 9         ; in dau gach ngang 
    LEA DX , line
    INT 21h
    MOV DL , [SI+3]    
    MOV AH , 2
    INT 21h
    MOV AH , 9 
    LEA DX , pipe
    INT 21h
    MOV DL , [SI+4]
    MOV AH , 2 
    INT 21h
    MOV AH , 9 
    LEA DX , pipe
    INT 21h
    MOV DL , [SI+5]
    MOV AH , 2
    INT 21h  
    MOV AH , 9
    LEA DX , line
    INT 21h 
    MOV DL , [SI+6]
    MOV AH , 2
    INT 21h
    MOV AH , 9 
    LEA DX , pipe
    INT 21h
    MOV DL , [SI+7]
    MOV AH , 2
    INT 21h
    MOV AH , 9 
    LEA DX , pipe
    INT 21h
    MOV DL , [SI+8]
    MOV AH , 2
    INT 21h   
    MOV AH , 9         ; in dau xuong dong 
    LEA DX , CRLF
    INT 21h         
    ret
map ENDP
    
; ham kiem tra xem co nguoi thang khong    
check PROC 
   MOV AX , @data
   MOV DS , AX
   MOV CX , 3    ; lap toi da 3 lan 
   MOV BX , 0    ; de cong chi so   
 
 ; kiem tra 3 hang 
 three_rows:
   MOV AL , char               ; AL = nuoc di hien tai 
   CMP [SI+BX] , 32            ; neu o dau tien trong , chuyen qua hang tiep theo luon
   JE next_rows          
   CMP [SI+BX] , AL            ; neu 1 o khac nuoc di hien tai , chuyen qua hang tiep
   JNE next_rows
   CMP [SI+BX+1] , AL
   JNE next_rows
   CMP [SI+BX+2] , AL
   JNE next_rows  
   call win
 next_rows:
   ADD BX , 3                  ; tang BX len 3 de chuyen xuong hang tiep
   loop three_rows             ; lap 
   MOV CX , 3                  ; dat lai cho lan ktra tiep theo 
   MOV BX , 0            
 three_columns:
   MOV AL , char
   CMP [SI+BX] , 32            ; neu o dau tien trong , chuyen qua cot tiep theo
   JE next_columns
   CMP [SI+BX] , AL            ; kiem tra cac o theo tung cot
   JNE next_columns
   CMP [SI+BX+3] , AL
   JNE next_columns
   CMP [SI+BX+6] , AL
   JNE next_columns
   call win
 next_columns:
   ADD BX , 1                  ; tang BX len 1 de chuyen sang cot tiep theo 
   loop three_columns
   
   CMP [SI] , 32               ; kiem tra duong cheo chinh 
   JE second_diag 
   CMP [SI] , AL
   JNE second_diag
   CMP [SI+4] , AL
   JNE second_diag
   CMP [SI+8] , AL
   JNE second_diag
   call win                    ; neu xuat hien duong cheo chinh , nhay toi label win 
 second_diag:
   CMP [SI+2] , 32
   JE exit 
   CMP [SI+2] , AL
   JNE exit
   CMP [SI+4] , AL
   JNE exit

   CMP [SI+6] , AL
   JNE exit
   call win                    ; neu xuat hien duong cheo phu , nhay qua label win
 exit:
  ret
check ENDP   

; ham in ra trang thai bang cuoi cung va nguoi chien thang
win PROC 
   MOV AX , @data
   MOV DS , AX
   
   MOV AH , 9            ; xuong dong 
   LEA DX , CRLF
   INT 21h
   call map              ; in bang
   MOV AL , char
   CMP AL , 'O'           ; so sanh voi ky tu O , neu bang thi nhay qua label 2win 
   JE winnn
   MOV AH , 9
   LEA DX , winner1      ; in ra nguoi cam quan X chien thang 
   INT 21h
   MOV endg , 1          ; bien endg = 1 danh dau ket thuc game va co nguoi thang 
  ret                    ; quay tro ve vi tri goi ham ( trong main)
 winnn:
   MOV AH , 9            ; in ra nguoi cam quan O chien thang 
   LEA DX , winner2
   INT 21h               
   MOV endg , 1          ; bien endg = 1 danh dau ket thuc game va co nguoi thang 
  ret
win ENDP   

check_draw PROC
    MOV CX , 9           ; bien lap CX = 9 vi phai lap 9 toi da 9 lan 
    MOV SI , OFFSET arr                                      
  full:
    CMP [SI] , 32        ; neu o trong , thoat ham 
    JE not_full          
    INC SI               ; tang SI len 1 dv de chuyen qua o tiep theo
    loop full            ; lap toi da 9 lan      
    
    MOV AH , 9           ; xuong dong 
    LEA DX , CRLF 
    INT 21h    
    call map             ; in ban co hoa 
              
    LEA DX , draw        ; in ra cau lenh thong bao hoa 
    INT 21h             
    MOV endg , 2         ; bien endg = 2 danh dau ket thuc game va hoa nhau                                
  not_full:                                                
  ret
check_draw ENDP      
    
 occupied:
    MOV AH , 9        
    LEA DX , ocp
    INT 21h
    JMP input 

END


