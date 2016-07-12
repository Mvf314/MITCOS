; functions for output

printchar:
	pusha
	mov	ah, 0x0E
	int 	0x10
	popa
	ret
