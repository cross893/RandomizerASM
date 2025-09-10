; main.asm (64-bit)
default rel

extern printf
extern srand
extern rand
extern atoi
extern GetTickCount

section .data
    result db 'Случайное число: %d', 10, 0
    usage db 'Использование: program.exe <min> <max>', 10, 0
    
section .bss
    num1 resd 1
    num2 resd 1
    
section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    ; Проверяем количество аргументов
    cmp rcx, 3
    jne .show_usage
    
    ; Получаем аргументы
    mov r12, rdx
    
    ; Первый аргумент
    mov rcx, [r12 + 8]
    call atoi
    mov [num1], eax
    
    ; Второй аргумент
    mov rcx, [r12 + 16]
    call atoi
    mov [num2], eax
    
    ; Упорядочиваем числа
    mov eax, [num1]
    mov ebx, [num2]
    cmp eax, ebx
    jle .no_swap
    xchg eax, ebx
.no_swap:
    mov [num1], eax
    mov [num2], ebx
    
    ; Улучшенная инициализация генератора случайных чисел
    call better_seed
    
    ; Генерация случайного числа
    call rand
    
    ; Вычисление в диапазоне
    mov ebx, [num2]
    sub ebx, [num1]
    inc ebx
    
    xor edx, edx
    div ebx
    add edx, [num1]
    
    ; Вывод результата
    mov r8d, edx
    mov edx, r8d
    lea rcx, [result]
    call printf
    
    jmp .exit

.show_usage:
    ; Простая подсказка в одну строку
    lea rcx, [usage]
    call printf

.exit:
    add rsp, 32
    pop rbp
    xor eax, eax
    ret

better_seed:
    push rbp
    mov rbp, rsp
    
    ; Получаем более точное время через GetTickCount
    call GetTickCount
    
    ; Добавляем entropy через счетчик тактов процессора
    rdtsc                   ; читаем Time Stamp Counter
    xor eax, edx            ; смешиваем младшие и старшие биты
    add eax, [rsp]          ; добавляем значение указателя стека
    
    ; Инициализируем генератор
    mov rcx, rax
    call srand
    
    pop rbp
    ret
