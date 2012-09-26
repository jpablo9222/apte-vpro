;-------------------------------------------------------------------------------------------
; Universidad del Valle de Guatemala
; Taller de Assembler
; Nombre: Juan Pablo Argueta			  Carn�: 11033
; Nombre: Jonathan L�pez                  Carn�: 11106
; Nombre: Mar�a Fernanda Mart�nez         Carn�: 11176
; Secci�n: 10
;-------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
; Ejemplo de tablas de bifurcaci�n, basado en ejemplos del curso Organizaci�n de las 
; computadoras y assembler, Martha Ligia Naranjo.
;-------------------------------------------------------------------------------------------

.MODEL SMALL
.STACK 64
.DATA

OPCION    	DB   ?
MSJMENU 	DB   ' Que desea hacer:   								', 0DH, 0AH
			DB	 ' 1. Ingreso de articulo   						', 0DH, 0AH 
			DB	 ' 2. Despliegue de articulo   						', 0DH, 0AH 
			DB	 ' 3. Despliegue de inventario total de art�culos 	', 0DH, 0AH
			DB	 ' 4. Borrar articulo   							', 0DH, 0AH
			DB	 ' 5. Salida   										', 0DH, 0AH, '$'
			
MSJ1     	DB   'Eligio sumar$'
MSJ2		DB 	 'Eligio restar$'
MSJ3 		DB   'Eligio multiplicar$' 
TABLA   	DW   PRO1              ; Tabla de bifurcaci�n con sus tres opciones
			DW   PRO2
			DW   PRO3

ENTR1        DB   0DH,0AH,'$'
;-------------------------------------------------------------------------------------------
; Inicio de c�digo
.CODE
;-------------------------------------------------------------------------------------------
; PROCEDIMIENTOS
; Despliega en pantalla el mensaje indicado
MOSTRAR	PROC NEAR
		MOV   AH, 09H               ; Petici�n para mostrar una cadena
        INT   21H
        RET
MOSTRAR ENDP

; Deja un espacio para ordenar mejor la interfaz
ENTR	PROC NEAR
		MOV   AH, 09H
		LEA   DX, ENTR1              ; Baja una l�nea
		INT   21H
		RET
ENTR    ENDP

; Controla el ingreso de las opciones
INGRESO PROC NEAR
		MOV AH,01H
		INT 21H
		MOV OPCION, AL
		RET
INGRESO ENDP

;----------------------------------------------------------------------------------------------------

;GET_ING: Permite el ingreso de un n�mero desde el teclado, luego de haber impreso una petici�n, gen�rica.
;         Valida que el caracter se encuentre dentro del rango 0<=caracter<=9.
;         De no estarlos, repite la petici�n del caracter. Se almacenan dos caracteres.
;TOMADO DEL PROYECTO FINAL DE ORGANIZACION DE COMPUTADORAS, AUTORES: Juan Pablo Argueta (yo), Oscar Castaneda

GET_ING   PROC  NEAR
REP_ING:  LEA   DX, M_ING                   ;Imprime la petici�n de ingreso al usuario.
          CALL  MOSTRAR
          MOV   AH, 01H
          INT   21H
          SUB   AL, 30H
          CMP   AL, 0                       ;Se verifica que el ingreso no est� debajo del valor inferior.
          JB    INVALIDO                    ;De estarlo, se repite la petici�n.
          CMP   AL, 9                       ;Se verifica que el ingreSo no est� arriba del valor superior.
          JA    INVALIDO                    ;De estarlo, se repite la petici�n.
		  MOV   PRIMD, AL
          MOV   AH, 01H
          INT   21H
          SUB   AL, 30H
          CMP   AL, 0                       ;Se verifica que el ingreso no est� debajo del valor inferior.
          JB    INVALIDO                    ;De estarlo, se repite la petici�n.
          CMP   AL, 9                       ;Se verifica que el ingreSo no est� arriba del valor superior.
          JA    INVALIDO
          CALL  MULTI
          RET                               ;Si se llega aqu�, el ingreso el v�lido.
INVALIDO: LEA   DX, M_INGIN                 ;De ser invalido el ingreso, se imprime un mensaje inform�ndolo.
          CALL  MOSTRAR
          CALL  ENTR1                       ;Se cambia de l�nea.
          JMP   REP_ING                     ;Se repite el ingreso.
GET_ING   ENDP

;Procedimiento de la tabla
PRO1 	PROC NEAR
		LEA DX, MSJ1
		CALL MOSTRAR
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
        SUB    OPCION, 31H
        
		CALL SALTOS
		
        MOV AH, 4CH		;salida al DOS
		INT 21H

MAIN   ENDP
       END MAIN