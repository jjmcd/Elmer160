		title		'Del256ms - Delay 256 milliseconds (approximately)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  Del256ms
;
;  Delay 256 millisecond (approximately).
;
;  This function delays for 256 milliseconds.  The W
;  register is ignored.  The contents of the W register
;  are destroyed.
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:10-04 $

			global		Del256ms
			extern		Del128ms

LCDLIB		code
; ------------------------------------------------------------------------
	; Waste a lot of time

Del256ms:
		call		Del128ms
		call		Del128ms
		return

		end
