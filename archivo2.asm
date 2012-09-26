; **********************************************************************************
; Autor: Martha Ligia Naranjo
; Fecha de creacion: 9 de Octubre del 2009
; Fecha de ultima modificacion: 27 de Septiembre de 2011
; CC-4010 Taller de Assembler
; archivo2.asm: Crear y escribir en un archivo
; **********************************************************************************
DESP	MACRO CADENA
	MOV AH, 09H		; DESPLEGAR MENSAJE
	LEA DX, CADENA
	INT 21H
	ENDM
; **********************************************************************************
CREAR_A	MACRO NOM_ARCHIVO
	MOV	AH, 3CH			; PETICION
	MOV	CX, 00			; ATRIBUTO NORMAL
	LEA DX, NOM_ARCHIVO	; CADENA ASCIIZ
	INT 21H				; LLAMA AL DOS
	MOV	MANEJ, AX		; GUARDA EL MANEJADOR
	ENDM
; **********************************************************************************
ESCRIBIR_A	MACRO MANEJADOR, DATOS
	MOV AH, 40H			; petición para escribir
	MOV	BX, MANEJADOR	; manejador de archivo
	MOV CX, 25			; longitud del registro
	LEA	DX, DATOS		; dirección del área de datos
	INT	21H				; llama al DOS
	ENDM
; **********************************************************************************
	.MODEL SMALL
	.STACK 64
; **********************************************************************************
; Area de datos
	.DATA
NOMBRE		DB	'sec10.asm',00h
MANEJ		DW	?
EXITO		DB	'El archivo se creo exitosamente. Manejador: $'
ERROR		DB	'No pudo crearse el archivo$'
EXITO_E		DB	0DH,0AH,'El archivo se escribio exitosamente.$'
ERROR_E1	DB	'No pudo escribirse en el archivo$'
ERROR_E2	DB	'No se realizo la escritura completa en el archivo$'
DATOS		DB	23 DUP('*'),0dh,0ah	; datos que se escriben en el archivo
DATOS1		DB	23 DUP('#'),0dh,0ah
; **********************************************************************************
; Programa principal
	.CODE
BEGIN 	PROC FAR
	MOV AX, @DATA           ; inicializar area de datos
	MOV DS, AX
	
	; CREAR EL ARCHIVO
	CREAR_A NOMBRE
	JC	FALLO		; SI HAY ERROR, SALE
	DESP EXITO
	MOV DX,MANEJ	; GUARDA EN DL MANEJADOR DE ARCHIVO PARA DESPLIEGUE
	ADD DL, 30H		; CONVIERTE A ASCII
	MOV AH, 02H		; PETICION DE DESPLIEGUE DE UN CARACTER
	INT 21H
	
	; ESCRIBIR EN EL ARCHIVO
	ESCRIBIR_A MANEJ, DATOS
	ESCRIBIR_A MANEJ, DATOS1
	JC	error1		; prueba por error
	CMP	AX, 25		; ¿se escribieron todos los bytes?
	JNE	error2
	DESP EXITO_E
	JMP SALIR
error1:
	DESP ERROR_E1
	JMP SALIR
error2:
	DESP ERROR_E2
	JMP SALIR
FALLO:
	DESP ERROR
SALIR:	
	MOV AX, 4C00H	; salir a DOS
	INT 21H
BEGIN	ENDP
		END BEGIN
