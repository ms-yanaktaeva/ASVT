.586
.MODEL FLAT, C
.STACK 4096

.DATA
    V0          REAL8   5.0
    a           REAL8   2.0
    times       REAL8   1.0, 2.0, 3.5, 5.0, 7.2
    numPoints   EQU     5
    two         REAL8   2.0
    distances   REAL8   numPoints DUP(?)

    debugMsg    DB      "Loop %d: t=%f, S=%f", 10, 0

.CODE
main PROC
    finit

    lea     esi, times
    lea     edi, distances
    mov     ecx, numPoints
    xor     ebx, ebx

    ;fld     V0
    ;fld     a
    ;fld     two

compute_loop:
    ; Загружаем t
    fld     qword ptr [esi]
    
    ; Вычисляем t^2
    fld     st(0)
    fmul    st(0), st(0)    ; t^2
    
    ; Умножаем на a
    fmul    qword ptr [a]   ; a*t^2
    
    ; Делим на 2
    fdiv    qword ptr [two] ; a*t^2/2
    
    ; Сохраняем промежуточный результат
    fld     st(0)           ; копия для сложения
    
    ; Вычисляем V0*t
    fld     qword ptr [esi]
    fmul    qword ptr [V0]  ; V0*t
    
    ; Складываем
    fadd    st(0), st(2)    ; V0*t + a*t^2/2
    
    ; Сохраняем результат
    fstp    qword ptr [edi]
    
    ; Очищаем стек от t^2 и a*t^2/2
    fstp    st(0)           ; удаляем a*t^2/2
    fstp    st(0)           ; удаляем t
    
    add     esi, 8
    add     edi, 8
    loop    compute_loop

    finit

    mov     eax, 0
    ret
main ENDP
END main