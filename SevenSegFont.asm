;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;* Seven Segment Big Font file for usage in Graphical LCD programs.                         *
;* This library needs a segment named .fonts defined. This is necessary for ease of         *
;* positioning the font's data in flash memory, at the willing space. Each glyph is of size *
;* of 200 bytes (in memory size) and 32x50 in pixel size.                                   *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - 7 Segment Font"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------


;============================================================================================
; LIBRARY DEFINITIONS - This section contains definitions, global to all program
;--------------------------------------------------------------------------------------------
SEVENSEGFONTH	.equ	46					;The height of the font in pixels
SEVENSEGFONTW	.equ	32					;The width of each character in pixels
SEVENSEGFONTL	.equ	184					;The length of each glyph in bytes
SEVENSEGMINCHAR	.equ	030h				;Minimum character available by this font is
											; digit '0'
SEVENSEGMAXCHAR	.equ	03Ah				;Maximum character available by this font is
											; character ':'
SevenSegProp	.equ	0					;No proportional part for this font


;==< specify which must be global >==========================================================
			.def	SEVENSEGFONTH
			.def	SEVENSEGFONTW
			.def	SEVENSEGFONTL
			.def	SEVENSEGMINCHAR
			.def	SEVENSEGMAXCHAR

;============================================================================================
; FONTS - This section contains constant data written in Flash (.fonts section)
;--------------------------------------------------------------------------------------------
			.def	SevenSegFont
			.def	SevenSegProp

			.sect	".fonts"
			.align	1
;Glyph data
SevenSegFont:
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			.byte	00Ch,0FFh,0FEh,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Eh,000h,000h,078h,038h,000h,000h,018h,020h,000h,000h,008h
			.byte	000h,000h,000h,000h,020h,000h,000h,000h,038h,000h,000h,018h
			.byte	03Eh,000h,000h,078h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	01Eh,000h,000h,0F0h,00Ch,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			.byte	003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 0
			.byte	000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,060h
			.byte	000h,000h,000h,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,078h,000h,000h,000h,018h,000h,000h,000h,008h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,018h
			.byte	000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,0F0h,000h,000h,000h,060h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 1
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			.byte	000h,0FFh,0FEh,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,078h,001h,0FFh,0FEh,018h,003h,0FFh,0FFh,088h
			.byte	00Fh,0FFh,0FFh,0E0h,027h,0FFh,0FFh,0C0h,039h,0FFh,0FFh,000h
			.byte	03Eh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	01Eh,000h,000h,000h,00Ch,0FFh,0FEh,000h,001h,0FFh,0FFh,000h
			.byte	003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 2
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			.byte	000h,0FFh,0FEh,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,078h,001h,0FFh,0FEh,018h,003h,0FFh,0FFh,088h
			.byte	00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			.byte	000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,0F0h,000h,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			.byte	003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 3
			.byte	000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,060h
			.byte	00Ch,000h,000h,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Eh,000h,000h,078h,039h,0FFh,0FEh,018h,023h,0FFh,0FFh,088h
			.byte	00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			.byte	000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,0F0h,000h,000h,000h,060h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h
			.byte	00Ch,0FFh,0FEh,000h,01Eh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Eh,000h,000h,000h,039h,0FFh,0FEh,000h,023h,0FFh,0FFh,080h
			.byte	00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			.byte	000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,0F0h,000h,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			.byte	003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 5
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h
			.byte	00Ch,0FFh,0FEh,000h,01Eh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			.byte	03Eh,000h,000h,000h,039h,0FFh,0FEh,000h,023h,0FFh,0FFh,080h
			.byte	00Fh,0FFh,0FFh,0E0h,027h,0FFh,0FFh,0C0h,039h,0FFh,0FFh,018h
			.byte	03Eh,000h,000h,078h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	01Eh,000h,000h,0F0h,00Ch,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			.byte	003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 6
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			.byte	000h,0FFh,0FEh,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,078h,000h,000h,000h,018h,000h,000h,000h,008h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,018h
			.byte	000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,0F0h,000h,000h,000h,060h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			.byte	00Ch,0FFh,0FEh,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Eh,000h,000h,078h,039h,0FFh,0FEh,018h,023h,0FFh,0FFh,088h
			.byte	00Fh,0FFh,0FFh,0E0h,027h,0FFh,0FFh,0C0h,039h,0FFh,0FFh,018h
			.byte	03Eh,000h,000h,078h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	01Eh,000h,000h,0F0h,00Ch,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			.byte	003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 8
			.byte	000h,0FFh,0FEh,000h
			.byte	001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			.byte	00Ch,0FFh,0FEh,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			.byte	03Eh,000h,000h,078h,039h,0FFh,0FEh,018h,023h,0FFh,0FFh,088h
			.byte	00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			.byte	000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			.byte	000h,000h,000h,0F0h,000h,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			.byte	003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 9
			.byte	000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,0E0h,000h,000h,001h,0F0h,000h,000h,003h,0F8h,000h
			.byte	000h,003h,0F8h,000h,000h,003h,0F8h,000h,000h,001h,0F0h,000h
			.byte	000h,000h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,0E0h,000h,000h,001h,0F0h,000h,000h,003h,0F8h,000h
			.byte	000h,003h,0F8h,000h,000h,003h,0F8h,000h,000h,001h,0F0h,000h
			.byte	000h,000h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; :
