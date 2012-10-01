;***********************************************************************************
; Macro para obtener la posición del cursor en la pantalla.
;***********************************************************************************
GET_CUR    	MACRO  PAG
			MOV    AH, 03H			;Obtiene la posición actual del cursor
			MOV    BH, PAG
			INT    10H
			MOV    FILA_ACTUAL, DH
			MOV    COL_ACTUAL, DL
			ENDM

;----------------------------------------------------------------------------------------------
; Macro para posicionar el cursor en una posición específica en la pantalla.
;----------------------------------------------------------------------------------------------		   
SET_CUR    	MACRO  PAG, COL, FILA
			MOV    AH, 02H
			MOV    BH, PAG
			MOV    DL, COL
			MOV    DH, FILA
			INT    10H
			ENDM
;***********************************************************************************
; Macro para copiar una cadena a otra. 
;***********************************************************************************
COPIAR_CAD 	MACRO SOURCE, DESTINY, LONGITUD
			PUSHA
			MOV CX, LONGITUD	; Se carga la longitud de la cadena
			CLD
			LEA SI, SOURCE	
			LEA DI, DESTINY
			REP	MOVSB
			POPA
			ENDM

;***********************************************************************************
; Macro para desplegar una cadena.
;***********************************************************************************
DESP		MACRO CADENA
			MOV AH, 09H			; DESPLEGAR MENSAJE
			LEA DX, CADENA
			INT 21H
			ENDM
			
;***********************************************************************************
; Macro para desplegar una caracter.
;***********************************************************************************
DESPC		MACRO CARACTER
			MOV AH, 02H			; DESPLEGAR MENSAJE
			MOV DL, CARACTER
			INT 21H
			ENDM
			
;***********************************************************************************
; Macro para limpiar una cadena.
;***********************************************************************************
LIMPIAR		MACRO CADENA, LONGITUD
			XOR CX, CX			 
			MOV CX, LONGITUD
			CLD
			LEA SI, LIMPIA		; Cadena vacía
			LEA DI, CADENA
			REP	MOVSB
			ENDM			
;----------------------------------------------------------------------------------------------
; Macro para inicializar el área de datos
;----------------------------------------------------------------------------------------------
INICIO 	   	MACRO			; define macro
			MOV   AX, @DATA           ; inicializar area de datos
			MOV   DS, AX
			MOV   ES, AX
			MOV   AX, 0003H				; modo texto 03h
			INT   10H
			ENDM			; fin macro	

;***********************************************************************************
; Macro para restar variables.
;***********************************************************************************
RESTAM		MACRO MINUENDO, SUSTRAENDO
			PUSHA
			MOV AX, MINUENDO
			SUB AX, SUSTRAENDO
			MOV LONG_COP, AX
			POPA
			ENDM

;***********************************************************************************
; Macro para sumar variables.
;***********************************************************************************
SUMAM		MACRO SUMANDO1, SUMANDO2
			PUSHA
			MOV AX, SUMANDO1
			ADD AX, SUMANDO2
			MOV SUMA, AX
			POPA
			ENDM

;***********************************************************************************
; Macro para dividir variables.
;***********************************************************************************			
DIVIDIR		MACRO DIVIDENDO, DIVISOR
			PUSHA
			MOV BX, DIVISOR
			MOV DX, 0
			MOV AX, DIVIDENDO
			DIV BX
			MOV COCIENTE, AX
			MOV RESIDUO, DX
			POPA
			ENDM
			
;***********************************************************************************
; Macro para "mover de memoria a memoria".
;***********************************************************************************
MOVM 		MACRO SRC, DTN
			PUSH AX
			MOV AX, SRC			; Fuente
			MOV DTN, AX			; Destino
			POP AX
			ENDM

ELIMINAR_STRING	MACRO VECES
			PUSHA
			LOCAL CIC_ELI
			XOR CX, CX
			MOV CL, VECES
CIC_ELI:	CALL BACKSPACE
			LOOP CIC_ELI
			POPA
			ENDM	

IMP_NULLS	MACRO CADENA, APUNTADOR, VECES
			PUSHA
			MOV BX, APUNTADOR
			MOV CX, VECES
			LEA DI, CADENA[BX]
			MOV AL, 00H
			REP STOSB
			POPA
			ENDM

INSERTAR_CAD	MACRO CADENA_COPIAR, LONG_CAD_COP
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CADENA_COPIAR, CADENA_DEST[BX], LONG_CAD_COP
				ADD BX, LONG_CAD_COP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				SUMAM CANT_CAR, LONG_CAD_COP
				MOVM SUMA, CANT_CAR
				SUMAM APUNTADOR_CAD, LONG_CAD_COP
				MOVM SUMA, APUNTADOR_CAD
				POPA
				ENDM
			
	.MODEL SMALL
	.STACK 1024
	.386
;-------------------------------------------------------------------------------------------
; Inicio de Datos
	.DATA


CARACTER_NULL	DB	00H
CARACTER		DB	 '*$'
LONG_CAR		DW, 1
CADENA_DEST		DB	16 DUP (?),'$'
LONG_STRING1	DW	16
CANT_CAR		DW	16
APUNTADOR_CAD	DW 	0
COP_APUNT_CAD	DW	?
COP2_APUNT_CAD	DW	?
CADENA_AUX		DB 	2000 DUP (' '),'$'
LONG_AUX		DW	2000
S_2_INS			DB	'**********','$'
LONG_STRING2	DW	10
LIMPIA			DB	80 DUP (' ')							 ; cadena para limpiar línea.
LONG_COP		DW	?
SUMA			DW  ?
COCIENTE		DW	?
RESIDUO			DW 	?
CADENA_COPIAR	DB	80 DUP (' '), '$'
LONG_CADP		DW	80
APUNT_CORTAR	DW	0
CONT_NULL		DW 	0
FILA_ACTUAL 	DB	?
COL_ACTUAL 		DB	?
NUM_PAG			DB	?
LONG_LINE		DW	80
NUM_LINE		DB	?
STR_TAB			DB 	0H,0H,0H,0H,0H,0H,0H,0H,0H,0FFH,' $'
LONG_TAB		DW	10
CONT_TAB		DW	0
B_NEGRITAS		DB	0
;B_NEGRITAS		DB  2AH ;01011010B
CADENA_PRUEBA	DB  31H,32H,33H,0H,0H,0H,35H,36H,31H,32H,0H,0H,35H,36H,0H,31H,'$'
LONG_STR01		DW	16
CANT_CARP		DW	16
STRING			DB	16 DUP (?),'$'
APUNT			DB 	0

;STRING_NULL		DB	40 DUP (0H), '$'


	.CODE


;----------------------------------------------------------------------------------------------
; Procedimiento auxiliar para borrar el caracter anterior a la posición del apuntador:
; Parámetros: 	CADENA_AUX Y LONG_AUX: cadena donde se insertan los caracteres que no se borrarán.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;				CADENA_DEST: cadena sobre la cual se trabaja durante el programa. 
;----------------------------------------------------------------------------------------------
COP_BS			PROC NEAR
				PUSHA
				LIMPIAR CADENA_AUX, LONG_AUX					
				MOV AX, CONT_NULL								
				SUB APUNTADOR_CAD, AX								; Se coloca el apuntador en la posición adecuada.
				RESTAM CANT_CAR, COP_APUNT_CAD						; Se obtiene la longitud de cadena a copiar.
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP 	;Se copia a la cadena auxiliar
				DEC BX
				MOV APUNTADOR_CAD, BX								; Se mueve el apuntador a la nueva posición.
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP 	;Se copia la cadena auxiliar en la nueva posición.
				LIMPIAR CADENA_AUX, LONG_AUX									
				MOV BX, CANT_CAR
				COPIAR_CAD CARACTER_NULL, CADENA_DEST[BX], 1		; Se inserta un NULL en la última posición de la cadena anterior.
				DEC CANT_CAR
				POPA
				RET
COP_BS			ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento auxiliar para borrar el caracter anterior a la posición del apuntador:
; Parámetros: 	CADENA_AUX Y LONG_AUX: cadena donde se insertan los caracteres que no se borrarán.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;				COP_APUNT_CAD: proveniente del método principal BACKSPACE
;				CADENA_DEST: cadena sobre la cual se trabaja durante el programa. 
;----------------------------------------------------------------------------------------------
COP_BSNULL		PROC NEAR
				PUSHA
NULL_AG:		DEC COP_APUNT_CAD								
				MOV BX, COP_APUNT_CAD
				MOV AL, CADENA_DEST[BX]								; Se compara con 00H en búsqueda de
				CMP AL, 00H											; más NULL por eliminar.
				JNE	SAL_NULL
				INC CONT_NULL
				DEC CANT_CAR
				JMP NULL_AG
SAL_NULL:		MOV CX, CONT_NULL								
				SUMAM CANT_CAR, CONT_NULL
				RESTAM SUMA, APUNTADOR_CAD							; Se obtiene la longitud de cadena a copiar.
				CMP LONG_COP, 0
				JE COP_1
CONTI:			MOV BX, APUNTADOR_CAD								
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP	; Se copia la cadena auxiliar en la nueva posición.
				DEC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				INC BX
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				IMP_NULLS CADENA_DEST, CANT_CAR, CONT_NULL			; Se imprimen los NULL necesarios para eliminar los caracteres.
				POPA
				RET
COP_1:			INC LONG_COP
				JMP CONTI
COP_BSNULL		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para borrar el caracter anterior a la posición del apuntador:
; Parámetros: 	APUNTADOR_CAD: para conocer el caracter a borrar.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;				CADENA_DEST: cadena sobre la cual se trabaja durante el programa. 
;----------------------------------------------------------------------------------------------
BACKSPACE		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				CMP APUNTADOR_CAD, 0								; Se comprueba que no esté en la primera columna y fila
				JE  SALE_BS											; del áreaescritura, si lo está, no ejecuta la acción.
IN_BS:			DEC COP_APUNT_CAD									; Se hace una copia del apuntador para guardar el mismo.
				MOV BX, COP_APUNT_CAD							
				MOV AL, CADENA_DEST[BX]								; Se obtiene el caracter anterior al apuntador, si es NULL
				CMP AL, 00H											; se ejecutan instrucciones para eliminar todos los NULL,
				JE	ELIM_NULL										; de lo contario, se elimina solamente un caracter del String.
				CALL COP_BS
SALE_BS:		POPA
				RET
ELIM_NULL:		MOV CONT_NULL, 0									; Se inicializa CONT_NULL
				INC CONT_NULL										
				DEC CANT_CAR
				CALL COP_BSNULL										
				JMP IN_BS
BACKSPACE		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para borrar caracter donde se encuentra posicionado el apuntador, utiliza a 
; BACKSPACE para su total funcionamiento.
; Parámetros: 	APUNTADOR_CAD: para conocer el caracter a borrar.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;----------------------------------------------------------------------------------------------
SUPRIMIR		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOV AX, CANT_CAR
				CMP COP_APUNT_CAD, AX
				JE SALE_SUPR
				MOV BX, COP_APUNT_CAD
				MOV AL, CADENA_DEST[BX]								; Se compara el caracter de la posición en búsqueda 
				CMP AL, 00H											; de algún NULL, si los hay, se accede a su correcto
				JE SUPR_NULL										; procesamiento.
				CMP AL, 09H											; 01H funciona como caracter indicador de finalizado.
				JE SUPR_NULL
				INC COP_APUNT_CAD
				CALL BACKSPACE
SALE_SUPR:		POPA
				RET
SUPR_NULL:		MOV CONT_NULL, 0									; Se inicializa CONT_NULL
				MOV CADENA_DEST[BX], 01H							; Se sustituye el primer caracter por uno cualquiera.
CONT_N:			MOV AX, APUNTADOR_CAD
				CMP AX, CANT_CAR									; Se corrobora que no haya alcanzado el final del String.
				JE SALE_SUPR
				INC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				MOV AL, CADENA_DEST[BX]								; Se compara en búsqueda de más NULL.
				CMP AL, 00H
				JE CONT_N
				CALL BACKSPACE
				JMP SALE_SUPR
SUPRIMIR		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para borrar caracter donde se encuentra posicionado el apuntador, utiliza a 
; BACKSPACE para su total funcionamiento.
; Parámetros: 	APUNTADOR_CAD: para conocer el caracter a borrar.
;				CONT_NULL: contador de caracteres nullos por suprimir en caso de que existieran.
;				CANT_CAR: contador de caracteres introducidos en el String.
;----------------------------------------------------------------------------------------------
ELIM_STR		PROC NEAR
				PUSHA
				MOV CX, LONG_LINE
CIC_ELI:		CALL SUPRIMIR
				CMP CANT_CAR,0
				JE F_CIC_ELI
				LOOP CIC_ELI
F_CIC_ELI:		POPA
				RET
ELIM_STR		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para guardar una línea de 80 caracteres en un string auxiliar al mismo tiempo que
; la borra del String y mueve toda la cadena.
; Parámetros: 	APUNTADOR_CAD: para conocer el inicio de la línea que se cortará.
;				LONG_LINE: determina la cantidad de caracteres en una línea.
;				CADENA_COPIAR: String donde se guarda la línea cortada, funciona también para 
;					guardar algún String que solamente se haya copiado.
;				LONG_CADP: Largo de la cadena que se ha guardado en CADENA_COPIAR, 80 caracteres.
;----------------------------------------------------------------------------------------------
CORTAR_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_COPIAR, LONG_CADP
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, LONG_CADP
				CALL ELIM_STR
SALE_CUT:		POPA
				RET
CORTAR_CAD		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para guardar una línea de 80 caracteres en un string auxiliar sin borrarlo.
; Parámetros: 	APUNTADOR_CAD: para conocer el inicio de la línea que se cortará.
;				lONG_LINE: determina la cantidad de caracteres en una línea.
;				CADENA_COPIAR: String donde se guarda la línea cortada, funciona también para 
;					guardar algún String que solamente se haya copiado.
;				LONG_CADP: Largo de la cadena que se ha guardado en CADENA_COPIAR, 80 caracteres.
;----------------------------------------------------------------------------------------------
COPIA_CAD		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				LIMPIAR CADENA_COPIAR, LONG_CADP
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_COPIAR, LONG_CADP
				SUMAM APUNTADOR_CAD, RESIDUO
				MOVM SUMA, APUNTADOR_CAD
				POPA
				RET
COPIA_CAD		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para pegar la cadena guardada en alguno de los procedimientos CORTAR_CAD o 
; COPIA_CAD. La copia en la dirección determinada por el apuntador de la cadena.
; Parámetros: 	APUNTADOR_CAD: para conocer el inicio donde se pegará el String.
;				lONG_LINE: determina la cantidad de caracteres en una línea.
;				CADENA_COPIAR: String donde se guarda la línea cortada, funciona también para 
;					guardar algún String que solamente se haya copiado.
;				LONG_CADP: Largo de la cadena que se ha guardado en CADENA_COPIAR, 80 caracteres.
;----------------------------------------------------------------------------------------------
PEGA_CAD		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOV AX, LONG_STRING1
				SUMAM CANT_CAR, LONG_CADP
				CMP SUMA, AX
				JA SALE_PEGA
				MOV BX, APUNTADOR_CAD
				RESTAM CANT_CAR, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CADENA_COPIAR, CADENA_DEST[BX], LONG_CADP
				ADD BX, LONG_CADP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				SUMAM CANT_CAR, LONG_CADP
				MOVM SUMA, CANT_CAR
				SUMAM APUNTADOR_CAD, LONG_CADP
				MOVM SUMA, APUNTADOR_CAD
SALE_PEGA:		POPA
				RET
PEGA_CAD		ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la izquierda del String. Si está al principio del mismo,
; no realiza ninguna acción. Si está al principio de una línea, se mueve a la anterior, si es 
; ENTER, se mueve al principio de la línea, si hay tabuladores, al final de los mismos.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;----------------------------------------------------------------------------------------------
MOVC_IZ			PROC NEAR
				PUSHA
FIND_ASCII:		CMP APUNTADOR_CAD, 0
				JE SALE_IZ
				DEC APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H
				JE FIND_ASCII
SALE_IZ:		POPA
				RET
MOVC_IZ			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la derecha del String. Si está al final del mismo,
; no realiza ninguna acción. Si está al final de una línea, se mueve a la siguiente, si es 
; ENTER, se mueve al principio de la línea, si hay tabuladores, al principio de los mismos.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
MOVC_DER		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
BUSCAR_ASCII:	MOV AX, LONG_STRING1
				CMP COP_APUNT_CAD, AX
				JE REG_APUNT
				MOV AX, CANT_CAR
				CMP COP_APUNT_CAD, AX
				JE REG_APUNT
				INC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE BUSCAR_ASCII
				MOVM COP_APUNT_CAD, APUNTADOR_CAD
SALE_DER:		POPA
				RET
REG_APUNT:		MOVM APUNTADOR_CAD, APUNTADOR_CAD
				JMP SALE_DER
MOVC_DER		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para obtener el ASCII más cercano distinto de 00H. 
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				CONT_TAB: Cuenta la cantidad de NULLS hacia la izquierda para determinar el
;					ASCII más cercano al apuntador.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
DISTANCIA_MENOR PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
MOV_IZ:			CMP CONT_TAB,5
				JE C_DER
				INC COP_APUNT_CAD
				INC CONT_TAB
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE MOV_IZ
SALE_MEN:		MOVM COP_APUNT_CAD, APUNTADOR_CAD
				MOV CONT_TAB, 0
				POPA
				RET
C_DER:			DEC COP_APUNT_CAD
				MOV BX, COP_APUNT_CAD
				CMP CADENA_DEST[BX], 00H
				JE C_DER
				JMP SALE_MEN
DISTANCIA_MENOR ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la linea anterior del String. Si se desplaza hacia un NULL,
; busca el ASCII más cercano hacia su derecha o izquierda. Si está en la primera línea, no realiza 
; acción alguna. 
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				LONG_LINE: largo de la línea. 80 caracteres.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
MOVC_UP			PROC NEAR
				PUSHA
				MOV AX, LONG_LINE
				CMP APUNTADOR_CAD, AX
				JB SALE_UP
				RESTAM APUNTADOR_CAD, LONG_LINE
				MOVM LONG_COP, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H
				JE BUSC_ASCII
SALE_UP:		POPA
				RET
BUSC_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_UP
MOVC_UP			ENDP

; CONDICIÓN: EL ENTER DEBE COLOCAR UN ASCII CUALQUIERA AL INICIO DE LA LÍNEA. TAB LO COLOCA ANTES Y
; DEBE SER PAR.
;----------------------------------------------------------------------------------------------
; Procedimiento para desplazarse hacia la siguiente línea del String. Si se desplaza hacia un NULL,
; busca el ASCII más cercano hacia su derecha o izquierda. Si está en la última línea, no realiza 
; acción alguna. Si se dirige a una posición mayor a los caracteres ingresados, regresa al último
; caracter del String.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				LONG_STRING1: Capacidad total del String. 
;				CANT_CAR: Cantidad de caracteres ingresados por el usuario hasta el momento.
;				LONG_LINE: largo de la línea. 80 caracteres.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
MOVC_DOWN		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				SUMAM COP_APUNT_CAD, CANT_CAR
				MOV AX, LONG_STRING1
				CMP SUMA, AX
				JA SALE_DOWN
				MOV AX, CANT_CAR
				CMP APUNTADOR_CAD, AX
				JB ULTIMO
				SUMAM APUNTADOR_CAD, LONG_LINE
				MOVM SUMA, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				CMP CADENA_DEST[BX], 00H
				JE BUS_ASCII
SALE_DOWN:		POPA
				RET
BUS_ASCII:		CALL DISTANCIA_MENOR
				JMP SALE_DOWN
ULTIMO:			MOVM CANT_CAR, APUNTADOR_CAD
				JMP SALE_DOWN
MOVC_DOWN		ENDP

;----------------------------------------------------------------------------------------------
; Procedimiento para insertar 10 espacios en el String, simulando un tabulador. El primer y último
; espacio es distinto a NULL para poder ubicarlo en el String. Si al insertarlo es mayor a la 
; longitud del String, no se inserta.
; Parámetros: 	APUNTADOR_CAD: para conocer la posición en el String. 
;				COP_APUNT_CAD: copia para auxiliar al apuntador definitivo del String.
;				LONG_STRING1: Capacidad total del String. 
;				CANT_CAR: Cantidad de caracteres ingresados por el usuario hasta el momento.
;				LONG_LINE: largo de la línea. 80 caracteres.
;				CADENA_DEST: String principal del programa.
;----------------------------------------------------------------------------------------------
TABULADOR		PROC NEAR
				PUSHA
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				DIVIDIR COP_APUNT_CAD, LONG_LINE
				MOV AX, CANT_CAR
				SUMAM APUNTADOR_CAD, LONG_TAB
				CMP SUMA, AX
				JA SALE_TAB
				RESTAM LONG_LINE, RESIDUO
				MOV AX, LONG_COP
				CMP LONG_COP, 0
				JE LINE_DOWN
				CMP LONG_TAB, AX
				JA INS_NULL
				INSERTAR_CAD STR_TAB, LONG_TAB
SALE_TAB:		POPA
				RET
LINE_DOWN:		CALL MOVC_DER
				INSERTAR_CAD STR_TAB, LONG_TAB
				JMP SALE_TAB
INS_NULL:		CALL INSERTAR_NULL
				JMP SALE_TAB
TABULADOR		ENDP

INSERTAR_NULL	PROC NEAR
				PUSHA
				MOV AX, APUNTADOR_CAD								; Si está al final del String, no ejecuta la acción.
				CMP AX, LONG_STRING1
				JE SALE_NULL
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CARACTER_NULL, CADENA_DEST[BX], LONG_COP
				ADD BX, LONG_COP
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				INC CANT_CAR
SALE_NULL:		POPA
				RET
INSERTAR_NULL	ENDP

INSERTAR_C 		PROC NEAR
				PUSHA
				MOV AX, APUNTADOR_CAD								; Si está al final del String, no ejecuta la acción.
				CMP AX, LONG_STRING1
				JE SALE_C
				LIMPIAR CADENA_AUX, LONG_AUX
				RESTAM CANT_CAR, APUNTADOR_CAD
				MOV BX, APUNTADOR_CAD
				COPIAR_CAD CADENA_DEST[BX], CADENA_AUX, LONG_COP
				COPIAR_CAD CARACTER, CADENA_DEST[BX], 1
				COPIAR_CAD CADENA_AUX, CADENA_DEST[BX+1], LONG_COP
				LIMPIAR CADENA_AUX, LONG_AUX
				INC CANT_CAR
SALE_C:			POPA
				RET
INSERTAR_C		ENDP

HOME_STR		PROC NEAR
				PUSHA
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				RET
				POPA
HOME_STR		ENDP

END_STR			PROC NEAR
				PUSHA
				RESTAM LONG_STRING1, APUNTADOR_CAD
				MOV AX, LONG_LINE
				CMP AX, LONG_COP
				JAE I_CANT_CAR
				DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM LONG_LINE, RESIDUO
				SUMAM APUNTADOR_CAD, LONG_COP
				MOVM SUMA, APUNTADOR_CAD
				DEC APUNTADOR_CAD
SALE_END:		POPA
				RET
I_CANT_CAR:		MOVM CANT_CAR, APUNTADOR_CAD
				JMP SALE_END
END_STR			ENDP	

NEGRITAS		PROC NEAR
				PUSHA
				MOV DL, 00010111B
				CMP B_NEGRITAS,0
				JE AC_NEGRITAS
IN_NEG:			DIVIDIR APUNTADOR_CAD, LONG_LINE
				RESTAM APUNTADOR_CAD, RESIDUO
				MOVM LONG_COP, APUNTADOR_CAD
				MOV CX, LONG_LINE
				MOVM APUNTADOR_CAD, COP_APUNT_CAD
				MOVM LONG_LINE, COP_APUNT_CAD
				DEC COP_APUNT_CAD
SIG_CAR:		MOV BX, COP_APUNT_CAD
				MOV AH, 09H
				MOV AL, CADENA_DEST[BX]
				MOV BH, 0
				MOV BL, DL
				INT 10H
				DEC COP_APUNT_CAD
				LOOP SIG_CAR			
				POPA
				RET
AC_NEGRITAS:	OR DL, 00001000B
				JMP IN_NEG				
NEGRITAS		ENDP

;--------------------------------------------------------------------------------------------
; Necesita pasar a STRING, la cadena a renderizar, y en CANT_CAR, cantidad de caracteres de
; de dicha cadena.
;--------------------------------------------------------------------------------------------

REND_CAD		PROC  NEAR
				LEA   SI, CADENA_DEST
RECORRER:		LODSB
				INC APUNTADOR_CAD
				CMP	  AL, 00H
				JE    SUP
CONTINUAR:		MOV   BX, CANT_CAR
				DEC	  BX
				LEA   DX, STRING[BX]
				CMP   DX, SI
				JAE	  RECORRER
				RET
SUP:			DEC   APUNTADOR_CAD
				CALL  SUPRIMIR
				JMP   CONTINUAR
REND_CAD		ENDP










MAIN PROC FAR

		INICIO
		;DESP CADENA_DEST
		;CALL INSERTAR_C
		;INSERTAR_CAD S_2_INS, LONG_STRING2
		;CALL BACKSPACE
		;CALL SUPRIMIR
		;CALL CORTAR_CAD
		;CALL TABULADOR
		;CALL MOVC_UP
		;CALL MOVC_DOWN
		;CALL MOVC_IZ
		;CALL BACKSPACE
		;CALL SUPRIMIR
		;CALL COPIA_CAD
		;CALL PEGA_CAD
		;DESP CADENA_COPIAR
		;INSERTAR_CAD CARACTER, LONG_CAR
		;DESP CADENA_PRUEBA
		;MOV APUNTADOR_CAD, 00
		;CALL INSERTAR_C
		;CALL INSERTAR_C
		;CALL INSERTAR_C
		;CALL INSERTAR_C
		;CALL INSERTAR_C
		;CALL TABULADOR
		;SET_CUR 00, 00, 00
		;CALL NEGRITAS
		;SET_CUR 00, 00, 24
		;MOV AH, 09H
		;MOV AL, 2AH
		;MOV BH, 0
		;MOV BL, 01011010B
		;MOV CX, 5
		;INT 10H
		;CALL MOVC_UP
		;CALL MOVC_UP
		;CALL HOME_STR
		;CALL END_STR
		;CALL MOVC_IZ
		;CALL MOVC_DER
		;CALL INSERTAR_C
		;DESP CADENA_DEST
		;DESP CADENA_COPIAR
		;MOVM CANT_CARP, CANT_CAR
		COPIAR_CAD CADENA_PRUEBA, CADENA_DEST, 16
		CALL REND_CAD
		DESP CADENA_DEST
		

		MOV   AX, 4C00H		;salida al DOS
		INT   21H
MAIN 	ENDP
;-----------------------------------------------------------------------------------------------------
		END MAIN
