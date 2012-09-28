

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
	.MODEL SMALL
	.STACK 64
;-------------------------------------------------------------------------------------------
; Inicio de Datos
	.DATA

.386			
CARACTER		DB	 '*$'
CADENA_DEST		DB	'Hoy es un bonito dia...    ', '$'
LONG_STRING1	DW	30
CANT_CAR		DW	23	
APUNTADOR_CAD	DW 	5
CADENA_AUX		DB 	'                              ',0DH, 0AH,'$'
LONG_AUX		DB	30
S_2_INS			DB	'***','$'
LONG_STRING2	DW	3
LIMPIA			DB	30 DUP (' ')							 ; cadena para limpiar línea.
LONG_COP		DW	?

	.CODE
INSERTAR_C 		PROC NEAR
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CARACTER, CADENA_DEST[BX], 1
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX+1], LONG_COP
				ADD LONG_STRING1, BX
				LIMPIAR CADENA_AUX, LONG_AUX
				POPA
				RET
INSERTAR_C		ENDP

INSERTAR_CAD	PROC NEAR
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				SUB LONG_STRING1, BX
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD S_2_INS, CADENA_DEST[BX], LONG_STRING2
				ADD BX, LONG_STRING2
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				ADD LONG_STRING1, BX
				LIMPIAR CADENA_AUX, LONG_AUX
				DESP CADENA_DEST
				POPA
				RET
INSERTAR_CAD	ENDP

BACKSPACE		PROC NEAR
				
				RET
BACKSPACE		ENDP
MAIN PROC FAR

		INICIO
		
		;CALL INSERTAR_C
		CALL INSERTAR_CAD
		

		MOV   AX, 4C00H		;salida al DOS
		INT   21H
MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN
