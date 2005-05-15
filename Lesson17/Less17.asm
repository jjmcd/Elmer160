;	Less17 - Test program for Lesson 17 on LCD's
;
;	JJMcD - 14-May-05
;	$Revision: 1.1 $ $Date: 2005-05-14 16:27:52-04 $
			include		p16f84a.inc
			__config	_XT_OSC & _WDT_OFF & _PWRTE_ON

			extern		Msg1,Msg2,Msg3
			extern		LCDinit,LCDclear
			extern		Del1s

STARTUP		code
			goto		Start

			code
Start
			call		LCDinit			; Initialize the LCD
Loop
			call		Msg1			; Display the 'Pig' message
			call		Del1s			; Wait a second to see it
			call		LCDclear		; Clear the LCD
			call		Del1s			; Wait a second to see it

			call		Msg2			; Display the 'Elecraft' message
			call		Del1s			; Wait a second to see it
			call		LCDclear		; Clear the LCD
			call		Del1s			; Wait a second to see it

			call		Msg3			; Display the 'Watson' message
			call		Del1s			; Wait a second to see it
			call		LCDclear		; Clear the LCD
			call		Del1s			; Wait a second to see it

			goto		Loop			; Do it again

			end
