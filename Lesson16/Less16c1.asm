			global		Sub1

Counters	udata_ovr
Loopc1		res			1
Loopc2		res			1

			code
Sub1
			movlw		5
			movwf		Loopc1
Loop1
			movlw		3
			movwf		Loopc2
Loop2
			decfsz		Loopc2,F
			goto		Loop2
			decfsz		Loopc1,F
			goto		Loop1

			return
			end
