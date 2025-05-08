; Tic Tac Toe Game
; Directives
INCLUDE "emu8086.inc"
.MODEL large
.STACK 100h

; Data Section
.DATA
    ; Strings for making 3 x 3 box 
    space db 32,"$"
    newline db  0ah,0dh,"$"
    strline db " | $"
    line db 0ah,0dh,"-----------",0ah,0dh,32,"$"
   
    ; Array to write "O" and "X" in the box
    arr db 32 , 32, 32
        db 32 , 32, 32
        db 32 , 32, 32
   
    ; Title of the Game
    tictac db "---------------------------",0ah,0dh,
          db "|      Tic Tac Toe        |",0ah,0dh,
          db "---------------------------",0ah,0dh,0ah,0dh
          db "Player1 : O    Player2 : X ",0ah,0dh,0ah,0dh,"$"
   
    ; Strings for players turn
    play1 db 0ah,0dh,0ah,0dh,"Player 1 turn : ",0ah,0dh,0ah,0dh,"$"
    play2 db 0ah,0dh,0ah,0dh,"Player 2 turn : ",0ah,0dh,0ah,0dh,"$"
   
    ; Strings for inputting the rows and column
    enterrow db 0ah,0dh,"Enter the row (1-3): ","$"
    entercol db 0ah,0dh,"Enter the column (1-3): ","$"
   
    ; Strings for the Winner
    play1win db 0ah,0dh,0ah,0dh,"Player 1 is Winner.","$"
    play2win db 0ah,0dh,0ah,0dh,"Player 2 is Winner.","$"
    drawn db 0ah,0dh,"Game is Drawn.",0ah,0dh,"$"
   
    ; Error messages
    invalid_input_msg db 0ah,0dh,"Invalid input! Please enter 1-3.",0ah,0dh,"$"
    occupied_msg db 0ah,0dh,"This position is already occupied!",0ah,0dh,"$"
   
    ; Defining variables
    turn db 1
    endgame db 0
    chr db 79
    rows db 0
    cols db 0
    num dw ?
   
; Code Section 
.CODE

; Main Procedure
MAIN PROC 
    mov ax,@data
    mov ds,ax
    
    call tictactoe 
    mov si,offset arr
    mov cx,9
    
    ; Loop to run the game
    game_loop:
        mov al,turn
        cmp al,1
        je callplayer1
        call player2
        jmp done
       
        callplayer1:
        call player1
       
        done:
        call map
        
        ; Get row input
        input_row:
            lea dx,enterrow
            mov ah,09
            int 21h
            
            mov ah,1
            int 21h
            sub al,48
            
            ; Validate row input
            cmp al,1
            jl invalid_row
            cmp al,3
            jg invalid_row
            mov rows,al
            jmp get_col
            
        invalid_row:
            lea dx,invalid_input_msg
            mov ah,09
            int 21h
            jmp input_row
            
        ; Get column input
        get_col:
            lea dx,entercol
            mov ah,09
            int 21h
            
            mov ah,1
            int 21h
            sub al,48
            
            ; Validate column input
            cmp al,1
            jl invalid_col
            cmp al,3
            jg invalid_col
            mov cols,al
            
            ; Thêm xu?ng dòng sau khi nh?p xong c?t
            lea dx,newline
            mov ah,09
            int 21h         
            
            lea dx , newline 
            mov ah,09
            int 21h
            
            jmp check_position
            
        invalid_col:
            lea dx,invalid_input_msg
            mov ah,09
            int 21h
            jmp get_col
            
        ; Check if position is occupied
        check_position:
            mov si,offset arr
            mov bl,3
            mov al,rows
            sub al,1
            mul bl
            mov bh,cols
            sub bh,1
            add al,bh
            mov bh,0
            mov bl,al
            
            cmp byte ptr [si+bx],32
            jne position_occupied
            
            ; Update board
            mov al,turn
            cmp al,0
            je elsepart 
            mov [si+bx],'X'
            jmp ok
            
            elsepart:
            mov [si+bx],'O'
            
            ok:
            ; Check for winner
            call CHECK
            
            mov al,endgame
            cmp al,1
            je break
            
            ; Check for draw
            call CHECK_DRAW
            mov al,endgame
            cmp al,2
            je break
            
            loop game_loop
            
            break:
            mov al,endgame
            cmp al,0
            jne return
            call map              ; In bàn c? tru?c
            mov dx,offset drawn  ; Sau dó m?i in thông báo hòa
            mov ah,09h
            int 21h
        return:    
     
    mov ah,4ch
    int 21h
    MAIN ENDP

; Procedure to check for draw
CHECK_DRAW PROC
    mov cx,9
    mov si,offset arr
    check_full:
        cmp byte ptr [si],32    ; Ki?m tra ô tr?ng
        je not_full            ; N?u có ô tr?ng thì không hòa
        inc si
        loop check_full
        
    ; N?u d?n dây nghia là bàn c? dã d?y
    mov endgame,2              ; Ðánh d?u là hòa
    call map                   ; In bàn c? tru?c
    lea dx,newline            ; Xu?ng dòng tru?c khi in thông báo hòa
    mov ah,09
    int 21h
    lea dx,newline            ; Xu?ng dòng thêm l?n n?a
    mov ah,09
    int 21h
    lea dx,drawn              ; In thông báo hòa
    mov ah,09
    int 21h
    
    not_full:
    ret
CHECK_DRAW ENDP
    
; Procedure to check the winner
CHECK PROC
    mov ax,@data
    mov ds,ax 
    
    ; Check rows
    mov cx,3
    mov bx,0
    check_rows:
        mov al,chr
        cmp byte ptr [si+bx],32
        je next_row
        cmp al,[si+bx]
        jne next_row
        cmp al,[si+bx+1]
        jne next_row
        cmp al,[si+bx+2]
        jne next_row
        call winner
    next_row:
        add bx,3
        loop check_rows
    
    ; Check columns
    mov cx,3
    mov bx,0
    check_cols:
        mov al,chr
        cmp byte ptr [si+bx],32
        je next_col
        cmp al,[si+bx]
        jne next_col
        cmp al,[si+bx+3]
        jne next_col
        cmp al,[si+bx+6]
        jne next_col
        call winner
    next_col:
        inc bx
        loop check_cols
    
    ; Check diagonals
    mov al,chr
    cmp byte ptr [si],32
    je check_second_diag
    cmp al,[si]
    jne check_second_diag
    cmp al,[si+4]
    jne check_second_diag
    cmp al,[si+8]
    jne check_second_diag
    call winner
    
    check_second_diag:
    mov al,chr
    cmp byte ptr [si+2],32
    je end_check
    cmp al,[si+2]
    jne end_check
    cmp al,[si+4]
    jne end_check
    cmp al,[si+6]
    jne end_check
    call winner
    
    end_check:
    ret
CHECK ENDP

; Winner Procedure
winner proc
    mov ax,@data
    mov ds,ax
    
    call map                   ; In bàn c? tru?c
    mov al,chr
    cmp al,79
    jne else
    lea dx,play1win
    mov ah,09
    int 21h
    mov endgame,1
    ret
    else:
    lea dx,play2win
    mov ah,09
    int 21h
    mov endgame,1
    ret
winner endp

; Procedure for making the title
tictactoe proc
    mov ax,@data
    mov ds,ax
    
    mov dx,offset tictac
    mov ah,09
    int 21h
    ret
tictactoe endp

; Procedure for player 1's turn
player1 proc  
    mov ax,@data
    mov ds,ax 
    
    lea dx,play1
    mov ah,09
    int 21h 
    
    mov chr,79
    mov turn,0
    ret
player1 endp 

; Procedure for player 2's turn
player2 proc  
    mov ax,@data
    mov ds,ax 
    
    lea dx,play2
    mov ah,09
    int 21h 
    
    mov chr,88
    mov turn,1
    ret
player2 endp 

; Procedure for making the 3x3 box and show elements
map proc
    mov ax,@data
    mov ds,ax
    mov si,offset arr
    
    lea dx,space
    mov ah,09
    int 21h
    
    mov dx,[si]
    mov ah,02h
    int 21h
    
    lea dx,strline
    mov ah,09
    int 21h
     
    mov dx,[si+1]
    mov ah,02h
    int 21h
    
    lea dx,strline
    mov ah,09
    int 21h 
    
    mov dx,[si+2]
    mov ah,02h
    int 21h
    
    lea dx,line
    mov ah,09
    int 21h
    
    mov dx,[si+3]
    mov ah,02h
    int 21h
    
    lea dx,strline
    mov ah,09
    int 21h
     
    mov dx,[si+4]
    mov ah,02h
    int 21h
    
    lea dx,strline
    mov ah,09
    int 21h 
    
    mov dx,[si+5]
    mov ah,02h
    int 21h 
    
    lea dx,line
    mov ah,09
    int 21h
    
    mov dx,[si+6]
    mov ah,02h
    int 21h
    
    lea dx,strline
    mov ah,09
    int 21h
     
    mov dx,[si+7]
    mov ah,02h
    int 21h
    
    lea dx,strline
    mov ah,09
    int 21h 
    
    mov dx,[si+8]
    mov ah,02h
    int 21h 
    
    lea dx,newline
    mov ah,09
    int 21h
    ret
map endp

; Position occupied handler
position_occupied:
    lea dx,occupied_msg
    mov ah,09
    int 21h
    jmp input_row    ; Return to input row

end main
