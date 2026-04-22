section .data
result:
    db 'Volume kubus adalah: ', 0

section .text
    MOV EAX, 9
    PUSH EAX
    CALL cube_volume

    MOV EBX, EAX
    MOV EAX, result
    INT 2

    MOV EAX, EBX
    INT 1

    HLT

cube_volume:
    ENTER

    MOV EAX, [EBP + 8]
    IMUL EAX
    IMUL [EBP + 8]

    LEAVE
    RET