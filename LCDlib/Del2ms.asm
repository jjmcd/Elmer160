		include		"LCDMacs.inc"

	; Provided Routines
		global		Del2ms

	; Required Storage
_DELOV2	UDATA_OVR
_DELV003	res		1
_DELV004	res		1

		code
; ------------------------------------------------------------------------
	; Waste a lot of time by executing nested loops
	; 1us * 3 Inst/loop * 24 * 24 = 1.8 ms approx

;	 4 MHz = 24
;	10 MHz = 38
;	20 MHz = 53

Del2ms:
		movlw		D'24'			; w := 24 decimal for 4 MHz
		movwf		_DELV003		; _DELV003 := w
lloop:	movwf		_DELV004		; _DELV004 := w
mloop:	decfsz		_DELV004,f		; _DELV004 = _DELV004-1, skip next if zero
		goto 		mloop
		decfsz		_DELV003,f		; _DELV003 = _DELV003-1, skip next if zero
		goto		lloop
		return

		end
