		include		"LCDmacs.inc"
;**
;  LCDsnd
;
;  Sends a nybble to the LCD.  Two entry points are provided, LCDsndI to
;  send a command nybble, LCDsndD to send a data nybble.
;
;**
;  WB8RCR - 26-Sep-04
;  $Revision: 3.0 $ $Date: 2007-03-25 10:12:25-04 $

	; Provided Routines
		global	LCDsndI		; Send a command nybble to the LCD
		global	LCDsndD		; Send data to the LCD
	; Required routines
		extern	Del450ns	; Delay 450 nsec

    IF      PROC == 1320
        udata
work    res     1
    ENDIF

LCDLIB	code
; ------------------------------------------------------------------------
	; Send data to the LCD
LCDsndD:
    IF      PROC == 1320
; On the PIC-EL, the LCD is wired to pins that make sense on the 16F,
; but are more or less random on the 18F.  Use the following defines
; to try to keep it all straight.  Note that since we are only writing,
; we will use the LAT registers rather than the PORTs
#define LCD_D4  LATA,2
#define LCD_D5  LATA,3
#define LCD_D6  LATB,0
#define LCD_D7  LATB,1
#define LCD_EN  LATB,4
#define LCD_RW  LATB,5
#define LCD_RS  LATB,6

        bsf     LCD_RS      ; For data, set the register select
    ELSE
		andlw	00fh		; only use low order 4 bits
		iorlw	LCDRS		; Select register
    ENDIF
		goto	LCDsnd2			; Skip over LCDsndI

; ------------------------------------------------------------------------
	; Send a command nybble to the LCD
LCDsndI:
; ------------------------------------------------------------------------
	; Actually move the data
    IF      PROC == 1320
        bcf     LCD_RS      ; For a command, clear the register select
LCDsnd2
        bcf     LCD_RW      ; Ensure read/write set to write
    ; The individual bits must be set since we do not want to
    ; disturb the other bits of the port
        movwf   work        ; Save to RAM so we can do bit tests
        btfsc   work,0      ; D4
        goto    LCD1
        bcf     LCD_D4
        goto    LCD2
LCD1    bsf     LCD_D4
LCD2       
        btfsc   work,1      ; D5
        goto    LCD3
        bcf     LCD_D5
        goto    LCD4
LCD3    bsf     LCD_D5
LCD4       
        btfsc   work,2      ; D6
        goto    LCD5
        bcf     LCD_D6
        goto    LCD6
LCD5    bsf     LCD_D6
LCD6
        btfsc   work,3      ; D7
        goto    LCD7
        bcf     LCD_D7
        goto    LCD8
LCD7    bsf     LCD_D7
LCD8       
        bsf     LCD_EN      ; Strobe the data into the LCD by asserting
        call    Del450ns    ; enable for 450 ns, then removing it
        bcf     LCD_EN
        call    Del450ns

        bsf     LCD_D4      ; Leave the data bits high so that the
        bsf     LCD_D5      ; LEDs do not light.  Since enable is not
        bsf     LCD_D6      ; asserted, LCD doesn't care.
        bsf     LCD_D7
    ELSE
		andlw	00fh		; only use low order 4 bits
LCDsnd2
		movwf	LCDPORT		; Send data to LCDPORT
		iorlw	LCDEN		; Turn on enable bit
		movwf	LCDPORT
		call	Del450ns	; 450ns
		xorlw	LCDEN
		movwf	LCDPORT
		call	Del450ns	; 450ns
        movlw   H'0f'       ; Set data lines high
        movwf   LCDPORT     ;
    ENDIF
		return
		end
