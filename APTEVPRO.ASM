

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

INSERTAR_CAD	MACRO CADENA_COPIAR, LONG_CAD_COP
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CADENA_COPIAR, CADENA_DEST[BX], LONG_CAD_COP
				ADD BX, LONG_CAD_COP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				SUMAM CANT_CAR, LONG_CAD_COP
				MOVM SUMA, CANT_CAR
				SUMAM APUNTADOR_CAD, LONG_CAD_COP
				MOVM SUMA, APUNTADOR_CAD
				POPA
				ENDM
			
	.MODEL SMALL
	.STACK 64
	.386
;-------------------------------------------------------------------------------------------
; Inicio de Datos
	.DATA


CARACTER_NULL	DB	00H
STR_ERROR_PEG	DB  'ERROR: La cadena que desea pegar es mayor a la capacidad de almacenamiento del programa$'			
CARACTER		DB	 '*$'
CADENA_DEST		DB	'Hoy es un bonito dia...                 *                                      ', '$'
LONG_STRING1	DW	80
CANT_CAR		DW	41	
APUNTADOR_CAD	DW 	6
COP_APUNT_CAD	DW	?
CADENA_AUX		DB 	40 DUP (' '),'$'
LONG_AUX		DW	40
S_2_INS			DB	'**********','$'
LONG_STRING2	DW	10
LIMPIA			DB	40 DUP (' ')							 ; cadena para limpiar línea.
LONG_COP		DW	?
SUMA			DW  ?
COCIENTE		DW	?
RESIDUO			DW 	?
CADENA_COPIAR	DB	40 DUP (' '), '$'
LONG_CADP		DW	40
APUNT_CORTAR	DW	0
CONT_NULL		DW 	0
FILA_ACTUAL 	DB	?
COL_ACTUAL 		DB	?
NUM_PAG			DB	?
LONG_LINE		DW	40
NUM_LINE		DB	?
STR_TAB			DB 	' ',0H,0H,0H,0H,0H,0H,0H,0H,0H
LONG_TAB		DW	10
CONT_TAB		DW	0
STRING_NULL		DB	40 DUP (0H), '$'


	.CODE


;----------------------------------------------------------------------------------------------
; Procedimiento auxiliar para borrar el caracter anterior a la posición del apuntador:
; Parámetros: 	CADENA_AUX Y LONG_AUX: cadena donde se insertan los caracteres que no se borrarán.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;				CADENA_DEST: cadena sobre la cual se trabaja durante el programa. 
;----------------------------------------------------------------------------------------------
COP_BS			PROC NEAR
				;PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX					
				MOV AX, CONT_NULL								
				SUB APUNTADOR_CAD, AX								; Se coloca el apuntador en la posición adecuada.
				RESTAM CANT_CAR, APUNTADOR_CAD						; Se obtiene la longitud de cadena a copiar.
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP 	;Se copia a la cadena auxiliar
				DEC BX
				MOV APUNTADOR_CAD, BX								; Se mueve el apuntador a la nueva posición.
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP 	;Se copia la cadena auxiliar en la nueva posición.
				LIMPIAR CADENA_AUX, LONG_AUX
				DEC CANT_CAR									
				MOV BX, CANT_CAR
				COPIAR_CAD CARACTER_NULL, CADENA_DEST[BX], 1		; Se inserta un NULL en la última posición de la cadena anterior.
				;POPA
				RET
COP_BS			ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento auxiliar para borrar el caracter anterior a la posición del apuntador:
; Parámetros: 	CADENA_AUX Y LONG_AUX: cadena donde se insertan los caracteres que no se borrarán.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;				COP_APUNT_CAD: proveniente del método principal BACKSPACE
;				CADENA_DEST: cadena sobre la cual se trabaja durante el programa. 
;----------------------------------------------------------------------------------------------
COP_BSNULL		PROC NEAR
				PUSHA
NULL_AG:		DEC COP_APUNT_CAD								
				MOV BX, COP_APUNT_CAD
				MOV AL, CADENA_DEST[BX]								; Se compara con 00H en búsqueda de
				CMP AL, 00H											; más NULL por eliminar.
				JNE	SAL_NULL
				INC CONT_NULL
				DEC CANT_CAR
				JMP NULL_AG
SAL_NULL:		MOV CX, CONT_NULL								
				SUMAM CANT_CAR, CONT_NULL
				RESTAM SUMA, APUNTADOR_CAD							; Se obtiene la longitud de cadena a copiar.
				MOV BX, APUNTADOR_CAD								
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP	; Se copia la cadena auxiliar en la nueva posición.
				INC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				IMP_NULLS CADENA_DEST, CANT_CAR, CONT_NULL			; Se imprimen los NULL necesarios para eliminar los caracteres.
				POPA
				RET
COP_BSNULL		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para borrar el caracter anterior a la posición del apuntador:
; Parámetros: 	APUNTADOR_CAD: para conocer el caracter a borrar.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;				CADENA_DEST: cadena sobre la cual se trabaja durante el programa. 
;----------------------------------------------------------------------------------------------
BACKSPACE		PROC NEAR
				PUSHA
				CMP APUNTADOR_CAD, 0								; Se comprueba que no esté en la primera columna y fila
				JE  SALE_BS											; del áreaescritura, si lo está, no ejecuta la acción.
IN_BS:			MOVM APUNTADOR_CAD, COP_APUNT_CAD					; Se hace una copia del apuntador para guardar el mismo.
				DEC COP_APUNT_CAD								
				MOV BX, COP_APUNT_CAD							
				MOV AL, CADENA_DEST[BX]								; Se obtiene el caracter anterior al apuntador, si es NULL
				CMP AL, 00H											; se ejecutan instrucciones para eliminar todos los NULL,
				JE	ELIM_NULL										; de lo contario, se elimina solamente un caracter del String.
				CALL COP_BS
SALE_BS:		POPA
				RET
				MOV CONT_NULL, 0									; Se inicializa CONT_NULL
ELIM_NULL:		INC CONT_NULL										
				DEC CANT_CAR
				CALL COP_BSNULL										
				JMP IN_BS
BACKSPACE		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para borrar caracter donde se encuentra posicionado el apuntador, utiliza a 
; BACKSPACE para su total funcionamiento.
; Parámetros: 	APUNTADOR_CAD: para conocer el caracter a borrar.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;----------------------------------------------------------------------------------------------
SUPRIMIR		PROC NEAR
				PUSHA
				MOV AX, APUNTADOR_CAD								; Si está al final del String, no ejecuta la acción.
				CMP AX, LONG_STRING1
				JE SALE_SUPR
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]								; Se compara el caracter de la posición en búsqueda 
				CMP AL, 00H											; de algún NULL, si los hay, se accede a su correcto
				JE SUPR_NULL										; procesamiento.
				CMP AL, 01H											; 01H funciona como caracter indicador de finalizado.
				JE SALE_SUPR
				INC APUNTADOR_CAD
				CALL BACKSPACE
SALE_SUPR:		POPA
				RET
SUPR_NULL:		MOV CONT_NULL, 0									; Se inicializa CONT_NULL
				MOV CADENA_DEST[BX], 01H							; Se sustituye el primer caracter por uno cualquiera.
CONT_N:			MOV AX, APUNTADOR_CAD
				CMP AX, LONG_STRING1								; Se corrobora que no haya alcanzado el final del String.
				JE SALE_SUPR
				INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]								; Se compara en búsqueda de más NULL.
				CMP AL, 00H
				JE CONT_N
				CALL BACKSPACE
				JMP SALE_SUPR
SUPRIMIR		ENDP
		
ELIM_STR		PROC NEAR
				PUSHA
				MOV CX, LONG_LINE
CIC_ELI:		CALL BACKSPACE
				JE F_CIC_ELI
				LOOP CIC_ELI
F_CIC_ELI:		POPA
				RET
ELIM_STR		ENDP

CORTAR_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_COPIAR, LONG_CADP
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, LONG_CADP
				SUMAM APUNTADOR_CAD, LONG_LINE
				MOVM SUMA, APUNTADOR_CAD
				CALL ELIM_STR
				POPA
				RET
CORTAR_CAD		ENDP

COPIA_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_COPIAR, LONG_CADP
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, LONG_CADP
				SUMAM APUNTADOR_CAD, RESIDUO
				MOVM SUMA, APUNTADOR_CAD
				POPA
				RET
COPIA_CAD		ENDP

PEGA_CAD		PROC NEAR
				PUSHA
				MOV AX, LONG_STRING1
				CMP CANT_CAR, AX
				JA SALE_PEGA
				MOV BX, APUNTADOR_CAD
				RESTAM CANT_CAR, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CADENA_COPIAR, CADENA_DEST[BX], LONG_CADP
				ADD BX, LONG_CADP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				SUMAM CANT_CAR, LONG_CADP
				MOVM SUMA, CANT_CAR
				SUMAM APUNTADOR_CAD, LONG_CADP
				MOVM SUMA, APUNTADOR_CAD
SALE_PEGA:		DESP STR_ERROR_PEG
				POPA
				RET
PEGA_CAD		ENDP

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

TABULADOR		PROC NEAR
				PUSHA
				INSERTAR_CAD STR_TAB, LONG_TAB
				POPA
				RET
TABULADOR		ENDP


MAIN PROC FAR

		INICIO
		;DESP CADENA_DEST
		;CALL INSERTAR_C
		;INSERTAR_CAD S_2_INS, LONG_STRING2
		;CALL BACKSPACE
		;CALL SUPRIMIR
		;CALL CORTAR_CAD
		;CALL MOVC_IZ
		;CALL MOVC_DER
		;CALL MOVC_UP
		;CALL MOVC_DOWN
		CALL TABULADOR
		CALL MOVC_IZ
		CALL SUPRIMIR
		;CALL COPIA_CAD
		;CALL PEGA_CAD
		;DESP CADENA_COPIAR
		DESP CADENA_DEST
		;DESP CADENA_COPIAR
		

		MOV   AX, 4C00H		;salida al DOS
		INT   21H
MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN
