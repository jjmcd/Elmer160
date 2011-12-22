;	Less17e.asm - Mainline to test clear display
;
;	JJMcD - 2005-04-26
;	$Revision: 1.1 $ $Date: 2011-12-21 21:52:37-05 $
			include		Processor.inc
			__config	_XT_OSC & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _BOREN_OFF
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
