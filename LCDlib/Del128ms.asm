		title		'Del128ms - Delay 128 milliseconds (approximately)'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off
		include		LCDMacs.inc

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
;  $Revision: 2.2 $ $Date: 2008-02-27 11:24:55-05 $

		global		Del128ms
;
;	Loop counter:

LOOPCNT=((D'104'*PROCSPEED)/D'10')+1

;	 4MHz	 42	129.2 ms
;	10MHz	105	129.2 ms
;	20MHz	209	128.6 ms


_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1
LCDLIB		code
; ------------------------------------------------------------------------
;  Delay 128 milliseconds
Del128ms
		call		Go128
		call		Go128
		call		Go128
Go128:
	banksel		_DELV001
	        movlw   	LOOPCNT		; Set up outer loop counter
        movwf   	_DELV001	;   to calculated value
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
	banksel		0
        return					; Yes, return to caller
		end
