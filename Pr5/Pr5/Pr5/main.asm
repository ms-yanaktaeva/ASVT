$MOD51
jmp start

org 20h
start:
    mov p1, #0f0h
    lcall lcd_init
    lcall lcd_string
    mov a, #0c0h
    lcall lcd_cmd
    mov r0, #0

main_loop:
    lcall get_key
    cjne a, #0ffh, process_key
    sjmp main_loop

process_key:
    cjne a, #'C', add_symbol
    lcall clear_line
    sjmp main_loop

add_symbol:
    cjne r0, #16, add_char
    sjmp main_loop    

add_char:
    lcall lcd_char
    inc r0
    lcall delay_short
wait_release:
    lcall get_key
    cjne a, #0ffh, wait_release
    ljmp main_loop

clear_line:
    mov a, r0
    push acc
    mov a, #0c0h
    lcall lcd_cmd
    mov r1, #16
clear_loop:
    mov a, #20h
    lcall lcd_char
    djnz r1, clear_loop
    mov a, #0c0h
    lcall lcd_cmd
    pop acc
    mov r0, a
    mov r0, #0
    ret

get_key:
    clr p1.0
    lcall delay_micro
    mov a, p1
    anl a, #0f0h
    cjne a, #0f0h, key_row0
    setb p1.0
    clr p1.1
    lcall delay_micro
    mov a, p1
    anl a, #0f0h
    cjne a, #0f0h, key_row1
    setb p1.1
    clr p1.2
    lcall delay_micro
    mov a, p1
    anl a, #0f0h
    cjne a, #0f0h, key_row2
    setb p1.2
    clr p1.3
    lcall delay_micro
    mov a, p1
    anl a, #0f0h
    cjne a, #0f0h, key_row3
    setb p1.3
    mov a, #0ffh
    ret

key_row0:
    cjne a, #0e0h, r0c2
    mov a, #'7'
    ret
r0c2:
    cjne a, #0d0h, r0c3
    mov a, #'8'
    ret
r0c3:
    cjne a, #0b0h, r0c4
    mov a, #'9'
    ret
r0c4:
    mov a, #'+'
    ret

key_row1:
    cjne a, #0e0h, r1c2
    mov a, #'4'
    ret
r1c2:
    cjne a, #0d0h, r1c3
    mov a, #'5'
    ret
r1c3:
    cjne a, #0b0h, r1c4
    mov a, #'6'
    ret
r1c4:
    mov a, #'-'
    ret

key_row2:
    cjne a, #0e0h, r2c2
    mov a, #'1'
    ret
r2c2:
    cjne a, #0d0h, r2c3
    mov a, #'2'
    ret
r2c3:
    cjne a, #0b0h, r2c4
    mov a, #'3'
    ret
r2c4:
    mov a, #'*'
    ret

key_row3:
    cjne a, #0e0h, r3c2
    mov a, #'C'
    ret
r3c2:
    cjne a, #0d0h, r3c3
    mov a, #'0'
    ret
r3c3:
    cjne a, #0b0h, r3c4
    mov a, #'='
    ret
r3c4:
    mov a, #'/'
    ret

delay_micro:
    mov r7, #5
    djnz r7, $
    ret

lcd_init:
    mov a, #30h
    lcall lcd_cmd
    lcall delay
    mov a, #30h
    lcall lcd_cmd
    lcall delay
    mov a, #30h
    lcall lcd_cmd
    lcall delay
    mov a, #38h
    lcall lcd_cmd
    lcall delay
    mov a, #08h
    lcall lcd_cmd
    lcall delay
    mov a, #01h
    lcall lcd_cmd
    lcall delay
    mov a, #06h
    lcall lcd_cmd
    lcall delay
    mov a, #0fh
    lcall lcd_cmd
    lcall delay
    ret

lcd_cmd:
    mov p0, a
    clr p2.1
    clr p2.2
    setb p2.0
    nop
    nop
    clr p2.0
    ret

lcd_char:
    mov p0, a
    setb p2.1
    clr p2.2
    setb p2.0
    nop
    nop
    clr p2.0
    ret

lcd_string:
    clr a
    movc a, @a+dptr
    jz string_end
    lcall lcd_char
    inc dptr
    sjmp lcd_string
string_end:
    ret

delay_short:
    mov r7, #10
    djnz r7, $
    ret

delay:
    mov r7, #50
d1: mov r6, #100
d2: djnz r6, d2
    djnz r7, d1
    ret

END