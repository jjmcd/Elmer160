
	; Provided Routines
		global		Del450ns

		code
; ------------------------------------------------------------------------
	; Waste 450ns for the enable pulse width,  only
	; need 4.5 clock cycles, so the call and return
	; should more than do it  (4 clock cycles/instruction)
	; but it turns out we need the NOP.

Del450ns:
		NOP
		NOP
		NOP
		return
		end
