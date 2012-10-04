;***********************************************************************************
; Macro para obtener la posición del cursor en la pantalla.
;***********************************************************************************
GET_CUR    		MACRO  PAG
				MOV    AH, 03H			;Obtiene la posición actual del cursor
				MOV    BH, PAG
				INT    10H
				MOV    FILA_ACTUAL, DH
				MOV    COL_ACTUAL, DL
				ENDM

;----------------------------------------------------------------------------------------------
; Macro para posicionar el cursor en una posición específica en la pantalla.
;----------------------------------------------------------------------------------------------		   
SET_CUR    		MACRO  PAG, COL, FILA
				MOV    AH, 02H
				MOV    BH, PAG
				MOV    DL, COL
				MOV    DH, FILA
				INT    10H
				ENDM
;***********************************************************************************
; Macro para copiar una cadena a otra. 
;***********************************************************************************
COPIAR_CAD 		MACRO SOURCE, DESTINY, LONGITUD
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
DESP			MACRO CADENA
				MOV AH, 09H			; DESPLEGAR MENSAJE
				LEA DX, CADENA
				INT 21H
				ENDM
			
;***********************************************************************************
; Macro para desplegar una caracter.
;***********************************************************************************
DESPC			MACRO CARACTER
				MOV AH, 02H			; DESPLEGAR MENSAJE
				MOV DL, CARACTER
				INT 21H
				ENDM
			
;***********************************************************************************
; Macro para limpiar una cadena.
;***********************************************************************************
LIMPIAR			MACRO CADENA, LONGITUD
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
INICIO 	   		MACRO			; define macro
				MOV   AX, @DATA           ; inicializar area de datos
				MOV   DS, AX
				MOV   ES, AX
				MOV   AX, 0003H				; modo texto 03h
				INT   10H
				ENDM			; fin macro	

;***********************************************************************************
; Macro para restar variables.
;***********************************************************************************
RESTAM			MACRO MINUENDO, SUSTRAENDO
				PUSHA
				MOV AX, MINUENDO
				SUB AX, SUSTRAENDO
				MOV LONG_COP, AX
				POPA
				ENDM

;***********************************************************************************
; Macro para sumar variables.
;***********************************************************************************
SUMAM			MACRO SUMANDO1, SUMANDO2
				PUSHA
				MOV AX, SUMANDO1
				ADD AX, SUMANDO2
				MOV SUMA, AX
				POPA
				ENDM

;***********************************************************************************
; Macro para dividir variables.
;***********************************************************************************			
DIVIDIR			MACRO DIVIDENDO, DIVISOR
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
MOVM 			MACRO SRC, DTN
				PUSH AX
				MOV AX, SRC			; Fuente
				MOV DTN, AX			; Destino
				POP AX
				ENDM
				
;***********************************************************************************
; Macro para eliminar una línea completa.
;***********************************************************************************
ELIMINAR_STRING	MACRO VECES
				PUSHA
				LOCAL CIC_ELI
				XOR CX, CX
				MOV CL, VECES
CIC_ELI:		CALL BACKSPACE
				LOOP CIC_ELI
				POPA
				ENDM	

;*********************************************************************************************
; Macro para imprimir el caracter NULL n VECES comenzando en la posición que APUNTADOR indica
;*********************************************************************************************				
IMP_NULLS		MACRO CADENA, APUNTADOR, VECES
				PUSHA
				MOV BX, APUNTADOR
				MOV CX, VECES
				LEA DI, CADENA[BX]
				MOV AL, 00H
				REP STOSB
				POPA
				ENDM

;***********************************************************************************
; Macro para insertar una cadena de longitud LONG_CAD_COP
;***********************************************************************************				
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

;***********************************************************************************
; Macro para mover el apuntador a la coordenada (FILA, COLUMNA)
;***********************************************************************************				
SET_APUNTADOR   MACRO FILA, COLUMNA
				MOV AL, 80
				MUL FILA
				MOV APUNTADOR_CAD, AX
				XOR AX, AX
				MOV AL, COLUMNA
				ADD APUNTADOR_CAD, AX
				SUB APUNTADOR_CAD, 160
				ENDM
;***********************************************************************************
; Macro para desplegar una caracter.
;***********************************************************************************
DESPC			MACRO CARACTER
				MOV AH, 02H			; DESPLEGAR MENSAJE
				MOV DL, CARACTER
				INT 21H
				ENDM

;***********************************************************************************
; Macro para insertar un caracter
;***********************************************************************************				
INSERTAR_C 		MACRO CARACTER
				LOCAL INS_C
				LOCAL IMP_SIG
				LIMPIAR CADENA_AUX, LONG_AUX
				MOV DX, CANT_CAR
				CMP APUNTADOR_CAD, DX
				JE IMP_SIG
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CARACTER, CADENA_DEST[BX], 1
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX+1], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				INC CANT_CAR
				JMP INS_C
IMP_SIG:		INC CANT_CAR
				MOV BX, APUNTADOR_CAD
INS_C:			COPIAR_CAD ASCII, CADENA_DEST[BX], 1
				INC APUNTADOR_CAD
				ENDM
			
;***********************************************************************************
; Macro para eliminar una línea completa.
;***********************************************************************************			
SET_SP			MACRO TROW, BROW, LCOL, LM, MEN
				MOV   TOPROW, TROW
				MOV   BOTROW, BROW
				MOV   LEFCOL, LCOL
				MOV   LONG_MEN, LM
				LEA   DX, MEN
				MOV   MENU, DX
				ENDM

;***********************************************************************************
; Macro para crear un archivo.
;***********************************************************************************
CREAR_A	MACRO NOM_ARCHIVO
				MOV	AH, 3CH			; PETICION
				MOV	CX, 00			; ATRIBUTO NORMAL
				LEA DX, NOM_ARCHIVO	; CADENA ASCIIZ
				INT 21H				; LLAMA AL DOS
				MOV	MANEJ, AX		; GUARDA EL MANEJADOR
				ENDM
				
;***********************************************************************************
; Macro para abrir un archivo previamente guardado
;***********************************************************************************
ABRIR_A	     	MACRO NOM_ARCHIVO
				MOV AH, 3DH			    
				MOV AL, 02H			    
				LEA DX, NOM_ARCHIVO	    
				INT 21H
				MOV MANEJ, AX		    
				ENDM				

;***********************************************************************************
; Macro para leer un archivo previamente guardado
;***********************************************************************************
LEER_A	     	MACRO MANEJADOR
				MOV AH, 3FH			    
				MOV BX, MANEJADOR	    
				MOV CX, 1839  		    
				LEA DX, TEXT_P		    
				INT 21H
				ENDM			
				
CERRAR_A	MACRO MANEJADOR
				MOV	AH, 3EH	; PETICION
				MOV BX, MANEJADOR
				INT	21H
				ENDM	
			
	.MODEL SMALL
	.STACK 2048
	.386
;-------------------------------------------------------------------------------------------
; Inicio de Datos
	.DATA

NOMBRE			DB	'Proy.txt',00H
MANEJ			DW	  	?
TEXT_P			DB	1680 DUP (?), '$'
CARACTER_NULL	DB	00H
CARACTER		DB	 ' $'
LONG_CAR		DW 	1
CADENA_DEST		DB	1680 DUP (?),'$'
CADENA_DEST0	DB	1680 DUP (?),'$'
CADENA_DEST1	DB	1680 DUP (?),'$'
CADENA_DEST2	DB	1680 DUP (?),'$'
CADENA_DEST3	DB	1680 DUP (?),'$'
LONG_STRING1	DW	1680
CANT_CAR		DW	0
CANT_CAR0		DW	0
CANT_CAR1		DW	0
CANT_CAR2		DW	0
CANT_CAR3		DW	0
COP_CANT_CAR	DW	0
APUNTADOR_CAD	DW 	0
COP_APUNT_CAD	DW	?
COP2_APUNT_CAD	DW	?
CADENA_AUX		DB 	1680 DUP (' '),'$'
LONG_AUX		DW	1680
LIMPIA			DB	80 DUP (' ')							 	; cadena para limpiar línea.
LONG_COP		DW	?
SUMA			DW  ?
COCIENTE		DW	?
RESIDUO			DW 	?
CADENA_COPIAR	DB	80 DUP (' '), '$'
LONG_CADP		DW	80
CONT_NULL		DW 	0
FILA_ACTUAL 	DB	?
COL_ACTUAL 		DB	?
NUM_PAG			DB	?
LONG_LINE		DW	80
NUM_LINE		DB	?
STR_TAB			DB 	0H,0H,0H,0H,0H,0H,0H,0H,0H,32,'$'
LONG_TAB		DW	10
CONT_TAB		DW	0
B_NEGRITAS		DB	0
CHAR			DB  0
CADENA_PRUEBA	DB  78 DUP (32H),09H,31H,32H,02H, 34H,35H,33H,0H,0H,0H,35H,36H,31H,32H,0H,0H,35H,36H,0H,31H,'$'
LONG_STR01		DW	95
CANT_CARP		DW	95
STRING			DB	16 DUP (?),'$'
APUNT			DB 	0
PAGINA			DB  0
NULL_A_IMP		DW	0
OFFSET_CUR		DW  0
ASCII			DB  0
RASTREO			DB 	0
CT				DB 	0
FT				DB	0
FUN				DB  ?

;TABLA DE BIFUCACIÓN
CAD_TABLA  		DB  3BH, 0, 3CH, 2, 3DH, 4, 3EH, 6, 47H, 8, 53H, 10, 52H, 12, 51H, 14, 49H, 16, 50H, 18, 4BH, 20, 4DH, 22, 48H, 24, 4FH, 26
TABLA      		DW  ARCHIVO              	             		; Tabla de bifurcación con sus cuatro opciones
				DW  EDICION
				DW  FORMATO
				DW  AYUDA
				DW  HOME
				DW  DEL
				DW  INSRT
				DW  PGDN
				DW  PGUP
				DW  F_AB
				DW  F_IZ
				DW  F_DER
				DW  F_UP
				DW  T_END
		
TABLA2 			DW  FARCHIVO
				DW  FEDICION
				DW  FFORMATO
				DW  FAYUDA
				
T_EDICION		DW  CORTAR_CAD
				DW  COPIA_CAD
				DW  PEGA_CAD
				
T_ARCHIVO		DW  ABRIR_AR
				DW  GUARDAR_AR
				DW  SALIR_P
				
T_AYUDA			DW  MANUAL
				DW  CRED
;----------------------------------------------------------------------------------------------
; Manejo de archivos y cerrar programa
;----------------------------------------------------------------------------------------------


;PARTE GRÁFICA LOL
TOPROW			DB	?					    					; Fila superior menu
BOTROW			DB	?											; fila inferior menu
LEFCOL			DB	?											; Columna izquierda menu
ATTRIB			DB	?											; Atributo de pantalla
ROW				DB	?											; Fila pantalla
INGRESO			DB	?											; Guarda tecla ingresada
SHADOW			DB	40	DUP(0DBH)								; Caracteres de sombreado
MENU			DW  ?
LONG_MEN		DB  ?
B_NA			DB 36 DUP (0C4H), 'UNTITLED', 36 DUP (0C4H), '$'
B_MENUS			DB '  Archivo    Edicion    Formato    Ayuda  ', 38 DUP (' '), '$'
B_ABAJO			DB ' F1 - Archivo    F2 - Edicion    F3 - Formato    F4 - Ayuda ', 20 DUP (' '), '$'  
M_ARCHIVO		DB	0C9H, 10 DUP(0CDH), 0BBH	; Dibuja menu
				DB	0BAH, ' Abrir    ', 0BAH
				DB	0BAH, ' Guardar  ', 0BAH
				DB	0BAH, ' Salir    ', 0BAH
				DB	0C8H, 10 DUP(0CDH), 0BCH
				
M_EDICION		DB	0C9H, 22 DUP(0CDH), 0BBH					; Dibuja menu
				DB	0BAH, ' Cortar               ', 0BAH
				DB	0BAH, ' Copiar               ', 0BAH
				DB	0BAH, ' Pegar                ', 0BAH
				DB	0BAH, ' Copiar y Reemplazar  ', 0BAH
				DB	0C8H, 22 DUP(0CDH), 0BCH

M_FORMATO		DB	0C9H, 10 DUP(0CDH), 0BBH					; Dibuja menu
				DB	0BAH, ' Negrita  ', 0BAH
				DB	0BAH, ' Normal   ', 0BAH
				DB	0C8H, 10 DUP(0CDH), 0BCH
				
M_AYUDA			DB	0C9H, 18 DUP(0CDH), 0BBH					; Dibuja menu
				DB	0BAH, ' Manual de Ayuda  ', 0BAH
				DB	0BAH, ' Creditos         ', 0BAH
				DB	0C8H, 18 DUP(0CDH), 0BCH	
				
CREDITOS		DB  0C9H, 20 DUP(0CDH), 0BBH				;22
				DB  0BAH, '      Creditos      ', 0BAH
				DB  0BAH, '                    ', 0BAH
				DB  0BAH, '    Programadores   ', 0BAH
				DB  0BAH, '                    ', 0BAH
				DB  0BAH, ' Juan Pablo Argueta ', 0BAH
				DB  0BAH, '   Jonathan Lopez   ', 0BAH
				DB  0BAH, '                    ', 0BAH
				DB  0BAH, '    PRESIONE ESC    ', 0BAH
				DB  0BAH, '     PARA SALIR     ', 0BAH
				DB  0C8H, 20 DUP(0CDH), 0BCH
				
MAN_AYUDA		DB  0C9H, 69 DUP(0CDH), 0BBH
				DB  0BAH, '                           Manual de Ayuda                           ', 0BAH
				DB  0BAH, '                                                                     ', 0BAH
				DB  0BAH, ' Teclas de Funcion Especial:                                         ', 0BAH
				DB  0BAH, '                                                                     ', 0BAH
				DB  0BAH, ' Backspace: Borra un dato a la izquierda del cursor.                 ', 0BAH
				DB  0BAH, ' Suprimir: Borra un dato a la derecha del cursos.                    ', 0BAH
				DB  0BAH, ' Enter: Baja una linea y posiciona el cursor en la primera columna.  ', 0BAH
				DB  0BAH, ' Re Pag: Cambia de hoja a una hoja anterior.                         ', 0BAH
				DB  0BAH, ' Av Pag: Cambia de hoja a la hoja siguiente.                         ', 0BAH
				DB  0BAH, ' Inicio: Posiciona el cursor en la primera columna.                  ', 0BAH
				DB  0BAH, ' Fin: Posiciona el cursor en la ultima columna.                      ', 0BAH
				DB  0BAH, '                                                                     ', 0BAH
				DB  0BAH, ' PRESIONE ESC PARA SALIR                                             ', 0BAH
				DB  0C8H, 69 DUP(0CDH), 0BCH
				
				
	.CODE

FARCHIVO		PROC  NEAR
				XOR   BX, BX
				MOVZX BX, ROW					; la fila indica que linea se seleccionó.
				SUB	  BL, TOPROW
				DEC   BX
				SHL	  BX, 01
				CALL  [T_ARCHIVO+BX]
				RET
FARCHIVO		ENDP

FEDICION		PROC  NEAR
				XOR   BX, BX
				MOVZX BX, ROW					; la fila indica que linea se seleccionó.
				SUB	  BL, TOPROW
				DEC   BX
				SHL	  BX, 01
				CALL  [T_EDICION+BX]
				RET
FEDICION		ENDP

FFORMATO		PROC  NEAR
				CALL  NEGRITAS
				RET
FFORMATO		ENDP


FAYUDA			PROC  NEAR
				XOR   BX, BX
				MOVZX BX, ROW					; la fila indica que linea se seleccionó.
				SUB	  BL, TOPROW
				DEC   BX
				SHL	  BX, 01
				CALL  [T_AYUDA+BX]
				RET
FAYUDA			ENDP

CRED			PROC  NEAR
				SET_SP 6, 16, 28, 22, CREDITOS 
				CALL  Q10CLEAR                					; Se limpia la pantalla.
				CALL  PAINT_CUADRO								; Desplegar menu
A2000:			MOV   AH, 10H
				INT	  16H
				CMP	  AL, 1BH									
				JNE	  A2000										; no, continuar
				CALL  Q10CLEAR	
				RET
CRED			ENDP

MANUAL			PROC  NEAR
				SET_SP 3, 17, 5, 71, MAN_AYUDA
				CALL  Q10CLEAR                					; Se limpia la pantalla.
				CALL  PAINT_CUADRO								; Desplegar menu
A200:			MOV   AH, 10H
				INT	  16H
				CMP	  AL, 1BH									
				JNE	  A200										; no, continuar
				CALL  Q10CLEAR	
				RET
MANUAL 			ENDP
	
ABRIR_AR		PROC NEAR
				ABRIR_A NOMBRE
				RET
ABRIR_AR		ENDP

GUARDAR_AR		PROC NEAR
				CERRAR_A MANEJ
				RET
GUARDAR_AR		ENDP
				
CERRAR_AR		PROC NEAR
				CALL GUARDAR_AR
				MOV   AX, 4C00H		;salida al DOS
				INT   21H
				RET
CERRAR_AR		ENDP
				
;-------------------------------------------------------------------------------------------
; Imprime el menu de acuerdo a aja
;-------------------------------------------------------------------------------------------
PAINT_MENU		PROC  NEAR
				PUSHA											; guardar todos los registros
				CALL  PAINT_SOMBRA
				CALL  PAINT_CUADRO
				POPA											; recuperar registros
				RET
PAINT_MENU		ENDP

PAINT_SOMBRA	PROC  NEAR
				PUSHA
				MOV   AL, TOPROW
				INC   AL
				MOV	  DH, AL									; fila superior de sombra
				LEA	  BP, SHADOW								; caracteres sombreados
B20:			MOV	  AX, 1301H									; dibujar caja sombreada
				MOV   BH, PAGINA								; PAGINA
				MOV	  BL, 60H									; atributo
				
				MOV   AL, LEFCOL
				INC   AL
				MOVZX CX, LONG_MEN								; 19 caracteres
				MOV	  DL, AL									; columna izq de sombra
				INT	  10H
				INC	  DH										; siguiente fila
				MOV   AL, BOTROW
				ADD   AL, 2
				CMP	  DH, AL									; se desplegaron todas las columnas?
				JNE	  B20										; no, repetir
				POPA
				RET
PAINT_SOMBRA	ENDP

PAINT_CUADRO	PROC  NEAR
				PUSHA
				MOV   BP, MENU
				MOV	  DH, TOPROW								; fila
B30:
				MOV	  BH, PAGINA								;PAGINA
				MOV   BL, 70H									; atributo: azul sobre blanco
				MOV	  AX, 1300H									; solicitar menu de despliegue
				MOVZX	  CX, LONG_MEN							; longitud de la linea
				MOV	  DL, LEFCOL								; columna
				PUSH  DX										; guarda el registro que contiene fila, columna
				INT   10H
				MOVZX AX, LONG_MEN
				ADD	  BP, AX									; siguiente linea del menu
				POP	  DX										; recupera registro con fila, columna
				INC	  DH										; siguiente fila
				MOV   AL, BOTROW
				INC   AL 
				CMP	  DH, AL									; se mostraron todas las filas?
				JNE	  B30										; no, repetir
				POPA
				RET
PAINT_CUADRO	ENDP

;------------------------------------------------------------------------------------------
ARCHIVO			PROC  NEAR
				MOV   FUN, 0
				SET_SP 1, 5, 0, 12, M_ARCHIVO
				CALL  MOSTRAR_MENU
				RET
ARCHIVO			ENDP

EDICION			PROC  NEAR
				MOV   FUN, 2
				SET_SP 1, 6, 12, 24, M_EDICION
				CALL  MOSTRAR_MENU
				RET
EDICION 		ENDP

FORMATO			PROC  NEAR
				MOV   FUN, 4
				SET_SP 1, 4, 23, 12, M_FORMATO
				CALL  MOSTRAR_MENU
				RET
FORMATO			ENDP

SALIR_P			PROC NEAR
				MOV		AX, 0600H
				MOV		BH, 07H					; blanco sobre verde
				MOV		CX, 0000H				; pantalla completa
				MOV		DX, 184FH				; fila 24, col 79
				INT		10H
				MOV   AX, 4C00H		;salida al DOS
				INT   21H
				RET
SALIR_P			ENDP


AYUDA			PROC  NEAR
				MOV   FUN, 6
				SET_SP 1, 4, 32, 20, M_AYUDA
				CALL  MOSTRAR_MENU
				RET
AYUDA			ENDP

T_END				PROC NEAR
				CALL END_STR
				RET
T_END				ENDP

HOME			PROC NEAR
				CALL HOME_STR
				RET
HOME			ENDP

DEL				PROC NEAR
				CALL SUPRIMIR
				RET
DEL				ENDP

INSRT			PROC NEAR
				RET
INSRT			ENDP

PGDN			PROC NEAR
				MOV BX, 0
				CMP PAGINA, 0
				JE PAG_1D
				CMP PAGINA, 1
				JE PAG_2D
				CMP PAGINA, 2
				JE PAG_3D
				CMP PAGINA, 3
				JE S_PGUD
CON_PGD:		INC PAGINA
				MOV AL, PAGINA
				MOV AH, 05H
				INT 10H
S_PGUD:			RET
PAG_1D:			COPIAR_CAD CADENA_DEST, CADENA_DEST0, 1680
				COPIAR_CAD CADENA_DEST1, CADENA_DEST, 1680
				MOVM CANT_CAR, CANT_CAR0
				MOVM CANT_CAR1, CANT_CAR
				JMP CON_PGD
PAG_2D:			COPIAR_CAD CADENA_DEST, CADENA_DEST1, 1680
				COPIAR_CAD CADENA_DEST2, CADENA_DEST, 1680
				MOVM CANT_CAR, CANT_CAR1
				MOVM CANT_CAR2, CANT_CAR
				JMP CON_PGD				
PAG_3D:			COPIAR_CAD CADENA_DEST, CADENA_DEST2, 1680
				COPIAR_CAD CADENA_DEST3, CADENA_DEST, 1680
				MOVM CANT_CAR, CANT_CAR2
				MOVM CANT_CAR3, CANT_CAR
				JMP CON_PGD
S_PGD:			RET
PGDN			ENDP				

PGUP			PROC NEAR
				MOV BX, 0
				CMP PAGINA, 0
				JE S_PGU
				CMP PAGINA, 1
				JE PAG_0
				CMP PAGINA, 2
				JE PAG_1
				CMP PAGINA, 3
				JE PAG_2
CON_PG:			DEC PAGINA
				MOV AL, PAGINA
				MOV AH, 05H
				INT 10H
S_PGU:			RET
PAG_0:			COPIAR_CAD CADENA_DEST, CADENA_DEST1, 1680
				COPIAR_CAD CADENA_DEST0, CADENA_DEST, 1680
				MOVM CANT_CAR, CANT_CAR1
				MOVM CANT_CAR0, CANT_CAR
				JMP CON_PG
PAG_1:			COPIAR_CAD CADENA_DEST, CADENA_DEST2, 1680
				COPIAR_CAD CADENA_DEST1, CADENA_DEST, 1680
				MOVM CANT_CAR, CANT_CAR2
				MOVM CANT_CAR1, CANT_CAR
				JMP CON_PG				
PAG_2:			COPIAR_CAD CADENA_DEST, CADENA_DEST3, 1680
				COPIAR_CAD CADENA_DEST2, CADENA_DEST, 1680
				MOVM CANT_CAR, CANT_CAR3
				MOVM CANT_CAR2, CANT_CAR
				JMP CON_PG
PGUP			ENDP

F_AB			PROC NEAR
				CALL MOVC_DOWN
				RET
F_AB			ENDP

F_IZ			PROC NEAR
				CALL MOVC_IZ
				RET
F_IZ			ENDP

F_DER			PROC NEAR
				CALL MOVC_DER
				RET
F_DER			ENDP

F_UP			PROC NEAR
				CALL MOVC_UP
				RET
F_UP			ENDP


;-------------------------------------------------------------------------------------------
; Menus
;-------------------------------------------------------------------------------------------
MOSTRAR_MENU	PROC  NEAR
A20:			CALL  Q10CLEAR                					; Se limpia la pantalla.
				CALL  PAINT_MENU								; Desplegar menu
				MOV   AL, TOPROW
				INC   AL
				MOV   ROW, AL									; Fijar la fila en la primera opcion
				MOV   ATTRIB, 10H								; fijar video inverso
				CALL  D10DISPLY									; resaltar linea actual
				CALL  C10INPUT									; leer opcion de menu
				CMP	  INGRESO, 1BH								;  presiono esc?
				JNE	  A20										; no, continuar
FIN:			CALL  Q10CLEAR									; limpiar pantalla
				RET
MOSTRAR_MENU	ENDP

C10INPUT 		PROC  NEAR
				PUSHA											; guardar registros
C20:			MOV	  AH, 10H									; leer caracter de teclado
				INT	  16H
				CMP	  AH, 50H									; cod rastreo flecha abajo?
				JE	  C30
				CMP	  AH, 48H									; cod rastreo flecha arriba?
				JE	  C40
				CMP	  AL, 0DH									; ascii enter?
				JE	  C100

				CMP	  AL, 1BH									; ascii esc?
				JE	  C90
				JMP	  C20
C30:			MOV	  INGRESO, AL
				MOV	  ATTRIB, 70H								; flecha-abajo, azul sobre blanco
				CALL  D10DISPLY									; regresar linea ant a video normal
				INC	  ROW										; fila siguiente
				MOV   AL, BOTROW
				DEC   AL
				CMP	  ROW, AL									; se paso de la ultima fila?
				JBE	  C50										; no, ok
				MOV   AL, TOPROW
				INC   AL
				MOV	  ROW, AL									; si, iniciar fila
				JMP	  C50
C40:			MOV	  INGRESO, AL
				MOV   ATTRIB, 70H								; flecha-arriba, azul sobre blanco
				CALL  D10DISPLY									; regresar linea ant a video normal
				DEC	  ROW										; fila anterior
				MOV   AL, TOPROW
				INC   AL
				CMP	  ROW, AL									; se paso de la primera fila?
				JAE	  C50										; no, ok
				MOV   AL, BOTROW
				DEC   AL
				MOV	  ROW, AL									; si, iniciar fila
C50:			MOV	  INGRESO, AL
				MOV	  ATTRIB, 10H								; blanco sobre azul
				CALL  D10DISPLY									; fijar linea nueva a video inverso
				JMP	  C20
C100:  			MOV   ATTRIB, 17H
				CALL  D10DISPLY
				CALL  OUT_M
				JMP   SAL_YA
C90:
				MOV	  INGRESO, AL
SAL_YA:			POPA											; recuperar registros
				RET
C10INPUT 		ENDP

OUT_M   		PROC  NEAR
				PUSHA											; guardar registros
				XOR   BX, BX
				MOV   BL, FUN
				CALL  [TABLA2+BX] 	; salta a la tabla
				MOV   INGRESO, 1BH
				POPA											; recuperar registros
				RET
OUT_M   		ENDP
; ----------------------------------------------------------------------
;
; ----------------------------------------------------------------------
D10DISPLY 		PROC  NEAR
				PUSHA											; guardar registros
				MOVZX AX, ROW									; la fila indica que linea fijar
				SUB	  AL, TOPROW
				MOVZX BX, LONG_MEN
				IMUL  AX, BX									; multiplicar por longitud de linea
				MOV	  SI, MENU									; para seleccionar fila del menu
				ADD	  SI, AX
				XOR   AX, AX
				MOV   AL, LONG_MEN
				SUB   AL, 2
				MOV	  CX, AX									; longitud de cadena menu
				MOV	  AX, 1300H									; solicita despliegue
				MOVZX BX, ATTRIB								; pagina y atributo
				MOV	  BP, SI									; caracter de cadena menu
				INC   BP
				MOV	  DH, ROW									; fila
				MOV   AL, LEFCOL
				INC   AL 
				MOV	  DL, AL									; columna
				INT	  10H
				POPA											; recuperar registros
				RET
D10DISPLY 		ENDP

; ----------------------------------------------------------------------
; 
; ----------------------------------------------------------------------
Q10CLEAR 		PROC  NEAR
				PUSHA											; guardar registros
				MOV	  AX, 0600H
				MOV	  BH, 17H									; blanco sobre verde
				MOV	  CX, 0200H									; pantalla completa
				MOV	  DX, 164FH									; fila 24, col 79
				INT	  10H
				
				MOV   AX, 1300H
				MOV   BH, PAGINA
				MOV   BL, 70H
				LEA   BP, B_MENUS
				MOV   DX, 0000H
				MOV   CX, 0080
				INT   10H
				
				INC   DH 
				MOV   BL, 07H
				LEA   BP, B_NA
				INT   10H
				
				MOV   DX, 1700H
				MOV   BL, 70H
				LEA   BP, B_ABAJO
				INT   10H
				POPA											; recuperar registros
				RET
Q10CLEAR 		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento auxiliar para borrar el caracter anterior a la posición del apuntador:
; Parámetros: 	CADENA_AUX Y LONG_AUX: cadena donde se insertan los caracteres que no se borrarán.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;				CADENA_DEST: cadena sobre la cual se trabaja durante el programa. 
;----------------------------------------------------------------------------------------------
COP_BS			PROC  NEAR
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX					
				MOV   AX, CONT_NULL								
				RESTAM CANT_CAR, APUNTADOR_CAD						; Se obtiene la longitud de cadena a copiar.
				MOV   BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP 	;Se copia a la cadena auxiliar
				DEC APUNTADOR_CAD
				MOV   BX, APUNTADOR_CAD								; Se mueve el apuntador a la nueva posición.
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP 	;Se copia la cadena auxiliar en la nueva posición.
				LIMPIAR CADENA_AUX, LONG_AUX
				DEC   CANT_CAR				
				MOV   BX, CANT_CAR
				COPIAR_CAD CARACTER_NULL, CADENA_DEST[BX], 1		; Se inserta un NULL en la última posición de la cadena anterior.
				POPA
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
				MOV   BX, COP_APUNT_CAD
				MOV   AL, CADENA_DEST[BX]								; Se compara con 00H en búsqueda de
				CMP   AL, 00H											; más NULL por eliminar.
				JNE	  SAL_NULL
				INC   CONT_NULL
				DEC   CANT_CAR
				JMP   NULL_AG
SAL_NULL:		SUMAM CANT_CAR, CONT_NULL
				RESTAM SUMA, APUNTADOR_CAD							; Se obtiene la longitud de cadena a copiar.
				CMP   LONG_COP, 0
				JE   COP_1
CONTI:			MOV   BX, APUNTADOR_CAD								
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP	; Se copia la cadena auxiliar en la nueva posición.
				MOV   BX, COP_APUNT_CAD
				INC   BX
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				MOV   BX, APUNTADOR_CAD
				IMP_NULLS CADENA_DEST, CANT_CAR, CONT_NULL			; Se imprimen los NULL necesarios para eliminar los caracteres.
				RESTAM APUNTADOR_CAD, CONT_NULL
				MOVM LONG_COP, APUNTADOR_CAD
				POPA
				RET
COP_1:			INC LONG_COP
				JMP CONTI
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
SALE_BS:		MOVM APUNTADOR_CAD, COP_APUNT_CAD
				CMP   APUNTADOR_CAD, 0								; Se comprueba que no esté en la primera columna y fila
				JE    SALE_BACKS										; del áreaescritura, si lo está, no ejecuta la acción.
				DEC   COP_APUNT_CAD									; Se hace una copia del apuntador para guardar el mismo.
				MOV   BX, COP_APUNT_CAD							
				MOV   AL, CADENA_DEST[BX]								; Se obtiene el caracter anterior al apuntador, si es NULL
				CMP   AL, 00H											; se ejecutan instrucciones para eliminar todos los NULL,
				JE	  ELIM_NULL										; de lo contario, se elimina solamente un caracter del String.
				CALL  COP_BS
SALE_BACKS:		POPA
				RET
ELIM_NULL:		MOV   CONT_NULL, 0									; Se inicializa CONT_NULL
				INC   CONT_NULL										
				DEC   CANT_CAR
				CALL  COP_BSNULL	
				JMP   SALE_BS
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
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOV   AX, CANT_CAR
				CMP   COP_APUNT_CAD, AX
				JE    SALE_SUPR
				MOV   BX, COP_APUNT_CAD
				MOV   AL, CADENA_DEST[BX]								; Se compara el caracter de la posición en búsqueda 
				CMP   AL, 00H											; de algún NULL, si los hay, se accede a su correcto
				JE    SUPR_NULL										; procesamiento.
				INC   APUNTADOR_CAD
				CALL  BACKSPACE
SALE_SUPR:		POPA
				RET
SUPR_NULL:		MOV CADENA_DEST[BX], 01H								; Se sustituye el primer caracter por uno cualquiera.
CONT_N:			MOV AX, APUNTADOR_CAD
				CMP AX, CANT_CAR									; Se corrobora que no haya alcanzado el final del String.
				JAE SALE_SUPR
				INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]								; Se compara en búsqueda de más NULL.
				CMP AL, 00H
				JE CONT_N
				CALL BACKSPACE
				INC FT
				JMP SALE_SUPR
SUPRIMIR		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para borrar caracter donde se encuentra posicionado el apuntador, utiliza a 
; BACKSPACE para su total funcionamiento.
; Parámetros: 	APUNTADOR_CAD: para conocer el caracter a borrar.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;----------------------------------------------------------------------------------------------
ELIM_STR		PROC NEAR
				PUSHA
				MOV CX, LONG_LINE
CIC_ELI:		CALL SUPRIMIR										; Se hace un suprimir hasta que
				CMP CANT_CAR,0										; CX sea cero o se alcance el 
				JE F_CIC_ELI										; inicio de la línea.
				LOOP CIC_ELI
F_CIC_ELI:		POPA
				RET
ELIM_STR		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para guardar una línea de 80 caracteres en un string auxiliar al mismo tiempo que
; la borra del String y mueve toda la cadena.
; Parámetros: 	APUNTADOR_CAD: para conocer el inicio de la línea que se cortará.
;				LONG_LINE: determina la cantidad de caracteres en una línea.
;				CADENA_COPIAR: String donde se guarda la línea cortada, funciona también para 
;					guardar algún String que solamente se haya copiado.
;				LONG_CADP: Largo de la cadena que se ha guardado en CADENA_COPIAR, 80 caracteres.
;----------------------------------------------------------------------------------------------
CORTAR_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_LINE					; Se obtiene el inicio de la línea
				RESTAM APUNTADOR_CAD, RESIDUO						
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_COPIAR, LONG_CADP					; Se limpia la cadena donde se copiará la línea
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, LONG_CADP
				;INC APUNTADOR_CAD
				CALL ELIM_STR										; Se elimina la línea actual, simulando
SALE_CUT:		POPA												; la instrucción cortar.
				RET
CORTAR_CAD		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para guardar una línea de 80 caracteres en un string auxiliar sin borrarlo.
; Parámetros: 	APUNTADOR_CAD: para conocer el inicio de la línea que se cortará.
;				lONG_LINE: determina la cantidad de caracteres en una línea.
;				CADENA_COPIAR: String donde se guarda la línea cortada, funciona también para 
;					guardar algún String que solamente se haya copiado.
;				LONG_CADP: Largo de la cadena que se ha guardado en CADENA_COPIAR, 80 caracteres.
;----------------------------------------------------------------------------------------------
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

;----------------------------------------------------------------------------------------------
; Procedimiento para pegar la cadena guardada en alguno de los procedimientos CORTAR_CAD o 
; COPIA_CAD. La copia en la dirección determinada por el apuntador de la cadena.
; Parámetros: 	APUNTADOR_CAD: para conocer el inicio donde se pegará el String.
;				lONG_LINE: determina la cantidad de caracteres en una línea.
;				CADENA_COPIAR: String donde se guarda la línea cortada, funciona también para 
;					guardar algún String que solamente se haya copiado.
;				LONG_CADP: Largo de la cadena que se ha guardado en CADENA_COPIAR, 80 caracteres.
;----------------------------------------------------------------------------------------------
PEGA_CAD		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOV AX, LONG_STRING1								; Si la cadena es mayor a la
				SUMAM CANT_CAR, LONG_CADP							; longitud del String no 
				CMP SUMA, AX										; realiza la acción.
				JAE SALE_PEGA
				MOV BX, APUNTADOR_CAD
				RESTAM CANT_CAR, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CADENA_COPIAR, CADENA_DEST[BX], LONG_CADP
				ADD BX, LONG_CADP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				MOV AX, LONG_CADP
				ADD CANT_CAR, AX									; Se incrementa el CANT_CAR y APUNTADOR_CAD 
				ADD APUNTADOR_CAD, AX								; la cantidad de espacios correctos.
SALE_PEGA:		POPA
				RET
PEGA_CAD		ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la izquierda del String. Si está al principio del mismo,
; no realiza ninguna acción. Si está al principio de una línea, se mueve a la anterior, si es 
; ENTER, se mueve al principio de la línea, si hay tabuladores, al final de los mismos.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;----------------------------------------------------------------------------------------------
MOVC_IZ			PROC NEAR
				PUSHA
FIND_ASCII:		CMP APUNTADOR_CAD, 0								; Si está en primera línea y primera
				JE SALE_IZ											; columna, no hace la acción.
				DEC APUNTADOR_CAD									; Se decrementa el apuntador y la 
				DEC CT												; columna.
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H							; Si encuentra NULL, sigue hasta encontrar
				JE FIND_ASCII										; un ASCII
SALE_IZ:		POPA
				RET
MOVC_IZ			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la derecha del String. Si está al final del mismo,
; no realiza ninguna acción. Si está al final de una línea, se mueve a la siguiente, si es 
; ENTER, se mueve al principio de la línea, si hay tabuladores, al principio de los mismos.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
MOVC_DER		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD					; Si está al final del String o del 
BUSCAR_ASCII:	MOV AX, LONG_STRING1								; CANT_CAR, no realiza la acción.
				CMP COP_APUNT_CAD, AX
				JE SALE_DER
				MOV AX, CANT_CAR
				CMP COP_APUNT_CAD, AX
				JE SALE_DER
				INC COP_APUNT_CAD
				INC CT
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H							; Si encuentra NULL, sigue hasta encontrar
				JE BUSCAR_ASCII										; un ASCII.
				MOVM COP_APUNT_CAD, APUNTADOR_CAD
SALE_DER:		POPA
				RET
MOVC_DER		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para obtener el ASCII más cercano distinto de 00H. 
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				CONT_TAB: Cuenta la cantidad de NULLS hacia la izquierda para determinar el
;					ASCII más cercano al apuntador.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
DISTANCIA_MENOR PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
MOV_IZ:			CMP CONT_TAB,5										; Al llegar a 5 reconoce que no es la
				JE C_DER											; distancia más cercana.
				INC COP_APUNT_CAD
				INC CONT_TAB
				INC CT
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE MOV_IZ
SALE_MEN:		MOVM COP_APUNT_CAD, APUNTADOR_CAD					; Se posiciona correctamente el apuntador.
				MOV CONT_TAB, 0
				POPA
				RET
C_DER:			SUB CT, 5											; Se regresa las columnas avanzadas a la inicial.
				DEC COP_APUNT_CAD
				DEC CT
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE C_DER
				JMP SALE_MEN
DISTANCIA_MENOR ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la linea anterior del String. Si se desplaza hacia un NULL,
; busca el ASCII más cercano hacia su derecha o izquierda. Si está en la primera línea, no realiza 
; acción alguna. 
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				LONG_LINE: largo de la línea. 80 caracteres.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
MOVC_UP			PROC NEAR
				PUSHA
				CMP FT, 2
				;MOV AX, LONG_LINE
				;CMP APUNTADOR_CAD, AX
				JBE SALE_UP
				RESTAM APUNTADOR_CAD, LONG_LINE
				DEC FT
				MOVM LONG_COP, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H
				JE BUSC_ASCII
SALE_UP:		POPA
				RET
BUSC_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_UP
MOVC_UP			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la siguiente línea del String. Si se desplaza hacia un NULL,
; busca el ASCII más cercano hacia su derecha o izquierda. Si está en la última línea, no realiza 
; acción alguna. Si se dirige a una posición mayor a los caracteres ingresados, regresa al último
; caracter del String.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				LONG_STRING1: Capacidad total del String. 
;				CANT_CAR: Cantidad de caracteres ingresados por el usuario hasta el momento.
;				LONG_LINE: largo de la línea. 80 caracteres.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
MOVC_DOWN		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				SUMAM COP_APUNT_CAD, CANT_CAR
				
				MOV AX, 1680
				CMP SUMA, AX
				JA SALE_DOWN
				MOV AX, CANT_CAR
				CMP APUNTADOR_CAD, AX
				JB ULTIMO
				SUMAM APUNTADOR_CAD, LONG_LINE
				MOVM SUMA, APUNTADOR_CAD
				INC FT
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H
				JE BUS_ASCII
SALE_DOWN:		POPA
				RET
BUS_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_DOWN
ULTIMO:			MOVM CANT_CAR, APUNTADOR_CAD
				JMP SALE_DOWN
MOVC_DOWN		ENDP

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
				MOVM APUNTADOR_CAD, COP2_APUNT_CAD
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				DIVIDIR COP_APUNT_CAD, LONG_LINE
				MOV AX, LONG_STRING1
				SUMAM APUNTADOR_CAD, LONG_TAB
				CMP SUMA, AX
				JA SALE_TAB
				RESTAM LONG_LINE, RESIDUO
				MOV AX, LONG_COP
				CMP LONG_COP, 0
				JE LINE_DOWN
				CMP LONG_TAB, AX
				JA INS_NULL
				INSERTAR_CAD STR_TAB, LONG_TAB
SALE_TAB:		MOVM COP2_APUNT_CAD, APUNTADOR_CAD 
				POPA
				RET
LINE_DOWN:		CALL MOVC_DER
				INSERTAR_CAD STR_TAB, LONG_TAB
				JMP SALE_TAB
INS_NULL:		INSERTAR_CAD CARACTER, 1
				JMP SALE_TAB
TABULADOR		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para situar el apuntador y cursor en la primera columna de la fila actual.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				LONG_LINE: largo de la línea. 80 caracteres.
;----------------------------------------------------------------------------------------------
HOME_STR		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				MOV CX, RESIDUO
				SUB CT, CL
				POPA
				RET
HOME_STR		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para situar el apuntador y cursor en la última columna de la fila actual.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				LONG_LINE: largo de la línea. 80 caracteres.
;----------------------------------------------------------------------------------------------
END_STR			PROC NEAR
				PUSHA
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV AX, LONG_LINE
				CMP AX, LONG_COP
				JAE I_CANT_CAR
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM LONG_LINE, RESIDUO
				SUMAM APUNTADOR_CAD, LONG_COP
				MOVM SUMA, APUNTADOR_CAD
				DEC APUNTADOR_CAD
				MOV CX, APUNTADOR_CAD
				MOV CT, CL
SALE_END:		POPA
				RET
I_CANT_CAR:		MOVM CANT_CAR, APUNTADOR_CAD
				MOV CX, CANT_CAR
				ADD CT, CL
				JMP SALE_END
END_STR			ENDP	

;----------------------------------------------------------------------------------------------
; Procedimiento para cambiar la intensidad de la fila en donde se encuentra el cursor.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				LONG_LINE: largo de la línea. 80 caracteres.
;----------------------------------------------------------------------------------------------
NEGRITAS		PROC NEAR
				PUSHA
				MOV DL, 00010111B
				CMP B_NEGRITAS,0
				JE AC_NEGRITAS
				DEC B_NEGRITAS
IN_NEG:			DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				MOV CX, LONG_LINE
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOVM LONG_LINE, COP_APUNT_CAD
				DEC COP_APUNT_CAD
SIG_CAR:		MOV BX, COP_APUNT_CAD
				MOV AH, 09H
				MOV AL, CADENA_DEST[BX]
				MOV BH, 0
				MOV BL, DL
				INT 10H
				DEC COP_APUNT_CAD
				LOOP SIG_CAR			
				POPA
				RET
AC_NEGRITAS:	INC B_NEGRITAS
				OR DL, 00001000B
				JMP IN_NEG				
NEGRITAS		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para insertar un caracter nullo.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				LONG_LINE: largo de la línea. 80 caracteres.
;----------------------------------------------------------------------------------------------
INSERTAR_CNULL	PROC NEAR
				INSERTAR_CAD CARACTER_NULL, 1 
				RET
INSERTAR_CNULL	ENDP

;--------------------------------------------------------------------------------------------
; Necesita pasar a STRING, la cadena a renderizar, y en CANT_CAR, cantidad de caracteres de
; de dicha cadena.
;--------------------------------------------------------------------------------------------
REND_CAD		PROC  NEAR
				PUSHA
				MOV   APUNTADOR_CAD, 0
				LEA   SI, CADENA_DEST
RECORRER:		LODSB
				CMP	  AL, 00H
				JE    SUP
CONTINUAR:		MOV   BX, CANT_CAR
				LEA   DX, CADENA_DEST[BX-1]
				INC APUNTADOR_CAD
				CMP   DX, SI
				JAE	  RECORRER
				;CMP APUNTADOR_CAD, BX
				;JNE RECORRER
				MOV APUNTADOR_CAD, 0
				SET_CUR PAGINA, 0, 2
				POPA
				RET
SUP:			CALL  SUPRIMIR
				JMP   CONTINUAR
REND_CAD		ENDP

;--------------------------------------------------------------------------------------------
; Procedimiento que identifica el final de la línea y determina si es posible imprimir la 
; palabra en ese espacio, si no es así, imprime NULL y un espacio en blanco al final de la
; línea y pasa lo que se escribía a la siguiente línea.
;--------------------------------------------------------------------------------------------
BAJAR_P			PROC  NEAR
				CMP   CHAR, 32
				JE	  IMP
				CMP   CHAR, 00H
				JE    IMP
				MOV   NULL_A_IMP, 0
				RESTAM APUNTADOR_CAD, 79
NO_SPACE:		DEC   SI
				DEC   APUNTADOR_CAD
				MOV	  CX, LONG_COP
				CMP	  APUNTADOR_CAD, CX
				JE    REG
				INC   NULL_A_IMP
				MOV   AL, [SI]
				CMP   AL, 32
				JNE   NO_SPACE
				INC   SI
				INC	  APUNTADOR_CAD
				MOV	  CX, NULL_A_IMP
VOLVER:			CALL INSERTAR_CNULL
				LOOP VOLVER
SAL_BAJAR:		RET
IMP:			DESPC CHAR
				INC   SI
				INC	  APUNTADOR_CAD
				JMP   SAL_BAJAR
REG:			ADD   SI, 79
				ADD   APUNTADOR_CAD, 79
				JMP   IMP
BAJAR_P			ENDP

HAY_ENTER		PROC  NEAR		
				DESPC 32
				INC   SI
				INC	  APUNTADOR_CAD
				MOVM  APUNTADOR_CAD, COP_APUNT_CAD
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				CMP   RESIDUO, 0
				JE    SALIR_ENTER
				MOV   CX, LONG_LINE
				SUB   CX, RESIDUO
VOLVER1:  		CALL INSERTAR_CNULL
				LOOP VOLVER1
				MOVM COP_APUNT_CAD, APUNTADOR_CAD
SALIR_ENTER:	RET
HAY_ENTER		ENDP

HAY_TAB			PROC NEAR
				DESPC 32
				INC   SI
				INC   APUNTADOR_CAD
				GET_CUR 0
				CMP   DL, 79
				JE    SALIR_TAB
				CALL  TABULADOR
SALIR_TAB:		RET
HAY_TAB 		ENDP

SET_STR			PROC  NEAR
				LEA   SI, CADENA_DEST
RECORRER1:		MOV   BX, CANT_CAR
				LEA   DX, CADENA_DEST[BX]
				CMP	  SI, DX
				JE    FIN2
				MOV	  AL, [SI]
				MOV   CHAR, AL
				GET_CUR PAGINA
				CMP	  CHAR, 13
				JE	  ENTERR
				CMP   CHAR, 09
				JE    TAB
				CMP   COL_ACTUAL, 79
				JE	  VERIFICAR
IMPR:			DESPC CHAR
				INC   SI
				INC   APUNTADOR_CAD
				JMP   RECORRER1
ENTERR:			CALL  HAY_ENTER
				JMP   RECORRER1
VERIFICAR:		CALL  BAJAR_P
				JMP   RECORRER1
TAB:			CALL  HAY_TAB
				JMP   RECORRER1
FIN2:		    RET
SET_STR			ENDP

;----------------------------------------------------------------------------------------------
; Limpia el Buffer de Teclado.
;----------------------------------------------------------------------------------------------
CLEAN_BUFF 		PROC  NEAR
				MOV   AH, 0CH
				INT   16H
				RET
CLEAN_BUFF 		ENDP

ES_ASCII		PROC  NEAR
				CMP	  ASCII, 08
				JE	  BACKS
				CMP   ASCII, 13
				JE    PRIN
				CMP   ASCII, 09
				JE    TABU
				CMP   CT, 79
				JNE   SIG
				CMP   ASCII, 32
				JE	  PRIN
				MOV   OFFSET_CUR, 0
				RESTAM APUNTADOR_CAD, 79
NO_SPACE1:		DEC   APUNTADOR_CAD
				MOV	  CX, LONG_COP
				CMP	  APUNTADOR_CAD, CX
				JE    PRIN
				INC   OFFSET_CUR
				MOV   BX, APUNTADOR_CAD
				MOV   AL, CADENA_DEST[BX]
				CMP   AL, 32
				JNE   NO_SPACE1
				XOR	  DX, DX
				MOV	  DX, OFFSET_CUR
				MOV   CT, DL
				INC   FT
SAL_ASCII:		INSERTAR_C ASCII 
BACK_LOL:		RET
PRIN:			INC   FT
				MOV   CT, 0
				JMP   SAL_ASCII
TABU:			CMP   CT, 67
				JAE   CUR_FIN
				ADD   CT, 12
				JMP   SAL_ASCII
CUR_FIN:		MOV   CT, 79
				JMP   SAL_ASCII
SIG:			INC   CT
				JMP   SAL_ASCII
BACKS:			CALL  BACKSPACE
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				MOV AX, RESIDUO
				MOV CT, AL
				MOV AX, COCIENTE
				MOV FT, AL
				ADD FT, 2
				JMP   BACK_LOL
ES_ASCII		ENDP

GET_ET			PROC NEAR
				MOV AH, 10H
				INT 16H
				MOV ASCII, AL
				MOV RASTREO, AH
				RET
GET_ET			ENDP
;-------------------------------------------------------------------------------------------
; FLUJO LÓGICO DEL PROGRAMA
;-------------------------------------------------------------------------------------------
FLUJO			PROC  NEAR
VUELVE:	   		CALL CLEAN_BUFF	
				GET_CUR PAGINA
				MOV AL, FILA_ACTUAL
				MOV FT, AL
				MOV AL, COL_ACTUAL
				MOV CT, AL
				SET_APUNTADOR FT, CT
				CALL  GET_ET
				CMP	  RASTREO, 0
				JE	  VUELVE
				CMP   ASCII, 0
				JE    FUN_ES
				CALL  ES_ASCII
				
IMP_P:			CALL  REND_CAD
				CALL Q10CLEAR
				CALL  SET_STR
				SET_CUR PAGINA, CT, FT
				JMP   VUELVE
FUN_ES:			CLD						; izq a der
				MOV	  AL, RASTREO		; busca ‘a’ en TEXTO
				MOV	  CX, 14
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

MAIN PROC FAR

				INICIO
				CREAR_A NOMBRE
				CALL  Q10CLEAR
				SET_CUR PAGINA, 0, 2
				;SET_APUNTADOR DH, DL
				CALL FLUJO

MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN
