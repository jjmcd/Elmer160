;	Less17 - Test program for Lesson 17 on LCD's
;
;	JJMcD - 14-May-05
;	$Revision: 1.3 $ $Date: 2011-12-21 21:21:34-05 $
			include		P16F628A.INC
			__config	_XT_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _BOREN_OFF

			extern		LCDinit,LCDclear,LCDaddr,LCDletr
			extern		Del128ms
	
PB1			equ			4
PB2			equ			3
PB3			equ			2

STARTUP		code
			goto		Start

			code
Start
			errorlevel	-302		; Initialize PORTA to
			banksel		TRISA		; be inputs (actually,
			movlw		H'ff'		; somewhat redundant)
			movwf		TRISA
			banksel		PORTA
			errorlevel	+302
			movlw		H'07'
			movwf		CMCON
			call		LCDinit		; Initialize the LCD
			call		LCDclear	; and clear it
Loop
			movlw		H'3'		; Position cursor to
			call		LCDaddr		; PB1 location
			movlw		"-"			; Default character
			btfss		PORTA,PB1	; PB1 pressed?
			movlw		"1"			; Yes, make it a 1
			call		LCDletr		; Display the character

			movlw		H'7'
			call		LCDaddr
			movlw		"-"
			btfss		PORTA,PB2
			movlw		"2"
			call		LCDletr

			movlw		H'43'
			call		LCDaddr
			movlw		"-"
			btfss		PORTA,PB3
			movlw		"3"
			call		LCDletr

			movlw		H'09'
			call		LCDaddr

			call		Del128ms

			goto		Loop

			end
