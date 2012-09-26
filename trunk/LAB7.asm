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

.MODEL SMALL
.STACK 64
.DATA

OPCION    	DB   ?
MSJMENU 	DB   ' Que desea hacer:   								 ', 0DH, 0AH
			DB	 ' 1. Ingreso de articulo   						 ', 0DH, 0AH 
			DB	 ' 2. Despliegue de articulo   						 ', 0DH, 0AH 
			DB	 ' 3. Despliegue de inventario total de artículos 	 ', 0DH, 0AH
			DB	 ' 4. Borrar articulo   							 ', 0DH, 0AH
			DB	 ' 5. Salida   										 ', 0DH, 0AH, '$'
MSJMENU1	DB   'Ingrese el numero de la opcion que desea realizar: ','$'
MSJCADENA   DB   'Ingrese una cadena de no mas de 12 caracteres:', 0DH, 0AH, '$'
M_ING   	DB   0DH,0AH,'Ingrese el numero de codigo: $'
M_INGIN 	DB   0DH,0AH,'Ha realizado un ingreso invalido. Repita su ingreso.$'			 
MSJ1     	DB   'Eligio sumar$'
MSJ2		DB 	 'Eligio restar$'
MSJ3 		DB   'Eligio multiplicar$' 
TABLA   	DW   PRO1              ; Tabla de bifurcación con sus tres opciones
			DW   PRO2
			DW   PRO3
			DW	 PRO4
			DW	 PRO5
LISTA  	    LABEL BYTE                    				 ; inicio de la lista de parametros
MAXLEN 	    DB   13                       				 ; numero maximo de caracteres de entrada
ACTLEN 	    DB   0                        				 ; numero real de caracteres de entrada
DESCRIP	    DB   12 DUP (' '), 0DH, 0AH, '$'             ; caracteres introducidos del teclado
LINEA	    DB   14 DUP (' '), 0DH, 0AH, '$'
ENTR1       DB   0DH,0AH,'$'

SECD    	DB   ' '
PRIMD		DB   ' '
;-------------------------------------------------------------------------------------------
; Inicio de código
.CODE
;-------------------------------------------------------------------------------------------
; PROCEDIMIENTOS
; Despliega en pantalla el mensaje indicado
MOSTRAR	PROC NEAR
		MOV   AH, 09H               ; Petición para mostrar una cadena
        INT   21H
        RET
MOSTRAR ENDP

; Deja un espacio para ordenar mejor la interfaz
ENTR	PROC NEAR
		MOV   AH, 09H
		LEA   DX, ENTR1              ; Baja una línea
		INT   21H
		RET
ENTR    ENDP

; Controla el ingreso de las opciones
INGRESO   PROC  NEAR
REP_ING2: CALL  ENTR
          LEA   DX, MSJMENU1                 ;Imprime la petición de ingreso al usuario.
          CALL  MOSTRAR
          MOV   AH, 01H
          INT   21H
          SUB   AL, 30H
          CMP   AL, 0                       ;Se verifica que el ingreso no esté debajo del valor inferior.
          JB    INVALIDO2                   ;De estarlo, se repite la petición.
          CMP   AL, 5                       ;Se verifica que el ingreSo no esté arriba del valor superior.
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

GET_ING   PROC  NEAR
REP_ING:  LEA   DX, M_ING                   ;Imprime la petición de ingreso al usuario.
          CALL  MOSTRAR
          MOV   AH, 01H
          INT   21H
          CMP   AL, 30h                     ;Se verifica que el ingreso no esté debajo del valor inferior.
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

;CONCA: Se encarga de concatener los dígitos ingresados para guardarlos como Strings en la cadena correspondiente. 

CONCA   PROC  NEAR
		CLD
		LEA   SI, PRIMD
		LEA   DI, LINEA
		MOVSB
		LEA   SI, SECD
	    MOVSB
		LEA   DX, LINEA
		CALL  MOSTRAR
		RET
CONCA   ENDP

;Procedimiento de la tabla
PRO1 	PROC NEAR
		CALL GET_ING
        RET
PRO1 	ENDP

;Procedimiento de la tabla
PRO2 	PROC NEAR
		LEA DX, MSJ2
		CALL MOSTRAR
        RET
PRO2 	ENDP

;Procedimiento de la tabla
PRO3 	PROC NEAR
		LEA DX, MSJ3
		CALL MOSTRAR
        RET
PRO3 	ENDP

PRO4	PROC NEAR
		RET
PRO4	ENDP

PRO5	PROC NEAR
		RET
PRO5	ENDP

;Tomado del ejemplo "Tablas.asm" de Martha Ligia Naranjo
SALTOS	PROC 	NEAR
		XOR	BX, BX	  	; pone a 0 registro BX
		MOV BL, OPCION 	; obtener el codigo
		SHL	BX, 01	  	; mult. Por 2
		JMP	[TABLA+BX] 	; salta a la tabla
SALTOS	ENDP
;---------------------------------------------------------------------------------------------------------
MAIN   PROC FAR
       .STARTUP

        LEA    DX, MSJMENU
        CALL   MOSTRAR
        CALL   ENTR

        CALL   INGRESO
		CALL   ENTR
        
        
		CALL SALTOS
		
        MOV AH, 4CH		;salida al DOS
		INT 21H

MAIN   ENDP
       END MAIN