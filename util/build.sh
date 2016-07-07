echo "Welcome to the MITCOS cross-compiler build utility.\nWhere is your kernel source file? (kernel.c)?"
read kernel_src
echo "Where is your linker source file? (linker.ld)"
read linker_src
echo "Where is your assembled boot file? (boot.o)"
read boot_bin
echo "Where do you want your compiled kernel file (kernel.o) to go?"
read kernel_dest
echo "Where do you want your OS binary (os.bin) to go?"
read os_dest
$CROSS-gcc -c $kernel_src -o $kernel_dest -std=gnu99 -ffreestanding -O2 -Wall -Wextra || echo "Something went wrone compiling the kernel."
echo "Successfully compiled $kernel_src into $kernel_dest"
$CROSS-gcc -T $linker_src -o $os_dest -ffreestanding -O2 -nostdlib $boot_bin $kernel_dest -lgcc || echo "Something went wrong linking the OS."
echo "Successfully linked $linker_src, $boot_bin and $kernel_dest into $os_dest."
