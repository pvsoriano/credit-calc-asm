; Source Name: readdata.asm
; Compiled Name: readdata.o
; Executable Name: NONE ---> function library
; Code Model: Flat mode protected model
; Version: 1.0
; Created Date: 29 APR 2006
; Last Updated: 29 APR 2006
; Author: Paul V. Soriano
; Description: This module reads the data from a file and 
; 	automatically calculates the monthly payment plan
;	and outputs to a file.
;
; Assemble using this code:
;	clear;nasm -l outcode -f elf readdata.asm



[SECTION .text]

;; These externals are from the standard C library
extern printf
extern system

;; These externals are from the associated library CALCULATE.ASM
extern get_data
extern pause_data

;; needed so linker can find entry point
global read_data

read_data:
	;;; Clear screen first
	push dword clear_scr		; push "clear" onto stack
	call system			; clear terminal screen
	add esp,4			; clean up stack

	;;; Display temporary message
	push dword readdatamsg		; test print
	call printf			; print it out
	add esp,4			; clean up stack
	call pause_data



[SECTION .data]

; Used to clear the terminal screen
clear_scr	db	"clear",0


readdatamsg	db	"Message from readdata.asm",10,0



[SECTION .bss]
