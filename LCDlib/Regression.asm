;	LCDlib Regression Test
;
;	Exercise the routines in the LCD library
;
;	JJMcD - 17-Mar-05
;	$Revision: 1.2 $ $Date: 2005-03-18 09:29:34-04 $

			include		Processor.inc
			__config	_WDT_OFF & _XT_OSC & _PWRTE_ON

			extern		LCDinit,LCDdig,LCDclear,LCDaddr,LCDletr
			extern		LCDshift,LCDunshf,LCD8,LCDzero,LCDmsg
			extern		LCDinsc,LCDsc16
			extern		Del1s,Del128ms,Del256ms

			udata
Index		res			1		; Index into message
IndInd		res			1		; Index into Index
SaveChr		res			1		; Storage for character
Buffer		res			17		; Buffer to test LCDmsg

STARTUP		code
			goto		Start
			code
Start
	;	Initialize
			call		LCDinit
Loop
	;	Test LCDdig, also uses LCDletr
			call		TstDig
	;	Test 1 sec delay
			call		Del1s
	;	Test LCDclear
			call		LCDclear
			call		Del1s
	;	Test LCDaddr
			call		TstAdr
			call		Del1s
	;	Test scrolling
			call		TstScr
			call		Del1s
	;	Test LCDmsg
			call		TstMsg
			call		Del1s
	;	Test LCDmsg - 16 char
			call		TstMs6
			call		Del1s
	;	Test scrolling - 16 char
			call		TstSc6
			call		Del1s
	;	Test LCDaddr - 16 char
			call		TstA6r
			call		Del1s

	; Get ready to start over
			call		LCDclear	; Move cursor to the start
			call		LCDzero		; for the next guy
			goto		Loop

;	Test scrolling - 16 character display
TstSc6
			call		LCDclear	; Clear it out
			call		LCDinsc		; Initialize scrolling
			clrf		Index		; Start with zeroth character
TstSc61		movf		Index,W		; Pick up the index
			call		TabSc6		; Look up the desired character
			call		LCDsc16		; Display it
			call		Del256ms	; Slow it down
			incf		Index,1		; Next character
			movlw		.31			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstSc61		; No, do it again
			return					;

;	Test the message function - 16-character (2x8) display
TstMs6
			call		LCDclear	; Clear out the display
			clrf		Index		; Start with zeroth character
			movlw		Buffer		; Pick up address of buffer
			movwf		IndInd		; And save it
TstMs61		movf		Index,W		; Pick up the index
			call		TabM6g		; Look up the desired character
			movwf		SaveChr		; Save off the character
			incf		IndInd,F	; Need to add one to index
			movf		IndInd,W	; Pick up storage location
			movwf		FSR			; Place it in FSR
			movf		SaveChr,W	; Get letter back
			movwf		INDF		; And store it in the buffer
			incf		Index,1		; Next character
			movlw		.16			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstMs61		; No, do it again
			movlw		.16			; Message length
			movwf		Buffer		; Stuff it in buffer
			movlw		Buffer		; Message in buffer, can
			call		LCDmsg		; display it with LCDmsg
			return					; All done

;	Test the message function
TstMsg
			call		LCDclear	; Clear out the display
			clrf		Index		; Start with zeroth character
			movlw		Buffer		; Pick up address of buffer
			movwf		IndInd		; And save it
TstMsg1		movf		Index,W		; Pick up the index
			call		TabMsg		; Look up the desired character
			movwf		SaveChr		; Save off the character
			incf		IndInd,F	; Need to add one to index
			movf		IndInd,W	; Pick up storage location
			movwf		FSR			; Place it in FSR
			movf		SaveChr,W	; Get letter back
			movwf		INDF		; And store it in the buffer
			incf		Index,1		; Next character
			movlw		.8			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstMsg1		; No, do it again
			movlw		.8			; Message length
			movwf		Buffer		; Stuff it in buffer
			movlw		Buffer		; Message in buffer, can
			call		LCDmsg		; display it with LCDmsg
			return					; All done

;	Test scrolling - 8 character only
TstScr
			call		LCDclear	; First clear memory
			call		LCDshift	; Set to shift mode
			call		LCD8		; First char on right
			clrf		Index		; Start with zeroth character
TstScr1		movf		Index,W		; Pick up the index
			call		TabScr		; Look up the desired character
			call		LCDletr		; Display it
			call		Del256ms	; Slow it down
			incf		Index,1		; Next character
			movlw		.31			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstScr1		; No, do it again
			call		LCDunshf	; Get out of shift mode
			return					;

;	Test digit ... send 1..8 to LCD
TstDig
			call		LCDclear	; Clear out old stuff
			clrf		Index		; Start with zeroth character
TstDig1		movf		Index,W		; Pick up the index
			call		TabDig		; Look up the desired character
			call		LCDdig		; Display it
			incf		Index,1		; Next character
			movlw		.8			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstDig1		; No, do it again
			return					; Yes, all done
;	Test address ... will send "Elecraft" slowly, from the ends in
TstAdr
			clrf		Index		; Start with zeroth
TstAd1		movf		Index,W		; Pick up the index
			call		TabAd1		; And get the char position
			movwf		IndInd		; Save it
			call		LCDaddr		; and position cursor
			movf		IndInd,W	; Get the position again
			call		TabAdr		; and get the character
			call		LCDletr		; Display it
			movlw		H'11'		; Move cursor out of the way
			call		LCDaddr		; for a nicer display
			call		Del256ms	; Slow it down
			incf		Index,1		; Next character
			movlw		.8			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstAd1		; No, do it again
			return					; Yes, all done

;	Test address - 16 char display ... will send "Wilderness Radio" slowly, from the ends in
TstA6r
			call		LCDclear	; Clear out prev message
			clrf		Index		; Start with zeroth
TstA61		movf		Index,W		; Pick up the index
			call		TabA61		; And get the char position
			movwf		IndInd		; Save it
			sublw		.7			; Check if second part of LCD
			btfss		STATUS,C	; Borrow?
			goto		TstA62		; No
			movf		IndInd,W	; Yes
			call		LCDaddr		; and position cursor
			goto		TstA63		; Skip over right half
TstA62		movf		IndInd,W	; Pick up position
			addlw		H'38'		; Move to right half
			call		LCDaddr		; of LCD (add 64-8)
TstA63		movf		IndInd,W	; Get the position again
			call		TabAd6		; and get the character
			call		LCDletr		; Display it
			movlw		H'11'		; Move cursor out of the way
			call		LCDaddr		; for a nicer display
			call		Del256ms	; Slow it down
			incf		Index,1		; Next character
			movlw		.16			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstA61		; No, do it again
			return					; Yes, all done

;	Lookup tables - moved up here to avoid page crossings

TABSTOR		udata
SavIdx		res			1			; Temporary storage for index

TABLES		code		H'300'		; Start on a page boundary
;	Table of digits to display
TabDig		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabDig); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			.1,.2,.3,.4,.5,.6,.7,.8
;	Table with message for TstAdr
TabAdr		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAdr); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Elecraft"
;	Table with char numbers for TstAdr
TabAd1		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAd1); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			.7,.0,.6,.1,.5,.2,.4,.3
;	Table with message for TstAdr 16-character
TabAd6		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAd6); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Wilderness Radio"
;	Table with char numbers for TstAdr 16-char
TabA61		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabA61); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			.15,.0,.14,.1,.13,.2,.12,.3,.11,.4,.10,.5,.9,.6,.8,.7
;	Table with message for TstScr
TabScr		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabScr); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Oak Hills Research ...         "
;	Table with message for TstScr - 16 char
TabSc6		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabSc6); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Small Wonder Labs ...          "
;	Table with message for TstMsg
TabMsg		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabMsg); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"QRP Labs"
;	Table with message for TstMsg (16 character message)
TabM6g		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabM6g); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"*Morse Express* "

			end
