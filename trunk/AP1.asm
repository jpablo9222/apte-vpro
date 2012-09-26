; Universidad del Valle de Guatemala
; Taller de Assembler
; Oscar Castañeda 	11086
; Benito Maza 		11088
; Jonathan López 	11106

TITLE	Seleccion de opcion de menu
.MODEL SMALL
.STACK 64
; Programa tomado de libro: IBM PC Assembly Language and Programming
; Fifth Edition. Autor: Peter Abel
; Capítulo 10
; ----------------------------------------------------------------------
.DATA
TOPROW	EQU	08							; Fila superior menu
BOTROW	EQU	15							; fila inferior menu
LEFCOL	EQU	26							; Columna izquierda menu
ATTRIB	DB	?							; Atributo de pantalla
ROW	DB	?								; Fila pantalla
INGRESO	DB	?							; Guarda tecla ingresada
SHADOW	DB	19	DUP(0DBH)				; Caracteres de sombreado
MENU	DB	0C9H, 17 DUP(0CDH), 0BBH	; Dibuja menu
	DB	0BAH, ' Add records     ', 0BAH
	DB	0BAH, ' Delete records  ', 0BAH
	DB	0BAH, ' Enter orders    ', 0BAH
	DB	0BAH, ' Print report    ', 0BAH
	DB	0BAH, ' Update accounts ', 0BAH
	DB	0BAH, ' View records    ', 0BAH
	DB	0C8H, 17 DUP(0CDH), 0BCH
PROMPT	DB	'To select an item, use <Up/Down Arrow>'
        DB	' and press <Enter>.'
        DB	13, 10, 'To exit a selected option, press any key. Press <Esc> to exit the program.'
MSJ_I   DB      "Presione F5 para ver el menu de opciones"
MSJ_A   DB      "  PROCEDIMIENTO ADD RECORDS  "
MSJ_D   DB      "PROCEDIMIENTO DELETE RECORDS "
MSJ_E   DB      " PROCEDIMIENTO ENTER ORDERS  "
MSJ_P   DB      " PROCEDIMIENTO PRINT REPORT  "
MSJ_U   DB      "PROCEDIMIENTO UPDATE ACCOUNTS"
MSJ_V   DB      " PROCEDIMIENTO VIEW RECORDS  "
.386	; directiva que permite uso de instrucciones como PUSHA,POPA,MOVZX
; ----------------------------------------------------------------------
.CODE
MAIN	PROC	FAR
        MOV 	AX, @data				; inicializar segmento de datos
        MOV 	DS, AX
        MOV 	ES, AX
		CALL 	Q10CLEAR				; Limpiar pantalla
		MOV 	ROW, BOTROW+4			; Fijar la fila
A10:    CALL    MSJ_INI                 ;Se despliega un mensaje inicial.
        CALL    C10INPUT_I              ;Se recibe un ingreso de teclado.
        CMP     INGRESO, 1BH            ;Si es ESC, se sale del programa.
        JE      FIN
        CMP     INGRESO, 3FH            ;Mientras la tecla no sea F5, se continúa mostrando el mensaje.
        JNE     A10
A20:    CALL    Q10CLEAR                ; Se limpia la pantalla.
        CALL 	B10MENU					; Desplegar menu
        MOV 	ROW, TOPROW+1			; Fijar la fila en la primera opcion
        MOV 	ATTRIB, 17H				; fijar video inverso
        CALL 	D10DISPLY				; resaltar linea actual
        CALL 	C10INPUT				; leer opcion de menu
        CMP		INGRESO, 1BH			;  presiono esc?
        JNE		A20						; no, continuar
FIN:    MOV	AX, 0600H					; si, terminar
        CALL	Q10CLEAR				; limpiar pantalla
        MOV	AX, 4C00H					; salir a DOS
        INT	21H
MAIN	ENDP
; ----------------------------------------------------------------------
;
; ----------------------------------------------------------------------

MSJ_INI PROC NEAR
        PUSHA
        LEA     BP, MSJ_I           ;Se carga el prompt inicial.
       	MOV	BX, 005FH				; Se coloca la página y el atributo: azul sobre blanco
		MOV	AX, 1301H				; Se prepara la función para mostrar la cadena.
        MOV	CX, 40					; longitud de la linea
        MOV     DX, 0               ; El mensaje se coloca en la primera fila y columna.
        INT     10H                 ;Se activa la interrupción, mostrando la cadena en pantalla.
        POPA
        RET
MSJ_INI ENDP

;Se debe cargar en BP antes el mensaje a mostrar, el cual debe de tener una longitud de
MSJ_PRO PROC NEAR
        PUSHA
       	MOV	BX, 005FH				; Se coloca la página y el atributo: azul sobre blanco
		MOV	AX, 1300H				; Se prepara la función para mostrar la cadena.
        MOV	CX, 29					; longitud de la linea
        MOV     DH, 04              ; El mensaje se coloca en la cuarta fila
        MOV     DL, 25              ; y columna 25.
        INT     10H                 ;Se activa la interrupción, mostrando la cadena en pantalla.
        POPA
        RET
MSJ_PRO ENDP

B10MENU	PROC NEAR
        PUSHA						; guardar todos los registros
        MOV	DH, TOPROW+1			; fila superior de sombra
B20:	MOV	AX, 1301H				; dibujar caja sombreada
        MOV	BX, 0060H				; pagina y atributo
        LEA	BP, SHADOW				; caracteres sombreados
        MOV	CX, 19					; 19 caracteres
        MOV	DL, LEFCOL+1			; columna izq de sombra
        INT	10H
        INC	DH						; siguiente fila
        CMP	DH, BOTROW+2			; se desplegaron todas las columnas?
        JNE	B20						; no, repetir

        LEA	BP, MENU				; linea del menu
        MOV	DH, TOPROW				; fila
B30:
		MOV	BX, 0071H				; pagina y atributo: azul sobre blanco
		MOV	AX, 1300H				; solicitar menu de despliegue
        MOV	CX, 19					; longitud de la linea
		MOV	DL, LEFCOL					; columna
		PUSH	DX					; guarda el registro que contiene fila, columna
		INT 	10H
		ADD	BP, 19					; siguiente linea del menu
		POP	DX						; recupera registro con fila, columna
		INC	DH						; siguiente fila
		CMP	DH, BOTROW+1			; se mostraron todas las filas?
		JNE	B30						; no, repetir

        MOV 	AX, 1301H			; desplegar prompt
        MOV	BX, 0071H				; pagina y atributo
        LEA	BP, PROMPT				; linea de prompt
        MOV	CX, 133					; longitud de linea
        MOV	DH, BOTROW+4			; fila y
        MOV	DL, 00					; columna de pantalla
        INT	10H
        POPA						; recuperar registros
        RET
B10MENU	ENDP
; ----------------------------------------------------------------------
;
; ----------------------------------------------------------------------
C10INPUT_I PROC NEAR
           PUSHA
           MOV    AH, 10H           ;Se recibe un ingreso del teclado.
           INT    16H
           CMP    AH, 3FH           ; código de rastreo de F5?
           JNE    C10               ;Si no es F5, se sigue.
           MOV    AL, AH            ;Para almacenar el código de rastreo de F5.
C10:       MOV	  INGRESO, AL
           POPA						; recuperar registros
           RET
C10INPUT_I ENDP

C10INPUT PROC NEAR
        PUSHA						; guardar registros
C20:	MOV	AH, 10H					; leer caracter de teclado
        INT	16H
        CMP	AH, 50H					; cod rastreo flecha abajo?
        JE	C30
        CMP	AH, 48H					; cod rastreo flecha arriba?
        JE	C40
        CMP	AL, 0DH					; ascii enter?
        JE	C100

        CMP	AL, 1BH					; ascii esc?
        JE	C90
        JMP	C20
C30:	MOV	INGRESO, AL
        MOV	ATTRIB, 71H				; flecha-abajo, azul sobre blanco
        CALL	D10DISPLY			; regresar linea ant a video normal
        INC	ROW						; fila siguiente
        CMP	ROW, BOTROW-1			; se paso de la ultima fila?
        JBE	C50						; no, ok
		MOV		ROW, TOPROW+1		; si, iniciar fila
		JMP		C50
C40:	MOV		INGRESO, AL
		MOV 	ATTRIB, 71H			; flecha-arriba, azul sobre blanco
		CALL	D10DISPLY			; regresar linea ant a video normal
		DEC		ROW					; fila anterior
		CMP		ROW, TOPROW+1		; se paso de la primera fila?
		JAE		C50					; no, ok
		MOV		ROW, BOTROW-1		; si, iniciar fila

C50:	MOV		INGRESO, AL
		MOV		ATTRIB, 17H			; blanco sobre azul
		CALL 	D10DISPLY			; fijar linea nueva a video inverso
		JMP		C20
C100:   MOV    	ATTRIB, 75H
        CALL   	D10DISPLY
        CALL   	OUT_M
C90:
		MOV		INGRESO, AL
		POPA						; recuperar registros
		RET
C10INPUT ENDP
; ----------------------------------------------------------------------
;
; ----------------------------------------------------------------------
D10DISPLY PROC NEAR
        PUSHA							; guardar registros
        MOVZX	AX, ROW					; la fila indica que linea fijar
        SUB	AX, TOPROW
        IMUL	AX, 19					; multiplicar por longitud de linea
        LEA	SI, MENU+1					; para seleccionar fila del menu
        ADD	SI, AX

        MOV	AX, 1300H					; solicita despliegue
        MOVZX	BX, ATTRIB				; pagina y atributo
        MOV	BP, SI						; caracter de cadena menu
        MOV	CX, 17						; longitud de cadena menu
        MOV	DH, ROW						; fila
        MOV	DL, LEFCOL+1				; columna
        INT	10H
        POPA							; recuperar registros
        RET
D10DISPLY ENDP

OUT_M   PROC NEAR
        PUSHA							; guardar registros
        MOVZX	AX, ROW					; la fila indica que linea se seleccionó.
        SUB	AX, TOPROW
        DEC   AX
        IMUL	AX, 29					; multiplicar por longitud de linea
        LEA	SI, MSJ_A					; para seleccionar mensaje correspondiente
        ADD	SI, AX
        MOV   BP, SI
        CALL  MSJ_PRO
        MOV   AH, 10H                 	;Se espera una tecla cualquiera para continuar.
        INT   16H
        POPA							; recuperar registros
        RET
OUT_M   ENDP
; ----------------------------------------------------------------------
; hola mundo.
; ----------------------------------------------------------------------
Q10CLEAR PROC
        PUSHA							; guardar registros
        MOV		AX, 0600H
        MOV		BH, 2FH					; blanco sobre verde
        MOV		CX, 0000H				; pantalla completa
        MOV		DX, 184FH				; fila 24, col 79
        INT		10H
        POPA							; recuperar registros
        RET
Q10CLEAR ENDP
; ----------------------------------------------------------------------
END MAIN
