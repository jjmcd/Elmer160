; Lesson12c.asm - demonstration of basic I/O with Macros
;
;  WB8RCR - 21-Feb-04
;=====================================================================

		processor	pic16f628a
		include		"P16F628A.INC"
		__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF
		list		b=4,n=70

;=====================================================================
;	Macro definitions
;=====================================================================
ChkBut	macro		Button,LED
		btfss		Buttons,Button	; Is PB pressed?
		goto		$+3			; Yes
		bsf		LEDs,LED		; No, turn off LED
		goto		$+2
		bcf		LEDs,LED		; Yes, turn on LED
		endm

;=====================================================================
;	Manifest Constants
;=====================================================================
LED1	equ			H'03'			; PORTA bit number for LED
LED2	equ			H'02'			; PORTA bit number for LED
LED3	equ			H'01'			; PORTA bit number for LED
PB1	equ			H'04'			; PORTB bit number for button
PB2	equ			H'03'			; PORTB bit number for button
PB3	equ			H'02'			; PORTB bit number for button
MASKA	equ			B'11111111'		; PORTA all inputs
MASKB	equ			B'00000000'		; PORTB all outputs

;=====================================================================
;	File register use
;=====================================================================
		cblock		H'20'
			Buttons					; Storage for inputs
			LEDs					; Storage for outputs
		endc


		goto		start			; Skip over interrupt vector
		org		H'05'

;=====================================================================
;  Mailine begins here -- Initialization
;=====================================================================
start
		errorlevel	-302
		banksel		TRISA			; Set PORTA to be all inputs
		movlw		MASKA			; (somewhat redundant since
		movwf		TRISA			; reset does this anyway)
		banksel		TRISB			; (This is actually redundant, too)
		movlw		MASKB			; Set PORTB to be all outputs
		movwf		TRISB
		banksel		PORTB
		errorlevel	+302

		movlw		h'07'
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

		ChkBut		PB1,LED1
		ChkBut		PB2,LED2
		ChkBut		PB3,LED3

;---------------------------------------------------------------------
;	Set outputs
;---------------------------------------------------------------------
		movf		LEDs,W			; Pick up the output storage
		movwf		PORTB			; And send it to the world

		goto		main			; Play it again, Sam

		end
