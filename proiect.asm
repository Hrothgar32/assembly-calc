    .386
    .model flat, stdcall

    includelib msvcrt.lib
    extern exit: proc
    extern printf: proc
    extern scanf: proc
    extern strcmp: proc
    extern strlen: proc
    extern isdigit: proc

    public start

    .data
    greeting_message db "Introduceti o expresie",10, 0
    format_string db "%s",0
    exit_string db "exit", 0
    plus_sign dd "+", 0
    multiply_sign dd "*",0
    minus_sign dd "-",0
    first_operand dd 0
    second_operand dd 0
    third_operand dd 0
    initial_variable dd 0
    user_input_string db 0


.code

check_if_digit macro char
    push char
    call isdigit
    add esp, 4
endm


read_in_number proc
    push EBP
    mov EBP, ESP
    xor EAX, EAX
    pop ECX
    push EAX
    check_if_digit ECX
    cmp EAX, 0
    jne end_read_num
    pop EAX
    mov EDX, 10
    mul EDX
    add EAX, ECX
end_read_num:
    mov ESP, EBP
    pop EBP
    ret
read_in_number endp



add_value_of_operand proc
    push EBP
    mov EBP, ESP
    sub ESP, 4
    mov EAX, [EBP+8]
    sub EAX, 48
    add initial_variable, EAX
    mov ESP, EBP
    pop EBP
    ret 4
add_value_of_operand endp

multiply_operands proc
    push EBP
    mov EBP, ESP
    sub ESP, 8
    mov EAX, [EBP + 8]
    mov EBX, [EBP + 12]
    mul EBX
    mov ESP, EBP
    pop EBP
    ret 8
multiply_operands endp

add_operands proc
    push EBP
    mov EBP, ESP
    sub ESP, 8
    mov EAX, [EBP + 8]
    mov EBX, [EBP + 12]
    add EAX, EBX
    mov ESP, EBP
    pop EBP
    ret 8
add_operands endp

substract_operands proc
    push EBP
    mov EBP, ESP
    sub ESP, 8
    mov EAX, [EBP + 8]
    mov EBX, [EBP + 12]
    sub EAX, EBX
    mov ESP, EBP
    pop EBP
    ret 8
substract_operands endp

start:

print_greeting_message:
    push offset greeting_message
    push offset format_string
    call printf
    add ESP, 8

read_input:
    push offset user_input_string
    push offset format_string
    call scanf
    add ESP, 8

calculate_lenght_of_input:
    push offset user_input_string
    call strlen
    add ESP, 4
    mov ECX, EAX

put_initial_input_onto_stack:
    mov AL, user_input_string[ECX-1]
    push EAX
    loop put_initial_input_onto_stack

calculate_input_result:
    pop EDX
    cmp EDX, plus_sign
    jne continue_calculate_input_result
    call add_value_of_operand
    jmp print_greeting_message
continue_calculate_input_result:
    sub EDX, 48
    mov first_operand, EDX
    pop EDX
    cmp EDX, multiply_sign
    je multiply
    cmp EDX, plus_sign
    je addition
    cmp EDX, minus_sign
    je substraction
    jne check_if_exit
multiply:
    mov EBX, first_operand
    pop EDX
    sub EDX, 48
    push EDX
    push EBX
    call multiply_operands
    jmp push_back_to_stack
addition:
    mov EBX, first_operand
    pop EDX
    sub EDX, 48
    push EDX
    push EBX
    call add_operands
    jmp push_back_to_stack
substraction:
    mov EBX, first_operand
    pop EDX
    sub EDX, 48
    push EDX
    push EBX
    call substract_operands
push_back_to_stack:
    add EAX, 48
    push EAX



check_if_exit:
    push offset user_input_string
    push offset exit_string
    call strcmp
    add ESP, 8
    cmp EAX, 0
    jne print_greeting_message

lexit:
    push 0
    call exit

end start
