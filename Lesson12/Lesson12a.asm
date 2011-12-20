; Lesson12a.asm - demonstration of basic I/O
; Turns on LED1 when PB1 is pressed
;
;  WB8RCR - 21-Feb-04
;
		processor	pic16f628a
		include		"P16F628A.INC"
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF
		list		b=4,n=70

;=====================================================================
;	Manifest Constants
;=====================================================================
LED1	equ			H'03'			; PORTA bit number for LED
PB1		equ			H'04'			; PORTB bit number for button
MASKA	equ			B'11111111'		; PORTA all inputs
MASKB	equ			B'00000000'		; PORTB all outputs

;=====================================================================
;	File register use
;=====================================================================
		cblock		H'20'
			Buttons					; Storage for inputs
			LEDs					; Storage for outputs
		endc

		nop
		goto		start			; Skip over interrupt vector
		org		H'05'

;=====================================================================
;  Mailine begins here -- Initialization
;=====================================================================
start
		errorlevel	-302
		banksel		TRISA			; Set PORTA to be all inputs
		movlw		MASKA			; (somewhat redundant since
		movwf		TRISA			;(reset does this anyway)
		banksel		TRISB
		movlw		MASKB			; Set PORTB to be all outputs
		movwf		TRISB
		banksel		PORTB
		errorlevel	+302

		movlw		B'00000111'		; Comparators normal I/O
		movwf		CMCON

		movlw		B'00001110'		; Turn off all LEDs
		movwf		PORTB

		movlw		B'00001110'		; Initialize outputs to all off
		movwf		LEDs			;

;=====================================================================
; Main program loop here
;=====================================================================

main

;---------------------------------------------------------------------
;	Get inputs
;---------------------------------------------------------------------
		movf		PORTA,W			; Get the inputs from PORTA
		movwf		Buttons			; Save them away

;---------------------------------------------------------------------
;	Do Calculations
;---------------------------------------------------------------------
		btfss		Buttons,PB1		; Is PB1 pressed?
		goto		LEDon			; Yes
		bsf		LEDs,LED1		; No, turn off LED1
		goto		LEDoff			; Skip over turn on LED
LEDon							; Output low = LED on
		bcf		LEDs,LED1		; Yes, turn on LED1
LEDoff

;---------------------------------------------------------------------
;	Set outputs
;---------------------------------------------------------------------
		movf		LEDs,W			; Pick up the output storage
		movwf		PORTB			; And send it to the world

		goto		main			; Play it again, Sam

		end
