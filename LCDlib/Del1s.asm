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
;  $Revision: 1.3 $ $Date: 2004-11-22 21:48:18-05 $

			global		Del1s
			extern		Del128ms

			code

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
