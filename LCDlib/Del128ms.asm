			global		Del128ms


_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1
		code
; ------------------------------------------------------------------------
;  Delay 128 milliseconds
Del128ms
        movlw   	D'167'		; Set up outer loop
        movwf   	_DELV001		;   counter to 255
        goto    	outer_loop	; Go to wait loops
outer_loop
        movlw   	0xFF		; Set up inner loop counter
        movwf   	_DELV002		;   to 255
inner_loop
        decfsz  	_DELV002,f	; Decrement inner loop counter
        goto    	inner_loop	; If inner loop counter not down to zero,
								;   then go back to inner loop again
        decfsz  	_DELV001,f	; Yes, Decrement outer loop counter
        goto    	outer_loop	; If outer loop counter not down to zero,
								;   then go back to outer loop again
        return					; Yes, return to caller
		end
