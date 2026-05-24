all: run

boot.bin: boot.asm
	nasm -fbin boot.asm -o boot.bin

boot.img: boot.bin
	dd if=/dev/zero of=boot.img bs=1024 count=1440  
	dd if=boot.bin of=boot.img conv=notrunc         

run: boot.img
	qemu-system-i386 -cpu pentium2 -m 1g -fda boot.img -monitor stdio -device VGA

clean:
	rm -f boot.bin boot.img

debug: boot.img
	qemu-system-i386 -cpu pentium2 -m 1g -fda boot.img -monitor stdio -device VGA &
	gdb -ex "target remote localhost:1234" -ex "break *0x7C00" -ex "continue"

.PHONY: all run clean debug
