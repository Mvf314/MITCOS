# Declare constants for the Multiboot header
.set ALIGN,	1 << 0		# Align the loaded modules on page boundaries
.set MEMINFO,	1 << 1		# Provite memory map
.set FLAGS,	ALIGN | MEMINFO	# Multiboot "flag" field
.set MAGIC,	0x1BADB002	# Magic number, lets bootloader find this header
.set CHECKSUM,	-(MAGIC + FLAGS)# Checksum of above, to prove the program wants to Multiboot

# Declare a Multiboot header marking the program as a kernel.
#These are magic values documented by the Multiboot standard. 
#The bootloader will search the first 8 KiB of the kernel file for those values, aligned at a 32-bit boundary.
#The signature is in its own section to the header can be forced to be within the first 8 KiB of the file.
.section .multiboot
	.align	4
	.long	MAGIC
	.long	FLAGS
	.long	CHECKSUM

# The Multiboot standard does not define the calue of the stack pointer register (esp) and the kernel has to provide a stack.
# The following code allocates room for a small stack by creating a symbol at the bottom, and then allocating 16384 bytes for it, and then finally creating a symbol at the top.
# The stack grows downwards in x86. Because the stack is in its own section, it can be marked as nobits.
# This means that the kernel will be smaller because it doesn't hold an uninitialized stack.
.section .bootstrap_stack, "aw", @nobits
	stack_bottom:
		.skip	16384	#16384 B = 16 KiB (the size of the stack)
	stack_top:

# The linker wants "_start" as the entry point to the kernel and the bootloades jumps to this position when the kernel is loaded.
# Returning from this function is'nt necessary because the bootloader will be gone.
.section .text
	.global	_start
		.type	_start, @function
	_start:
		# The bootloader loads into 32-bit protected mode on an x86.
		# Interrupts and paging are disabled.
		# The processor state is as defined in the Multiboot standard.
		# The kernel has full control of the CPU now.
		# The kernel can only use harware features and self-provided code (code in this file).
		# Basically, there's no software apart from the kernel that can be used on the operating system right now.
		# From here on, the kernel has complete control of the machine.

		# To set up the stack, the esp register will be set to the top of the stack (as it grows downward).
		# This is done because languages as C can't function without a stack.
		mov	$stack_top, %esp

		# Here is a good place to initialize the processor state before the "high-level kernel" (C kernel) is entered.
		# It is best to minimize the number of tasks done here because most, if not all features are not available.
		# Paging should be enabled here. C++ features will require runtime support to work as well.

		# Enter the high-level (C) kernel.
		call	kernel_main

		# If the system has nothing more to do (finished executing kernel_main), put the machine in an infinite loop.
		# Step 1: Disable interrupts with cli (clear interrupts).
		#         Interrupts are already disabled from the bootloader, so this is not necessary if you use a bootloader.
		# Step 2: Wait for the next interrupt to arrive with hlt (the halt instruction).
		#	  Since interrupts are disabled, this will lock up the machine.
		# Step 3: Jump to the hlt instruction if it ever wakes up due to a non-maskable interrupt of system management mode.
		cli
		1:
			hlt
		jmp	1b

# Set the size of the _start symbol the the current location '.' minus its start
# Can be useful for debugging or when implementing call tracers
.size	_start, . - _start
