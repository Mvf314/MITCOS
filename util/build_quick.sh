echo "Welcome to the MITCOS cross-compiler build utility.\nWhat version number is your OS?"
read os_version
$CROSS-gcc -c src/kernel.c -o bin/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra || echo "Something went wrone compiling the kernel."
echo "Successfully compiled src/kernel.c into bin/kernel.o"
$CROSS-gcc -T src/linker.ld -o bins/MITCOS-$os_version.bin -ffreestanding -O2 -nostdlib bin/boot.o bin/kernel.o -lgcc || echo "Something went wrong linking the OS."
echo "Successfully linked src/linker.ld, bin/boot.o and bin/kernel.o into bins/MITCOS-$os_version.bin"
