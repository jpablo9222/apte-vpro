

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
			MOV CX, LONGITUD
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
			MOV CX, LONGITUD
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
CADENA_DEST		DB	'Hoy es un bonito dia...       ', '$'
LONG_STRING1	DW	30
CANT_CAR		DW	23	
APUNTADOR_CAD	DW 	6
COP_APUNT_CAD	DW	?
CADENA_AUX		DB 	'                              ',0DH, 0AH,'$'
LONG_AUX		DW	30
S_2_INS			DB	'***','$'
LONG_STRING2	DW	3
LIMPIA			DB	30 DUP (' ')							 ; cadena para limpiar línea.
LONG_COP		DW	?
SUMA			DW  ?
COCIENTE		DW	?
RESIDUO			DW 	?
CADENA_COPIAR	DB	30 DUP (' '), '$'
LONG_CADP		DW	30
APUNT_CORTAR	DW	0
CONT_NULL		DW 	0
FILA_ACTUAL 	DB	?
COL_ACTUAL 		DB	?
NUM_PAG			DB	?
LONG_LINE		DW	30
NUM_LINE		DB	?
CONT_TAB		DB	0


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
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JE SUPR_NULL
				CMP AL, 07H
				JE SALE_SUPR
				INC APUNTADOR_CAD
				CALL BACKSPACE
SALE_SUPR:		POPA
				RET
SUPR_NULL:		MOV CONT_NULL, 0
				MOV CADENA_DEST[BX], 01H
CONT_N:			MOV AX, APUNTADOR_CAD
				CMP AX, LONG_STRING1
				JE SALE_SUPR
				INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				CALL BACKSPACE
				JMP SALE_SUPR
SUPRIMIR		ENDP
		
ELIM_STR		PROC NEAR
				PUSHA
				MOV CX, LONG_CADP
				;INC CX
CIC_ELI:		CALL SUPRIMIR
				JE F_CIC_ELI
				LOOP CIC_ELI
F_CIC_ELI:		POPA
				RET
ELIM_STR		ENDP

CORTAR_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_STRING1
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_COPIAR, LONG_CADP
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, LONG_CADP
				MOVM LONG_STRING1, APUNT_CORTAR
				CALL ELIM_STR
				POPA
				RET
CORTAR_CAD		ENDP

INICIO_LINE		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				DIVIDIR COP_APUNT_CAD, LONG_LINE
				RESTAM COP_APUNT_CAD, RESIDUO
				MOVM COP_APUNT_CAD, LONG_COP
				POPA
				RET
INICIO_LINE		ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_IZ			PROC NEAR
				PUSHA
FIND_ASCII:		CMP APUNTADOR_CAD, 0
				JE SALE_IZ
				DEC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H
				JE FIND_ASCII
SALE_IZ:		POPA
				RET
MOVC_IZ			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_DER		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
BUSCAR_ASCII:	MOV AX, LONG_STRING1
				CMP COP_APUNT_CAD, AX
				JE REG_APUNT
				INC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE BUSCAR_ASCII
				MOVM COP_APUNT_CAD, APUNTADOR_CAD
SALE_DER:		POPA
				RET
REG_APUNT:		MOVM APUNTADOR_CAD, APUNTADOR_CAD
				JMP SALE_DER
MOVC_DER		ENDP

DISTANCIA_MENOR PROC NEAR
				PUSHA
MOV_IZ:			CMP CONT_TAB,5
				JE C_DER
				INC COP_APUNT_CAD
				INC CONT_TAB
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE MOV_IZ
SALE_MEN:		MOVM COP_APUNT_CAD, APUNTADOR_CAD
				MOV CONT_TAB, 0
				POPA
				RET
C_DER:			DEC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE C_DER
				JMP SALE_MEN
DISTANCIA_MENOR ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_UP			PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOV AX, LONG_LINE
				CMP COP_APUNT_CAD, AX
				JB SALE_UP
				RESTAM APUNTADOR_CAD, LONG_LINE
				MOV APUNTADOR_CAD, BX
				CMP CADENA_DEST[BX], 00H
				JE BUSC_ASCII
SALE_UP:		POPA
				RET
BUSC_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_UP
MOVC_UP			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_DOWN		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				SUMAM COP_APUNT_CAD, LONG_LINE
				MOV AX, LONG_STRING1
				CMP SUMA, AX
				JA SALE_UP
				SUMAM APUNTADOR_CAD, LONG_LINE
				MOV APUNTADOR_CAD, BX
				CMP CADENA_DEST[BX], 00H
				JE BUS_ASCII
SALE_DOWN:		POPA
				RET
BUS_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_DOWN
MOVC_DOWN		ENDP


MAIN PROC FAR

		INICIO
		;DESP CADENA_DEST
		;CALL INSERTAR_C
		;CALL INSERTAR_CAD
		;CALL BACKSPACE
		;CALL SUPRIMIR
		;CALL CORTAR_CAD
		;CALL MOVC_IZ
		;CALL MOVC_DER
		;CALL MOVC_UP
		CALL MOVC_DOWN
		CALL INSERTAR_C
		DESP CADENA_DEST
		;DESP CADENA_COPIAR
		

		MOV   AX, 4C00H		;salida al DOS
		INT   21H
MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN


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
CADENA_DEST		DB	'Hoy es un bonito dia...       ', '$'
LONG_STRING1	DW	30
CANT_CAR		DW	23	
APUNTADOR_CAD	DW 	6
COP_APUNT_CAD	DW	?
CADENA_AUX		DB 	'                              ',0DH, 0AH,'$'
LONG_AUX		DW	30
S_2_INS			DB	'***','$'
LONG_STRING2	DW	3
LIMPIA			DB	30 DUP (' ')							 ; cadena para limpiar línea.
LONG_COP		DW	?
SUMA			DW  ?
COCIENTE		DW	?
RESIDUO			DW 	?
CADENA_COPIAR	DB	30 DUP (' '), '$'
LONG_CADP		DW	30
APUNT_CORTAR	DW	0
CONT_NULL		DW 	0
FILA_ACTUAL 	DB	?
COL_ACTUAL 		DB	?
NUM_PAG			DB	?
LONG_LINE		DW	30
NUM_LINE		DB	?
CONT_TAB		DB	0


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
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JE SUPR_NULL
				CMP AL, 07H
				JE SALE_SUPR
				INC APUNTADOR_CAD
				CALL BACKSPACE
SALE_SUPR:		POPA
				RET
SUPR_NULL:		MOV CONT_NULL, 0
				MOV CADENA_DEST[BX], 01H
CONT_N:			MOV AX, APUNTADOR_CAD
				CMP AX, LONG_STRING1
				JE SALE_SUPR
				INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				CALL BACKSPACE
				JMP SALE_SUPR
SUPRIMIR		ENDP
		
ELIM_STR		PROC NEAR
				PUSHA
				MOV CX, LONG_CADP
				;INC CX
CIC_ELI:		CALL SUPRIMIR
				JE F_CIC_ELI
				LOOP CIC_ELI
F_CIC_ELI:		POPA
				RET
ELIM_STR		ENDP

CORTAR_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_STRING1
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_COPIAR, LONG_CADP
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, LONG_CADP
				MOVM LONG_STRING1, APUNT_CORTAR
				CALL ELIM_STR
				POPA
				RET
CORTAR_CAD		ENDP

INICIO_LINE		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				DIVIDIR COP_APUNT_CAD, LONG_LINE
				RESTAM COP_APUNT_CAD, RESIDUO
				MOVM COP_APUNT_CAD, LONG_COP
				POPA
				RET
INICIO_LINE		ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_IZ			PROC NEAR
				PUSHA
FIND_ASCII:		CMP APUNTADOR_CAD, 0
				JE SALE_IZ
				DEC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H
				JE FIND_ASCII
SALE_IZ:		POPA
				RET
MOVC_IZ			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_DER		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
BUSCAR_ASCII:	MOV AX, LONG_STRING1
				CMP COP_APUNT_CAD, AX
				JE REG_APUNT
				INC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE BUSCAR_ASCII
				MOVM COP_APUNT_CAD, APUNTADOR_CAD
SALE_DER:		POPA
				RET
REG_APUNT:		MOVM APUNTADOR_CAD, APUNTADOR_CAD
				JMP SALE_DER
MOVC_DER		ENDP

DISTANCIA_MENOR PROC NEAR
				PUSHA
MOV_IZ:			CMP CONT_TAB,5
				JE C_DER
				INC COP_APUNT_CAD
				INC CONT_TAB
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE MOV_IZ
SALE_MEN:		MOVM COP_APUNT_CAD, APUNTADOR_CAD
				MOV CONT_TAB, 0
				POPA
				RET
C_DER:			DEC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE C_DER
				JMP SALE_MEN
DISTANCIA_MENOR ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_UP			PROC NEAR
				PUSHA
				CALL INICIO_LINE
				CMP COP_APUNT_CAD, 0
				JE SALE_UP
				RESTAM APUNTADOR_CAD, LONG_LINE
				MOV APUNTADOR_CAD, BX
				CMP CADENA_DEST[BX], 00H
				JE BUSC_ASCII
SALE_UP:		POPA
				RET
BUSC_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_UP
MOVC_UP			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ' ' DESPUÉS DE TODOS LOS NULL Y TAB ANTES, DEBE SER PAR.
MOVC_DOWN		PROC NEAR
				PUSHA
				CALL INICIO_LINE
				SUMAM COP_APUNT_CAD, LONG_LINE
				MOV AX, LONG_LINE
				CMP COP_APUNT_CAD, AX
				JE SALE_UP
				SUMAM APUNTADOR_CAD, LONG_LINE
				MOV APUNTADOR_CAD, BX
				CMP CADENA_DEST[BX], 00H
				JE BUS_ASCII
SALE_DOWN:		POPA
				RET
BUS_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_DOWN
MOVC_DOWN		ENDP


MAIN PROC FAR

		INICIO
		;DESP CADENA_DEST
		;CALL INSERTAR_C
		;CALL INSERTAR_CAD
		;CALL BACKSPACE
		;CALL SUPRIMIR
		;CALL CORTAR_CAD
		DESP CADENA_DEST
		;DESP CADENA_COPIAR
		

		MOV   AX, 4C00H		;salida al DOS
		INT   21H
MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN
