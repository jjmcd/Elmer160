;	Less17c2 - Replace LCDletr code in library
;
;	JJMCD - 2005-03-19
;	$Revision: 1.1 $ $Date: 2005-03-19 09:56:22-04 $

			global		LCDletr
			extern		LCDsndD,Del40us
LCD1		udata_ovr
SavLtr		res			1			; Storage for letter
			code
LCDletr:
			movwf		SavLtr		; Save off the letter
			swapf		SavLtr,W	; Swap nybbles
			call		LCDsndD		; Send high nybble
			movf		SavLtr,W	; Grab it again
			call		LCDsndD		; Send low nybble
			call		Del40us		; Hang around
			return
			end
