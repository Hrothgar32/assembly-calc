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
    format_output_string db "%d",10, 0
    exit_string db "exit", 0
    plus_sign dd "+", 0
    multiply_sign dd "*",0
    divide_sign dd "/", 0
    minus_sign dd "-",0
    equal_sign dd "=",0
    first_operand dd 0
    second_operand dd 0
    third_operand dd 0
    current_operation dd 0
    current_operation_priority dd 0
    counter_thingie dd 0
    initial_variable dd 0
    edx_vessel dd 0
    last_op_negative dd 0
    user_input_string db 0


.code

check_if_digit macro char
    push char
    call isdigit
    add esp, 4
endm

format_to_string MACRO operand
LOCAL do_thing, finish_format
    mov EBX, 10
do_thing:
    cmp EAX, 0
    je finish_format
    xor EDX, EDX
    div BX
    add EDX, 48
    push EDX
    jmp do_thing
finish_format:
    mov EAX, 0
ENDM

prepare_operation MACRO
    mov EBX, first_operand
    push EBX
    mov EBX, second_operand
    push EBX
ENDM
   
read_in_number proc
    push EBP
    mov EBP, ESP
    mov EAX, 0
    push EAX
    mov counter_thingie, EAX
    mov ECX, 8
get_next_char:
    mov EBX, [EBP+ECX]
    push ECX
    check_if_digit EBX
    pop ECX
    cmp EAX, 0
    je end_read_num
    pop EAX
    add EAX, 4
    push EAX
    mov EAX, counter_thingie
    mov EDX, 10
    mul EDX
    sub EBX, 48
    add EAX, EBX
    mov counter_thingie, EAX
    add ECX, 4
    jmp get_next_char
end_read_num:
    pop EAX
    mov ESP, EBP
    pop EBP
    ret
read_in_number endp



add_value_of_operand proc
    push EBP
    mov EBP, ESP
    sub ESP, 4
    mov EAX, [EBP+8]
    add initial_variable, EAX
    mov ESP, EBP
    pop EBP
    ret 4
add_value_of_operand endp

substract_value_of_operand proc
    push EBP
    mov EBP, ESP
    sub ESP, 4
    mov EAX, [EBP+8]
    sub initial_variable, EAX
    mov ESP, EBP
    pop EBP
    ret 4
substract_value_of_operand endp

multiply_value_of_operand proc
    push EBP
    mov EBP, ESP
    sub ESP, 4
    mov EAX, [EBP+8]
    mov EBX, initial_variable
    mul EBX
    mov initial_variable, EAX
    mov ESP, EBP
    pop EBP
    ret 4
multiply_value_of_operand endp

divide_value_of_operand proc
    push EBP
    mov EBP, ESP
    sub ESP, 4
    mov EBX, [EBP+8]
    mov EAX, initial_variable
    cdq
    idiv EBX
    mov initial_variable, EAX
    mov ESP, EBP
    pop EBP
    ret 4
divide_value_of_operand endp

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

divide_operands proc
    push EBP
    mov EBP, ESP
    sub ESP, 8
    mov EAX, [EBP + 8]
    mov EBX, [EBP + 12]
    xor EDX, EDX
    div EBX
    mov ESP, EBP
    pop EBP
    ret 8
divide_operands endp

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
    mov EAX, [EBP + 12]
    mov EBX, [EBP + 8]
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
    je  add_to_initial
    cmp EDX, minus_sign
    je substract_from_initial
    cmp EDX, multiply_sign
    je multiply_initial
    cmp EDX, divide_sign
    je divide_initial
    jne normal_mode

add_to_initial:
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    push EDX
    call add_value_of_operand
    jmp display_changed_initial

substract_from_initial:
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    push EDX
    call substract_value_of_operand
    jmp display_changed_initial

multiply_initial:
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    push EDX
    call multiply_value_of_operand
    jmp display_changed_initial

divide_initial:
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    push EDX
    call divide_value_of_operand
    jmp display_changed_initial

normal_mode:
    push EDX
    mov initial_variable, 0
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    mov EAX, last_op_negative
    cmp EAX, 0
    je con_normal_mode
    mov EAX, EDX
    mov EBX, -1
    mul EBX
    mov EDX, EAX
    mov counter_thingie, EDX
    xor EAX, EAX
    mov last_op_negative, EAX

con_normal_mode:
    mov first_operand, EDX
    pop EDX
    cmp EDX, equal_sign
    je display_number
    cmp EDX, plus_sign
    je set_low_priority
    cmp EDX, minus_sign
    jne set_high_priority

set_low_priority:
    mov EAX, 0
    jmp go_on

set_high_priority:
    mov EAX, 1

go_on:
    mov current_operation_priority, EAX
    mov current_operation, EDX
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    mov second_operand, EDX
    pop EDX
    cmp EDX, multiply_sign
    je high_priority
    cmp EDX, divide_sign
    jne everything_as_usual

high_priority:
    mov EAX, current_operation_priority
    cmp EAX, 1
    je everything_as_usual
    mov edx_vessel, EDX
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    mov ECX, first_operand
    mov third_operand, ECX
    mov ECX, second_operand
    mov second_operand, EDX
    mov first_operand, ECX
    mov EDX, edx_vessel
    cmp EDX, multiply_sign
    je multiply
    cmp EDX, plus_sign
    je addition
    cmp EDX, minus_sign
    je substraction
    cmp EDX, divide_sign
    je division
    jne check_if_exit


everything_as_usual:
    push EDX
    mov EDX, current_operation
    cmp EDX, multiply_sign
    je multiply
    cmp EDX, divide_sign
    je division
    cmp EDX, plus_sign
    je addition
    cmp EDX, minus_sign
    je substraction
    jne check_if_exit

multiply:
    prepare_operation
    call multiply_operands
    jmp push_back_to_stack

addition:
    prepare_operation
    call add_operands
    jmp push_back_to_stack

substraction:
    prepare_operation
    call substract_operands
    jmp push_back_to_stack

division:
    mov EBX, second_operand
    push EBX
    mov EBX, first_operand
    push EBX
    call divide_operands

push_back_to_stack:
    cmp EAX, 0
    jnl format_further
    mov EBX, 1
    mov last_op_negative, EBX
    imul EAX, -1
format_further:
    format_to_string EAX
    mov EAX, third_operand
    cmp EAX, 0
    je calculate_input_result
    call read_in_number
    add ESP, EAX
    mov EDX, counter_thingie
    mov second_operand, EDX
    mov ECX, third_operand
    mov first_operand, ECX
    xor EAX, EAX
    mov third_operand, EAX
    mov EDX, current_operation
    cmp EDX, plus_sign
    je addition
    cmp EDX, minus_sign
    je substraction
    jmp check_if_exit

display_number:
    mov EAX, counter_thingie
    mov initial_variable, EAX
    push EAX
    push offset format_output_string
    call printf
    add ESP, 8
    jmp print_greeting_message

display_changed_initial:
    mov EAX, initial_variable
    push EAX
    push offset format_output_string
    call printf
    add ESP, 8
    jmp print_greeting_message


check_if_exit:
    push offset user_input_string
    push offset exit_string
    call strcmp
    add ESP, 8
    cmp EAX, 0
    jne print_greeting_message

    push 0
    call exit

end start
