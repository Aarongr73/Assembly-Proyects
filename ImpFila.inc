ImprimeFila	Proc Near
; ESI apunta al offset de pantalla donde se debe imprimir. Se preserva
; EDI apunta al offset de la posición a imprimir
; EBX El tablero
	Push ESI
	Push ECX ;preservar contador anterior

	Mov Ah, ColorBase

; Repetir N veces (tamano de la linea)
	Mov ecx,col32
OtroCar:
	Mov Al, [EBX+EDI]
	Cmp Al,0 ; Si es cero imprimir una X
	JE Cero
	Cmp Al,1
	JE Uno
	Cmp Al,2
	JE ndos	
	Cmp Al,10
	JE CursorNada
	Cmp Al, 11
	JE CursorB
	Cmp Al,12
	JE CursorN
Cero:
	Mov Al, [EBX+EDI]

	Mov Al, " "
	Mov ah,90H
	Jmp Escribir
Uno:
Mov Al,"B"
mov ah,30H
Jmp Escribir

ndos:
Mov Al,"N"
mov ah,50H
Jmp Escribir

CursorNada:
Mov Al,"X"
mov ah,20H
Jmp Escribir

CursorB:
Mov Al,"B"
mov ah,60H
Jmp Escribir

CursorN:
Mov Al,"N"
mov ah,60H
Jmp Escribir



Escribir:
;  Imprimirlo en pantalla
	Mov ES:[ESI],AX ; caracter
;  Incrementar indice Tablero
	Inc EDI
;  Incrementar indice Pantalla
	Inc ESI
	Inc ESI
   Loop OtroCar

	Pop ECX
	Pop ESI
	Ret
ImprimeFila	EndP

