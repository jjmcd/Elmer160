;	Less17 - Test program for Lesson 17 on LCD's
;
;	JJMcD - 14-May-05
;	$Revision: 1.2 $ $Date: 2005-08-07 10:36:34-04 $
			include		p16f84a.inc
			__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

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
