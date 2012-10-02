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
; Macro para recibir entrada de teclado.
;***********************************************************************************
GET_ET		MACRO CADENA
			MOV AH, 10H			; DESPLEGAR MENSAJE
			INT 16H
			MOV ASCII, AL
			MOV RASTREO, AH
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
; Macro para obtener la posición del cursor en la pantalla.
;***********************************************************************************
GET_CUR    	MACRO  PAG
			MOV    AH, 03H			;Obtiene la posición actual del cursor
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

INSERTAR_CAD	MACRO CADENA_COPIAR, LONG_CAD_COP
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CADENA_COPIAR, CADENA_DEST[BX], LONG_STRING2
				ADD BX, LONG_CAD_COP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				SUMAM CANT_CAR, LONG_STRING2
				MOVM SUMA, CANT_CAR
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
			
SET_SP			MACRO TROW, BROW, LCOL, LM
				MOV   TOPROW, TROW
				MOV   BOTROW, BROW
				MOV   LEFCOL, LCOL
				MOV   LONG_MEN, LM
				ENDM
				
;-------------------------------------------------------------------------------------------
	.MODEL SMALL
	.STACK 64
;-------------------------------------------------------------------------------------------
; Area de datos
.DATA
.386
B_MENUS			DB '  Archivo  Edición  Formato  Ayuda  ', 36 DUP (' '), '$'
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
LIMPIA			DB	30 DUP (' ')							 ; cadena para limpiar línea.
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

M_ARCHIVO		DB	0C9H, 10 DUP(0CDH), 0BBH	; Dibuja menu
				DB	0BAH, ' Abrir    ', 0BAH
				DB	0BAH, ' Guardar  ', 0BAH
				DB	0BAH, ' Salir    ', 0BAH
				DB	0C8H, 10 DUP(0CDH), 0BCH
				
M_EDICION		DB	0C9H, 22 DUP(0CDH), 0BBH	; Dibuja menu
				DB	0BAH, ' Cortar   			 ', 0BAH
				DB	0BAH, ' Copiar     			 ', 0BAH
				DB	0BAH, ' Pegar                ', 0BAH
				DB	0BAH, ' Copiar y Reemplazar  ', 0BAH
				DB	0C8H, 22 DUP(0CDH), 0BCH

M_ARCHIVO		DB	0C9H, 10 DUP(0CDH), 0BBH	; Dibuja menu
				DB	0BAH, ' Negrita  ', 0BAH
				DB	0BAH, ' Normal   ', 0BAH
				DB	0C8H, 10 DUP(0CDH), 0BCH
				
M_AYUDA			DB	0C9H, 18 DUP(0CDH), 0BBH	; Dibuja menu
				DB	0BAH, ' Manual de Ayuda  ', 0BAH
				DB	0BAH, ' Creditos         ', 0BAH
				DB	0C8H, 18 DUP(0CDH), 0BCH	

TABLA      		DW  ARCHIVO              	             ; Tabla de bifurcación con sus cuatro opciones
				DW  EDICION
				DW  FORMATO
				DW  AYUDA
				DW  HOME
				DW  ENDD
				DW  INSERT
				DW  PG_UP
				DW  PG_DOWN
				DW  
				DW
				DW
				DW
CAD_TABLA  		DB  3BH, 0, 3CH, 2, 3DH, 4, 3EH, 6, 47H, 8, 53H, 10, 52H, 12, 51H, 14, 49H, 16, 50H, 18, 4BH, 20, 4DH, 22, 48H, 24

;-------------------------------------------------------------------------------------------
; Inicio de código
.CODE

;-------------------------------------------------------------------------------------------
; PROCEDIMIENTOS
;-------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
; Imprime el menu de acuerdo a aja
;-------------------------------------------------------------------------------------------
B10MENU			PROC  NEAR
				PUSHA						; guardar todos los registros
				MOV	  DH, TOPROW+1			; fila superior de sombra
				LEA	  BP, SHADOW				; caracteres sombreados
B20:			MOV	  AX, 1301H				; dibujar caja sombreada
				MOV   BH, PAGINA			; PAGINA
				MOV	  BL, 60H				; atributo
				
				MOV	  CX, LONG_MEN					; 19 caracteres
				MOV	  DL, LEFCOL+1			; columna izq de sombra
				INT	  10H
				INC	  DH						; siguiente fila
				CMP	  DH, BOTROW+2			; se desplegaron todas las columnas?
				JNE	  B20						; no, repetir

				LEA	  BP, MENU				; linea del menu
				MOV	  DH, TOPROW				; fila
B30:
				MOV	  BX, PAGINA			;PAGINA
				MOV   BL, 71H				; atributo: azul sobre blanco
				MOV	  AX, 1300H				; solicitar menu de despliegue
				MOV	  CX, 19					; longitud de la linea
				MOV	  DL, LEFCOL					; columna
				PUSH  DX					; guarda el registro que contiene fila, columna
				INT   10H
				ADD	  BP, 19					; siguiente linea del menu
				POP	  DX						; recupera registro con fila, columna
				INC	  DH						; siguiente fila
				CMP	  DH, BOTROW+1			; se mostraron todas las filas?
				JNE	  B30						; no, repetir

				MOV   AX, 1301H			; desplegar prompt
				MOV	  BX, 0071H				; pagina y atributo
				LEA	  BP, PROMPT				; linea de prompt
				MOV	  CX, 133					; longitud de linea
				MOV	  DH, BOTROW+4			; fila y
				MOV	  DL, 00					; columna de pantalla
				INT	  10H
				POPA						; recuperar registros
				RET
B10MENU	ENDP

;------------------------------------------------------------------------------------------
ARCHIVO			PROC  NEAR
				SET_SP 1, 5, 0, 12
				
ARCHIVO			ENDP

EDICION			PROC  NEAR
EDICION 		ENDP

FORMATO			PROC  NEAR
FORMATO			ENDP

AYUDA			PROC  NEAR
AYUDA			ENDP


;-------------------------------------------------------------------------------------------
; Menus
;-------------------------------------------------------------------------------------------
MOSTRAR_MENU	PROC  NEAR
				CALL  Q10CLEAR                ; Se limpia la pantalla.
				CALL  B10MENU					; Desplegar menu
				MOV   ROW, TOPROW+1			; Fijar la fila en la primera opcion
				MOV   ATTRIB, 17H				; fijar video inverso
				CALL  D10DISPLY				; resaltar linea actual
				CALL  C10INPUT				; leer opcion de menu
				CMP	  INGRESO, 1BH			;  presiono esc?
				JNE	  A20						; no, continuar
FIN:		    MOV	  AX, 0600H					; si, terminar
				CALL  Q10CLEAR				; limpiar pantalla
				RET
MOSTRAR_MENU	ENDP


;-------------------------------------------------------------------------------------------
; fLUJO LÓGICO DEL PROGRAMA
;-------------------------------------------------------------------------------------------
FLUJO			PROC  NEAR
VUELVE:	   		CLEAN_BUFF				
AGAIN:      	GET_ET
				CMP   ASCII, 0
				JE    FUN_ES
				INSERT_C ASCII 
IMP_P:			CALL  REND_CAD
				CALL  SET_STR
				JMP   VUELVE
FUN_ES:			CLD						; izq a der
				MOV	  AL, RASTREO		; busca ‘a’ en TEXTO
				MOV	  CX, 13
				LEA	  DI, CAD_TABLA
COMP:			SCASB			; repite mientras no 
				JE    SALTA
				INC   DI
				LOOP  COMP
				JMP   VUELVE
SALTA:     		XOR	  BX, BX
				MOV   BL, [DI]   	; obtener el codigo
				CALL  [TABLA+BX] 	; salta a la tabla
				JMP   IMP_P
FLUJO			ENDP

;--------------------------------------------------------------------------------------------
; Necesita pasar a STRING, la cadena a renderizar, y en CANT_CAR, cantidad de caracteres de
; de dicha cadena.
;--------------------------------------------------------------------------------------------

REND_CAD		PROC  NEAR
				LEA   SI, STRING
RECORRER:		LODSB	
				CMP	  AL, 00H
				JE    SUP
CONTINUAR:		CALL  CMP_CANT_CAR
				JAE	  RECORRER
				RET
SUP:			MOV	  APUNT, SI
				SUB   APUNT, 1
				CALL  SUPRIMIR
				JMP   CONTINUAR
REND_CAD		ENDP

CMP_CANT_CAR	PROC  NEAR
				MOV   BX, CANT_CAR
				LEA   DX, STRING[BX-1]
				CMP	  SI, DX
				RET
CMP_CANT_CAR	ENDP

;--------------------------------------------------------------------------------------------
; Necesita pasar a STRING, la cadena a renderizar, y en CANT_CAR, cantidad de caracteres de
; de dicha cadena.
;--------------------------------------------------------------------------------------------

SET_STR			PROC  NEAR
				LEA   SI, STRING
RECORRER1:		CALL  CMP_CANT_CAR
				JE    FIN
				MOV	  AL, [SI]
				MOV   CHAR, AL
				GET_CUR
				CMP   DL, 79
				JE	  VERIFICAR
				CMP	  CHAR, 13
				JE	  ENTERR
				CMP   CHAR, 09
				JE    TAB
IMPR:			DESPC CHAR
				INC   SI
				JMP   RECORRER1
ENTERR:			CALL  HAY_ENTER
				JMP   RECORRER1
VERIFICAR:		CALL  BAJAR_P
				JMP   RECORRER1
TAB:			CALL  HAY_TAB
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
				DESPC 32
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

;----------------------------------------------------------------------------------------------
; Procedimiento para insertar 10 espacios en el String, simulando un tabulador. El primer y último
; espacio es distinto a NULL para poder ubicarlo en el String. Si al insertarlo es mayor a la 
; longitud del String, no se inserta.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				LONG_STRING1: Capacidad total del String. 
;				CANT_CAR: Cantidad de caracteres ingresados por el usuario hasta el momento.
;				LONG_LINE: largo de la línea. 80 caracteres.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
TABULADOR		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOV AX, LONG_STRING1
				SUMAM CANT_CAR, LONG_TAB
				CMP SUMA, AX
				JA SALE_TAB
				MOV AX, LONG_STRING1
				CMP APUNTADOR_CAD, AX
				JE SALE_TAB
				INSERTAR_CAD STR_TAB, LONG_TAB
SALE_TAB:		POPA
				RET
TABULADOR		ENDP

MAIN		PROC  FAR
			INICIO
			CALL REND_CAD
			CALL SET_STR
			MOV   AX, 4C00H		;salida al DOS
			INT   21H
MAIN		ENDP 
;-------------------------------------------------------------------------------------------
			END MAIN