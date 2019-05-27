;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;*                                                                                          *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - Simple Math Funcs Library"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------
			.asg	R8,DIVIDENT_H
			.asg	R7,DIVIDENT_L
			.asg	R9,DIVISOR
			.asg	R11,RESULT_H
			.asg	R10,RESULT_L
			.asg	R12,MODULO
			.asg	R14,BITCOUNTER

;--< Some of them must be public >-----------------------------------------------------------
;The reason is that it is easier for the rest of the program files to initialise the correct
; registers, according to the settings the functions use in this file
			.def	DIVIDENT_H
			.def	DIVIDENT_L
			.def	DIVISOR
			.def	RESULT_H
			.def	RESULT_L
			.def	MODULO

;============================================================================================
; PROGRAM FUNCTIONS
;--------------------------------------------------------------------------------------------
;--< Some of the labels must be available to other files >-----------------------------------
			.def	UDivide32

			.text							;Place program in ROM (Flash)
			.align	1
UDivide32:
; Divides an Unsigned 32 bit number by an Unsigned 16 bit number
; Input:				DIVIDENT is the register specified in the definitions section
;						 High word is DIVIDENT_H, Low word is DIVIDENT_L
;						DIVISOR is the register specified in the definitions section
; Output:				RESULT is the register specified in the definitions section
;						 High word is stored in RESULT_H and low word is stored in RESULT_L
;						MODULO is the register specified in the definitions section
;						Carry flag is set on divide by 0, else reset
; Registers Used:		BITCOUNTER, DIVIDENT, DIVISOR_H, DIVISOR_L, MODULO, RESULT_H, RESULT_L
; Registers Altered:	MODULO, RESULT_H, RESULT_L
; Stack Usage:			None
; Depend On Defs:		BITCOUNTER, DIVIDENT, DIVISOR_H, DIVISOR_L, MODULO, RESULT_H, RESULT_L
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			MOV		#0FFFFh,RESULT_H		;Maximum value for result in case of DIV by 0
			MOV		#0FFFFh,RESULT_L
			MOV		#0FFFFh,MODULO			;Maximum value for modulo in case of DIV by 0
			CMP		#00000h,DIVISOR			;Do we have a division by 0?
			JEQ		Div32Exit				;Yes => Exit with carry flag set
			MOV		#00000h,RESULT_H		;Clear result
			MOV		#00000h,RESULT_L
			MOV		#00000h,MODULO			;Clear the remain of division
			MOV.B	#020h,BITCOUNTER		;Number of bits of division
Div32Nxt:	ADD		DIVIDENT_L,DIVIDENT_L	;MSB of DIVIDENT is transfered to...
			ADDC	DIVIDENT_H,DIVIDENT_H
			ADDC	MODULO,MODULO			;... MODULO value
			BIT		#BIT0,MODULO			;Carry flag is restored
			ADDC	#00000h,DIVIDENT_L		;Add back the MSB to LSB. In that way DIVIDENT was
											; rolled left without carry
			CMP		DIVISOR,MODULO			;Is the MODULO >= DIVISOR?
			ADDC	RESULT_L,RESULT_L		;Carry flag contains the result, so push it from
			ADDC	RESULT_H,RESULT_H		; right to the RESULT
			BIT		#BIT0,RESULT_L			;Restore carry flag altered by last addition
			JZ		Div32NoDec				;MODULO < DIVISOR => Do not subtract divisor from
											; remain
			SUB		DIVISOR,MODULO			;else, perform the subtraction
Div32NoDec:	DEC		BITCOUNTER				;One bit less
			JNZ		Div32Nxt				;More bits? => Repeat
			CLRC							;Clear carry to flag success
Div32Exit:	RET								;and return to caller
;-------------------------------------------

			.end
