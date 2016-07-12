; boot_sect.asm - a boot sector program that loops forever

loop:			; define label "loop"
	jmp	loop	; jump to label "loop", creating an infinite loop

times	510-($-$$) db 0 ; When compiled, the program has to fit in 512 bytes
			; including the magic number. here reserve 510 bytes
dw	0xaa55		; and [d]eclare [w]ord of two more bytes here, creating 512 bytes.
