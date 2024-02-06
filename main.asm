;******************************************************************************
; Universidad del Valle de Guatemala
; Programación de Microcrontroladores
; Proyecto: Laboratorio Contador
; Archivo: Contador_Laboratoio_1_Progra_de_Micro.asm
; Hardware: ATMEGA328p
; Created: 30/01/2024 18:11:46
; Author : amola
;******************************************************************************
; Encabezado: Consiste en realizar un contador binario de 4 Bits. 2 pushbottons
; para aumentar y 2 para decrementar
;******************************************************************************

.include "M328PDEF.inc" ; para reconozer los nombres de los registros
.cseg ; indica que lo que viene después es el segmento de código
.org 0x00 ; establecemos la dirección en posición 0
;******************************************************************************
; stack pointer
;******************************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16 
LDI R17, HIGH(RAMEND)
OUT SPH, R17
;******************************************************************************
; Configuración
;******************************************************************************
Setup:
LDI R16, (1 << CLKPCE)
STS CLKPR, R16 ;HABILITAMOS EL PRESCALER

LDI R16, 0b0000_0011
STS CLKPR, R16 ;DEFINIMOS UNA FRECUENCIA DE 2MGHz

LDI R16, 0b0001_1111 ; CONFIGURAMOS LOS PULLUPS 
OUT PORTC, R16	; HABILITAMOS LOS PULLUPS
LDI R18, 0b0000_0000
OUT DDRC, R18

LDI R16, 0b1111_1111	;HABILITAMOS LAS SALIDAS 
OUT DDRD, R16
LDI R16, 0b0001_1111
OUT DDRB, R16

LDI R16, 0b0000_0000 ; INDICAMOS UN VALOR INICIAL PARA LAS SALIDAS
OUT PORTD, R16
;PARA OPERACIONES LÓGICAS
LDI R18, 0B0000_0000 ;incrementa y decrementa
LDI R22, 0B0000_0000
LDI R21, 0B0000_0000
LDI R19, 0b0000_1111
LDI R20, 0b1111_0000
CLR R18
CLR R17
CLR R22
CLR R21

Loop:

IN R16, PINC ;CONFIGURAMOS EL PINC EN LA POSICION 0 PRA QUE TENGA DE SALLIDA 
;CONTADOR 1
SBRS R16, PC0 ;INCREMENTO
RJMP ANTIREBOTE1
OUT PORTD, R17

SBRS R16, PC1 ;DECREMETNO
RJMP ANTIREBOTE2
OUT PORTD, R17
;CONTADOR 2
SBRS R16, PC2 ;INCREMENTO
RJMP ANTIREBOTE3
OUT PORTD, R17

SBRS R16, PC3 ;DECREMENTO
RJMP ANTIREBOTE4
OUT PORTD, R17

	RJMP Loop
;******************************************************************************
; Subrutinas
;******************************************************************************
;ESPERAMOS UN BREVE TIEMPO 
ANTIREBOTE1: ; INCREMENTO 1
LDI R16, 100
DELAY:
	DEC R16
	BRNE DELAY ; SI NO ES IGUAL A CERO, RECGRESA 

SBIS PINC, PC0
RJMP ANTIREBOTE1
INC R18
AND R18, R19
MOV R17, R18

RJMP Loop


ANTIREBOTE2: ;DECREMENTO 1
LDI R16, 100
DELAY2:
	DEC R16
	BRNE DELAY2 ; SI NO ES IGUAL A CERO, RECGRESA 

SBIS PINC, PC1
RJMP ANTIREBOTE2
DEC R18
AND R18, R19
MOV R17, R18


RJMP Loop

;CONTADOR 2
ANTIREBOTE3: ; INCREMENTO 2
LDI R16, 100
DELAY3:
	DEC R16
	BRNE DELAY3 ; SI NO ES IGUAL A CERO, RECGRESA 

SBIS PINC, PC2
RJMP ANTIREBOTE3
INC R22
MOV R21, R22
SWAP R21
OR R17, R21

RJMP Loop

ANTIREBOTE4: ; INCREMENTO 2
LDI R16, 100
DELAY4:
	DEC R16
	BRNE DELAY4 ; SI NO ES IGUAL A CERO, RECGRESA 

SBIS PINC, PC3
RJMP ANTIREBOTE4
DEC R22
MOV R21, R22
SWAP R21
OR R17, R21

RJMP Loop
/////////////////////////////////////////////////////