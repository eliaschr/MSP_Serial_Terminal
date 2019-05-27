;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;* Big Font file for usage in Graphical LCD programs.                                       *
;* This library needs a segment named .fonts defined. This is necessary for ease of         *
;* positioning the font's data in flash memory, at the willing space. Each glyph is of size *
;* of 32 bytes (in memory size) and 16x16 in pixel size.                                    *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - Big Font"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------


;============================================================================================
; LIBRARY DEFINITIONS - This section contains definitions, global to all program
;--------------------------------------------------------------------------------------------
BIGFONTH		.equ	16					;The height of the font in pixels
BIGFONTW		.equ	16					;The width of each character in pixels
BIGFONTL		.equ	32					;The length of each glyph in bytes
BIGFONTMINCHAR	.equ	020h				;The minimum character number available by this
											; font
BIGFONTMAXCHAR	.equ	07Fh				;The maximum character number available by this
											; font


;==< specify which must be global >==========================================================
			.def	BIGFONTH
			.def	BIGFONTW
			.def	BIGFONTL
			.def	BIGFONTMINCHAR
			.def	BIGFONTMAXCHAR

;============================================================================================
; FONTS - This section contains constant data written in Flash (.fonts section)
;--------------------------------------------------------------------------------------------
			.def	BigFont
			.def	BigFontProp

			.sect	".fonts"
			.align	1
BigFontProp:
;New proportional data for font. For each glyph there are two bytes, the first shows the left
; border that should not be used and the second shows the width of the glyph (after the left
; border) that is the real glyph
			.byte	000h,008h,003h,007h,003h,00Bh,000h,010h,002h,00Ch,003h,00Ah
			.byte	002h,00Ch,003h,006h,003h,00Ah,003h,00Ah,001h,00Eh,003h,00Ah
			.byte	003h,006h,002h,00Ch,004h,005h,002h,00Eh,002h,00Ch,002h,00Bh
			.byte	002h,00Ch,002h,00Ch,002h,00Ch,002h,00Ch,002h,00Ch,002h,00Dh
			.byte	002h,00Ch,002h,00Ch,005h,005h,004h,006h,002h,00Bh,001h,00Eh
			.byte	002h,00Bh,002h,00Ch,002h,00Dh,002h,00Ch,002h,00Ch,002h,00Ch
			.byte	002h,00Ch,002h,00Ch,002h,00Ch,002h,00Ch,002h,00Bh,003h,009h
			.byte	001h,00Eh,002h,00Ch,002h,00Ch,002h,00Dh,002h,00Dh,002h,00Dh
			.byte	002h,00Ch,002h,00Dh,002h,00Ch,002h,00Ch,002h,00Dh,002h,00Bh
			.byte	002h,00Bh,002h,00Dh,002h,00Bh,002h,00Bh,002h,00Ch,004h,009h
			.byte	002h,00Fh,004h,009h,002h,00Ch,000h,010h,002h,007h,002h,00Ch
			.byte	002h,00Ch,002h,00Bh,002h,00Ch,002h,00Bh,002h,00Bh,002h,00Ch
			.byte	002h,00Ch,003h,00Bh,002h,00Bh,002h,00Ch,003h,00Bh,002h,00Dh
			.byte	002h,00Bh,002h,00Bh,002h,00Ch,001h,00Ch,002h,00Ch,002h,00Bh
			.byte	002h,00Bh,002h,00Ch,002h,00Bh,002h,00Dh,002h,00Ah,002h,00Ch
			.byte	002h,00Ah,002h,00Ch,006h,005h,002h,00Ch,001h,00Eh,000h,010h

;Glyph data
BigFont:
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	;  <Space>			8
			.byte	000h,000h,000h,000h,007h,000h,00Fh,080h,00Fh,080h,00Fh,080h
			.byte	00Fh,080h,00Fh,080h,007h,000h,007h,000h,000h,000h,000h,000h
			.byte	007h,000h,007h,000h,007h,000h,000h,000h	; !					10
			.byte	000h,000h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h,006h,030h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; "					14
			.byte	000h,000h,00Ch,030h,00Ch,030h,00Ch,030h,07Fh,0FEh,07Fh,0FEh
			.byte	00Ch,030h,00Ch,030h,00Ch,030h,00Ch,030h,07Fh,0FEh,07Fh,0FEh
			.byte	00Ch,030h,00Ch,030h,00Ch,030h,000h,000h	; #					16
			.byte	000h,000h,002h,040h,002h,040h,00Fh,0F8h,01Fh,0F8h,01Ah,040h
			.byte	01Ah,040h,01Fh,0F0h,00Fh,0F8h,002h,058h,002h,058h,01Fh,0F8h
			.byte	01Fh,0F0h,002h,040h,002h,040h,000h,000h	; $					14
			.byte	000h,000h,000h,000h,000h,000h,00Eh,010h,00Eh,030h,00Eh,070h
			.byte	000h,0E0h,001h,0C0h,003h,080h,007h,000h,00Eh,070h,00Ch,070h
			.byte	008h,070h,000h,000h,000h,000h,000h,000h	; %					13
			.byte	000h,000h,000h,000h,00Fh,000h,019h,080h,019h,080h,019h,080h
			.byte	00Fh,000h,00Fh,008h,00Fh,098h,019h,0F8h,018h,0F0h,018h,0E0h
			.byte	019h,0F0h,00Fh,098h,000h,000h,000h,000h	; &					14
			.byte	000h,000h,000h,000h,007h,000h,007h,000h,007h,000h,00Eh,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; '					9
			.byte	000h,000h,000h,000h,000h,0F0h,001h,0C0h,003h,080h,007h,000h
			.byte	00Eh,000h,00Eh,000h,00Eh,000h,00Eh,000h,007h,000h,003h,080h
			.byte	001h,0C0h,000h,0F0h,000h,000h,000h,000h	; (					13
			.byte	000h,000h,000h,000h,00Fh,000h,003h,080h,001h,0C0h,000h,0E0h
			.byte	000h,070h,000h,070h,000h,070h,000h,070h,000h,0E0h,001h,0C0h
			.byte	003h,080h,00Fh,000h,000h,000h,000h,000h	; )					13
			.byte	000h,000h,000h,000h,001h,080h,011h,088h,009h,090h,007h,0E0h
			.byte	007h,0E0h,03Fh,0FCh,03Fh,0FCh,007h,0E0h,007h,0E0h,009h,090h
			.byte	011h,088h,001h,080h,000h,000h,000h,000h	; *					15
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,001h,080h,001h,080h
			.byte	001h,080h,00Fh,0F0h,00Fh,0F0h,001h,080h,001h,080h,001h,080h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; +					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,007h,000h
			.byte	007h,000h,007h,000h,00Eh,000h,000h,000h	;					9
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,01Fh,0F8h,01Fh,0F8h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; -					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,007h,000h
			.byte	007h,000h,007h,000h,000h,000h,000h,000h	;					9
			.byte	000h,000h,000h,000h,000h,002h,000h,006h,000h,00Eh,000h,01Ch
			.byte	000h,038h,000h,070h,000h,0E0h,001h,0C0h,003h,080h,007h,000h
			.byte	00Eh,000h,01Ch,000h,000h,000h,000h,000h	; /					16
			.byte	000h,000h,000h,000h,00Fh,0F0h,01Ch,038h,01Ch,078h,01Ch,0F8h
			.byte	01Ch,0F8h,01Dh,0B8h,01Dh,0B8h,01Fh,038h,01Fh,038h,01Eh,038h
			.byte	01Ch,038h,00Fh,0F0h,000h,000h,000h,000h	; 0					14
			.byte	000h,000h,000h,000h,001h,080h,001h,080h,003h,080h,01Fh,080h
			.byte	01Fh,080h,003h,080h,003h,080h,003h,080h,003h,080h,003h,080h
			.byte	003h,080h,01Fh,0F0h,000h,000h,000h,000h	; 1					13
			.byte	000h,000h,000h,000h,00Fh,0E0h,01Ch,070h,01Ch,038h,000h,038h
			.byte	000h,070h,000h,0E0h,001h,0C0h,003h,080h,007h,000h,00Eh,038h
			.byte	01Ch,038h,01Fh,0F8h,000h,000h,000h,000h	; 2					14
			.byte	000h,000h,000h,000h,00Fh,0E0h,01Ch,070h,01Ch,038h,000h,038h
			.byte	000h,070h,003h,0C0h,003h,0C0h,000h,070h,000h,038h,01Ch,038h
			.byte	01Ch,070h,00Fh,0E0h,000h,000h,000h,000h	; 3					14
			.byte	000h,000h,000h,000h,000h,0E0h,001h,0E0h,003h,0E0h,006h,0E0h
			.byte	00Ch,0E0h,018h,0E0h,01Fh,0F8h,01Fh,0F8h,000h,0E0h,000h,0E0h
			.byte	000h,0E0h,003h,0F8h,000h,000h,000h,000h	; 4					14
			.byte	000h,000h,000h,000h,01Fh,0F8h,01Ch,000h,01Ch,000h,01Ch,000h
			.byte	01Ch,000h,01Fh,0E0h,01Fh,0F0h,000h,078h,000h,038h,01Ch,038h
			.byte	01Ch,070h,00Fh,0E0h,000h,000h,000h,000h	; 5					14
			.byte	000h,000h,000h,000h,003h,0E0h,007h,000h,00Eh,000h,01Ch,000h
			.byte	01Ch,000h,01Fh,0F0h,01Fh,0F8h,01Ch,038h,01Ch,038h,01Ch,038h
			.byte	01Ch,038h,00Fh,0F0h,000h,000h,000h,000h	; 6					14
			.byte	000h,000h,000h,000h,01Fh,0FCh,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch
			.byte	000h,01Ch,000h,038h,000h,070h,000h,0E0h,001h,0C0h,003h,080h
			.byte	003h,080h,003h,080h,000h,000h,000h,000h	; 7					15
			.byte	000h,000h,000h,000h,00Fh,0F0h,01Ch,038h,01Ch,038h,01Ch,038h
			.byte	01Fh,038h,007h,0E0h,007h,0E0h,01Ch,0F8h,01Ch,038h,01Ch,038h
			.byte	01Ch,038h,00Fh,0F0h,000h,000h,000h,000h	; 8					14
			.byte	000h,000h,000h,000h,00Fh,0F0h,01Ch,038h,01Ch,038h,01Ch,038h
			.byte	01Ch,038h,01Fh,0F8h,00Fh,0F8h,000h,038h,000h,038h,000h,070h
			.byte	000h,0E0h,007h,0C0h,000h,000h,000h,000h	; 9					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,003h,080h,003h,080h
			.byte	003h,080h,000h,000h,000h,000h,003h,080h,003h,080h,003h,080h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; :					10
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,003h,080h,003h,080h
			.byte	003h,080h,000h,000h,000h,000h,003h,080h,003h,080h,003h,080h
			.byte	007h,000h,000h,000h,000h,000h,000h,000h	; ;					10
			.byte	000h,000h,000h,070h,000h,0E0h,001h,0C0h,003h,080h,007h,000h
			.byte	00Eh,000h,01Ch,000h,01Ch,000h,00Eh,000h,007h,000h,003h,080h
			.byte	001h,0C0h,000h,0E0h,000h,070h,000h,000h	; <					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,03Fh,0FCh
			.byte	03Fh,0FCh,000h,000h,000h,000h,03Fh,0FCh,03Fh,0FCh,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; =					15
			.byte	000h,000h,01Ch,000h,00Eh,000h,007h,000h,003h,080h,001h,0C0h
			.byte	000h,0E0h,000h,070h,000h,070h,000h,0E0h,001h,0C0h,003h,080h
			.byte	007h,000h,00Eh,000h,01Ch,000h,000h,000h	; >					13
			.byte	000h,000h,003h,0C0h,00Fh,0F0h,01Eh,078h,018h,038h,000h,038h
			.byte	000h,070h,000h,0E0h,001h,0C0h,001h,0C0h,000h,000h,000h,000h
			.byte	001h,0C0h,001h,0C0h,001h,0C0h,000h,000h	; ?					14
			.byte	000h,000h,00Fh,0F8h,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch
			.byte	01Ch,0FCh,01Ch,0FCh,01Ch,0FCh,01Ch,0FCh,01Ch,000h,01Ch,000h
			.byte	01Ch,000h,01Fh,0F0h,007h,0F8h,000h,000h	; @					15
			.byte	000h,000h,000h,000h,003h,0C0h,007h,0E0h,00Eh,070h,01Ch,038h
			.byte	01Ch,038h,01Ch,038h,01Ch,038h,01Fh,0F8h,01Ch,038h,01Ch,038h
			.byte	01Ch,038h,01Ch,038h,000h,000h,000h,000h	; A					14
			.byte	000h,000h,000h,000h,01Fh,0F0h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,00Fh,0F0h,00Fh,0F0h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,01Fh,0F0h,000h,000h,000h,000h	; B					14
			.byte	000h,000h,000h,000h,007h,0F0h,00Eh,038h,01Ch,038h,01Ch,000h
			.byte	01Ch,000h,01Ch,000h,01Ch,000h,01Ch,000h,01Ch,000h,01Ch,038h
			.byte	00Eh,038h,007h,0F0h,000h,000h,000h,000h	; C					14
			.byte	000h,000h,000h,000h,01Fh,0E0h,00Eh,070h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Eh,070h,01Fh,0E0h,000h,000h,000h,000h	; D					14
			.byte	000h,000h,000h,000h,01Fh,0F8h,00Eh,018h,00Eh,008h,00Eh,000h
			.byte	00Eh,030h,00Fh,0F0h,00Fh,0F0h,00Eh,030h,00Eh,000h,00Eh,008h
			.byte	00Eh,018h,01Fh,0F8h,000h,000h,000h,000h	; E					14
			.byte	000h,000h,000h,000h,01Fh,0F8h,00Eh,018h,00Eh,008h,00Eh,000h
			.byte	00Eh,030h,00Fh,0F0h,00Fh,0F0h,00Eh,030h,00Eh,000h,00Eh,000h
			.byte	00Eh,000h,01Fh,000h,000h,000h,000h,000h	; F					14
			.byte	000h,000h,000h,000h,007h,0F0h,00Eh,038h,01Ch,038h,01Ch,038h
			.byte	01Ch,000h,01Ch,000h,01Ch,000h,01Ch,0F8h,01Ch,038h,01Ch,038h
			.byte	00Eh,038h,007h,0F8h,000h,000h,000h,000h	; G					14
			.byte	000h,000h,000h,000h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,01Fh,0F0h,01Fh,0F0h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,01Ch,070h,000h,000h,000h,000h	; H					13
			.byte	000h,000h,000h,000h,00Fh,0E0h,003h,080h,003h,080h,003h,080h
			.byte	003h,080h,003h,080h,003h,080h,003h,080h,003h,080h,003h,080h
			.byte	003h,080h,00Fh,0E0h,000h,000h,000h,000h	; I					12
			.byte	000h,000h,000h,000h,001h,0FCh,000h,070h,000h,070h,000h,070h
			.byte	000h,070h,000h,070h,000h,070h,038h,070h,038h,070h,038h,070h
			.byte	038h,070h,00Fh,0E0h,000h,000h,000h,000h	; J					13
			.byte	000h,000h,000h,000h,01Eh,038h,00Eh,038h,00Eh,070h,00Eh,0E0h
			.byte	00Fh,0C0h,00Fh,080h,00Fh,080h,00Fh,0C0h,00Eh,0E0h,00Eh,070h
			.byte	00Eh,038h,01Eh,038h,000h,000h,000h,000h	; K					14
			.byte	000h,000h,000h,000h,01Fh,000h,00Eh,000h,00Eh,000h,00Eh,000h
			.byte	00Eh,000h,00Eh,000h,00Eh,000h,00Eh,000h,00Eh,008h,00Eh,018h
			.byte	00Eh,038h,01Fh,0F8h,000h,000h,000h,000h	; L					14
			.byte	000h,000h,000h,000h,01Ch,01Ch,01Eh,03Ch,01Fh,07Ch,01Fh,0FCh
			.byte	01Fh,0FCh,01Dh,0DCh,01Ch,09Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch
			.byte	01Ch,01Ch,01Ch,01Ch,000h,000h,000h,000h	; M					15
			.byte	000h,000h,000h,000h,01Ch,01Ch,01Ch,01Ch,01Eh,01Ch,01Fh,01Ch
			.byte	01Fh,09Ch,01Dh,0DCh,01Ch,0FCh,01Ch,07Ch,01Ch,03Ch,01Ch,01Ch
			.byte	01Ch,01Ch,01Ch,01Ch,000h,000h,000h,000h	; N					15
			.byte	000h,000h,000h,000h,003h,0E0h,007h,0F0h,00Eh,038h,01Ch,01Ch
			.byte	01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,00Eh,038h
			.byte	007h,0F0h,003h,0E0h,000h,000h,000h,000h	; O					15
			.byte	000h,000h,000h,000h,01Fh,0F0h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,00Fh,0F0h,00Fh,0F0h,00Eh,000h,00Eh,000h,00Eh,000h
			.byte	00Eh,000h,01Fh,000h,000h,000h,000h,000h	; P					14
			.byte	000h,000h,000h,000h,003h,0E0h,00Fh,078h,00Eh,038h,01Ch,01Ch
			.byte	01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,07Ch,01Ch,0FCh,00Fh,0F8h
			.byte	00Fh,0F8h,000h,038h,000h,0FCh,000h,000h	; Q					15
			.byte	000h,000h,000h,000h,01Fh,0F0h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,00Fh,0F0h,00Fh,0F0h,00Eh,070h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,01Eh,038h,000h,000h,000h,000h	; R					14
			.byte	000h,000h,000h,000h,00Fh,0F0h,01Ch,038h,01Ch,038h,01Ch,038h
			.byte	01Ch,000h,00Fh,0E0h,007h,0F0h,000h,038h,01Ch,038h,01Ch,038h
			.byte	01Ch,038h,00Fh,0F0h,000h,000h,000h,000h	; S					14
			.byte	000h,000h,000h,000h,01Fh,0FCh,019h,0CCh,011h,0C4h,001h,0C0h
			.byte	001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h
			.byte	001h,0C0h,007h,0F0h,000h,000h,000h,000h	; T					15
			.byte	000h,000h,000h,000h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,00Fh,0E0h,000h,000h,000h,000h	; U					13
			.byte	000h,000h,000h,000h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,00Eh,0E0h
			.byte	007h,0C0h,003h,080h,000h,000h,000h,000h	; V					13
			.byte	000h,000h,000h,000h,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch
			.byte	01Ch,01Ch,01Ch,09Ch,01Ch,09Ch,01Ch,09Ch,00Fh,0F8h,00Fh,0F8h
			.byte	007h,070h,007h,070h,000h,000h,000h,000h	; W					15
			.byte	000h,000h,000h,000h,01Ch,070h,01Ch,070h,01Ch,070h,00Eh,0E0h
			.byte	007h,0C0h,003h,080h,003h,080h,007h,0C0h,00Eh,0E0h,01Ch,070h
			.byte	01Ch,070h,01Ch,070h,000h,000h,000h,000h	; X					13
			.byte	000h,000h,000h,000h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,00Eh,0E0h,007h,0C0h,003h,080h,003h,080h,003h,080h
			.byte	003h,080h,00Fh,0E0h,000h,000h,000h,000h	; Y					13
			.byte	000h,000h,000h,000h,01Fh,0F8h,01Ch,038h,018h,038h,010h,070h
			.byte	000h,0E0h,001h,0C0h,003h,080h,007h,000h,00Eh,008h,01Ch,018h
			.byte	01Ch,038h,01Fh,0F8h,000h,000h,000h,000h	; Z					14
			.byte	000h,000h,000h,000h,007h,0F0h,007h,000h,007h,000h,007h,000h
			.byte	007h,000h,007h,000h,007h,000h,007h,000h,007h,000h,007h,000h
			.byte	007h,000h,007h,0F0h,000h,000h,000h,000h	; [					13
			.byte	000h,000h,000h,000h,010h,000h,018h,000h,01Ch,000h,00Eh,000h
			.byte	007h,000h,003h,080h,001h,0C0h,000h,0E0h,000h,070h,000h,038h
			.byte	000h,01Ch,000h,007h,000h,000h,000h,000h	; <Backslash>		16
			.byte	000h,000h,000h,000h,007h,0F0h,000h,070h,000h,070h,000h,070h
			.byte	000h,070h,000h,070h,000h,070h,000h,070h,000h,070h,000h,070h
			.byte	000h,070h,007h,0F0h,000h,000h,000h,000h	; ]					13
			.byte	000h,000h,001h,080h,003h,0C0h,007h,0E0h,00Eh,070h,01Ch,038h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; ^					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,07Fh,0FFh,07Fh,0FFh	; _					16
			.byte	000h,000h,000h,000h,01Ch,000h,01Ch,000h,007h,000h,007h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; '					9
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Fh,0E0h,000h,070h,000h,070h,00Fh,0F0h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,00Fh,0D8h,000h,000h,000h,000h	; a					14
			.byte	000h,000h,000h,000h,01Eh,000h,00Eh,000h,00Eh,000h,00Eh,000h
			.byte	00Fh,0F0h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,01Bh,0F0h,000h,000h,000h,000h	; b					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Fh,0E0h,01Ch,070h,01Ch,070h,01Ch,000h,01Ch,000h,01Ch,070h
			.byte	01Ch,070h,00Fh,0E0h,000h,000h,000h,000h	; c					13
			.byte	000h,000h,000h,000h,000h,0F8h,000h,070h,000h,070h,000h,070h
			.byte	00Fh,0F0h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,00Fh,0D8h,000h,000h,000h,000h	; d					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Fh,0E0h,01Ch,070h,01Ch,070h,01Fh,0F0h,01Ch,000h,01Ch,070h
			.byte	01Ch,070h,00Fh,0E0h,000h,000h,000h,000h	; e					13
			.byte	000h,000h,000h,000h,003h,0E0h,007h,070h,007h,070h,007h,000h
			.byte	007h,000h,01Fh,0E0h,01Fh,0E0h,007h,000h,007h,000h,007h,000h
			.byte	007h,000h,01Fh,0C0h,000h,000h,000h,000h	; f					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Fh,0D8h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,00Fh,0F0h
			.byte	007h,0F0h,000h,070h,01Ch,070h,00Fh,0E0h	; g					14
			.byte	000h,000h,000h,000h,01Eh,000h,00Eh,000h,00Eh,000h,00Eh,000h
			.byte	00Eh,0F0h,00Fh,038h,00Fh,038h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Eh,038h,01Eh,038h,000h,000h,000h,000h	; h					14
			.byte	000h,000h,000h,000h,001h,0C0h,001h,0C0h,001h,0C0h,000h,000h
			.byte	00Fh,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h
			.byte	001h,0C0h,00Fh,0F8h,000h,000h,000h,000h	; i					14
			.byte	000h,000h,000h,000h,000h,070h,000h,070h,000h,070h,000h,000h
			.byte	003h,0F0h,000h,070h,000h,070h,000h,070h,000h,070h,000h,070h
			.byte	000h,070h,01Ch,070h,00Ch,0F0h,007h,0E0h	; j					13
			.byte	000h,000h,000h,000h,01Eh,000h,00Eh,000h,00Eh,000h,00Eh,000h
			.byte	00Eh,038h,00Eh,070h,00Eh,0E0h,00Fh,0C0h,00Eh,0E0h,00Eh,070h
			.byte	00Eh,038h,01Eh,038h,000h,000h,000h,000h	; k					14
			.byte	000h,000h,000h,000h,00Fh,0C0h,001h,0C0h,001h,0C0h,001h,0C0h
			.byte	001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h
			.byte	001h,0C0h,00Fh,0F8h,000h,000h,000h,000h	; l					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Fh,0F8h,01Ch,09Ch,01Ch,09Ch,01Ch,09Ch,01Ch,09Ch,01Ch,09Ch
			.byte	01Ch,09Ch,01Ch,09Ch,000h,000h,000h,000h	; m					15
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Fh,0E0h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,01Ch,070h,000h,000h,000h,000h	; n					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Fh,0E0h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,00Fh,0E0h,000h,000h,000h,000h	; o					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Bh,0F0h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h
			.byte	00Fh,0F0h,00Eh,000h,00Eh,000h,01Fh,000h	; p					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Fh,0B0h,038h,0E0h,038h,0E0h,038h,0E0h,038h,0E0h,038h,0E0h
			.byte	01Fh,0E0h,000h,0E0h,000h,0E0h,001h,0F0h	; q					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Eh,0F0h,00Fh,0F8h,00Fh,038h,00Eh,000h,00Eh,000h,00Eh,000h
			.byte	00Eh,000h,01Fh,000h,000h,000h,000h,000h	; r					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Fh,0E0h,01Ch,030h,01Ch,030h,00Fh,080h,003h,0E0h,018h,070h
			.byte	018h,070h,00Fh,0E0h,000h,000h,000h,000h	; s					14
			.byte	000h,000h,000h,000h,000h,000h,001h,000h,003h,000h,007h,000h
			.byte	01Fh,0F0h,007h,000h,007h,000h,007h,000h,007h,000h,007h,070h
			.byte	007h,070h,003h,0E0h,000h,000h,000h,000h	; t					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h
			.byte	01Ch,070h,00Fh,0D8h,000h,000h,000h,000h	; u					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,01Ch,070h,00Eh,0E0h
			.byte	007h,0C0h,003h,080h,000h,000h,000h,000h	; v					13
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,01Ch,09Ch,01Ch,09Ch,00Fh,0F8h
			.byte	007h,070h,007h,070h,000h,000h,000h,000h	; w					15
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Ch,0E0h,01Ch,0E0h,00Fh,0C0h,007h,080h,007h,080h,00Fh,0C0h
			.byte	01Ch,0E0h,01Ch,0E0h,000h,000h,000h,000h	; x					12
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h,00Eh,038h,007h,0F0h
			.byte	003h,0E0h,000h,0E0h,001h,0C0h,01Fh,080h	; y					14
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	01Fh,0E0h,018h,0E0h,011h,0C0h,003h,080h,007h,000h,00Eh,020h
			.byte	01Ch,060h,01Fh,0E0h,000h,000h,000h,000h	; z					12
			.byte	000h,000h,000h,000h,001h,0F8h,003h,080h,003h,080h,003h,080h
			.byte	007h,000h,01Ch,000h,01Ch,000h,007h,000h,003h,080h,003h,080h
			.byte	003h,080h,001h,0F8h,000h,000h,000h,000h	; {					14
			.byte	000h,000h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h
			.byte	001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h,001h,0C0h
			.byte	001h,0C0h,001h,0C0h,001h,0C0h,000h,000h	; |					11
			.byte	000h,000h,000h,000h,01Fh,080h,001h,0C0h,001h,0C0h,001h,0C0h
			.byte	000h,0E0h,000h,038h,000h,038h,000h,0E0h,001h,0C0h,001h,0C0h
			.byte	001h,0C0h,01Fh,080h,000h,000h,000h,000h	; }					14
			.byte	000h,000h,000h,000h,01Fh,01Ch,03Bh,09Ch,039h,0DCh,038h,0F8h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
			.byte	000h,000h,000h,000h,000h,000h,000h,000h	; ~					15
