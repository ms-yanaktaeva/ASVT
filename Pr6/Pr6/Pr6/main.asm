$MOD51
ORG 0000H

MAIN:
  ; zapolnim dannye 50h-59h (10 bayt)
  MOV R0, #50H     ; start adres (XX = 50h)
  MOV R1, #10      ; N = 10
  MOV A, #50H      ; nachinaem zapolnyat (50h, 51h, 52h...)
  
FILL_BUFFER:
  MOV @R0, A       ; znach v bufer
  INC R0           ; sled adres
  INC A            ; sled znach
  DJNZ R1, FILL_BUFFER

  ; nastr skorosti dlya 62.5 kbit/s
  ; SMOD = 1, S = 62.5 kbit/s, Fosc = 12 MGz
  ; TH1 = 256 - (Fosc / (12 * 16 * S))? NET!
  ; Formula: S = (2^SMOD / 32) * (Fosc / (12 * (256 - TH1)))
  ; 62500 = (2/32) * (12e6 / (12 * (256 - TH1)))
  ; 62500 = (1/16) * (12e6 / (12 * (256 - TH1)))
  ; 62500 = (1/16) * (1e6 / (256 - TH1))
  ; 62500 * 16 = 1e6 / (256 - TH1)
  ; 1,000,000 = 1,000,000 / (256 - TH1)
  ; 256 - TH1 = 1
  ; TH1 = 255 = 0FFh
  MOV PCON, #80H   ; SMOD = 1 (udvoenie skorosti)
  
  MOV TMOD, #20H   ; timer 1 v rezhime 2 (8-bit avtoperezagruzka)
  MOV TH1, #0FFH   ; znachenie dlya skorosti 62.5 kbit/s pri Fosc=12 MGz
  MOV TL1, #0FFH   ; nachalnoe znachenie taymera
  
  SETB TR1         ; zapusk timer 1
  
  ; nastroyka UART: rezhim 1 (10 bitoviy kadr), peredacha
  ; SM0=0, SM1=1, REN=0 (tolko peredacha)
  MOV SCON, #40H   ; 01000000b
  
  MOV R0, #50H     ; ukazatel na start bufera (XX = 50h)
  MOV R7, #10      ; schetchik baytov N = 10

SEND_LOOP:
  MOV A, @R0       ; vzyat znachenie iz pamyati
  MOV SBUF, A      ; otpravit v UART

WAIT_TI:
  JNB TI, WAIT_TI  ; zdat zaversheniya peredachi
  CLR TI           ; sbros flag dlya sleduyuschego bayta
  
  INC R0           ; sled bayt
  DJNZ R7, SEND_LOOP  ; povtorit N raz

STOP:
  SJMP STOP 
END