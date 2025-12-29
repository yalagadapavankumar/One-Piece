; =============================================================================
; |                              BOOT SECTOR                                  |
; | ------------------------------------------------------------------------- |
; | Mode:   REAL MODE (16-bit)                                                |
; | Task:   Load Kernel and Jump to Protected Mode                            |
; =============================================================================

[bits 16]							; generate 16-bit instructions (BIOS Real Mode)
[org 0x7c00]						; BIOS loads at 0x0000:0x7c00

start:
	cli								; disable hardware interrupts
	xor ax, ax						; clear AX (set 0)
	mov ds, ax						; set data segment = 0 (flat memory)
	mov es, ax						; set extra segment = 0

	mov ah, 0x0E					; BIOS teletype print function
	mov al, 'A'						; character to print
	int 0x10						; call BIOS video interrupt

halt:
	jmp halt						; infinite loop to stop execution

times 510-($-$$) db 0				; pad remaining bytes to 510
dw 0xAA55							; BIOS boot signature (must be at end)
