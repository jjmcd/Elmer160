			title			'Del1s - Delay one second (approximately)'
			subtitle		'Part of the LCDlib library'
			list			b=4,c=132,n=77,x=Off

;**
;  Del1s
;
;  Delay one second (approximately).
;
;  This function waits for just over one second.  The W
;  register is ignored.  The contents of the W register
;  are destroyed.
;**
;  WB8RCR - 25-Sep-04
;  $Revision: 1.32 $ $Date: 2005-03-18 13:14:16-04 $

			global		Del1s
			extern		Del128ms

LCDLIB		code

; ------------------------------------------------------------------------
;  Delay 1 second
Del1s
		call		Del128ms
		call		Del128ms
		call		Del128ms
		call		Del128ms
		call		Del128ms
		call		Del128ms
		call		Del128ms
		call		Del128ms
		return

			end
