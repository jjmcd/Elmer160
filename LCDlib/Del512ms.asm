			global		Del512ms

			extern		Del256ms

_DELOV1	UDATA_OVR
_DELV001	res		1
_DELV002	res		1

		code
; ------------------------------------------------------------------------
;  Read LCD Delay
Del512ms:
		movlw		H'08'		; Now wait a while to allow it to
		movwf		_DELV002	; be read.  wait is approx 64*4.1ms
zzWait							; or about 1/2 second
		call		Del256ms	; 
		decfsz		_DELV002,F
		goto		zzWait
		return



		end
