;*************************************************
; PRUEBA MANEJO DE PUERTO SERIAL 1
;*************************************************
; MACROS
;*************************************************
INITP MACRO ; Inicializar puerto serial
	MOV AH, 00H 	; Llama función inicializar
	MOV AL, 03H 	; Indica parámetros: 110 baudios, ninguna  
					; paridad, 1 bit de parada, palabra de 8 bits
	MOV DX, 3F8H 	; Determina el número  del puerto COM1
	INT 14H  		; Llama interrupción
	ENDM
;*************************************************
WRITEP MACRO B, P 	; Escribir en Puerto B = Dato, P = Puerto
	XOR AX, AX 		; Mover 0 (cero) a registro AX
	MOV AL, B 		; Especificar Dato de salida
	MOV DX, P 		; Indicar Puerto de salida
	OUT DX, AL 		; Realizar instrucción OUT
	ENDM
;*************************************************               
DELAY MACRO NUM 	; Producir un retardo
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
PART1: 	SUB C1, 1
PART2: 	CMP C1, 0
	JZ PART3
	CMP C2, 0
	JZ PART4
	CMP C3, 0
	JZ PART5
	CMP C4, 0
	JZ PART6
	JMP PART1
PART3: 	SUB C2, 1
	MOV C1, NUM
	JMP PART2
PART4: 	SUB C3, 1
	MOV C2, NUM
	JMP PART2
PART5: 	SUB C4, 1
	MOV C3, NUM
	JMP PART2
PART6: 	ENDM
;*************************************************
; VARIABLES
;*************************************************
.MODEL COMPACT
.STACK 64
.386
.DATA 		; Definición de datos.
C1		DB	?
C2		DB	?
C3		DB	?
C4		DB	?
TABLA 	DW	OP1
		DW	OP2
		DW	OP3

;*************************************************
.CODE ; Inicio de código.
; PROCEDIMIENTOS

OP1	PROC NEAR
		WRITEP 11110000B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 00001111B, 03F8H
		DELAY 20 ; Ocasiona un retardo		
		RET
OP1	ENDP

OP2	PROC NEAR
		WRITEP 10000001B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 01000010B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 00100100B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		WRITEP 00011000B, 03F8H
		DELAY 20 ; Ocasiona un retardo
		RET
OP2	ENDP

OP3	PROC NEAR
		JMP SALIR
		RET
OP3	ENDP
;*************************************************
MAIN PROC
MOV AX, @data     ; Inicialización.
MOV DS, AX
INITP ; Inicializa Puerto serial COM1
;REG:
;WRITEP 01010101B, 03F8H ; Macro: escribe 10101010 en el puerto COM1
;DELAY 20 ; Ocasiona un retardo
JMP REG ; es un ciclo infinito. Salir con Ctrl-C.
SALIR:
MOV AH, 4CH    ; Salida al DOS.
INT 21H
MAIN ENDP
END MAIN
;*************************************************