/* The bootloader will start at the symbol designated as the entry point */
ENTRY(_start)

/* Tell where the sections of the assembled and compiled files will be put in the final kernel image */
SECTIONS
{
	/* Begin putting sections at 1 MiB. */
	. = 1M;

	/* First put the Multiboot header as it's required to be in the first 8 KiB of the image (see boot.s).
	   The text sections comes after that. */
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.multiboot)
		*(.text)
	}

	/* Read-only data */
	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	}

	/* Initialized read-write data */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}

	/* Uninitialized read-write data and stack */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
		*(.bootstrap_stack)
	}

	/* The compiler may produce other sections, by default it will put them in a segment with the same name.
	   Add stuff down here when needed. */
}
