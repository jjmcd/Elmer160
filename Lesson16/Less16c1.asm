; Less16c1.asm
;
;	Delay subroutine with two loop counters.  Used to demonstrate
;	linking with overlaid data.
;
;	WB8RCR - 18-Nov-04
;	$Revision: 1.2 $ $Date: 2005-01-20 16:32:44-05 $
;===========================================================
			global		Sub1

Counters	udata_ovr
Loopc1		res			1
Loopc2		res			1

			code
Sub1
			movlw		5
			movwf		Loopc1
Loop1
			movlw		3
			movwf		Loopc2
Loop2
			decfsz		Loopc2,F
			goto		Loop2
			decfsz		Loopc1,F
			goto		Loop1

			return
			end
