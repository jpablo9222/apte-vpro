; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 9 de Octubre del 2009
; Fecha de ultima modificacion: 27 de Septiembre de 2011
; CC-4010 Taller de Assembler
; archivo4.asm: abrir y leer desde un archivo con procesamiento directo
; **********************************************************************************
MOV_APUN MACRO MANEJADOR
	MOV AH, 42H			; Peticion para mover el apuntador
	MOV	AL, 00H			; 00: inicio, 01: pos actual 02: fin archivo
	mov	BX, MANEJADOR	; MANEJADOR
	MOV CX, 00H			;
	MOV	DX, 1000 		; DESPLAZAMIENTO DE n BYTES
	INT 21H
	ENDM
; **********************************************************************************
DESP	MACRO CADENA
	MOV AH, 09H		; DESPLEGAR MENSAJE
	LEA DX, CADENA
	INT 21H
	ENDM
; **********************************************************************************
ABRIR_A	MACRO NOM_ARCHIVO
	MOV AH, 3DH			; petición
	MOV AL, 00H			; 00: modo sólo lectura, 01: solo escritura, 02: lect/escr
	LEA DX, NOM_ARCHIVO	; cadena ASCIIZ
	INT	21H
	MOV	MANEJ, AX		; guardar el manejador
	ENDM
; **********************************************************************************
LEER_A	MACRO MANEJADOR
	MOV	AH, 3FH			; petición
	MOV BX, MANEJADOR	; manejador
	MOV CX, 300		; longitud del registro
	LEA	DX, DATOS		; registro donde se leen datos
	INT 21H
	ENDM
; **********************************************************************************
	.MODEL SMALL
	.STACK 64
; **********************************************************************************
; Area de datos
	.DATA
NOMBRE		DB	'archivo1.asm',00h
MANEJ		DW	?
EXITO		DB	'El archivo se abrio exitosamente. Manejador: $'
ERROR		DB	'No pudo abrirse el archivo$'
EXITO_L		DB	0DH,0AH,'El archivo se leyo exitosamente.',0DH,0AH,'$'
ERROR_L1	DB	'No pudo leerse del archivo$'
ERROR_L2	DB	'No se realizo la lectura completa del archivo$'

EXITO_M		DB	0DH,0AH,'El apuntador de archivo se movio exitosamente.$'
ERROR_M		DB	0DH,0AH,'No se realizo el movimiento del apuntador.$'
DATOS		DB	300 DUP(' ')	; datos que se leen del archivo
MENS		DB 	0DH,0AH,'# de bytes leidos: '
N_BYTES		DW	?
FIN			DB	'$'
; **********************************************************************************
; Programa principal
	.CODE
BEGIN 	PROC FAR
	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	
	; ABRIR EL ARCHIVO
	ABRIR_A NOMBRE
	JC FALLO		; SI HAY ERROR, SALE
	DESP EXITO
	MOV DX, MANEJ	; GUARDA EN DL MANEJADOR DE ARCHIVO PARA DESPLIEGUE
	ADD DL, 30H		; CONVIERTE A ASCII
	MOV AH, 02H		; PETICION DE DESPLIEGUE DE UN CARACTER
	INT 21H
	
    MOV_APUN MANEJ
	    
	JC FALLO_M			; SI HAY ERROR, SALE
	DESP EXITO_M
	
	; LEER DESDE EL ARCHIVO
	LEER_A MANEJ
	JC error1		; prueba por error
	CMP AX, 00		; en AX retorna el numero de bytes leídos
	JE error2
	MOV N_BYTES, AX	; guarda numero de bytes leidos
	DESP EXITO_L
	ADD N_BYTES,30H
	DESP DATOS
	JMP SALIR
error1:
	DESP ERROR_L1
	JMP SALIR
error2:
	DESP ERROR_L2
	JMP SALIR
FALLO:
	DESP ERROR
	JMP SALIR
FALLO_M:
	DESP ERROR_M
SALIR:	
	MOV AX, 4C00H	; salir a DOS
	INT 21H
BEGIN	ENDP
		END BEGIN
