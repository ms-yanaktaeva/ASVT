.686
.model flat, stdcall
.stack 100h

.data
    X dw 67          
    Y dw 2           
    Z dw 13          
    X_shift dw ?     
    Y_shift dw ?     
    Z_shift dw ?     
    temp_div dw ?    
    M dw ?           

.code
ExitProcess PROTO STDCALL :DWORD

Start:
    mov ax, X
    shr ax, 5        
    mov X_shift, ax

    mov ax, Y
    shr ax, 5
    mov Y_shift, ax

    mov ax, Z
    shr ax, 5
    mov Z_shift, ax

    mov ax, Z_shift
    xor dx, dx       
    div Y            
    mov temp_div, ax

    mov ax, X
    sub ax, temp_div
    mov M, ax        

    mov ax, X_shift
    xor ax, Z_shift
    and ax, Y_shift

    add ax, M
    mov M, ax        

    invoke ExitProcess, 0
End Start