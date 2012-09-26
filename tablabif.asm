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
MSJMENU 	DB   'Que desea hacer: 1.Sumar  2.Restar  3.Multiplicar (ingrese el numero de la opcion): ','$'
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