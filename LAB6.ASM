TITLE LAB6
;----------------------------------------------------------------------------------------------
; Universidad del Valle de Guatemala
; Taller de Assembler
; Laboratorio 6
; LAB6.ASM
; Descripción: Este programa permite realizar tres funciones que se realizan mediante la 
;              utilizacion de teclado avanzado y la implementación de macros.
; Autor:       Juan Pablo Argueta Cortés           Carnet 11033 - Sección 11
; 			   Jonathan Josué López Guevara		   Carnet 11106 - Sección 11
; Fecha de creación: 28 de agosto del 2012
; Revisiones: 5
; 28 de Agosto 2012
;----------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------
; Área de Macros
;----------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------
; Macro para inicializar el área de datos
;----------------------------------------------------------------------------------------------
INICIO 	   	MACRO			; define macro
			MOV    AX, @data
			MOV    DS, AX
			MOV    ES, AX
			MOV    AX, 0003H				; modo texto 03h
			INT    10H
			ENDM			; fin macro
			
;----------------------------------------------------------------------------------------------
; Macro para imprimir un caracter.
;----------------------------------------------------------------------------------------------
FUN_C	   	MACRO 
			MOV    AH, 02H
			MOV    DL, ASCII
			INT    21H	   
			ENDM
		   
;----------------------------------------------------------------------------------------------
; Macro para obtener la posición del cursor en la pantalla.
;----------------------------------------------------------------------------------------------
GET_CUR    	MACRO  PAG
			MOV    AH, 03H			;Obtiene la posición actual del cursor
			MOV    BH, PAG
			INT    10H
			MOV    FILA_ACTUAL, DH
			MOV    COL_ACTUAL, DL
			ENDM
;----------------------------------------------------------------------------------------------
; Macro para posicionar el cursor en una posición específica en la pantalla.
;----------------------------------------------------------------------------------------------		   
SET_CUR    	MACRO  PAG, COL, FILA
			MOV    AH, 02H
			MOV    BH, PAG
			MOV    DL, COL
			MOV    DH, FILA
			INT    10H
			ENDM
;----------------------------------------------------------------------------------------------
; Macro para permitir la entrada de teclado.
;----------------------------------------------------------------------------------------------
GET_C       MACRO
			MOV   AH, 00H
			INT   16H
			MOV   ASCII, AL
			MOV   RASTREO, AH
			ENDM
;----------------------------------------------------------------------------------------------
; Macro para cambiar de línea y posicionar el cursor en la primera columna de está.
;----------------------------------------------------------------------------------------------				
FUN_ENTER  	MACRO  PAGINA, FILA, COLUMNA
			MOV    COL_ACTUAL, 0
			ADD    FILA_ACTUAL, 1
			MOV    AH, 02H
			MOV    BH, PAGINA
			MOV    DL, COLUMNA
			MOV    DH, FILA
			INT    10H    
			ENDM
;----------------------------------------------------------------------------------------------
; Macro para poder mover el cursor usando las flechas.
;----------------------------------------------------------------------------------------------
MOVCURSOR  	MACRO PAGINA, FILA, COLUMNA
			MOV AH, 02H
			MOV BH, PAGINA
			MOV DL, COLUMNA
			MOV DH, FILA
			INT 10H
			ENDM
;----------------------------------------------------------------------------------------------
; Macro para identificar cual fue el ingreso del teclado y dependiendo de ello realizar la
; acción correspondiente.
;----------------------------------------------------------------------------------------------				
COMP	   	PROC NEAR
			CMP RAST, 4BH
			JE IZ
			CMP RAST, 4DH
			JE DE
		    CMP RAST, 1CH
			JE ENT
			CMP RAST, 4FH
			JE EN
			CMP ASCI, 00H
			JE  SALIR
			FUN_C 
			JMP SALIR
ENT:		FUN_ENTER PAG_ACTUAL, FILA_ACTUAL, COL_ACTUAL	;Enter
			JMP SALIR
EN:			SET_CUR  PAG_ACTUAL, 79, FILA_ACTUAL
IZ:			SUB COL_ACTUAL, 1								
			MOVCURSOR PAG_ACTUAL, FILA_ACTUAL, COL_ACTUAL	;Movimiento izquierda
			JMP SALIR
DE: 		ADD COL_ACTUAL, 1								
			MOVCURSOR PAG_ACTUAL, FILA_ACTUAL, COL_ACTUAL	;Movimiento derecha	
			JMP SALIR
SALIR:
COMP			ENDP
;----------------------------------------------------------------------------------------------		   
		   	.MODEL SMALL
			.STACK 64
;----------------------------------------------------------------------------------------------
;Definición de datos.
.DATA

PAG_ACTUAL	DB  0
FILA_ACTUAL DB  0
COL_ACTUAL	DB  0
ASCII		DB  0
RASTREO		DB  0
;----------------------------------------------------------------------------------------------
			.CODE
;----------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------
; Procedimiento Principal del Programa. Define el flujo lógico del Programa.
;----------------------------------------------------------------------------------------------
MAIN 		PROC  FAR
			INICIO
SEGUIR:		GET_CUR PAG_ACTUAL
INE:		CMP   COL_ACTUAL, 80
			JE    INTRO
			SET_CUR PAG_ACTUAL, COL_ACTUAL, FILA_ACTUAL
			GET_C
			CMP   ASCII, 27
			JE    SALIDA
			CALL COMP  
			JMP   SEGUIR
INTRO:      FUN_ENTER PAG_ACTUAL, FILA_ACTUAL, COL_ACTUAL
			JMP   SEGUIR
SALIDA:		MOV   AX, 4C00H	; salir a DOS
			INT   21H
MAIN		ENDP
;----------------------------------------------------------------------------------------------		
END MAIN