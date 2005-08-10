		title		'Del40us - Delay 40 microseconds (approximately)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  Del40us
;
;  Delay 40 microseconds (approximately).
;
;  This function delays for 40 microseconds.  The W
;  register is ignored.  The contents of the W register
;  are destroyed.
;**
;  WB8RCR 26-Sep-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:12-04 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		Del40us		; Delay 40 usec

	; Required Storage
_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1

LCDLIB		code
; ------------------------------------------------------------------------
	; Waste some time by executing nested loops

LOOPCNT=3+(4*PROCSPEED)/11

	; This calculation turns out to be a little fat for faster processors
	; but it is pretty close:

	;	 4MHz		3	44.0us
	;	10MHz		6	53.6us
	;	20MHz		10	67.6us

Del40us:
		movlw		LOOPCNT
		movwf		_DELV001	; _DELV001 := w
jloop:	movwf		_DELV002	; _DELV002 := w
kloop:	decfsz		_DELV002,F	; _DELV002 = _DELV002-1, skip next if zero
		goto 		kloop
		decfsz		_DELV001,F	; _DELV001 = _DELV001-1, skip next if zero
		goto		jloop
		nop			; Fill out remaining 3 usec (at 4MHz)
		nop
		nop
		return

		end
