; Less16a1.asm
;
;	Simple subroutine to demonstrate linking.  Merely
;	complements the contents of the W register
;
;	WB8RCR - 29-Oct-04
;	$Revision: 1.3 $ $Date: 2004-11-16 10:02:52-05 $
;===========================================================

		processor	pic16f84a
		include		p16f84a.inc

;	Define the global entry point so the linker can see it
		global		aSub

		code
aSub
		xorlw		h'ff'	; Only complement the contents
		return				; of W and return

		end
