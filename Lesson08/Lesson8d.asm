;	Lesson8d.asm - 
;	28-Jan-2003
;
		list		b=4
		processor	pic16f84a
		include		<p16f84a.inc>
		__config	_XT_OSC & _PWRTE_ON & _WDT_OFF

		cblock		H'3d'
			Bank0
			Bank1
		endc
PB1		equ			D'4'
LED1	equ			D'3'

		goto		Start

;	Mainline starts here
Start
		; PORTB connections as follows:
		;
		;  RB0 - LCD DB4 / PB4
		;  RB1 - LCD DB5 / LED1
		;  RB2 - LCD DB6 / LED2
		;  RB3 - LCD DB7 / LED3
		;  RB4 - HD44780 Enable
		;  RB5 - HD44780 Read/Write (1=read)
		;  RB6 - HD44780 Register Select (1=data, 0=instruction)
		;  RB7 - Xmtr / DDS

		movlw		B'00000000'		; All bits as output
		banksel		TRISB			; Select Bank 1
		errorlevel	-302			; Supress stupid error
		movwf		TRISB			; Set tristate mode
		errorlevel	+302			; Re-enable stupid error
		banksel		PORTB			; Select Bank 0
		movlw		B'00100000'		; w := !LCDRS | LCDRW | !LCDEN
		movwf		PORTB			; port B itself := w

		; PORTA connections as follows:
		;
		;  RA0 - Enc1 
		;  RA1 - Enc2
		;  RA2 - PB3 / Piezo
		;  RA3 - PB2 / Dit
		;  RA4 - TMR0/ PB1 / Dah

		movlw		B'00011011'		; Spkr output, others as input
		banksel		TRISA			; Select Bank 1
		errorlevel	-302			; Suppress error
		movwf		TRISA			; Set mode for the pins
		errorlevel	+302			; Restore message
		banksel		PORTA			; Select Bank 0
		movlw		B'00000100'		; This is somewhat reduntant
		movwf		PORTA			; since all bits are inputs

Loop
		btfsc		PORTA,PB1		; Button pressed?
		goto		Up				; No, go to button up
		bcf			PORTB,LED1		; Yes, turn on LED
		goto		Loop			; Do it again
Up
		bsf			PORTB,LED1		; Turn off LED
		goto		Loop			; Play it again, Sam

		end
