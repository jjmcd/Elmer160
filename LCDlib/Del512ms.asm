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
;  $Revision: 1.7 $ $Date: 2004-11-23 08:11:00-05 $

			global		Del512ms

			extern		Del256ms

_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1

		code
; ------------------------------------------------------------------------
;  Wait for 1/2 second
Del512ms:
		movlw		H'08'		; Now wait a while to allow it to
		movwf		_DELV002	; be read.  wait is approx 64*4.1ms
zzWait							; or about 1/2 second
		call		Del256ms	; 
		decfsz		_DELV002,F
		goto		zzWait
		return

		end
