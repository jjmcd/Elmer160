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
