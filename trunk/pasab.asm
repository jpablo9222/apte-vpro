;*************************************************
; PRUEBA MANEJO DE PUERTO SERIAL 1
;*************************************************

; MACROS
;*************************************************

INITP MACRO ; Inicializar puerto serial
	MOV AH, 00H 	; Llama funci�n inicializar
	MOV AL, 03H 	; Indica par�metros: 110 baudios, ninguna  
			; paridad, 1 bit de parada, palabra de 8 bits
	MOV DX, 3F8H 	; Determina el n�mero  del puerto COM1
	INT 14H  	; Llama interrupci�n
	ENDM

;*************************************************
WRITEP  MACRO B, P 	; Escribir en Puerto B = Dato, P = Puerto
	XOR AX, AX 	; Mover 0 (cero) a registro AX
	MOV AL, B 	; Especificar Dato de salida
	MOV DX, P 	; Indicar Puerto de salida
	OUT DX, AL 	; Realizar instrucci�n OUT
	ENDM

;**************************************
READP	MACRO P		; Escribir en Puerto B = Dato, P = Puerto
	XOR AX, AX	; Mover 0 a registro AX
	MOV DX, P 	; Puerto Serial COM1
	IN  AL, DX 	; Realizar instrucci�n IN
	MOV EN, AL
	;mov en, 10000001B
	ENDM
;**************************************

;*************************************************               
DELAY MACRO NUM ; Producir un retardo
	LOCAL PART1
	LOCAL PART2
	LOCAL PART3
	LOCAL PART4
	LOCAL PART5
	LOCAL PART6
	MOV C1, NUM
	MOV C2, NUM
	MOV C3, NUM
	MOV C4, NUM
	PART1: SUB C1, 1
	PART2: CMP C1, 0
	JZ PART3
	CMP C2, 0
	JZ PART4                                                                                     
	CMP C3, 0
	JZ PART5
	CMP C4, 0
	JZ PART6
	JMP PART1
	PART3: SUB C2, 1
	MOV C1, NUM
	JMP PART2
	PART4: SUB C3, 1
	MOV C2, NUM
	JMP PART2
	PART5: SUB C4, 1
	MOV C3, NUM
	JMP PART2
	PART6: ENDM

;*************************************************
; VARIABLES
;*************************************************

.MODEL COMPACT
.STACK 64
.DATA ; Definici�n de datos.
.386

C1	DB 	?
C2	DB 	?
C3	DB 	?
C4	DB 	?
EN	DB      ?

;*************************************************
.CODE ; Inicio de c�digo.
; PROCEDIMIENTOS

;*************************************************

MAIN PROC
	MOV AX, @data     		; Inicializaci�n.
	MOV DS, AX
	INITP 				; Inicializa Puerto serial COM1
REG:
	READP 03F8H
	;DELAY 20
	WRITEP EN, 03F8H 		; Macro: escribe 10101010 en el puerto COM1
	DELAY 20 			; Ocasiona un retardo
	JMP REG 			; es un ciclo infinito. Salir con Ctrl-C.
SALIR:
	MOV AH, 4CH    			; Salida al DOS.
	INT 21H
	MAIN ENDP
END MAIN
;*************************************************