    .386
    .model flat, stdcall

    includelib msvcrt.lib
    extern exit: proc
    extern printf: proc
    extern scanf: proc
    extern strcmp: proc

    public start

    .data
    greeting_message db "Introduceti o expresie ", 0
    format_string db "%s",0
    exit_string db "exit", 0
    inital_variable dd 0
    user_input_string db 0


.code
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
