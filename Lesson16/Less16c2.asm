; Less16c2.asm
;
;	Delay subroutine with two loop counters.  Used to demonstrate
;	linking with overlaid data.
;
;	WB8RCR - 18-Nov-04
;	$Revision: 1.2 $ $Date: 2005-01-20 16:33:08-05 $
;===========================================================
			global		Sub2

Counters	udata_ovr
Loopc3		res			1
Loopc4		res			1

			code
Sub2
			movlw		5
			movwf		Loopc3
Loop1
			movlw		3
			movwf		Loopc4
Loop2
			decfsz		Loopc4,F
			goto		Loop2
			decfsz		Loopc3,F
			goto		Loop1

			return
			end
