all: run

boot.bin: boot.asm
	nasm -fbin boot.asm -o boot.bin

boot.img: boot.bin
	dd if=/dev/zero of=boot.img bs=512 count=2880
	dd if=boot.bin of=boot.img conv=notrunc
	dd if=aoi.txt of=boot.img conv=notrunc seek=1

run: boot.img
	qemu-system-i386 -cpu pentium2 -m 1g -fda boot.img -monitor stdio -device VGA

clean:
	rm -f boot.bin boot.img aoi.bin

debug: boot.img
	qemu-system-i386 -cpu pentium2 -m 1g -fda boot.img -monitor stdio -device VGA -s -S &
	gdb -ex "target remote localhost:1234" -ex "break *0x7C00" -ex "continue"

.PHONY: all run clean debug
