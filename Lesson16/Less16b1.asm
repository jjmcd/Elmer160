; Less16b1.asm
;
;	Simple subroutine to demonstrate linking.  Provide
;	storage for a variable to be used by another routine.
;
;	WB8RCR - 16-Nov-04
;	$Revision: 1.2 $ $Date: 2004-11-16 11:30:54-05 $
;===========================================================

		global		Sub1
		global		Shared

		udata
Shared	res			1

		code
Sub1
		movwf		Shared
		return

		end
