$MOD52 
ORG 0000H      ;nach pamyati

LJMP START
ORG 002BH     ; adres prer taymera

LJMP TIMER2_ISR
DUTY EQU 30H    ;koyf zapol 
STEP_CNT EQU 31H    ;chet schagov
PWM_OUT BIT 090H    ; bit vyxoda
KEY_INC BIT 091H       ; yvelech koyf
KEY_DEC BIT 092H      ; ymen koyf

START:  ; tochka vchoda
MOV SP, #70H
MOV P1, #0FFH
MOV DUTY, #50 ; iznach koyf zapol50%
MOV STEP_CNT, #00    ;obnulenie 
; Fosc=12 mgz, T=0,06c  R=64936=0xFDA8
MOV RCAP2H, #0FDH
MOV RCAP2L, #0A8H
MOV TH2, #0FDH
MOV TL2, #0A8H
MOV T2CON, #00H      ;obnylyaet registr
CLR TF2                 ;sbros flagov
CLR EXF2
SETB PWM_OUT            ;nach yroven
SETB ET2                      
SETB EA                          ;global preryvan
SETB TR2                        ;zapusk taymera

MAIN:    ;osn cikl
JNB KEY_INC, SET_80
JNB KEY_DEC, SET_50
SJMP MAIN

SET_50:
ACALL DEBOUNCE
JB KEY_DEC, MAIN
MOV DUTY, #50

WAIT_REL_50:
JNB KEY_DEC, WAIT_REL_50
ACALL DEBOUNCE
SJMP MAIN

SET_80:
ACALL DEBOUNCE
JB KEY_INC, MAIN
MOV DUTY, #80

WAIT_REL_80:
JNB KEY_INC, WAIT_REL_80
ACALL DEBOUNCE
SJMP MAIN

DEBOUNCE:     ;drebesg
MOV R7, #20
DB1: MOV R6, #250
DB2: DJNZ R6, DB2
DJNZ R7, DB1
RET

TIMER2_ISR:     ;obrab prer taymera
PUSH ACC
PUSH PSW
CLR TF2
CLR EXF2
MOV A, STEP_CNT
CLR C
SUBB A, DUTY
JC PWM_HIGH

PWM_LOW:
CLR PWM_OUT
SJMP NEXT_STEP

PWM_HIGH:
SETB PWM_OUT

NEXT_STEP:
INC STEP_CNT
MOV A, STEP_CNT
CJNE A, #100, ISR_EXIT
MOV STEP_CNT, #00

ISR_EXIT:
POP PSW
POP ACC
RETI
END