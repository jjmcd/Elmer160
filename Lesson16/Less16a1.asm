		processor	pic16f84a
		include		p16f84a.inc

		global		aSub

		code
aSub
		xorlw		h'ff'
		return

		end
