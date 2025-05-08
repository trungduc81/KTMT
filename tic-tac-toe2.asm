; Tic Tac Toe Game - Ch?n ô b?ng s? 1-9
INCLUDE "emu8086.inc"
.MODEL large
.STACK 100h

.DATA
    space db 32,"$"
    newline db 0ah,0dh,"$"
    strline db " | $"
    line db 0ah,0dh,"-----------",0ah,0dh,32,"$"
    arr db 32,32,32,32,32,32,32,32,32
    tictac db "---------------------------",0ah,0dh,
          db "|      Tic Tac Toe        |",0ah,0dh,
          db "---------------------------",0ah,0dh,0ah,0dh
          db "Player1 : O    Player2 : X ",0ah,0dh,0ah,0dh,"$"
    play1 db 0ah,0dh,0ah,0dh,"Player 1 turn : ",0ah,0dh,0ah,0dh,"$"
    play2 db 0ah,0dh,0ah,0dh,"Player 2 turn : ",0ah,0dh,0ah,0dh,"$"
    prompt_pos db "Enter your move (1-9): $"
    play1win db 0ah,0dh,0ah,0dh,"Player 1 is Winner.","$"
    play2win db 0ah,0dh,0ah,0dh,"Player 2 is Winner.","$"
    drawn db 0ah,0dh,"Game is Drawn.",0ah,0dh,"$"
    invalid_input_msg db 0ah,0dh,"Invalid input! Please enter 1-9.",0ah,0dh,"$"
    occupied_msg db 0ah,0dh,"This position is already occupied!",0ah,0dh,"$"
    turn db 1
    endgame db 0
    chr db 79
    num dw ?

.CODE

MAIN PROC 
    mov ax,@data
    mov ds,ax
    
    call tictactoe 
    mov si,offset arr
    mov cx,9
    
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

; Nh?p v? trí t? 1-9
input_pos:
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, prompt_pos
    mov ah, 09h
    int 21h

    mov ah, 1
    int 21h
    sub al, 48
    cmp al, 1
    jl invalid_pos
    cmp al, 9
    jg invalid_pos
    mov bl, al
    dec bl         ; index = pos - 1

    ; Thêm xu?ng dòng sau khi nh?p xong v? trí
    lea dx, newline
    mov ah, 09h
    int 21h

    ; Ki?m tra ô dã dánh chua
    mov si, offset arr
    cmp byte ptr [si+bx], 32
    jne position_occupied

    ; Ðánh d?u X ho?c O
    mov al, turn
    cmp al, 0
    je elsepart2
    mov [si+bx], 'X'
    jmp ok2

elsepart2:
    mov [si+bx], 'O'

ok2:
    ; Check for winner
    call CHECK

    mov al, endgame
    cmp al, 1
    je break

    ; Check for draw
    call CHECK_DRAW
    mov al, endgame
    cmp al, 2
    je break

    loop game_loop

invalid_pos:
    lea dx, invalid_input_msg
    mov ah, 09h
    int 21h
    jmp input_pos

break:
    mov al,endgame
    cmp al,0
    jne return
    lea dx,newline
    mov ah,09
    int 21h
    call map
    lea dx,newline
    mov ah,09
    int 21h
    lea dx,newline
    mov ah,09
    int 21h
    mov dx,offset drawn
    mov ah,09h
    int 21h
return:    
    mov ah,4ch
    int 21h
MAIN ENDP

CHECK_DRAW PROC
    mov cx,9
    mov si,offset arr
check_full:
    cmp byte ptr [si],32
    je not_full
    inc si
    loop check_full
    mov endgame,2
    lea dx, newline      ; Thêm dòng tr?ng tru?c khi in b?ng cu?i
    mov ah, 09h
    int 21h
    call map
    lea dx,newline
    mov ah,09
    int 21h
    lea dx,newline
    mov ah,09
    int 21h
    lea dx,drawn
    mov ah,09
    int 21h
not_full:
    ret
CHECK_DRAW ENDP

CHECK PROC
    mov ax,@data
    mov ds,ax 
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

winner proc
    mov ax,@data
    mov ds,ax
    lea dx, newline      ; Thêm dòng tr?ng tru?c khi in b?ng cu?i
    mov ah, 09h
    int 21h
    call map
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

tictactoe proc
    mov ax,@data
    mov ds,ax
    mov dx,offset tictac
    mov ah,09
    int 21h
    ret
tictactoe endp

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

map proc
    mov ax,@data
    mov ds,ax
    mov si,offset arr
    lea dx,space
    mov ah,09
    int 21h
    mov dl,[si]
    mov ah,02h
    int 21h
    lea dx,strline
    mov ah,09
    int 21h
    mov dl,[si+1]
    mov ah,02h
    int 21h
    lea dx,strline
    mov ah,09
    int 21h 
    mov dl,[si+2]
    mov ah,02h
    int 21h
    lea dx,line
    mov ah,09
    int 21h
    mov dl,[si+3]
    mov ah,02h
    int 21h
    lea dx,strline
    mov ah,09
    int 21h
    mov dl,[si+4]
    mov ah,02h
    int 21h
    lea dx,strline
    mov ah,09
    int 21h 
    mov dl,[si+5]
    mov ah,02h
    int 21h 
    lea dx,line
    mov ah,09
    int 21h
    mov dl,[si+6]
    mov ah,02h
    int 21h
    lea dx,strline
    mov ah,09
    int 21h
    mov dl,[si+7]
    mov ah,02h
    int 21h
    lea dx,strline
    mov ah,09
    int 21h 
    mov dl,[si+8]
    mov ah,02h
    int 21h 
    lea dx,newline
    mov ah,09
    int 21h
    ret
map endp

position_occupied:
    lea dx,occupied_msg
    mov ah,09
    int 21h
    jmp input_pos

end main
