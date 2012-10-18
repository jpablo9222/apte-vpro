TITLE pserial3
;-------------------------------------------------------------------------------------------
; Universidad del Valle de Guatemala
; Taller de Assembler
; Secci�n: 10
; Laboratorio 8
; pserial3.ASM
; Descripci�n: 
;				Programa que conecta a un circuito mediante puerto serial (COM1).
;				Permite activar los LEDS de un circuito enviandole informaci�n
;				a trav�s del Puerto Serial. 
; Autor:  	Juan Pablo Argueta			  	Carn�: 11033
;  			Jonathan L�pez                  Carn�: 11106
; Fecha de creaci�n: 16 de septiembre del 2012
; Revisiones: 6
; 17 de septiembre del 2012
;-------------------------------------------------------------------------------------------

;***********************************************************************************
; MACROS
;***********************************************************************************

;***********************************************************************************
; Inicializa el Puerto Serial (COM1) con determinada configuraci�n.
;***********************************************************************************
INITP 	MACRO ; Inicializar puerto serial
		MOV   AH, 00H 	; Llama funci�n inicializar
		MOV   AL, 03H 	; Indica par�metros: 110 baudios, ninguna  
						; paridad, 1 bit de parada, palabra de 8 bits
		MOV   DX, 3F8H 	; Determina el n�mero  del puerto COM1
		INT   14H  		; Llama interrupci�n
		ENDM

;***********************************************************************************
; Env�a un Byte dado por el par�metro B hacia el puerto P.
;***********************************************************************************
WRITEP 	MACRO B, P 			; Escribir en Puerto B = Dato, P = Puerto
		XOR   AX, AX 		; Mover 0 (cero) a registro AX
		MOV   AL, B 		; Especificar Dato de salida
		MOV   DX, P 		; Indicar Puerto de salida
		OUT   DX, AL 		; Realizar instrucci�n OUT
		ENDM
		
;***********************************************************************************
; Produce un retardo.
;***********************************************************************************		
DELAY 	MACRO NUM 	
		LOCAL PART1
		LOCAL PART2
		LOCAL PART3
		LOCAL PART4
		LOCAL PART5
		LOCAL PART6
		MOV   C1, NUM
		MOV   C2, NUM
		MOV   C3, NUM
		MOV   C4, NUM
PART1: 	SUB   C1, 1
PART2: 	CMP   C1, 0
		JZ    PART3
		CMP   C2, 0
		JZ    PART4
		CMP   C3, 0
		JZ    PART5
		CMP   C4, 0
		JZ    PART6
		JMP   PART1
PART3: 	SUB   C2, 1
		MOV   C1, NUM
		JMP   PART2
PART4: 	SUB   C3, 1
		MOV   C2, NUM
		JMP   PART2
PART5: 	SUB   C4, 1
		MOV   C3, NUM
		JMP   PART2
PART6: 	ENDM

;***********************************************************************************
; Macro para desplegar una cadena.
;***********************************************************************************
DESP		MACRO CADENA
			MOV AH, 09H			; DESPLEGAR MENSAJE
			LEA DX, CADENA
			INT 21H
			ENDM
			
;***********************************************************************************

.MODEL COMPACT
.STACK 64
.386

;***********************************************************************************
; Variables
;***********************************************************************************
.DATA 		; Definici�n de datos.
ENTR1   DB    	0DH,0AH,'$'
LINE	DB  80 DUP(0CDH), 0DH, 0AH, '$'	
MSJM	DB  '               Menu               ', 0DH, 0AH, 0DH, 0AH
		DB  ' Que desea hacer:                 ', 0DH, 0AH
		DB	' 1. ACTIVACION BITS ALTOS Y BAJOS ', 0DH, 0AH
		DB	' 2. CORRIMIENTO DE LEDS           ', 0DH, 0AH
		DB	' 3. SALIR                         ', 0DH, 0AH, 0DH, 0AH, '$'
MSJM1	DB 	'Ingrese el numero de la opcion que desea realizar: ','$'
M_IN 	DB  0DH,0AH,'Ha realizado un ingreso invalido. Repita su ingreso.$'	
C1		DB	?
C2		DB	?
C3		DB	?
C4		DB	?
OPCION	DB  ?
TABLA 	DW	OP1
		DW	OP2
		DW	OP3

;***********************************************************************************
; Inicio del C�digo
;***********************************************************************************
.CODE

;***********************************************************************************
; Procedimientos
;***********************************************************************************

;-------------------------------------------------------------------------------------------
; Deja un espacio para ordenar mejor la interfaz
;-------------------------------------------------------------------------------------------
ENTR		PROC  NEAR
			MOV   AH, 09H
			LEA   DX, ENTR1              ; Baja una l�nea
			INT   21H
			RET
ENTR 		ENDP	

;-----------------------------------------------------------------------------------------------------
;Tomado del ejemplo "Tablas.asm" de Martha Ligia Naranjo
;-----------------------------------------------------------------------------------------------------
SALTOS		PROC  NEAR
			XOR	  BX, BX	  	; pone a 0 registro BX
			MOV   BL, OPCION 	; obtener el codigo
			SHL	  BX, 01	  	; mult. Por 2
			CALL [TABLA+BX] 	; salta a la tabla
			RET
SALTOS		ENDP

;-----------------------------------------------------------------------------------------------------
; Controla el ingreso de las opciones
;-----------------------------------------------------------------------------------------------------
INGRESO   	PROC  NEAR
REP_ING2: 	DESP  MSJM1
			MOV   AH, 01H
			INT   21H
			SUB   AL, 30H
			CMP   AL, 1                       ;Se verifica que el ingreso no est� debajo del valor inferior.
			JB    INVALIDO2                   ;De estarlo, se repite la petici�n.
			CMP   AL, 3	                     ;Se verifica que el ingreSo no est� arriba del valor superior.
			JA    INVALIDO2
			MOV   OPCION, AL
			SUB	  OPCION, 1
			RET                               ;Si se llega aqu�, el ingreso es v�lido.
INVALIDO2:	CALL  ENTR
			DESP  M_IN
			CALL  ENTR                        ;Se cambia de l�nea.
			JMP   REP_ING2
INGRESO   	ENDP


;-----------------------------------------------------------------------------------------------------
; Controla la Entrada del Teclado sin espera
;-----------------------------------------------------------------------------------------------------
TECLADO PROC  NEAR
		MOV	  AH, 06H			; Petici�n directa a consola
		MOV	  DL, 0FFH		; Entrada del teclado
		INT	  21H
		RET
TECLADO ENDP

;-----------------------------------------------------------------------------------------------------
; Procedimiento 1, Activa Bits Bajos y Altos
;-----------------------------------------------------------------------------------------------------
OP1		PROC NEAR
CICLO:	WRITEP 11110000B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 00001111B, 03F8H
		DELAY 20 ; Ocasiona un retardo		
		CALL TECLADO
		JZ CICLO
		CMP AL, 27
		JNE CICLO
		WRITEP 00000000B, 03F8H
		RET
OP1		ENDP

;-----------------------------------------------------------------------------------------------------
; Procedimiento 2, Realiza el Corrimiento de Bits de Extremos al Centro
;-----------------------------------------------------------------------------------------------------
OP2		PROC  NEAR
CICOP2:	WRITEP 10000001B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 01000010B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 00100100B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 00011000B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		CALL  TECLADO
		JZ    CICOP2
		CMP   AL, 27
		JNE   CICOP2
		WRITEP 00000000B, 03F8H
		RET
OP2		ENDP

;-----------------------------------------------------------------------------------------------------
; Procedimiento 3, Sale del Programa
;-----------------------------------------------------------------------------------------------------
OP3		PROC  NEAR
		JMP   SALIR
		RET
OP3		ENDP

;-----------------------------------------------------------------------------------------------------
; Procedimiento Principal, Maneja el Flujo L�gico del Programa
;-----------------------------------------------------------------------------------------------------
MAIN 	PROC  FAR
		MOV   AX, @data     ; Inicializaci�n.
		MOV   DS, AX
		INITP ; Inicializa Puerto serial COM1
ASD: 	WRITEP 00000000B, 03F8H
		DESP LINE
		DESP MSJM
		CALL  ENTR
		CALL  INGRESO
		CALL  ENTR
		CALL  SALTOS
		JMP   ASD
SALIR:	MOV   AH, 4CH    ; Salida al DOS.
		INT   21H
MAIN 	ENDP

;-----------------------------------------------------------------------------------------------------	
		END MAIN