.386P
.MODEL  LARGE
;‘âàãªâãàë ¤ ­­ëå
S_DESC  struc                                   ;‘âàãªâãà  á¥£¬¥­â­®£® ¤¥áªà¨¯â®à 
    LIMIT       dw 0                            ;‹¨¬¨â á¥£¬¥­â  (15:00)    
    BASE_L      dw 0                            ;€¤à¥á ¡ §ë, ¬« ¤è ï ç áâì (15:0)
    BASE_M      db 0                            ;€¤à¥á ¡ §ë, áà¥¤­ïï ç áâì (23:16)
    ACCESS      db 0                            ; ©â ¤®áâã¯ 
    ATTRIBS     db 0                            ;‹¨¬¨â á¥£¬¥­â  (19:16) ¨  âà¨¡ãâë
    BASE_H      db 0                            ;€¤à¥á ¡ §ë, áâ àè ï ç áâì
S_DESC  ends        
I_DESC  struc                                   ;‘âàãªâãà  ¤¥áªà¨¯â®à  â ¡«¨æë ¯à¥àë¢ ­¨©
    OFFS_L      dw 0                            ;€¤à¥á ®¡à ¡®âç¨ª  (0:15)
    SEL         dw 0                            ;‘¥«¥ªâ®à ª®¤ , á®¤¥à¦ é¥£® ª®¤ ®¡à ¡®âç¨ª 
    PARAM_CNT   db 0                            ; à ¬¥âàë
    ACCESS      db 0                            ;“à®¢¥­ì ¤®áâã¯ 
    OFFS_H      dw 0                            ;€¤à¥á ®¡à ¡®âç¨ª  (31:16)
I_DESC  ends        
R_IDTR  struc                                   ;‘âàãªâãà  IDTR
    LIMIT       dw 0                            
    IDT_L       dw 0                            ;‘¬¥é¥­¨¥ ¡¨âë (0-15)
    IDT_H       dw 0                            ;‘¬¥é¥­¨¥ ¡¨âë (31-16)
R_IDTR  ends
;”« £¨ ãà®¢­¥© ¤®áâã¯  á¥£¬¥­â®¢
ACS_PRESENT     EQU 10000000B                   ;PXXXXXXX - ¡¨â ¯à¨áãâáâ¢¨ï, á¥£¬¥­â ¯à¨áãâáâ¢ã¥â ¢ ®¯¥à â¨¢­®© ¯ ¬ïâ¨
ACS_CSEG        EQU 00011000B                   ;XXXXIXXX - â¨¯ á¥£¬¥­â , ¤«ï ¤ ­­ëå = 0, ¤«ï ª®¤  1
ACS_DSEG        EQU 00010000B                   ;XXXSXXXX - ¡¨â á¥£¬¥­â , ¤ ­­ë© ®¡ê¥ªâ á¥£¬¥­â(á¨áâ¥¬­ë¥ ®¡ê¥ªâë ¬®£ãâ ¡ëâì ­¥ á¥£¬¥­âë)
ACS_READ        EQU 00000010B                   ;XXXXXXRX - ¡¨â çâ¥­¨ï, ¢®§¬®¦­®áâì çâ¥­¨ï ¨§ ¤àã£®£® á¥£¬¥­â 
ACS_WRITE       EQU 00000010B                   ;XXXXXXWX - ¡¨â § ¯¨á¨, ¤«ï á¥£¬¥­â  ¤ ­­ëå à §¥àè ¥â § ¯¨áì
ACS_CODE        =   ACS_PRESENT or ACS_CSEG     ;AR á¥£¬¥­â  ª®¤ 
ACS_DATA =  ACS_PRESENT or ACS_DSEG or ACS_WRITE;AR á¥£¬¥­â  ¤ ­­ëå
ACS_STACK=  ACS_PRESENT or ACS_DSEG or ACS_WRITE;AR á¥£¬¥­â  áâ¥ª 
ACS_INT_GATE    EQU 00001110B
ACS_TRAP_GATE   EQU 00001111B                   ;XXXXSICR - á¥£¬¥­â, ¯®¤ç¨­¥­­ë© á¥£¬¥­â ª®¤ , ¤®áâã¯¥­ ¤«ï çâ¥­¨ï
ACS_IDT         EQU ACS_DATA                    ;AR â ¡«¨æë IDT    
ACS_INT         EQU ACS_PRESENT or ACS_INT_GATE
ACS_TRAP        EQU ACS_PRESENT or ACS_TRAP_GATE
ACS_DPL_3       EQU 01100000B                   ;X<DPL,DPL>XXXXX - ¯à¨¢¥«¥£¨¨ ¤®áâã¯ , ¤®áâã¯ ¬®¦¥â ¯®«ãç¨âì «î¡®© ª®¤
;‘¥£¬¥­â ª®¤  à¥ «ì­®£® à¥¦¨¬        
CODE_RM segment para use16
CODE_RM_BEGIN   = $
    assume cs:CODE_RM,DS:DATA,ES:DATA           ;ˆ­¨æ¨ «¨§ æ¨ï à¥£¨áâà®¢ ¤«ï  áá¥¬¡«¨à®¢ ­¨ï
START:
    mov ax,DATA                                 ;ˆ­¨æ¨ «¨§¨æ¨ï á¥£¬¥­â­ëå à¥£¨áâà®¢
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
    int 21h                                     ;Ž¦¨¤ ­¨¥ ¯®¤â¢¥à¦¤¥­¨ï
    cmp al, 'p'
    je ENABLE_A20
    cmp al, 'e'
    je END_PROG
    jmp ANSWER
ENABLE_A20:                                     ;Žâªàëâì «¨­¨î A20
    in  al,92h                                                                              
    or  al,2                                    ;“áâ ­®¢¨âì ¡¨â 1 ¢ 1                                                   
    out 92h,al                                                                                                                     
    ;ˆ«¨ â ª ¤«ï áâ àëå ª®¬¯ìîâ¥à®¢                                                                                                      0 LINE
    ;mov    al, 0D1h
    ;out    64h, al
    ;mov    al, 0DFh
    ;out    60h, al
SAVE_MASK:                                      ;‘®åà ­¨âì ¬ áª¨ ¯à¥àë¢ ­¨©     
    in      al,21h
    mov     INT_MASK_M,al                  
    in      al,0A1h
    mov     INT_MASK_S,al                 
DISABLE_INTERRUPTS:                             ;‡ ¯à¥â ¬ áª¨àã¥¬ëå ¨ ­¥¬ áª¨àã¥¬ëå ¯à¥àë¢ ­¨©        
    cli                                         ;‡ ¯à¥â ¬ áª¨àã¬ëå ¯à¥àë¢ ­¨©
    in  al,70h	
	or	al,10000000b                            ;“áâ ­®¢¨âì 7 ¡¨â ¢ 1 ¤«ï § ¯à¥â  ­¥¬ áª¨àã¥¬ëå ¯à¥àë¢ ­¨©
	out	70h,al
	nop	
LOAD_GDT:                                       ;‡ ¯®«­¨âì £«®¡ «ì­ãî â ¡«¨æã ¤¥áªà¨¯â®à®¢            
    mov ax,DATA
    mov dl,ah
    xor dh,dh
    shl ax,4
    shr dx,4
    mov si,ax
    mov di,dx
WRITE_GDT:                                      ;‡ ¯®«­¨âì ¤¥áªà¨¯â®à GDT
    lea bx,GDT_GDT
    mov ax,si
    mov dx,di
    add ax,offset GDT
    adc dx,0
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_CODE_RM:                                  ;‡ ¯®«­¨âì ¤¥áªà¨¯â®à á¥£¬¥­â  ª®¤  à¥ «ì­®£® à¥¦¨¬ 
    lea bx,GDT_CODE_RM
    mov ax,cs
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_DATA:                                     ;‡ ¯¨á âì ¤¥áªà¨¯â®à á¥£¬¥­â  ¤ ­­ëå
    lea bx,GDT_DATA
    mov ax,si
    mov dx,di
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_STACK:                                    ;‡ ¯¨á âì ¤¥áªà¨¯â®à á¥£¬¥­â  áâ¥ª 
    lea bx, GDT_STACK
    mov ax,ss
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_CODE_PM:                                  ;‡ ¯¨á âì ¤¥áªà¨¯â®à ª®¤  § é¨é¥­­®£® à¥¦¨¬ 
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
WRITE_IDT:                                      ;‡ ¯¨á âì ¤¥áªà¨¯â®à IDT
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
FILL_IDT:                                       ;‡ ¯®«­¨âì â ¡«¨æã ¤¥áªà¨¯â®à®¢ è«î§®¢ ¯à¥àë¢ ­¨©
    irpc    N, 0123456789ABCDEF                 ;‡ ¯®«­¨âì è«î§ë 00-0F ¨áª«îç¥­¨ï¬¨
        lea eax, EXC_0&N
        mov IDT_0&N.OFFS_L,ax
        shr eax, 16
        mov IDT_0&N.OFFS_H,ax
    endm
    irpc    N, 0123456789ABCDEF                 ;‡ ¯®«­¨âì è«î§ë 10-1F ¨áª«îç¥­¨ï¬¨
        lea eax, EXC_1&N
        mov IDT_1&N.OFFS_L,ax
        shr eax, 16
        mov IDT_1&N.OFFS_H,ax
    endm
    lea eax, KEYBOARD_HANDLER                   ;®¬¥áâ¨âì ®¡à ¡®âç¨ª ¯à¥àë¢ ­¨ï ª« ¢¨ âãàë ­  21 è«î§
    mov IDT_KEYBOARD.OFFS_L,ax
    shr eax, 16
    mov IDT_KEYBOARD.OFFS_H,ax
    irpc    N, 0234567                           ;‡ ¯®«­¨âì ¢¥ªâ®à  20, 22-27 § £«ãèª ¬¨
        lea eax,DUMMY_IRQ_MASTER
        mov IDT_2&N.OFFS_L, AX
        shr eax,16
        mov IDT_2&N.OFFS_H, AX
    endm
    irpc    N, 89ABCDEF                         ;‡ ¯®«­¨âì ¢¥ªâ®à  28-2F § £«ãèª ¬¨
        lea eax,DUMMY_IRQ_SLAVE
        mov IDT_2&N.OFFS_L,ax
        shr eax,16
        mov IDT_2&N.OFFS_H,ax
    endm
    lgdt fword ptr GDT_GDT                      ;‡ £àã§¨âì à¥£¨áâà GDTR
    lidt fword ptr IDTR                         ;‡ £àã§¨âì à¥£¨áâà IDTR
    mov eax,cr0                                 ;®«ãç¨âì ã¯à ¢«ïîé¨© à¥£¨áâà cr0
    or  al,00000001b                            ;“áâ ­®¢¨âì ¡¨â PE ¢ 1
    mov cr0,eax                                 ;‡ ¯¨á âì ¨§¬¥­¥­­ë© cr0 ¨ â¥¬ á ¬ë¬ ¢ª«îç¨âì § é¨é¥­­ë© à¥¦¨¬
OVERLOAD_CS:                                    ;¥à¥§ £àã§¨âì á¥£¬¥­â ª®¤  ­  ¥£® ¤¥áªà¨¯â®à
    db  0EAH
    dw  $+4
    dw  CODE_RM_DESC        
OVERLOAD_SEGMENT_REGISTERS:                     ;¥à¥¨­¨æ¨ «¨§¨à®¢ âì ®áâ «ì­ë¥ á¥£¬¥­â­ë¥ à¥£¨áâàë ­  ¤¥áªà¨¯â®àë
    mov ax,DATA_DESC
    mov ds,ax                         
    mov es,ax                         
    mov ax,STACK_DESC
    mov ss,ax                         
    xor ax,ax
    mov fs,ax                                   ;Ž¡­ã«¨âì à¥£¨áâà fs
    mov gs,ax                                   ;Ž¡­ã«¨âì à¥£¨áâà gs
    lldt ax                                     ;Ž¡­ã«¨âì à¥£¨áâà LDTR - ­¥ ¨á¯®«ì§®¢ âì â ¡«¨æë «®ª «ì­ëå ¤¥áªà¨¯â®à®¢
PREPARE_TO_RETURN:
    push cs                                     ;‘¥£¬¥­â ª®¤ 
    push offset BACK_TO_RM                      ;‘¬¥é¥­¨¥ â®çª¨ ¢®§¢à â 
    lea  edi,ENTER_PM                           ;®«ãç¨âì â®çªã ¢å®¤  ¢ § é¨é¥­­ë© à¥¦¨¬
    mov  eax,CODE_PM_DESC                       ;®«ãç¨âì ¤¥áªà¨¯â®à ª®¤  § é¨é¥­­®£® à¥¦¨¬ 
    push eax                                    ;‡ ­¥áâ¨ ¨å ¢ áâ¥ª
    push edi                                    
REINITIALIAZE_CONTROLLER_FOR_PM:                ;¥à¥¨­¨æ¨ «¨§¨à®¢ âì ª®­âà®««¥à ¯à¥àë¢ ­¨© ­  ¢¥ªâ®à  20h, 28h
    mov al,00010001b                            ;ICW1 - ¯¥à¥¨­¨æ¨ «¨§ æ¨ï ª®­âà®««¥à  ¯à¥àë¢ ­¨©
    out 20h,al                                  ;¥à¥¨­¨æ¨ «¨§¨àã¥¬ ¢¥¤ãé¨© ª®­âà®««¥à
    out 0A0h,al                                 ;¥à¥¨­¨æ¨ «¨§¨àã¥¬ ¢¥¤®¬ë© ª®­âà®««¥à
    mov al,20h                                  ;ICW2 - ­®¬¥à ¡ §®¢®£® ¢¥ªâ®à  ¯à¥àë¢ ­¨©
    out 21h,al                                  ;¢¥¤ãé¥£® ª®­âà®««¥à 
    mov al,28h                                  ;ICW2 - ­®¬¥à ¡ §®¢®£® ¢¥ªâ®à  ¯à¥àë¢ ­¨©
    out 0A1h,al                                 ;¢¥¤®¬®£® ª®­âà®««¥à 
    mov al,04h                                  ;ICW3 - ¢¥¤ãé¨© ª®­âà®««¥à ¯®¤ª«îç¥­ ª 3 «¨­¨¨
    out 21h,al       
    mov al,02h                                  ;ICW3 - ¢¥¤®¬ë© ª®­âà®««¥à ¯®¤ª«îç¥­ ª 3 «¨­¨¨
    out 0A1h,al      
    mov al,11h                                  ;ICW4 - à¥¦¨¬ á¯¥æ¨ «ì­®© ¯®«­®© ¢«®¦¥­­®áâ¨ ¤«ï ¢¥¤ãé¥£® ª®­âà®««¥à 
    out 21h,al        
    mov al,01h                                  ;ICW4 - à¥¦¨¬ ®¡ëç­®© ¯®«­®© ¢«®¦¥­­®áâ¨ ¤«ï ¢¥¤®¬®£® ª®­âà®««¥à 
    out 0A1h,al       
    mov al, 0                                   ; §¬ áª¨à®¢ âì ¯à¥àë¢ ­¨ï
    out 21h,al                                  ;‚¥¤ãé¥£® ª®­âà®««¥à 
    out 0A1h,al                                 ;‚¥¤®¬®£® ª®­âà®««¥à 
ENABLE_INTERRUPTS_0:                            ; §à¥è¨âì ¬ áª¨àã¥¬ë¥ ¨ ­¥¬ áª¨àã¥¬ë¥ ¯à¥àë¢ ­¨ï
    in  al,70h	
	and	al,01111111b                            ;“áâ ­®¢¨âì 7 ¡¨â ¢ 0 ¤«ï § ¯à¥â  ­¥¬ áª¨àã¥¬ëå ¯à¥àë¢ ­¨©
	out	70h,al
	nop
    sti                                         ; §à¥è¨âì ¬ áª¨àã¥¬ë¥ ¯à¥àë¢ ­¨ï
GO_TO_CODE_PM:                                  ;¥à¥å®¤ ª á¥£¬¥­âã ª®¤  § é¨é¥­­®£® à¥¦¨¬ 
    db 66h                                      
    retf
BACK_TO_RM:                                     ;’®çª  ¢®§¢à â  ¢ à¥ «ì­ë© à¥¦¨¬
    cli                                         ;‡ ¯à¥â ¬ áª¨àã¥¬ëå ¯à¥àë¢ ­¨©
    in  al,70h	                                ;ˆ ­¥ ¬ áª¨àã¥¬ëå ¯à¥àë¢ ­¨©
	or	AL,10000000b                            ;“áâ ­®¢¨âì 7 ¡¨â ¢ 1 ¤«ï § ¯à¥â  ­¥¬ áª¨àã¥¬ëå ¯à¥àë¢ ­¨©
	out	70h,AL
	nop
REINITIALISE_CONTROLLER:                        ;¥à¥¨­¨æ «¨§ æ¨ï ª®­âà®««¥à  ¯à¥àë¢ ­¨©               
    mov al,00010001b                            ;ICW1 - ¯¥à¥¨­¨æ¨ «¨§ æ¨ï ª®­âà®««¥à  ¯à¥àë¢ ­¨©
    out 20h,al                                  ;¥à¥¨­¨æ¨ «¨§¨àã¥¬ ¢¥¤ãé¨© ª®­âà®««¥à
    out 0A0h,al                                 ;¥à¥¨­¨æ¨ «¨§¨àã¥¬ ¢¥¤®¬ë© ª®­âà®««¥à
    mov al,8h                                   ;ICW2 - ­®¬¥à ¡ §®¢®£® ¢¥ªâ®à  ¯à¥àë¢ ­¨©
    out 21h,al                                  ;¢¥¤ãé¥£® ª®­âà®««¥à 
    mov al,70h                                  ;ICW2 - ­®¬¥à ¡ §®¢®£® ¢¥ªâ®à  ¯à¥àë¢ ­¨©
    out 0A1h,al                                 ;¢¥¤®¬®£® ª®­âà®««¥à 
    mov al,04h                                  ;ICW3 - ¢¥¤ãé¨© ª®­âà®««¥à ¯®¤ª«îç¥­ ª 3 «¨­¨¨
    out 21h,al       
    mov al,02h                                  ;ICW3 - ¢¥¤®¬ë© ª®­âà®««¥à ¯®¤ª«îç¥­ ª 3 «¨­¨¨
    out 0A1h,al      
    mov al,11h                                  ;ICW4 - à¥¦¨¬ á¯¥æ¨ «ì­®© ¯®«­®© ¢«®¦¥­­®áâ¨ ¤«ï ¢¥¤ãé¥£® ª®­âà®««¥à 
    out 21h,al        
    mov al,01h                                  ;ICW4 - à¥¦¨¬ ®¡ëç­®© ¯®«­®© ¢«®¦¥­­®áâ¨ ¤«ï ¢¥¤®¬®£® ª®­âà®««¥à 
    out 0A1h,al
PREPARE_SEGMENTS:                               ;®¤£®â®¢ª  á¥£¬¥­â­ëå à¥£¨áâà®¢ ¤«ï ¢®§¢à â  ¢ à¥ «ì­ë© à¥¦¨¬          
    mov GDT_CODE_RM.LIMIT,0FFFFh                ;“áâ ­®¢ª  «¨¬¨â  á¥£¬¥­â  ª®¤  ¢ 64KB
    mov GDT_DATA.LIMIT,0FFFFh                   ;“áâ ­®¢ª  «¨¬¨â  á¥£¬¥­â  ¤ ­­ëå ¢ 64KB
    mov GDT_STACK.LIMIT,0FFFFh                  ;“áâ ­®¢ª  «¨¬¨â  á¥£¬¥­â  áâ¥ª  ¢ 64KB
    db  0EAH                                    ;¥à¥§ £àã§¨âì à¥£¨áâà cs
    dw  $+4
    dw  CODE_RM_DESC                            ;  á¥£¬¥­â ª®¤  à¥ «ì­®£® à¥¦¨¬ 
    mov ax,DATA_DESC                            ;‡ £àã§¨¬ á¥£¬¥­â­ë¥ à¥£¨áâàë ¤¥áªà¨¯â®à®¬ á¥£¬¥­â  ¤ ­­ëå
    mov ds,ax                                   
    mov es,ax                                   
    mov fs,ax                                   
    mov gs,ax                                   
    mov ax,STACK_DESC
    mov ss,ax                                   ;‡ £àã§¨¬ à¥£¨áâà áâ¥ª  ¤¥áªà¨¯â®à®¬ áâ¥ª 
ENABLE_REAL_MODE:                               ;‚ª«îç¨¬ à¥ «ì­ë© à¥¦¨¬
    mov eax,cr0
    and al,11111110b                            ;Ž¡­ã«¨¬ 0 ¡¨â à¥£¨áâà  cr0
    mov cr0,eax                        
    db  0EAH
    dw  $+4
    dw  CODE_RM                                 ;¥à¥§ £àã§¨¬ à¥£¨áâà ª®¤ 
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
REPEAIR_MASK:                                   ;‚®ááâ ­®¢¨âì ¬ áª¨ ¯à¥àë¢ ­¨©
    mov al,INT_MASK_M
    out 21h,al                                  ;‚¥¤ãé¥£® ª®­âà®««¥à 
    mov al,INT_MASK_S
    out 0A1h,al                                 ;‚¥¤®¬®£® ª®­âà®««¥à 
ENABLE_INTERRUPTS:                              ; §à¥è¨âì ¬ áª¨àã¥¬ë¥ ¨ ­¥¬ áª¨àã¥¬ë¥ ¯à¥àë¢ ­¨ï
    in  al,70h	
	and	al,01111111b                            ;“áâ ­®¢¨âì 7 ¡¨â ¢ 0 ¤«ï à §à¥è¥­¨ï ­¥¬ áª¨àã¥¬ëå ¯à¥àë¢ ­¨©
	out	70h,al
    nop
    sti                                         ; §à¥è¨âì ¬ áª¨àã¥¬ë¥ ¯à¥àë¢ ­¨ï
DISABLE_A20:                                    ;‡ ªàëâì ¢¥­â¨«ì A20
    in  al,92h
    and al,11111101b                            ;Ž¡­ã«¨âì 1 ¡¨â - § ¯à¥â¨âì «¨­¨î A20
    out 92h, al
EXIT:                                           ;‚ëå®¤ ¨§ ¯à®£à ¬¬ë
    mov ax,3h
    int 10H                                     ;Žç¨áâ¨âì ¢¨¤¥®-à¥¦¨¬    
    lea dx,MSG_HELLO_RM
    mov ah,9h
    int 21h                                     ;‚ë¢¥áâ¨ á®®¡é¥­¨¥
    jmp START
END_PROG:
    mov ax,4C00h
    int 21H                                     ;‚ëå®¤ ¢ dos
SIZE_CODE_RM    = ($ - CODE_RM_BEGIN)           ;‹¨¬¨â á¥£¬¥­â  ª®¤ 
CODE_RM ends
;‘¥£¬¥­â ª®¤  à¥ «ì­®£® à¥¦¨¬ 
CODE_PM  segment para use32
CODE_PM_BEGIN   = $
    assume cs:CODE_PM,ds:DATA,es:DATA           ;“ª § ­¨¥ á¥£¬¥­â®¢ ¤«ï ª®¬¯¨«ïæ¨¨
ENTER_PM:                                       ;’®çª  ¢å®¤  ¢ § é¨é¥­­ë© à¥¦¨¬
    call CLRSCR                                 ;à®æ¥¤ãà  ®ç¨áâª¨ íªà ­ 
    xor  edi,edi                                ;‚ edi á¬¥é¥­¨¥ ­  íªà ­¥
    lea  esi,MSG_HELLO_PM                       ;‚ esi  ¤à¥á ¡ãä¥à 
    call BUFFER_OUTPUT                          ;‚ë¢¥áâ¨ áâà®ªã-¯à¨¢¥âáâ¢¨¥ ¢ § é¨é¥­­®¬ à¥¦¨¬¥
    add  edi,160                                ;¥à¥¢¥áâ¨ ªãàá®à ­  á«¥¤ãîéãî áâà®ªã
    lea  esi,MSG_KEYBOARD
    call BUFFER_OUTPUT                          ;‚ë¢¥áâ¨ ¯®«¥ ¤«ï ¢ë¢®¤  áª ­-ª®¤  ª« ¢¨ âãàë
WAITING_ESC:                                    ;Ž¦¨¤ ­¨¥ ­ ¦ â¨ï ª­®¯ª¨ ¢ëå®¤  ¨§ § é¨é¥­­®£® à¥¦¨¬ 
    jmp  WAITING_ESC                            ;…á«¨ ¡ë« ­ ¦ â ­¥ ESC
EXIT_PM:                                        ;’®çª  ¢ëå®¤  ¨§ 32-¡¨â­®£® á¥£¬¥­â  ª®¤     
    db 66H
    retf                                        ;¥à¥å®¤ ¢ 16-¡¨â­ë© á¥£¬¥­â ª®¤ 
EXIT_FROM_INTERRUPT:                            ;’®çª  ¢ëå®¤  ¤«ï ¢ëå®¤  ­ ¯àï¬ãî ¨§ ®¡à ¡®âç¨ª  ¯à¥àë¢ ­¨©
    popad
    pop es
    pop ds
    pop eax                                     ;‘­ïâì á® áâ¥ª  áâ àë© EIP
    pop eax                                     ;CS  
    pop eax                                     ;ˆ EFLAGS
    sti                                         ;Ž¡ï§ â¥«ì­®, ¡¥§ íâ®£® ®¡à ¡®âª   ¯¯ à â­ëå ¯à¥àë¢ ­¨© ®âª«îç¥­ 
    db 66H
    retf                                        ;¥à¥å®¤ ¢ 16-¡¨â­ë© á¥£¬¥­â ª®¤     
M = 0                           
IRPC N, 0123456789ABCDEF
EXC_0&N label word                              ;Ž¡à ¡®âç¨ª¨ ¨áª«îç¥­¨©
    cli 
    jmp EXC_HANDLER
endm
M = 010H
IRPC N, 0123456789ABCDEF                        ;Ž¡à ¡®âç¨ª¨ ¨áª«îç¥­¨©
EXC_1&N label word                          
    cli
    jmp EXC_HANDLER
endm
EXC_HANDLER proc near                           ;à®æ¥¤ãà  ¢ë¢®¤  ®¡à ¡®âª¨ ¨áª«îç¥­¨©
    call CLRSCR                                 ;Žç¨áâª  íªà ­ 
    lea  esi, MSG_EXC
    mov  edi, 40*2
    call BUFFER_OUTPUT                          ;‚ë¢®¤ ¯à¥¤ã¯à¥¦¤¥­¨ï
    pop eax                                     ;‘­ïâì á® áâ¥ª  áâ àë© EIP
    pop eax                                     ;CS  
    pop eax                                     ;ˆ EFLAGS
    sti                                         ;Ž¡ï§ â¥«ì­®, ¡¥§ íâ®£® ®¡à ¡®âª   ¯¯ à â­ëå ¯à¥àë¢ ­¨© ®âª«îç¥­ 
    db 66H
    retf                                        ;¥à¥å®¤ ¢ 16-¡¨â­ë© á¥£¬¥­â ª®¤     
EXC_HANDLER     ENDP
DUMMY_IRQ_MASTER proc near                      ;‡ £«ãèª  ¤«ï  ¯¯ à â­ëå ¯à¥àë¢ ­¨© ¢¥¤ãé¥£® ª®­âà®««¥à 
    push eax
    mov  al,20h
    out  20h,al
    pop  eax
    iretd
DUMMY_IRQ_MASTER endp
DUMMY_IRQ_SLAVE  proc near                      ;‡ £«ãèª  ¤«ï  ¯¯ à â­ëå ¯à¥àë¢ ­¨© ¢¥¤®¬®£® ª®­âà®««¥à 
    push eax
    mov  al,20h
    out  20h,al
    out  0A0h,al
    pop  eax
    iretd
DUMMY_IRQ_SLAVE  endp
KEYBOARD_HANDLER proc near                      ;Ž¡à ¡®âç¨ª ¯à¥àë¢ ­¨ï ª« ¢¨ âãàë
    push ds
    push es
    pushad                                      ;‘®åà ­¨âì à áè¨à¥­­ë¥ à¥£¨áâàë ®¡é¥£® ­ §­ ç¥­¨ï
    in   al,60h                                 ;‘ç¨â âì áª ­ ª®¤ ¯®á«¥¤­¥© ­ ¦ â®© ª« ¢¨è¨                                ;
    cmp  al, 1                                  ;…á«¨ ¡ë« ­ ¦ â 'ESC'
    jne   KEYBOARD_RETURN                        
    mov  al,20h                                 ;’®£¤  ­  ¢ëå®¤ ¨§ § é¨é¥­­®£® à¥¦¨¬    
    out  20h,al
    db 0eah
    dd OFFSET EXIT_FROM_INTERRUPT 
    dw CODE_PM_DESC  
KEYBOARD_RETURN:
    mov  al,20h
    out  20h,al                                 ;Žâ¯ à¢ª  á¨£­ «  ª®­âà®««¥àã ¯à¥àë¢ ­¨©
    popad                                       ;‚®ááâ ­®¢¨âì §­ ç¥­¨ï à¥£¨áâà®¢
    pop es
    pop ds
    iretd                                       ;‚ëå®¤ ¨§ ¯à¥àë¢ ­¨ï
KEYBOARD_HANDLER endp
CLRSCR  proc near                               ;à®æ¥¤ãà  ®ç¨áâª¨ ª®­á®«¨
    push es
    pushad
    mov  ax,TEXT_DESC                           ;®¬¥áâ¨âì ¢ ax ¤¥áªà¨¯â®à â¥ªáâ 
    mov  es,ax
    xor  edi,edi
    mov  ecx,80*25                              ;Š®«¨ç¥áâ¢® á¨¬¢®«®¢ ¢ ®ª­¥
    mov  ax,700h
    rep  stosw
    popad
    pop  es
    ret
CLRSCR  endp
BUFFER_OUTPUT proc near                         ;à®æ¥¤ãà  ¢ë¢®¤  â¥ªáâ®¢®£® ¡ãä¥à , ®ª ­ç¨¢ îé¥£®áï 0
    push es
    pushad
    mov  ax,TEXT_DESC                           ;®¬¥áâ¨âì ¢ es á¥«¥ªâ®à â¥ªáâ 
    mov  es,ax
OUTPUT_LOOP:                                    ;–¨ª« ¯® ¢ë¢®¤ã ¡ãä¥à 
    lodsb                                       
    or   al,al
    jz   OUTPUT_EXIT                            ;…á«¨ ¤®è«® ¤® 0, â® ª®­¥æ ¢ëå®¤ 
    stosb
    inc  edi
    jmp  OUTPUT_LOOP
OUTPUT_EXIT:                                    ;‚ëå®¤ ¨§ ¯à®æ¥¤ãàë ¢ë¢®¤ 
    popad
    pop  es
    ret
BUFFER_OUTPUT ENDP
SIZE_CODE_PM     =       ($ - CODE_PM_BEGIN)
CODE_PM  ENDS
;‘¥£¬¥­â ¤ ­­ëå à¥ «ì­®£®/§ é¨é¥­­®£® à¥¦¨¬ 
DATA    segment para use16                      ;‘¥£¬¥­â ¤ ­­ëå à¥ «ì­®£®/§ é¨é¥­­®£® à¥¦¨¬ 
DATA_BEGIN      = $
    ;GDT - £«®¡ «ì­ ï â ¡«¨æ  ¤¥áªà¨¯â®à®¢
    GDT_BEGIN   = $
    GDT label   word                            ;Œ¥âª  ­ ç «  GDT (GDT: ­¥ à ¡®â ¥â)
    GDT_0       S_DESC <0,0,0,0,0,0>                              
    GDT_GDT     S_DESC <GDT_SIZE-1,,,ACS_DATA,0,>                 
    GDT_CODE_RM S_DESC <SIZE_CODE_RM-1,,,ACS_CODE,0,>             
    GDT_DATA    S_DESC <SIZE_DATA-1,,,ACS_DATA+ACS_DPL_3,0,>      
    GDT_STACK   S_DESC <1000h-1,,,ACS_DATA,0,>                    
    GDT_TEXT    S_DESC <2000h-1,8000h,0Bh,ACS_DATA+ACS_DPL_3,0,0> 
    GDT_CODE_PM S_DESC <SIZE_CODE_PM-1,,,ACS_CODE+ACS_READ,0,>    
    GDT_IDT     S_DESC <SIZE_IDT-1,,,ACS_IDT,0,>                  
    GDT_SIZE    = ($ - GDT_BEGIN)               ; §¬¥à GDT
    ;‘¥««¥ªâ®àë á¥£¬¥­â®¢
    CODE_RM_DESC = (GDT_CODE_RM - GDT_0)
    DATA_DESC    = (GDT_DATA - GDT_0)      
    STACK_DESC   = (GDT_STACK - GDT_0)
    TEXT_DESC    = (GDT_TEXT - GDT_0)  
    CODE_PM_DESC = (GDT_CODE_PM - GDT_0)
    IDT_DESC     = (GDT_IDT - GDT_0)
    ;IDT - â ¡«¨æ  ¤¥áªà¨¯â®à®¢ ¯à¥àë¢ ­¨©
    IDTR    R_IDTR  <SIZE_IDT,0,0>              ;”®à¬ â à¥£¨áâà  ITDR   
    IDT label   word                            ;Œ¥âª  ­ ç «  IDT
    IDT_BEGIN   = $
    IRPC    N, 0123456789ABCDEF
        IDT_0&N I_DESC <0, CODE_PM_DESC,0,ACS_TRAP,0>            ; 00...0F
    ENDM
    IRPC    N, 0123456789ABCDEF
        IDT_1&N I_DESC <0, CODE_PM_DESC, 0, ACS_TRAP, 0>         ; 10...1F
    ENDM
    IDT_20    I_DESC <0,CODE_PM_DESC,0,ACS_INT,0>
    IDT_KEYBOARD I_DESC <0,CODE_PM_DESC,0,ACS_INT,0>             ;IRQ 1 - ¯à¥àë¢ ­¨¥ ª« ¢¨ âãàë
    IRPC    N, 23456789ABCDEF
        IDT_2&N         I_DESC <0, CODE_PM_DESC, 0, ACS_INT, 0>  ; 22...2F
    ENDM
    SIZE_IDT        =       ($ - IDT_BEGIN)
    MSG_HELLO           db " ¦¬¨â¥ 'p', çâ®¡ë ¯¥à¥©â¨ ¢ § é¨é¥­­ë© à¥¦¨¬",13,10,"$"
    MSG_HELLO_PM        db "‚ë ­ å®¤¨â¥áâì ¢ § é¨é¥­­®¬ à¥¦¨¬¥!",0
    MSG_HELLO_RM        db "‚ë ¢¥à­ã«¨áì ¢ à¥ «ì­ë© à¥¦¨¬",13,10,"$"
    MSG_KEYBOARD        db " ¦¬¨â¥ 'ESC', çâ®¡ë ¢¥à­ãâìáï ¢ à¥ «ì­ë© à¥¦¨¬",0
    MSG_EXC             db "ˆáª«îç¥­¨¥: XX",0
    MSG_EXIT            db " ¦¬¨â¥ 'e', çâ®¡ë ¢ë©â¨",13,10,"$"
    MSG_ERROR           db "¥¯à ¢¨«ì­ ï ®è¨¡ª $"
    HEX_TAB             db "0123456789ABCDEF"   ;’ ¡«¨æ  ­®¬¥à®¢ ¨áª«îç¥­¨©
    ESP32               dd  1 dup(?)            ;“ª § â¥«ì ­  ¢¥àè¨­ã áâ¥ª 
    INT_MASK_M          db  1 dup(?)            ;‡­ ç¥­¨¥ à¥£¨áâà  ¬ á®ª ¢¥¤ãé¥£® ª®­âà®««¥à 
    INT_MASK_S          db  1 dup(?)            ;‡­ ç¥­¨¥ à¥£¨áâà  ¬ á®ª ¢¥¤®¬®£® ª®­âà®««¥à  
    
SIZE_DATA   = ($ - DATA_BEGIN)                  ; §¬¥à á¥£¬¥­â  ¤ ­­ëå
DATA    ends
;‘¥£¬¥­â áâ¥ª  à¥ «ì­®£®/§ é¨é¥­­®£® à¥¦¨¬ 
STACK_A segment para stack
    db  1000h dup(?)
STACK_A  ends
end START
