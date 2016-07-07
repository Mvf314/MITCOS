## IMPORTANT NOTE: PLEASE DISREGARD THE README UNTIL THIS NOTICE IS GONE. THE PROJECT WILL BE REWRITTEN FROM SCRATCH. ##

# MITCOS #

## version 0.01.1 ##

### by Mvf314 ###

## Introduction ##

MITCOS is a hobby project where I will try to make an operating system.

Note: I use the OSdev wiki (wiki.osdev.org) religiously, so don't be surprised if the code is mostly the same as the examples given on that site. Of course, when I have a basic kernel up I will try to implement as much as my own knowledge in the OS. A lot of the comments are also the same, but they are so I can take a look at the code and know exactly what is does and why it does that. Most of the comments will contain the same information, maybe worded a little bit differently.

## Running MITCOS ##

For now, MITCOS can only be run with Quick Emulator (QEMU).

To run MITCOS, first make sure you have the right qemu installed (qemu-system-x86).

Then, you can run MITCOS with the following command:

qemu-system-i386 -kernel MITCOS-x.y.bin

### MITCOS Utils ###

In the MITCOS repo is also a /util folder, containing utilities for compiling, linking, and building the kernel and OS.
This was because I wanted to expand my knowledge with some shell scripting, but also because I couldn't be bothered to type the long commands for compiling and linking the files.

util/comp_kernel.sh compiles the C kernel.

util/link_kernel.sh links the kernel with the boot assembly into the OS binary.

util/build.sh compiles and linkd the kernel in one file.

util/build_quick.sh is the same as util/build.sh, although build_quick doesn't ask for filenames, only for the OS version. build_quick is based on a file model where there are src, bin and bins folders.

## Naming ##

MITCOS stands for "MITCOS Is The Coolest Operating System", but it can also stand for "Mvf314's Interesting but Terrible and Crappy Operating System".

## Changelog ##

#### 0.01.2 ####

\+ Added line scrolling
