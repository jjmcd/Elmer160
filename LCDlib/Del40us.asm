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
;  $Revision: 1.30 $ $Date: 2005-03-05 09:36:06-05 $

		include		"LCDMacs.inc"

	; Provided Routines
		global		Del40us		; Delay 40 usec

	; Required Storage
_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1

		code
; ------------------------------------------------------------------------
	; Waste some time by executing nested loops
	; 1us * 3 inst/loop * 4 * 4 = 48us (need 40)

	; Because of the extra couple of instructions, this turns out to be
	; 60 usec.  But a value of 3 ends up at 37 usec.  So we use 3 and
	; add a few nops at the end.

	;	 4MHz		3	40us
	;	10MHz		6	52us
	;	20MHz		8	44us

Del40us:
		movlw		D'3'		; w :=3 decimal
;		movlw		D'6'		; w :=6 decimal
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
