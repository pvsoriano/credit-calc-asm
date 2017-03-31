; Source Name: calculate.asm
; Compiled Name: calculate.o
; Executable Name: NONE ---> function library
; Code Model: Flat mode protected model
; Version: 1.0
; Created Date: 29 APR 2006
; Last Updated: 05 MAY 2006
; Author: Paul V. Soriano
; Description: This module will perform the calculations need to figure
;	the monthly payments and how long a credit card amount would
;	take to pay off.
;
; Assemble using this code:
;	clear;nasm -l outcode -f elf calculate.asm



[SECTION .text]
;; These externals are from the standard C library
extern fprintf
extern printf
extern scanf
extern sscanf
extern fopen
extern fclose
extern system
extern time
extern ctime

;; These externals are from the associated library CREDTICALC.ASM:
extern main_menu
extern gohome

;; needed so linker can find entry point	
global open_file
global assign_args
global pause_data

open_file:
	;-------------------------------------------------------;
	; open_file: 						;
	; Opens the file before calculations.  Also prints	;
	; headings for the payment table.			;
	;-------------------------------------------------------;

	;;; Here we can write to a file
	push dword writecode		; code to write to file
	push dword filename		; push pointer to filename
	call fopen			; open or create file
	add esp,8			; clean up stack
	mov ebx,eax			; eax contains file handle - we'll save it in ebx

	push dword heading1		; push first heading message
	push ebx			; push pointer to file
	call fprintf			; call printf to format and display
	add esp,8			; clean up stack

	;;; We will get the time that the file was opened
	push dword 0			; push 32-bit null pointer on stack
	call time			; return calendar time in eax
	add esp,4			; clean up stack
	mov [time_stamp],eax		; copy time from eax into time_stamp

	push dword time_stamp			; push system calendar time
	call ctime			; returns point to ASCII time string in eax
	add esp,4			; clean up stack

	push eax			; push pointer to ASCII string in eax
	push dword time_str		; push address for time format message
	push ebx			; push file pointer
	call fprintf			; print to file
	add esp,12			; clean up the stack

	;;; We continue pushing the headings for the payment table
	push dword heading2		; push first heading message
	push ebx			; push pointer to file
	call fprintf			; call printf to format and display
	add esp,8			; clean up stack

	push dword heading3		; push first heading message
	push ebx			; push pointer to file
	call fprintf			; call printf to format and display
	add esp,8			; clean up stack

	push dword heading4		; push first heading message
	push ebx			; push pointer to file
	call fprintf			; call printf to format and display
	add esp,8			; clean up stack

	push dword heading5		; push first heading message
	push ebx			; push pointer to file
	call fprintf			; call printf to format and display
	add esp,8			; clean up stack

assign_args:
	;-------------------------------------------------------;
	; assign_args: 						;
	; Once we know that there are arguments, we will assign	;
	; them to the proper variables.				;
	;-------------------------------------------------------;

	;;; Let's clear the screen first
	;push dword clear_scr		; push "clear" onto stack
	;call system			; clear terminal screen
	;add esp,4			; clean up stack

	;mov edi,[ebp+12]		; put pointer to argument table into ebx

	;;; We pull the debt first
	;push dword debt			; Push address of line count integer for sscanf
	;push dword float_fmt		; Push address of integer formatting code
	;push dword [edi+4]		; Push pointer to arg(1)
	;call sscanf			; Call sscanf to convert arg(1) to an integer
	;add esp,12

	;;; Now we pull the percent
	;push dword percent		; Push address of line count integer for sscanf
	;push dword float_fmt		; Push address of integer formatting code
	;push dword [edi+8]		; Push pointer to arg(1)
	;call sscanf			; Call sscanf to convert arg(1) to an integer
	;add esp,12

	;;; Last, we pull the APR
	;push dword apr			; Push address of line count integer for sscanf
	;push dword float_fmt		; Push address of integer formatting code
	;push dword [edi+12]		; Push pointer to arg(1)
	;call sscanf			; Call sscanf to convert arg(1) to an integer
	;add esp,12

	;;; Now let's process the data
	jmp get_data			; go straight to calculations

gohome_jump:
	call gohome			; shortcut
	
get_data:
	;-------------------------------------------------------;
	; get_data: 						;
	; We get all the necessary information from the user to ;
	; compute their credit debt.				;
	;-------------------------------------------------------;

	;;; Prompts user to input the amount of credit card debt
	push dword debt_msg		; push address of debt prompt string
	call printf			; displays message
	add esp,4			; clean up

	push dword debt			; push address of integer buffer for 'debt'
	push dword float_fmt		; push address of integer format string for 'debt'
	call scanf			; calls scanf to get data from user
	add esp,8			; clean up

	;;; Prompts user to input the percentage for minimum payment percentage
	push dword percent_msg		; push address of percent prompt string
	call printf			; displays message
	add esp,4			; clean up

	push dword percent		; push address of integer buffer for 'percent'
	push dword float_fmt		; push address of integer format string for 'percent'
	call scanf			; calls scanf to get data from user
	add esp,8			; clean up

	;;; Prompts user to input the annual percentage rate, or APR
	push dword apr_msg		; push address of APR prompt string
	call printf			; displays message
	add esp,4			; clean up

	push dword apr			; push address of integer buffer for 'apr'
	push dword float_fmt		; push address of integer format string for 'percent'
	call scanf			; calls scanf to get data from user
	add esp,8			; clean up

verify_data:
	;-------------------------------------------------------;
	; verify_data:						;
	; Here, we display the inputted information to the user ;
	; for review to see if everything entered is correct.	;
	;-------------------------------------------------------;

	;;; Clear terminal screen first
	push dword clear_scr		; push "clear" onto stack
	call system			; clear terminal screen
	add esp,4			; clean up stack

	;;; Display amount of debt
	fld dword [debt]		; push integer value to display
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword debt_show		; print string
	call printf			; call printf to format and display
	add esp,12			; clean up

	;;; Display percent value
	fld dword [percent]		; push integer value to display
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword percent_show		; pointer to print format
	call printf			; call printf to format and display
	add esp,12			; clean up

	;;; Display APR value
	fld dword [apr]			; push integer value to display
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword apr_show		; pointer to print format
	call printf			; call printf to format and display
	add esp,12			; clean up

	;;; Asks the user if the data shown is correct
	push dword correct_msg		; push address of the correct prompt string
	call printf			; displays message
	add esp,4			; clean up

	push dword answer		; push address of answer on stack
	push dword int_fmt		; push format of answer
	call scanf			; calls scanf to get data from user
	add esp,8			; clean up

	;;; Comparing answer to see whether to loop or not
	cmp dword [answer],1		; see if answer is 1 (yes)
	je calculate			; if everything's okay, go to calculate
	jmp get_data			; if not, go back and get the correct data

calculate:
	;-------------------------------------------------------;
	; calculate:						;
	; This is the main function that calculates all of the	;
	; necessary variables used to create the payment table	;
	; that will be displayed in the terminal.		;
	;-------------------------------------------------------;

	;;; Multiply the 2 values together
	fld dword [debt]		; push debt onto FPU stack
	fmul dword [percent]		; multiply debt with percent on FPU stack
	fstp dword [min_payment]	; pop value from FPU stack into result variable

	;;; First we divide the interest rate by 12, to get the monthly rate
	fld dword [apr]			; divide APR from MONTHLY, or 12 months
	fdiv dword [MONTHLY]		; push 12.0 (the months) onto FPU stack
	fmul dword [debt]		; multiply debt by monthly interest rate
	fstp dword [interest]		; pop value from FPU stack into interest

	;;; Calculate the principal paid on the debt
	fld dword [min_payment]		; push minimum payment onto stack
	fsub dword [interest]		; subtract minimum payment from interest paid
	fstp dword [prin_paid]		; pop value into principal paid

	;;; Calculate the remaining debt
	fld dword [debt]		; push original debt onto stack
	fsub dword [prin_paid]		; subtract principal paid from debt
	fstp dword [remain_bal]		; pop value into remaining balance

initial_verify:
	;-------------------------------------------------------;
	; initial_verify:					;
	; Because of the way the logic is, we will check if 	;
	; the minimum payment is less $10 before calculating.	;
	;-------------------------------------------------------;

	;;; Compares the $10 minimum and minimum payment
	fld dword [MINIMUM]		; push minimum of $10 onto FPU stack
	fld dword [min_payment]		; push minimum payment onto FPU stack
	fcompp				; compare balance from 0 and pop off of FPU stack
	fnstsw ax			; copy FPU registers onto ax for comparison
	sahf				; copies into ah
	jb make_minimum_jump		; if yes, make minimum payment $10
	jmp write_data			; if no, move on

make_minimum_jump:
	jmp make_minimum		; shortcut

write_data:
	;-------------------------------------------------------;
	; write_data:						;
	; The data is written directly to the screen.  I will	;
	; incorporate a way to print the entire payment table	;
	; to a file in the future.				;
	;-------------------------------------------------------;

	;;; Print minimum payment
	fld dword [min_payment]		; push min_payment value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_min		; print string
	push ebx			; push pointer to file
	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Print interest paid
	fld dword [interest]		; push min_payment value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_int		; push address of base string
 	push ebx			; push pointer to file
 	call fprintf			; write to file
	add esp,12			; clean up stack
	
	;;; Print principal paid
	fld dword [prin_paid]		; push debt value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_prin		; print string
	push ebx			; push pointer to file
	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Print remaining balance
	fld dword [remain_bal]		; push remaining balance onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_bal		; push address of base string
 	push ebx			; push pointer to file
 	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Exchange original balance & remaining balance
	fld dword [remain_bal]		; push remaining balance on FPU stack
	fstp dword [debt]		; pop into debt

verify_less_balance:
	;-------------------------------------------------------;
	; verify_less_balance:					;
	; This module will verify whether the balance is less	;
	; than the minimum payment of $10.  If it is, we will	;
	; pay off the entire balance and we will be done.	;
	;-------------------------------------------------------;

	;;; Compares the $10 minimum and minimum payment
	fld dword [debt]		; push balance onto FPU stack
	fld dword [MINIMUM]		; push minimum payment onto FPU stack
	fcompp				; compare balance from $10 and pop off of FPU stack
	fnstsw ax			; copy FPU registers onto ax for comparison
	sahf				; copies into ah
	ja end_table			; if debt < min_payment, go to last payment
	jmp verify_minimum		; if not, keep verifying

end_table:
	;-------------------------------------------------------;
	; end_table:						;
	; This module will complete the last payment to bring	;
	; the debt finally to 0.				;
	;-------------------------------------------------------;

	;;; First we divide the interest rate by 12, to get the monthly rate
	fld dword [apr]			; divide APR from MONTHLY, or 12 months
	fdiv dword [MONTHLY]		; push 12.0 (the months) onto FPU stack
	fmul dword [debt]		; multiply debt by monthly interest rate
	fstp dword [interest]		; pop value from FPU stack into interest 

	;;; Now take the remaining balance and subtract the interest
	fld dword [debt]		; divide APR from MONTHLY, or 12 months
	fadd dword [interest]		; add interest from debt, that's the last payment
	fstp dword [min_payment]	; pop value from FPU stack into interest

	;;; Calculate the principal paid on the debt
	fld dword [min_payment]		; push minimum payment onto stack
	fsub dword [interest]		; sub minimum payment from interest paid
	fstp dword [prin_paid]		; pop value into principal paid

	;;; Calculate the remaining debt
	fld dword [debt]		; push original debt onto stack
	fsub dword [prin_paid]		; subtract principal paid from debt
	fstp dword [remain_bal]		; pop value into remaining balance

	;;; Print minimum payment
	fld dword [min_payment]		; push min_payment value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_min		; print string
	push ebx			; push pointer to file
	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Print interest paid
	fld dword [interest]		; push min_payment value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_int		; push address of base string
 	push ebx			; push pointer to file
 	call fprintf			; write to file
	add esp,12			; clean up stack
	
	;;; Print principal paid
	fld dword [prin_paid]		; push debt value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_prin		; print string
	push ebx			; push pointer to file
	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Print remaining balance
	fld dword [remain_bal]		; push remaining balance onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_bal		; push address of base string
 	push ebx			; push pointer to file
 	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Closes file
	push ebx			; Push the handle of the file to be closed
	call fclose			; Closes the file whose handle is on the stack
	add esp,4
    .loop:
	;;; Let's clear the screen first
	push dword clear_scr		; push "clear" onto stack
	call system			; clear terminal screen
	add esp,4			; clean up stack

	;;; Display message and wait for user response
	push dword print_tofile1	; push address of the answer message
	call printf			; displays message
	add esp,4			; clean up

	push dword print_tofile2	; push address of the answer message
	call printf			; displays message
	add esp,4			; clean up

	push dword answer		; push address of answer on stack
	push dword int_fmt		; push format of answer
	call scanf			; calls scanf to get data from user
	add esp,8			; clean up

	;;; Compares answer
	cmp dword [answer],1		; checks if answer is '1'
	jne .loop			; just stay put and keep showing message
	call main_menu			; otherwise, we're going home


verify_minimum:
	;-------------------------------------------------------;
	; verify_minimum:					;
	; We are going to make sure that the minimum payment 	;
	; doesn't go below $10.  If the minimum payment goes	;
	; below $10, we will reassign the value of min_payment	;
	; to $10.						;
	;-------------------------------------------------------;

	;;; Compares the $10 minimum and minimum payment
	fld dword [MINIMUM]		; push minimum of $10 onto FPU stack
	fld dword [min_payment]		; push minimum payment onto FPU stack
	fcompp				; compare balance from 0 and pop off of FPU stack
	fnstsw ax			; copy FPU registers onto ax for comparison
	sahf				; copies into ah
	jb make_minimum			; if yes, make minimum payment $10
	jmp calculate			; if no, move on

make_minimum:
	;-------------------------------------------------------;
	; make_minimum:						;
	; We are going to make sure that the minimum payment 	;
	; doesn't go below $10.  If the minimum payment goes	;
	; below $10, we will reassign the value of min_payment	;
	; to $10.						;
	;-------------------------------------------------------;

	;;; First we divide the interest rate by 12, to get the monthly rate
	fld dword [apr]			; divide APR from MONTHLY, or 12 months
	fdiv dword [MONTHLY]		; push 12.0 (the months) onto FPU stack
	fmul dword [debt]		; multiply debt by monthly interest rate
	fstp dword [interest]		; pop value from FPU stack into interest

	;;; Calculate the principal paid on the debt
	fld dword [MINIMUM]		; push minimum payment onto stack
	fsub dword [interest]		; subtract minimum payment from interest paid
	fstp dword [prin_paid]		; pop value into principal paid

	;;; Calculate the remaining debt
	fld dword [debt]		; push original debt onto stack
	fsub dword [prin_paid]		; subtract principal paid from debt
	fstp dword [remain_bal]		; pop value into remaining balance

	;;; Print minimum payment
	fld dword [min_payment]		; push min_payment value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_min		; print string
	push ebx			; push pointer to file
	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Print interest paid
	fld dword [interest]		; push min_payment value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_int		; push address of base string
 	push ebx			; push pointer to file
 	call fprintf			; write to file
	add esp,12			; clean up stack
	
	;;; Print principal paid
	fld dword [prin_paid]		; push debt value onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_prin		; print string
	push ebx			; push pointer to file
	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Print remaining balance
	fld dword [remain_bal]		; push remaining balance onto FPU stack
	add esp,-8			; reserve space for floating point number
	fstp qword [esp]		; pop value from FPU stack onto my stack
	push dword display_bal		; push address of base string
 	push ebx			; push pointer to file
 	call fprintf			; write to file
	add esp,12			; clean up stack

	;;; Exchange original balance & remaining balance
	fld dword [remain_bal]		; push remaining balance on FPU stack
	fstp dword [debt]		; pop into debt

	;;; Continue on verifying
	jmp verify_less_balance		; go back to verifying

pause_data:
	;-------------------------------------------------------;
	; pause_data:						;
	; Displays a message and waits for the user to type in	;
	; the number '1' to go back to the main menu.		;
	;-------------------------------------------------------;

	;;; Display message and wait for user response
	push dword answer_msg		; push address of the answer message
	call printf			; displays message
	add esp,4			; clean up

	push dword answer		; push address of answer on stack
	push dword int_fmt		; push format of answer
	call scanf			; calls scanf to get data from user
	add esp,8			; clean up

	;;; Compares answer
	cmp dword [answer],1		; checks if answer is '1'
	jne pause_data			; just stay put and keep showing message
	call main_menu			; otherwise, we're going home



[SECTION .data]
; Different formats for scanf
float_fmt 	dd 	"%f",0
int_fmt		dd 	"%d",0

; Used to clear the terminal screen
clear_scr	db	"clear",0

; Messages that show the information to the user
display_min	db	"     $%.2f    ",0
display_int	db	"           $%.2f    ",0
display_prin	db	"         $%.2f    ",0
display_bal	db	"          $%.2f    ",10,0

; Used for file manipulation
filename		db	"payment_table.txt",0
writecode	db	"a",0
opencode	db	"r",0

; Messages that show the information to the user
debt_show 	db 	"Your credit card debt is: $%.2f",10,0
percent_show 	db 	"The percentage for the minumum payment is: %.2f%",10,0
monthly_show 	db 	"Your monthly minimum payment is: $%.2f",10,0
apr_show	db	"Your Annual Percentage Rate (APR) is: %.2f%",10,0
interest_show	db	"Your monthly interest amount is: $%.2f",10,0
too_many	db	"There are too many arguments.  Only the 1st 3 arguments will be processed.",10,0

; Messages that asks the user for information
debt_msg 	db 	"Enter the amount of credit card debt: ",0
percent_msg 	db 	"Enter the percent of balance used to calculate minimum payment: ",0
apr_msg		db	"Enter the Annual Percentage Rate: ",0
correct_msg 	db 	"Are the values correct?  If yes, type 1, if not, type 0: ",0
another_msg 	db 	"Would you like to calculate another monthly payment? ",0
write_msg	db	"Would you like to write this information to a file? ",0
answer_msg	db	"Press 1 if you would like to return to the main menu: ",0
print_tofile1	db	"The information has been written to file 'payment_table.txt'.",10,0
print_tofile2	db	"Please type '1' and hit 'Enter' to continue...",10,0
error_msg	db	"The file could not be opened.",10,0

; Heading messages
heading1	db	"Credit Card Debt Payment Table                                              ",10,0
heading2	db	"                                                                                 ",10,0
heading3	db	"----------------------------------------------------------------------------",10,0
heading4	db	"|Minimum payment|   |Interest Paid|   |Principal Paid|   |Remaining Balance|",10,0
heading5	db	"----------------------------------------------------------------------------",10,0
format_str	db 	"$%.2f	             $%.2f             $%.2f              $%.2f             ",10,0

; Time messages
time_str	db	"Created on: %s.",10,0

; Constants
MONTHLY		dd	12.0
MINIMUM		dd	10.0
ZERO		dd	0.0



[SECTION .bss]
debt		resd 	1		; credit card debt
percent		resd 	1		; percent of credit card debt for minimum payment
apr		resd 	1		; Annual Percentage Rate
min_payment	resd 	1		; minimum payment for credit card
interest	resd	1		; monthly interest amount due
prin_paid	resd	1		; principal paid
remain_bal	resd	1		; remaining balance
answer		resd 	1		; answer to loop for getdata
linecount	resd	1		; buffer to hold line count
time_stamp	resd	1		; holds the system time
