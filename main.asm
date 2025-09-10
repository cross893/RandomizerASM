; main.asm (64-bit)
default rel

extern printf
extern scanf
extern srand
extern rand
extern time

section .data
    prompt1: db 'Введите первое число: ', 0
    prompt2: db 'Введите второе число: ', 0
    result: db 'Случайное число: %d', 10, 0
    format: db '%d', 0
    
section .bss
    a: resd 1
    b: resd 1
    
section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    ; time(NULL)
    xor ecx, ecx
    call time
    
    ; srand(time(NULL))
    mov rcx, rax
    call srand
    
    ; printf(prompt1)
    lea rcx, [prompt1]
    call printf
    
    ; scanf("%d", &a)
    lea rdx, [a]
    lea rcx, [format]
    call scanf
    
    ; printf(prompt2)
    lea rcx, [prompt2]
    call printf
    
    ; scanf("%d", &b)
    lea rdx, [b]
    lea rcx, [format]
    call scanf
    
    ; rand()
    call rand
    
    ; Вычисление диапазона
    mov ebx, [b]
    sub ebx, [a]
    inc ebx
    
    ; Деление
    xor edx, edx
    div ebx
    
    ; Результат
    add edx, [a]
    
    ; printf
    mov r8d, edx
    mov edx, r8d
    lea rcx, [result]
    call printf
    
    ; Завершение
    add rsp, 32
    pop rbp
    xor eax, eax
    ret
