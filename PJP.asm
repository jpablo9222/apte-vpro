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
			
SET_SP			MACRO TROW, BROW, LCOL, LM, MEN
				MOV   TOPROW, TROW
				MOV   BOTROW, BROW
				MOV   LEFCOL, LCOL
				MOV   LONG_MEN, LM
				LEA   DX, MEN
				MOV   MENU, DX
				ENDM
				
;-------------------------------------------------------------------------------------------
	.MODEL SMALL
	.STACK 64
;-------------------------------------------------------------------------------------------
; Area de datos
.DATA
.386

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

PAGINA			DB  0
TOPROW			DB	?					    	; Fila superior menu
BOTROW			DB	?							; fila inferior menu
LEFCOL			DB	?							; Columna izquierda menu
ATTRIB			DB	?							; Atributo de pantalla
ROW				DB	?							; Fila pantalla
INGRESO			DB	?							; Guarda tecla ingresada
SHADOW			DB	19	DUP(0DBH)				; Caracteres de sombreado
MENU			DW  ?
LONG_MEN		DB  ?
B_MENUS			DB '  Archivo    Edici�n    Formato    Ayuda  ', 38 DUP (' '), '$'
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

M_FORMATO		DB	0C9H, 10 DUP(0CDH), 0BBH	; Dibuja menu
				DB	0BAH, ' Negrita  ', 0BAH
				DB	0BAH, ' Normal   ', 0BAH
				DB	0C8H, 10 DUP(0CDH), 0BCH
				
M_AYUDA			DB	0C9H, 18 DUP(0CDH), 0BBH	; Dibuja menu
				DB	0BAH, ' Manual de Ayuda  ', 0BAH
				DB	0BAH, ' Creditos         ', 0BAH
				DB	0C8H, 18 DUP(0CDH), 0BCH	

TABLA      		DW  ARCHIVO              	             ; Tabla de bifurcaci�n con sus cuatro opciones
				DW  EDICION
				DW  FORMATO
				DW  AYUDA
				;DW  HOME
				;DW  ENDD
				;DW  INSERT
				;DW  PG_UP
				;DW  PG_DOWN
				;DW  
				;DW
				;DW
				;DW
CAD_TABLA  		DB  3BH, 0, 3CH, 2, 3DH, 4, 3EH, 6, 47H, 8, 53H, 10, 52H, 12, 51H, 14, 49H, 16, 50H, 18, 4BH, 20, 4DH, 22, 48H, 24

;-------------------------------------------------------------------------------------------
; Inicio de c�digo
.CODE

;-------------------------------------------------------------------------------------------
; PROCEDIMIENTOS
;-------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
; Imprime el menu de acuerdo a aja
;-------------------------------------------------------------------------------------------
PAINT_MENU		PROC  NEAR
				PUSHA						; guardar todos los registros
				CALL  PAINT_SOMBRA
				CALL  PAINT_CUADRO
				POPA						; recuperar registros
				RET
PAINT_MENU		ENDP

PAINT_SOMBRA	PROC  NEAR
				MOV	  DH, TOPROW+1			; fila superior de sombra
				LEA	  BP, SHADOW				; caracteres sombreados
B20:			MOV	  AX, 1301H				; dibujar caja sombreada
				MOV   BH, PAGINA			; PAGINA
				MOV	  BL, 60H				; atributo
				
				MOVZX CX, LONG_MEN					; 19 caracteres
				MOV	  DL, LEFCOL+1			; columna izq de sombra
				INT	  10H
				INC	  DH						; siguiente fila
				CMP	  DH, BOTROW+2			; se desplegaron todas las columnas?
				JNE	  B20						; no, repetir
				RET
PAINT_SOMBRA	ENDP

PAINT_CUADRO	PROC  NEAR
				LEA   BP, M_ARCHIVO				; linea del menu
				MOV	  DH, TOPROW				; fila
B30:
				MOV	  BH, PAGINA			;PAGINA
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
				RET
PAINT_CUADRO	ENDP

;------------------------------------------------------------------------------------------
ARCHIVO			PROC  NEAR
				SET_SP 1, 5, 0, 12, M_ARCHIVO
				CALL  MOSTRAR_MENU
				RET
ARCHIVO			ENDP

EDICION			PROC  NEAR
				SET_SP 1, 6, 12, 24, M_EDICION
				CALL  MOSTRAR_MENU
				RET
EDICION 		ENDP

FORMATO			PROC  NEAR
				SET_SP 1, 4, 23, 12, M_FORMATO
				CALL  MOSTRAR_MENU
				RET
FORMATO			ENDP

AYUDA			PROC  NEAR
				SET_SP 1, 4, 34, 18, M_AYUDA
				CALL  MOSTRAR_MENU
				RET
AYUDA			ENDP


;-------------------------------------------------------------------------------------------
; Menus
;-------------------------------------------------------------------------------------------
MOSTRAR_MENU	PROC  NEAR
A20:			;CALL  Q10CLEAR                ; Se limpia la pantalla.
				CALL  PAINT_MENU					; Desplegar menu
				MOV   AL, TOPROW+1
				MOV   ROW, AL			; Fijar la fila en la primera opcion
				MOV   ATTRIB, 17H				; fijar video inverso
				;CALL  D10DISPLY				; resaltar linea actual
				;CALL  C10INPUT				; leer opcion de menu
				;CMP	  INGRESO, 1BH			;  presiono esc?
				;JNE	  A20						; no, continuar
FIN:		    ;MOV	  AX, 0600H					; si, terminar
				;CALL  Q10CLEAR				; limpiar pantalla
				RET
MOSTRAR_MENU	ENDP

C10INPUT 		PROC  NEAR
				PUSHA						; guardar registros
C20:			MOV	  AH, 10H					; leer caracter de teclado
				INT	  16H
				CMP	  AH, 50H					; cod rastreo flecha abajo?
				JE	  C30
				CMP	  AH, 48H					; cod rastreo flecha arriba?
				JE	  C40
				CMP	  AL, 0DH					; ascii enter?
				JE	  C100

				CMP	  AL, 1BH					; ascii esc?
				JE	  C90
				JMP	  C20
C30:			MOV	  INGRESO, AL
				MOV	  ATTRIB, 71H				; flecha-abajo, azul sobre blanco
				CALL  D10DISPLY			; regresar linea ant a video normal
				INC	  ROW						; fila siguiente
				MOV   AL, BOTROW
				DEC   AL
				CMP	  ROW, AL			; se paso de la ultima fila?
				JBE	  C50						; no, ok
				MOV   AL, TOPROW+1
				MOV	  ROW, AL		; si, iniciar fila
				JMP	  C50
C40:			MOV	  INGRESO, AL
				MOV   ATTRIB, 71H			; flecha-arriba, azul sobre blanco
				CALL  D10DISPLY			; regresar linea ant a video normal
				DEC	  ROW					; fila anterior
				MOV   AL, TOPROW
				INC   AL
				CMP	  ROW, AL		; se paso de la primera fila?
				JAE	  C50					; no, ok
				MOV   AL, BOTROW-1
				MOV	  ROW, AL		; si, iniciar fila

C50:			MOV	  INGRESO, AL
				MOV	  ATTRIB, 17H			; blanco sobre azul
				CALL  D10DISPLY			; fijar linea nueva a video inverso
				JMP	  C20
C100:  			MOV   ATTRIB, 75H
				CALL  D10DISPLY
				;CALL  OUT_M
C90:
				MOV	  INGRESO, AL
				POPA						; recuperar registros
				RET
C10INPUT 		ENDP

OUT_M   		PROC  NEAR
				PUSHA							; guardar registros
				MOVZX AX, ROW					; la fila indica que linea se seleccion�.
				SUB	  AL, TOPROW
				DEC   AX
				IMUL  AX, 29					; multiplicar por longitud de linea
				;LEA	  SI, MSJ_A					; para seleccionar mensaje correspondiente
				ADD	  SI, AX
				MOV   BP, SI
				;CALL  MSJ_PRO
				MOV   AH, 10H                 	;Se espera una tecla cualquiera para continuar.
				INT   16H
				POPA							; recuperar registros
				RET
OUT_M   		ENDP
; ----------------------------------------------------------------------
;
; ----------------------------------------------------------------------
D10DISPLY 		PROC  NEAR
				PUSHA							; guardar registros
				MOVZX AX, ROW					; la fila indica que linea fijar
				SUB	  AL, TOPROW
				IMUL  AX, 19					; multiplicar por longitud de linea
				LEA	  SI, MENU+1					; para seleccionar fila del menu
				ADD	  SI, AX

				MOV	  AX, 1300H					; solicita despliegue
				MOVZX BX, ATTRIB				; pagina y atributo
				MOV	  BP, SI						; caracter de cadena menu
				MOV	  CX, 17						; longitud de cadena menu
				MOV	  DH, ROW						; fila
				MOV	  DL, LEFCOL+1				; columna
				INT	  10H
				POPA							; recuperar registros
				RET
D10DISPLY 		ENDP

; ----------------------------------------------------------------------
; hola mundo.
; ----------------------------------------------------------------------
Q10CLEAR 		PROC  NEAR
				PUSHA							; guardar registros
				MOV	  AX, 0600H
				MOV	  BH, 2FH					; blanco sobre verde
				MOV	  CX, 0000H				; pantalla completa
				MOV	  DX, 184FH				; fila 24, col 79
				INT	  10H
				POPA							; recuperar registros
				RET
Q10CLEAR 		ENDP

;-------------------------------------------------------------------------------------------
; fLUJO L�GICO DEL PROGRAMA
;-------------------------------------------------------------------------------------------
;FLUJO			PROC  NEAR
;VUELVE:	   		CLEAN_BUFF				
;AGAIN:      	GET_ET
;				CMP   ASCII, 0
;				JE    FUN_ES
;				INSERT_C ASCII 
;IMP_P:			CALL  REND_CAD
;				CALL  SET_STR
;				JMP   VUELVE
;FUN_ES:			CLD						; izq a der
;				MOV	  AL, RASTREO		; busca �a� en TEXTO
;				MOV	  CX, 13
;				LEA	  DI, CAD_TABLA
;COMP:			SCASB			; repite mientras no 
;				JE    SALTA
;				INC   DI
;				LOOP  COMP
;				JMP   VUELVE
;SALTA:     		XOR	  BX, BX
;				MOV   BL, [DI]   	; obtener el codigo
;				CALL  [TABLA+BX] 	; salta a la tabla
;				JMP   IMP_P
;FLUJO			ENDP

MAIN			PROC  FAR
				INICIO
				CALL  ARCHIVO
				MOV   AX, 4C00H		;salida al DOS
				INT   21H
MAIN			ENDP 
;-------------------------------------------------------------------------------------------
			END MAIN