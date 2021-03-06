;	Less17g.asm - Mainline to test scrolling display
;
;	JJMcD - 2005-04-26
;	$Revision: 1.1 $ $Date: 2005-04-26 14:26:46-04 $
			include		Processor.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF
			extern		LCDinit,LCDletr,LCDclear
			extern		Del1s
			extern		Msg1,Msg2

STARTUP		code
			goto		Start
			code
Start
			call		LCDinit			; Initialize the LCD
Loop
			call		Msg1			; Display message 1
			call		Del1s			; Wait a second so we can see it
			call		LCDclear		; Clear the display
			call		Msg2			; Display message 2
			call		Del1s			; Wait a second again
			call		LCDclear		; Clear the display
			goto		Loop			; Do it again

			end
