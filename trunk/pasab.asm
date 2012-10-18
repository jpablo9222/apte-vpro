TITLE pasab
;-------------------------------------------------------------------------------------------
; Universidad del Valle de Guatemala
; Taller de Assembler
; Secci�n: 10
; Laboratorio 8
; psab.ASM
; Descripci�n: 
;				Programa que recibe un Byte de entrada desde otra Computadora
;				y luego lo redirecciona a la salida del Puerto, el cual se conecta
;				al Circuito. Realiza una interconexi�n entre dos computadoras.
; Autor:  	Juan Pablo Argueta			  	Carn�: 11033
;  			Jonathan L�pez                  Carn�: 11106
; Fecha de creaci�n: 16 de septiembre del 2012
; Revisiones: 2
; 17 de septiembre del 2012
;-------------------------------------------------------------------------------------------

;***********************************************************************************
; MACROS
;***********************************************************************************

;***********************************************************************************
; Inicializa el Puerto Serial (COM1) con determinada configuraci�n.
;***********************************************************************************
INITP 	MACRO 			; Inicializar puerto serial
		MOV AH, 00H 	; Llama funci�n inicializar
		MOV AL, 03H 	; Indica par�metros: 110 baudios, ninguna  
						; paridad, 1 bit de parada, palabra de 8 bits
		MOV DX, 3F8H 	; Determina el n�mero  del puerto COM1
		INT 14H  		; Llama interrupci�n
		ENDM

;***********************************************************************************
; Env�a un Byte dado por el par�metro B hacia el puerto P.
;***********************************************************************************
WRITEP  MACRO B, P 		; Escribir en Puerto B = Dato, P = Puerto
		XOR AX, AX 		; Mover 0 (cero) a registro AX
		MOV AL, B 		; Especificar Dato de salida
		MOV DX, P 		; Indicar Puerto de salida
		OUT DX, AL 		; Realizar instrucci�n OUT
		ENDM

;***********************************************************************************
; Recibe un Byte por medio del puerto P.
;***********************************************************************************
READP	MACRO P			; Escribir en Puerto B = Dato, P = Puerto
		XOR AX, AX		; Mover 0 a registro AX
		MOV DX, P 		; Puerto Serial COM1
		IN  AL, DX 		; Realizar instrucci�n IN
		MOV EN, AL
		;mov en, 10000001B
		ENDM

;***********************************************************************************
; Produce un retardo.
;***********************************************************************************		
DELAY 	MACRO NUM ; Producir un retardo
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

.MODEL COMPACT
.STACK 64

;***********************************************************************************
; Variables
;***********************************************************************************
.DATA ; Definici�n de datos.
.386

C1	DB 	?
C2	DB 	?
C3	DB 	?
C4	DB 	?
EN	DB  ?

;***********************************************************************************
; Inicio del C�digo
;***********************************************************************************
.CODE

;***********************************************************************************
; Procedimientos
;***********************************************************************************

;-----------------------------------------------------------------------------------------------------
; Procedimiento Principal, Maneja el Flujo L�gico del Programa
;-----------------------------------------------------------------------------------------------------
MAIN 	PROC  FAR
		MOV   AX, @data     	; Inicializaci�n.
		MOV   DS, AX
		INITP 				; Inicializa Puerto serial COM1
REG:
		READP 03F8H
		;DELAY 20
		WRITEP EN, 03F8H 	; Macro: escribe 10101010 en el puerto COM1
		DELAY 20 			; Ocasiona un retardo
		JMP   REG 			; es un ciclo infinito. Salir con Ctrl-C.
SALIR:
		MOV   AH, 4CH    		; Salida al DOS.
		INT   21H
MAIN	ENDP

;-----------------------------------------------------------------------------------------------------		
		END MAIN
