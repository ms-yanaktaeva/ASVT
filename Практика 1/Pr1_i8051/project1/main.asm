$MOD51
org 00h

clr P1.0
    mov dptr, #1000h    
    mov r2, #04h        
    mov r1, #055h       

test_page:
    mov r3, #00h        

test_byte:
    mov a, r1
    movx @dptr, a       
    movx a, @dptr       
    xrl a, #055h        
    jnz error           
    inc dptr            
    djnz r3, test_byte  
    djnz r2, test_page  

    sjmp $              

error:
    setb P1.0           
    sjmp $              

END