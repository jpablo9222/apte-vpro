TITLE LAB7
;-------------------------------------------------------------------------------------------
; Universidad del Valle de Guatemala
; Taller de Assembler
; Sección: 10
; Laboratorio 7
; LAB7.ASM
; Descripción: 
; Autor:  	Juan Pablo Argueta			  	Carné: 11033
;  			Jonathan López                  Carné: 11106
; Fecha de creación: 25 de septiembre del 2012
; Revisiones: 1
; 25 de septiembre del 2012
;-------------------------------------------------------------------------------------------

;***********************************************************************************
; Macro para desplegar una cadena.
;***********************************************************************************
DESP	MACRO CADENA
	MOV AH, 09H		; DESPLEGAR MENSAJE
	LEA DX, CADENA
	INT 21H
	ENDM
; **********************************************************************************

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
; **********************************************************************************

;***********************************************************************************
; Macro para escribir un archivo. 
; **********************************************************************************
ESCRIBIR_A	MACRO MANEJADOR, DATOS
	MOV AH, 40H			; petición para escribir
	MOV	BX, MANEJADOR	; manejador de archivo
	MOV CX, 17			; longitud del registro
	LEA	DX, DATOS		; dirección del área de datos
	INT	21H				; llama al DOS
	ENDM
; **********************************************************************************

;***********************************************************************************
; Macro para cerrar un archivo.
;***********************************************************************************
CERRAR_A	MACRO MANEJADOR
	MOV	AH, 3EH	; PETICION
	MOV BX, MANEJADOR
	INT	21H
	ENDM
; **********************************************************************************

;***********************************************************************************
; Macro para mover el apuntador.
;***********************************************************************************
MOV_APUN MACRO MANEJADOR, REGISTRO, POS
	MOV AH, 42H			; Peticion para mover el apuntador
	MOV	AL, POS 		; 00: inicio, 01: pos actual 02: fin archivo
	mov	BX, MANEJADOR	; MANEJADOR
	MOV CX, 00H			;
	MOV	DX, REGISTRO 	; DESPLAZAMIENTO DE n BYTES
	INT 21H
	ENDM
; **********************************************************************************

;***********************************************************************************
; Macro para abrir archivo. 
;***********************************************************************************
ABRIR_A	MACRO NOM_ARCHIVO, MODO
	MOV AH, 3DH			; petición
	MOV AL, MODO			; 00: modo sólo lectura, 01: solo escritura, 02: lect/escr
	LEA DX, NOM_ARCHIVO	; cadena ASCIIZ
	INT	21H
	MOV	MANEJ, AX		; guardar el manejador
	ENDM
; **********************************************************************************

;***********************************************************************************
; Macro para leer archivo. 
;***********************************************************************************
LEER_A	MACRO MANEJADOR
	MOV	AH, 3FH			; petición
	MOV BX, MANEJADOR	; manejador
	MOV CX, 17			; longitud del registro
	LEA	DX, LECTURA		; registro donde se leen datos
	INT 21H
	ENDM
; **********************************************************************************

;***********************************************************************************
; Macro para copiar una cadena a otra. 
;***********************************************************************************
COPIAR_CAD MACRO SOURCE, DESTINY, LONGITUD
	MOV CX, LONGITUD
	LEA SI, SOURCE
	LEA DI, DESTINY
REP MOVSB
	ENDM

; **********************************************************************************

;***********************************************************************************
; Macro para "mover de memoria a memoria".
;***********************************************************************************
MOVM MACRO SRC, DTN
	PUSH AX
	MOV AL, SRC
	MOV DTN, AL
	POP AX
	ENDM
; **********************************************************************************

.MODEL SMALL
.STACK 64
.DATA
.386
NOMBRE		DB	 'LAB7.TXT',00H
MANEJ		DW	 ?
OPCION    	DB   ?
MSJMENU 	DB   ' Que desea hacer:   								 ', 0DH, 0AH
			DB	 ' 1. Ingreso de articulo   						 ', 0DH, 0AH 
			DB	 ' 2. Despliegue de articulo   						 ', 0DH, 0AH 
			DB	 ' 3. Despliegue de inventario total de articulos 	 ', 0DH, 0AH
			DB	 ' 4. Borrar articulo   							 ', 0DH, 0AH
			DB	 ' 5. Salida   										 ', 0DH, 0AH, '$'
MSJMENU1	DB   'Ingrese el numero de la opcion que desea realizar: ','$'
MSJMENU2	DB   '                        Ingrese el Registro a ver: ','$'
MSJ			DB   52 DUP (' ')
MSJCADENA   DB   0DH,0AH,'Ingrese una cadena de no mas de 12 caracteres:', 0DH, 0AH, '$'
M_ING   	DB   0DH,0AH,'Ingrese el numero de codigo: $'
M_INGIN 	DB   0DH,0AH,'Ha realizado un ingreso invalido. Repita su ingreso.$'			 
TABLA   	DW   PRO1               					; Tabla de bifurcación con sus tres opciones
			DW   PRO2
			DW   PRO3
			DW	 PRO4
			DW	 PRO5
LISTA  	    LABEL BYTE                    				 ; inicio de la lista de parametros
MAXLEN 	    DB   13                       				 ; numero maximo de caracteres de entrada
ACTLEN 	    DB   0                        				 ; numero real de caracteres de entrada
DESCRIP	    DB   12 DUP (' ')                            ; caracteres introducidos del teclado
LINEA	    DB   15 DUP (' '), 0DH, 0AH, '$'
LECTURA		DB   17 DUP (' ')
LIMPIA		DB	 15 DUP (' ')							 ; cadena para limpiar línea.
ENTR1       DB   0DH,0AH,'$'
NO_CAD	   	DB  'Lo lamento, no ha ingresado alguna cadena.', 0DH, 0AH, '$'
SECD    	DB   ' '
PRIMD		DB   ' '
CONT_REG	DW	0
CONT_REG1	DB  0
VAL_SUP		DB  ?
REGISTRO	DB  ?
ERROR		DB	0DH,0AH,'No pudo crearse el archivo$'
ERROR_E0    DB  0DH,0AH,'No pudo abrirse el archvio$'
ERROR_E1	DB	0DH,0AH,'No pudo escribirse en el archivo$'
ERROR_L1	DB	0DH,0AH,'No pudo leerse del archivo$'
ERROR_L2	DB	0DH,0AH,'No se realizo la lectura completa del archivo$'
ERROR_M		DB	0DH,0AH,'No se realizo el movimiento del apuntador.$'
N			DW	0
;-------------------------------------------------------------------------------------------
; Inicio de código
.CODE
;-------------------------------------------------------------------------------------------
; PROCEDIMIENTOS
;-------------------------------------------------------------------------------------------
; Despliega en pantalla el mensaje indicado
;-------------------------------------------------------------------------------------------
MOSTRAR	PROC NEAR
		MOV   AH, 09H               ; Petición para mostrar una cadena
        INT   21H
        RET
MOSTRAR ENDP
;-------------------------------------------------------------------------------------------
; Deja un espacio para ordenar mejor la interfaz
;-------------------------------------------------------------------------------------------
ENTR	PROC NEAR
		MOV   AH, 09H
		LEA   DX, ENTR1              ; Baja una línea
		INT   21H
		RET
ENTR    ENDP
;----------------------------------------------------------------------------------------------------
; Procedimiento que carga el macro para crear un archivo, junto con sus posibles errores.
;----------------------------------------------------------------------------------------------------
CREAR_ARCHIVO PROC NEAR
		  CREAR_A NOMBRE
		  JC FALLO										 ; Si hay error despliega mensaje.
R1:		  RET
FALLO:	  DESP ERROR
		  JMP R1
CREAR_ARCHIVO ENDP

;----------------------------------------------------------------------------------------------------
; Procedimiento para escribir en el archivo, junto con sus posibles errores.
;----------------------------------------------------------------------------------------------------
ESCRIBIR_ARCHIVO PROC NEAR
		  ESCRIBIR_A MANEJ, LINEA
		  JC ERROR3										 ; Prueba por error.
R3:		  RET
ERROR3:	  DESP ERROR_E1
		  JMP R3		  
ESCRIBIR_ARCHIVO ENDP

;----------------------------------------------------------------------------------------------------
; Procedimiento para leer un archivo, junto con sus posibles errores.
;----------------------------------------------------------------------------------------------------
LEER_ARCHIVO  PROC NEAR
		  LEER_A MANEJ									 ; Mueve el manejador.
		  JC ERROR1										 ; Prueba por error.
		  CMP AX, 00									 ; En AX retorna el numero de bytes leidos.
		  JE ERROR2
		  DESP LINEA
R2:		  RET
ERROR1:   DESP ERROR_L1
		  JMP R2
ERROR2:   DESP ERROR_L2
		  JMP R2
LEER_ARCHIVO ENDP

;----------------------------------------------------------------------------------------------------
; Procedimiento para mover el apuntador, junto con sus posibles errores.
;----------------------------------------------------------------------------------------------------
MOVER_APUNTADOR	PROC NEAR
		  MOV_APUN MANEJ, AX, 00H
		  JC FALLO_M									 ; Si hay error, despliega el mensaje de error.
R4:		  RET
FALLO_M:  DESP ERROR_M
		  JMP R4
MOVER_APUNTADOR	ENDP		  

;----------------------------------------------------------------------------------------------------
; Procedimiento para limpiar una cadena.
;----------------------------------------------------------------------------------------------------
LIMPIAR	PROC NEAR
		XOR CX, CX										 ; 
		MOV CL, 15
		CLD
		LEA SI, LIMPIA
		LEA DI, LINEA
M:		MOVSB
		LOOP M
		RET
LIMPIAR ENDP

;-----------------------------------------------------------------------------------------------------
; Controla el ingreso de las opciones
;-----------------------------------------------------------------------------------------------------
INGRESO   PROC  NEAR
REP_ING2: CALL  ENTR
          LEA   DX, MSJ                     ;Imprime la petición de ingreso al usuario.
          CALL  MOSTRAR
          MOV   AH, 01H
          INT   21H
          SUB   AL, 30H
          CMP   AL, 0                       ;Se verifica que el ingreso no esté debajo del valor inferior.
          JB    INVALIDO2                   ;De estarlo, se repite la petición.
          CMP   AL, VAL_SUP                 ;Se verifica que el ingreSo no esté arriba del valor superior.
          JA    INVALIDO2
          MOV   OPCION, AL
		  SUB	OPCION, 1
          RET                               ;Si se llega aquí, el ingreso es válido.
INVALIDO2:CALL  ENTR
          LEA   DX, M_INGIN                 ;De ser invalido el ingreso, se imprime un mensaje informándolo.
          CALL  MOSTRAR
          CALL  ENTR                        ;Se cambia de línea.
          JMP   REP_ING2
INGRESO   ENDP

;----------------------------------------------------------------------------------------------------
;GET_ING: Permite el ingreso de un número desde el teclado, luego de haber impreso una petición, genérica.
;         Valida que el caracter se encuentre dentro del rango 0<=caracter<=9.
;         De no estarlos, repite la petición del caracter. Se almacenan dos caracteres.
;TOMADO DEL PROYECTO FINAL DE ORGANIZACION DE COMPUTADORAS, AUTORES: Juan Pablo Argueta (yo), Oscar Castaneda
;-----------------------------------------------------------------------------------------------------
GET_ING   PROC  NEAR
REP_ING:  LEA   DX, M_ING                   ;Imprime la petición de ingreso al usuario.
          CALL  MOSTRAR
          MOV   AH, 01H
          INT   21H
          CMP   AL, 30H                     ;Se verifica que el ingreso no esté debajo del valor inferior.
          JB    INVALIDO                    ;De estarlo, se repite la petición.
          CMP   AL, 39H                     ;Se verifica que el ingreSo no esté arriba del valor superior.
          JA    INVALIDO                    ;De estarlo, se repite la petición.
		  MOV   PRIMD, AL
          MOV   AH, 01H
          INT   21H
          CMP   AL, 30h                     ;Se verifica que el ingreso no esté debajo del valor inferior.
          JB    INVALIDO                    ;De estarlo, se repite la petición.
          CMP   AL, 39H                     ;Se verifica que el ingreSo no esté arriba del valor superior.
          JA    INVALIDO                    ;De estarlo, se repite la petición.
		  MOV   SECD, AL
          CALL  CONCA
          RET                               ;Si se llega aquí, el ingreso el válido.
INVALIDO: LEA   DX, M_INGIN                 ;De ser invalido el ingreso, se imprime un mensaje informándolo.
          CALL  MOSTRAR
          CALL  ENTR                       ;Se cambia de línea.
          JMP   REP_ING                     ;Se repite el ingreso.
GET_ING   ENDP

;-----------------------------------------------------------------------------------------------------
;CONCA: Se encarga de concatener los dígitos ingresados para guardarlos como Strings en la cadena correspondiente. 
;-----------------------------------------------------------------------------------------------------
CONCA   PROC  NEAR
		CLD
		LEA    SI, PRIMD
		LEA    DI, LINEA
		MOVSB
		LEA    SI, SECD
	    MOVSB
		MOV    AL, ' '
		STOSB
		MOV    CL, ACTLEN
		LEA    SI, DESCRIP 
REP		MOVSB
		RET
CONCA   ENDP

;----------------------------------------------------------------------------------------------------
;Procedimiento de la tabla
;-----------------------------------------------------------------------------------------------------
PRO1 	PROC NEAR
		ABRIR_A NOMBRE, 01H
		MOV_APUN MANEJ, 0, 02H
INI:	LEA DX, MSJCADENA
		CALL MOSTRAR
		MOV AH, 0AH
		LEA DX, LISTA
		INT 21H
		XOR CX, CX
		CMP ACTLEN, 0
		JE SALIR
		CALL GET_ING
		CALL ENTR
		LEA DX, LINEA
		CALL MOSTRAR
		CALL ESCRIBIR_ARCHIVO
		CERRAR_A MANEJ
		ABRIR_A NOMBRE, 01H
		JC SALIR
		MOV_APUN MANEJ, 0, 02H
		INC CONT_REG
		INC CONT_REG1
		CALL LIMPIAR
		CERRAR_A MANEJ
        RET
SALIR:	LEA DX, NO_CAD
		CALL MOSTRAR
		JMP INI	
PRO1 	ENDP

;-----------------------------------------------------------------------------------------------------
;Procedimiento para multiplicar el manejador.
;-----------------------------------------------------------------------------------------------------
MULTI	PROC NEAR
		PUSH AX
		XOR AX, AX
		MOV  AL, 17
		MUL OPCION
		MOV_APUN MANEJ, AX, 00H
		POP AX
		RET
MULTI	ENDP
;-----------------------------------------------------------------------------------------------------
;Procedimiento de la tabla
;-----------------------------------------------------------------------------------------------------
PRO2 	PROC NEAR
		ABRIR_A NOMBRE, 00H
		COPIAR_CAD MSJMENU2, MSJ, 52
		MOVM  CONT_REG1, VAL_SUP 
		CALL INGRESO
		CALL MULTI
		CALL LEER_ARCHIVO
		CALL ENTR
		DESP LECTURA
		CERRAR_A MANEJ
        RET
PRO2 	ENDP

;-----------------------------------------------------------------------------------------------------
;Procedimiento de la tabla
;-----------------------------------------------------------------------------------------------------
PRO3 	PROC NEAR
		ABRIR_A NOMBRE, 00H
		XOR CX, CX
		MOV CX, CONT_REG
LEER:	CALL LEER_ARCHIVO
		LOOP LEER
		CERRAR_A MANEJ
        RET
PRO3 	ENDP

;-----------------------------------------------------------------------------------------------------
; Procedimiento de la tabla
;-----------------------------------------------------------------------------------------------------
PRO4	PROC NEAR
		RET
PRO4	ENDP

;-----------------------------------------------------------------------------------------------------
; Procedimiento de la tabla.
;-----------------------------------------------------------------------------------------------------
PRO5	PROC NEAR
		JMP SALE
PRO5	ENDP

;-----------------------------------------------------------------------------------------------------
;Tomado del ejemplo "Tablas.asm" de Martha Ligia Naranjo
;-----------------------------------------------------------------------------------------------------
SALTOS	PROC 	NEAR
		XOR	BX, BX	  	; pone a 0 registro BX
		MOV BL, OPCION 	; obtener el codigo
		SHL	BX, 01	  	; mult. Por 2
		JMP	[TABLA+BX] 	; salta a la tabla
SALTOS	ENDP

;---------------------------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------------------
MAIN   PROC FAR
        MOV AX, @DATA           ; inicializar area de datos
		MOV DS, AX
		MOV ES, AX
		CALL CREAR_ARCHIVO
ASD:    LEA    DX, MSJMENU
        CALL   MOSTRAR
        CALL   ENTR
		COPIAR_CAD MSJMENU1, MSJ, 52
		MOV   VAL_SUP, 5
        CALL   INGRESO
		CALL   ENTR
        
		CALL SALTOS
		JMP ASD
SALE:   CERRAR_A MANEJ
		MOV AX, 4C00H		;salida al DOS
		INT 21H

MAIN   ENDP
       END MAIN