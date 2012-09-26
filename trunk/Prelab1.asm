;-------------------------------------------------------------------------------------------
; Universidad del Valle de Guatemala
; Taller de Assembler
; Nombre: Juan Pablo Argueta		  Carné: 11033
; Nombre: Jonathan López                  Carné: 11106
; Sección: 10
; Fecha: 11/07/12
;-------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
; Ejemplo de tablas de bifurcación, basado en ejemplos del curso Organización de las 
; computadoras y assembler, Martha Ligia Naranjo.
;-------------------------------------------------------------------------------------------


.MODEL SMALL
.STACK 64
.DATA

OPCION	DB  ?
PRIMD	DB  ? 
SECD    DB  ?
RES     DW  ?
DIEZ    DB  10                   ;Valor 10 para división a realizar en random.
NOTAS   DB  5 DUP(0)
NOTA    DB  ': Nota Final: $'
MSJMENU DB  'Ingrese el numero de la opcion que desea realizar: ','$'
M_ING   DB  0DH,0AH,'Ingrese su Nota Final: $'
M_EST   DB  'Estudiante No. $'
MSJ1    DB  '1. Ingreso de notas de estudiantes.$'
MSJ2	DB  '2. Mostrar desempeno de estudiantes.$'
MSJ3 	DB  '3. Cambiar atributo.$'
MSJ4	DB  '4. Salir.$'
EXEL	DB  '. Excelente!$'
MBUENO	DB  '. Muy Bueno.$'
BUENO	DB  '. Bueno.$'
REG	DB  '. Regular.$'
DEBEM	DB  '. Debe Mejorar.$'
M_INGIN DB  0DH,0AH,'Ha realizado un ingreso invalido. Repita su ingreso.$'
SALE    DB  'Nos vemos.$'
MENU   	DW	PRO1              ; Tabla de bifurcación con sus cuatro opciones
		DW     PRO2
		DW     PRO3
		DW     PRO4

ENTR   DB   0DH,0AH,'$'

;-------------------------------------------------------------------------------------------
; Inicio de código
.CODE
;-------------------------------------------------------------------------------------------
; PROCEDIMIENTOS
;-------------------------------------------------------------------------------------------

;MOSTRAR: Despliega en pantalla el mensaje indicado

MOSTRAR	  PROC  NEAR
          MOV   AH, 09H               ; Petición para mostrar una cadena
          INT   21H
          RET
MOSTRAR   ENDP

;-------------------------------------------------------------------------------------------

;ENTR1: Equivalente a Enter
ENTR1	  PROC  NEAR
	  LEA   DX, ENTR              ; Baja una línea
	  CALL  MOSTRAR
	  RET
ENTR1     ENDP

;----------------------------------------------------------------------------------------------------

;PRINTC: Permite la impresión de un caracter en pantalla, al cargar la función correspondiente en AH y
;        activar la interrupción necesaria. La dirección de inicio de cadena debe estar en DX.

PRINTC    PROC  NEAR
          MOV   AH, 02H
          INT   21H
          RET
PRINTC    ENDP

;-------------------------------------------------------------------------------------------

;INICIO: Muestra el menú en pantalla.

INICIO	  PROC  NEAR
	  LEA   DX, MSJMENU
	  CALL  MOSTRAR
	  CALL  ENTR1
	  LEA   DX, MSJ1
	  CALL  MOSTRAR
	  CALL  ENTR1
	  LEA   DX, MSJ2
	  CALL  MOSTRAR
	  CALL  ENTR1
	  LEA   DX, MSJ3
	  CALL  MOSTRAR
	  CALL  ENTR1
	  LEA   DX, MSJ4
	  CALL  MOSTRAR
	  CALL  ENTR1
	  RET
INICIO 	  ENDP

;-------------------------------------------------------------------------------------------

;INGRESO: Permite controlar el ingreso de datos

INGRESO   PROC  NEAR
REP_ING2: CALL  ENTR1
          LEA   DX, MSJMENU                 ;Imprime la petición de ingreso al usuario.
          CALL  MOSTRAR
          MOV   AH, 01H
          INT   21H
          SUB   AL, 30H
          CMP   AL, 0                       ;Se verifica que el ingreso no esté debajo del valor inferior.
          JB    INVALIDO2                   ;De estarlo, se repite la petición.
          CMP   AL, 4                       ;Se verifica que el ingreSo no esté arriba del valor superior.
          JA    INVALIDO2
          MOV   OPCION, AL
          RET                               ;Si se llega aquí, el ingreso el válido.
INVALIDO2:CALL  ENTR1
          LEA   DX, M_INGIN                 ;De ser invalido el ingreso, se imprime un mensaje informándolo.
          CALL  MOSTRAR
          CALL  ENTR1                       ;Se cambia de línea.
          JMP   REP_ING2
INGRESO   ENDP

;----------------------------------------------------------------------------------------------------

;GET_ING: Permite el ingreso de un número desde el teclado, luego de haber impreso una petición, genérica.
;         Valida que el caracter se encuentre dentro del rango de los valores VAL_INF y VAL_SUP.
;         De no estarlos, repite la petición del caracter. Se almacenan dos caracteres.
;TOMADO DEL PROYECTO FINAL DE ORGANIZACION DE COMPUTADORAS, AUTORES: Juan Pablo Argueta (yo), Oscar Castaneda

GET_ING   PROC  NEAR
REP_ING:  LEA   DX, M_ING                   ;Imprime la petición de ingreso al usuario.
          CALL  MOSTRAR
          MOV   AH, 01H
          INT   21H
          SUB   AL, 30H
          CMP   AL, 0                       ;Se verifica que el ingreso no esté debajo del valor inferior.
          JB    INVALIDO                    ;De estarlo, se repite la petición.
          CMP   AL, 9                       ;Se verifica que el ingreSo no esté arriba del valor superior.
          JA    INVALIDO                    ;De estarlo, se repite la petición.
	  MOV   PRIMD, AL
          MOV   AH, 01H
          INT   21H
          SUB   AL, 30H
          CMP   AL, 0                       ;Se verifica que el ingreso no esté debajo del valor inferior.
          JB    INVALIDO                    ;De estarlo, se repite la petición.
          CMP   AL, 9                       ;Se verifica que el ingreSo no esté arriba del valor superior.
          JA    INVALIDO
          CALL  MULTI
          RET                               ;Si se llega aquí, el ingreso el válido.
INVALIDO: LEA   DX, M_INGIN                 ;De ser invalido el ingreso, se imprime un mensaje informándolo.
          CALL  MOSTRAR
          CALL  ENTR1                       ;Se cambia de línea.
          JMP   REP_ING                     ;Se repite el ingreso.
GET_ING   ENDP


;-------------------------------------------------------------------------------------------

;MULTI: Se encarga de realizar las multiplicaciones necesarias para guardar el numero de dos 
;       digitos en el arreglo "Notas".

MULTI    PROC  NEAR
         MOV   SECD, AL
         MOV   AL, 10
	 MUL   PRIMD
	 MOV   RES, AX
	 XOR   AX, AX
	 MOV   AL, SECD
	 ADD   RES, AX
	 XOR   AX, AX
	 MOV   AX, RES
	 MOV	NOTAS[BX-1], AL
	 RET
MULTI    ENDP


;-------------------------------------------------------------------------------------------

;PRO1: Procedimiento 1 de la tabla. Permite el ingreso de notas de los cinco estudiantes.
;      El ingreso es de dos digitos para numeros de 0-99.

PRO1 	  PROC  NEAR
	  CALL  ENTR1                      ;Se cambia de línea.
          XOR   BX, BX
          MOV   CX, 5
ING:      INC   BX
          LEA   DX, M_EST                  ;Imprime la petición de ingreso al usuario.
          CALL  MOSTRAR
          MOV   DL, BL                     ;Se indica el numero de estudiante actual.
          ADD   DL, 30H
          CALL  PRINTC
          CALL  GET_ING
          CALL  ENTR1
          CALL  ENTR1
          LOOP  ING
          RET
PRO1 	  ENDP

;-------------------------------------------------------------------------------------------

;PRO2: Procedimiento 2 de la tabla. Muestra el desempeno de todos los estudiantes de acuerdo
;      a su nota final.

PRO2 	  PROC  NEAR
	  CALL  ENTR1                      ;Se cambia de línea.
          XOR   BX, BX
          MOV   CX, 5
ING1:     INC   BX
          LEA   DX, M_EST                  ;Indica el estudiante de cual se habla.
          CALL  MOSTRAR
          MOV   DL, BL                     
          ADD   DL, 30H
          CALL  PRINTC
          LEA   DX, NOTA
          CALL  MOSTRAR
          XOR   AX, AX
          MOV   AL, NOTAS[BX-1]
          CALL  PRINTNUM
          CALL  COMPARAR
          CALL  MOSTRAR
          CALL  ENTR1
          CALL  ENTR1
          LOOP  ING1
          RET
PRO2 	  ENDP

;-------------------------------------------------------------------------------------------

;PRINTNUM: Imprime correctamente en pantalla un número positivo de dos dígitos almacenado en AL.
;TOMADO DEL PROYECTO FINAL DE ORGANIZACION DE COMPUTADORAS, AUTORES: Juan Pablo Argueta (yo), Oscar Castaneda

PRINTNUM  PROC  NEAR
          CBW                               ;Se convierte el dato a palabra en AX, preparándolo para la división.
          DIV   DIEZ                        ;El cociente quedará en AL y el residuo en AH.
          TEST  AL, 11111111B               ;El cociente será el dígito de las decenas.
          JZ    DIG_UNI                     ;Si es cero, no se imprime.
          PUSH  AX                          ;De imprimirlo, se almacena AX en la pila para conservar el resultado de unidades.
          MOV   DL, AL                      ;Se imprime el dígito de las decenas.
          ADD   DL, 30H
          CALL  PRINTC
          POP   AX                          ;Se retornan los resultados de la operación a AX.
DIG_UNI:  MOV   DL, AH                      ;Se imprime el dígito de las unidades, que es el residuo.
          ADD   DL, 30H
          CALL  PRINTC
          RET
PRINTNUM  ENDP
;-------------------------------------------------------------------------------------------

;COMPARAR: Compara las notas de los alumnos e identifica cual ha sido el desempeno del estudiante
;          y prepara el mensaje respectivo en DX.

COMPARAR  PROC  NEAR
	  CMP	NOTAS[BX-1], 99             ;Verifica si la nota es 99.
	  JE	EXE
	  CMP   NOTAS[BX-1], 79             ;Verifica si la nota es mayor a 79.
	  JAE	MB
	  CMP	NOTAS[BX-1], 69             ;Verifica si la nota es mayor a 69.
	  JAE	BUE
	  CMP   NOTAS[BX-1], 59             ;Verifica si la nota es mayor a 59.
	  JAE	REG1
	  LEA	DX, DEBEM
SALIR:	  RET
EXE:	  LEA	DX, EXEL
	  JMP	SALIR
MB:       LEA	DX, MBUENO
	  JMP 	SALIR
BUE:	  LEA	DX, BUENO
	  JMP 	SALIR
REG1:	  LEA 	DX, REG   			  	
	  JMP	SALIR	
COMPARAR  ENDP		


;-------------------------------------------------------------------------------------------

;PRO3: Procedimiento 3 de la tabla. Permite cambiar atributos en un manejo sencillo de pantalla.

PRO3 	PROC  NEAR
	    CALL CURSOR
	    ;Comienza a limpiar pantalla
		MOV AX, 0600H
		MOV BH, 00010011B
		MOV CX,0000H	; Posicion izquierda superior
		MOV DX,184FH	; Posicion derecha inferior
		INT 10H
        RET
PRO3 	ENDP

;-------------------------------------------------------------------------------------------

;PRO4: Procedimiento 4 de la tabla. Da opcion a salir del programa.

PRO4	  PROC  NEAR
	  LEA   DX, SALE
	  CALL  MOSTRAR
	  CALL  ENTR1
	  JMP   SALIRD
PRO4	  ENDP

;-------------------------------------------------------------------------------------------

;SALTOS: Procedimiento obtenido de "Tablas.asm" de Martha Ligia Naranjo.
;        Permite el ingreso a procedimientos especificos a traves de un menu previamente mostrado.

SALTOS	  PROC  NEAR
	  XOR   BX, BX	  	; pone a 0 registro BX
	  MOV   BL, OPCION 	; obtener el codigo
	  SHL   BX, 01	  	; mult. Por 2
	  JMP   [MENU+BX] 	; salta a la tabla
SALTOS	  ENDP

;Situa el cursor en la primera línea y primera columna
CURSOR	PROC NEAR
	MOV AH, 02H		; Peticion de fijar cursor
	MOV DX, 0000
	MOV BH, 00		; Pagina 0
	INT 10H
	RET
CURSOR	ENDP

;Llama al modo video
VIDEO	PROC NEAR
		MOV AH, 00H
		MOV AL, 03H
		INT 10H
		RET
VIDEO 	ENDP

;
REGRESA	PROC NEAR
		MOV AX,0600H	; Recorrer toda la pantalla
		MOV BH, 70H		; Atributo: blanco sobre negro
		MOV CX,0000H	; Posicion izquierda superior
		MOV DX,184FH	; Posicion derecha inferior
		INT 10H			
		RET
REGRESA	ENDP

;---------------------------------------------------------------------------------------------------------

;MAIN: Procedimiento principal del programa.

MAIN   	  PROC  FAR
	  .STARTUP

OTRAVEZ:  CALL  INICIO
          CALL  INGRESO
		  CALL  ENTR1
          SUB   OPCION, 01H
          CALL  SALTOS
          JMP   OTRAVEZ
SALIRD:	  CALL REGRESA  
		  MOV   AH, 4CH                 ; salida al DOS
		  INT   21H
MAIN 	  ENDP
	  END MAIN