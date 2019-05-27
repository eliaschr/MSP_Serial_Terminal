;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;* Inconsola file for usage in Graphical LCD programs.                                      *
;* This library needs a segment named .fonts defined. This is necessary for ease of         *
;* positioning the font's data in flash memory, at the willing space. Each glyph is of size *
;* of 96 bytes (in memory size) and 24x32 in pixel size.                                    *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - Inconsola Font"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------


;============================================================================================
; LIBRARY DEFINITIONS - This section contains definitions, global to all program
;--------------------------------------------------------------------------------------------
INCONSOLAH			.equ	32				;The height of the font in pixels
INCONSOLAW			.equ	24				;The width of each character in pixels
INCONSOLAL			.equ	96				;The length of each glyph in bytes
INCONSOLAMINCHAR	.equ	020h			;The minimum character number available by this
											; font
INCONSOLAMAXCHAR	.equ	07Fh			;The maximum character number available by this
											; font


;==< specify which must be global >==========================================================
			.def	INCONSOLAH
			.def	INCONSOLAW
			.def	INCONSOLAL
			.def	INCONSOLAMINCHAR
			.def	INCONSOLAMAXCHAR

;============================================================================================
; FONTS - This section contains constant data written in Flash (.fonts section)
;--------------------------------------------------------------------------------------------
			.def	Inconsola
			.def	InconsolaProp

			.sect 	".fonts"
			.align	1
InconsolaProp:
;New proportional data for font. For each glyph there are two bytes, the first shows the left
; border that should not be used and the second shows the width of the glyph (after the left
; border) that is the real glyph
			.byte	000h,00Ah,009h,006h,005h,00Fh,002h,013h,003h,011h,003h,013h
			.byte	002h,013h,008h,007h,005h,00Dh,007h,00Dh,004h,011h,004h,011h
			.byte	00Ah,007h,005h,00Fh,00Ah,006h,004h,010h,003h,011h,006h,00Ah
			.byte	004h,010h,004h,00Fh,003h,011h,003h,011h,004h,00Fh,004h,00Fh
			.byte	003h,011h,004h,00Fh,009h,006h,009h,007h,002h,012h,004h,011h
			.byte	002h,012h,004h,010h,002h,012h,002h,013h,003h,011h,003h,012h
			.byte	003h,011h,003h,011h,004h,00Fh,003h,012h,003h,011h,004h,00Eh
			.byte	003h,011h,003h,012h,004h,010h,003h,011h,003h,011h,002h,013h
			.byte	003h,011h,003h,013h,003h,011h,004h,011h,003h,012h,003h,011h
			.byte	002h,013h,002h,013h,003h,012h,003h,013h,003h,012h,005h,00Dh
			.byte	005h,010h,006h,00Dh,005h,00Eh,003h,012h,006h,00Ch,004h,010h
			.byte	004h,011h,002h,011h,003h,011h,003h,011h,003h,012h,002h,013h
			.byte	004h,00Fh,005h,00Dh,005h,00Eh,003h,011h,003h,010h,003h,013h
			.byte	005h,00Fh,003h,011h,003h,011h,004h,011h,004h,00Fh,003h,010h
			.byte	004h,010h,003h,011h,003h,012h,002h,013h,004h,011h,002h,012h
			.byte	003h,011h,004h,00Fh,00Ah,005h,006h,010h,003h,012h,000h,018h

;Glyph data
Inconsola:
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; <space>	12

			.byte	000h,018h,000h,000h,03Ch,000h,000h,03Ch,000h,000h,03Ch,000h
			.byte	000h,03Ch,000h,000h,03Ch,000h,000h,03Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,018h,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,018h,000h,000h,03Ch,000h,000h,03Ch,000h
			.byte	000h,03Ch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; !			15

			.byte	000h,0C0h,080h,001h,0E1h,0E0h,001h,0E1h,0E0h,001h,0F1h,0E0h
			.byte	000h,0E0h,0E0h,000h,060h,0E0h,000h,0E0h,0C0h,000h,0C1h,0C0h
			.byte	001h,081h,080h,003h,003h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; "			20

			.byte	000h,000h,000h,000h,0E1h,080h,000h,0E1h,080h,000h,0C1h,080h
			.byte	000h,0C3h,080h,000h,0C3h,080h,000h,0C3h,000h,00Fh,0FFh,0F0h
			.byte	01Fh,0FFh,0F0h,001h,0C3h,000h,001h,0C3h,000h,001h,083h,000h
			.byte	001h,087h,000h,001h,087h,000h,001h,086h,000h,01Fh,0FFh,0E0h
			.byte	01Fh,0FFh,0E0h,001h,086h,000h,003h,086h,000h,003h,006h,000h
			.byte	003h,006h,000h,003h,00Eh,000h,003h,00Eh,000h,003h,00Ch,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; #

			.byte	000h,000h,000h,000h,018h,000h,000h,018h,000h,000h,0FEh,000h
			.byte	001h,0FFh,080h,003h,09Bh,0E0h,007h,018h,0C0h,007h,018h,080h
			.byte	007h,018h,000h,007h,018h,000h,003h,098h,000h,003h,0F8h,000h
			.byte	000h,0FCh,000h,000h,07Fh,000h,000h,01Fh,0C0h,000h,019h,0C0h
			.byte	000h,018h,0E0h,000h,018h,060h,000h,018h,060h,004h,018h,060h
			.byte	006h,018h,0E0h,00Fh,019h,0C0h,003h,0FFh,080h,001h,0FFh,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,018h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; $

			.byte	000h,000h,000h,001h,0C0h,000h,007h,0E0h,070h,007h,070h,060h
			.byte	00Eh,030h,0E0h,00Ch,030h,0C0h,00Ch,031h,080h,00Eh,033h,080h
			.byte	006h,073h,000h,007h,0E7h,000h,003h,0C6h,000h,000h,00Eh,000h
			.byte	000h,00Ch,000h,000h,01Ch,000h,000h,018h,000h,000h,030h,000h
			.byte	000h,071h,0E0h,000h,063h,0F0h,000h,0E6h,038h,000h,0C6h,018h
			.byte	001h,0C6h,018h,001h,086h,018h,003h,086h,038h,003h,003h,0F0h
			.byte	006h,001h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; %

			.byte	000h,020h,000h,001h,0FCh,000h,003h,0FEh,000h,003h,08Eh,000h
			.byte	003h,006h,000h,007h,007h,000h,003h,006h,000h,003h,086h,000h
			.byte	003h,08Eh,000h,001h,0DCh,000h,000h,0F8h,000h,000h,0F0h,000h
			.byte	003h,0F0h,000h,007h,0B8h,040h,007h,01Ch,060h,00Eh,01Ch,070h
			.byte	00Eh,00Eh,0E0h,00Ch,007h,0C0h,01Ch,003h,0C0h,00Ch,003h,080h
			.byte	00Eh,007h,0C0h,00Fh,01Eh,0E0h,007h,0FCh,0F0h,003h,0F8h,060h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; &

			.byte	000h,018h,000h,000h,03Ch,000h,000h,03Ch,000h,000h,03Ch,000h
			.byte	000h,01Ch,000h,000h,00Ch,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,030h,000h,000h,060h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; '

			.byte	000h,001h,000h,000h,007h,000h,000h,00Fh,080h,000h,01Ch,000h
			.byte	000h,038h,000h,000h,070h,000h,000h,070h,000h,000h,0E0h,000h
			.byte	000h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,080h,000h
			.byte	001h,080h,000h,003h,080h,000h,003h,080h,000h,003h,080h,000h
			.byte	003h,080h,000h,003h,080h,000h,001h,080h,000h,001h,080h,000h
			.byte	001h,0C0h,000h,001h,0C0h,000h,000h,0E0h,000h,000h,0E0h,000h
			.byte	000h,070h,000h,000h,078h,000h,000h,038h,000h,000h,01Ch,000h
			.byte	000h,00Fh,000h,000h,007h,080h,000h,003h,000h,000h,000h,000h ; (

			.byte	000h,080h,000h,000h,0E0h,000h,000h,0F0h,000h,000h,078h,000h
			.byte	000h,01Ch,000h,000h,00Eh,000h,000h,007h,000h,000h,007h,000h
			.byte	000h,003h,080h,000h,003h,080h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,000h,0C0h,000h,000h,0C0h,000h,000h,0C0h,000h,000h,0E0h
			.byte	000h,000h,0E0h,000h,000h,0C0h,000h,000h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,080h,000h,003h,080h,000h,003h,080h
			.byte	000h,007h,000h,000h,00Eh,000h,000h,01Eh,000h,000h,03Ch,000h
			.byte	000h,078h,000h,000h,0F0h,000h,000h,0C0h,000h,000h,080h,000h ; )

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,004h,01Ch,010h,007h,018h,070h,007h,0C9h,0F0h
			.byte	001h,0FFh,0C0h,000h,03Ch,000h,000h,03Ch,000h,000h,076h,000h
			.byte	000h,063h,000h,000h,0E3h,080h,001h,0C1h,0C0h,003h,081h,0C0h
			.byte	000h,080h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; *

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	007h,0FFh,0F0h,007h,0FFh,0F0h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; +

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,006h,000h
			.byte	000h,00Fh,000h,000h,00Fh,000h,000h,00Fh,000h,000h,007h,000h
			.byte	000h,003h,000h,000h,006h,000h,000h,006h,000h,000h,00Ch,000h
			.byte	000h,018h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; ,

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	003h,0FFh,0E0h,003h,0FFh,0E0h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; -

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,00Ch,000h,000h,01Eh,000h,000h,01Eh,000h,000h,01Eh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; .

			.byte	000h,000h,040h,000h,000h,0E0h,000h,000h,0E0h,000h,000h,0C0h
			.byte	000h,001h,0C0h,000h,001h,080h,000h,003h,080h,000h,003h,000h
			.byte	000h,007h,000h,000h,007h,000h,000h,00Eh,000h,000h,00Eh,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,030h,000h,000h,070h,000h,000h,060h,000h,000h,0E0h,000h
			.byte	000h,0C0h,000h,001h,0C0h,000h,001h,080h,000h,003h,080h,000h
			.byte	003h,080h,000h,007h,000h,000h,001h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; /


			.byte	000h,010h,000h,000h,0FCh,000h,001h,0FEh,000h,003h,0C7h,000h
			.byte	003h,083h,080h,007h,001h,080h,006h,001h,0C0h,006h,003h,0C0h
			.byte	00Eh,007h,0C0h,00Eh,00Eh,0C0h,00Eh,01Ch,0E0h,00Ch,018h,0E0h
			.byte	00Ch,038h,0E0h,00Eh,070h,0E0h,00Eh,0E0h,0E0h,00Eh,0C0h,0C0h
			.byte	00Fh,0C0h,0C0h,007h,080h,0C0h,007h,001h,0C0h,007h,001h,080h
			.byte	003h,083h,080h,003h,0C7h,000h,000h,0FEh,000h,000h,07Ch,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 0

			.byte	000h,000h,000h,000h,00Eh,000h,000h,03Eh,000h,001h,0FEh,000h
			.byte	000h,0C6h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h
			.byte	000h,006h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h
			.byte	000h,006h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h
			.byte	000h,006h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h
			.byte	000h,006h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 1

			.byte	000h,010h,000h,000h,0FEh,000h,001h,0FFh,000h,003h,087h,080h
			.byte	007h,001h,0C0h,002h,001h,0C0h,000h,001h,0C0h,000h,000h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,003h,080h,000h,003h,080h
			.byte	000h,007h,000h,000h,00Eh,000h,000h,01Ch,000h,000h,038h,000h
			.byte	000h,070h,000h,000h,0E0h,000h,001h,0C0h,000h,003h,080h,000h
			.byte	003h,080h,000h,007h,000h,020h,007h,0FFh,0C0h,007h,0FFh,0C0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 2

			.byte	000h,000h,000h,000h,0FCh,000h,003h,0FFh,000h,007h,007h,000h
			.byte	002h,003h,080h,000h,001h,080h,000h,001h,080h,000h,001h,080h
			.byte	000h,003h,080h,000h,007h,000h,000h,01Eh,000h,000h,07Ch,000h
			.byte	000h,07Fh,000h,000h,007h,080h,000h,003h,080h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,002h,001h,0C0h
			.byte	002h,003h,080h,007h,087h,080h,003h,0FFh,000h,001h,0FCh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 3

			.byte	000h,000h,000h,000h,007h,000h,000h,00Fh,000h,000h,00Fh,000h
			.byte	000h,01Fh,000h,000h,03Fh,000h,000h,037h,000h,000h,067h,000h
			.byte	000h,067h,000h,000h,0C7h,000h,001h,0C7h,000h,001h,087h,000h
			.byte	003h,007h,000h,007h,007h,000h,006h,007h,000h,00Fh,0FFh,0E0h
			.byte	00Fh,0FFh,0E0h,00Fh,0FFh,0E0h,000h,007h,000h,000h,007h,000h
			.byte	000h,007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 4

			.byte	000h,000h,000h,003h,0FFh,0C0h,003h,0FFh,0C0h,003h,000h,000h
			.byte	003h,000h,000h,003h,000h,000h,003h,000h,000h,003h,000h,000h
			.byte	007h,000h,000h,007h,0FEh,000h,007h,0FFh,000h,007h,087h,080h
			.byte	007h,001h,0C0h,000h,001h,0C0h,000h,000h,0C0h,000h,000h,0E0h
			.byte	000h,000h,0E0h,000h,000h,0E0h,000h,000h,0C0h,002h,001h,0C0h
			.byte	00Eh,001h,0C0h,007h,087h,080h,003h,0FFh,000h,001h,0FEh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 5

			.byte	000h,008h,000h,000h,07Fh,000h,000h,0FFh,0C0h,001h,0C1h,080h
			.byte	003h,080h,080h,003h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	006h,000h,000h,006h,03Eh,000h,006h,0FFh,000h,007h,0C7h,080h
			.byte	007h,081h,080h,007h,001h,0C0h,006h,000h,0C0h,006h,000h,0C0h
			.byte	006h,000h,0C0h,006h,000h,0C0h,007h,000h,0C0h,003h,001h,0C0h
			.byte	003h,081h,0C0h,001h,0C3h,080h,000h,0FFh,000h,000h,07Eh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 6

			.byte	000h,000h,000h,007h,0FFh,0C0h,007h,0FFh,0C0h,000h,001h,0C0h
			.byte	000h,003h,080h,000h,003h,080h,000h,003h,000h,000h,007h,000h
			.byte	000h,007h,000h,000h,00Eh,000h,000h,00Eh,000h,000h,00Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,070h,000h,000h,070h,000h,000h,070h,000h
			.byte	000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h,001h,0C0h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 7

			.byte	000h,018h,000h,000h,0FEh,000h,001h,0FFh,000h,003h,083h,080h
			.byte	003h,001h,080h,007h,001h,0C0h,007h,001h,0C0h,003h,001h,0C0h
			.byte	003h,083h,080h,001h,0C7h,000h,000h,0FEh,000h,000h,07Ch,000h
			.byte	001h,0FFh,000h,003h,0C7h,080h,007h,003h,080h,007h,001h,0C0h
			.byte	006h,000h,0C0h,00Eh,000h,0E0h,00Eh,000h,0C0h,006h,000h,0C0h
			.byte	007h,001h,0C0h,007h,083h,080h,003h,0FFh,080h,000h,0FEh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 8

			.byte	000h,010h,000h,000h,0FEh,000h,001h,0FFh,000h,003h,087h,080h
			.byte	007h,003h,080h,007h,001h,0C0h,006h,001h,0C0h,006h,000h,0C0h
			.byte	006h,000h,0C0h,006h,000h,0C0h,007h,000h,0C0h,007h,001h,0C0h
			.byte	003h,083h,0C0h,003h,0FEh,0C0h,000h,0FCh,0C0h,000h,020h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,003h,080h
			.byte	002h,003h,080h,003h,00Fh,000h,007h,0FEh,000h,001h,0F8h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; 9

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,018h,000h
			.byte	000h,03Ch,000h,000h,03Ch,000h,000h,03Ch,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,018h,000h
			.byte	000h,03Ch,000h,000h,03Ch,000h,000h,03Ch,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; :

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ch,000h
			.byte	000h,01Eh,000h,000h,01Eh,000h,000h,01Eh,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00Ch,000h
			.byte	000h,01Eh,000h,000h,01Eh,000h,000h,01Eh,000h,000h,00Eh,000h
			.byte	000h,006h,000h,000h,00Ch,000h,000h,00Ch,000h,000h,018h,000h
			.byte	000h,030h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; ;

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,020h,000h,000h,0E0h,000h,003h,0E0h,000h,00Fh,080h
			.byte	000h,03Eh,000h,000h,0F8h,000h,003h,0E0h,000h,00Fh,080h,000h
			.byte	01Eh,000h,000h,01Eh,000h,000h,00Fh,080h,000h,003h,0E0h,000h
			.byte	000h,0F0h,000h,000h,07Ch,000h,000h,01Fh,000h,000h,007h,0C0h
			.byte	000h,001h,0E0h,000h,000h,0E0h,000h,000h,020h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; <

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,007h,0FFh,0F0h
			.byte	007h,0FFh,0F0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,007h,0FFh,0F0h,007h,0FFh,0F0h
			.byte	007h,0FFh,0F0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; =

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	008h,000h,000h,00Eh,000h,000h,00Fh,080h,000h,003h,0E0h,000h
			.byte	000h,0F8h,000h,000h,03Eh,000h,000h,00Fh,000h,000h,003h,0C0h
			.byte	000h,000h,0E0h,000h,000h,0E0h,000h,003h,0C0h,000h,00Fh,080h
			.byte	000h,03Eh,000h,000h,078h,000h,001h,0F0h,000h,007h,0C0h,000h
			.byte	01Fh,000h,000h,01Ch,000h,000h,018h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; >

			.byte	000h,000h,000h,000h,03Eh,000h,000h,0FFh,080h,001h,0FFh,0C0h
			.byte	007h,081h,0C0h,003h,000h,0E0h,001h,000h,0E0h,000h,000h,0E0h
			.byte	000h,000h,0E0h,000h,000h,0E0h,000h,001h,0E0h,000h,003h,0C0h
			.byte	000h,007h,080h,000h,007h,000h,000h,00Eh,000h,000h,00Ch,000h
			.byte	000h,00Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,00Ch,000h,000h,01Eh,000h
			.byte	000h,01Eh,000h,000h,01Eh,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; ?


			.byte	000h,000h,000h,000h,01Ch,000h,000h,0FFh,000h,001h,0E7h,080h
			.byte	003h,081h,0C0h,007h,000h,0E0h,006h,000h,060h,00Eh,000h,060h
			.byte	00Ch,003h,0E0h,00Ch,01Fh,0E0h,01Ch,03Ch,060h,01Ch,070h,060h
			.byte	018h,060h,060h,018h,060h,060h,01Ch,060h,060h,01Ch,070h,0E0h
			.byte	01Ch,079h,0E0h,00Ch,03Fh,0E0h,00Ch,00Eh,000h,00Eh,000h,000h
			.byte	007h,000h,000h,003h,080h,000h,003h,0C0h,0C0h,000h,0FFh,0C0h
			.byte	000h,07Fh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; @

			.byte	000h,020h,000h,000h,030h,000h,000h,030h,000h,000h,030h,000h
			.byte	000h,078h,000h,000h,078h,000h,000h,078h,000h,000h,0FCh,000h
			.byte	000h,0CCh,000h,000h,0CEh,000h,001h,086h,000h,001h,086h,000h
			.byte	001h,087h,000h,003h,003h,000h,003h,003h,080h,003h,0FFh,080h
			.byte	007h,0FFh,080h,006h,001h,0C0h,00Eh,001h,0C0h,00Eh,000h,0C0h
			.byte	00Ch,000h,0E0h,01Ch,000h,0E0h,01Ch,000h,070h,018h,000h,070h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; A

			.byte	000h,000h,000h,00Fh,0FEh,000h,00Fh,0FFh,000h,00Ch,007h,080h
			.byte	00Ch,001h,0C0h,00Ch,001h,0C0h,00Ch,000h,0C0h,00Ch,001h,0C0h
			.byte	00Ch,001h,0C0h,00Ch,003h,080h,00Fh,0FFh,000h,00Fh,0FEh,000h
			.byte	00Fh,0FFh,080h,00Ch,003h,0C0h,00Ch,001h,0C0h,00Ch,000h,0E0h
			.byte	00Ch,000h,0E0h,00Ch,000h,0E0h,00Ch,000h,0E0h,00Ch,000h,0E0h
			.byte	00Ch,001h,0C0h,00Ch,007h,0C0h,00Fh,0FFh,080h,00Fh,0FCh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; B

			.byte	000h,008h,000h,000h,07Fh,000h,001h,0FFh,0C0h,003h,0C1h,0E0h
			.byte	007h,080h,0E0h,007h,000h,070h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Ch,000h,000h,00Ch,000h,000h,00Ch,000h,000h
			.byte	00Ch,000h,000h,00Ch,000h,000h,00Ch,000h,000h,00Ch,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,007h,000h,000h,007h,000h,040h
			.byte	003h,080h,0E0h,003h,0C1h,0C0h,000h,0FFh,080h,000h,07Fh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; C

			.byte	000h,000h,000h,00Fh,0FCh,000h,00Fh,0FFh,000h,00Ch,00Fh,080h
			.byte	00Ch,003h,080h,00Ch,001h,0C0h,00Ch,001h,0C0h,00Ch,000h,0E0h
			.byte	00Ch,000h,0E0h,00Ch,000h,0E0h,00Ch,000h,0E0h,00Ch,000h,0E0h
			.byte	00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,0E0h,00Ch,000h,0E0h
			.byte	00Ch,000h,0E0h,00Ch,000h,0C0h,00Ch,001h,0C0h,00Ch,001h,0C0h
			.byte	00Ch,003h,080h,00Ch,00Fh,000h,00Fh,0FEh,000h,00Fh,0F8h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; D

			.byte	000h,000h,000h,00Fh,0FFh,0E0h,00Fh,0FFh,0E0h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h,00Fh,0FFh,000h
			.byte	00Fh,0FFh,000h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Fh,0FFh,0C0h,00Fh,0FFh,0C0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; E

			.byte	000h,000h,000h,007h,0FFh,0C0h,007h,0FFh,0C0h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,0FFh,000h,007h,0FFh,000h
			.byte	007h,0FFh,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; F

			.byte	000h,004h,000h,000h,07Fh,080h,000h,0FFh,0C0h,001h,0E0h,0E0h
			.byte	003h,080h,070h,003h,080h,020h,007h,000h,000h,007h,000h,000h
			.byte	006h,000h,000h,006h,000h,000h,006h,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,003h,0F0h,00Eh,003h,0F0h,006h,000h,030h
			.byte	006h,000h,030h,007h,000h,030h,007h,000h,030h,003h,080h,030h
			.byte	003h,0C0h,030h,001h,0E0h,0F0h,000h,0FFh,0E0h,000h,03Fh,080h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; G

			.byte	000h,000h,000h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Fh,0FFh,0E0h
			.byte	00Fh,0FFh,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; H

			.byte	000h,000h,000h,007h,0FFh,080h,007h,0FFh,080h,000h,030h,000h
			.byte	000h,030h,000h,000h,030h,000h,000h,030h,000h,000h,030h,000h
			.byte	000h,030h,000h,000h,030h,000h,000h,030h,000h,000h,030h,000h
			.byte	000h,030h,000h,000h,030h,000h,000h,030h,000h,000h,030h,000h
			.byte	000h,030h,000h,000h,030h,000h,000h,030h,000h,000h,030h,000h
			.byte	000h,030h,000h,000h,030h,000h,007h,0FFh,080h,007h,0FFh,080h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; I

			.byte	000h,000h,000h,000h,0FFh,0E0h,000h,0FFh,0E0h,000h,007h,000h
			.byte	000h,007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h
			.byte	000h,007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h
			.byte	000h,007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h
			.byte	000h,007h,000h,000h,006h,000h,000h,006h,000h,000h,00Eh,000h
			.byte	004h,00Eh,000h,00Fh,01Ch,000h,007h,0F8h,000h,003h,0F8h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; J

			.byte	002h,000h,0A0h,00Ch,001h,0C0h,00Ch,003h,080h,00Ch,007h,080h
			.byte	00Ch,007h,000h,00Ch,00Eh,000h,00Ch,01Ch,000h,00Ch,038h,000h
			.byte	00Ch,070h,000h,00Ch,0E0h,000h,00Dh,0C0h,000h,00Fh,0E0h,000h
			.byte	00Fh,0E0h,000h,00Eh,070h,000h,00Ch,038h,000h,00Ch,03Ch,000h
			.byte	00Ch,01Ch,000h,00Ch,00Eh,000h,00Ch,00Fh,000h,00Ch,007h,000h
			.byte	00Ch,003h,080h,00Ch,001h,0C0h,00Ch,001h,0E0h,00Ch,000h,0F0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; K

			.byte	000h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,0FFh,0E0h,007h,0FFh,0E0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; L

			.byte	000h,000h,000h,00Ch,000h,060h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Fh,001h,0E0h,00Fh,001h,0E0h,00Fh,083h,0E0h,00Fh,083h,060h
			.byte	00Dh,0C7h,060h,00Ch,0C6h,060h,00Ch,0EEh,060h,00Ch,06Ch,060h
			.byte	00Ch,078h,060h,00Ch,038h,060h,00Ch,030h,060h,00Ch,010h,060h
			.byte	00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h
			.byte	00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; M

			.byte	000h,000h,000h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Fh,000h,0E0h
			.byte	00Fh,080h,0E0h,00Fh,080h,0E0h,00Dh,0C0h,0E0h,00Dh,0C0h,0E0h
			.byte	00Ch,0E0h,0E0h,00Ch,060h,0E0h,00Ch,070h,0E0h,00Ch,038h,0E0h
			.byte	00Ch,038h,0E0h,00Ch,01Ch,0E0h,00Ch,01Ch,0E0h,00Ch,00Eh,0E0h
			.byte	00Ch,00Eh,0E0h,00Ch,007h,0E0h,00Ch,003h,0E0h,00Ch,003h,0E0h
			.byte	00Ch,001h,0E0h,00Ch,001h,0E0h,00Ch,000h,0E0h,00Ch,000h,0E0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; N

			.byte	000h,000h,000h,000h,0FEh,000h,001h,0FFh,080h,003h,083h,080h
			.byte	007h,001h,0C0h,00Eh,000h,0C0h,00Eh,000h,0E0h,00Ch,000h,0E0h
			.byte	01Ch,000h,060h,01Ch,000h,060h,01Ch,000h,070h,01Ch,000h,070h
			.byte	01Ch,000h,070h,01Ch,000h,070h,01Ch,000h,070h,01Ch,000h,060h
			.byte	00Ch,000h,060h,00Eh,000h,0E0h,00Eh,000h,0E0h,007h,001h,0C0h
			.byte	007h,081h,0C0h,003h,0C7h,080h,001h,0FFh,000h,000h,0FEh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; O

			.byte	000h,000h,000h,00Fh,0FFh,000h,00Fh,0FFh,080h,00Eh,003h,0C0h
			.byte	00Eh,001h,0C0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,001h,0C0h,00Fh,0FFh,080h
			.byte	00Fh,0FFh,000h,00Fh,0FCh,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; P

			.byte	000h,008h,000h,000h,07Fh,000h,000h,0FFh,0C0h,001h,0C1h,0C0h
			.byte	003h,080h,0E0h,007h,000h,060h,007h,000h,070h,006h,000h,070h
			.byte	00Eh,000h,030h,00Eh,000h,030h,00Eh,000h,038h,00Eh,000h,038h
			.byte	00Eh,000h,038h,00Eh,000h,038h,00Eh,000h,038h,00Eh,000h,030h
			.byte	006h,000h,030h,007h,000h,030h,007h,000h,070h,003h,000h,060h
			.byte	003h,080h,0E0h,001h,0E3h,0C0h,000h,0FFh,080h,000h,07Eh,000h
			.byte	000h,01Ch,000h,000h,00Ch,000h,000h,00Eh,000h,000h,00Fh,0F0h
			.byte	000h,007h,0F0h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; Q

			.byte	000h,000h,000h,00Fh,0FFh,000h,00Fh,0FFh,080h,00Eh,003h,0C0h
			.byte	00Eh,001h,0C0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,00Eh,001h,0C0h,00Eh,003h,0C0h,00Fh,0FFh,080h
			.byte	00Fh,0FFh,000h,00Fh,0FCh,000h,00Eh,00Ch,000h,00Eh,00Eh,000h
			.byte	00Eh,007h,000h,00Eh,007h,000h,00Eh,003h,080h,00Eh,003h,080h
			.byte	00Eh,001h,0C0h,00Eh,001h,0C0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; R

			.byte	000h,000h,000h,000h,07Fh,080h,000h,0FFh,0C0h,001h,0C0h,0E0h
			.byte	003h,080h,060h,003h,080h,040h,003h,080h,000h,003h,080h,000h
			.byte	003h,080h,000h,001h,0E0h,000h,000h,0F8h,000h,000h,07Eh,000h
			.byte	000h,01Fh,080h,000h,007h,0C0h,000h,001h,0E0h,000h,000h,0F0h
			.byte	000h,000h,070h,000h,000h,070h,000h,000h,070h,002h,000h,070h
			.byte	007h,000h,0E0h,007h,0C1h,0E0h,001h,0FFh,0C0h,000h,0FFh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; S

			.byte	000h,000h,000h,00Fh,0FFh,0F0h,00Fh,0FFh,0F0h,000h,018h,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,018h,000h,000h,018h,000h,000h,018h,000h,000h,018h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; T

			.byte	000h,000h,000h,00Eh,000h,060h,00Ch,000h,060h,00Ch,000h,060h
			.byte	00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h
			.byte	00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h
			.byte	00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h,00Ch,000h,060h
			.byte	00Ch,000h,060h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	007h,001h,0C0h,007h,083h,0C0h,003h,0FFh,080h,000h,0FEh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; U

			.byte	000h,000h,000h,01Ch,000h,070h,00Ch,000h,060h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,006h,000h,0C0h,007h,001h,0C0h,007h,001h,0C0h
			.byte	003h,001h,080h,003h,081h,080h,003h,083h,080h,001h,083h,000h
			.byte	001h,0C3h,000h,001h,0C7h,000h,000h,0C6h,000h,000h,0E6h,000h
			.byte	000h,0EEh,000h,000h,06Ch,000h,000h,07Ch,000h,000h,07Ch,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,000h,010h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; V

			.byte	000h,000h,000h,018h,000h,030h,018h,010h,030h,01Ch,010h,030h
			.byte	01Ch,018h,030h,01Ch,018h,070h,00Ch,038h,060h,00Ch,03Ch,060h
			.byte	00Ch,03Ch,060h,00Ch,06Ch,060h,00Eh,06Ch,060h,00Eh,06Eh,060h
			.byte	006h,066h,0C0h,006h,0C6h,0C0h,006h,0C6h,0C0h,006h,0C7h,0C0h
			.byte	007h,083h,0C0h,007h,083h,0C0h,007h,083h,080h,003h,083h,080h
			.byte	003h,001h,080h,003h,001h,080h,003h,001h,080h,003h,001h,080h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; W

			.byte	000h,000h,020h,00Eh,000h,0C0h,007h,001h,0C0h,007h,001h,080h
			.byte	003h,083h,080h,003h,083h,000h,001h,0C7h,000h,001h,0CEh,000h
			.byte	000h,0EEh,000h,000h,07Ch,000h,000h,07Ch,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,07Ch,000h,000h,07Ch,000h,000h,0EEh,000h
			.byte	000h,0CEh,000h,001h,0C7h,000h,003h,083h,080h,003h,083h,080h
			.byte	007h,001h,0C0h,007h,001h,0C0h,00Eh,000h,0E0h,00Eh,000h,0F0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; X

			.byte	000h,000h,008h,00Fh,000h,030h,007h,000h,070h,003h,080h,060h
			.byte	003h,080h,0E0h,001h,0C0h,0C0h,001h,0C1h,0C0h,000h,0E1h,0C0h
			.byte	000h,0E3h,080h,000h,073h,080h,000h,077h,000h,000h,03Fh,000h
			.byte	000h,03Eh,000h,000h,01Eh,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; Y

			.byte	000h,000h,000h,00Fh,0FFh,0E0h,00Fh,0FFh,0E0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,003h,080h,000h,003h,000h,000h,007h,000h
			.byte	000h,00Eh,000h,000h,00Eh,000h,000h,01Ch,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,070h,000h,000h,070h,000h,000h,0E0h,000h
			.byte	001h,0C0h,000h,001h,0C0h,000h,003h,080h,000h,003h,080h,000h
			.byte	007h,000h,000h,00Eh,000h,010h,00Fh,0FFh,0E0h,00Fh,0FFh,0E0h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; Z

			.byte	000h,000h,000h,003h,0FFh,080h,003h,0FFh,080h,003h,000h,000h
			.byte	003h,000h,000h,003h,000h,000h,003h,000h,000h,003h,000h,000h
			.byte	003h,000h,000h,003h,000h,000h,003h,000h,000h,003h,000h,000h
			.byte	003h,000h,000h,003h,000h,000h,003h,000h,000h,003h,000h,000h
			.byte	003h,000h,000h,003h,000h,000h,003h,000h,000h,003h,000h,000h
			.byte	003h,000h,000h,003h,000h,000h,003h,000h,000h,003h,000h,000h
			.byte	003h,000h,000h,003h,000h,000h,003h,000h,000h,003h,0FFh,080h
			.byte	003h,0FFh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; [

			.byte	000h,080h,000h,003h,080h,000h,001h,0C0h,000h,001h,0C0h,000h
			.byte	000h,0E0h,000h,000h,0E0h,000h,000h,070h,000h,000h,070h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,018h,000h,000h,01Ch,000h
			.byte	000h,00Ch,000h,000h,00Eh,000h,000h,006h,000h,000h,007h,000h
			.byte	000h,007h,000h,000h,003h,080h,000h,003h,080h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,000h,0E0h,000h,000h,0E0h,000h,000h,060h
			.byte	000h,000h,070h,000h,000h,030h,000h,000h,020h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; <backslash>

			.byte	000h,000h,000h,001h,0FFh,0C0h,001h,0FFh,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,001h,0FFh,0C0h
			.byte	001h,0FFh,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; ]

			.byte	000h,000h,000h,000h,008h,000h,000h,01Ch,000h,000h,01Eh,000h
			.byte	000h,03Eh,000h,000h,077h,000h,000h,063h,000h,000h,0E3h,080h
			.byte	000h,0C1h,080h,001h,081h,0C0h,003h,080h,080h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; ^

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Fh,0FFh,0F0h,00Fh,0FFh,0F0h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; _

			.byte	000h,000h,000h,000h,03Ch,000h,000h,0FEh,000h,001h,0C7h,000h
			.byte	001h,083h,000h,001h,083h,080h,001h,083h,080h,001h,083h,000h
			.byte	001h,0C7h,000h,000h,0FEh,000h,000h,07Ch,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; `

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,000h
			.byte	000h,07Fh,000h,003h,0FFh,0C0h,001h,081h,0E0h,001h,000h,0E0h
			.byte	000h,000h,060h,000h,000h,060h,000h,000h,060h,000h,03Fh,0E0h
			.byte	001h,0FFh,0E0h,003h,0C0h,060h,007h,000h,060h,007h,000h,060h
			.byte	007h,000h,0E0h,007h,001h,0E0h,007h,083h,0E0h,003h,0FFh,060h
			.byte	001h,0FCh,060h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; a

			.byte	000h,000h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	007h,000h,000h,007h,000h,000h,007h,000h,000h,007h,004h,000h
			.byte	007h,03Fh,000h,007h,07Fh,0C0h,007h,0C1h,0C0h,007h,080h,0E0h
			.byte	007h,000h,0F0h,007h,000h,070h,007h,000h,070h,007h,000h,070h
			.byte	007h,000h,070h,007h,000h,070h,007h,000h,070h,007h,000h,070h
			.byte	007h,080h,0E0h,007h,080h,0E0h,007h,0C3h,0C0h,007h,07Fh,080h
			.byte	006h,03Fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; b

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,0FFh,000h,003h,0FFh,080h,007h,083h,0C0h,007h,000h,080h
			.byte	00Eh,000h,080h,00Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h
			.byte	01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,007h,001h,080h,007h,0C3h,0C0h,003h,0FFh,080h
			.byte	000h,0FEh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; c

			.byte	000h,000h,000h,000h,000h,0C0h,000h,000h,0C0h,000h,000h,0C0h
			.byte	000h,000h,0C0h,000h,000h,0C0h,000h,000h,0C0h,000h,020h,0C0h
			.byte	001h,0FCh,0C0h,003h,0FEh,0C0h,007h,083h,0C0h,007h,001h,0C0h
			.byte	00Eh,001h,0C0h,00Eh,001h,0C0h,00Eh,000h,0C0h,00Ch,000h,0C0h
			.byte	00Ch,000h,0C0h,00Eh,000h,0C0h,00Eh,001h,0C0h,00Eh,001h,0C0h
			.byte	00Eh,001h,0C0h,007h,003h,0C0h,007h,087h,0C0h,003h,0FEh,0C0h
			.byte	000h,0FCh,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; d

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,000h
			.byte	000h,0FEh,000h,001h,0FFh,000h,003h,083h,080h,007h,001h,0C0h
			.byte	006h,000h,0C0h,00Eh,000h,0C0h,00Eh,000h,0E0h,00Fh,0FFh,0E0h
			.byte	00Fh,0FFh,0E0h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	006h,000h,000h,007h,000h,080h,003h,0C1h,0C0h,001h,0FFh,080h
			.byte	000h,0FFh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; e

			.byte	000h,000h,000h,000h,00Fh,0C0h,000h,03Fh,0E0h,000h,078h,070h
			.byte	000h,070h,020h,000h,0E0h,020h,000h,0E0h,000h,000h,0E0h,000h
			.byte	000h,0E0h,000h,000h,0E0h,000h,00Fh,0FFh,000h,00Fh,0FFh,000h
			.byte	000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h
			.byte	000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h
			.byte	000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h
			.byte	000h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; f

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,030h,020h,001h,0FCh,0F0h,003h,0DFh,0F0h,007h,007h,000h
			.byte	006h,003h,000h,00Eh,003h,080h,00Eh,003h,080h,006h,003h,000h
			.byte	007h,007h,000h,007h,08Fh,000h,003h,0FEh,000h,003h,0F8h,000h
			.byte	007h,000h,000h,006h,000h,000h,007h,000h,000h,007h,0FFh,000h
			.byte	003h,0FFh,0C0h,006h,001h,0E0h,00Ch,000h,0E0h,00Ch,000h,060h
			.byte	01Ch,000h,0E0h,00Eh,001h,0C0h,00Fh,0FFh,080h,003h,0FFh,000h ; g

			.byte	000h,000h,000h,007h,000h,000h,006h,000h,000h,006h,000h,000h
			.byte	006h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h,000h
			.byte	006h,004h,000h,006h,03Fh,000h,006h,07Fh,080h,006h,0C3h,0C0h
			.byte	007h,081h,0C0h,007h,001h,0C0h,007h,000h,0C0h,006h,000h,0C0h
			.byte	006h,000h,0C0h,006h,000h,0C0h,006h,000h,0C0h,006h,000h,0C0h
			.byte	006h,000h,0C0h,006h,000h,0C0h,006h,000h,0C0h,006h,000h,0C0h
			.byte	006h,000h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; h

			.byte	000h,010h,000h,000h,038h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	003h,0F8h,000h,003h,0F8h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,003h,0FFh,080h
			.byte	003h,0FFh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; i

			.byte	000h,000h,000h,000h,000h,080h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,07Fh,0C0h,000h,07Fh,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h
			.byte	000h,001h,0C0h,000h,001h,0C0h,000h,001h,0C0h,001h,003h,080h
			.byte	003h,087h,080h,003h,0FFh,000h,000h,0FEh,000h,000h,010h,000h ; j

			.byte	000h,000h,000h,00Fh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,001h,0E0h,00Eh,003h,080h,00Eh,007h,000h
			.byte	00Eh,00Eh,000h,00Eh,01Ch,000h,00Eh,038h,000h,00Eh,070h,000h
			.byte	00Fh,0F0h,000h,00Fh,0B8h,000h,00Fh,03Ch,000h,00Eh,01Eh,000h
			.byte	00Eh,00Eh,000h,00Eh,007h,000h,00Eh,003h,080h,00Eh,003h,0C0h
			.byte	00Eh,001h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; k

			.byte	000h,000h,000h,007h,0F8h,000h,007h,0F8h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,000h,038h,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,038h,000h,00Fh,0FFh,0C0h
			.byte	00Fh,0FFh,0C0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; l

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,040h
			.byte	00Eh,0F9h,0F0h,00Fh,0FBh,070h,00Fh,01Eh,030h,00Eh,01Ch,038h
			.byte	00Eh,01Ch,038h,00Eh,01Ch,038h,00Eh,01Ch,038h,00Eh,01Ch,038h
			.byte	00Eh,01Ch,038h,00Eh,01Ch,038h,00Eh,01Ch,038h,00Eh,01Ch,038h
			.byte	00Eh,01Ch,038h,00Eh,01Ch,038h,00Eh,01Ch,038h,00Eh,01Ch,038h
			.byte	00Eh,01Ch,038h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; m

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,004h,000h
			.byte	003h,01Fh,080h,003h,03Fh,0C0h,003h,061h,0E0h,003h,0C0h,0E0h
			.byte	003h,080h,0E0h,003h,080h,0E0h,003h,000h,060h,003h,000h,060h
			.byte	003h,000h,060h,003h,000h,060h,003h,000h,060h,003h,000h,060h
			.byte	003h,000h,060h,003h,000h,060h,003h,000h,060h,003h,000h,060h
			.byte	003h,000h,060h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; n

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,000h
			.byte	000h,0FEh,000h,001h,0FFh,000h,003h,083h,080h,007h,001h,0C0h
			.byte	00Eh,001h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Ch,000h,0E0h
			.byte	00Ch,000h,060h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Fh,000h,0E0h,007h,001h,0C0h,003h,083h,080h,001h,0FFh,000h
			.byte	000h,0FEh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; o

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,000h
			.byte	00Eh,07Fh,000h,00Eh,0FFh,080h,00Fh,083h,0C0h,00Fh,001h,0C0h
			.byte	00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,060h,00Eh,000h,0E0h,00Eh,000h,0E0h,00Eh,000h,0E0h
			.byte	00Eh,000h,0E0h,00Fh,001h,0C0h,00Fh,083h,080h,00Eh,0FFh,080h
			.byte	00Eh,07Eh,000h,00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h
			.byte	00Eh,000h,000h,00Eh,000h,000h,00Eh,000h,000h,000h,000h,000h ; p

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,000h
			.byte	000h,07Eh,070h,001h,0FFh,070h,003h,0C1h,0F0h,003h,080h,0F0h
			.byte	007h,000h,0F0h,007h,000h,070h,007h,000h,070h,006h,000h,070h
			.byte	006h,000h,070h,007h,000h,070h,007h,000h,070h,007h,000h,0F0h
			.byte	007h,000h,0F0h,003h,081h,0F0h,003h,0C3h,0F0h,001h,0FFh,070h
			.byte	000h,07Eh,070h,000h,000h,070h,000h,000h,070h,000h,000h,070h
			.byte	000h,000h,070h,000h,000h,070h,000h,000h,070h,000h,000h,000h ; q

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,004h,000h
			.byte	007h,03Fh,080h,006h,07Fh,0C0h,006h,0E0h,0C0h,007h,0C0h,080h
			.byte	007h,080h,000h,007h,000h,000h,007h,000h,000h,007h,000h,000h
			.byte	006h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h,000h
			.byte	006h,000h,000h,006h,000h,000h,006h,000h,000h,006h,000h,000h
			.byte	006h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; r

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,000h
			.byte	000h,0FFh,000h,001h,0FFh,080h,003h,081h,0C0h,007h,000h,080h
			.byte	007h,000h,080h,003h,080h,000h,003h,0E0h,000h,001h,0FCh,000h
			.byte	000h,07Fh,000h,000h,00Fh,0C0h,000h,003h,0C0h,000h,001h,0C0h
			.byte	004h,000h,0C0h,006h,001h,0C0h,00Fh,083h,0C0h,003h,0FFh,080h
			.byte	001h,0FEh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; s

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,070h,000h
			.byte	000h,070h,000h,000h,070h,000h,000h,060h,000h,000h,060h,000h
			.byte	007h,0FFh,080h,007h,0FFh,080h,000h,060h,000h,000h,060h,000h
			.byte	000h,060h,000h,000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h
			.byte	000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h,000h,0E0h,000h
			.byte	000h,0E0h,000h,000h,070h,040h,000h,078h,0C0h,000h,07Fh,0E0h
			.byte	000h,03Fh,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; t

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Eh,000h,0C0h,00Eh,000h,0C0h,00Eh,000h,0C0h,00Eh,000h,0C0h
			.byte	00Eh,000h,0C0h,00Eh,000h,0C0h,00Eh,000h,0C0h,00Eh,000h,0C0h
			.byte	00Eh,000h,0C0h,00Eh,000h,0C0h,00Eh,000h,0C0h,00Eh,001h,0C0h
			.byte	007h,001h,0C0h,007h,003h,0C0h,007h,087h,0C0h,003h,0FCh,0C0h
			.byte	001h,0F8h,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; u

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,000h,000h
			.byte	007h,000h,030h,007h,000h,070h,003h,000h,060h,003h,080h,060h
			.byte	003h,080h,0E0h,001h,0C0h,0C0h,001h,0C0h,0C0h,001h,0C1h,0C0h
			.byte	000h,0E1h,080h,000h,0E3h,080h,000h,063h,000h,000h,077h,000h
			.byte	000h,076h,000h,000h,03Eh,000h,000h,03Eh,000h,000h,01Ch,000h
			.byte	000h,03Ch,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; v

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	018h,000h,030h,018h,010h,030h,018h,038h,070h,01Ch,038h,060h
			.byte	00Ch,038h,060h,00Ch,03Ch,060h,00Ch,06Ch,060h,00Ch,06Ch,060h
			.byte	00Eh,06Ch,060h,006h,066h,040h,006h,0C6h,0C0h,006h,0C6h,0C0h
			.byte	007h,0C7h,0C0h,007h,083h,0C0h,003h,083h,0C0h,003h,083h,080h
			.byte	003h,081h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; w

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	007h,000h,0E0h,003h,081h,0C0h,001h,0C1h,0C0h,001h,0C3h,080h
			.byte	000h,0E7h,000h,000h,077h,000h,000h,03Eh,000h,000h,03Ch,000h
			.byte	000h,01Ch,000h,000h,03Eh,000h,000h,07Eh,000h,000h,077h,000h
			.byte	000h,0E3h,080h,001h,0C1h,0C0h,001h,081h,0C0h,003h,080h,0E0h
			.byte	007h,000h,070h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; x

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Eh,000h,0E0h,00Eh,000h,0E0h,007h,000h,0C0h,007h,000h,0C0h
			.byte	003h,001h,0C0h,003h,081h,080h,003h,081h,080h,001h,0C3h,080h
			.byte	001h,0C3h,000h,000h,0C7h,000h,000h,0E7h,000h,000h,0E6h,000h
			.byte	000h,07Eh,000h,000h,07Ch,000h,000h,03Ch,000h,000h,03Ch,000h
			.byte	000h,038h,000h,000h,038h,000h,000h,030h,000h,000h,070h,000h
			.byte	008h,060h,000h,01Fh,0E0h,000h,00Fh,0C0h,000h,002h,000h,000h ; y

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	007h,0FFh,0C0h,007h,0FFh,0C0h,000h,003h,080h,000h,007h,080h
			.byte	000h,007h,000h,000h,00Eh,000h,000h,01Ch,000h,000h,038h,000h
			.byte	000h,078h,000h,000h,070h,000h,000h,0E0h,000h,001h,0C0h,000h
			.byte	003h,080h,000h,007h,080h,000h,00Fh,000h,020h,00Fh,0FFh,0E0h
			.byte	00Fh,0FFh,0E0h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; z

			.byte	000h,000h,000h,000h,007h,0C0h,000h,01Fh,0C0h,000h,03Ch,000h
			.byte	000h,030h,000h,000h,070h,000h,000h,070h,000h,000h,070h,000h
			.byte	000h,070h,000h,000h,070h,000h,000h,070h,000h,000h,070h,000h
			.byte	000h,060h,000h,000h,0E0h,000h,007h,0C0h,000h,007h,080h,000h
			.byte	003h,0C0h,000h,000h,0E0h,000h,000h,060h,000h,000h,070h,000h
			.byte	000h,070h,000h,000h,070h,000h,000h,070h,000h,000h,070h,000h
			.byte	000h,070h,000h,000h,070h,000h,000h,070h,000h,000h,078h,000h
			.byte	000h,03Ch,000h,000h,01Fh,0C0h,000h,007h,0C0h,000h,000h,000h ; {

			.byte	000h,000h,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h
			.byte	000h,01Ch,000h,000h,01Ch,000h,000h,01Ch,000h,000h,000h,000h ; |

			.byte	000h,000h,000h,001h,0F8h,000h,001h,0FEh,000h,000h,00Fh,000h
			.byte	000h,007h,000h,000h,003h,000h,000h,003h,080h,000h,003h,080h
			.byte	000h,003h,080h,000h,003h,080h,000h,003h,080h,000h,003h,080h
			.byte	000h,003h,080h,000h,001h,0C0h,000h,000h,0F8h,000h,000h,078h
			.byte	000h,000h,0E0h,000h,001h,080h,000h,003h,080h,000h,003h,080h
			.byte	000h,003h,080h,000h,003h,080h,000h,003h,080h,000h,003h,080h
			.byte	000h,003h,080h,000h,003h,080h,000h,003h,080h,000h,007h,000h
			.byte	000h,00Fh,000h,001h,0FEh,000h,001h,0F8h,000h,000h,000h,000h ; }

			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,003h,0E0h,020h,007h,0F8h,070h,00Eh,03Fh,0E0h
			.byte	00Ch,00Fh,0C0h,000h,007h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h ; ~

