;	CW decode routines
		include		p16f628.inc
		include		CWdefs.inc

		global		c_minof,c_minon,decod,ag_parm,dec_sg
		global  	ctrsegn,swinput,tmed_on,tmed_of,tmax_of
		global		plval,pldata,speed,cntchar
		extern		moltip,dividi
		extern		wrtlcd,bytelcd
		extern		ord_of,ord_on
		extern		ric_a,ric_b,ric_c,ric_d,ric_e,ric_f
		extern		tmin1_on,tmin1_of,tmin2_on,tmin2_of,tmin3_on,tmin3_of
		extern		timeon,timeoff
		extern		timchr1,timchr2
		extern		w_num1,w_num2,w_num3,w_num4,w_count
		extern		w_conv

;       program variables definitions 
		udata
cntchar res 1 ;      0x0e		;received characters counter  
pldata  res 1 ;      0x10		;received dit/dash map (max 8)
plval   res 1 ;	 0x11		;significant dit/dash map (max 8)
speed	res 1 ;	 0x1f

tmed_on res 1 ;	 0x1c		;ON signal mean duration
tmed_of res 1 ;	 0x1d		;OFF signal mean duration
tmax_of res 1 ;	 0x1e		;interwords pause mean duration

swinput res 1 ;	 0x20		;input ON/OFF state indicator
ctrsegn res 1 ;	 0x21		;received signs counter 

		code
;	Received character decoding routine
;
;	input : 	
;	- PLVAL area containing significant bits map
;	- PLDATA area containing received values (0=dit,1=dash) 
;
;	output :
;	- decoded character in w_conv  
;	- decoded character on LCD display
;	
decod
	movlw	 " "		; space default character
	movwf	 w_conv		;
	movf     plval,F      	; verify PLVAL content
	btfsc	 STATUS,Z	; if zero
	return			; go to end routine	
decod1	
	movlw	 d'1'		; verify if plval = 1
	subwf	 plval,F	;
	btfss	 STATUS,Z	;
	goto	 decod3		;
	call	 ric_a		; and tab A search
	goto	 endecod

decod3	
	movlw	 d'2'		; verify if plval = 3
	subwf	 plval,F	;
	btfss	 STATUS,Z	;
	goto	 decod7		;
	call	 ric_b		; and tab B search
	goto	 endecod

decod7	
	movlw	 d'4'		; verify if plval = 7
	subwf	 plval,F	;
	btfss	 STATUS,Z	;
	goto	 decod15	;
	call	 ric_c		; and tab C search
	goto	 endecod
	
decod15	
	movlw	 d'8'		; verify if plval = 15
	subwf	 plval,F	;
	btfss	 STATUS,Z	;
	goto	 decod31	;
	call	 ric_d		; and tab D search
	goto	 endecod

decod31	
	movlw	 d'16'		; verify if plval = 31
	subwf	 plval,F	;
	btfss	 STATUS,Z	;
	goto	 decod63	;
	call	 ric_e		; and tab E search
	goto	 endecod

decod63	
	movlw	 d'32'		; verify if plval = 63
	subwf	 plval,F	;
	btfss	 STATUS,Z	;
	goto	 nodecod	;
	call	 ric_f		; and tab F search
	goto	 endecod

nodecod
	movlw	 "*"
endecod
	movwf	 w_conv		; at end save in w_conv decoded character
	movwf	 bytelcd
	clrf	 plval		; clear PLVAL e PLDATA
	clrf	 pldata
	call	 wrtlcd		; display decoded character

	return

;	Received sign decoding routine 
;
;	input : 
;	- received signal duration  	
;	- PLVAL area containing map of received signs
;	- PLDATA area containing received values (0=punto, 1=linea) 
;
;	output :
;	- updated PLVAL area  
;	- updated PLDATA area
;	
dec_sg
	btfsc	 plval, 0	; verify if plval = 00000000
	goto	 dec_sg1	;
	bsf	 plval, 0	; first sign of the received character
	movf	 tmed_on,W	;
	subwf	 timeon,W	; verify if duration > mean ON time (dit)
	btfsc	 STATUS,C	;
	bsf	 pldata, 0	; greater duration (dash)
	goto	 end_sg
dec_sg1
	btfsc	 plval, 1	; verify if plval = 00000001
	goto	 dec_sg2	;
	bsf	 plval, 1	; second sign of the received character
	movf	 tmed_on,W	;
	subwf	 timeon,W	; verify if duration > mean ON time (dit)
	btfsc	 STATUS,C	;
	bsf	 pldata, 1	; greater duration (dash)
	goto	 end_sg	
dec_sg2
	btfsc	 plval, 2	; verify if plval = 00000011
	goto	 dec_sg3	;
	bsf	 plval, 2	; third sign of the received character
	movf	 tmed_on,W	;
	subwf	 timeon,W	; verify if duration > mean ON time (dit)
	btfsc	 STATUS,C	;
	bsf	 pldata, 2	; greater duration (dash)
	goto	 end_sg
dec_sg3
	btfsc	 plval, 3	; verify if plval = 00000111
	goto	 dec_sg4	;
	bsf	 plval, 3	; fourth sign of the received character
	movf	 tmed_on,W	;
	subwf	 timeon,W	; verify if duration > mean ON time (dit)
	btfsc	 STATUS,C	;
	bsf	 pldata, 3	; greater duration (dash)
	goto	 end_sg		
dec_sg4
	btfsc	 plval, 4	; verify if plval = 00001111
	goto	 dec_sg5	;
	bsf	 plval, 4	; fifth sign of the received character
	movf	 tmed_on,W	;
	subwf	 timeon,W	; verify if duration > mean ON time (dit)
	btfsc	 STATUS,C	;
	bsf	 pldata, 4	; greater duration (dash)
	goto	 end_sg
dec_sg5
	btfsc	 plval, 5	; verify if plval = 00011111
	goto	 dec_sg6	;
	bsf	 plval, 5	; sixth sign of the received character
	movf	 tmed_on,W	;
	subwf	 timeon,W	; verify if duration > mean ON time (dit)
	btfsc	 STATUS,C	;
	bsf	 pldata, 5	; greater duration (dash)
	goto	 end_sg	
dec_sg6
	bsf	 plval, 6	; if more than six signs set a default 		
end_sg	
	return

;	Working parameters calculation routine
;	
;	tmed_on 
;	tmed_of    
;	tmax_of      
;
ag_parm
;	tmed_on computing
	movf	 tmin3_on,W
	movwf	 w_num2		; multiplicand in w_num2
	movlw	 d'2'
	movwf	 w_num3		; 2 in w_num3
	call	 moltip
	movf	 w_num2,W
	movwf	 tmed_on

;	tmed_of computing
	movf	 tmin3_of,W
	movwf	 w_num2		; multiplicand in w_num2
	movlw	 d'2'
	movwf	 w_num3		; 2 in w_num3
	call	 moltip
	movf	 w_num2,W
	movwf	 tmed_of

;	tmax_of computing
	movf	 tmin3_of,W
	movwf	 w_num2		; multiplicand in w_num2
	movlw	 d'5'
	movwf	 w_num3		; 5 in w_num3
	call	 moltip
	movf	 w_num2,W	; compute tmax_of = tmin_of * 5
	movwf	 tmax_of

	clrf	 ctrsegn
	movlw	 0xff
	movwf	 tmin1_on
	movwf	 tmin2_on
	movwf	 tmin3_on
	movwf	 tmin1_of
	movwf	 tmin2_of
	movwf	 tmin3_of
	return

;	Minimum ON time calculation routine.
;	stores the three lowest measured values 
;	in the observation interval (sgparm = received signs)    
c_minon
	movlw	 d'3'		; verify if timeon < 30 ms
	subwf	 timeon,W	; if so no computing is done
	btfss	 STATUS,C	; 
	goto	 end_mon	
	movf	 timeon,W	; 
	subwf	 tmin3_on,W	; calculate tmin3_on - timeon
	btfss	 STATUS,C	;
	goto	 end_mon	; if result < 0 exit
	movf	 timeon,W	; otherwise substitute for tmin3_on
	movwf	 tmin3_on	;
	call	 ord_on		; and tabel reorg 
end_mon
	return	

;	Minimum OFF time calculation routine.
;	stores the three lowest measured values 
;	in the observation interval (sgparm = received signs) 
c_minof
	movlw	 d'3'		; verify if timeoff < 30 ms
	subwf	 timeoff,W	; if so no computing is done
	btfss	 STATUS,C	; 
	goto	 end_mof	;
	movf	 timeoff,W	; 
	subwf	 tmin3_of,W	; calculate tmin3_of - timeoff
	btfss	 STATUS,C	;
	goto	 end_mof	; if result < 0 exit
	movf	 timeoff,W	; otherwise substitute for tmin3_of
	movwf	 tmin3_of	;
	call	 ord_of		; and tabel reorg
end_mof
	return	





		end
