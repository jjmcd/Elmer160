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
;  $Revision: 1.20 $ $Date: 2005-01-23 11:09:42-05 $

			global		Del256ms
			extern		Del2ms

_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1

		code
; ------------------------------------------------------------------------
	; Waste a lot of time

Del256ms:
		movlw		D'80'		; How much is a lot?
		movwf		_DELV001
LineLp:
		call		Del2ms		; 
		decfsz		_DELV001,F
		goto		LineLp
		return

		end
