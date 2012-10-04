INSERTAR_C 		PROC NEAR
				PUSHA			
				MOVM APUNTADOR_CAD, POS_INSERT
				MOVM APUNTADOR_CAD, INICIO_CAD
				MOV CX, LONGSTRING2
ETIQUETA:		INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				CMP BX CANT_CAR
				JE  
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JNE ETIQUETA
				MOV INICIO_NULL, BX
				RESTAM INICIO_NULL, INICIO_CAD
ENCONTRO:		INC CANT_NULL
				ADD BX, 1
				MOV AL, CADENA_DEST[BX]
				CMP AL, 00H
				JE ENCONTRO
				MOV BX, INICIO_CAD
				LIMPIAR CADENA_AUX, LONG_AUX
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				ADD BX, CANT_NULL
				MOV INICIO_CAD, BX
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				SUB CX, CANT_NULL
				LOOP CX
				
				
				RESTAM CANT_CAR, INICIO_CAD
				MOV BX, INICIO_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				MOV BX, POS_INSERT
				COPIAR_CAD S_2_INS, CADENA_DEST[BX], LONG_STRING2
				ADD BX, LONG_STRING2
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				SUMAM CANT_CAR, LONG_STRING2
				MOVM SUMA, CANT_CAR
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
ENTERR:			INC   SI
				MOV   LARGO, 78
				SUB   LARGO, DL
				MOV	  CX, LARGO
				MOV   APUNTADOR_CAD, SI
				MOVM  STRING, CADENA_DEST
VOLVER1:		INSERT_C 00H 
				INC   APUNTADOR_CAD
				LOOP VOLVER1
VERIFICAR:		CMP   CHAR, 32
				JE	  IMPR
				CMP   CHAR, 00H
				JE    IMPR
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
				JMP   RECORRER1
FIN:		    RET
SET_STR			ENDP

INSERTAR_C 		PROC NEAR
				PUSHA
				MOV AX, APUNTADOR_CAD								; Si está al final del String, no ejecuta la acción.
				CMP AX, LONG_STRING1
				JE SALE_C
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CARACTER, CADENA_DEST[BX], 1
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX+1], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				INC CANT_CAR
SALE_C:			POPA
				RET
INSERTAR_C		ENDP

INSERTAR_NULL	PROC NEAR
				PUSHA
				MOV AX, APUNTADOR_CAD								; Si está al final del String, no ejecuta la acción.
				CMP AX, LONG_STRING1
				JE SALE_NULL
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CARACTER_NULL, CADENA_DEST[BX], LONG_COP
				ADD BX, LONG_COP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				INC CANT_CAR
SALE_NULL:		POPA
				RET
INSERTAR_NULL	ENDP


		;DESP CADENA_DEST
		;CALL INSERTAR_C
		;INSERTAR_CAD S_2_INS, LONG_STRING2
		;CALL BACKSPACE
		;CALL SUPRIMIR
		;CALL CORTAR_CAD
		;CALL TABULADOR
		;CALL MOVC_UP
		;CALL MOVC_DOWN
		;CALL MOVC_IZ
		;CALL BACKSPACE
		;CALL SUPRIMIR
		;CALL COPIA_CAD
		;DESP CADENA_COPIAR
		;INSERTAR_CAD CARACTER, LONG_CAR
		;DESP CADENA_PRUEBA
		;COPIAR_CAD CADENA_PRUEBA, CADENA_DEST, 95
		;MOV APUNTADOR_CAD, 5
		;CALL CORTAR_CAD
		;CALL PEGA_CAD
		;CALL TABULADOR
		;MOV APUNTADOR_CAD, 0
		;SET_CUR 00, 00, 00
		;CALL NEGRITAS
		;SET_CUR 00, 00, 24
		;MOV AH, 09H
		;MOV AL, 2AH
		;MOV BH, 0
		;MOV BL, 01011010B
		;MOV CX, 5
		;INT 10H
		;CALL MOVC_UP
		;CALL HOME_STR
		;CALL END_STR
		;CALL MOVC_IZ
		;CALL MOVC_DER
		;CALL INSERTAR_C
		;MOVM CANT_CARP, CANT_CAR
		;CALL REND_CAD
		;CALL SET_STR
		;DESP CADENA_DEST
		;DESP CADENA_PRUEBA
		;GET_CUR 0
		
		
		
; +-------------------------------------------------------------------------------+
; | Universidad del Valle de Guatemala                                            |
; | Taller de Assembler                                                           |
; | Evelyn Lissete Paiz     11365                                                 |
; | Andrea Mendoza          11331                                                 |
; | Sección: 20                                                                   |
; +-------------------------------------------------------------------------------+

;                                  -Proyecto No.2-

; +-------------------------------------------------------------------------------+
; | Descripción del programa:                                                     |
; | Editor de texto.                                                              |
; +-------------------------------------------------------------------------------+

; +-----------------------------------+
; | Definición de macros              |
; +-----------------------------------+

; +-----------------------------------------------------------------+
; Macro INITZ:
; Inicialización del área de datos(Marta Ligia).

INITZ        MACRO                                  ;; Define la maccro
             MOV AX, @data                          ;; Inicialización de area de datos.
             MOV DS, AX
             MOV ES, AX
             ENDM                                   ;; Fin macro

; +-----------------------------------------------------------------+
; Macro MOD_VIDEO:
; Fijar modo de video en texto a color (03H) (Marta Ligia).

MOD_VIDEO    MACRO
             PUSHA
             MOV AH, 00H                            ;; Designación de modo.
	     MOV AL, 03H                            ;; Texto a color, 80x25.
	     INT 10H                                ;; Llamada al BIOS.
             POPA
             ENDM

;---------------------------------------------------------------------+
; Macro MOSTMENU:
; Muestra el Menu de la opción de Archivo (F1) (Marta Ligia).

MOSTMENU     MACRO TOPROW, BOTROW, LEFCOL, SHADOW, TAMANO, MENU
             LOCAL B20
             LOCAL B30
             PUSHA				    ;; Guardar todos los registros
             MOV DH, TOPROW+1			    ;; Fila superior de sombra
B20:	     MOV AX, 1301H			    ;; Dibujar caja sombreada
             MOV BL, 70H                            ;; Atributo
             MOV BH, PAG			    ;; Pagina
             LEA BP, SHADOW			    ;; Caracteres sombreados
             MOV CX, TAMANO			    ;; numero de caracteres
             MOV DL, LEFCOL+1			    ;; Columna izq de sombra
             INT 10H
             INC DH		                    ;; Siguiente fila
             CMP DH, BOTROW+2			    ;; Se desplegaron todas las columnas?
             JNE B20				    ;; No, repetir
             LEA BP, MENU			    ;; linea del menu
             MOV DH, TOPROW			    ;; Fila
B30:         MOV BL, 30H			    ;; Pagina y atributo: negro sobre celeste.
             MOV AX, 1300H			    ;; Solicitar menu de despliegue
             MOV CX, TAMANO			    ;; Longitud de la linea
             MOV DL, LEFCOL			    ;; Columna
             PUSH DX				    ;; Guarda el registro que contiene fila, columna
             INT 10H
             ADD BP, TAMANO			    ;; Siguiente linea del menu
             POP DX				    ;; Recupera registro con fila, columna
             INC DH				    ;; Siguiente fila
             CMP DH, BOTROW+1			    ;; Se mostraron todas las filas?
             JNE B30				    ;; no, repetir
             POPA				    ;; Recuperar registros
             ENDM

;---------------------------------------------------------------------+
; Macro DISPLYM:
; Permite el despliegue (Marta Ligia).

DISPLYM      MACRO ROW, TOPROW, COL, MENU, ATTRIB, TAMANO
             PUSHA				    ;; Guardar registros
             MOVZX AX, ROW			    ;; la fila indica que linea fijar
             SUB AX, TOPROW
             IMUL AX, TAMANO			    ;; Ftiplicar por longitud de linea
             LEA SI, MENU+1			    ;; para seleccionar fila del menu
             ADD SI, AX

             MOV AX, 1300H			    ;; Solicita despliegue
             MOVZX BX, ATTRIB			    ;; Atributo
             MOV BH, PAG                            ;; Pagina
             MOV BP, SI				    ;; Caracter de cadena menu
             MOV CX, TAMANO-2			    ;; Longitud de cadena menu
             MOV DH, ROW			    ;; Fila
             MOV DL, COL+1			    ;; Columna
             INT 10H
             POPA				    ;; Recuperar registros
             ENDM

;---------------------------------------------------------------------+
; Macro DISPLYM2:
; Permite el despliegue.

DISPLYM2     MACRO MENU, COL
             PUSHA                                  ;; Guarda los registros
             MOV AX, 0 			            ;; La fila indica que linea fijar
             LEA SI, MENU			    ;; para seleccionar fila del menu
             MOV BL, COL
             ADD SI, BX

             MOV AX, 1300H			    ;; Solicita despliegue
             MOV BL, 03H			    ;; Atributo
             MOV BH, PAG                            ;; Pagina
             MOV BP, SI				    ;; Caracter de cadena menu
             MOV CX, 13  			    ;; Longitud de cadena menu
             MOV DH, 0  			    ;; Fila
             MOV DL, COL  			    ;; Columna
             INT 10H
             POPA                                   ;; Recupera los registros.
             ENDM
;---------------------------------------------------------------------+
; Procedimiento LOCALES:
; Permite describir las locales para las macros Input.

LOCALES      MACRO
             LOCAL C20
             LOCAL C30
             LOCAL C40
             LOCAL C50
             LOCAL C90
             ENDM
;---------------------------------------------------------------------+
; Procedimiento INPUTM:
; Permite el ingreso de una tecla y determina que hacer (Marta Ligia).

INPUTM       MACRO INGRESO, ROW, TOPROW, LEFTCOL, BOTROW, MENU, ATTRIB, TAMANO
             LOCAL C20
             LOCAL C30
             LOCAL C40
             LOCAL C50
             LOCAL C90
             PUSHA			            ;; Guardar registros
C20:	     MOV AH, 10H			    ;; Leer caracter de teclado
             INT 16H
             CMP AH, 50H			    ;; Cod rastreo flecha arriba?
             JE	C30
             CMP AH, 48H			    ;; Cod rastreo flecha abajo?
             JE C40
             CMP AL, 0DH			    ;; Ascii enter?
	     JE C90
             CMP AL, 1BH			    ;; Ascii esc?
             JE	C90
             JMP C20
C30:	     MOV INGRESO, AL
             MOV ATTRIB, 30H			    ;; Flecha-arriba, azul sobre blanco
             DISPLYM ROW, TOPROW, LEFTCOL, MENU, ATTRIB, TAMANO
             INC ROW				    ;; Fila siguiente
             CMP ROW, BOTROW-1			    ;; Se paso de la ultima fila?
             JBE C50				    ;; No, ok
             MOV ROW, TOPROW+1			    ;; Si, iniciar fila
             JMP C50
C40:	     MOV INGRESO, AL
             MOV ATTRIB, 30H			    ;; Flecha-abajo, negro sobre celeste
             DISPLYM ROW, TOPROW, LEFTCOL, MENU, ATTRIB, TAMANO
             DEC ROW				    ;; Fila anterior
             CMP ROW, TOPROW+1			    ;; Se paso de la primera fila?
             JAE C50				    ;; No, ok
             MOV ROW, BOTROW-1			    ;; Si, iniciar fila
C50:	     MOV INGRESO, AL
             MOV ATTRIB, 03H			    ;; Celeste sobre negro
             DISPLYM ROW, TOPROW, LEFTCOL, MENU, ATTRIB, TAMANO
             JMP C20
C90:         MOV INGRESO, AL                        ;; Guarda el valor del ingreso
             POPA				    ;; recuperar registros
             ENDM

;---------------------------------------------------------------------+
; Procedimiento INPUTM2:
; Permite el ingreso de una tecla y determina que hacer (Marta Ligia).

INPUTM2      MACRO MENU, COL, INGRESO
             LOCALES
             PUSHA			            ;; Guardar registros
C20:	     MOV AH, 10H			    ;; Leer caracter de teclado
             INT 16H
             CMP AH, 4DH			    ;; Cod rastreo flecha derecha?
             JE	C30
             CMP AH, 4BH			    ;; Cod rastreo flecha izquierda?
             JE C40
             CMP AL, 0DH			    ;; Ascii enter?
	     JE C90
             CMP AL, 1BH			    ;; Ascii esc?
             JE	C90
             JMP C20
C30:	     MOV INGRESO, AL
             CMP COL, 40			    ;; Se paso de la ultima fila?
             JAE C90				    ;; No, ok
             ADD COL, 13			    ;; Fila siguiente
             JMP C90
C40:	     MOV INGRESO, AL
             CMP COL, 2 			    ;; Se paso de la primera opcion?
             JBE C90				    ;; No, ok
             SUB COL, 13			    ;; Fila anterior
             JMP C90
C50:	     MOV INGRESO, AL
             DISPLYM2 MENU, COL
             JMP C20
C90:         MOV INGRESO, AL
             POPA				    ;; recuperar registros
             ENDM

; +-----------------------------------------------------------------+
; Macro DESP: (Marta Ligia)
; Despliega el mensaje en pantalla.
DESP	     MACRO CADENA
	     MOV AH, 09H		            ;; Desplegar mensaje
             LEA DX, CADENA
      	     INT 21H
      	     ENDM

; +-----------------------------------------------------------------+
; Macro CURSOR:
; Permite el manejo del cursor (Marta Ligia).

CURSOR       MACRO PAG, FILA, COLUMNA
             PUSHA
             MOV AH, 02H		            ;; Peticion de fijar cursor
	     MOV BH, PAG                            ;; Pagina
	     MOV DH, FILA		            ;; Fila
	     MOV DL, COLUMNA		            ;; Columna
	     INT 10H
             POPA
             ENDM

; +-----------------------------------------------------------------+
; Macro CURSOR:
; Permite el manejo del cursor (Marta Ligia).

CURSORA      MACRO PAG, FILA, COLUMNA
             PUSHA
             MOV AH, 02H		            ;; Peticion de fijar cursor

	     MOV BH, PAG                            ;; Pagina
	     MOV DH, FILA		            ;; Fila
	     MOV DL, COLUMNA		            ;; Columna
	     INT 10H
             POPA
             ENDM

; +-----------------------------------------------------------------+
; Macro CAMBIOPAG:
; Permite guardar la info que está en la pag.

CAMBIOPAG    MACRO CAD1, CAD2
             CLD                                    ;; Izq a der
             MOV CX, 1839                           ;; Longitud
             LEA SI, CAD1                           ;; Cadena fuente
             LEA DI, CAD2                           ;; Cadena destino
REP          MOVSB                                  ;; Copia la cadena.
             ENDM

; +-----------------------------------------------------------------+
; Macro MOV_APUN: (Marta Ligia)
; Mueve el apuntador del archivo.

MOV_APUN     MACRO MANEJADOR, POS
	     MOV AH, 42H			    ;; Peticion para mover el apuntador
      	     MOV AL, POS			    ;; 00: inicio, 01: pos actual 02: fin archivo
      	     MOV BX, MANEJADOR	                    ;; MANEJADOR
      	     MOV CX, 00H
      	     MOV DX, N_BYTES	                    ;; DESPLAZAMIENTO DE n BYTES
      	     INT 21H
      	     ENDM

; +-----------------------------------------------------------------+
; Macro DESP: (Marta Ligia)
; Despliega el mensaje en pantalla.
DESP	     MACRO CADENA
	     MOV AH, 09H		            ;; DESPLEGAR MENSAJE
             LEA DX, CADENA
      	     INT 21H
      	     ENDM

; +-----------------------------------------------------------------+
; Macro ABRIR_A: (Marta Ligia)
; Abre un archivo ya existente.
ABRIR_A	     MACRO NOM_ARCHIVO
	     MOV AH, 3DH			    ;; petición
	     MOV AL, 02H			    ;; 00: modo sólo lectura, 01: solo escritura, 02: lect/escr
	     LEA DX, NOM_ARCHIVO	            ;; cadena ASCIIZ
	     INT 21H
	     MOV MANEJ, AX		            ;; guardar el manejador
	     ENDM

; +-----------------------------------------------------------------+
; Macro CERRAR_A: (Marta Ligia)
; Cierra un archivo en uso.
CERRAR_A     MACRO MANEJADOR
	     MOV AH, 3EH			    ;; petición
	     MOV BX, MANEJADOR	                    ;; manejador
	     INT 21H
	     ENDM

; +-----------------------------------------------------------------+
; Macro LEER_A: (Marta Ligia)
; Lee los datos del archivo.
LEER_A	     MACRO MANEJADOR
	     MOV AH, 3FH			    ;; petición
	     MOV BX, MANEJADOR	                    ;; manejador
	     MOV CX, 1839  		            ;; longitud del registro
	     LEA DX, PAG0T		            ;; registro donde se leen datos
	     INT 21H
	     ENDM

; +-----------------------------------------------------------------+
; Macro ESCRIBIR_A: (Marta Ligia)
; Lee los datos del archivo.
ESCRIBIR_A   MACRO MANEJADOR, DATOS
	     MOV AH, 40H			    ;; petición para escribir
	     MOV BX, MANEJADOR	                    ;; manejador de archivo
	     MOV CX, 16			            ;; longitud del registro
	     LEA DX, DATOS		            ;; dirección del área de datos
	     INT 21H			            ;; llama al DOS
	     ENDM

; +-----------------------------------------------------------------+
; Macro MOVIMIENTOS:
; Realiza movimientos necesarios para manejar el texto.

MOVIMIENTOS  MACRO
             MOV BL, FILA                           ;; Mueve la fila del cursor
             SUB BL, 2
             MOV AX, 80                             ;; Determina las veces que se van a multiplicar
             MUL BX
             MOV BX,0                               ;; Limpia BX
             MOV BL, COLUMNA                        ;; Suma las columnas
             SUB BL, 1                              ;; Colo puntero de la cadena correctamente.
             ADD BX, AX
             MOV APUNTADOR, BX                      ;; Guarda BX
             ENDM

; +-----------------------------------+
; | Definición de modelo de memoria   |
; +-----------------------------------+

.MODEL LARGE                                        ;Modelo de memoria pequeño
.STACK 2048                                         ;Segmento de sack

; +-----------------------------------+
; | Definición de datos               |
; +-----------------------------------+

.DATA
.386

; +-------------------+
; | Variables         |
; +-------------------+

TOPROW	     EQU    01				    ; Fila superior menu
BOTROW	     EQU    04		                    ; Fila inferior menu
LEFCOL	     EQU    02				    ; Columna izquierda menu

TAMANO1      EQU    14                              ; Tamaño de caracteres
TAMANO2      EQU    22                              ; Tamaño de caracteres
TAMANO3      EQU    54                              ; Tamaño de caracteres
ATTRIB	     DB	    ?				    ; Atributo de pantalla
ROW	     DB	    ?				    ; Fila pantalla
COL          DB     ?                               ; Columna de la pantalla
INGRESO	     DB	    ?				    ; Guarda tecla sada
EXTENSION    DB     ?                               ; Determina si es carácter ASCII o tecla de función.
TECLA        DB     ?                               ; Código de rastreo de la tecla ingresada.
PAG          DB     0                               ; La página que se está utilizando.
FILA         DB     2                               ; La fila donde se encuentra el cursor.
COLUMNA      DB     0                               ; La columna donde se encuentra el cursor.
AUX          DB     0                               ; Variable que guarda el valor de una resta
APUNTADOR    DW     ?                               ; Apuntador
INSTBAND     DB     1                               ; Bandera de inserción
FILAED1      DW     0                               ; Numero de posicion inicial de la cadena PAG0T a editar en la cadena.
FILAED2      DB     0                               ; Numero de posicion final a editar en la cadena PAG0T.

POSX         DW     ?                               ;cx, coordenada horizontal
POSY         DW     ?                               ;dx, cooredenada vertical
ESTADOBOTON  DW     ?                               ;estado de los botones, bit 0,1,2
VECESCLIC    DW     ?                               ;guarda las veces que se ha presionado un boton.
VECESCLIC2   DW     ?                               ;guarda las veces que se ha presionado un boton.
NOTASE       DB     10   DUP(?)                     ;Notas de los estudiantes
DIVIDIR      DW     ?
FILAA        DB     ?
COLUMNAA     DB     ?

; +-------------------+
; | Texto             |
; +-------------------+
PAG0T        DB     1839 DUP(" ")                   ; Texto en la pag.
CADFIN0      DB     "$"
PAGINA1      DB     1839 DUP(" ")                   ; Texto en la pag 0.
PAGINA0      DB     1839 DUP(" ")                   ; Texto en la pag 1.
PAGINA2      DB     1839 DUP(" ")                   ; Texto en la pag 2.
PAGINA3      DB     1839 DUP(" ")                   ; Texto en la pag 3.
TEMP         DB     " "                             ; Texto temporal
NOMBRE	     DB	    '            ',00h              ; Nombre del archivo que se está utilizando.
TXTEDITAR    DB     79 DUP(" ")                     ; Texto de una fila a modificar, el texto "copiado"

; +-------------------+
; | Opciones del menu |
; +-------------------+

MENU         DB     '     Archivo      Edicion      Formato       Ayuda                                  '

ARCHIVO      DB     0C9H, 12 DUP (0CDH) , 0BBH      ; Dibuja la opción de Archivo (F1)
             DB     0BAH, ' Abrir      ', 0BAH
             DB     0BAH, ' Guardar    ', 0BAH
             DB     0BAH, ' Salir      ', 0BAH
             DB     0C8H, 12 DUP (0CDH) , 0BCH

EDICION      DB     0C9H,      20 DUP (0CDH)    , 0BBH   ; Dibuja la opción de Edición (F2)
             DB     0BAH, ' Cortar             ', 0BAH
             DB     0BAH, ' Copiar             ', 0BAH
             DB     0BAH, ' Pegar              ', 0BAH
             DB     0BAH, ' Buscar y Remplazar ', 0BAH
             DB     0C8H,      20 DUP (0CDH)    , 0BCH

FORMATO      DB     0C9H, 12 DUP (0CDH) , 0BBH      ; Dibuja la opción de Formato (F3)
             DB     0BAH, ' Negrita    ', 0BAH
             DB     0BAH, ' Normal     ', 0BAH
             DB     0C8H, 12 DUP (0CDH) , 0BCH

AYUDA        DB     0C9H, 12 DUP (0CDH) , 0BBH      ; Dibuja la opción de Ayuda (F4)
             DB     0BAH, ' Manual     ', 0BAH
             DB     0BAH, ' Creditos   ', 0BAH
             DB     0C8H, 12 DUP (0CDH) , 0BCH

SHADOW	     DB	    14 DUP(0DBH)		    ; Caracteres de sombreado
SHADOW2	     DB	    22 DUP(0DBH)		    ; Caracteres de sombreado
SHADOW3	     DB	    54 DUP(0DBH)		    ; Caracteres de sombreado

ABRIRM       DB     0C9H,      20 DUP (0CDH)    , 0BBH   ; Dibuja la opción de Edición (F2)
             DB     0BAH, '  Ingrese nombre :  ', 0BAH
             DB     0BAH, '                    ', 0BAH
             DB     0BAH, '                    ', 0BAH
             DB     0BAH, '     ENTER - OK     ', 0BAH
             DB     0C8H,      20 DUP (0CDH)    , 0BCH

; +-----------------+
; | Archivo         |
; +-----------------+

MANEJ	     DW	    ?
EXITO	     DB	    0DH, 0AH,0DH, 0AH,' El archivo se abrio exitosamente. Manejador: $'
EXITO2	     DB	    0DH, 0AH,0DH, 0AH,' El archivo se cerro exitosamente. Manejador: $'
ERROR	     DB	    0DH, 0AH,0DH, 0AH,' No pudo abrirse el archivo$'
ERROR2       DB	    0DH, 0AH,0DH, 0AH,' No pudo cerrarse el archivo$'
EXITO_L	     DB	    0DH,0AH,0DH, 0AH,' El archivo se leyo exitosamente$'
ERROR_L1     DB	    0DH, 0AH,0DH, 0AH,' No pudo leerse del archivo$'
ERROR_L2     DB	    0DH, 0AH,0DH, 0AH,' No se realizo la lectura completa del archivo$'
EXITO_E	     DB	    0DH,0AH,0DH,0AH,' El archivo se escribio exitosamente$'
ERROR_E1     DB	    0DH,0AH,0DH,0AH,' No pudo escribirse en el archivo$'
ERROR_E2     DB	    0DH,0AH,0DH,0AH,' No se realizo la escritura completa en el archivo$'
EXITO_M	     DB	    0DH,0AH,0DH, 0AH,' El apuntador de archivo se movio exitosamente$'
ERROR_M	     DB	    0DH,0AH,0DH, 0AH,' No se realizo el movimiento del apuntador$'
MENS	     DB     ' , presione cualquier tecla para continuar$'
N_BYTES	     DW	    0


; +-----------------------------------+
; | Inicio del código                 |
    .CODE
; +-----------------------------------+


;---------------------------------------------------------------------+
; Procedimiento CLEAR:
; Limpia la pantalla (Marta Ligia).

CLEAR        PROC
             PUSHA				    ; Guardar registros
             MOV AX, 0600H
             MOV BH, 20H		            ; Negro sobre verde
             MOV CX, 0000H	                    ; Pantalla completa
             MOV DX, 184FH	                    ; Fila 24, col 79
             INT 10H
             POPA				    ; Recuperar Registros
             RET
CLEAR ENDP

;---------------------------------------------------------------------+
; Procedimiento MMENU:
; Muestra el Menu(Marta Ligia).

MMENU        PROC NEAR
             PUSHA
             CALL CLEAR                             ; Limpia la pantalla

             LEA BP, MENU			    ; linea del menu
             MOV DH, 0   			    ; Fila
             MOV BL, 30H			    ; Atributo: negro sobre celeste.
             MOV BH, PAG                            ; Pagina
             MOV AX, 1300H			    ; Solicitar menu de despliegue
             MOV CX, 80  			    ; Longitud de la linea
             MOV DL, 0  			    ; Columna
             INT 10H
             POPA
             RET
MMENU        ENDP

;---------------------------------------------------------------------+
; Procedimiento MARCHIVO:
; Muestra el Menu de la opción de Archivo (F1) (Marta Ligia).

MARCHIVO     PROC NEAR
             PUSHA
             CALL OCULTARMOUSE
             DISPLYM2 MENU, 2
             MOV ROW, BOTROW+5                      ; Fija la fila
             CALL MOSTRARMOUSE

A20:         CALL OCULTARMOUSE
             MOSTMENU TOPROW, BOTROW+1, LEFCOL, SHADOW, TAMANO1, ARCHIVO

             MOV ROW, TOPROW+1		            ; Fijar la fila en la primera opcion
             MOV ATTRIB, 03H		            ; Fijar video inverso
             DISPLYM  ROW, TOPROW, LEFCOL, ARCHIVO, ATTRIB, TAMANO1
             INPUTM   INGRESO, ROW, TOPROW, LEFCOL, BOTROW+1, ARCHIVO, ATTRIB, TAMANO1
             CALL MOSTRARMOUSE
             CMP INGRESO, 1BH			    ;  presiono esc?
             JE SIGAR				    ; no, continuar
             CMP INGRESO, 0DH                       ; presiono enter?
             JNE A20                                ; no, continuar
             CALL OPCIONESARC                       ; muestra las opciones de los archivos
SIGAR:       CALL OCULTARMOUSE
             MOV AX, 0600H			    ; si, terminar
             CALL CLEAR				    ; limpiar pantalla
             POPA
             RET
MARCHIVO     ENDP

;---------------------------------------------------------------------+
; Procedimiento OPCIONESARC:
; Verifica en que opcion se dio enter para realizar la solicitud.

OPCIONESARC  PROC NEAR
             CMP ROW, 2                             ; Está en la opción de abrir.
             JE OPEN
             CMP ROW, 3                             ; Está guardando el archivo.
             JE SAVE
             JMP SALI                               ; Se desea salir
OPEN:        MOSTMENU 9, 14, 28, SHADOW2, TAMANO2, ABRIRM
             CALL OPENS                             ; Abre el archivo.
             JMP AFN
SAVE:
SALI:        MOV TECLA, 1                           ; Se determina que se quiere salir.
AFN:         RET
OPCIONESARC  ENDP

;---------------------------------------------------------------------+
; Procedimiento OPENS:
; Abre el archivo que el usuario selecciona (F1).

OPENS        PROC NEAR
             CURSOR PAG, 12, 32                     ; Coloca en su lugar el cursor.
             MOV BX, 0
OPENL:       CALL INGTECLA                          ; Permite ingresar una tecla.
             CMP EXTENSION, 0DH                     ; Se ingreso un ENTER.
             JE OPN
             MOV AL, EXTENSION                      ; Guarda el caracter.
             CMP BX, 13
             JE OPENL                               ; No permite ingresar más de 13 caracteres.
             MOV NOMBRE[BX], AL
             INC BX                                 ; Incrementa el apuntador.
             MOV DL, AL
             CALL OUTC                              ; Muestra el caracter.
             JMP OPENL
OPN:         CURSOR PAG, 15, 10                     ; Coloca el cursor.
             CALL ABRIR                             ; Muestra si se abrio el archivo.
             RET
OPENS        ENDP

;---------------------------------------------------------------------+
; Procedimiento SAVES:
; Guarda el archivo que el usuario selecciona (F1).

SAVES        PROC NEAR
             MOV AL, 10
             RET
SAVES        ENDP

;---------------------------------------------------------------------+
; Procedimiento MEDICION:
; Muestra el Menu de la opción de Edición (F2) (Marta Ligia).

MEDICION     PROC NEAR
             PUSHA
             DISPLYM2 MENU, 15
             MOV ROW, BOTROW+6                      ; Fija la fila

A30:         MOSTMENU TOPROW, BOTROW+2, LEFCOL+13, SHADOW2, TAMANO2, EDICION

             MOV ROW, TOPROW+1		            ; Fijar la fila en la primera opcion
             MOV ATTRIB, 03H		            ; Fijar video inverso
             DISPLYM  ROW, TOPROW, LEFCOL+13, EDICION, ATTRIB, TAMANO2
             INPUTM   INGRESO, ROW, TOPROW, LEFCOL+13, BOTROW+2, EDICION, ATTRIB, TAMANO2
             CMP INGRESO, 1BH			    ; presiono esc?
             JE RETURN 				    ; no, continuar
             CMP INGRESO, 0DH                       ; presiono enter?
             JNE A30                                ; no, continuar
             CALL OPCIONESED                        ; Verificar en donde dio enter
RETURN:      MOV AX, 0600H			    ; si, terminar
             CALL CLEAR				    ; limpiar pantalla
             POPA
             RET
MEDICION     ENDP

;---------------------------------------------------------------------+
; Procedimiento OPCIONESED:
; Verificar en que opcion se dio enter y luego realizar la edicion.

OPCIONESED   PROC NEAR
             CMP ROW, 2                             ; Está en la opción de abrir.
             JE CUT
             CMP ROW, 3                             ; Está guardando el archivo.
             JE COPY
             CMP ROW, 4
             JE PASTE
             CMP ROW, 5
             JMP SEARCH

CUT:
COPY:        CALL COPIANDO
             JMP AFJ
PASTE:
SEARCH:

AFJ:         RET
OPCIONESED   ENDP


;---------------------------------------------------------------------+
; Procedimiento COPIANDO:
; Copiar el texto de la linea en que se encuentra el cursor.
COPIANDO     PROC NEAR

             CALL FILAEDITAR                        ; Calcula la fila que se va a editar.
             CALL GUARDARFILAED                     ; Guarda la fila solicitada por el usuario.

             RET
COPIANDO     ENDP


; +-----------------------------------------------------------------+
; Procedimiento COUT: (Marta Ligia)}
; Muestra una cadena en la pantalla.

COUT         PROC NEAR

             MOV AH, 09H                            ;Peticion para desplegar
             INT 21H                                ;Llama al DOS
             RET

COUT         ENDP

; +-----------------------------------------------------------------+
; Procedimiento FILAEDITAR
; Regresa el valor de la fila a modificar (FILAED1), es decir, en donde se
; encuentra el cursor.

FILAEDITAR   PROC NEAR
             PUSHA
             XOR BX,BX
             MOV BL,FILA                            ; Copiar la fila actual
             SUB BL,2                               ; Le resto a la fila 2, para encontrar la posicion real en la cadena.

             CMP BL,0                               ; Si esta en la fila 0
             JE  ESCERO

             XOR AX,AX
             MOV AL,80                              ; Multiplica por 80 para encontrar la posicion inicial de la fila a copiar mas adelante.
             MUL BX                                 ; Si esta arriba de la fila 0
             MOV FILAED1,AX                         ; Posision a comenzar a copiar de la cadena PAG0T

             MOV FILAED2,AH
             ADD FILAED2,79                         ; Termina de editar la cadena en la posicion inicial mas 79
             JMP TERMINA

ESCERO:      MOV FILAED1,BX                         ; Comienza en la posicion 0 a copiar la cadena PAG0T mas adelante
             MOV FILAED2,79                         ; Si esta en la fila 0, se queda en la columna inicial 0.
                                                    ; Columna final a editar es 79

TERMINA:     POPA
FILAEDITAR   ENDP


; +-----------------------------------------------------------------+
; Procedimiento GUARDARFILAED
; Guarda en memoria la fila de texto a editar, ya sea para cortar o copiar
GUARDARFILAED PROC NEAR
              PUSHA
              XOR BX,BX                             ; limpio el bx
              MOV BX,FILAED1                        ; Guardo el valor de donde debe comenzar a copiar la cadena.
              MOV CX,79                             ; Contador 79, porque vamos a copiar la fila entera.
              MOV SI,0

BACK10:       MOV AL, PAG0T[BX]                     ; copiamos de la cadena actual
              MOV TEMP, AL                          ; copiamos el valor a una variable temp.
              MOV AL, TEMP                          ; Guardamos el valor a copiar en Al
              MOV TXTEDITAR[SI],AL                  ; Guardamos el valor en la nueva cadena.
              INC BX
              INC SI
              LOOP BACK10

              POPA
              RET
GUARDARFILAED ENDP


;---------------------------------------------------------------------+
; Procedimiento MFORMATO:
; Muestra el Menu de la opción de Formato (F3) (Marta Ligia).

MFORMATO     PROC NEAR
             PUSHA
             DISPLYM2 MENU, 28
             MOV ROW, BOTROW+4                      ; Fija la fila

A40:         MOSTMENU TOPROW, BOTROW, LEFCOL+26, SHADOW, TAMANO1, FORMATO

             MOV ROW, TOPROW+1		            ; Fijar la fila en la primera opcion
             MOV ATTRIB, 03H		            ; Fijar video inverso
             DISPLYM  ROW, TOPROW, LEFCOL+26, FORMATO, ATTRIB, TAMANO1
             INPUTM   INGRESO, ROW, TOPROW, LEFCOL+26, BOTROW, FORMATO, ATTRIB, TAMANO1
             CMP INGRESO, 1BH			    ;  presiono esc?
             JNE A40				    ; no, continuar
             MOV AX, 0600H			    ; si, terminar
             CALL CLEAR				    ; limpiar pantalla
             POPA
             RET
MFORMATO     ENDP

;---------------------------------------------------------------------+
; Procedimiento MAYUDA:
; Muestra el Menu de la opción de Ayuda (F4) (Marta Ligia).

MAYUDA       PROC NEAR
             PUSHA
             DISPLYM2 MENU, 41
             MOV ROW, BOTROW+4                      ; Fija la fila

A50:         MOSTMENU TOPROW, BOTROW, LEFCOL+39, SHADOW, TAMANO1, AYUDA

             MOV ROW, TOPROW+1		            ; Fijar la fila en la primera opcion
             MOV ATTRIB, 03H		            ; Fijar video inverso
             DISPLYM  ROW, TOPROW, LEFCOL+39, AYUDA, ATTRIB, TAMANO1
             INPUTM   INGRESO, ROW, TOPROW, LEFCOL+39, BOTROW, AYUDA, ATTRIB, TAMANO1
             CMP INGRESO, 1BH			    ;  presiono esc?
             JNE A50				    ; no, continuar
             MOV AX, 0600H			    ; si, terminar
             CALL CLEAR				    ; limpiar pantalla
             POPA
             RET
MAYUDA       ENDP

; +-----------------------------------------------------------------+
; Procedimiento OPI:
; Permite el movimiento a la izquierda del cursor.

OPI          PROC NEAR

             CMP COLUMNA, 0                         ; Revisa si ya se llegó al final de la columna.
             JE SIGA2
             DEC COLUMNA
             JMP FIN3
SIGA2:       CMP FILA, 0                            ; Determina si se está en el final.
             JE FIN3
             DEC FILA                               ; Cambia de fila.
             MOV COLUMNA, 79                        ; Cambia de columna.
FIN3:        RET
OPI          ENDP

; +-----------------------------------------------------------------+
; Procedimiento OPDE:
; Permite el movimiento a la derecha del cursor.

OPDE         PROC NEAR

             CMP COLUMNA, 79                        ; Revisa si ya se llegó al final de la columna.
             JE SIGA3
             INC COLUMNA
             JMP FIN4
SIGA3:       CMP FILA, 24                           ; Determina si se llegó al final.
             JE FIN4
             INC FILA                               ; Cambia de fila.
             MOV COLUMNA, 0                         ; Cambia de columna.
FIN4:        RET
OPDE         ENDP

; +-----------------------------------------------------------------+
; Procedimiento OP2:
; Permite determinar si se se desea cambiar la posición del cursor a través de las flechas.

OP2          PROC NEAR

             CMP TECLA, 48H                         ; Determina si se desea moverse arriba.
             JE  OPCIONU                            ; Salta a la opcion de arriba.
             CMP TECLA, 50H                         ; Determina si se desea moverse abajo.
             JE  OPCIOND                            ; Salta a la opcion de abajo.
             CMP TECLA, 4BH                         ; Determina si se desea moverse a la izquierda.
             JE  OPCIONI                            ; Salta a la opción de la izquierda.
             CMP TECLA, 4DH                         ; Determina si se desea moverse a la derecha.
             JE  OPCIONDE                           ; Salta a la opcion de la derecha.
             JMP FINAL
OPCIONU:     CMP FILA, 2                            ; Se encuentra en la primera fila?
             JE FIN2                                ; entonces no hacer nada.
             DEC FILA                               ; Mueve el cursor arriba.
             JMP FIN2
OPCIOND:     CMP FILA, 24                           ; Se encuentra en la última fila?
             JE FIN2                                ; entonces no hacer nada.
             INC FILA                               ; Mueve el cursor para abajo.
             JMP FIN2
OPCIONI:     CMP FILA, 2                            ; Se encuentra en la primera fila?
             JNE REI                                ; si no, entonces seguir.
             CMP COLUMNA, 0                         ; Se encuentra en la primera columna?
             JE FIN2                                ; entonces no hacer nada.
REI:         CALL OPI                               ; Permite determinar el movimiento a la izquierda.
             JMP FIN2
OPCIONDE:    CALL OPDE                              ; Permite determinar el movimiento a la derecha.
FIN2:        CURSOR PAG, FILA, COLUMNA
FINAL:       RET
OP2          ENDP

; +-----------------------------------------------------------------+
; Procedimiento OP3:
; Permite borrar con SUP.

OP3          PROC NEAR
             PUSHA                                  ; Guarda los registros
             MOV AH, 01H                            ; Cambio de cursor.
             CMP INSTBAND, 0                        ; Verifica si la inserción está desactivada
             JNE DESACTIVAR
ACTIVAR:     MOV INSTBAND, 1                        ; Activa la inserción.
             MOV CH, 6                              ; Vuelve al cursor corto.
             MOV CL, 7
             JMP FN3
DESACTIVAR:  MOV INSTBAND, 0                        ; Desactiva la inserción.
             MOV CH, 0                              ; Vuelve al cursor largo.
             MOV CL, 7
FN3:         INT 10H
             POPA                                   ; Regresa los registros
             RET
OP3          ENDP

; +-----------------------------------------------------------------+
; Procedimiento OP4:
; Permite borrar con SUP.

OP4          PROC NEAR
             PUSHA                                  ; Guarda los registros
             MOV BX, 0
             MOV BL, FILA                           ; Mueve la fila del cursor
             SUB BL, 2
             MOV AX, 80                             ; Determina las veces que se van a multiplicar
             MUL BX
             MOV BX,0                               ; Limpia BX
             MOV BL, COLUMNA                        ; Suma las columnas
             ADD BX, AX
             MOV CX, 1839                           ; Contador
BACK4:       MOV AL, PAG0T[BX+1]                    ; Mueve el caracter siguiente ASCII.
             MOV PAG0T[BX], " "                     ; Lo coloca en blanco.
             CMP AL, "$"                            ; Se llego al final
             JE CURSOR4                             ; Salta a arreglar el cursor.
             MOV PAG0T[BX], AL                      ; Guarda el caracter ASCII.
             INC BX
             LOOP BACK4
CURSOR4:     CMP COLUMNA, 0                         ; Determina si se está al inicio.
             JE SIGA4
             DEC COLUMNA
             JMP FN4
SIGA4:       CMP FILA, 2                            ; Compara que no se esté al inicio del doc.
             JE FN4
             DEC FILA                               ; Decrementa la fila
             MOV COLUMNA, 79                        ; vuelve la columna 79
FN4:         POPA                                   ; Regresa los registros
             RET
OP4          ENDP

; +-----------------------------------------------------------------+
; Procedimiento OP5:
; Permite borrar con BACKSPACE.

OP5          PROC NEAR
             PUSHA                                  ; Guarda los registros
             CMP COLUMNA, 0                         ; Determina si se está al inicio.
             JE SIGA5
             DEC COLUMNA                            ; Decrementa la columna.
             JMP CURSOR5
SIGA5:       CMP FILA, 2                            ; Compara que no se esté al inicio del doc.
             JE FIN5
             DEC FILA                               ; Decrementa la fila.
             MOV COLUMNA, 79                        ; Vuelve la columna 79
CURSOR5:     MOV BX, 0
             MOV BL, FILA                           ; Mueve la fila del cursor
             SUB BL, 2
             MOV AX, 80                             ; Determina las veces que se van a multiplicar
             MUL BX
             MOV BX,0                               ; Limpia BX
             MOV BL, COLUMNA                        ; Suma las columnas
             ADD BX, AX
             MOV CX, 1839                           ; Contador
BACK5:       MOV AL, PAG0T[BX+1]                    ; Mueve el caracter siguiente ASCII.
             MOV PAG0T[BX], " "                     ; Lo coloca en blanco.
             CMP AL, "$"                            ; Se llego al final
             JE FIN5                                ; Salta a arreglar el cursor.
             MOV PAG0T[BX], AL                      ; Guarda el caracter ASCII.
             INC BX
             LOOP BACK5
FIN5:        POPA                                   ; Regresa los registros
             RET
OP5          ENDP

; +-----------------------------------------------------------------+
; Procedimiento OP6:
; Permite mostrar un caracter ASCII.

OP6          PROC NEAR
             PUSHA                                  ; Guarda los registros.
IN6:         CMP COLUMNA, 79                        ; Revisa si ya se llegó al final de la columna.
             JE SIGA
             INC COLUMNA
             JMP FINAL2
SIGA:        CMP FILA, 24                           ; Compara si ya se llegó al final de la fila.
             JE CAMBPAG
             INC FILA                               ; Cambia de fila.
             MOV COLUMNA, 0                         ; Cambia de columna.
             JMP IN6
CAMBPAG:     CMP PAG, 3                             ; No realiza nada si se está al final.
             JE FN6
             CALL AVANZARPAG                        ; Avanza de página.
             JMP IN6                                ; Regresa al inicio.
FINAL2:      MOVIMIENTOS                            ; Realiza los movimientos necesarios.
             CMP INSTBAND, 0                        ; Revisa si la bandera de inserción está en true
             JE FIN6
             MOV CX, 1839                           ; Contador
             MOV AL, PAG0T[BX]
             MOV TEMP, AL                           ; Mueve el caracter ASCII.
BACK6:       MOV AL, TEMP                           ; Mueve el caracter siguiente ASCII.
             MOV AH, PAG0T[BX+1]                    ; Guarda el próximo caracter
             MOV TEMP, AH
             CMP AH, "$"                            ; Se llego al final
             JE FIN6                                ; Salta a arreglar el cursor.
             MOV PAG0T[BX+1], AL                    ; Guarda el caracter ASCII.
             INC BX
             LOOP BACK6
FIN6:        MOV BX, APUNTADOR                      ; Vuelve a obtener el valor de BX
             MOV AL, EXTENSION                      ; Mueve el caracter ASCII.
             MOV PAG0T[BX], AL                      ; Guarda el caracter ASCII.
             POPA                                   ; Recupera los registros
FN6:         RET
OP6          ENDP


; +-----------------------------------------------------------------+
; Procedimiento AVANZARPAG:
; Avanza una pagina.

AVANZARPAG   PROC NEAR
             PUSHA
             CALL GUARDARINFO                       ; Guarda el texto ingresado
             CMP PAG, 3                             ; Determina si se está en la pagina 3
             JE  TOPE                               ; Salta a TOPE
             JMP AUMENTARPAG                        ; Aumenta la página

TOPE:        MOV PAG,0                              ; Vuelve a regresar a la pag 0
             JMP APLICAR
AUMENTARPAG: INC PAG                                ; Incrementa la página

APLICAR:     CALL LLAMAR_PAG                        ; Llama al cambio de pagina
             MOV FILA,2                             ; Inicia en la fila 2
             MOV COLUMNA,0                          ; Inicia en la columna 0
             CURSOR PAG, FILA, COLUMNA              ; Fija el cursor
             CALL OBTENERINFO                       ; Obtiene el texto ya ingresado
             POPA
             RET
AVANZARPAG   ENDP

; +-----------------------------------------------------------------+
; Procedimiento REGRESARPAG:
; Avanza una pagina.

REGRESAPAG   PROC NEAR
             CALL GUARDARINFO                       ; Guarda el texto ya ingresado
             CMP PAG, 0                             ; Determina si llegó al inicio
             JE  TOPE2                              ; Salta al tope
             JMP AUMENTARPAG2                       ; Salta para aumentar la pagina

TOPE2:       MOV PAG,3                              ; Regresa a la pag 3
             JMP APLICAR2
AUMENTARPAG2:DEC PAG                                ; Decrementa la página.

APLICAR2:    CALL LLAMAR_PAG                        ; Cambia de página
             MOV FILA,2                             ; Inicia en la fila 2
             MOV COLUMNA,0                          ; Inicia en la columna 0
             CURSOR PAG, FILA, COLUMNA              ; Fija el cursor
             CALL OBTENERINFO                       ; Obtiene el texto ya ingresado.
             RET
REGRESAPAG   ENDP

; +-----------------------------------------------------------------+
; Procedimiento GUARDARINFO:
; Guarda el texto que se tiene en la página.

GUARDARINFO  PROC NEAR
             CMP PAG, 0                             ;Determina en que página se está.
             JE  P0
             CMP PAG, 1
             JE P1
             CMP PAG, 2
             JE P2
             CMP PAG, 3
             JE P3
P0:          CAMBIOPAG PAG0T, PAGINA0               ; Guarda la info.
             JMP FG
P1:          CAMBIOPAG PAG0T, PAGINA1
             JMP FG
P2:          CAMBIOPAG PAG0T, PAGINA2
             JMP FG
P3:          CAMBIOPAG PAG0T, PAGINA3
FG:          RET
GUARDARINFO  ENDP

; +-----------------------------------------------------------------+
; Procedimiento OTENERINFO:
; Obtiene el texto que se tiene en la página.

OBTENERINFO  PROC NEAR
             CMP PAG, 0                             ; Determina en que página se está.
             JE  P20
             CMP PAG, 1
             JE P21
             CMP PAG, 2
             JE P22
             CMP PAG, 3
             JE P23
P20:          CAMBIOPAG PAGINA0, PAG0T              ; Recupera la información.
             JMP FG2
P21:          CAMBIOPAG PAGINA1, PAG0T
             JMP FG2
P22:          CAMBIOPAG PAGINA2, PAG0T
             JMP FG2
P23:          CAMBIOPAG PAGINA3, PAG0T
FG2:          RET
OBTENERINFO   ENDP

; +-----------------------------------------------------------------+
; TABULADOR:
; Mueve el cursor 5 espacios.

TABULADOR    PROC NEAR
             PUSHA
             MOV AH,COLUMNA                         ; guardamos el valor de columna original
             ADD AH,5                               ; le suma a columna el tabulador.
             CMP FILA,24                            ; Compara si llego al final de la hoja
             JE FINAL1
             JMP COMPARAR
FINAL1:      CMP AH,79
             JA FINAL3                              ; Si llego al final de la hoja
             JMP RETORNAR                           ; si es menor
COMPARAR:    CMP AH,79                              ; Comparamos si se paso del tamaño de la hoja
             JA SIGFILA
             JMP RETORNAR                           ; no se paso del tamaño de la hoja seguir
SIGFILA:     SUB AH,79                              ; si se pasa de 79, le restamos 79 para ver cuanto se paso
             MOV AUX,AH                             ; guardamos el valor de la resta
             SUB AUX,1                              ; le restamos uno, ya que al colocarlo abajo contamos desde cero
             INC FILA                               ; le sumamos una a la fila
             MOV AH,AUX                             ; guardamos el nuevo valor de columna
             JMP RETORNAR
FINAL3:      MOV AH,79                              ; Se queda en la misma posicion
RETORNAR:    MOV COLUMNA,AH                         ; lo que sobro de columna, se lo colocamos abajo
             CURSOR PAG, FILA, COLUMNA
             POPA
             RET
TABULADOR    ENDP

; +-----------------------------------------------------------------+
; Procedimiento LLAMAR_PAG:
; Llama a la página donde se desplegará la información.
LLAMAR_PAG    PROC NEAR
              MOV  AH, 05H                          ; Llamar página
              MOV  AL, PAG                          ; Página
              INT  10H
              RET
LLAMAR_PAG    ENDP

; +-----------------------------------------------------------------+
; Procedimiento INGTECLA:
; Obtiene una respuesta del teclado sin eco (Marta Ligia).

INGTECLA     PROC NEAR
             PUSHA                                  ; Guarda el valor de los registros.
             MOV AH, 0CH                            ; Limpia buffer del teclado
             INT 21H
             MOV AH, 00H                            ; Entrada desde el teclado sin eco.
             INT 16H
             MOV TECLA, AH                          ; Guarda el valor del caracter ASCII.
             MOV EXTENSION, AL                      ; Guarda el valor de la extension.
             POPA                                   ; Recupera el valor de los registros
             RET
INGTECLA     ENDP

; +-----------------------------------------------------------------+
; Procedimiento TECLADO:
; Verifica la opción que ingreso el usuario.

TECLADO      PROC NEAR
             PUSHA
             CALL INGTECLA
SEGUIR:      CMP EXTENSION, 0                       ; ¿Se presiono tecla de función?
             JNE ING2	                            ; no, ir a la segunda verificación
             CMP TECLA, 3BH	                    ; presiono F1
             JE OPCIONF1
             CMP TECLA, 3CH                         ; Presiono F2
             JE OPCIONF2
             CMP TECLA, 3DH	                    ; presiono F3
             JE OPCIONF3
             CMP TECLA, 3EH                         ; Presiono F4
             JE OPCIONF4
             JMP ING2

OPCIONF1:    CALL MARCHIVO                          ; Llama al menu de las opciones
             JMP FIN
OPCIONF2:    CALL MEDICION
             JMP FIN
OPCIONF3:    CALL MFORMATO
             JMP FIN
OPCIONF4:    CALL MAYUDA
             JMP FIN
ING2:        CALL INGRESO2
             JMP FIN

USOMOUSE1:   MOV TECLA,3BH
             MOV EXTENSION,00H
             CALL CONTROLMOUSE                          ; Procedimiento para verificar en que parte de la pantalla se dio click

FIN:         POPA
             RET
TECLADO      ENDP


; +-----------------------------------------------------------------+
; Procedimiento USOMOUSE:
; Verifica en que parte de la pantalla se dio click.
CLICHOJA     PROC NEAR

             CMP  POSX,0       ;verificar si dio clic en la hoja
             JAE  NLATERAL1
             JMP  CUADRO1      ;Dio clic en el menu
NLATERAL1:   CMP  POSX,640
             JBE  NSUPERIOR1
             JMP  CUADRO1
NSUPERIOR1:  CMP  POSY,16
             JAE  NSUPERIOR2
             JMP  CUADRO1
NSUPERIOR2:  CMP  POSY, 200
             JBE  HOJA     ; si fue hoja
             JMP  CUADRO1
             RET
CLICHOJA     ENDP


;---------------------------------------------------------------------+
; Procedimiento CLICARCHIVO:
; Se verifica si se dio clic en archivo.
;

CLICARCHIVO  PROC NEAR

             CMP  POSX,40                          ; Compara posicione en x
             JAE  ILATERAL1
             JMP  CUADRO2
ILATERAL1:   CMP  POSX,88
             JBE  ISUPERIOR1
             JMP  CUADRO2
ISUPERIOR1:  CMP  POSY,0                          ; Primera fila
             JE   INFO                            ; Si fue Archivo
             JMP  CUADRO2                         ; No fue archivo, verifica si fue edicion.
             RET
CLICARCHIVO  ENDP

;---------------------------------------------------------------------+
; Procedimiento CLICEDITAR:
; Se verifica si se dio clic en editar.
;
CLICEDITAR   PROC NEAR
             CMP  POSX,144
             JAE  SLATERAL1
             JMP  CUADRO3
SLATERAL1:   CMP  POSX,192
             JBE  SSUPERIOR1
             JMP  CUADRO3
SSUPERIOR1:  CMP  POSY,0
             JE   SIEDITAR
             JMP  CUADRO3                             ;Si no se dio click en ninguno de estos rangos, espera a que de mas clics.
             RET
CLICEDITAR   ENDP

CLICFORMATO PROC NEAR
             CMP  POSX,272
             JAE  SLATERALL
             JMP  CUADRO4
SLATERALL:   CMP  POSX,296
             JBE  SSUPERIORR
             JMP  CUADRO4
SSUPERIORR:  CMP  POSY,0
             JE   SIFORMATO
             JMP  CUADRO4

            RET
CLICFORMATO ENDP

CLICAYUDA    PROC NEAR

             CMP  POSX,360
             JAE  SLATERA
             JMP  NADA
SLATERA:     CMP  POSX,392
             JBE  SSUPERIO
             JMP  NADA
SSUPERIO:    CMP  POSY,0
             JE   SIAYUDA

NADA:        RET
CLICAYUDA    ENDP

;---------------------------------------------------------------------+
; Procedimiento CAMBIARCURSOR:
; Cambia el cursor cuando dan clic

CAMBIARCURSOR PROC NEAR

              PUSHA
              XOR AX,AX
              MOV DIVIDIR,8
              MOV DX,POSY
              DIV DIVIDIR
              MOV FILA,AH


              XOR AX,AX
              MOV DX,POSX
              DIV DIVIDIR
              MOV COLUMNA,AH

              CURSOR PAG, FILA,COLUMNA

              POPA
              RET
CAMBIARCURSOR ENDP


;---------------------------------------------------------------------+
; Procedimiento CARCHIVO:
; Realizar el proceso debido al dar clic en archivo

CARCHIVO PROC NEAR

         CALL MARCHIVO

         RET
CARCHIVO ENDP

;---------------------------------------------------------------------+
; Procedimiento CEDITAR:
; Realizar el proceso debido al dar clic en editar

CEDITAR PROC NEAR

         RET
CEDITAR ENDP


;---------------------------------------------------------------------+
; Procedimiento CFORMATO:
; Realizar el proceso debido al dar clic en formato

CFORMATO PROC NEAR


         RET
CFORMATO ENDP


;---------------------------------------------------------------------+
; Procedimiento CAYUDA:
; Realizar el proceso debido al dar clic en ayuda.

CAYUDA PROC NEAR


       RET
CAYUDA ENDP


;---------------------------------------------------------------------+
; Procedimiento CONTROLMOUSE:
; Verifica en donde se dio clic

CONTROLMOUSE PROC NEAR

             CALL CLICHOJA                     ; Procedimiento para verificar si dio clic en la hoja.

CUADRO1:     CALL CLICARCHIVO                  ; Verificar si dio clic en Archivo.
CUADRO2:     CALL CLICEDITAR                   ; Verificar si dio en Editar.
CUADRO3:     CALL CLICFORMATO
CUADRO4:     CALL CLICAYUDA
             JMP  REGRESMEN                    ; NO dio clic en MENU ni HOJA
HOJA:        CALL CAMBIARCURSOR                ; Si clic en HOJA.
             JMP  REGRESMEN
INFO:        CALL CARCHIVO                     ; Si clic en ARCHIVO
             JMP  REGRESMEN
SIEDITAR:
             CALL CEDITAR                      ; Si clic en EDITAR
             JMP  REGRESMEN
SIFORMATO:   CALL CFORMATO                     ; Si clic en FORMATO
             JMP  REGRESMEN
SIAYUDA:     CALL CAYUDA                       ; Si clic en AYUDA

REGRESMEN:
             RET                               ;No dio clic ni en hoja ni en menu
CONTROLMOUSE ENDP
; +-----------------------------------------------------------------+
; Procedimiento INGRESO2:
; Determina que tecla se ingreso.

INGRESO2     PROC NEAR
             CMP TECLA, 47H                         ; Comprueba si se quiere ir al inicio de la columna.
             JE  OPCION9                            ; Salta a la opcion 9.
             CMP TECLA, 4FH                         ; Comprueba si se quiere ir al final de la columna.
             JE  OPCION10                           ; Salta a la opcion 10.
             CMP TECLA, 1CH                         ; Determina si se quiere dar un enter
             JE  OPCION7                            ; Salta a la opcion 7.
             CMP TECLA, 49H                         ; Comprueba si se quiere avanzar una pagina.
             JE  OPCION1_1                          ; Salta a la opcion 1.1
             CMP TECLA, 51H                         ; Comprueba si se quiere regresar una pagina.
             JE  OPCION1_2                          ; Salta a la opcion 1.2
             JMP ING3                               ; Salta para seguir verificando.
OPCION1_1:   CALL AVANZARPAG                        ; Avanza a la siguiente página.
             JMP FN
OPCION1_2:   CALL REGRESAPAG                        ; Regresa a la página anterior.
             JMP FN
OPCION2:     CALL OP2                               ; Opciones para flechas.
             JMP FN
OPCION7:     CMP FILA, 24                           ; Da un enter.
             JE FN
             INC FILA
             MOV COLUMNA, 0
             CURSOR PAG, FILA, COLUMNA              ; Da un enter.
             JMP FN
OPCION9:     MOV COLUMNA,0                          ; Coloca el cursor en la primera columna.
             JMP FN
OPCION10:    MOV COLUMNA, 79                        ; Coloca el cursor en la última columna.
             JMP FN
ING3:        CALL INGRESO3                          ; Sigue verificando.
FN:          RET
INGRESO2     ENDP

; +-----------------------------------------------------------------+
; Procedimiento INGRESO3:
; Determina que tecla se ingreso.

INGRESO3     PROC NEAR

             CMP TECLA, 0FH                         ; Presiono tabulador
             JE  OPCION8                            ; Salta a la opcion 8.
             CMP TECLA, 52H                         ; Presiono INS
             JE OPCION3                             ; Salta a laopción 3.
             CMP TECLA, 53H                         ; Determina si es un del
             JE OPCION4                             ; Salta a la opcion 4
             CMP EXTENSION, 08H                     ; Determina si es un backspace
             JE OPCION5                             ; Salta a la opcion 5
             CMP EXTENSION, 00H                     ; Determina si se ingreso un caracter ASCII.
             JE OPCION2
OPCION6:     CALL OP6                               ; Permite el ingreso de un caracter.
             JMP FN2
OPCION8:     CALL TABULADOR                         ; Realiza un tabulado.
             JMP FN2
OPCION3:     CALL OP3                               ; Quita o pone inserción.
             JMP FN2
OPCION4:     CALL OP4                               ; Borra un caracter con del.
             JMP FN2
OPCION5:     CALL OP5                               ; Borra un caracter con backspace.

FN2:         RET
INGRESO3     ENDP

; +-----------------------------------------------------------------+
; Procedimiento OUTC: (Marta Ligia)}
; Muestra un caracter en la pantalla.

OUTC         PROC NEAR

             MOV AH, 02H                            ; Peticion para desplegar
             INT 21H                                ; Llama al DOS
             RET

OUTC         ENDP

; +-----------------------------------------------------------------+
; Procedimiento ABRIR (Marta Ligia)
; Abre el archivo.

ABRIR	     PROC NEAR
             ABRIR_A NOMBRE
	     JC	FALLO		                    ; SI HAY ERROR, SALE
	     DESP EXITO
	     MOV DX,MANEJ	                    ; GUARDA EN DL MANEJADOR DE ARCHIVO PARA DESPLIEGUE
	     ADD DL, 30H		            ; CONVIERTE A ASCII
	     MOV AH, 02H		            ; PETICION DE DESPLIEGUE DE UN CARACTER
	     INT 21H
	     DESP MENS
             CALL INGTECLA                          ; Tecla de confirmación
             CALL LEERTODO                          ; Lee el archivo
	     JMP FN1

FALLO:       DESP ERROR                             ; Muestra mensaje de error
             DESP MENS
             CALL INGTECLA                          ; Tecla de confirmación

FN1:         RET
ABRIR	     ENDP

; +-----------------------------------------------------------------+
; Procedimiento CERRAR (Marta Ligia)
; Cierra el archivo.

CERRAR	     PROC NEAR
             CERRAR_A MANEJ
	     JC	FALLO2		                    ; SI HAY ERROR, SALE
	     DESP EXITO2
	     MOV DX,MANEJ	                    ; GUARDA EN DL MANEJADOR DE ARCHIVO PARA DESPLIEGUE
	     ADD DL, 30H		            ; CONVIERTE A ASCII
	     MOV AH, 02H		            ; PETICION DE DESPLIEGUE DE UN CARACTER
	     INT 21H
             JMP FN12

FALLO2:
	     DESP ERROR2

FN12:        RET
CERRAR	     ENDP

; +-----------------------------------------------------------------+
; Procedimiento LEERTODO (Marta Ligia)
; Lee todo el archivo.

LEERTODO     PROC NEAR

             MOV N_BYTES, 0                         ; Se contará el número de bytes
REPLEER:
             MOV_APUN MANEJ, 00H                    ; Va cambiando el apuntado
             LEER_A MANEJ                           ; lee un artículo
	     CMP AX, 00                             ; Determina si se llegó al final
	     JE FIINL
             JC ERROR1L		                    ; prueba por error
             CALL AVANZARPAG                        ; Avanza una pagina
             ADD N_BYTES, 1839                      ; Le suma para la siguiente
             CMP PAG, 3                             ; Revisa que no este en la última página
             JE ERROR2L
             JMP REPLEER                            ; Vuelve a leer

             JMP FIINL

ERROR1L:     DESP ERROR_L1                          ; Muestra mensaje de ERROR
	     DESP MENS
             CALL INGTECLA
	     JMP FIINL2
ERROR2L:     DESP ERROR_L2                          ; Muestra mensaje de ERROR
             DESP MENS
             CALL INGTECLA
             JMP FIINL2
FIINL:       CALL CLEAR                             ; Limpia la pantalla
             CALL MMENU                             ; Muestra el menu
             CURSOR PAG, 15, 10                     ; Coloca el cursor
             DESP EXITO_L                           ; Despliega mensaje de exito
	     DESP MENS
             CALL INGTECLA                          ; Permite ingresar una tecla.
FIINL2:      MOV N_BYTES, 0                         ; Se contará el número de bytes
             RET
LEERTODO     ENDP



; +-------------+
; | MOUSE       |
; +-------------+



;---------------------------------------------------------------------+
; Procedimiento MODOMOUSE:
; Muestra el mouse en una posicion específica.

MODOMOUSE    PROC NEAR
             PUSHA

             MOV AX, 01H                            ;funcion para mostrar el mouse
             INT 33H

             POPA
             RET
MODOMOUSE    ENDP

;---------------------------------------------------------------------+
; Procedimiento OCULTARMOUSE:
; Oculta el mouse.

OCULTARMOUSE  PROC NEAR
              PUSHA
              MOV AX,02H
              INT 33H
              POPA
              RET
OCULTARMOUSE  ENDP

;---------------------------------------------------------------------+
; Procedimiento MOSTRARMOUSE:
; Muestra el mouse.
MOSTRARMOUSE  PROC NEAR
              PUSHA
              MOV AX,01H
              INT 33H
              POPA
              RET
MOSTRARMOUSE  ENDP

;---------------------------------------------------------------------+
; Procedimiento CLIC:
; Obtiene el estado del ratón y la posición del puntero.

CLIC  PROC NEAR

      MOV AX,03H                                    ;funcion para obetener la posicion del puntero.
      INT 33H

      MOV ESTADOBOTON, BX                           ;Se activa el bit del boton presionado
      MOV POSX, CX                                  ;Se carga la coordenada horizontal
      MOV POSY, DX                                 ;Se carga la coordenada vertical.

      RET
CLIC  ENDP

;---------------------------------------------------------------------+
; Procedimiento PRESIONAR:
; Obtiene el estado del boton izquierdo al presinarlo.

PRESIONAR    PROC NEAR
             PUSHA
             MOV BX,00H                             ;parametro: boton izquierdo
             MOV AX,05H                             ;peticion para obtener estado del boton parametro.
             INT 33H
             MOV POSX, CX                           ;coordenada horizontal
             MOV POSY, DX
             MOV VECESCLIC, BX                      ;se guarda la cantidad de veces que se ha presionado ese boton.
             POPA
             RET
PRESIONAR    ENDP

;---------------------------------------------------------------------+
; Procedimiento PRESIONAR2:
; Peticion para obetenr la posicion y estado del puntero.

PRESIONAR2    PROC NEAR

              MOV AX,03H
              INT 33H

              RET
PRESIONAR2    ENDP


;---------------------------------------------------------------------+
; Procedimiento INICIARATON:
; Inicializa el raton y lo muestra.

INICIARATON  PROC NEAR
             PUSHA
             MOV AX, 00H                            ;Inicializar ratón
             INT 33H
             CALL MODOMOUSE                         ; Mostrar ratón
             POPA
             RET
INICIARATON  ENDP


; +-----------------------------------------------------------------+
; Programa Principal:

BEGIN        PROC FAR

             INITZ                                  ; Llamada a la macro para inicializar segmento de datos.
             MOD_VIDEO                              ; Coloca el modo de video.


A10:
             CALL INICIARATON
             CALL OCULTARMOUSE                      ; Oculta el mouse
             CALL MMENU                             ; Muestra el menu.
             CALL MOSTRARMOUSE
             CURSOR PAG, 2,0
             DESP PAG0T                             ; Muestra la cadena.
             CURSOR PAG, FILA, COLUMNA              ; Fija el cursor


             CALL TECLADO                           ; Permite el ingreso de una tecla.
             CMP TECLA, 1                           ; Compara si presionó ESC
             JNE A10
             CALL CLEAR                             ; Limpia
             MOV AX,4C00H			    ; salida a DOS
             INT 21H                                ; Determina que si se quiere salir

BEGIN        ENDP
             END BEGIN






