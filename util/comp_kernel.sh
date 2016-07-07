echo "Welcome to the MITCOS cross-compiler kernel compiler utility.\nWhere is your input file? (kernel.c)"
read input
echo "Where do you want your output file (kernel.o) to go?"
read output
$CROSS-gcc -c $input -o $output -std=gnu99 -ffreestanding -O2 -Wall -Wextra || echo "An error occured and the output file was not created"
