			title		'RestCnt - Restore counter from EEPROM'
			subtitle	'Part of Lesson 20 on interrupts'
			list		b=4,c=132,n=77,x=Off

			include		p16f84a.inc

;------------------------------------------------------------------------
;**
;	RestCnt
;
;	Restore the counter from EEPROM
;
;**
;	WB8RCR - 23-May-06
;	$Revision: 1.1 $ $State: Exp $ $Date: 2006-05-23 14:26:45-04 $

			errorlevel	-302
			global		RestCnt
			extern		binary

MYLIB		code
RestCnt:
			movlw		H'10'
			movwf		EEADR
			banksel		EECON1
			bsf			EECON1,RD
			banksel		EEDATA
			movf		EEDATA,W
			movwf		binary
			incf		EEADR,F
			banksel		EECON1
			bsf			EECON1,RD
			banksel		EEDATA
			movf		EEDATA,W
			movwf		binary+1
			
			return
			end
