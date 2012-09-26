; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 9 de Octubre del 2009
; Fecha de ultima modificacion: 27 de Septiembre de 2011
; CC-4010 Taller de Assembler
; archivo3.asm: abrir y leer desde un archivo
; **********************************************************************************
DESP	MACRO CADENA
	MOV AH, 09H		; DESPLEGAR MENSAJE
	LEA DX, CADENA
	INT 21H
	ENDM
; **********************************************************************************
ABRIR_A	MACRO NOM_ARCHIVO
	MOV AH, 3DH			; petici�n
	MOV AL, 00H			; modo s�lo lectura
	LEA DX, NOM_ARCHIVO	; cadena ASCIIZ
	INT	21H
	MOV	MANEJ, AX		; guardar el manejador
	ENDM
; **********************************************************************************
LEER_A	MACRO MANEJADOR
	MOV	AH, 3FH			; petici�n
	MOV BX, MANEJADOR	; manejador
	MOV CX, 500			; longitud del registro
	LEA	DX, DATOS		; registro donde se leen datos
	INT 21H
	ENDM
; **********************************************************************************
	.MODEL SMALL
	.STACK 64
; **********************************************************************************
; Area de datos
	.DATA
NOMBRE		DB	'archivo3.asm',00h
MANEJ		DW	?
EXITO		DB	'El archivo se abrio exitosamente. Manejador: $'
ERROR		DB	'No pudo abrirse el archivo$'
EXITO_L		DB	0DH,0AH,'El archivo se leyo exitosamente.$'
ERROR_L1	DB	'No pudo leerse del archivo$'
ERROR_L2	DB	'No se realizo la lectura completa del archivo$'
DATOS		DB	500 DUP(' ')	; datos que se leen del archivo
FIN			DB	'$'
ENTERR      DB  0DH,0AH, '$'
; **********************************************************************************
; Programa principal
	.CODE
BEGIN 	PROC FAR
	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	
	; ABRIR EL ARCHIVO
	ABRIR_A NOMBRE
	JC	FALLO		; SI HAY ERROR, SALE
	DESP EXITO
	MOV DX,MANEJ	; GUARDA EN DL MANEJADOR DE ARCHIVO PARA DESPLIEGUE
	ADD DL, 30H		; CONVIERTE A ASCII
	MOV AH, 02H		; PETICION DE DESPLIEGUE DE UN CARACTER
	INT 21H
	
	; LEER DESDE EL ARCHIVO
	LEER_A MANEJ
	JC 	error1		; prueba por error
	CMP AX, 00		; en AX retorna el numero de bytes le�dos
	JE	error2
	DESP EXITO_L
    DESP ENTERR
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
SALIR:	
	MOV AX, 4C00H	; salir a DOS
	INT 21H
BEGIN	ENDP
		END BEGIN
