#ifdef never
/*! \file LCDzero.asm

 \brief Set the LCD DDRAM address to zero.

 Provides the function LCDzero.  Requires the functions
 LCDsndI, Del40us and Del2ms.

*/

/*! \function LCDzero.asm

 \brief Set the LCD DDRAM address to zero


 LCDzero is called when it is desired to begin a new display on the
 LCD.  The DDRAM address, which affects where the next character will
 be written, is set to zero which is the first position on the LCD.

 The W register is not preserved and is ignored.
*/
#endif

		include		"LCDMacs.inc"

	; Provided Routines
		global		LCDzero
	; Required routines
		extern		LCDsndI
		extern		Del40us
		extern		Del2ms

; ------------------------------------------------------------------------
	; Set the LCD DDRAM address to zero
		code
LCDzero:
		LCD16	H'08',H'00'
		return

		end
