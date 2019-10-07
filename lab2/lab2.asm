.386P
.MODEL  LARGE
;�������� ������
S_DESC  struc                                   ;������� ᥣ���⭮�� ���ਯ��
    LIMIT       dw 0                            ;����� ᥣ���� (15:00)    
    BASE_L      dw 0                            ;���� ����, ������ ���� (15:0)
    BASE_M      db 0                            ;���� ����, �।��� ���� (23:16)
    ACCESS      db 0                            ;���� ����㯠
    ATTRIBS     db 0                            ;����� ᥣ���� (19:16) � ��ਡ���
    BASE_H      db 0                            ;���� ����, ����� ����
S_DESC  ends        
I_DESC  struc                                   ;������� ���ਯ�� ⠡���� ���뢠���
    OFFS_L      dw 0                            ;���� ��ࠡ��稪� (0:15)
    SEL         dw 0                            ;������� ����, ᮤ�ঠ饣� ��� ��ࠡ��稪�
    PARAM_CNT   db 0                            ;��ࠬ����
    ACCESS      db 0                            ;�஢��� ����㯠
    OFFS_H      dw 0                            ;���� ��ࠡ��稪� (31:16)
I_DESC  ends        
R_IDTR  struc                                   ;������� IDTR
    LIMIT       dw 0                            
    IDT_L       dw 0                            ;���饭�� ���� (0-15)
    IDT_H       dw 0                            ;���饭�� ���� (31-16)
R_IDTR  ends
;����� �஢��� ����㯠 ᥣ���⮢
ACS_PRESENT     EQU 10000000B                   ;PXXXXXXX - ��� ������⢨�, ᥣ���� ��������� � ����⨢��� �����
ACS_CSEG        EQU 00011000B                   ;XXXXIXXX - ⨯ ᥣ����, ��� ������ = 0, ��� ���� 1
ACS_DSEG        EQU 00010000B                   ;XXXSXXXX - ��� ᥣ����, ����� ��ꥪ� ᥣ����(��⥬�� ��ꥪ�� ����� ���� �� ᥣ�����)
ACS_READ        EQU 00000010B                   ;XXXXXXRX - ��� �⥭��, ����������� �⥭�� �� ��㣮�� ᥣ����
ACS_WRITE       EQU 00000010B                   ;XXXXXXWX - ��� �����, ��� ᥣ���� ������ ࠧ��蠥� ������
ACS_CODE        =   ACS_PRESENT or ACS_CSEG     ;AR ᥣ���� ����
ACS_DATA =  ACS_PRESENT or ACS_DSEG or ACS_WRITE;AR ᥣ���� ������
ACS_STACK=  ACS_PRESENT or ACS_DSEG or ACS_WRITE;AR ᥣ���� �⥪�
ACS_INT_GATE    EQU 00001110B
ACS_TRAP_GATE   EQU 00001111B                   ;XXXXSICR - ᥣ����, ���稭���� ᥣ���� ����, ����㯥� ��� �⥭��
ACS_IDT         EQU ACS_DATA                    ;AR ⠡���� IDT    
ACS_INT         EQU ACS_PRESENT or ACS_INT_GATE
ACS_TRAP        EQU ACS_PRESENT or ACS_TRAP_GATE
ACS_DPL_3       EQU 01100000B                   ;X<DPL,DPL>XXXXX - �ਢ������ ����㯠, ����� ����� ������� �� ���
;������� ���� ॠ�쭮�� ०���       
CODE_RM segment para use16
CODE_RM_BEGIN   = $
    assume cs:CODE_RM,DS:DATA,ES:DATA           ;���樠������ ॣ���஢ ��� ��ᥬ���஢����
START:
    mov ax,DATA                                 ;���樠������ ᥣ������ ॣ���஢
    mov ds,ax                                   
    mov es,ax                          
    lea dx,MSG_EXIT
    mov ah,9h
    int 21h
    lea dx,MSG_HELLO
    mov ah,9h
    int 21h
ANSWER:
    mov ah, 8h
    int 21h                                     ;�������� ���⢥ত����
    cmp al, 'p'
    je ENABLE_A20
    cmp al, 'e'
    je END_PROG
    jmp ANSWER
ENABLE_A20:                                     ;������ ����� A20
    in  al,92h                                                                              
    or  al,2                                    ;��⠭����� ��� 1 � 1                                                   
    out 92h,al                                                                                                                     
    ;��� ⠪ ��� ����� �������஢                                                                                                      0 LINE
    ;mov    al, 0D1h
    ;out    64h, al
    ;mov    al, 0DFh
    ;out    60h, al
	
SAVE_MASK:                                      ;���࠭��� ��᪨ ���뢠���     
    in      al,21h
    mov     INT_MASK_M,al                  
    in      al,0A1h
    mov     INT_MASK_S,al                 
DISABLE_INTERRUPTS:                             ;����� ��᪨�㥬�� � ����᪨�㥬�� ���뢠���        
    cli                                         ;����� ��᪨���� ���뢠���
    in  al,70h	
	or	al,10000000b                            ;��⠭����� 7 ��� � 1 ��� ����� ����᪨�㥬�� ���뢠���
	out	70h,al
	nop	
LOAD_GDT:                                       ;��������� ��������� ⠡���� ���ਯ�஢            
    mov ax,DATA
    mov dl,ah
    xor dh,dh
    shl ax,4
    shr dx,4
    mov si,ax
    mov di,dx
WRITE_GDT:                                      ;��������� ���ਯ�� GDT
    lea bx,GDT_GDT
    mov ax,si
    mov dx,di
    add ax,offset GDT
    adc dx,0
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_CODE_RM:                                  ;��������� ���ਯ�� ᥣ���� ���� ॠ�쭮�� ०���
    lea bx,GDT_CODE_RM
    mov ax,cs
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_DATA:                                     ;������� ���ਯ�� ᥣ���� ������
    lea bx,GDT_DATA
    mov ax,si
    mov dx,di
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_STACK:                                    ;������� ���ਯ�� ᥣ���� �⥪�
    lea bx, GDT_STACK
    mov ax,ss
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_CODE_PM:                                  ;������� ���ਯ�� ���� ���饭���� ०���
    lea bx,GDT_CODE_PM
    mov ax,CODE_PM
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh        
    or  [bx][S_DESC.ATTRIBS],40h
WRITE_IDT:                                      ;������� ���ਯ�� IDT
    lea bx,GDT_IDT
    mov ax,si
    mov dx,di
    add ax,OFFSET IDT
    adc dx,0
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh        
    mov IDTR.IDT_L,ax
    mov IDTR.IDT_H,dx
FILL_IDT:                                       ;��������� ⠡���� ���ਯ�஢ �� ���뢠���
    irpc    N, 0123456789ABCDEF                 ;��������� ��� 00-0F �᪫�祭�ﬨ
        lea eax, EXC_0&N
        mov IDT_0&N.OFFS_L,ax
        shr eax, 16
        mov IDT_0&N.OFFS_H,ax
    endm
    irpc    N, 0123456789ABCDEF                 ;��������� ��� 10-1F �᪫�祭�ﬨ
        lea eax, EXC_1&N
        mov IDT_1&N.OFFS_L,ax
        shr eax, 16
        mov IDT_1&N.OFFS_H,ax
    endm
    lea eax, KEYBOARD_HANDLER                   ;�������� ��ࠡ��稪 ���뢠��� ���������� �� 21 ��
    mov IDT_KEYBOARD.OFFS_L,ax
    shr eax, 16
    mov IDT_KEYBOARD.OFFS_H,ax
    irpc    N, 0234567                           ;��������� ����� 20, 22-27 �����誠��
        lea eax,DUMMY_IRQ_MASTER
        mov IDT_2&N.OFFS_L, AX
        shr eax,16
        mov IDT_2&N.OFFS_H, AX
    endm
    irpc    N, 89ABCDEF                         ;��������� ����� 28-2F �����誠��
        lea eax,DUMMY_IRQ_SLAVE
        mov IDT_2&N.OFFS_L,ax
        shr eax,16
        mov IDT_2&N.OFFS_H,ax
    endm
    lgdt fword ptr GDT_GDT                      ;����㧨�� ॣ���� GDTR
    lidt fword ptr IDTR                         ;����㧨�� ॣ���� IDTR
    mov eax,cr0                                 ;������� �ࠢ���騩 ॣ���� cr0
    or  al,00000001b                            ;��⠭����� ��� PE � 1
    mov cr0,eax                                 ;������� ��������� cr0 � ⥬ ᠬ� ������� ���饭�� ०��
OVERLOAD_CS:                                    ;��१���㧨�� ᥣ���� ���� �� ��� ���ਯ��
    db  0EAH
    dw  $+4
    dw  CODE_RM_DESC        
OVERLOAD_SEGMENT_REGISTERS:                     ;��२��樠����஢��� ��⠫�� ᥣ����� ॣ����� �� ���ਯ���
    mov ax,DATA_DESC
    mov ds,ax                         
    mov es,ax                         
    mov ax,STACK_DESC
    mov ss,ax                         
    xor ax,ax
    mov fs,ax                                   ;���㫨�� ॣ���� fs
    mov gs,ax                                   ;���㫨�� ॣ���� gs
    lldt ax                                     ;���㫨�� ॣ���� LDTR - �� �ᯮ�짮���� ⠡���� �������� ���ਯ�஢
PREPARE_TO_RETURN:
    push cs                                     ;������� ����
    push offset BACK_TO_RM                      ;���饭�� �窨 ������
    lea  edi,ENTER_PM                           ;������� ��� �室� � ���饭�� ०��
    mov  eax,CODE_PM_DESC                       ;������� ���ਯ�� ���� ���饭���� ०���
    push eax                                    ;������ �� � �⥪
    push edi                                    
REINITIALIAZE_CONTROLLER_FOR_PM:                ;��२��樠����஢��� ����஫��� ���뢠��� �� ����� 20h, 28h
    mov al,00010001b                            ;ICW1 - ��२��樠������ ����஫��� ���뢠���
    out 20h,al                                  ;��२��樠�����㥬 ����騩 ����஫���
    out 0A0h,al                                 ;��२��樠�����㥬 ������ ����஫���
    mov al,20h                                  ;ICW2 - ����� �������� ����� ���뢠���
    out 21h,al                                  ;����饣� ����஫���
    mov al,28h                                  ;ICW2 - ����� �������� ����� ���뢠���
    out 0A1h,al                                 ;�������� ����஫���
    mov al,04h                                  ;ICW3 - ����騩 ����஫��� ������祭 � 3 �����
    out 21h,al       
    mov al,02h                                  ;ICW3 - ������ ����஫��� ������祭 � 3 �����
    out 0A1h,al      
    mov al,11h                                  ;ICW4 - ०�� ᯥ樠�쭮� ������ ���������� ��� ����饣� ����஫���
    out 21h,al        
    mov al,01h                                  ;ICW4 - ०�� ���筮� ������ ���������� ��� �������� ����஫���
    out 0A1h,al       
    mov al, 0                                   ;�����᪨஢��� ���뢠���
    out 21h,al                                  ;����饣� ����஫���
    out 0A1h,al                                 ;�������� ����஫���
ENABLE_INTERRUPTS_0:                            ;������� ��᪨�㥬� � ����᪨�㥬� ���뢠���
    in  al,70h	
	and	al,01111111b                            ;��⠭����� 7 ��� � 0 ��� ����� ����᪨�㥬�� ���뢠���
	out	70h,al
	nop
    sti                                         ;������� ��᪨�㥬� ���뢠���
GO_TO_CODE_PM:                                  ;���室 � ᥣ����� ���� ���饭���� ०���
    db 66h                                      
    retf
BACK_TO_RM:                                     ;��窠 ������ � ॠ��� ०��
    cli                                         ;����� ��᪨�㥬�� ���뢠���
    in  al,70h	                                ;� �� ��᪨�㥬�� ���뢠���
	or	AL,10000000b                            ;��⠭����� 7 ��� � 1 ��� ����� ����᪨�㥬�� ���뢠���
	out	70h,AL
	nop
REINITIALISE_CONTROLLER:                        ;��२��栫����� ����஫��� ���뢠���               
    mov al,00010001b                            ;ICW1 - ��२��樠������ ����஫��� ���뢠���
    out 20h,al                                  ;��२��樠�����㥬 ����騩 ����஫���
    out 0A0h,al                                 ;��२��樠�����㥬 ������ ����஫���
    mov al,8h                                   ;ICW2 - ����� �������� ����� ���뢠���
    out 21h,al                                  ;����饣� ����஫���
    mov al,70h                                  ;ICW2 - ����� �������� ����� ���뢠���
    out 0A1h,al                                 ;�������� ����஫���
    mov al,04h                                  ;ICW3 - ����騩 ����஫��� ������祭 � 3 �����
    out 21h,al       
    mov al,02h                                  ;ICW3 - ������ ����஫��� ������祭 � 3 �����
    out 0A1h,al      
    mov al,11h                                  ;ICW4 - ०�� ᯥ樠�쭮� ������ ���������� ��� ����饣� ����஫���
    out 21h,al        
    mov al,01h                                  ;ICW4 - ०�� ���筮� ������ ���������� ��� �������� ����஫���
    out 0A1h,al
PREPARE_SEGMENTS:                               ;�����⮢�� ᥣ������ ॣ���஢ ��� ������ � ॠ��� ०��          
    mov GDT_CODE_RM.LIMIT,0FFFFh                ;��⠭���� ����� ᥣ���� ���� � 64KB
    mov GDT_DATA.LIMIT,0FFFFh                   ;��⠭���� ����� ᥣ���� ������ � 64KB
    mov GDT_STACK.LIMIT,0FFFFh                  ;��⠭���� ����� ᥣ���� �⥪� � 64KB
    db  0EAH                                    ;��१���㧨�� ॣ���� cs
    dw  $+4
    dw  CODE_RM_DESC                            ;�� ᥣ���� ���� ॠ�쭮�� ०���
    mov ax,DATA_DESC                            ;����㧨� ᥣ����� ॣ����� ���ਯ�஬ ᥣ���� ������
    mov ds,ax                                   
    mov es,ax                                   
    mov fs,ax                                   
    mov gs,ax                                   
    mov ax,STACK_DESC
    mov ss,ax                                   ;����㧨� ॣ���� �⥪� ���ਯ�஬ �⥪�
ENABLE_REAL_MODE:                               ;����稬 ॠ��� ०��
    mov eax,cr0
    and al,11111110b                            ;���㫨� 0 ��� ॣ���� cr0
    mov cr0,eax                        
    db  0EAH
    dw  $+4
    dw  CODE_RM                                 ;��१���㧨� ॣ���� ����
    mov ax,STACK_A
    mov ss,ax                      
    mov ax,DATA
    mov ds,ax                      
    mov es,ax
    xor ax,ax
    mov fs,ax
    mov gs,ax
    mov IDTR.LIMIT, 3FFH                
    mov dword ptr  IDTR+2, 0            
    lidt fword ptr IDTR                 
REPEAIR_MASK:                                   ;����⠭����� ��᪨ ���뢠���
    mov al,INT_MASK_M
    out 21h,al                                  ;����饣� ����஫���
    mov al,INT_MASK_S
    out 0A1h,al                                 ;�������� ����஫���
ENABLE_INTERRUPTS:                              ;������� ��᪨�㥬� � ����᪨�㥬� ���뢠���
    in  al,70h	
	and	al,01111111b                            ;��⠭����� 7 ��� � 0 ��� ࠧ�襭�� ����᪨�㥬�� ���뢠���
	out	70h,al
    nop
    sti                                         ;������� ��᪨�㥬� ���뢠���
DISABLE_A20:                                    ;������� ���⨫� A20
    in  al,92h
    and al,11111101b                            ;���㫨�� 1 ��� - ������� ����� A20
    out 92h, al
EXIT:                                           ;��室 �� �ணࠬ��
    mov ax,3h
    int 10H                                     ;������ �����-०��    
    lea dx,MSG_HELLO_RM
    mov ah,9h
    int 21h                                     ;�뢥�� ᮮ�饭��
    jmp START
END_PROG:
    mov ax,4C00h
    int 21H                                     ;��室 � dos
SIZE_CODE_RM    = ($ - CODE_RM_BEGIN)           ;����� ᥣ���� ����
CODE_RM ends
;������� ���� ॠ�쭮�� ०���
CODE_PM  segment para use32
CODE_PM_BEGIN   = $
    assume cs:CODE_PM,ds:DATA,es:DATA           ;�������� ᥣ���⮢ ��� �������樨
ENTER_PM:                                       ;��窠 �室� � ���饭�� ०��
    call CLRSCR                                 ;��楤�� ���⪨ �࠭�
    xor  edi,edi                                ;� edi ᬥ饭�� �� �࠭�
    lea  esi,MSG_HELLO_PM                       ;� esi ���� ����
    call BUFFER_OUTPUT                          ;�뢥�� ��ப�-�ਢ���⢨� � ���饭��� ०���
    add  edi,160                                ;��ॢ��� ����� �� ᫥������ ��ப�
    lea  esi,MSG_KEYBOARD
    call BUFFER_OUTPUT                          ;�뢥�� ���� ��� �뢮�� ᪠�-���� ����������
WAITING_ESC:                                    ;�������� ������ ������ ��室� �� ���饭���� ०���
    jmp  WAITING_ESC                            ;�᫨ �� ����� �� ESC
EXIT_PM:                                        ;��窠 ��室� �� 32-��⭮�� ᥣ���� ����    
    db 66H
    retf                                        ;���室 � 16-���� ᥣ���� ����
EXIT_FROM_INTERRUPT:                            ;��窠 ��室� ��� ��室� ������� �� ��ࠡ��稪� ���뢠���
    popad
    pop es
    pop ds
    pop eax                                     ;����� � �⥪� ���� EIP
    pop eax                                     ;CS  
    pop eax                                     ;� EFLAGS
    sti                                         ;��易⥫쭮, ��� �⮣� ��ࠡ�⪠ �������� ���뢠��� �⪫�祭�
    db 66H
    retf                                        ;���室 � 16-���� ᥣ���� ����    
M = 0                           
IRPC N, 0123456789ABCDEF
EXC_0&N label word                              ;��ࠡ��稪� �᪫�祭��
    cli 
    jmp EXC_HANDLER
endm
M = 010H
IRPC N, 0123456789ABCDEF                        ;��ࠡ��稪� �᪫�祭��
EXC_1&N label word                          
    cli
    jmp EXC_HANDLER
endm
EXC_HANDLER proc near                           ;��楤�� �뢮�� ��ࠡ�⪨ �᪫�祭��
    call CLRSCR                                 ;���⪠ �࠭�
    lea  esi, MSG_EXC
    mov  edi, 40*2
    call BUFFER_OUTPUT                          ;�뢮� �।�०�����
    pop eax                                     ;����� � �⥪� ���� EIP
    pop eax                                     ;CS  
    pop eax                                     ;� EFLAGS
    sti                                         ;��易⥫쭮, ��� �⮣� ��ࠡ�⪠ �������� ���뢠��� �⪫�祭�
    db 66H
    retf                                        ;���室 � 16-���� ᥣ���� ����    
EXC_HANDLER     ENDP
DUMMY_IRQ_MASTER proc near                      ;�����誠 ��� �������� ���뢠��� ����饣� ����஫���
    push eax
    mov  al,20h
    out  20h,al
    pop  eax
    iretd
DUMMY_IRQ_MASTER endp
DUMMY_IRQ_SLAVE  proc near                      ;�����誠 ��� �������� ���뢠��� �������� ����஫���
    push eax
    mov  al,20h
    out  20h,al
    out  0A0h,al
    pop  eax
    iretd
DUMMY_IRQ_SLAVE  endp
KEYBOARD_HANDLER proc near                      ;��ࠡ��稪 ���뢠��� ����������
    push ds
    push es
    pushad                                      ;���࠭��� ���७�� ॣ����� ��饣� �����祭��
    in   al,60h                                 ;����� ᪠� ��� ��᫥���� ����⮩ ������                                ;
    cmp  al, 1                                  ;�᫨ �� ����� 'ESC'
    jne   KEYBOARD_RETURN                        
    mov  al,20h                                 ;����� �� ��室 �� ���饭���� ०���   
    out  20h,al
    db 0eah
    dd OFFSET EXIT_FROM_INTERRUPT 
    dw CODE_PM_DESC  
KEYBOARD_RETURN:
    mov  al,20h
    out  20h,al                                 ;�⯠ࢪ� ᨣ���� ����஫���� ���뢠���
    popad                                       ;����⠭����� ���祭�� ॣ���஢
    pop es
    pop ds
    iretd                                       ;��室 �� ���뢠���
KEYBOARD_HANDLER endp
CLRSCR  proc near                               ;��楤�� ���⪨ ���᮫�
    push es
    pushad
    mov  ax,TEXT_DESC                           ;�������� � ax ���ਯ�� ⥪��
    mov  es,ax
    xor  edi,edi
    mov  ecx,80*25                              ;������⢮ ᨬ����� � ����
    mov  ax,700h
    rep  stosw
    popad
    pop  es
    ret
CLRSCR  endp
BUFFER_OUTPUT proc near                         ;��楤�� �뢮�� ⥪�⮢��� ����, ����稢��饣��� 0
    push es
    pushad
    mov  ax,TEXT_DESC                           ;�������� � es ᥫ���� ⥪��
    mov  es,ax
OUTPUT_LOOP:                                    ;���� �� �뢮�� ����
    lodsb                                       
    or   al,al
    jz   OUTPUT_EXIT                            ;�᫨ ��諮 �� 0, � ����� ��室�
    stosb
    inc  edi
    jmp  OUTPUT_LOOP
OUTPUT_EXIT:                                    ;��室 �� ��楤��� �뢮��
    popad
    pop  es
    ret
BUFFER_OUTPUT ENDP
SIZE_CODE_PM     =       ($ - CODE_PM_BEGIN)
CODE_PM  ENDS
;������� ������ ॠ�쭮��/���饭���� ०���
DATA    segment para use16                      ;������� ������ ॠ�쭮��/���饭���� ०���
DATA_BEGIN      = $
    ;GDT - ������쭠� ⠡��� ���ਯ�஢
    GDT_BEGIN   = $
    GDT label   word                            ;��⪠ ��砫� GDT (GDT: �� ࠡ�⠥�)
    GDT_0       S_DESC <0,0,0,0,0,0>                              
    GDT_GDT     S_DESC <GDT_SIZE-1,,,ACS_DATA,0,>                 
    GDT_CODE_RM S_DESC <SIZE_CODE_RM-1,,,ACS_CODE,0,>             
    GDT_DATA    S_DESC <SIZE_DATA-1,,,ACS_DATA+ACS_DPL_3,0,>      
    GDT_STACK   S_DESC <1000h-1,,,ACS_DATA,0,>                    
    GDT_TEXT    S_DESC <2000h-1,8000h,0Bh,ACS_DATA+ACS_DPL_3,0,0> 
    GDT_CODE_PM S_DESC <SIZE_CODE_PM-1,,,ACS_CODE+ACS_READ,0,>    
    GDT_IDT     S_DESC <SIZE_IDT-1,,,ACS_IDT,0,>                  
    GDT_SIZE    = ($ - GDT_BEGIN)               ;������ GDT
    ;��������� ᥣ���⮢
    CODE_RM_DESC = (GDT_CODE_RM - GDT_0)
    DATA_DESC    = (GDT_DATA - GDT_0)      
    STACK_DESC   = (GDT_STACK - GDT_0)
    TEXT_DESC    = (GDT_TEXT - GDT_0)  
    CODE_PM_DESC = (GDT_CODE_PM - GDT_0)
    IDT_DESC     = (GDT_IDT - GDT_0)
    ;IDT - ⠡��� ���ਯ�஢ ���뢠���
    IDTR    R_IDTR  <SIZE_IDT,0,0>              ;��ଠ� ॣ���� ITDR   
    IDT label   word                            ;��⪠ ��砫� IDT
    IDT_BEGIN   = $
    IRPC    N, 0123456789ABCDEF
        IDT_0&N I_DESC <0, CODE_PM_DESC,0,ACS_TRAP,0>            ; 00...0F
    ENDM
    IRPC    N, 0123456789ABCDEF
        IDT_1&N I_DESC <0, CODE_PM_DESC, 0, ACS_TRAP, 0>         ; 10...1F
    ENDM
    IDT_20    I_DESC <0,CODE_PM_DESC,0,ACS_INT,0>
    IDT_KEYBOARD I_DESC <0,CODE_PM_DESC,0,ACS_INT,0>             ;IRQ 1 - ���뢠��� ����������
    IRPC    N, 23456789ABCDEF
        IDT_2&N         I_DESC <0, CODE_PM_DESC, 0, ACS_INT, 0>  ; 22...2F
    ENDM
    SIZE_IDT        =       ($ - IDT_BEGIN)
    MSG_HELLO           db "������ 'p', �⮡� ��३� � ���饭�� ०��",13,10,"$"
    MSG_HELLO_PM        db "�� ��室����� � ���饭��� ०���!",0
    MSG_HELLO_RM        db "�� ���㫨�� � ॠ��� ०��",13,10,"$"
    MSG_KEYBOARD        db "������ 'ESC', �⮡� �������� � ॠ��� ०��",0
    MSG_EXC             db "�᪫�祭��: XX",0
    MSG_EXIT            db "������ 'e', �⮡� ���",13,10,"$"
    MSG_ERROR           db "���ࠢ��쭠� �訡��$"
    HEX_TAB             db "0123456789ABCDEF"   ;������ ����஢ �᪫�祭��
    ESP32               dd  1 dup(?)            ;�����⥫� �� ���設� �⥪�
    INT_MASK_M          db  1 dup(?)            ;���祭�� ॣ���� ��᮪ ����饣� ����஫���
    INT_MASK_S          db  1 dup(?)            ;���祭�� ॣ���� ��᮪ �������� ����஫��� 
    
	
SIZE_DATA   = ($ - DATA_BEGIN)                  ;������ ᥣ���� ������
DATA    ends
;������� �⥪� ॠ�쭮��/���饭���� ०���
STACK_A segment para stack
    db  1000h dup(?)
STACK_A  ends
end START
