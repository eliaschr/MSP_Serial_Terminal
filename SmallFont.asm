;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;* Small Font file for usage in Graphical LCD programs.                                     *
;* This library needs a segment named .fonts defined. This is necessary for ease of         *
;* positioning the font's data in flash memory, at the willing space. Each glyph is of size *
;* of 12 bytes (in memory size) and 8x12 in pixel size.                                     *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - Small Font"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------


;============================================================================================
; LIBRARY DEFINITIONS - This section contains definitions, global to all program
;--------------------------------------------------------------------------------------------
SMALLFONTH			.equ	12				;The height of the font in pixels
SMALLFONTW			.equ	8				;The width of each character in pixels
SMALLFONTL			.equ	12				;The length of each glyph in bytes
SMALLFONTMINCHAR	.equ	020h			;First character available by this font is space
SMALLFONTMAXCHAR	.equ	07Fh			;Last character available by this font is '~'

;==< specify which must be global >==========================================================
			.def	SMALLFONTH
			.def	SMALLFONTW
			.def	SMALLFONTL
			.def	SMALLFONTMINCHAR
			.def	SMALLFONTMAXCHAR

;============================================================================================
; FONTS - This section contains constant data written in Flash (.fonts section)
;--------------------------------------------------------------------------------------------
			.def	SmallFont
			.def	SmallFontProp

			.sect	".fonts"
			.align	1
; Width of each glyph for using this font as a proportional font
SmallFontProp:
;New proportional data for font. For each glyph there are two bytes, the first shows the left
; border that should not be used and the second shows the width of the glyph (after the left
; border) that is the real glyph
			.byte	000h,004h,001h,003h,000h,006h,000h,007h,000h,006h,000h,007h
			.byte	000h,007h,000h,003h,002h,005h,000h,005h,000h,006h,000h,006h
			.byte	000h,003h,000h,006h,000h,003h,000h,006h,000h,006h,000h,005h
			.byte	000h,006h,000h,006h,000h,006h,000h,006h,000h,006h,000h,006h
			.byte	000h,006h,000h,006h,001h,003h,001h,003h,000h,007h,000h,006h
			.byte	000h,007h,000h,006h,000h,006h,000h,007h,000h,006h,000h,006h
			.byte	000h,006h,000h,006h,000h,006h,000h,007h,000h,007h,000h,006h
			.byte	000h,007h,000h,007h,000h,007h,000h,006h,000h,007h,000h,006h
			.byte	000h,006h,000h,006h,000h,007h,000h,006h,000h,006h,000h,007h
			.byte	000h,007h,000h,006h,000h,006h,000h,006h,000h,006h,001h,005h
			.byte	000h,006h,000h,005h,000h,005h,000h,007h,001h,003h,000h,007h
			.byte	000h,006h,000h,006h,000h,007h,000h,006h,000h,007h,000h,007h
			.byte	000h,007h,000h,005h,000h,005h,000h,007h,000h,006h,000h,006h
			.byte	000h,007h,000h,006h,000h,006h,000h,007h,000h,006h,000h,006h
			.byte	000h,006h,000h,007h,000h,007h,000h,006h,000h,006h,000h,007h
			.byte	000h,006h,001h,005h,002h,003h,000h,005h,000h,007h,007h,002h

; Glyph data
SmallFont:
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	;<Space>	4
			.byte	000h,000h,020h,020h,020h,020h,020h,020h,000h,020h,000h,000h	;!			5
			.byte	000h,028h,050h,050h,000h,000h,000h,000h,000h,000h,000h,000h	;"			6
			.byte	000h,000h,028h,028h,0FCh,028h,050h,0FCh,050h,050h,000h,000h	;#			7
			.byte	000h,020h,078h,0A8h,0A0h,060h,030h,028h,0A8h,0F0h,020h,000h	;$			6
			.byte	000h,000h,048h,0A8h,0B0h,050h,028h,034h,054h,048h,000h,000h	;%			7
			.byte	000h,000h,020h,050h,050h,078h,0A8h,0A8h,090h,06Ch,000h,000h	;&			7
			.byte	000h,040h,040h,080h,000h,000h,000h,000h,000h,000h,000h,000h	;'			3
			.byte	000h,004h,008h,010h,010h,010h,010h,010h,010h,008h,004h,000h	;(			7
			.byte	000h,040h,020h,010h,010h,010h,010h,010h,010h,020h,040h,000h	;)			5
			.byte	000h,000h,000h,020h,0A8h,070h,070h,0A8h,020h,000h,000h,000h	;*			6
			.byte	000h,000h,020h,020h,020h,0F8h,020h,020h,020h,000h,000h,000h	;+			6
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,040h,040h,080h	;,			3
			.byte	000h,000h,000h,000h,000h,0F8h,000h,000h,000h,000h,000h,000h	;-			6
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,040h,000h,000h	;.			3
			.byte	000h,008h,010h,010h,010h,020h,020h,040h,040h,040h,080h,000h	;/			6
			.byte	000h,000h,070h,088h,088h,088h,088h,088h,088h,070h,000h,000h	;0			6
			.byte	000h,000h,020h,060h,020h,020h,020h,020h,020h,070h,000h,000h	;1			5
			.byte	000h,000h,070h,088h,088h,010h,020h,040h,080h,0F8h,000h,000h	;2			6
			.byte	000h,000h,070h,088h,008h,030h,008h,008h,088h,070h,000h,000h	;3			6
			.byte	000h,000h,010h,030h,050h,050h,090h,078h,010h,018h,000h,000h	;4			6
			.byte	000h,000h,0F8h,080h,080h,0F0h,008h,008h,088h,070h,000h,000h	;5			6
			.byte	000h,000h,070h,090h,080h,0F0h,088h,088h,088h,070h,000h,000h	;6			6
			.byte	000h,000h,0F8h,090h,010h,020h,020h,020h,020h,020h,000h,000h	;7			6
			.byte	000h,000h,070h,088h,088h,070h,088h,088h,088h,070h,000h,000h	;8			6
			.byte	000h,000h,070h,088h,088h,088h,078h,008h,048h,070h,000h,000h	;9			6
			.byte	000h,000h,000h,000h,020h,000h,000h,000h,000h,020h,000h,000h	;:			4
			.byte	000h,000h,000h,000h,000h,020h,000h,000h,000h,020h,020h,000h	;;			4
			.byte	000h,004h,008h,010h,020h,040h,020h,010h,008h,004h,000h,000h	;<			7
			.byte	000h,000h,000h,000h,0F8h,000h,000h,0F8h,000h,000h,000h,000h	;=			6
			.byte	000h,040h,020h,010h,008h,004h,008h,010h,020h,040h,000h,000h	;>			7
			.byte	000h,000h,070h,088h,088h,010h,020h,020h,000h,020h,000h,000h	;?			6
			.byte	000h,000h,070h,088h,098h,0A8h,0A8h,0B8h,080h,078h,000h,000h	;@			6
			.byte	000h,000h,020h,020h,030h,050h,050h,078h,048h,0CCh,000h,000h	;A			7
			.byte	000h,000h,0F0h,048h,048h,070h,048h,048h,048h,0F0h,000h,000h	;B			6
			.byte	000h,000h,078h,088h,080h,080h,080h,080h,088h,070h,000h,000h	;C			6
			.byte	000h,000h,0F0h,048h,048h,048h,048h,048h,048h,0F0h,000h,000h	;D			6
			.byte	000h,000h,0F8h,048h,050h,070h,050h,040h,048h,0F8h,000h,000h	;E			6
			.byte	000h,000h,0F8h,048h,050h,070h,050h,040h,040h,0E0h,000h,000h	;F			6
			.byte	000h,000h,038h,048h,080h,080h,09Ch,088h,048h,030h,000h,000h	;G			7
			.byte	000h,000h,0CCh,048h,048h,078h,048h,048h,048h,0CCh,000h,000h	;H			7
			.byte	000h,000h,0F8h,020h,020h,020h,020h,020h,020h,0F8h,000h,000h	;I			6
			.byte	000h,000h,07Ch,010h,010h,010h,010h,010h,010h,090h,0E0h,000h	;J			7
			.byte	000h,000h,0ECh,048h,050h,060h,050h,050h,048h,0ECh,000h,000h	;K			7
			.byte	000h,000h,0E0h,040h,040h,040h,040h,040h,044h,0FCh,000h,000h	;L			7
			.byte	000h,000h,0D8h,0D8h,0D8h,0D8h,0A8h,0A8h,0A8h,0A8h,000h,000h	;M			6
			.byte	000h,000h,0DCh,048h,068h,068h,058h,058h,048h,0E8h,000h,000h	;N			7
			.byte	000h,000h,070h,088h,088h,088h,088h,088h,088h,070h,000h,000h	;O			6
			.byte	000h,000h,0F0h,048h,048h,070h,040h,040h,040h,0E0h,000h,000h	;P			6
			.byte	000h,000h,070h,088h,088h,088h,088h,0E8h,098h,070h,018h,000h	;Q			6
			.byte	000h,000h,0F0h,048h,048h,070h,050h,048h,048h,0ECh,000h,000h	;R			7
			.byte	000h,000h,078h,088h,080h,060h,010h,008h,088h,0F0h,000h,000h	;S			6
			.byte	000h,000h,0F8h,0A8h,020h,020h,020h,020h,020h,070h,000h,000h	;T			6
			.byte	000h,000h,0CCh,048h,048h,048h,048h,048h,048h,030h,000h,000h	;U			7
			.byte	000h,000h,0CCh,048h,048h,050h,050h,030h,020h,020h,000h,000h	;V			7
			.byte	000h,000h,0A8h,0A8h,0A8h,070h,050h,050h,050h,050h,000h,000h	;W			6
			.byte	000h,000h,0D8h,050h,050h,020h,020h,050h,050h,0D8h,000h,000h	;X			6
			.byte	000h,000h,0D8h,050h,050h,020h,020h,020h,020h,070h,000h,000h	;Y			6
			.byte	000h,000h,0F8h,090h,010h,020h,020h,040h,048h,0F8h,000h,000h	;Z			6
			.byte	000h,038h,020h,020h,020h,020h,020h,020h,020h,020h,038h,000h	;[			6
			.byte	000h,040h,040h,040h,020h,020h,010h,010h,010h,008h,000h,000h	;<Backslash>6
			.byte	000h,070h,010h,010h,010h,010h,010h,010h,010h,010h,070h,000h	;]			5
			.byte	000h,020h,050h,000h,000h,000h,000h,000h,000h,000h,000h,000h	;^			5
			.byte	000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,0FCh	;_			7
			.byte	000h,020h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	;'			4
			.byte	000h,000h,000h,000h,000h,030h,048h,038h,048h,03Ch,000h,000h	;a			7
			.byte	000h,000h,0C0h,040h,040h,070h,048h,048h,048h,070h,000h,000h	;b			6
			.byte	000h,000h,000h,000h,000h,038h,048h,040h,040h,038h,000h,000h	;c			6
			.byte	000h,000h,018h,008h,008h,038h,048h,048h,048h,03Ch,000h,000h	;d			7
			.byte	000h,000h,000h,000h,000h,030h,048h,078h,040h,038h,000h,000h	;e			6
			.byte	000h,000h,01Ch,020h,020h,078h,020h,020h,020h,078h,000h,000h	;f			7
			.byte	000h,000h,000h,000h,000h,03Ch,048h,030h,040h,078h,044h,038h	;g			7
			.byte	000h,000h,0C0h,040h,040h,070h,048h,048h,048h,0ECh,000h,000h	;h			7
			.byte	000h,000h,020h,000h,000h,060h,020h,020h,020h,070h,000h,000h	;i			5
			.byte	000h,000h,010h,000h,000h,030h,010h,010h,010h,010h,010h,0E0h	;j			5
			.byte	000h,000h,0C0h,040h,040h,05Ch,050h,070h,048h,0ECh,000h,000h	;k			7
			.byte	000h,000h,0E0h,020h,020h,020h,020h,020h,020h,0F8h,000h,000h	;l			6
			.byte	000h,000h,000h,000h,000h,0F0h,0A8h,0A8h,0A8h,0A8h,000h,000h	;m			6
			.byte	000h,000h,000h,000h,000h,0F0h,048h,048h,048h,0ECh,000h,000h	;n			7
			.byte	000h,000h,000h,000h,000h,030h,048h,048h,048h,030h,000h,000h	;o			6
			.byte	000h,000h,000h,000h,000h,0F0h,048h,048h,048h,070h,040h,0E0h	;p			6
			.byte	000h,000h,000h,000h,000h,038h,048h,048h,048h,038h,008h,01Ch	;q			7
			.byte	000h,000h,000h,000h,000h,0D8h,060h,040h,040h,0E0h,000h,000h	;r			6
			.byte	000h,000h,000h,000h,000h,078h,040h,030h,008h,078h,000h,000h	;s			6
			.byte	000h,000h,000h,020h,020h,070h,020h,020h,020h,018h,000h,000h	;t			6
			.byte	000h,000h,000h,000h,000h,0D8h,048h,048h,048h,03Ch,000h,000h	;u			7
			.byte	000h,000h,000h,000h,000h,0ECh,048h,050h,030h,020h,000h,000h	;v			7
			.byte	000h,000h,000h,000h,000h,0A8h,0A8h,070h,050h,050h,000h,000h	;w			6
			.byte	000h,000h,000h,000h,000h,0D8h,050h,020h,050h,0D8h,000h,000h	;x			6
			.byte	000h,000h,000h,000h,000h,0ECh,048h,050h,030h,020h,020h,0C0h	;y			7
			.byte	000h,000h,000h,000h,000h,078h,010h,020h,020h,078h,000h,000h	;z			6
			.byte	000h,018h,010h,010h,010h,020h,010h,010h,010h,010h,018h,000h	;{			6
			.byte	010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h	;|			5
			.byte	000h,060h,020h,020h,020h,010h,020h,020h,020h,020h,060h,000h	;}			4
			.byte	040h,0A4h,018h,000h,000h,000h,000h,000h,000h,000h,000h,000h	;~			6
