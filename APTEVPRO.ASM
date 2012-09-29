

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
; Macro para desplegar una caracter.
;***********************************************************************************
DESPC		MACRO CARACTER
			MOV AH, 02H			; DESPLEGAR MENSAJE
			MOV DL, CARACTER
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
DIVIDIR		MACRO DIVIDENDO, DIVISOR
			PUSHA
			MOV BX, DIVISOR
			MOV DX, 0
			MOV AX, DIVIDENDO
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

ELIMINAR_STRING	MACRO VECES
			PUSHA
			LOCAL CIC_ELI
			XOR CX, CX
			MOV CL, VECES
CIC_ELI:	CALL BACKSPACE
			LOOP CIC_ELI
			POPA
			RET
			ENDM	

IMP_NULLS	MACRO CADENA, APUNTADOR, VECES
			PUSHA
			MOV BX, APUNTADOR
			MOV CX, VECES
			LEA DI, CADENA[BX]
			MOV AL, 00H
			REP STOSB
			POPA
			ENDM
			
	.MODEL SMALL
	.STACK 64
	.386
;-------------------------------------------------------------------------------------------
; Inicio de Datos
	.DATA


CARACTER_NULL	DB	00H			
CARACTER		DB	 '*$'
CADENA_DEST		DB	'Hoy es',0H, 0H,' un bonito dia...    ', '$'
LONG_STRING1	DW	31
CANT_CAR		DW	25	
APUNTADOR_CAD	DW 	6
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
RESIDUO			DW 	?
CADENA_COPIAR	DB	30 DUP (' '), '$'
LONG_CADP		DB	30
APUNT_CORTAR	DW	?
CONT_NULL		DW 	0

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
				MOV AX, CONT_NULL
				SUB APUNTADOR_CAD, AX
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

COP_BSNULL		PROC NEAR
				PUSHA
NULL_AG:		DEC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JNE	SAL_NULL
				INC CONT_NULL
				DEC CANT_CAR
				JMP NULL_AG
SAL_NULL:		MOV CX, CONT_NULL
				SUMAM CANT_CAR, CONT_NULL
				RESTAM SUMA, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				INC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				IMP_NULLS CADENA_DEST, CANT_CAR, CONT_NULL
				POPA
				RET
COP_BSNULL		ENDP

BACKSPACE		PROC NEAR
				PUSHA
				CMP APUNTADOR_CAD, 0
				JE  SALE_BS
IN_BS:			MOVM APUNTADOR_CAD, COP_APUNT_CAD
				DEC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JE	ELIM_NULL
				CALL COP_BS
SALE_BS:		POPA
				RET
				MOV CONT_NULL, 0
ELIM_NULL:		INC CONT_NULL
				DEC CANT_CAR
				CALL COP_BSNULL
				JMP IN_BS
BACKSPACE		ENDP

SUPRIMIR		PROC NEAR
				PUSHA
				MOV AX, APUNTADOR_CAD
				CMP AX, LONG_STRING1
				JE SALE_SUPR
				INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JE SUPR_NULL
				INC APUNTADOR_CAD
				CALL BACKSPACE
SALE_SUPR:		POPA
				RET
SUPR_NULL:		MOV CONT_NULL, 0
				MOV CADENA_DEST[BX], 01H
CONT_N:			DEC CANT_CAR
				INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JE CONT_N
				CALL BACKSPACE
				JMP SALE_SUPR
SUPRIMIR		ENDP
		
ELIM_STR		PROC NEAR
				PUSHA
				XOR CX, CX
				MOV CL, LONG_CADP
CIC_ELI:		CALL BACKSPACE
				LOOP CIC_ELI
				POPA
				RET
ELIM_STR		ENDP

CORTAR_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, 30
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_AUX, LONG_AUX
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, 30
				ADD APUNTADOR_CAD, 30
				CALL ELIM_STR
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
		;CALL CORTAR_CAD
		DESP CADENA_DEST
		

		MOV   AX, 4C00H		;salida al DOS
		INT   21H
MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN
