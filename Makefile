CFLAGS = -g -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs \
		 -Wall -Wextra -Werror
C_SOURCES = $(wildcard kernel/*.c drivers/*.c libs/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h libs/*.h)
OBJ = ${C_SOURCES:%.c=build/%.o}

compile_and_run:
	make compile && make run

cnr:
	make compile_and_run

compile:
	mkdir build/boot -p
	mkdir build/kernel -p
	mkdir build/bin -p
	mkdir build/drivers -p
	make build/bin/os-image.bin

build/bin/os-image.bin: build/boot/boot_sect.bin build/boot/setup.bin build/boot/kernel.bin
	cat $^ > build/bin/os-image.bin

build/boot/kernel.bin: build/boot/kernel_entry.o ${OBJ}
	i686-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

run: build/bin/os-image.bin
	qemu-system-i386 -fda build/bin/os-image.bin

build/%.o: %.c ${HEADERS}
	i686-elf-gcc ${CFLAGS} -ffreestanding -c $< -o $@

build/%.o: %.asm
	nasm $< -f elf -o $@

build/%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -r build