$MOD51
ORG 0000H

MAIN:
  ; zapolnim dannye 30h-43h (20 bit)
  MOV R0, #30H     ; start adres
  MOV R1, #20      ; N = 20
  MOV A, #30H      ; nachinaem zapolnyat (30h, 31h, 32h...)
  
FILL_BUFFER:
  MOV @R0, A       ; znach v bufer
  INC R0           ; sled adres
  INC A            ; sled znach
  DJNZ R1, FILL_BUFFER

  ; nastr skorosti
  ; SMOD = 1, S = 9.6 kbit/s, Fosc = 11.0592 mgz
  ; TH1 = 256 - (Fosc / (12 * 16 * S)) = 256 - (11.0592e6 / (12 * 16 * 9600)) = 256 - 6 = 250 
  MOV PCON, #80H   ; SMOD = 1
  
  MOV TMOD, #20H   ; timer 1 v rezhime 2, znachit 8bit -> 0...255(FFH)) avtoperezagruzka
  MOV TH1, #250   ; znach dlya skorocti 9600 Fosc=11.0592 
  MOV TL1, #250   ; nach znach taymera
  
  SETB TR1         ; zapusk timer1
  
  ; nastroyka UART: rezim 1 (8 ???), peredacha
  ; SM0=0, SM1=1, REN=0 ()
  MOV SCON, #40H   ; 
  
  MOV R0, #30H     ; ukazatel na start bufera
  MOV R7, #20      ; chetchik baytov N = 20

SEND_LOOP:
  MOV A, @R0       ; vzat znachenie na kotoroe ukazivaet r0
  MOV SBUF, A      ; sbuf - buffer posledovatelnogo porta

WAIT_TI:
  JNB TI, WAIT_TI  ; gdat zaver peredachi
  CLR TI           ; sbros flag
  
  INC R0           ; sled bayt
  DJNZ R7, SEND_LOOP  ; povtot 

STOP:
  SJMP STOP 
END