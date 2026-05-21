; integral.asm - метод Симпсона

.586
.MODEL FLAT, C

.DATA
    sum_val REAL8 0.0
    x_val   REAL8 0.0

.CODE
    EXTERN CalcFunction:NEAR
    PUBLIC CalculateIntegral

CalculateIntegral PROC C n:DWORD, step:REAL8
    
    push ebp
    mov ebp, esp
    
    finit
    
    ; Проверка, что n чётное
    mov eax, n
    and eax, 1
    cmp eax, 0
    je n_is_even
    ; Если n нечётное, увеличиваем на 1
    mov eax, n
    add eax, 1
    mov n, eax
    fld1
    fild n
    fdivp
    fstp step
    
n_is_even:
    ; sum = f(0) + f(1)
    fldz
    call CalcFunction        ; f(0)
    fld1
    call CalcFunction        ; f(1)
    faddp                    ; ST(0) = f(0)+f(1)
    fstp sum_val
    
    mov ecx, n
    dec ecx                  ; n-1
    mov eax, 1               ; i = 1
    
for_loop:
    cmp eax, ecx
    jg finish
    
    ; x = i * step
    fld step
    push eax
    fild DWORD PTR [esp]
    add esp, 4
    fmulp ST(1), ST(0)
    fstp x_val
    
    ; вызов f(x)
    push DWORD PTR [x_val+4]
    push DWORD PTR [x_val]
    call CalcFunction
    add esp, 8
    
    ; умножение на коэффициент
    test eax, 1              ; проверка чётности i
    jnz odd_index
    
    ; чётный индекс: умножаем на 2
    fld sum_val
    fadd ST(0), ST(1)
    faddp
    fstp sum_val
    jmp next
    
odd_index:
    ; нечётный индекс: умножаем на 4
    fld sum_val
    fadd ST(0), ST(1)
    fadd ST(0), ST(1)
    fadd ST(0), ST(1)
    faddp
    fstp sum_val
    
next:
    inc eax
    jmp for_loop
    
finish:
    ; integral = sum * step / 3
    fld sum_val
    fld step
    fmulp
    fld1
    fld1
    faddp
    faddp
    fdivp
    
    pop ebp
    ret
    
CalculateIntegral ENDP

END