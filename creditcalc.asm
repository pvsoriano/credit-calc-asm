; Source Name: creditcalc.asm
; Compiled Name: creditcalc.o
; Executable Name: creditcalc
; Code Model: Flat mode protected model
; Version: 1.0
; Created Date: 08 MAR 2006
; Last Updated: 05 MAY 2006
; Author: Paul V. Soriano
; Description: This module will take in input from the user and manipulate the data
; 	inputted from the user.  This module will serve as the foundation for a more 
;	complicated and robust input module that will do more than simple arithmetic 
;	and manipulation of data.
;
; Assemble using this code:
;	clear;nasm -l outcode -f elf creditcalc.asm



[SECTION .text]

;; These externals are from the standard C library
extern fprintf
extern printf
extern scanf
extern sscanf
extern fopen
extern fclose
extern system

;; These externals are from the associated library CALCULATE.ASM
extern calculate
extern open_file
extern assign_args
extern pause_data

;; These externals are from the associated library READDATA.ASM
extern read_data


;; needed so linker can find entry point
global creditcalc
global main_menu
global gohome			


creditcalc:
	push ebp			; setup stack frame
	mov ebp,esp
	push ebx			; pushing necessary registers
	push esi
	push edi
        jmp check_args

assign_args_jump:
	call printf
	add esp,4
	call assign_args		; shortcut

check_args:
	;-------------------------------------------------------;
	; check_args: 						;
	; Here we are going to check the arguments from the 	;
	; command line and process them if there are.		;
	;-------------------------------------------------------;

	;;; Check to see if there are more than 1 argument
	mov eax,[ebp+8]			; load argument count from stack into eax
	cmp eax,1			; if count is 1, there are no args
	ja assign_args_jump		; continue if arg count is < 1

;-----------------------------------------------------------------------;
; Main Menu Switch Case							;
;									;
; This subroutine is a switch case for the main menu, but isn't a true	;
; switch case, in that it doesn't fall through if the conditions	;
; aren't met.  You can adjust the calls or jumps to your needs.		;
;-----------------------------------------------------------------------;

main_menu:
	;;; The following code display's the menu items
	push dword clear_scr		; push "clear" onto stack
	call system			; clear terminal screen
	add esp,4			; clean up stack

	mov ebx, dword switch_msg	; move pointer to message
    .checkline:
	cmp dword [ebx],0		; is the message line null?
	jne .show			; if not, show more lines
	jmp switch_answer		; once done, get answer
    .show:	
	push ebx			; push address of switch message	
	call printf			; display the message
	add esp,4			; clean up stack
	add ebx,SWITCHSIZE		; increment address by length of switch message line
	jmp .checkline			; loop back to see if we're done yet

  switch_answer:
	;;; Asks the user what he wants to do
	push dword answer_msg		; push address of the answer message
	call printf			; displays message
	add esp,4			; clean up

	push dword answer		; push address of answer on stack
	push dword int_fmt		; push format of answer
	call scanf			; calls scanf to get data from user
	add esp,8			; clean up

  switch_case:
	;;; start switch case
	mov eax,[answer]			; move answer into eax
	cmp eax,0			; see if eax is 0
	jnz .Not0			; move to next case if not 0
		jmp gohome		; quit program
	.Not0:
	cmp eax,1			; see if eax is 1
	jne .Not1			; move to next case if not 1
		call open_file		; call getdata to get data from user manually
	.Not1:
	cmp eax,2			; see if eax is 2
	jne .Not2			; move to next case if not 2
		call read_data		; call readdata to get data from file
	.Not2
	cmp eax,3			; see if eax is 3
	jne .Not3			; move to next case if not 3
		jmp calchelp		; call the help file
	.Not3
	cmp eax,4			
	jge endcase			; go directly to endcase if not 0, 1, 2, 3 or 4.

  endcase:
	;;; This ends the switch case
	push dword endmsg		; push address of end message
	call printf			; display message
	add esp,4			; clean up stack
	jmp main_menu			; go back to the main menu

;-----------------------------------------------------------------------;
; CreditCalc Help							;
;									;
; This subroutine displays the help menu for the user.			;
;-----------------------------------------------------------------------;

calchelp:
	;;; Clear the screen first
	push dword clear_scr		; push "clear" onto stack
	call system			; clear terminal screen
	add esp,4			; clean up stack

	push dword helpmsg		; push address of end message
	call printf			; display message
	add esp,4			; clean up stack
	call pause_data

gohome:
	pop edi
	pop esi
	pop ebx				; restore registers
	mov esp,ebp			; destroy stack
	pop ebp
	ret				; return control to Linux



[SECTION .data]

clear_scr	db	"clear",0

; Different formats for scanf
float_fmt 	db 	"%f",0
int_fmt		db 	"%d",0

; Below relate to the Main Menu Switch Case
answer_msg	db	"Please select one of the menu item: ",0

msg2		db	"----------Import Data From a File----------",10,0
msg3		db	"Task 3",10,0
endmsg		db	"You have chosen an incorrect menu item, please try again.",10,0

switch_msg	db	"Credit Calc Main Menu - please select from the following:",10,0
SWITCHSIZE	EQU	$-switch_msg
		db	"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",10,0
		db 	"1. Manually Input Data For One Credit Card               ",10,0
		db      "2. Import Data From a File                               ",10,0
		db      "3. Help                                                  ",10,0
		db	"---------------------------------------------------------",10,0
		db 	"0. Quit Program                                          ",10,0				
		db	"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",10,10,0
switch_end	dd	0

; Below is for the help file
helpmsg		db	"Example help file.",10,0


[SECTION .bss]

answer		resd 	1			; answer to loop for getdata
debt		resd	1
