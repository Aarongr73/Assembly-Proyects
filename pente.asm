CR			Equ 13
LF			Equ 10
DOS			Equ 21H
TEsc		Equ 27
Bios		Equ 10H
Blanco		Equ 0F0h
SegVideo	Equ 0B800h
AnchoP		Equ 80 ; ancho pantalla en caracteres
LargoLin	Equ AnchoP*2 ; Largo en bytes de una linea en pantalla
;N 			Equ 6
ColorBase 	Equ 0eH ;amarillo


Datos Segment
PosFilas 	db 0
PosCol 	 	db 0
Jugador  	db 0
contDnum1   db 0
contDnum2   db 0
cont 		db 1
totalcajas  db 0
ganadosjug1 db "0"
ganadosjug2 db "0"

Teclas		DB "a",0
Procs   	DW P_FEnter
Letras  	dw Ent
fil32 		dd 0
fil 		db 0
col32 		dd 0
col 		db 0
contador 	db 0

contFila 	db 0
vs		  	db  LF," vs ",LF,CR,"$"
inicio 	  	db "Bienvenido al juego Pente",LF,CR,"$"
jug1      	db LF,CR,"Jugador 1. Digite su nombre", LF,CR,"$"
juga1    	db "Jugador 1 $"
juga2 	  	db "Jugador 2 $"
jug2      	db LF,CR," Jugador 2. Digite su nombre",LF,CR,"$"
Ayuda     	db "Ayuda", CR, LF, "F1: Ayuda del juego", CR, LF, "F10: Reinicia",CR,LF,"Flecha arriba: Mueve cursor arriba", CR, LF, "Flecha abajo: Mueve cursor abajo", CR,LF, "Flecha Derecha: Mueve cursor a la derecha",CR,LF, "Flecha Izquierda: Mueve cursor hacia la izquierda", CR, LF, "Esc: Salir ", CR, LF, "$"
cantFilas 	db LF,CR,"NUMERO DE FILAS",LF,CR,"$"
cantCol   	db LF,CR,"NUMERO DE COLUMNAS",LF,CR,"$"
TeclaEsp  	db ";","D","H","P","M","K",0
Gano    	db LF,CR,"GANO!",LF,CR,"$"
ProcsE	 	DW P_F1,P_F10,P_FArr,P_FAba,P_FDer,P_FIzq
pente    db LF,CR,"-------------------------------------PENTE--------------------------------------",LF,CR,"$"
gjuga1    	db LF,CR,"ganados Jugador 1 $",LF,CR,"$"
gjuga2 	  	db LF,CR,"Ganados Jugador 2 $",LF,CR,"$"
Rot_NoteclaEsp DB "Tecla especial <"
TeclaE	Db ?
	Db "",CR,LF,"$"
Ent	Db "Tecla enter",CR,LF,"$"
F1	Db "",CR,LF,"$"
F10	Db "",CR,LF,"$"
Arr	Db "",CR,LF,"$"
Aba	Db "",CR,LF,"$"
der db "",CR,LF,"$"
izq db "",CR,LF,"$"

Rot1	Db ""
Tecla	DB ?,CR,LF,"$"

Tablero db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

vec1 db 100 dup('$')		
vec2 db 100 dup('$')
num1 db 100 dup('$')	
num2 db 100 dup('$')	
	
	Datos EndS

Pila Segment Stack "Stack"
	DW 100 Dup (0)
Pila EndS

Codigo Segment
.486
Assume CS:Codigo, DS:Datos, SS:Pila
Include ImpFila.inc


Princ:
	Mov Ax,Datos
	Mov DS,Ax
	Mov Ax, SegVideo
	Mov ES, Ax ; ES= Mem Video
princ2:	
	
	mov Edx, offset inicio
    mov ah,09 ;Int para visualizacion de caracteres
    int 21h


    mov Edx,offset jug1
    mov ah,09
    int 21h
		
    xor Esi,Esi ; indice del vector  en 0
    leer:
        mov ah,01h ;Int para lectura
        int 21h
        mov vec1[Esi],al ;Vector en la posicion ESI
        inc Esi   ;Moverme
        cmp al,0dh ;Comparar con el enter
        jne leer ;Mientras no sea enter se repite
        mov Edx, offset juga1
        mov ah,09
        int 21h
    ver:
        mov Edx,offset vec1 ;Mostrar nombre del jugador 1
        mov ah,09h
        int 21h        
    
		mov Edx, offset jug2  
		mov ah,09
		int 21h
		xor Esi, Esi
	otro:
        mov ah,01h
        int 21h
        mov vec2[Esi],al
        inc Esi   
        cmp al,0dh 
        ja otro
        mov Edx, offset juga2
        mov ah,09
        int 21h   
        mov Edx,offset vec2 
        mov ah,09h
        int 21h 
		xor esi,esi
		
		call numC
		call numF
		
		mov Edx, offset num1
        mov ah,09
        int 21h
		call espera
		
		sigue:
		xor esi,esi
		
		Mov EAx,0003	;Modo 25x 80
		Int BIOS
	
		Mov DI, 2*2*1024 ;Mostrar tablero en una pagina diferente
		Mov EBX, Offset Tablero
		Mov ESI,LargoLin*7+ 70 ; posicion en pantalla 
		
		mov Edx,offset vec1
		mov ah,09h
		int 21h 
	 
		mov Edx,offset vs 
		mov ah,09h
		int 21h 
		
		mov Edx,offset vec2
		mov ah,09h
		int 21h 
		xor eax,eax
		mov al,PosFilas
		mov edi,eax
		add tablero[edi],10
		
		
		mov Edx, offset pente
		mov ah,09 ;Int para visualizacion de caracteres
		int 21h
		Call ImpTablero
			
Otra:
	int 3
	xor eax,eax
    xor esi,esi
    xor edx,edx	

	Mov AH,07H ;espera una tecla
	Int DOS

	Cmp Al, TEsc
	JE Salir
	Mov Tecla,Al
	; Escribir una hilera terminada en $
	
	Call ProcTecla
	Mov ESI,LargoLin*7+ 70 ; posicion en pantalla 
	Push ESI
	Call ImpTablero
	Pop ESI
	Jmp Otra;sigue leyendo teclas	
Espera Proc Near
	Push EAx 
	Mov AH,07H 
	Int DOS
	pop EAx

  Ret
Espera EndP		

ProcTecla Proc
; Procesa la tecla contenida en AL y llama al procedimiento respectivo
	


	Push ESI
	Xor ESI,ESI
	Cmp Al,CR
	JE P_FEnter
	Cmp AL,0
	Call TeclaEspecial
	Jmp S1		; Devolverse
O2:
	Cmp Teclas[ESI],0
	JE S1		; Termin� de buscar en la tabla
	Cmp Teclas[ESI],AL
	JE procesa
	Inc ESI ; buscar siguiente
	Jmp O2
procesa:	
;Procesar las teclas, m�todo General
	; Escribir rotulo general
	Call Procs[ESI*2] ; procesar segun el proc correspondiente
	
S1:
	
	Pop ESI
	Ret
ProCTecla EndP

TeclaEspecial Proc Near
int 3
	Mov AH,07H 
	Int 21H ; Lee tecla en AL posterior al 0 de tecla especial
	
	Mov TeclaE, Al ; guardarla por si no la encuntra poner mensaje
	
	Xor ESI,ESI	; en 0 para busqueda en el vector TeclaEsp
O3:
	
	Cmp TeclaEsp[ESI],0
	JE TE_S1		; Termin� de buscar en la tabla
	Cmp TeclaEsp[ESI],AL
	JE pro2
	Inc ESI ; buscar siguiente
	Jmp O3
Pro2:
    int 3
	xor EDI,EDI
	xor EAX,EAX
	mov al,PosFilas
	Mov EDI,EAX
	sub Tablero[EDI], 10
	tEST CL,0FH
	Call ProcsE[ESI*2] ; procesar segun el proc correspondiente
	Jmp TE_Fin
TE_S1:
	
	
TE_Fin:
	Ret
TeclaEspecial EndP
Reinicio Proc
Sale:
	cmp jugador,1
	je rjug2
	inc ganadosjug1
	mov Edx,offset vec1
	mov ah,09h
	int 21h 
	jmp cls

rjug2:
	inc ganadosjug2
	mov Edx,offset vec2
	mov ah,09h
	int 21h 
	jmp cls
	
	XOR ECX,ECX
	XOR EAX,EAX
	mov ecx,4000
	xor edi,edi
	
cls:
	MOV ES:[EDI],Ax
	INC EDI
	LOOP cls
	
limpiatablero2:
    xor eax,eax
	xor edx,edx
	xor edi,edi
	mov al,col
	mov dl,fil
	mul dl
limpia2:;limpiamos el tablero
	mov tablero[edi],0
	inc edi
	cmp edi,eax
	jne limpia2
	
	xor edi,edi
	mov PosFilas,0;posicion 0
	call espera
	jmp sigue;volvemos al principio sin pedir nombres
	
endp	

P_F1 Proc Near
	Mov EAx,0003
	Int BIOS
	
	Mov DI, 2*2*1024
	Mov ah,09h
	Mov DX, Offset Ayuda ;Mostrar rotulo de ayuda en pagina aparte
    int 21h
	mov ah,01h ;Int para lectura
	int 21h
	call espera
	jmp sigue
Ret
P_F1 EndP

P_F10 Proc Near
	XOR ECX,ECX
	XOR EAX,EAX
	mov ecx,4000
	xor edi,edi
	
limpiar:;borramos los datos en la pantalla
	MOV ES:[EDI],Ax
	INC EDI
	LOOP limpiar
	jmp limpiatablero;limpiamos el tablero de igual manera
siguelimp:;limpiamos variables
	mov vec1,0
	mov vec2,0
	mov col,0
	mov col32,0
	mov fil32,0
	mov PosFilas,0
	xor edi,edi
	Mov EAx,0003
	Int BIOS
	
	Mov DI, 2*2*1024

	jmp princ2;aqui si pedimos todo nuevamente
	
	
	


Ret
P_F10 EndP

P_FArr Proc Near
	Xor EDI,EDI
	Xor EAX,EAX
	xor edx,edx
	mov dl,col
	sub PosFilas,dl;nos movemos arriba
	Mov	al,PosFilas
	add EDI,EAX
	add Tablero[EDI],10; ponemos el cursor
	
Ret
P_FArr EndP

P_FAba Proc Near
	Xor EDI,EDI
	Xor EAX,EAX
	xor edx,edx
	mov dl,col
	add PosFilas,dl;nos movemos abajo
	Mov	al,PosFilas
	add EDI,EAX
	add Tablero[EDI],10;ponemos el cursor
Ret
P_FAba EndP

P_FDer Proc Near
	; Escribir una hilera teriminada en $
	
	int 3
	Xor EDI,EDI
	Xor EAX,EAX
	add contFila,1
	cmp contFila,99
	jge suma
a:
	add PosFilas,1;nos movemos a la derecha
	Mov	al,PosFilas
	add EDI,EAX
	add Tablero[EDI],10;ponemos el cursor
	ret
	
 Suma:
	 xor eax,eax
	 mov al,col
	 sub PosFilas,al
	 sub contFila,al
	 jmp a


Ret
P_Fder EndP

P_FIzq Proc Near
	; Escribir una hilera teriminada en $
	; Escribir una hilera teriminada en $
	Xor EDI,EDI
	Xor EAX,EAX
	sub contFila,1
	cmp contFila,0
	jl Resta1
b:	
	sub PosFilas,1;nos movemos a la izquierda
	Mov	al,PosFilas
	add EDI,EAX
	add Tablero[EDI],10;ponemos el cursor
 Ret
	Resta1:
	 xor eax,eax
	 mov al,col
	 add PosFilas,al
	 add contFila,al
	jmp b
	ret


P_FIzq EndP

P_FEnter Proc near
	Xor EAX,EAX
	Xor EDI,EDI
	Mov	al,PosFilas
	add EDI,EaX
	cmp Tablero[EDI],10
	JE INSERTAR
	Mov ESI,LargoLin*7+ 70 ; posicion en pantalla 
	RET
insertar:	
	Xor EAX,EAX
	Xor EDI,EDI
	Mov al,Jugador
	Cmp al,0
	JE j1 
	Xor ECX,ECX
	Mov	cl,PosFilas
	add EDI,ECX
	mov Tablero[EDI],2;ponemos 2 en el tablero, es decir N
	add tablero[EDI],10; agregamos el cursor
	call Ganador; sera una ficha ganadora?
	sub Jugador,1; cambiamos de jugador
	Mov ESI,LargoLin*7+ 70 ; posicion en pantalla 
	ret

j1:
	
		
	Xor EDI,EDI
	Xor ECX,ECX
	Mov	cl,PosFilas
	add EDI,ECX
	mov Tablero[EDI],1;ficha blanca
	add tablero[EDI],10;cursor
	call Ganador;gano?
	add Jugador,1
	Mov ESI,LargoLin*7+ 70 ; posicion en pantalla 

	ret



P_FEnter endP
numC proc
		xor esi,esi
		mov Edx,offset cantCol
		mov ah,09
		int 21h
		leenum:
		 mov ah,01h
         int 21h
         mov num1[Esi],al
         inc Esi   
		 inc contDnum1
         cmp al,0dh 
         jne leenum
		 
		 xor eax,eax
		 xor esi,esi
		 xor edx,edx
		 mov dl,num1[ESI];tomamos el primer digito
		 sub dl,30h; lo pasamos a numero base 10
		 mov al,10 ; se multiplica por 10
		 mul dl
		 inc esi;aumentamos el contador
		 xor edx,edx
		 mov dl,num1[ESI];segundo digito
		 sub dl,30h;base 10
		 add al,dl;sumamos y obtenemos el numero deseado
		 mov col,al; lo hice asi ya que ocupaba manejarme tanto en 8 para la logica y en 32 para moverme
		 mov col32,eax
		 ret
		 
endp
numF proc
		xor esi,esi
		mov Edx,offset cantFilas
		mov ah,09
		int 21h
		leenum2:
		 mov ah,01h
         int 21h
         mov num2[Esi],al;llenamos el vector con el numero
         inc Esi   
		 inc contDnum2
         cmp al,0dh ;presiono enter?
         jne leenum2
		 
		 xor eax,eax
		 xor esi,esi
		 xor edx,edx
		 mov dl,num2[ESI];tomamos el primer digito
		 sub dl,30h; lo pasamos a numero base 10
		 mov al,10 ; se multiplica por 10
		 mul dl
		 inc esi;aumentamos el contador
		 xor edx,edx
		 mov dl,num2[ESI];segundo digito
		 sub dl,30h;base 10
		 add al,dl;sumamos y obtenemos el numero deseado
		 mov fil,al; lo hice asi ya que ocupaba manejarme tanto en 8 para la logica y en 32 para moverme
		 mov fil32,eax
		 ret
		 
endp
Ganador Proc
     int 3
	 xor edx,edx
	 mov dl, tablero[edi]; se guarda el valor que acabamos de ingresar
	 sub dl,10; la posicion inicial se asume que tiene cursor,para comparar restamos 10
	 inc cont; se pone en 1 por que la ingresada sera la primera tecla en contar
GDer:
	add edi, 1; nos movemos a la derecha
	mov al, Tablero[EDI];guardamos el valor
	cmp al,dl;iguales?
	je Contar_Der; de ser incrementamos el contador y comparamos
	xor eax,eax
	mov al,cont
	sub edi,eax; devolvermos el indice donde insertamos la tecla
	xor eax,eax


GIzq:
	sub edi, 1; nos movemos a la izq
	mov al, Tablero[EDI];guardamos el valor
	cmp al,dl
	je Contar_Izq
	mov cont, 0
	xor edi, edi
	xor eax,eax
	mov al,PosFilas
	mov edi,eax; nos devolvemos a la posicion donde se inserto en caso de no encontrarse, revisa arriba y abajo despues de esto
	mov cont,1
	
GAb:
	add edi,col32; nos movemos abajo
	mov al, Tablero[edi];guardamos
	cmp al, dl
	je Contar_Ab
	xor eax,eax
	mov al,PosFilas
	mov edi,eax
	xor eax,eax
GArr:
	sub edi,col32
	mov al, Tablero[edi]
	cmp al,dl
	je Contar_Arr
	mov cont,1
	xor eax,eax
	mov al,PosFilas
	mov edi,eax
	xor eax,eax
GDiagDerArr:
	add edi,col32
	sub edi,1
	mov al,tablero[edi]
	cmp al,dl
	je Cont_DiagderArr
	xor eax,eax
	mov al,PosFilas
	mov edi,eax
	xor eax,eax
GDiagDerAb:
	sub edi,col32
	add edi,1
	mov al,tablero[edi]
	cmp al,dl
	je Cont_DiagderAb
	xor eax,eax
	mov al,PosFilas
	mov edi,eax
	xor eax,eax
	mov cont,1
GDiagIzqArr:
	add edi,col32
	add edi,1
	mov al,tablero[edi]
	cmp al,dl
	je Cont_DiagizqArr
	xor eax,eax
	mov al,PosFilas
	mov edi,eax
	xor eax,eax
GDiagIzqAb:
	sub edi,col32
	sub edi,1
	mov al,tablero[edi]
	cmp al,dl
	je Cont_DiagizqAb
	xor eax,eax
	mov al,PosFilas
	mov edi,eax
	xor eax,eax	
	mov cont,0
	
	
ret
Ganador endp


ImpTablero Proc
; Imprime un tablero (EBX) en pantalla de dimensiones NXN
; N   es global y debe estar definido con anterioridad
; EBX está la dirección inical del tablero NXN
; ESI tiene el offset inicial en pantalla
; EDI tiene el indice al tablero apuntado por EBX. Interno.
	xor ecx,ecx
	Mov ecx,fil32 ;N Filas
	Xor EDI, EDI ; Posicion inicial en 0
OtraLinea:
	Call ImprimeFila ; preserva ESI
	; Cambiar de linea
	Add ESI, LargoLin
  Loop OtraLinea

	Ret
ImpTablero EndP
;todos hacen lo mismos, verifican un gane, si no regresan a la eqitueta respectiva y llaman al reinicio del juego
Contar_Der:
	inc cont
	cmp cont, 5
	jne GDer
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call Espera
	call reinicio
	
Contar_Izq:
	inc cont
	mov cl, cont
	cmp cl, 5
	jne GIzq
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call reinicio	

Contar_Ab:
	inc cont
	mov cl, cont
	cmp cl,5
	jne GAb	
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call reinicio	
Contar_Arr:
	inc cont
	mov cl, cont
	cmp cl,5
	jne GArr
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call reinicio	
Cont_DiagderArr:	
	inc cont
	mov cl, cont
	cmp cl,5
	jne GDiagDerArr
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call reinicio
Cont_DiagderAb:	
	inc cont
	mov cl, cont
	cmp cl,5
	jne GDiagDerAb
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call reinicio	
Cont_DiagizqArr:	
	inc cont
	mov cl, cont
	cmp cl,5
	jne GDiagizqArr
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call reinicio	
Cont_DiagizqAb:	
	inc cont
	mov cl, cont
	cmp cl,5
	jne GDiagizqAb
	mov Edx, offset Gano
    mov ah,09
    int 21h
	call reinicio	
		
	


Salir:
	Mov Ah,4CH
	Int DOS	
	
limpiatablero:
		;averiguamos la cantidad de cajas en la matriz a limipiar
		xor eax,eax
		xor edx,edx
		xor edi,edi
		mov al,col
		mov dl,fil
		mul dl
limpia:;limpiamos
		mov tablero[edi],0
		inc edi
		cmp edi,eax
		jne limpia
		jmp siguelimp
			
Codigo EndS

END Princ
