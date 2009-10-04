;	LCDlib Regression Test
;
;	Exercise the routines in the LCD library
;
;	JJMcD - 17-Mar-05
;	$Revision: 2.1 $ $Date: 2008-02-26 14:31:22-05 $

			include		Processor.inc
			include		Configuration.inc

			extern		LCDinit,LCDdig,LCDclear,LCDaddr,LCDletr
			extern		LCDshift,LCDunshf,LCD8,LCDzero,LCDmsg
			extern		LCDinsc,LCDsc16
			extern		Del1s,Del128ms,Del256ms

			udata
Index		res			1		; Index into message
IndInd		res			1		; Index into Index
SaveChr		res			1		; Storage for character
Buffer		res			17		; Buffer to test LCDmsg
;TABSTOR		udata
;SavIdx		res			1			; Temporary storage for index
#define SavIdx SaveChr

STARTUP		code
			lgotox		Start
			code
;	Test scrolling - 16 character display
TstSc6
			lcallx		LCDclear	; Clear it out
			lcallx		LCDinsc		; Initialize scrolling
			clrf		Index		; Start with zeroth character
TstSc61		movf		Index,W		; Pick up the index
			lcallx		TabSc6		; Look up the desired character
			lcallx		LCDsc16		; Display it
			lcallx		Del256ms	; Slow it down
			pageselx		TstSc6
			incf		Index,1		; Next character
			movlw		.31			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstSc61		; No, do it again
			return					;

;	Test the message function - 16-character (2x8) display
TstMs6
			lcallx		LCDclear	; Clear out the display
			pageselx		TstMs6
			clrf		Index		; Start with zeroth character
			movlw		Buffer		; Pick up address of buffer
			movwf		IndInd		; And save it
TstMs61		movf		Index,W		; Pick up the index
			lcallx		TabM6g		; Look up the desired character
			pageselx		TstMs61
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
			lcallx		LCDmsg		; display it with LCDmsg
			return					; All done
;
;;	Test the message function
TstMsg
			lcallx		LCDclear	; Clear out the display
			pageselx		TstMsg
			clrf		Index		; Start with zeroth character
			movlw		Buffer		; Pick up address of buffer
			movwf		IndInd		; And save it
TstMsg1		movf		Index,W		; Pick up the index
			lcallx		TabMsg		; Look up the desired character
			pageselx		TstMsg1
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
			lcallx		LCDmsg		; display it with LCDmsg
			return					; All done
;
;	Test scrolling - 8 character only
TstScr
			lcallx		LCDclear	; First clear memory
			lcallx		LCDshift	; Set to shift mode
			lcallx		LCD8		; First char on right
			clrf		Index		; Start with zeroth character
TstScr1		movf		Index,W		; Pick up the index
			lcallx		TabScr		; Look up the desired character
			lcallx		LCDletr		; Display it
			lcallx		Del256ms	; Slow it down
			pageselx		TstScr1
			incf		Index,1		; Next character
			movlw		.31			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstScr1		; No, do it again
			lcallx		LCDunshf	; Get out of shift mode
			return					;

;	Test digit ... send 1..8 to LCD
TstDig
			lcallx		LCDclear	; Clear out old stuff
			clrf		Index		; Start with zeroth character
TstDig1		movf		Index,W		; Pick up the index
			lcallx		TabDig		; Look up the desired character
			lcallx		LCDdig		; Display it
			pageselx		TstDig
			incf		Index,F		; Next character
			movlw		.8			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstDig1		; No, do it again
			return					; Yes, all done
;	Test address ... will send "Elecraft" slowly, from the ends in
TstAdr
			clrf		Index		; Start with zeroth
TstAd1		movf		Index,W		; Pick up the index
			lcallx		TabAd1		; And get the char position
			movwf		IndInd		; Save it
			lcallx		LCDaddr		; and position cursor
			movf		IndInd,W	; Get the position again
			lcallx		TabAdr		; and get the character
			lcallx		LCDletr		; Display it
			movlw		H'11'		; Move cursor out of the way
			lcallx		LCDaddr		; for a nicer display
			lcallx		Del256ms	; Slow it down
			pageselx		TstAdr
			incf		Index,1		; Next character
			movlw		.8			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstAd1		; No, do it again
			return					; Yes, all done

;	Test address - 16 char display ... will send "Wilderness Radio" slowly, from the ends in
TstA6r
			lcallx		LCDclear	; Clear out prev message
			pageselx		TstA6r
			clrf		Index		; Start with zeroth
TstA61		movf		Index,W		; Pick up the index
			lcallx		TabA61		; And get the char position
			pageselx		TstA6r
			movwf		IndInd		; Save it
			sublw		.7			; Check if second part of LCD
			btfss		STATUS,C	; Borrow?
			goto		TstA62		; No
			movf		IndInd,W	; Yes
			lcallx		LCDaddr		; and position cursor
			pageselx		TstA6r
			goto		TstA63		; Skip over right half
TstA62
    		movf		IndInd,W	; Pick up position
			addlw		H'38'		; Move to right half
			lcallx		LCDaddr		; of LCD (add 64-8)
			pageselx		TstA6r
TstA63		movf		IndInd,W	; Get the position again
			lcallx		TabAd6		; and get the character
			lcallx		LCDletr		; Display it
			movlw		H'11'		; Move cursor out of the way
			lcallx		LCDaddr		; for a nicer display
			lcallx		Del256ms	; Slow it down
			pageselx		TstA6r
			incf		Index,1		; Next character
			movlw		.16			; Message length
			subwf		Index,W		; WIll be zero when done
			btfss		STATUS,Z	; Zero?
			goto		TstA61		; No, do it again
			return					; Yes, all done

Start
			lcallx		Del128ms
	;	Initialize
		IF	PROC==716
			clrf		CCP1CON
		ENDIF
			lcallx		LCDinit
            lcallx       Del1s
Loop
	;	Test LCDdig, also uses LCDletr
			lcallx		TstDig
	;	Test 1 sec delay
			lcallx		Del1s
	;	Test LCDclear
			lcallx		LCDclear
			lcallx		Del1s
	;	Test LCDaddr
			lcallx		TstAdr
			lcallx		Del1s
	;	Test LCDaddr - 16 char
			lcallx		TstA6r
			lcallx		Del1s
	;	Test LCDmsg
			lcallx		TstMsg
			lcallx		Del1s
	;	Test LCDmsg - 16 char
			lcallx		TstMs6
			lcallx		Del1s
	;	Test scrolling
			lcallx		TstScr
			lcallx		Del1s
	;	Test scrolling - 16 char
			lcallx		TstSc6
			lcallx		Del1s

	; Get ready to start over
			lcallx		LCDclear	; Move cursor to the start
			lcallx		LCDzero		; for the next guy
			lgotox		Loop


;	Lookup tables - moved up here to avoid page crossings

TABLES      code

;	Table of digits to display
TabDig
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabDig); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			.1,.2,.3,.4,.5,.6,.7,.8
;	Table with message for TstAdr
TabAdr
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAdr); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Elecraft"
;	Table with char numbers for TstAdr
TabAd1
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAd1); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			.7,.0,.6,.1,.5,.2,.4,.3
;	Table with message for TstAdr 16-character
TabAd6
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabAd6); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Wilderness Radio"
;	Table with char numbers for TstAdr 16-char
TabA61
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabA61); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			.15,.0,.14,.1,.13,.2,.12,.3,.11,.4,.10,.5,.9,.6,.8,.7
;	Table with message for TstScr
TabScr
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabScr); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Oak Hills Research ...         "
;	Table with message for TstScr - 16 char
TabSc6
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabSc6); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"Small Wonder Labs ...          "
;	Table with message for TstMsg
TabMsg
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabMsg); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"QRP Labs"
;	Table with message for TstMsg (16 character message)
TabM6g
    		movwf		SavIdx		; Save off the index
			movlw		HIGH(TabM6g); Get this page's high byte
			movwf		PCLATH		; and store it into PCLATH
			movf		SavIdx,W	; Pick up index
			addwf		PCL,F		; And look it up
			dt			"*Morse Express* "

			end
