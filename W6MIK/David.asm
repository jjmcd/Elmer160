; -----------W6MIK's  Test Program-------------
; Lesson8a.asm - Test MPLAB stimulus - RA0 and RB0 
; Feb 2-2004
;=================================================================================
;
        processor                 pic16f84a
        include                         <p16f84a.inc>
        __config _XT_OSC & _PWRTE_ON & _WDT_OFF
;=================================================================================
;---------------------------------------------------------------------------------
Loop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

		goto Loop
		end
