; boot_sect.asm - a boot sector program that prints a message and loops forever

mov	ah, 0x0e	; load 10 in the high bits of a (ah)
			; -> scrolling teletype BIOS routine
			; the ASCII in the lower bits (al) will be printed after interrupt is called
mov	al, 'H'
int 	0x10
mov	al, 'e'
int	0x10
mov	al, 'l'
int	0x10
int	0x10		; 'l' can be printed twice in a row, so you don't need to load l in mem again, you can just call the interrupt again
mov	al, 'o'
int 	0x10
mov	al, ','
int	0x10
mov	al, ' '
int	0x10
mov	al, 'u'
int	0x10
mov	al, 's'
int	0x10
mov	al, 'e'
int	0x10
mov	al, 'r'
int	0x10
mov	al, '!'
int	0x10

jmp	$	; jump to the current address (a.k.a. forever)

; Padding and magic number for BIOS

times	510-($-$$) db 0 ; When compiled, the program has to fit in 512 bytes
			; including the magic number. here reserve 510 bytes
dw	0xAA55		; and [d]eclare [w]ord of two more bytes here, 512 bytes
			; 0xAA55 is a magic number so that the BIOS knows this is on the boot sector.
