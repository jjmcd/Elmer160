; Less16b2.asm
;
;	Simple subroutine to demonstrate linking.  Pick up
;	a variable stored by another subroutine.
;
;	WB8RCR - 16-Nov-04
;	$Revision: 1.2 $ $Date: 2005-01-20 16:23:36-05 $
;===========================================================

		global		Sub2
		extern		Shared

		code
Sub2
		movf		Shared,W
		return

		end
