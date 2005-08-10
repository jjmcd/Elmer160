;	Initialize Scrolling
;
;	This function simply initializes the two addresses
;	used by LCDsc16.
;
;	$Revision: 1.38 $ $Date: 2005-08-09 21:11:18-04 $

;	Provided routine
		global		LCDinsc		; Initialize scrolling
;	Storage shared with LCDsc16
		global		LCDad2,LCDad1 ; Current addresses
; Storage
;
; This storage is provided here so that a call from LCDinit
; does not require bringing in LCDsc16 unless it is needed.
_LCDSC	udata
LCDad1	res			1			; Addr to write line 1 char
LCDad2	res			1			; Addr to write line 2 char


;	Manifest Constants
START	equ			H'40'+.8	; Rightmost char after scroll
MID		equ			H'08'+.8	; Corresponding pos in line 1

LCDLIB	code
LCDinsc
		movlw		START		; Address to start line 2
		movwf		LCDad2		; Save it
		movlw		MID			; Address to start line 1
		movwf		LCDad1		; Save it
		return
		end
