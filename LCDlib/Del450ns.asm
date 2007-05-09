		title		'Del450ns - Delay 450 nanoseconds (approximately)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off
		include		LCDMacs.inc

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
;  $Revision: 2.0 $ $Date: 2007-05-09 11:24:48-04 $

	; Provided Routines
		global		Del450ns

LCDLIB	code
; ------------------------------------------------------------------------
	; Waste 450ns for the enable pulse width,  only
	; need 4.5 clock cycles, so the call and return
	; should more than do it  (4 clock cycles/instruction)
	; but it turns out we need the NOP.
	;
	;	 4 MHz	4000 ns		(including call)
	;	10 MHz	2000 ns
	;	20 MHz	1200 ns

Del450ns:
	IF PROCSPEED > 4
		NOP
	  IF PROCSPEED > 10
		NOP
	  ENDIF
	ENDIF
		return
		end
