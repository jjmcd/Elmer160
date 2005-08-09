;			list
	; LCDMacs.inc - Macros and defines used in LCD
;  Macros and defines used in LCDlib
;
;  WB8RCR - 26-Sep-04
;  $Revision: 1.37 $ $Date: 2005-08-09 09:33:08-04 $

;------------------------------------------------------------------
; Select processor include file depending on processor symbol
			include		Processor.inc
			nolist

;==================================================================
; The following define a number of implementation-specific
; parameters.  Note that underlying all is the assumprion
; that all the LCD lines will be attached to the same port, and
; the LCD data lines will be on the low 4 bits of that port
; in order.  There are a number of reasons why an implementor
; may choose something different.

;------------------------------------------------------------------
; How many lines on the display
; Comment out for a single line display
#define LCD2LINE
; Length of the LCD line
LCDLINELEN		equ		H'08'	; Length of the LCD line

;------------------------------------------------------------------
; Connection specific defines
LCDPORT			equ		PORTB	; Port LCD connected
LCDTRIS			equ		TRISB	; Corresponding TRIS register
LCDEN			equ		H'10'	; LCD enable mask in LCDPORT
LCDRS			equ		H'40'	; LCD register select mask in LCDPORT

;------------------------------------------------------------------
; The processor speed should work over a reasonable range
PROCSPEED=D'4'

; The following is fixed for all known implementations
LINE2OFFSET		equ		H'40'	; DDRAM start of line 2

; End of implementation-specific defines
;==================================================================

; The following define the LCD display commands.  To send
; a command, logically OR the command below with the desired
; parameters for the command.  Note that clear and home take
; no parameters, and in the case of set DDRAM address, the
; parameter is the desired address in DDRAM.
;
;------------------------------------------------------------------
; LCD Commands
LCD_DISP_CLEAR	equ		H'01'	; Clear display command
LCD_DISP_HOME	equ		H'02'	; Address and cursor home
LCD_ENTRY_MODE	equ		H'04'	; Set data entry mode
LCD_DISPLAY		equ		H'08'	; Control the display
LCD_SHIFT		equ		H'10'	; Control display shifting
LCD_FUN_SET		equ		H'20'	; Set display functions
LCD_SET_CGRAM	equ		H'40'	; Set character generator addr
LCD_SET_DDRAM	equ		H'80'	; Set display RAM address

;------------------------------------------------------------------
; LCD Function Set Parameters
LCD_1_LINE		equ		H'00'	; Single line display
LCD_2_LINE		equ		H'08'	; Two line display
LCD_5X7_FONT	equ		H'00'	; 5x7 dot font
LCD_5X10_FONT	equ		H'04'	; 5x10 dot font
LCD_DL_4		equ		H'00'	; 4 bit data length
LCD_DL_8		equ		H'10'	; 8 bit data length
; ** NOTE - setting 8 bit data length on PIC-EL will cause
; display to cease working because only 4 lines connected

;------------------------------------------------------------------
; LCD Entry Mode Parameters
LCD_DISP_SHIFT	equ		H'01'	; Set display to shift
LCD_NO_SHIFT	equ		H'00'	; Set display to not shift
LCD_DIS_INCR	equ		H'02'	; Set address to increment
LCD_DIS_DECR	equ		H'00'	; Set address to decrement

;------------------------------------------------------------------
; LCD Display Parameters
LCD_DISP_ON		equ		H'04'	; Turn display on
LCD_DISP_OFF	equ		H'00'	; Turn display off
LCD_CURS_ON		equ		H'02'	; Turn cursor on
LCD_CURS_OFF	equ		H'00'	; Turn cursor off
LCD_BLINK_ON	equ		H'01'	; Set cursor blinking
LCD_BLINK_OFF	equ		H'00'	; Set cursor nonblinking




				list
