TITLE PJP
;-------------------------------------------------------------------------------------------
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
			LEA SI, LIMPIA		; Cadena vac�a
			LEA DI, CADENA
			REP	MOVSB
			ENDM			
;----------------------------------------------------------------------------------------------
; Macro para inicializar el �rea de datos
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
; Macro para restar variables.
;***********************************************************************************
SUMAM		MACRO SUMANDO1, SUMANDO2
			PUSHA
			MOV AX, SUMANDO1
			ADD AX, SUMANDO2
			MOV SUMA, AX
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
			
;***********************************************************************************
; Macro para obtener la posici�n del cursor en la pantalla.
;***********************************************************************************
GET_CUR    	MACRO  PAG
			MOV    AH, 03H			;Obtiene la posici�n actual del cursor
			MOV    BH, PAG
			INT    10H
			MOV    FILA_ACTUAL, DH
			MOV    COL_ACTUAL, DL
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

INSERTAR_C 	MACRO CARACTER
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
			ENDM

;***********************************************************************************
; Macro para desplegar una caracter.
;***********************************************************************************
DESPC		MACRO CARACTER
			MOV AH, 02H			; DESPLEGAR MENSAJE
			MOV DL, CARACTER
			INT 21H
			ENDM
;-------------------------------------------------------------------------------------------
	.MODEL SMALL
	.STACK 64
;-------------------------------------------------------------------------------------------
; Area de datos
.DATA
.386
B_MENUS			DB '  Archivo  Edici�n  Formato  Ayuda  ', 36 DUP (' '), '$'
INICIO_CAD		DW	?			
CARACTER		DB	?
CADENA_DEST		DB	'Hoy es un bonito dia...    ', '$'
LONG_STRING1	DW	30
CANT_CAR		DW	23	
APUNTADOR_CAD	DW 	5
COP_APUNT_CAD	DW	?
CADENA_AUX		DB 	'                              ',0DH, 0AH,'$'
LONG_AUX		DB	30
S_2_INS			DB	'***','$'
LONG_STRING2	DW	3
LIMPIA			DB	30 DUP (' ')							 ; cadena para limpiar l�nea.
LONG_COP		DW	?
CONT_NULLS		DW  0
SUMA			DW  ?
CANT_NULL		DW  0
INICIO_NULL		DW	?
POS_INSERT		DW	?
CHAR			DB	?
STR0			DB	?
FILA_ACTUAL		DB	?
COL_ACTUAL		DB	?


;-------------------------------------------------------------------------------------------
; Inicio de c�digo
.CODE

;-------------------------------------------------------------------------------------------
; PROCEDIMIENTOS
;-------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------
; Necesita pasar a STRING, la cadena a renderizar, y en CANT_CAR, cantidad de caracteres de
; de dicha cadena.
;--------------------------------------------------------------------------------------------

REND_CAD		PROC  NEAR
				LEA   SI, STRING
RECORRER:		LODSB	
				CMP	  AL, 00H
				JE    SUP
CONTINUAR:		MOV   BX, CANT_CAR
				DEC	  BX
				CMP   BX, SI
				JAE	  RECORRER
				RET
SUP:			MOV	  APUNT, SI
				SUB   APUNT
				CALL  SUPRIMIR
				JMP CONTINUAR
REND_CAD		ENDP

;--------------------------------------------------------------------------------------------
; Necesita pasar a STRING, la cadena a renderizar, y en CANT_CAR, cantidad de caracteres de
; de dicha cadena.
;--------------------------------------------------------------------------------------------

SET_STR			PROC  NEAR
				LEA   SI, STRING
				MOVM  CANT_CAR, COP_CANT_CAR
				SUB	  COP_CANT_CAR,1
RECORRER1:		CMP	  SI, COP_CANT_CAR
				JE    FIN
				MOV	  AL, [SI]
				MOV   CHAR, AL
				GET_CUR
				CMP   DL, 79
				JE	  VERIFICAR
				CMP	  CHAR, 27
				JE	  ENTERR
IMPR:			DESPC CHAR
				INC   SI
				JMP   RECORRER1
ENTERR:			CALL  HAY_ENTER
				JMP   RECORRER1
VERIFICAR:		CALL  BAJAR_P
				JMP   RECORRER1
FIN:		    RET
SET_STR			ENDP

BAJAR_P			PROC  NEAR
				CMP   CHAR, 32
				JE	  IMP
				CMP   CHAR, 00H
				JE    IMP
NO_SPACE:		DEC   SI
				INC   NULL_A_IMP
				MOV   AL, [SI]
				CMP   AL, 32
				JNE   NO_SPACE
				ADD   SI, 1
				MOV   APUNTADOR_CAD, SI
				MOV	  CX, NULL_A_IMP
				MOVM  STRING, CADENA_DEST
VOLVER:			INSERT_C 00H 
				INC	  APUNTADOR_CAD
				LOOP VOLVER
SAL_BAJAR:		RET
IMP:			DESPC CHAR
				INC   SI
				JMP   SAL_BAJAR
BAJAR_P			ENDP

HAY_ENTER		PROC  NEAR
				INC   SI
				MOV   LARGO, 78
				SUB   LARGO, DL
				MOV	  CX, LARGO
				MOV   APUNTADOR_CAD, SI
				MOVM  STRING, CADENA_DEST
VOLVER1:		INSERT_C 00H 
				INC   APUNTADOR_CAD
				LOOP VOLVER1
				RET
HAY_ENTER		ENDP

MAIN		PROC  FAR
			INICIO
			CALL REND_CAD
			CALL SET_STR
			MOV   AX, 4C00H		;salida al DOS
			INT   21H
MAIN		ENDP 
;-------------------------------------------------------------------------------------------
			END MAIN