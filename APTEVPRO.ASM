

;***********************************************************************************
; Macro para obtener la posición del cursor en la pantalla.
;***********************************************************************************
GET_CUR    	MACRO  PAG
			MOV    AH, 03H			;Obtiene la posición actual del cursor
			MOV    BH, PAG
			INT    10H
			MOV    FILA_ACTUAL, DH
			MOV    COL_ACTUAL, DL
			ENDM

;***********************************************************************************
; Macro para copiar una cadena a otra. 
;***********************************************************************************
COPIAR_CAD 	MACRO SOURCE, DESTINY, LONGITUD
			PUSHA
			MOV CX, LONGITUD	; Se carga la longitud de la cadena
			CLD
			LEA SI, SOURCE	
			LEA DI, DESTINY
			REP	MOVSB
			POPA
			ENDM

;***********************************************************************************
; Macro para desplegar una cadena.
;***********************************************************************************
DESP		MACRO CADENA
			MOV AH, 09H			; DESPLEGAR MENSAJE
			LEA DX, CADENA
			INT 21H
			ENDM
			
;***********************************************************************************
; Macro para limpiar una cadena.
;***********************************************************************************
LIMPIAR		MACRO CADENA, LONGITUD
			XOR CX, CX			 
			MOV CL, LONGITUD
			CLD
			LEA SI, LIMPIA		; Cadena vacía
			LEA DI, CADENA
			REP	MOVSB
			ENDM			
;----------------------------------------------------------------------------------------------
; Macro para inicializar el área de datos
;----------------------------------------------------------------------------------------------
INICIO 	   	MACRO			; define macro
			MOV   AX, @DATA           ; inicializar area de datos
			MOV   DS, AX
			MOV   ES, AX
			MOV   AX, 0003H				; modo texto 03h
			INT   10H
			ENDM			; fin macro	

;***********************************************************************************
; Macro para restar variables.
;***********************************************************************************
RESTAM		MACRO MINUENDO, SUSTRAENDO
			PUSHA
			MOV AX, MINUENDO
			SUB AX, SUSTRAENDO
			MOV LONG_COP, AX
			POPA
			ENDM

;***********************************************************************************
; Macro para sumar variables.
;***********************************************************************************
SUMAM		MACRO SUMANDO1, SUMANDO2
			PUSHA
			MOV AX, SUMANDO1
			ADD AX, SUMANDO2
			MOV SUMA, AX
			POPA
			ENDM

;***********************************************************************************
; Macro para dividir variables.
;***********************************************************************************			
DIVIDIR		DIVIDENDO, DIVISOR
			PUSHA
			MOV BX, DIVISOR
			MOV DX:AX, DIVIDENDO
			DIV BX
			MOV COCIENTE, AX
			MOV RESIDUO, DX
			POPA
			ENDM
			
;***********************************************************************************
; Macro para "mover de memoria a memoria".
;***********************************************************************************
MOVM 		MACRO SRC, DTN
			PUSH AX
			MOV AX, SRC			; Fuente
			MOV DTN, AX			; Destino
			POP AX
			ENDM
			
	.MODEL SMALL
	.STACK 64
;-------------------------------------------------------------------------------------------
; Inicio de Datos
	.DATA

.386
CARACTER_NULL	DB	00H, '$'			
CARACTER		DB	 '*$'
CADENA_DEST		DB	'Hoy es un bonito dia...    ', '$'
LONG_STRING1	DW	30
CANT_CAR		DW	23	
APUNTADOR_CAD	DW 	5
COP_APUNT_CAD	DW	?
CADENA_AUX		DB 	'                              ',0DH, 0AH,'$'
LONG_AUX		DB	32
S_2_INS			DB	'***','$'
LONG_STRING2	DW	3
LIMPIA			DB	30 DUP (' ')							 ; cadena para limpiar línea.
LONG_COP		DW	?
CONT_NULLS		DW  0
SUMA			DW  ?
COCIENTE		DW	?

	.CODE
INSERTAR_C 		PROC NEAR
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CARACTER, CADENA_DEST[BX], 1
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX+1], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				INC CANT_CAR
				POPA
				RET
INSERTAR_C		ENDP

INSERTAR_CAD	PROC NEAR
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD S_2_INS, CADENA_DEST[BX], LONG_STRING2
				ADD BX, LONG_STRING2
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				SUMAM CANT_CAR, LONG_STRING2
				MOVM SUMA, CANT_CAR
				POPA
				RET
INSERTAR_CAD	ENDP

COP_BS			PROC NEAR
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				DEC BX
				MOV APUNTADOR_CAD, BX
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				DEC CANT_CAR
				MOV BX, CANT_CAR
				COPIAR_CAD CARACTER_NULL, CADENA_DEST[BX], 1
				POPA
				RET
COP_BS			ENDP

BACKSPACE		PROC NEAR
				PUSHA
				CMP APUNTADOR_CAD, 0
				JE  SALE_BS
IN_BS:			MOVM APUNTADOR_CAD, COP_APUNT_CAD
				DEC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				MOV AL, [BX]
				CMP AL, 00H
				JE	ELIM_NULL
				CALL COP_BS
SALE_BS:		POPA
				RET
ELIM_NULL:		CALL COP_BS
				JMP IN_BS
BACKSPACE		ENDP

SUPRIMIR		PROC NEAR
				PUSHA
				MOV AX, APUNTADOR_CAD
				CMP AX, LONG_STRING1
				JE SALE_SUPR
				INC APUNTADOR_CAD
				CALL BACKSPACE
				DEC APUNTADOR_CAD
SALE_SUPR:		POPA
				RET
SUPRIMIR		ENDP

CORTAR_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, 80
				
				POPA
				RET
CORTAR_CAD		ENDP




MAIN PROC FAR

		INICIO
		;DESP CADENA_DEST
		;CALL INSERTAR_C
		;CALL INSERTAR_CAD
		;CALL BACKSPACE
		CALL SUPRIMIR
		DESP CADENA_DEST

		MOV   AX, 4C00H		;salida al DOS
		INT   21H
MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN
