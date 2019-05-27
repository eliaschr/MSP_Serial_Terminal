;********************************************************************************************
;*                             MSP Hydro and Temperature Meter                              *
;********************************************************************************************
;* Seven Segment Big Font file for usage in Graphical LCD programs.                         *
;* This library needs a segment named .fonts defined. This is necessary for ease of         *
;* positioning the font's data in flash memory, at the willing space. Each glyph is of size *
;* of 200 bytes (in memory size) and 32x50 in pixel size.                                   *
;********************************************************************************************
#include <msp430.h>

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------


;============================================================================================
; LIBRARY DEFINITIONS - This section contains definitions, global to all program
;--------------------------------------------------------------------------------------------
SEVENSEGEMPTYFONTH		EQU		46			;The height of the font in pixels
SEVENSEGEMPTYFONTW		EQU		32			;The width of each character in pixels
SEVENSEGEMPTYFONTL		EQU		184			;The length of each glyph in bytes
SEVENSEGEMPTYMINCHAR	EQU		030h		;Minimum character available by this font is
											; digit '0'
SEVENSEGEMPTYMAXCHAR	EQU		03Ah		;Maximum character available by this font is
											; character ':'
SevenSegEmptyProp		EQU		0			;No proportional part for this font


;==< specify which must be global >==========================================================
			PUBLIC	SEVENSEGEMPTYFONTH
			PUBLIC	SEVENSEGEMPTYFONTW
			PUBLIC	SEVENSEGEMPTYFONTL
			PUBLIC	SEVENSEGEMPTYMINCHAR
			PUBLIC	SEVENSEGEMPTYMAXCHAR

;============================================================================================
; FONTS - This section contains constant data written in Flash (.fonts section)
;--------------------------------------------------------------------------------------------
			PUBLIC	SevenSegEmptyFont
			PUBLIC	SevenSegEmptyProp

			.sect "FONTS"
			.align	1
;Glyph data
SevenSegEmptyFont:
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			DB		00Ch,0FFh,0FEh,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Eh,000h,000h,078h,038h,000h,000h,018h,020h,000h,000h,008h
			DB		000h,000h,000h,000h,020h,000h,000h,000h,038h,000h,000h,018h
			DB		03Eh,000h,000h,078h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		01Eh,000h,000h,0F0h,00Ch,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			DB		003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 0
			DB		000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,060h
			DB		000h,000h,000h,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,078h,000h,000h,000h,018h,000h,000h,000h,008h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,018h
			DB		000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,0F0h,000h,000h,000h,060h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 1
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			DB		000h,0FFh,0FEh,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,078h,001h,0FFh,0FEh,018h,003h,0FFh,0FFh,088h
			DB		00Fh,0FFh,0FFh,0E0h,027h,0FFh,0FFh,0C0h,039h,0FFh,0FFh,000h
			DB		03Eh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		01Eh,000h,000h,000h,00Ch,0FFh,0FEh,000h,001h,0FFh,0FFh,000h
			DB		003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 2
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			DB		000h,0FFh,0FEh,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,078h,001h,0FFh,0FEh,018h,003h,0FFh,0FFh,088h
			DB		00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			DB		000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,0F0h,000h,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			DB		003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 3
			DB		000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,060h
			DB		00Ch,000h,000h,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Eh,000h,000h,078h,039h,0FFh,0FEh,018h,023h,0FFh,0FFh,088h
			DB		00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			DB		000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,0F0h,000h,000h,000h,060h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h
			DB		00Ch,0FFh,0FEh,000h,01Eh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Eh,000h,000h,000h,039h,0FFh,0FEh,000h,023h,0FFh,0FFh,080h
			DB		00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			DB		000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,0F0h,000h,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			DB		003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 5
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h
			DB		00Ch,0FFh,0FEh,000h,01Eh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Fh,000h,000h,000h,03Fh,000h,000h,000h,03Fh,000h,000h,000h
			DB		03Eh,000h,000h,000h,039h,0FFh,0FEh,000h,023h,0FFh,0FFh,080h
			DB		00Fh,0FFh,0FFh,0E0h,027h,0FFh,0FFh,0C0h,039h,0FFh,0FFh,018h
			DB		03Eh,000h,000h,078h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		01Eh,000h,000h,0F0h,00Ch,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			DB		003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 6
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			DB		000h,0FFh,0FEh,0F0h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,078h,000h,000h,000h,018h,000h,000h,000h,008h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,018h
			DB		000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,0F0h,000h,000h,000h,060h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			DB		00Ch,0FFh,0FEh,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Eh,000h,000h,078h,039h,0FFh,0FEh,018h,023h,0FFh,0FFh,088h
			DB		00Fh,0FFh,0FFh,0E0h,027h,0FFh,0FFh,0C0h,039h,0FFh,0FFh,018h
			DB		03Eh,000h,000h,078h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		01Eh,000h,000h,0F0h,00Ch,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			DB		003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 8
			DB		000h,0FFh,0FEh,000h
			DB		001h,0FFh,0FFh,000h,003h,0FFh,0FFh,080h,001h,0FFh,0FFh,060h
			DB		00Ch,0FFh,0FEh,0F0h,01Eh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h,03Fh,000h,001h,0F8h
			DB		03Eh,000h,000h,078h,039h,0FFh,0FEh,018h,023h,0FFh,0FFh,088h
			DB		00Fh,0FFh,0FFh,0E0h,007h,0FFh,0FFh,0C0h,001h,0FFh,0FFh,018h
			DB		000h,000h,000h,078h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,001h,0F8h,000h,000h,001h,0F8h,000h,000h,001h,0F8h
			DB		000h,000h,000h,0F0h,000h,0FFh,0FEh,060h,001h,0FFh,0FFh,000h
			DB		003h,0FFh,0FFh,080h,001h,0FFh,0FFh,000h,000h,0FFh,0FEh,000h	; 9
			DB		000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,0E0h,000h,000h,001h,0F0h,000h,000h,003h,0F8h,000h
			DB		000h,003h,0F8h,000h,000h,003h,0F8h,000h,000h,001h,0F0h,000h
			DB		000h,000h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,0E0h,000h,000h,001h,0F0h,000h,000h,003h,0F8h,000h
			DB		000h,003h,0F8h,000h,000h,003h,0F8h,000h,000h,001h,0F0h,000h
			DB		000h,000h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			DB		000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; :
