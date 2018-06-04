;suma,resta,multiplicacion de 2 numeros fraccionarios
;Modificado Aaron Gutierrez A.K.A EL PRRO MALO 31/5/2018

.model small
.stack 100h
.data
  ENT    equ 0dh
  BIOS   equ 21h  

  ms    db         10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,13,'          ---> s para salir',10,13,'          ---> c para borrar',10,10,13,'         -------------:v-------------$'
  pan1  db      10,13,'         +---------------------------+$'
  pan2  db      10,13,'         +                           +$'
  pan22  db      10,13,'         +ERROR                      +$'
  lin1  db      10,13,'         +---------------------------+$'
  lin2  db      10,13,'         | +---+ +---+ +---+   +---+ |$' ;Se define la interfaz grafica
  lin3  db      10,13,'         | | 1 | | 2 | | 3 |   | + | |$'
  lin4  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin5  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin6  db      10,13,'         | | 4 | | 5 | | 6 |   | - | |$'
  lin7  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin8  db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin9  db      10,13,'         | | 7 | | 8 | | 9 |   | c | |$'
  lin10 db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin11 db      10,13,'         | +---+ +---+ +---+   +---+ |$'
  lin12 db      10,13,'         | | * | | 0 | | / |   | s | |$'       ;Cada uno de los supuestos botones realiza algo
  lin13 db      10,13,'         | +---+ +---+ +---+   +---+ |$'       ;Al presionar 'c' --> "limpia pantalla" y vuelve a iniciar
  lin14 db       10,13,'         +---------------------------+$'        ;Al presionar 's' --> Sale del programa
  op    db  ?  ;variable que almacena el operador
Divid1  db 100 dup('$')
divsor1 db 100 dup('$')
Divid2  db 100 dup('$')
divsor2 db 100 dup('$')
Resul   db 100 dup('$')
divodivs db 0
mens    db 0
operando dw 0
multiplos db 2,3,5,7,11,13
tamDivd1 dw 0
tamDivS1 dw 0
tamDivd2 dw 0
tamDivS2 dw 0
tamres   dw 0


Decdividendo   dw 0
Decdividendo2  dw 0
Decdivisor     dw 0
Decdivisor2    dw 0
DividendoFinal dw 0
DivisorFinal   dw 0



.code
.486
   main proc
        mov ax,@data
        mov ds,ax
        mov mens,0
menu1:  call menu  ;Mandamos llamar al procedimiento menu

        call leecar          ;Mandamos llamar al procedimiento leecar el cual lee un caracter
        

fin:
       mov ah,4ch
        int 21h
   main endp



;***********************************LEER
   leecar proc near
      
        xor si,si
        call menu
        call set_position
        call set_cursor
   
   Dividendo1:

        mov ah,1                ;Servicio 1 para leer un caracter
        int 21h   ;El caracter leido se almacena en al        
        cmp al,'/'   ;Comparamos nuestra variable bandera
        je divisor1
        cmp al,'c'
        je limpiaPantalla
        cmp al,'s'
        je fin
        cmp al,'a'
        jge imposible
        mov divid1[si],al
        inc si
        inc tamdivd1
        jmp dividendo1        ;Sino entonces queremos capturar un operador
        
        divisor1:
        xor si,si

        
        dvs1:
        mov ah,1                ;Servicio 1 para leer un caracter
        int 21h   ;El caracter leido se almacena en al
        cmp al,'/'   ;Comparamos nuestra variable bandera
        je dividendo2
        cmp al,'+'   ;Comparamos nuestra variable bandera
        je dividendo2
        cmp al,'-'   ;Comparamos nuestra variable bandera
        je dividendo2
        cmp al,'*'   ;Comparamos nuestra variable bandera
        je dividendo2
        cmp al,'c'
        je limpiaPantalla
        cmp al,'s'
        je fin
        cmp al,'a'
        jge imposible
        mov divsor1[si],al
        inc si
        inc tamdivs1;
        jmp dvs1        ;Sino entonces queremos capturar un operador
        
        dividendo2:
        mov op,al
        xor si,si
        dvd2:
        mov ah,1                ;Servicio 1 para leer un caracter
        int 21h   ;El caracter leido se almacena en al
        
        
        cmp al,'/'   ;Comparamos nuestra variable bandera
        je divisor2
        cmp al,'c'
        je limpiaPantalla
        cmp al,'s'
        je fin
        cmp al,'a'
        jge imposible
        
        mov divid2[si],al
        inc si
        inc tamdivd2
        jmp dvd2        ;Sino entonces queremos capturar un operador
                
        divisor2:
        xor si,si
        dvs2:
        mov ah,1                ;Servicio 1 para leer un caracter
        int 21h   ;El caracter leido se almacena en al
        

        cmp al,ent
        je convertir
        
        cmp al,'c'
        je limpiaPantalla
        cmp al,'s'
        je fin
        cmp al,'a'
        jge imposible
        
        mov divsor2[si],al
        inc si
        inc tamdivs2;
        jmp dvs2        ;Sino entonces queremos capturar un operador
        
        
        limpiaPantalla:
        call menu
        call set_position
        call cleanArrays
        call leecar
        
        
        convertir:
        xor si,si
        xor cx,cx
        
        mov bx,tamDivd1
        mov si,offset divid1
        call conversionExp1
        mov decdividendo,cx
        
        xor si,si
        xor bx,bx
        
        mov bx,tamDivd2
        mov si,offset divid2
        call conversionExp1
        mov decdividendo2,cx
        
        xor si,si
        xor bx,bx
        
        mov bx,tamDivs1
        mov si,offset divsor1
        call conversionExp1
        mov decdivisor,cx
        
        xor si,si
        xor bx,bx
        
        mov bx,tamDivs2
        mov si,offset divsor2
        call conversionExp1
        mov decdivisor2,cx
        
        cmp decdivisor,0
        je imposible
        cmp decdivisor2,0
        je imposible
        
        jmp operacion
        
        imposible:
        mov mens,2
        call menu
        call cleanArrays
        
        mov ah,1
        int bios
        
        mov mens,0
        call leecar
        
        
        operacion:
        
        cmp op,'+'
        je suma        
        cmp op,'-'
        je resta        
        cmp op,'*'
        je multiplicacion        
        cmp op,'/'
        je division
        
        suma:
        call sumaproc
        jmp resoperacion
        
        resta:
        call restaproc
        jmp resoperacion
        
        multiplicacion:
        call multiproc
        jmp resoperacion
        
        division:
        call diviproc
        

        ResOperacion:
        ;call simplify
        mov mens,1
        
        call menu
        call set_position
        call set_cursor
        
        mov divodivs,1
        call DecToAscii
        call print
        
        mov ah,2
        mov dl,'/'
        int 21h
        
        mov divodivs,2
        call DecToAscii
        call print
        
        mov ah,1                ;Servicio 1 para leer un caracter
        int 21h   ;El caracter leido se almacena en al

        mov mens,0
        call menu
        call set_position
        call cleanarrays
        call leecar  
     RET
   leecar endp
;***************************************


;***********************************MENU
   menu proc near
        mov ah,9                ;Servicio 9 para imprimir una cadena
        lea dx,ms              ;Seleccionamos la cadena ms
        int 21h   ;la imprimimos
        lea dx,pan1          ;seleccionamos la cadena lin1
        int 21h   ;la imprimimos
        
        cmp mens,2
        je imperror
        lea dx,pan2          ;seleccionamos la cadena lin1
        int BIOS   ;la imprimimos
        jmp resto
        imperror:
        lea dx,pan22          ;seleccionamos la cadena lin1
        int BIOS   ;la imprimimos
        resto:
        lea dx,lin1          ;seleccionamos la cadena lin1
        int BIOS   ;la imprimimos
        lea dx,lin2          ;y asi para las demas lineas
        int BIOS
        lea dx,lin3
        int BIOS
        lea dx,lin4
        int BIOS
        lea dx,lin5
        int BIOS
        lea dx,lin6
        int BIOS
        lea dx,lin7
        int BIOS
        lea dx,lin8
        int BIOS
        lea dx,lin9
        int BIOS
        lea dx,lin10
        int BIOS
        lea dx,lin11
        int BIOS
        lea dx,lin12
        int BIOS
        lea dx,lin13
        int BIOS
        lea dx,lin14
        int BIOS
        
        salirmenu:
     RET
   menu endp
;/***************************************
;/***********************************SUMA
   sumaproc proc near
   
   xor ax,ax
   xor bx,bx
   xor cx,cx
   xor dx,dx

   
   mov bx,decdivisor
   mov ax,decdivisor2
   mul bx
   mov divisorfinal,ax
   
   xor ax,ax ;limpiamos variables para reutilizar
   xor bx,bx
   
   mov bx,decdivisor
   mov ax,decdividendo2
   mul bx
   mov bx,ax
   
   xor ax,ax ;limpiamos variables para reutilizar
   
   mov cx,decdivisor2
   mov ax,decdividendo
   mul cx
   
   add bx,ax
   mov dividendofinal,bx
   
        
        
     RET
   sumaproc endp
   ;/***************************************
;/**********************************RESTA
   restaproc proc near
   
   xor ax,ax
   xor bx,bx
   xor cx,cx
   xor dx,dx

   
   mov bx,decdivisor
   mov ax,decdivisor2
   mul bx
   mov divisorfinal,ax
   
   xor ax,ax ;limpiamos variables para reutilizar
   xor bx,bx
   
   mov bx,decdivisor2
   mov ax,decdividendo
   imul bx
   mov bx,ax
   
   xor ax,ax ;limpiamos variables para reutilizar
   
   mov cx,decdivisor
   mov ax,decdividendo2
   imul cx
   
   sub bx,ax

   mov dividendofinal,bx

     RET
   restaproc endp
;/***************************************

conversionExp1 proc
    xor eax,eax
    xor edx,edx
    xor cx,cx
    xor di,di

    
    dec bx
    mov al,[bx+si]
    sub al,'0'
    dec bx
    add cx,ax
    
    cmp bx,0
    jl asignar
    mov di,bx
    
    
    
    xor ax,ax
    mov al,10
    mov dl,[si+bx]
    sub dl,30h
    mul dl    
    add cx,ax
    dec si
    dec di
    
    cmp di,0
    jl asignar
    
    xor ax,ax
    mov al,100
    mov dl,[si+bx]
    sub dl,30h
    mul dl    
    add cx,ax
    dec si
    dec di
    
    cmp di,0
    jl asignar
    
    xor ax,ax
    mov ax,1000
    mov dl,[si+bx]
    sub dx,30h
    mul dx    
    add cx,ax
    dec si
    dec di
    
    cmp di,0
    jl asignar
    
    xor ax,ax
    mov ax,10000
    mov dl,[si+bx]
    sub dx,30h
    mul dx    
    add cx,ax
    dec si
    dec di
    
    asignar:

    ret
    conversionExp1 endp
    
    print Proc
    xor si,si
    xor ax,ax
    mov ah,2
    imprimir:
    mov dl,resul[si]                ;
    int 21h   ;Imprimimos la cadena
    inc si
    cmp si,tamres
    jne imprimir
    
    

    
    ret
    print endp
    
DecToAscii proc
    xor ax,ax
    cmp divodivs,1      
    je impdividendo
    
    impdivisor:
    mov ax,divisorfinal      ; number to be converted
    jmp imprimirr
    
    impdividendo:
    mov ax,dividendofinal      ; number to be converted
    
    
    imprimirr:
    mov cx, 10         ; divisor
    xor bx, bx          ; count digits

    divide:
    xor dx, dx        ; high part = 0
    div cx             ; eax = edx:eax/ecx, edx = remainder
    push dx             ; DL is a digit in range [0..9]
    inc bx              ; count digits
    test ax, ax       ; EAX is 0?
    jnz divide          ; no, continue

    ; POP digits from stack in reverse order
    mov cx, bx          ; number of digits
    mov tamres,bx
    xor si,si
    
next_digit:
    pop ax
    add al, '0'  
    ; convert to ASCII
    mov resul[si], al        ; write it to the buffer
    inc si
    loop next_digit
    
    ret
    DecToAscii endp

;/*************************MULTIPLICACI?N
   multiproc proc near
   xor ax,ax
   xor bx,bx
   xor cx,cx
   xor dx,dx
   
   mov ax,decdividendo
   mov bx,decdividendo2
   mul bx
   mov dividendofinal,ax
   
   xor ax,ax
   xor bx,bx
   
   mov ax,decdivisor
   mov bx,decdivisor2
   mul bx
   mov divisorfinal,ax
   
   

       
     RET
   multiproc endp
;/***************************************
;/*******************************DIVISI?N
   diviproc proc near
   xor ax,ax
   xor bx,bx
   xor cx,cx
   xor dx,dx
   
   mov ax,decdividendo
   mov bx,decdivisor2
   mul bx
   mov dividendofinal,ax
   
   xor ax,ax
   xor bx,bx
   
   mov ax,decdividendo2
   mov bx,decdivisor
   mul bx
   mov divisorfinal,ax



     RET
   diviproc endp
;/***************************************
cleanArrays proc
    mov cx,10
    mov si,0
    
    limpiar:
    mov Divid1[si],'$'
    mov divsor1[si],'$'
    mov Divid2[si],'$'
    mov divsor2[si],'$'
    mov resul[si],'$'
    inc si
    loop limpiar
    
    mov tamDivd1 ,0 
    mov tamDivS1,0 
    mov tamDivd2, 0
    mov tamDivS2 , 0
    
    mov Decdividendo,0
    mov Decdividendo2, 0
    mov Decdivisor,0
    mov Decdivisor2,0
    mov DividendoFinal,0
    mov DivisorFinal,0
    
ret
cleanArrays endp

simplify proc
    
    xor si,si
    
    sigmul:
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    
    cmp si,6
    jge salsimp
    
    mov cl,multiplos[si]
    mov ax,dividendofinal
    div cx
    mov dl,ah
    
    mov ax,divisorfinal
    div cx
    mov bl,ah
    
    
    
    cmp dl,bl
    je simplificar
    inc si
    jmp sigmul
    
    simplificar:
    xor ax,ax
    xor bx,bx
    
    mov ax,dividendofinal
    div cx
    xor ah,ah
    mov dividendofinal,ax
    
    mov ax,divisorfinal
    div cx
    xor ah,ah
    mov divisorfinal,ax
    
    cmp divisorfinal,1
    jmp salsimp
    
    jmp sigmul
    
    salsimp:
    xor ax,ax
    xor bx,bx
    
    mov ax,dividendofinal
    div cx
    xor ah,ah
    mov dividendofinal,ax
    
    mov ax,divisorfinal
    div cx
    xor ah,ah
    mov divisorfinal,ax
    
    ret
    simplify endp
    
set_cursor proc
      mov  ah, 2                  ;??? SERVICE TO SET CURSOR POSITION.
      mov  bh, 0                  ;??? VIDEO PAGE.
      int  10h                    ;??? BIOS SERVICES.
      RET
set_cursor endp
set_position proc
        mov dl,12
        mov dh,10
        ret
set_position endp
salir:



end main

