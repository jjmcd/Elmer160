		title		'Del128ms - Delay 512 milliseconds (approximately)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  Del512ms
;
;  Delay 512 millisecond (approximately).
;
;  This function delays for 512 milliseconds.  The W
;  register is ignored.  The contents of the W register
;  are destroyed.
;**
;  WB8RCR - 25-Sep-04
;  $Revision: 1.37 $ $Date: 2005-06-23 13:22:52-04 $

			global		Del512ms

			extern		Del256ms

LCDLIB		code
; ------------------------------------------------------------------------
;  Wait for 1/2 second
Del512ms:
		call		Del256ms	; 
		call		Del256ms	; 
		return

		end
