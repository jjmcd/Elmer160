; Less16b1.asm
;
;	Simple subroutine to demonstrate linking.  Pick up
;	a variable stored by another subroutine.
;
;	WB8RCR - 16-Nov-04
;	$Revision: 1.1 $ $Date: 2004-11-16 11:24:42-05 $
;===========================================================

		global		Sub2
		extern		Shared

		code
Sub2
		movf		Shared,W
		return

		end
