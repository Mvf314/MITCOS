; boot_sect.asm - a boot sector program that prints a message and loops forever

mov	al, 'H'
call 	printchar
mov	al, 'e'
call	printchar
mov	al, 'l'
call	printchar
mov	al, 'l'
call 	printchar
mov	al, 'o'
call	printchar
mov	al, '!'
call	printchar

jmp	$	; jump to the current address (a.k.a. forever)

%include "out.asm"

; Padding and magic number for BIOS

times	510-($-$$) db 0 ; When compiled, the program has to fit in 512 bytes
			; including the magic number. here reserve 510 bytes
dw	0xAA55		; and [d]eclare [w]ord of two more bytes here, 512 bytes
			; 0xAA55 is a magic number so that the BIOS knows this is on the boot sector.
