		title		'Del128ms - Delay 128 milliseconds (approximately)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  Del128ms
;
;  Delay 128 millisecond (approximately).
;
;  This function delays for 128 milliseconds.  The W
;  register is ignored.  The contents of the W register
;  are destroyed.
;**
;  WB8RCR - 25-Sep-04
;  $Revision: 1.20 $ $Date: 2005-01-23 11:09:42-05 $

		global		Del128ms


_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1
		code
; ------------------------------------------------------------------------
;  Delay 128 milliseconds
Del128ms
        movlw   	D'167'		; Set up outer loop
        movwf   	_DELV001	;   counter to 255
        goto    	outer_loop	; Go to wait loops
outer_loop
        movlw   	0xFF		; Set up inner loop counter
        movwf   	_DELV002	;   to 255
inner_loop
        decfsz  	_DELV002,f	; Decrement inner loop counter
        goto    	inner_loop	; If inner loop counter not down to zero,
								;   then go back to inner loop again
        decfsz  	_DELV001,f	; Yes, Decrement outer loop counter
        goto    	outer_loop	; If outer loop counter not down to zero,
								;   then go back to outer loop again
        return					; Yes, return to caller
		end
