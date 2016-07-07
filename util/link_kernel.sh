echo "Welcome to the MITCOS cross-compiler linker utility.\nWhere is your linker source file? (linker.ld)"
read linker
echo "Where is your assembled boot file? (boot.o)"
read boot
echo "Where is your compiled kernel file? (kernel.o)"
read kernel
echo "Where do you want your output file (os.bin) to go?"
read output
$CROSS-gcc -T $linker -o $output -ffreestanding -O2 -nostdlib $boot $kernel -lgcc || echo "An error occured and the output file was not created."
