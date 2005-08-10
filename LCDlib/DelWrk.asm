		title		'DelWrk, DelWrkL - Delay while working'
		subtitle	'Part of the LCDlib library'
		list		b=4,c=132,n=77,x=Off

;**
;  DelWrk
;
;  Delay while doing someting else.  This routine is used
;  by T-PICEL and is included here since all the other delays
;  are also here.
;
;**
;  WB8RCR 26-Sep-04
;  $Revision: 1.38 $ $Date: 2005-08-09 21:11:14-04 $

	; Provided routines
		global		DelWrk,DelWrkL
	; Provided data
		global		DelCt1,DelCt2,DelCt3

_ZZDATA	udata
DelCt1	res			1
DelCt2	res			1
DelCt3	res			1

LCDLIB	code
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
