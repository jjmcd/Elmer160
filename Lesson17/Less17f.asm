;	Less17f.asm - Mainline to test display addressing
;
;	JJMcD - 2005-04-26
;	$Revision: 1.1 $ $Date: 2005-04-26 15:14:42-04 $
			include		Processor.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
			extern		LCDinit,LCDletr,LCDclear,LCDaddr
			extern		Del1s, Del256ms

STARTUP		code
			goto		Start
			code
Start
			call		LCDinit			; Initialize the LCD
Loop
			call		LCDclear		; Clear the display

	; Now we will display "7.040MHz" on the display in a strange order:
			movlw		H'04'			; ____0___
			call		LCDaddr
			movlw		'0'
			call		LCDletr
			call		Del256ms

			movlw		H'02'			; __0_0___
			call		LCDaddr
			movlw		'0'
			call		LCDletr
			call		Del256ms

			movlw		H'07'			; __0_0__z
			call		LCDaddr
			movlw		'z'
			call		LCDletr
			call		Del256ms

			movlw		H'01'			; _.0_0__z
			call		LCDaddr
			movlw		'.'
			call		LCDletr
			call		Del256ms

			movlw		H'05'			; _.0_0M_z
			call		LCDaddr
			movlw		'M'
			call		LCDletr
			call		Del256ms

			movlw		H'00'			; 7.0_0M_z
			call		LCDaddr
			movlw		'7'
			call		LCDletr
			call		Del256ms

			movlw		H'06'			; 7.0_0MHz
			call		LCDaddr
			movlw		'H'
			call		LCDletr
			call		Del256ms

			movlw		H'03'			; 7.040MHz
			call		LCDaddr
			movlw		'4'
			call		LCDletr
			call		Del256ms

			movlw		H'08'			; Move cursor off the
			call		LCDaddr			; display
			call		Del1s			; And wait a while
			goto		Loop			; Do it again

			end
