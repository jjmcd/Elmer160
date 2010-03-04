			title			'Del2ms - Delay 2 millisecond (approximately)'
			subtitle		'Part of the LCDlib library'
			list			b=4,c=132,n=77,x=Off

;**
;  Del2ms
;
;  Delay 2 millisecond (approximately).
;
;  This function delays for about 2 milliseconds.  The W
;  register is ignored.  The contents of the W register
;  are destroyed.
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:12-04 $

		include		"LCDmacs.inc"

	; Provided Routines
		global		Del2ms

	; Required Storage
_DELOV2	UDATA_OVR
_DELV003	res		1
_DELV004	res		1

LCDLIB		code
; ------------------------------------------------------------------------
	; Waste a lot of time by executing nested loops
	; Calculate the loop count based on processor speed
	; This calculation leads to slightly long times
	; at higher speeds

LOOPCNT=D'21'+D'2'*PROCSPEED

Del2ms:
		movlw		LOOPCNT			; Outer loop counter to calc valuee
		movwf		_DELV003		; _DELV003 := w
lloop:	movwf		_DELV004		; _DELV004 := w
mloop:	decfsz		_DELV004,f		; _DELV004 = _DELV004-1, skip next if zero
		goto 		mloop
		decfsz		_DELV003,f		; _DELV003 = _DELV003-1, skip next if zero
		goto		lloop
		return

		end
