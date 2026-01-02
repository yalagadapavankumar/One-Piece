# Minimal BIOS Bootloader (16‑bit Real Mode)

This repository contains a simple **BIOS bootloader** written in x86 assembly that runs in **16‑bit real mode** and prints a character on the screen.

A bootloader is the very first code executed by a PC when it boots — the BIOS loads the first 512‑byte sector (called the boot sector) into memory and then jumps to it. This code runs **without any operating system under it**.


## What It Does

* Runs in 16‑bit real mode
* Uses BIOS video interrupt to print a character
* Loops forever after display
* Fits exactly in one 512‑byte boot sector
* Recognized as bootable by BIOS because of the **0xAA55 signature** at the end of the sector

This is a **first‑stage bootloader**, its job is to run first and can later be extended to load a full kernel.

## Files

| File | Description |
|------|-------------|
| `boot.asm` | the assembly source for the bootloader |
| `boot.bin` | the assembled 512‑byte binary boot sector |

## Build

You need **NASM** (Netwide Assembler) and **QEMU Emulator** installed:
* First command create **boot.bin** file
* Second command execute and display output
```bash
nasm -f bin boot.asm -o boot.bin

qemu-system-x86_64 boot.bin
```
Here, the character **A** printed in QEMU Emulator screen:

![The character **'A'** printed on the emulator screen:](../images/print_character.png)

## Debugging

When working with bootloaders, it is important to inspect the binary to ensure it is correctly structured. You can use tools like `hexdump` or a debugger to verify your code.

### Using `hexdump`

`hexdump` allows you to view the contents of your compiled bootloader in hexadecimal format. This is useful to confirm:

- That your code is in the correct place.
- That the boot signature (`0x55AA`) is at the correct offset (bytes 511 and 512).
- That any padding bytes are correct.

Example:

```bash
hexdump -C bootloader.bin
```
output:

```
00000000  fa 31 c0 8e d8 8e c0 b4  0e b0 41 cd 10 eb fe 00  |.1........A.....|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200
```
The first line shows **bootloader** code:
- `fa` → `cli`
- `31 c0` → `xor ax, ax`
- `8e d8` → `mov ds, ax`
- `8e c0` → `mov es, ax`
- `b4 0e` → BIOS teletype
- `b0 41` → `'A'`
- `cd 10` → print `A`
- `eb fe` → infinite loop
## using qemu + gdb

QEMU must be started with the -s and -S flags:

-  -s: (shorthand for -gdb tcp::1234) Opens a GDB server on TCP port 1234.
- -S: Freezes the CPU at startup (waiting for GDB connection).

I'm using 64 bit computer i use this command

    qemu-system-x86_64 boot.bin -s -S

QEMU will launch, but the CPU will be paused,see the below picture.
![qemu will launch and cpu will be paused](../images/paused.png)

**Connect GDB**

In a separate terminal, launch GDB and connect to the QEMU server.

type `gdb` in terminal

**Connect to QEMU**

    target remote localhost:1234
**Load Symbols/Breakpoints:** The boot sector starts executing at address 0x7c00.

    break *0x7c00
![Breakpoint at *0x7c00](../images/breakpoint.png)

**Start Execution:** Let the CPU run until it hits the breakpoint.

    continue

  ![load address](../images/loadaddress.png)
  
 now breakpoint at `0x7c00`

again `continue`, then it would be `halt` then type `Ctrl-c`

  ![character printed](../images/final_output.png)

  here, you can see that register `rax` has Character **A**

finally type `kill` to close the QEMU process then type `quit` to exit from the `gdb`.
