			global		DelWrk,DelWrkL

			global		DelCt1,DelCt2,DelCt3

_ZZDATA	udata
DelCt1	res		1
DelCt2	res		1
DelCt3	res		1

		code
; ------------------------------------------------------------------------
;	Delay while doing stuff
DelWrkL:
		decfsz		DelCt3,F
		return
DelWrk:
		decfsz		DelCt2,F
		return
		decf		DelCt1,F
		return

		end
