.686
.model flat,stdcall
.stack 100h

.data
  X dw 381Eh
  Y dw 0F120h      
  Z dw 3F9Bh
  Q dw 3981h
  X_prime dw ?
  Y_prime dw ?
  Z_prime dw ?
  Q_prime dw ?
  M dw ?
  R dw ?

.code
ExitProcess PROTO STDCALL :DWORD
Start:

    xor Eax, Eax 
    xor Edx, Edx
    xor Ecx, Ecx
    xor Ebx, Ebx

_start:
    ; Загрузка значений X, Y, Z, Q в регистры
    mov ax, [X]
    mov bx, [Y]
    mov cx, [Z]
    mov dx, [Q]

    ; Цикл: из младших байтов вычесть 43 (2Bh)
    lea esi, [X]              ; ESI = адрес X (начало массива)
    lea edi, [X_prime]        ; EDI = адрес X_prime (начало результатов)
    mov ecx, 4                ; ECX = 4 элемента
cycle_subtract:
    mov ax, [esi]         ; загружаем текущее слово
    mov bl, al           ; BL = младший байт
    sub bl, 43           ; вычитаем 43
    mov al, bl           ; новый младший байт
    mov [edi], ax         ; сохраняем результат
    add esi, 2            ; переход к следующему слову
    add edi, 2            ; переход к следующему результату
    loop cycle_subtract  ; повторяем 4 раза

    ; Загружаем результаты X', Y', Z', Q' в регистры
    mov ax, [X_prime]
    mov bx, [Y_prime]
    mov cx, [Z_prime]
    mov dx, [Q_prime]

    ; Вычисление M = X' & Z' or Y'
    mov ax, [X_prime]
    and ax, [Z_prime]        ; AX = X' & Z'
    or ax, [Y_prime]         ; AX = (X' & Z') or Y'
    mov [M], ax              ; сохраняем M

    ; Сравнение M с 1324h
    cmp ax, 1324h
    jne _subroutine1         ; Если M != 1324, переход к п/п 1
    je _subroutine2          ; Если M == 1324, переход к п/п 2

_subroutine1:
    ; п/п 1: R = M + 061Bh
    mov ax, [M]
    add ax, 061Bh
    mov [R], ax
    jmp _check_high_byte

_subroutine2:
    ; п/п 2: R = 0028h
    mov ax, 0028h
    mov [R], ax
    jmp _check_high_byte

_check_high_byte:
    ; Проверка старшего байта R >= 31h
    mov ax, [R]
    mov ah, byte ptr [R+1]   ; старший байт R
    cmp ah, 31h
    jae _addr1               ; Если >= 31h, переход к АДР1
    jb _addr2                ; Если < 31h, переход к АДР2

_addr1:
    ; АДР1: R = R - 11F1h
    mov ax, [R]
    sub ax, 11F1h
    mov [R], ax
    jmp _end

_addr2:
    ; АДР2: R = R xor 1F08h
    mov ax, [R]
    xor ax, 1F08h
    mov [R], ax
    jmp _end

_end:
    ; Результат в R
    mov ax, [R]

exit:
    Invoke ExitProcess, R
End Start