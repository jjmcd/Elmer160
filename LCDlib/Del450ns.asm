		title		'Del450ns - Delay 450 nanoseconds (approximately)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  Del40us
;
;  Delay 450 nanoseconds (approximately).
;
;  This function delays for a very short time.
;  The actual delay is dependent on the processor
;  speed but is at least 450 nanoseconds.
;
;  The W register is ignored.  The contents of the 
;  W register are preserved.
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.31 $ $Date: 2005-03-05 09:49:12-05 $

	; Provided Routines
		global		Del450ns

LCDLIB	code
; ------------------------------------------------------------------------
	; Waste 450ns for the enable pulse width,  only
	; need 4.5 clock cycles, so the call and return
	; should more than do it  (4 clock cycles/instruction)
	; but it turns out we need the NOP.

Del450ns:
		NOP
		NOP
		NOP
		return
		end
