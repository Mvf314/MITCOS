// This kernel is written in a high-level language (C), but in a special way:
// it is written in the freestanding version of C, which means you won't have the standard library functions available to you.
// Trying to include standard library files will not work.
// However, there are some header file that are not part of the standard library, but rather of the compiler.
// Because this program is compiled with gcc, those header files can be used.

// C doesn't have booleans by default
#if !defined(__cplusplus)
#include <stdbool.h> // For bool
#endif

#include <stddef.h> // For size_t and NULL
#include <stdint.h> // For intx_t and uintx_t

// Check if this file is run on the correct operating system
#if defined(__linux__)
#error "No cross-compiler was used, for those wanting to continue past this point: Rest In Peace."
#endif

// This kernel will only work for i386 targets
#if !defined(__i386__)
#error "This kernel needs to be compiled with an ix86-elf compiler."
#endif

// Hardware VGA text mode color constants
enum vga_color {
	COLOR_BLACK		= 0,
	COLOR_BLUE		= 1,
	COLOR_GREEN		= 2,
	COLOR_CYAN		= 3,
	COLOR_RED		= 4,
	COLOR_MAGENTA		= 5,
	COLOR_BROWN		= 6,
	COLOR_LIGHT_GREY	= 7,
	COLOR_DARK_GREY		= 8,
	COLOR_LIGHT_BLUE	= 9,
	COLOR_LIGHT_GREEN	= 10,
	COLOR_LIGHT_CYAN	= 11,
	COLOR_LIGHT_RED		= 12,
	COLOR_LIGHT_MAGENTA	= 13,
	COLOR_LIGHT_BROWN	= 14,
	COLOR_WHITE		= 15,
};

uint8_t make_color(enum vga_color foreground, enum vga_color background) {
	return foreground | background << 4;
}

uint16_t make_vga_entry(char c, uint8_t col) {
	uint16_t c16	= c;
	uint16_t col16 	= col;
	return c16 | col16 << 8;
}

// strlen() is in the C standard library, so it doesn exist to the kernel.
// Because of this, is has to be implemented in the freestanding version of C
size_t strlen(const char* str) {
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

static const size_t VGA_WIDTH 	= 80;
static const size_t VGA_HEIGHT	= 25;

size_t		term_row;
size_t		term_column;
uint8_t		term_col;
uint16_t*	term_buf;

size_t get_buffer_index(size_t x, size_t y) {
        return (y * VGA_WIDTH) + x;
}

void term_init() {
	term_row 	= 0;
	term_column 	= 0;
	term_col 	= make_color(COLOR_LIGHT_GREY, COLOR_BLACK);
	term_buf	= (uint16_t*) 0xB8000;				// VGA text buffer location
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			term_buf[get_buffer_index(x, y)] = make_vga_entry(' ', term_col);
		}
	}
}

void term_setcolor(uint8_t col) {
	term_col = col;
}

void term_put_entry_at(char c, uint8_t col, size_t x, size_t y) {
	term_buf[get_buffer_index(x, y)] = make_vga_entry(c, col);
}

void term_putchar(char c) {
	term_put_entry_at(c, term_col, term_column, term_row);
	if (++term_column == VGA_WIDTH) {
		term_column = 0;
		if (++term_row == VGA_HEIGHT) {
			term_row = VGA_HEIGHT - 1;
			for (size_t y = 0; y <= VGA_HEIGHT; y++) {
				for (size_t x = 0; x < VGA_WIDTH; x++) {
					term_buf[get_buffer_index(x, y - 1)] = term_buf[get_buffer_index(x, y)];
				}
			}
		}
	}
}

void term_nl() {
        ++term_row;
        term_column = 0;
}


void term_writestr(const char* data) {
	size_t data_len = strlen(data);
	for (size_t i = 0; i < data_len; i++) {
		// check for newlines
		if (data[i] == '\n') {
			term_nl();
		} else {
			term_putchar(data[i]);
		}
	}
}

void term_printstart() {
	term_writestr("Welcome to the MITCOS 0.01.2 kernel by Mvf314.\n");
}

void fill_term() {
	// Fill the terminal
	for (size_t i = 0; i < 5000; i++) {
		term_putchar((char) i);
	}
}

void test_colors(int xStart, int yStart) {
	term_column = xStart;
	term_row = yStart;
	term_writestr("Testing colors...");
	for (size_t i = 0; i <= 15; i++) {
		for (size_t j = 0; j <= 15; j++) {
			term_put_entry_at('g', make_color(i, j), i + xStart + 1, j + yStart + 1);
		}
	}
	term_column = xStart;
	term_row = yStart + 17;
	term_writestr("Done.");
}

// Use C linkage for kernel_main
#if defined(__cplusplus)
extern "C"
#endif

// Where the boot calls the kernel
void kernel_main() {
	// Init terminal
	term_init();
	// Print a welcome message
	term_printstart();
	test_colors(0, 1);
}
