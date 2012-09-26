TITLE LAB5
;----------------------------------------------------------------------------------------------
; Universidad del Valle de Guatemala
; Taller de Assembler
; Laboratorio 5
; LAB5.ASM
; Descripción: Este programa permite realizar dos funciones que se realizan mediante la 
;              utilizacion de teclado avanzado.
; Autor:       Juan Pablo Argueta Cortés           Carnet 11033 - Sección 11
; Fecha de creación: 14 de agosto del 2012
; Revisiones: 1
; 16 de Agosto 2012
;----------------------------------------------------------------------------------------------
			.MODEL SMALL
			.STACK 64
;----------------------------------------------------------------------------------------------
;Definición de datos.
.DATA

LINEA	   DB  80 DUP(0CDH), 0DH, 0AH, '$'	
NO_CAD	   DB  'Lo lamento, no ha ingresado alguna cadena.', 0DH, 0AH, '$'
MENU	   DB  '       Laboratorio No. 5           ', 0DH, 0AH, '$'
		   DB  'Manejo de Cadenas de Caracteres  ', 0DH, 0AH, 0DH, 0AH, '$'
		   DB  'F1 Ingreso de texto                ', 0DH, 0AH, '$'
		   DB  'F2 Salida de texto                 ', 0DH, 0AH, '$'
		   DB  'F3 Mayuscula                       ', 0DH, 0AH, '$'
		   DB  'F4 Vocales                         ', 0DH, 0AH, '$'
		   DB  'ESC Salir del programa           ', 0DH, 0AH, 0DH, 0AH, '$'
		   DB  'Ingrese una opcion: $' 
INTRO	   DB  0DH, 0AH, '$'
F1		   DB  'Ingrese una cadena de no mas de 20 caracteres:', 0DH, 0AH, '$'
TABLA      DW  FUNCION1              	             ; Tabla de bifurcación con sus cuatro opciones
           DW  FUNCION2
           DW  FUNCION3
           DW  FUNCION4
CAD_TABLA  DB  3BH, 0, 3CH, 2, 3DH, 4, 3EH, 6
LISTA  	   LABEL BYTE                    ; inicio de la lista de parametros
MAXLEN 	   DB    21                       ; numero maximo de caracteres de entrada
ACTLEN 	   DB    0                       ; numero real de caracteres de entrada
CAMPO  	   DB    20 DUP (' ')             ; caracteres introducidos del teclado
CAMPO2     DB    41 DUP (' ')

;----------------------------------------------------------------------------------------------
;Inicio de código
.CODE

;----------------------------------------------------------------------------------------------
; Imprime un Enter.
;----------------------------------------------------------------------------------------------
GET_ENTER  PROC  NEAR
		   LEA   DX, INTRO
		   CALL  PRINTS
GET_ENTER  ENDP

;----------------------------------------------------------------------------------------------
; Permite la impresión de una cadena en pantalla, al cargar la función correspondiente en AH y
; activar la interrupción necesaria. La dirección de inicio de cadena debe estar en DX.
;----------------------------------------------------------------------------------------------
PRINTS     PROC  NEAR
           MOV   AH, 09H
           INT   21H
           RET
PRINTS     ENDP

;----------------------------------------------------------------------------------------------
; Lee una entrada de Teclado, reconociendo Código de Rastreo y ASCII
;----------------------------------------------------------------------------------------------
GET_TECLA  PROC  NEAR
           MOV   AH, 10H
           INT   16H
           RET
GET_TECLA  ENDP

;----------------------------------------------------------------------------------------------
; Limpia el Buffer de Teclado.
;----------------------------------------------------------------------------------------------
CLEAN_BUFF PROC  NEAR
           MOV   AH, 0CH
           INT   16H
           RET
CLEAN_BUFF ENDP

;----------------------------------------------------------------------------------------------
; Permite la impresión del menú principal del programa.
;----------------------------------------------------------------------------------------------		
IMP_MENU   PROC  NEAR
		   LEA   DX, LINEA
		   CALL  PRINTS
		   MOV	 CX, 8
		   XOR	 BX, BX
IMP_SIG:   LEA	 DX, MENU+BX
		   CALL  PRINTS
		   ADD   BX, 38
		   LOOP  IMP_SIG
		   RET
IMP_MENU   ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento que permite ingresar una cadena de caracteres de longitud máxima de 
; 20 caracteres.
;----------------------------------------------------------------------------------------------	
FUNCION1   PROC  NEAR
		   CALL  GET_ENTER
		   LEA   DX, LINEA
		   CALL  PRINTS
		   LEA   DX, F1
		   CALL  PRINTS
		   MOV   AH, 0AH    ; peticion de la funcion de entrada
		   LEA   DX, LISTA  ; carga la direccion de la lista de parametros
		   INT   21H 
		   CALL  GET_ENTER
		   CALL  IMP_MENU
		   RET
FUNCION1   ENDP

;----------------------------------------------------------------------------------------------
; Imprimer la cadena ingresada en FUNCION1 con un asterisco entre cada letra
;----------------------------------------------------------------------------------------------	
FUNCION2   PROC  NEAR
		   CALL  GET_ENTER
		   LEA   DX, LINEA
		   CALL  PRINTS
		   CMP   ACTLEN, 0
		   JE    SALIDA
		   CLD
		   MOV   Cl, ACTLEN
		   LEA   SI, CAMPO			; cadena fuente
		   LEA	 DI, CAMPO2			; cadena destino
COPIA:	   MOVSB			; copia 20 veces byte por byte
		   MOV   AL, '*'
		   STOSB
		   LOOP  COPIA
		   MOV   AL, '$'
		   STOSB
		   LEA   DX, CAMPO2
		   CALL  PRINTS
		   JMP   EXIT2
SALIDA:	   LEA   DX, NO_CAD
		   CALL  PRINTS
EXIT2:     CALL  GET_ENTER
		   CALL  IMP_MENU
		   RET
FUNCION2   ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento que permite ingresar una cadena de caracteres de longitud máxima de 
; 20 caracteres.
;----------------------------------------------------------------------------------------------	
FUNCION3   PROC  NEAR
		   CALL  GET_ENTER
		   LEA   DX, LINEA
		   CALL  PRINTS
		   
		   CALL  GET_ENTER
		   CALL  IMP_MENU
		   RET
FUNCION3   ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento que permite ingresar una cadena de caracteres de longitud máxima de 
; 20 caracteres.
;----------------------------------------------------------------------------------------------	
FUNCION4   PROC  NEAR
		   CALL  GET_ENTER
		   LEA   DX, LINEA
		   CALL  PRINTS
		   
		   CALL  GET_ENTER
		   CALL  IMP_MENU
		   RET
FUNCION4   ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento que redirige a otros procedimientos
;----------------------------------------------------------------------------------------------
SALTOS     PROC  NEAR
VUELVE1:    CALL  CLEAN_BUFF
		   CALL	 GET_TECLA
		   CMP   AH, 3BH
		   JE    F_1
		   CMP   AH, 3CH
		   JE	 F_2
		   CMP   AH, 3DH
		   JE	 F_3
		   CMP   AH, 3EH
		   JE	 F_4
		   CMP	 AL, 1BH
		   JNE   VUELVE1
		   JMP   REG
F_1:       CALL  FUNCION1
REG:	   RET
F_2:	   CALL  FUNCION2
		   JMP   REG
F_3:	   CALL  FUNCION3
		   JMP   REG
F_4:	   CALL  FUNCION4
		   JMP   REG
SALTOS     ENDP

SALTOS2	   PROC  NEAR
VUELVE:	   CALL  CLEAN_BUFF
		   CALL  GET_TECLA
		   CMP	 AL, 1BH
		   JE    SALIR
		   CLD						; izq a der
		   MOV	 AL, AH			; busca ‘a’ en TEXTO
		   MOV	 CX, 4
		   LEA	 DI, CAD_TABLA
COMP:	   SCASB			; repite mientras no 
		   JE    SALTA
		   INC   DI
		   LOOP  COMP
		   JMP   VUELVE
SALTA:     XOR	 BX, BX
		   MOV   BL, [DI]   	; obtener el codigo
		   CALL  [TABLA+BX] 	; salta a la tabla
		   JMP   VUELVE
SALIR:	   RET
SALTOS2	   ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento Principal del Programa
;----------------------------------------------------------------------------------------------
MAIN 	   PROC  FAR
		   MOV AX, @DATA           ; inicializar area de datos
		   MOV DS, AX
		   MOV ES, AX
		   CALL  IMP_MENU
		   CALL	 SALTOS2
FINAL:     MOV   AX,4C00H
		   INT   21H
ENDP	   MAIN
;----------------------------------------------------------------------------------------------
END MAIN