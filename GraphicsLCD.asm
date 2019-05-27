;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;* Graphics LCD Library for 480x320 colour LCD module. The code is made for R61581          *
;* controller IC, used on the colour LCD. (eBay store)                                      *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - Real Time Clock Library"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------
LCDDataPrtH	.equ	6						;The port that holds the lower 8 data bus' bits
LCDDataPrtL	.equ	5						;The port that holds the higher 8 data bus' bits
LCDCtrlPrt	.equ	4						;The port that holds the control pins of the LCD

LCD_CS		.equ	BIT4					;Mask for Chip Select pin
LCD_DC		.equ	BIT7					;Mask for Control/Data pin
LCD_WR		.equ	BIT5					;Mask for Write pin
LCD_RES		.equ	BIT3					;Mask for Reset pin
LCD_RD		.equ	BIT1					;Mask for Read pin
			;Create the port mask for all MCD control pins
LCDCtrlALL	.equ	LCD_CS + LCD_DC + LCD_WR + LCD_RES + LCD_RD

LCDBLPort	.equ	4						;Port that holds the PWM for the backlight
LCD_BL		.equ	BIT6					;Pin driving PWM for the backlight

DEFBKGRND	.equ	00000h					;The default background colour
DEFFRGRND	.equ	0FFFFh					;The default foreground colour

DEFFONT		.equ	FONT_SMALL				;The defautl font to be used

DEFBLVAL	.equ	00000h					;The default value of backlight on first start
DEFBLSTEP	.equ	00001h					;The default step to be used for backlight PWM
											; transition
DEFCOUNTER	.equ	00002h					;Transition at every PWM pulse

LCDBUFFLEN	.equ	4096					;Buffer size for designing strings, preparing data
											; to LCD module, or read data from it

;============================================================================================
; LIBRARY DEFINITIONS - This section contains definitions, global to all program
;--------------------------------------------------------------------------------------------
PORTRAIT_TOPLEFT		.equ	000h
PORTRAIT_BOTTOMLEFT		.equ	080h
PORTRAIT_TOPRIGHT		.equ	040h
PORTRAIT_BOTTOMRIGHT	.equ	0C0h
PORTRAIT_MAXX			.equ	0013Fh
PORTRAIT_MAXY			.equ	001DFh

LANDSCAPE_TOPLEFT		.equ	0A0h
LANDSCAPE_BOTTOMLEFT	.equ	0E0h
LANDSCAPE_TOPRIGHT		.equ	020h
LANDSCAPE_BOTTOMRIGHT	.equ	060h
LANDSCAPE_MAXX			.equ	PORTRAIT_MAXY
LANDSCAPE_MAXY			.equ	PORTRAIT_MAXX

;-------------------------------< OctaPlot Arcs To Be Printed >-------------------------------
OP_BOTTOMPLUS			.equ	~BIT0
OP_BOTTOMMINUS			.equ	~BIT3
OP_TOPPLUS				.equ	~BIT1
OP_TOPMINUS				.equ	~BIT2
OP_LEFTPLUS				.equ	~BIT5
OP_LEFTMINUS			.equ	~BIT6
OP_RIGHTPLUS			.equ	~BIT4
OP_RIGHTMINUS			.equ	~BIT7
OP_TOPRIGHT90			.equ	(OP_TOPPLUS & OP_RIGHTMINUS)
OP_TOPLEFT90			.equ	(OP_TOPMINUS & OP_LEFTMINUS)
OP_BOTTOMRIGHT90		.equ	(OP_BOTTOMPLUS & OP_RIGHTPLUS)
OP_BOTTOMLEFT90			.equ	(OP_BOTTOMMINUS & OP_LEFTPLUS)
OP_LEFT180				.equ	(OP_TOPLEFT90 & OP_BOTTOMLEFT90)
OP_RIGHT180				.equ	(OP_TOPRIGHT90 & OP_BOTTOMRIGHT90)
OP_TOP180				.equ	(OP_TOPLEFT90 & OP_TOPRIGHT90)
OP_BOTTOM180			.equ	(OP_BOTTOMLEFT90 & OP_BOTTOMRIGHT90)
OP_CIRCLE				.equ	(OP_TOP180 & OP_BOTTOM180)

;-------------------------------------< Font Properties >-------------------------------------
FONT_PROPORTIONAL		.equ	BIT0
FONT_0A					.equ	BIT1
FONT_0D					.equ	BIT2
FONT_FORCEDY			.equ	BIT3		;If there was not enough space for the character

;==< specify which must be global >==========================================================
			.def	PORTRAIT_TOPLEFT
			.def	PORTRAIT_BOTTOMLEFT
			.def	PORTRAIT_TOPRIGHT
			.def	PORTRAIT_BOTTOMRIGHT
			.def	LANDSCAPE_TOPLEFT
			.def	LANDSCAPE_BOTTOMLEFT
			.def	LANDSCAPE_TOPRIGHT
			.def	LANDSCAPE_BOTTOMRIGHT

			.def	LANDSCAPE_MAXX
			.def	LANDSCAPE_MAXY
			.def	PORTRAIT_MAXX
			.def	PORTRAIT_MAXY

			.def	OP_BOTTOMPLUS
			.def	OP_BOTTOMMINUS
			.def	OP_TOPPLUS
			.def	OP_TOPMINUS
			.def	OP_LEFTPLUS
			.def	OP_LEFTMINUS
			.def	OP_RIGHTPLUS
			.def	OP_RIGHTMINUS
			.def	OP_TOPRIGHT90
			.def	OP_TOPLEFT90
			.def	OP_BOTTOMRIGHT90
			.def	OP_BOTTOMLEFT90
			.def	OP_LEFT180
			.def	OP_RIGHT180
			.def	OP_TOP180
			.def	OP_BOTTOM180
			.def	OP_CIRCLE

			.def	FONT_PROPORTIONAL

;============================================================================================
; AUTO DEFINITIONS - This section contains definitions calculated by preprocessor, mainly
; according to the previously specified ones
;--------------------------------------------------------------------------------------------
; Lets specify some definitions for the LCD ports, according to the previous settings:
; LCDDataLDIR points to the direction register of the port pointed by LCDDataL
; LCDDataLIN points to the input register of the same port
; LCDDataLSEL points to the Selection register of the same port
; LCDDataLSEL2 points to the Selection2 register of the same port
; LCDDataLREN points to the Register Enable register of the same port
			.if LCDDataPrtL == 1
LCDDataL		.equ	P1OUT
LCDDataLDIR		.equ	P1DIR
LCDDataLIN		.equ	P1IN
LCDDataLSEL		.equ	P1SEL
LCDDataLREN		.equ	P1REN
			.elseif LCDDataPrtL = 2
LCDDataL		.equ	P2OUT
LCDDataLDIR		.equ	P2DIR
LCDDataLIN		.equ	P2IN
LCDDataLSEL		.equ	P2SEL
LCDDataLREN		.equ	P2REN
			.elseif LCDDataPrtL = 3
LCDDataL		.equ	P3OUT
LCDDataLDIR		.equ	P3DIR
LCDDataLIN		.equ	P3IN
LCDDataLSEL		.equ	P3SEL
LCDDataLREN		.equ	P3REN
			.elseif LCDDataPrtL = 4
LCDDataL		.equ	P4OUT
LCDDataLDIR		.equ	P4DIR
LCDDataLIN		.equ	P4IN
LCDDataLSEL		.equ	P4SEL
LCDDataLREN		.equ	P4REN
			.elseif LCDDataPrtL = 5
LCDDataL		.equ	P5OUT
LCDDataLDIR		.equ	P5DIR
LCDDataLIN		.equ	P5IN
LCDDataLSEL		.equ	P5SEL
LCDDataLREN		.equ	P5REN
			.elseif LCDDataPrtL = 6
LCDDataL		.equ	P6OUT
LCDDataLDIR		.equ	P6DIR
LCDDataLIN		.equ	P6IN
LCDDataLSEL		.equ	P6SEL
LCDDataLREN		.equ	P6REN
			.elseif LCDDataPrtL = 7
LCDDataL		.equ	P7OUT
LCDDataLDIR		.equ	P7DIR
LCDDataLIN		.equ	P7IN
LCDDataLSEL		.equ	P7SEL
LCDDataLREN		.equ	P7REN
			.elseif LCDDataPrtL = 8
LCDDataL		.equ	P8OUT
LCDDataLDIR		.equ	P8DIR
LCDDataLIN		.equ	P8IN
LCDDataLSEL		.equ	P8SEL
LCDDataLREN		.equ	P8REN
			.else
				.emsg	"Error in LCDDataPrtL definition. Must be a number of digital port..."
			.endif

; Same definitions apply to the Data high port, LCDDataH:
; LCDDataHDIR points to the direction register of the port pointed by LCDDataH
; LCDDataHIN points to the input register of the same port
; LCDDataHSEL points to the Selection register of the same port
; LCDDataHSEL2 points to the Selection2 register of the same port
; LCDDataHREN points to the Register Enable register of the same port
			.if LCDDataPrtH == 1
LCDDataH		.equ	P1OUT
LCDDataHDIR		.equ	P1DIR
LCDDataHIN		.equ	P1IN
LCDDataHSEL		.equ	P1SEL
LCDDataHREN		.equ	P1REN
			.elseif LCDDataPrtH == 2
LCDDataH		.equ	P2OUT
LCDDataHDIR		.equ	P2DIR
LCDDataHIN		.equ	P2IN
LCDDataHSEL		.equ	P2SEL
LCDDataHREN		.equ	P2REN
			.elseif LCDDataPrtH == 3
LCDDataH		.equ	P3OUT
LCDDataHDIR		.equ	P3DIR
LCDDataHIN		.equ	P3IN
LCDDataHSEL		.equ	P3SEL
LCDDataHREN		.equ	P3REN
			.elseif LCDDataPrtH == 4
LCDDataH		.equ	P4OUT
LCDDataHDIR		.equ	P4DIR
LCDDataHIN		.equ	P4IN
LCDDataHSEL		.equ	P4SEL
LCDDataHREN		.equ	P4REN
			.elseif LCDDataPrtH == 5
LCDDataH		.equ	P5OUT
LCDDataHDIR		.equ	P5DIR
LCDDataHIN		.equ	P5IN
LCDDataHSEL		.equ	P5SEL
LCDDataHREN		.equ	P5REN
			.elseif LCDDataPrtH == 6
LCDDataH		.equ	P6OUT
LCDDataHDIR		.equ	P6DIR
LCDDataHIN		.equ	P6IN
LCDDataHSEL		.equ	P6SEL
LCDDataHREN		.equ	P6REN
			.elseif LCDDataPrtH == 7
LCDDataH		.equ	P7OUT
LCDDataHDIR		.equ	P7DIR
LCDDataHIN		.equ	P7IN
LCDDataHSEL		.equ	P7SEL
LCDDataHREN		.equ	P7REN
			.elseif LCDDataPrtH == 8
LCDDataH		.equ	P8OUT
LCDDataHDIR		.equ	P8DIR
LCDDataHIN		.equ	P8IN
LCDDataHSEL		.equ	P8SEL
LCDDataHREN		.equ	P8REN
			.else
				.emsg	"Error in LCDDataPrtH definition. Must be the number of a digital port..."
			.endif

; Next are the difinitions for LCD Control port:
; LCDCtrlDIR points to the direction register of the port pointed by LCDCtrl
; LCDCtrlIN points to the input register of the same port
; LCDCtrlSEL points to the Selection register of the same port
; LCDCtrlSEL2 points to the Selection2 register of the same port
; LCDCtrlREN points to the Register Enable register of the same port
			.if LCDCtrlPrt == 1
LCDCtrl			.equ	P1OUT
LCDCtrlDIR		.equ	P1DIR
LCDCtrlIN		.equ	P1IN
LCDCtrlSEL		.equ	P1SEL
LCDCtrlREN		.equ	P1REN
			.elseif LCDCtrlPrt == 2
LCDCtrl			.equ	P2OUT
LCDCtrlDIR		.equ	P2DIR
LCDCtrlIN		.equ	P2IN
LCDCtrlSEL		.equ	P2SEL
LCDCtrlREN		.equ	P2REN
			.elseif LCDCtrlPrt == 3
LCDCtrl			.equ	P3OUT
LCDCtrlDIR		.equ	P3DIR
LCDCtrlIN		.equ	P3IN
LCDCtrlSEL		.equ	P3SEL
LCDCtrlREN		.equ	P3REN
			.elseif LCDCtrlPrt == 4
LCDCtrl			.equ	P4OUT
LCDCtrlDIR		.equ	P4DIR
LCDCtrlIN		.equ	P4IN
LCDCtrlSEL		.equ	P4SEL
LCDCtrlREN		.equ	P4REN
			.elseif LCDCtrlPrt == 5
LCDCtrl			.equ	P5OUT
LCDCtrlDIR		.equ	P5DIR
LCDCtrlIN		.equ	P5IN
LCDCtrlSEL		.equ	P5SEL
LCDCtrlREN		.equ	P5REN
			.elseif LCDCtrlPrt == 6
LCDCtrl			.equ	P6OUT
LCDCtrlDIR		.equ	P6DIR
LCDCtrlIN		.equ	P6IN
LCDCtrlSEL		.equ	P6SEL
LCDCtrlREN		.equ	P6REN
			.elseif LCDCtrlPrt == 7
LCDCtrl			.equ	P7OUT
LCDCtrlDIR		.equ	P7DIR
LCDCtrlIN		.equ	P7IN
LCDCtrlSEL		.equ	P7SEL
LCDCtrlREN		.equ	P7REN
			.elseif LCDCtrlPrt == 8
LCDCtrl			.equ	P8OUT
LCDCtrlDIR		.equ	P8DIR
LCDCtrlIN		.equ	P8IN
LCDCtrlSEL		.equ	P8SEL
LCDCtrlREN		.equ	P8REN
			.else
				.emsg	"Error in LCDCtrlPrt definition. Must be an output register of a digital port..."
			.endif

;Now we need to setup definitions for the LCD Backlight
;LCDBLOUT	: Output register of port that the control pin of LCD Backlight is connected to
;LCDBLDIR	: The direction register of the port the LCD Backlight control pin is connected to
;LCDBLIN	: The input register of the same port
;LCDBLSEL	: The special function select register of the port in question
;LCDBLREN	: The Resistor Enable register of the port
;BLCTL		: The TxCTL register used for the timer of PWM
;BLCCTL		: The TxCCTLx register of PWM creation.
;BLCCR0		: The TxCCTL0 register of the PWM period setting
;BLCCR		: The TxCCRx register, counter of PWM
;BLIV		: The interrupt vector's ID for the backlight capture/compare interrupt
;BL_VECTOR	: The vector address of the corresponding Timer
			.if LCDBLPort == 1
LCDBLOUT		.equ	P1OUT
LCDBLDIR		.equ	P1DIR
LCDBLIN			.equ	P1IN
LCDBLSEL		.equ	P1SEL
LCDBLREN		.equ	P1REN
				.if (LCD_BL == BIT1) || (LCD_BL == BIT5)
BLCTL				.equ	TACTL
BLCCTL				.equ	TACCTL0
BLCCR0				.equ	TACCR0
BLCCR				.equ	TACCR0
BLIV				.equ	TAIV_NONE
BL_VECTOR			.equ	TIMERA0_VECTOR
				.elseif (LCD_BL == BIT2) || (LCD_BL == BIT6)
BLCTL				.equ	TACTL
BLCCTL				.equ	TACCTL1
BLCCR0				.equ	TACCR0
BLCCR				.equ	TACCR1
BLIV				.equ	TAIV_TACCR1
BL_VECTOR			.equ	TIMERA1_VECTOR
				.elseif (LCD_BL == BIT3) || (LCD_BL == BIT7)
BLCTL				.equ	TACTL
BLCCTL				.equ	TACCTL2
BLCCR0				.equ	TACCR0
BLCCR				.equ	TACCR2
BLIV				.equ	TAIV_TACCR2
BL_VECTOR			.equ	TIMERA1_VECTOR
				.endif
			.elseif LCDBLPort == 2
LCDBLOUT		.equ	P2OUT
LCDBLDIR		.equ	P2DIR
LCDBLIN			.equ	P2IN
LCDBLSEL		.equ	P2SEL
LCDBLREN		.equ	P2REN
				.if (LCD_BL == BIT2) || (LCD_BL == BIT7)
BLCTL				.equ	TACTL
BLCCTL				.equ	TACCTL0
BLCCR0				.equ	TACCR0
BLCCR				.equ	TACCR0
BLIV				.equ	TAIV_NONE
BL_VECTOR			.equ	TIMERA0_VECTOR
				.elseif (LCD_BL == BIT3)
BLCTL				.equ	TACTL
BLCCTL				.equ	TACCTL1
BLCCR0				.equ	TACCR0
BLCCR				.equ	TACCR1
BLIV				.equ	TAIV_TACCR1
BL_VECTOR			.equ	TIMERA1_VECTOR
				.elseif (LCD_BL == BIT4)
BLCTL				.equ	TACTL
BLCCTL				.equ	TACCTL2
BLCCR0				.equ	TACCR0
BLCCR				.equ	TACCR2
BLIV				.equ	TAIV_TACCR2
BL_VECTOR			.equ	TIMERA1_VECTOR
				.endif
			.elseif LCDBLPort == 3
LCDBLOUT		.equ	P3OUT
LCDBLDIR		.equ	P3DIR
LCDBLIN			.equ	P3IN
LCDBLSEL		.equ	P3SEL
LCDBLREN		.equ	P3REN
			.elseif LCDBLPort == 4
LCDBLOUT		.equ	P4OUT
LCDBLDIR		.equ	P4DIR
LCDBLIN			.equ	P4IN
LCDBLSEL		.equ	P4SEL
LCDBLREN		.equ	P4REN
				.if (LCD_BL == BIT0)
BLCTL				.equ	TBCTL
BLCCTL				.equ	TBCCTL0
BLCCR0				.equ	TBCCR0
BLCCR				.equ	TBCCR0
BLIV				.equ	TBIV_NONE
BL_VECTOR			.equ	TIMERB0_VECTOR
				.elseif (LCD_BL == BIT1)
BLCTL				.equ	TBCTL
BLCCTL				.equ	TBCCTL1
BLCCR0				.equ	TBCCR0
BLCCR				.equ	TBCCR1
BLIV				.equ	TBIV_TBCCR1
BL_VECTOR			.equ	TIMERB1_VECTOR
				.elseif (LCD_BL == BIT2)
BLCTL				.equ	TBCTL
BLCCTL				.equ	TBCCTL2
BLCCR0				.equ	TBCCR0
BLCCR				.equ	TBCCR2
BLIV				.equ	TBIV_TBCCR2
BL_VECTOR			.equ	TIMERB1_VECTOR
				.elseif (LCD_BL == BIT3)
BLCTL				.equ	TBCTL
BLCCTL				.equ	TBCCTL3
BLCCR0				.equ	TBCCR0
BLCCR				.equ	TBCCR3
BLIV				.equ	TBIV_TBCCR3
BL_VECTOR			.equ	TIMERB1_VECTOR
				.elseif (LCD_BL == BIT4)
BLCTL				.equ	TBCTL
BLCCTL				.equ	TBCCTL4
BLCCR0				.equ	TBCCR0
BLCCR				.equ	TBCCR4
BLIV				.equ	TBIV_TBCCR4
BL_VECTOR			.equ	TIMERB1_VECTOR
				.elseif (LCD_BL == BIT5)
BLCTL				.equ	TBCTL
BLCCTL				.equ	TBCCTL5
BLCCR0				.equ	TBCCR0
BLCCR				.equ	TBCCR5
BLIV				.equ	TBIV_TBCCR5
BL_VECTOR			.equ	TIMERB1_VECTOR
				.elseif (LCD_BL == BIT6)
BLCTL				.equ	TBCTL
BLCCTL				.equ	TBCCTL6
BLCCR0				.equ	TBCCR0
BLCCR				.equ	TBCCR6
BLIV				.equ	TBIV_TBCCR6
BL_VECTOR			.equ	TIMERB1_VECTOR
				.endif
			.elseif LCDBLPort == 5
LCDBLOUT		.equ	P5OUT
LCDBLDIR		.equ	P5DIR
LCDBLIN			.equ	P5IN
LCDBLSEL		.equ	P5SEL
LCDBLREN		.equ	P5REN
			.elseif LCDBLPort == 6
LCDBLOUT		.equ	P6OUT
LCDBLDIR		.equ	P6DIR
LCDBLIN			.equ	P6IN
LCDBLSEL		.equ	P6SEL
LCDBLREN		.equ	P6REN
			.elseif LCDBLPort == 7
LCDBLOUT		.equ	P7OUT
LCDBLDIR		.equ	P7DIR
LCDBLIN			.equ	P7IN
LCDBLSEL		.equ	P7SEL
LCDBLREN		.equ	P7REN
			.elseif LCDBLPort == 8
LCDBLOUT		.equ	P8OUT
LCDBLDIR		.equ	P8DIR
LCDBLIN			.equ	P8IN
LCDBLSEL		.equ	P8SEL
LCDBLREN		.equ	P8REN
			.else
				.emsg	"Error in LCDBLPort definition. Must be the number of a port of the processor..."
			.endif

;==< Public Definitions >====================================================================
			.if $isdefed("BL_VECTOR") == 0
BL_VECTOR		.equ	RESERVED0_VECTOR
			.endif
			.if $isdefed("BLIV") == 0
BLIV			.equ	TAIV_NONE
			.endif
			.def	BL_VECTOR			;Vector address for timer to be used
			.def	BLIV				;The associated vector value

;============================================================================================
; VARIABLES - This section contains local variables
;--------------------------------------------------------------------------------------------
			.sect	".bss"
			.align	1
			; The PWM smooth transition is made by usage of a timer counter interrupt. In
			; order for the value to be smoothly changed, there are three available variables
			; BLCurVal which holds the current value of PWM setting, BLMaxVal which is the
			; value the PWM subsystem must reach and the BLStep which holds the number of
			; change of PWM, that is a PWM step. The step is a signed value.
			; Two more variables define how fast the transition is applied. The first is
			; BLMaxCntr holds the number of repetitions before PWM changes by one step and
			; BLCounter holds the current number of repetitions performed before a PWM change
BLMaxVal:	.space	2				;Holds the maximum value of the backlight % for PWM
BLCurVal:	.space	2				;Holds the current value of the backlight % for PWM
BLMaxCntr:	.space	2				;Holds te maximum number of repeat counter for PWM change
BLCounter:	.space	2				;Holds the current value of repeat counter for PWM change
BLStep:		.space	2				;The increment/decrement step of the backlight value,
									; during transition
LCDMaxX:	.space	2				;Holds the maximum X value for the current screen
									; orientation
LCDMaxY:	.space	2				;Holds the maximum Y value for the current screen
									; orientation
LCDFlags:	.space	2				;Holds some flags for the status of the LCD module
ORIENTFLG	.equ	BIT0			;Bit 0 of LCDFlags expresses the orientation:
									; 0: Portrait, 1: Landscape
SWAPXFLG	.equ	BIT1			;It expresses if SetRegion exchanged X Axis registers
									; 0: No swap performed, 1: XAxis registers swapped
SWAPYFLG	.equ	BIT2			;It expresses if SetRegion exchanged Y Axis registers
									; 0: No swap performed, 1: YAxis registers swapped
READLAST	.equ	BIT3			;Set when this is the final block of buffer to be read
BkGrndClr:	.space	2				;The background colour for text
FrGrndClr:	.space	2				;The foreground colour for text
CurFontIdx:	.space	2				;Current font index
CurFontPtr:	.space	2				;Current font pointer entry to FontsTbl
FontProps:	.space	2				;Font properties to be used (Flags)
CurXPos:	.space	2				;The text cursor's X position in pixels
CurYPos:	.space	2				;The text cursor's Y position in pixels
TxtWinL:	.space	2				;The text window's left border
TxtWinR:	.space	2				;The text window's right border
TxtWinT:	.space	2				;The text window's top border
TxtWinB:	.space	2				;The text window's bottom border
ImgBuffer:	.space	LCDBUFFLEN +2	;Buffer for prepearing strings (2 bytes more for ease of
									; algorythm design)

;==< specify which must be global >==========================================================
;			.def DelayMax

;==< referenced variables defined in other files >===========================================
			.ref	SmallFont		;Small Font's data
			.ref	SmallFontProp	;Small Font's glyph widths for using is as a proportional
			.ref	SMALLFONTH		;Small Font's height
			.ref	SMALLFONTW		;Small Font's width as a monospace (fixed size)
			.ref	SMALLFONTL		;Small Font's glyph length in bytes
			.ref	SMALLFONTMINCHAR;Small Font's first available character
			.ref	SMALLFONTMAXCHAR;Small Font's last available character

			.ref	SevenSegFont	;Seven Segment big font's data
			.ref	SevenSegProp	;Seven Segment big font's proportional widths
			.ref	SEVENSEGFONTH	;Seven Segment big font's glyph height
			.ref	SEVENSEGFONTW	;Seven Segment big font's glyph width
			.ref	SEVENSEGFONTL	;Seven Segment big font's glyph length in bytes
			.ref	SEVENSEGMINCHAR	;Seven Segment big font's first available character
			.ref	SEVENSEGMAXCHAR	;Seven Segment big font's last available character

			.ref	BigFont			;Big font's data
			.ref	BigFontProp		;Big font's proportional glyph widths array
			.ref	BIGFONTH		;Big font's glyph height
			.ref	BIGFONTW		;Big font's glyph width
			.ref	BIGFONTL		;Big font's glyph length in bytes
			.ref	BIGFONTMINCHAR	;Big font's first available character
			.ref	BIGFONTMAXCHAR	;Big font's last available character

			.ref	Inconsola		;Inconsola font's data
			.ref	InconsolaProp	;Inconsola font's proportional glyph widths array
			.ref	INCONSOLAH		;Inconsola font's glyph height
			.ref	INCONSOLAW		;Inconsola font's glyph width
			.ref	INCONSOLAL		;Inconsola font's glyph length in bytes
			.ref	INCONSOLAMINCHAR;Inconsola font's first available character
			.ref	INCONSOLAMAXCHAR;Inconsola font's last available character

;============================================================================================
; CONSTANTS - This section contains constant data written in Flash (.const section)
;--------------------------------------------------------------------------------------------
			.sect	".const"
			.align	1
InitLCDTbl:
			.byte	080h,00Ah,06Bh					;Delay 5ms
			.byte	082h							;Lower Reset pin
			.byte	080h,014h,0D6h					;Delay 10ms
			.byte	083h							;Raise Reset pin
			.byte	080h,061h,02Ah					;Delay 50ms
			.byte	000h,0FFh						;Dummy command
			.byte	000h,0FFh						;Dummy command
			.byte	080h,00Ah,06Bh					;Delay 5ms
			.byte	000h,0FFh						;Dummy command
			.byte	000h,0FFh						;Dummy command
			.byte	000h,0FFh						;Dummy command
			.byte	000h,0FFh						;Dummy command
			.byte	080h,014h,0D6h					;Delay 10ms
			.byte	001h,0B0h,000h					;Manufacturer Command Access Protect: Off
			.byte	004h,0B3h,002h,000h,000h,010h	;Frame Memory Access & I/face setting
			.byte	001h,0B4h,000h					;Display Mode & Frame Memory Write
			.byte	008h,0C0h,013h,03Bh,000h		;Panel Driving setting
			.byte	000h,000h,001h,000h,043h
			.byte	004h,0C1h,008h,015h,008h,008h	;Normal Mode Display Timing
			.byte	004h,0C4h,015h,003h,003h,001h	;Source/VCOM/Gate Driving Timing
			.byte	001h,0C6h,002h					;Interface setting
			.byte	014h,0C8h,00Ch,005h,00Ah,06Bh	;Gamma setting
			.byte	004h,006h,015h,010h,000h,031h
			.byte	010h,015h,006h,064h,00Dh,00Ah
			.byte	005h,00Ch,031h,000h
			.byte	001h,036h,0A0h					;Set Address Mode (Landscape, Top, Left)
			.byte	001h,03Ah,055h					;Set Pixel Format
;			.byte	000h,038h						;Exit Idle Mode
			.byte	004h,0D0h,007h,007h,014h,0A2h	;Power setting
			.byte	003h,0D1h,003h,05Ah,010h		;VCOM setting
			.byte	003h,0D2h,003h,004h,004h		;Poer Setting for Normal Mode
			.byte	000h,011h						;Exit Sleep Mode
			.byte	080h,0FAh,000h					;Delay 120ms
			.byte	004h,02Ah,000h,000h,001h,0DFh	;Set Column Address
			.byte	004h,02Bh,000h,000h,001h,03Fh	;Set Page Address
			.byte	080h,0D0h,055h					;Delay 100ms
			.byte	000h,029h						;Set Display On
			.byte	080h,00Ah,06Bh					;Delay 5ms
			.byte	000h,02Ch						;Write Memory Start
			.byte	080h,03Eh,080h					;Delay 30ms
			.byte	0FFh							;End of initialisation sequence

			;The table that follows contains data for each font that can be used. Each table
			; entry contains 5 elements: The address of the font data, the address of the width
			; data if this font can be used as a proportional one, the width and the height of
			; each glyph and the length of each glyph in bytes. Lets define some offsets for
			; manipulating the table data
FTbl_ADDR		.equ	0					;Offset for reading the font's address
FTbl_PROP		.equ	4					;Offset for proportional font's width values
FTbl_WIDTH		.equ	8					;Offset for reading the width of a glyph
FTbl_HEIGHT		.equ	10					;Offset for reading the height of a glyph
FTbl_GLEN		.equ	12					;Offset for reading the length of a glyph in bytes
FTbl_MINCHAR	.equ	14					;Offset for reading the first available character
FTbl_MAXCHAR	.equ	16					;Offset for reading the last available character
FTbl_SIZE		.equ	18					;The size of an entry of this table
FTbl_MAXINDEX	.equ	3					;The maximum entry number that can be used

FONT_SMALL		.equ	0					;Table index for small font's data
FONT_BIG		.equ	1					;Table index for big font's data
FONT_INCONSOLA	.equ	2					;Table index for inconsola font's data
FONT_7SEG		.equ	3					;Table index for seven segment big font's data

			.align	1						;Table must be word aligned
FontsTbl:	.long	SmallFont				;Small font's elements
			.long	SmallFontProp
			.word	SMALLFONTW
			.word	SMALLFONTH
			.word	SMALLFONTL
			.word	SMALLFONTMINCHAR
			.word	SMALLFONTMAXCHAR +1

			.long	BigFont					;Big font's elements
			.long	BigFontProp
			.word	BIGFONTW
			.word	BIGFONTH
			.word	BIGFONTL
			.word	BIGFONTMINCHAR
			.word	BIGFONTMAXCHAR +1

			.long	Inconsola				;Inconsola font's elements
			.long	InconsolaProp
			.word	INCONSOLAW
			.word	INCONSOLAH
			.word	INCONSOLAL
			.word	INCONSOLAMINCHAR
			.word	INCONSOLAMAXCHAR +1

			.long	SevenSegFont			;Seven segment font's elements
			.long	SevenSegProp
			.word	SEVENSEGFONTW
			.word	SEVENSEGFONTH
			.word	SEVENSEGFONTL
			.word	SEVENSEGMINCHAR
			.word	SEVENSEGMAXCHAR +1

;============================================================================================
; PROGRAM FUNCTIONS
;--------------------------------------------------------------------------------------------
;--< Some of the labels must be available to other files >-----------------------------------
			.def	BLFadeISR				;Interrupt Service Routine for smooth backlight
											; level transition
			.def	InitLCDPorts			;Initialises the ports for LCD communication
			.def	WriteLCDData			;Writes data to LCD module
			.def	LCDStartData			;Puts the LCD in pixel write data mode
			.def	LCDContData				;Puts the LCD in pixel write data mode to
											; continue writing from the last used address
			.def	WriteLCDCmd				;Writes command to LCD module
			.def	WriteLCD				;Writes data/command to LCD module
			.def	ClearScreen				;Fills the whole screen with a colour
			.def	FillRegion				;Fills R14 pixels with colour R15
			.def	FillRect				;Fills a whole rectangle
			.def	SetOrientation			;Sets the orientation of the Frame Memory
			.def	LCDSetPageAddr			;Sets the row of the next pixel to be altered
			.def	LCDSetColAddr			;Sets the column address of the next pixel
			.def	LCDSetRegion			;Selects a whole region (page and column)
			.def	ReadLCD					;Reads data from LCD module. Sets up the bus
			.def	ReadNextLCD				;Reads data from LCD without setting up the bus
			.def	InitLCD					;Initialises the LCD module
			.def	DrawLine				;Draws a line on screen
			.def	DrawRect				;Draws an empty rectangle
			.def	DrawRoundRect			;Draws an empty rectangle with rounded corners
			.def	SetHScroll				;Sets the scroll region
			.def	HScroll					;Sets the scroll position
			.def	Plot					;Plots a pixel
			.def	DrawArcs				;Draws arcs of a circle
			.def	SetTextRegion			;Sets both text area and LCD graphical region
			.def	SetTextWindow			;Sets the valid text window that can be used for
											; text drawing
			.def	GetTextWindow			;Gets the current text window that can be used for
											; text drawing
			.def	Text2Region				;Selects the region to be used in LCD module by
											; the coordinates of the currently set Text region
			.def	SetBkGrnd				;Sets the background colour of the text
			.def	GetBkGrnd				;Gets the background colour of the text
			.def	SetFrGrnd				;Sets the foreground colour of the text
			.def	GetFrGrnd				;Gets the foreground colour of the text
			.def	SetFont					;Sets the font to be used for text printing
			.def	GetFont					;Gets the currently selected font used for text
											; printing
			.def	SetTxtXPos				;Sets the X position of the text cursor on screen
			.def	GetTxtXPos				;Gets the X position of the text cursor on screen
			.def	SetTxtYPos				;Sets the Y position of the text cursor on screen
			.def	GetTxtYPos				;Gets the Y position of the text cursor on screen
			.def	GetTxtPos				;Gets the coordinates of the text cursor on screen
			.def	SetTxtXRel				;Sets the X position of the text cursor relative
											; to the left text window border
			.def	SetTxtYRel				;Sets the Y position of the text cursor relative
											; to the top text window border
			.def	SetPropFont				;Makes use of a font as proportional
			.def	SetFixedFont			;Makes use of a font as fixed size
			.def	GetPropFont				;Returns the type of font used (proportional or
											; not)
			.def	ScrollTextUp			;Scrolls the text area up by one character line
			.def	PrintChr				;Prints a character on screen, using the selected
											; font
			.def	GetEndOfScreen			;Reads the "EndOfScreen" flag after printing a
											; character
			.def	PrintStr				;Prints a whole ASCIIZ string
			.def	CalcFont				;Font proportional caclulator

			.def	LCDBackLightOff			;Switches off the backlight without using timer
			.def	LCDBackLightPWM			;Enables PWM usage for backlight
			.def	LCDBackLightOn			;Switches on the backlight without using timer
			.def	LCDBackLightSet			;Sets a new value of backlight and starts the
											; smooth level transition

			.def	FONT_SMALL				;The small font's index in fonts table
			.def	FONT_BIG				;The big font's index in fonts table
			.def	FONT_INCONSOLA			;The inconsola font's index in fonts table
			.def	FONT_7SEG				;The big seven segment font's index

;==< Interrupt Service Routines >============================================================
			.text							;Place program in ROM (Flash)
			.align	1
;==< Interrupt Service Routines >============================================================
BLFadeISR:
; Helps for a smooth transition of backlight luminocity. When there is a new set of backlight
; the interrupt is enabled. Every single pulse of PWM generated, triggers this interrupt. Its
; function is to set the new value to a bigger or smaller number, according to the willing
; step. If the wanted limit of PWM is reached, the interrupt is automatically disabled
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None, No flags affected
; Stack Usage:			None
; Depend On Defs:		BLCCR, BLCCTL
; Depend On Vars:		BLCurVal, BLMaxVal, BLStep
; Depend On Funcs:		None
			DEC		&BLCounter				;Decrement repetition counter by one
			JC		BLISRTerm				;Time to change value? No => just exit, nothing to
											; do
			;else, perform a PWM step
			MOV		&BLMaxCntr,&BLCounter	;Set the counter value for the next PWM step
			ADD		&BLStep,&BLCCR			;Add the signed step value to current backlight
											; level (associated Timer Capture Compare)
			CMP		#00000h,&BLStep			;Is the step positive or negative?
			JN		BLISRNeg				;Negative => BLISRNeg
			; Using positive step value
BLISRPos:	CMP		&BLMaxVal,&BLCCR		;Is the new value out of limit?
			JGE		BLISREnd				;Yes => End transition
			MOV		&BLCCR,&BLCurVal		;else, Just store the new value and
BLISRTerm:	RETI							;exit interrupt service routine
			; Using negative step value
BLISRNeg:	CMP		&BLCCR,&BLMaxVal		;Is the new value out of bounds?
			JL		BLISRExit				;No => Just store and exit...

BLISREnd:	MOV		&BLMaxVal,&BLCCR		;else, backlight value to limit
			BIC		#CCIE,&BLCCTL			;Disable interrupt of backlight transition
BLISRExit:	MOV		&BLCCR,&BLCurVal		;Store the current level value
			RETI							;and exit
;-------------------------------------------

;==< Main Program >==========================================================================
InitLCDPorts:
; Initializes the port pins the LCD Module is connected. Control bus of the LCD module is
; used as output, all its pins are in logic high to make LCD inactive, and the LCD data bus
; becomes input with all its internal pull-up resistors activated.
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCDCtrl, LCDCtrlALL, LCDCtrlDIR, LCDDataH, LCDDataHDIR, LCDDataHRES,
;						LCDDataL, LCDDataLDIR, LCDDataLRES
; Depend On Vars:		None
; Depend On Funcs:		None
			BIC.B	#LCD_BL,&LCDBLOUT		;Going to switch off LCD Backlight
			BIS.B	#LCD_BL,&LCDBLDIR		;The pin is an output (for now)
			BIS.B	#LCDCtrlALL,&LCDCtrl	;LCD Control pins must be all high when activated
			BIS.B	#LCDCtrlALL,&LCDCtrlDIR	;Also they must be all outputs
			MOV.B	#0FFh,&LCDDataLDIR 		;LCD Data ports must be outputs. They are going to
			MOV.B	#0FFh,&LCDDataHDIR		; be used as bidirectional!
			MOV.B	#000h,&LCDDataL			;Lower all data pins (Uses the constant generator
			MOV.B	#000h,&LCDDataH			; to read 000h in less CPU cycles)
			RET
;-------------------------------------------

LCDContData:
; Puts the LCD in the mode that every next data transaction is a colour of a pixel. It uses
; write_memory_continue LCD command
; Input:				Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R15
; Registers Altered:	R15 -> Contains the write_memory_continue command, No flags are
;							modified
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			MOV.B	#03Ch,R15				;write_memory_start command
			JMP		WriteLCDCmd				;Send the command
;-------------------------------------------

LCDStartData:
; Puts the LCD in the mode that every next data transaction is a colour of a pixel. It uses
; write_memory_start LCD command
; Input:				Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R15
; Registers Altered:	R15 -> Contains the write_memory_start command, No flags are modified
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			MOV.B	#02Ch,R15				;write_memory_start command
;			JMP		WriteLCDCmd				;Send the command
;-------------------------------------------

WriteLCDCmd:
; Sends a command byte to the LCD module. It expects the direction of data ports to output
; (from MPU to LCD), as a command always is on that direction.
; Input:				R15: contains the data to be sent,
;						Carry Flag: 0 => Keep CS low (more data to send on the same
;							transaction), 1 => Raise CS (No more data to send)
; Output:				None
; Registers Used:		R15
; Registers Altered:	None, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_DC, LCD_WR, LCDCtrl, LCDDataH, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		WriteLCD
			BIC.B	#LCD_DC,&LCDCtrl		;Setup D/C low to send a command to LCD
			JMP		WriteLCD				;Send the command
;-------------------------------------------

WriteLCDData:
; Sends a data byte to the LCD module. It expects the data port direction to be output, as
; it is a following transaction to a WriteLCDCmd.
; Input:				R15: contains the data to be sent,
;						Carry Flag: 0 => Keep CS low (more data to send on the same
;							transaction), 1 => Raise CS (No more data to send)
; Output:				None
; Registers Used:		R15
; Registers Altered:	None, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_DC, LCD_WR, LCDCtrl, LCDDataH, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		WriteLCD
			BIS.B	#LCD_DC,&LCDCtrl		;Setup D/C high to send a data word to LCD
;			JMP		WriteLCD				;Since WriteLCD follows in the code there is no
											; need to execute this operand
;-------------------------------------------

WriteLCD:
; Sends a word to the LCD wether it is command or data. DC pin is previously set to valid
; logic level to express if this byte corresponds to command or data
; Input:				R15: contains the data to be sent,
;						Carry Flag: 0 => Keep CS low (more data to send on the same
;							transaction), 1 => Raise CS (No more data to send)
; Output:				None
; Registers Used:		R15
; Registers Altered:	None, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_WR, LCDCtrl, LCDDataH, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		None
			BIC.B	#LCD_CS+LCD_WR,&LCDCtrl	;Lower CS and WR to enable LCD in Read mode
			MOV.B	R15,&LCDDataL			;Set the lower byte of data
			SWPB	R15						;Swap the bytes in order to...
			MOV.B	R15,&LCDDataH			;... set the higher byte of the data
			BIS.B	#LCD_WR,&LCDCtrl		;Bring WR signal high to make the transaction
			SWPB	R15						;Swap the bytes to bring R15 to its original
											; state
			JNC		WL_Exit					;Is Carry Flag cleared? => Do not raise CS
			BIS.B	#LCD_CS,&LCDCtrl		;else, Disable LCD module.
WL_Exit:	RET
;-------------------------------------------

WriteLCDData8:
; Sends a data byte to the LCD module. It expects the data port direction to be output, as
; it is a following transaction to a WriteLCDCmd. Also, it expects the higher byte of the
; LCD Data bus to be zeroed.
; Input:				R15: contains the data to be sent (only the lower byte),
;						Carry Flag: 0 => Keep CS low (more data to send on the same
;							transaction), 1 => Raise CS (No more data to send)
; Output:				None
; Registers Used:		R15
; Registers Altered:	None, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_DC, LCD_WR, LCDCtrl, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		WriteLCD
			BIS.B	#LCD_DC,&LCDCtrl		;Setup D/C high to send a data word to LCD
;			JMP		WriteLCD8				;Since WriteLCD8 follows in the code there is
											; no need to execute this operand
;-------------------------------------------

WriteLCD8:
; Sends a byte to the LCD wether it is command or data. DC pin is previously set to valid
; logic level to express if this byte corresponds to command or data. Also, it expects
; the higher byte of LCD Data bus be zeroed earlier.
; Input:				R15: contains the data to be sent (only the lower byte),
;						Carry Flag: 0 => Keep CS low (more data to send on the same
;							transaction), 1 => Raise CS (No more data to send)
; Output:				None
; Registers Used:		R15
; Registers Altered:	None, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_WR, LCDCtrl, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		None
			BIC.B	#LCD_CS+LCD_WR,&LCDCtrl	;Lower CS and WR to enable LCD in Read mode
			MOV.B	R15,&LCDDataL			;Set the lower byte of data
			BIS.B	#LCD_WR,&LCDCtrl		;Bring WR signal high to make the transaction
			JNC		WL8_Exit				;Is Carry Flag cleared? => Do not raise CS
			BIS.B	#LCD_CS,&LCDCtrl		;else, Disable LCD module.
WL8_Exit:	RET
;-------------------------------------------

ReadLCD:
; Reads one word of data from the LCD. It also sets the direction of data port to input
; and the DC pin of the LCD to read data.
; Input:				Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS and set port to output after reading
; Output:				R15: Contains the word read
; Registers Used:		R15
; Registers Altered:	R15, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_DC, LCD_RD, LCDCtrl, LCDDataHDIR, LCDDataHIN,
;						LCDDataLDIR, LCDDataLIN
; Depend On Vars:		None
; Depend On Funcs:		ReadNextLCD
			BIS.B	#LCD_DC,&LCDCtrl		;Only data can be read from the LCD module
			MOV.B	#000h,&LCDDataLDIR		;Data pins must be inputs (uses the constant
			MOV.B	#000h,&LCDDataHDIR		;generator R3 to fetch 000h)
;-------------------------------------------

ReadNextLCD:
; Reads one word of data from the LCD. It expexts the direction of the data ports to be
; inputs and DC pin to be high.
; Input:				Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				R15: Contains the word read
; Registers Used:		R15
; Registers Altered:	R15, No flags affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_RD, LCDCtrl, LCDDataHDIR, LCDDataHIN,
;						LCDDataLDIR, LCDDataLIN
; Depend On Vars:		None
; Depend On Funcs:		ReadNextLCD
			BIC.B	#LCD_CS+LCD_RD,&LCDCtrl	;Enable LCD in Write mode (from LCD to MPU)
			JMP		$+2						;Wait 4 cycles
			JMP		$+2
			MOV.B	&LCDDataHIN,R15			;Read the 8 high bits of the byte
			SWPB	R15
			BIS.B	&LCDDataLIN,R15			;Store the 8 lower bits also
			BIS.B	#LCD_RD,&LCDCtrl		;Raise RD again
			JNC		RL_Exit					;Is Carry Flag cleared? => Do not raise CS
			BIS.B	#LCD_CS,&LCDCtrl		;else, disable the LCD module
			MOV.B	#0FFh,&LCDDataLDIR		;Set the direction of data port to output
			MOV.B	#0FFh,&LCDDataHDIR
RL_Exit:	RET
;-------------------------------------------

InitLCD:
; Sends the correct command sequence to initialise the LCD module
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		None
			MOV		#DEFBLVAL,&BLMaxVal		;Default maximum PWM value of the backlight
			MOV		#00000h,&BLCurVal		;Current PWM value of the backlight is 0.
			MOV		#DEFCOUNTER,&BLMaxCntr	;Default delay for PWM step change
			MOV		#DEFCOUNTER,&BLCounter	;The same value for current delay position count

			.if $isdefed("BLCTL")			;If PWM can be used for LCD Backlight
;			MOV.W	#0FFFFh,&BLCCR0			;Maximum value of PWM
			MOV.W	#DEFBLVAL,&BLCCR		;Default illuination PWM value of LCD Backlight
			.endif

			MOV.W	#DEFBKGRND,&BkGrndClr	;Set the default background colour
			MOV.W	#DEFFRGRND,&FrGrndClr	;Set the default foreground colour
			MOV.W	#DEFFONT,R4				;Going to set the font to be used
			CALL	#SetFont				;The font to be used is the default one
			MOV.W	#00000h,&FontProps		;Reset font properties
			MOV.W	#InitLCDTbl,R13			;Going to use a table of data to send to the LCD
			;In this table every command has the following format:
			;Byte1 is the number of data bytes the LCD command contains, if positive, or
			; a command to this function, if negative (like delay or End Of Sequence)
			;In case of a function command the rest of the bytes are its parameters, else
			;it is the LCD command byte.
			;The LCD command follow as many data bytes as specified by Byte1 of the sequence
ILCDNext:	MOV.B	@R13+,R14				;Get one byte.
			;If the byte fetched from the table is positive then it coresponds to the length
			; of data this command contains. If it is negative then it is a command to this
			; function: ex. 080h specifies a delay, 0FFh specifies the end of sequence
			TST.B	R14						;Lets find out if it is negative
			JN		InitCmd					;Negative => execute a non LCD command
			MOV.B	@R13+,R15				;Get the LCD command to send
			CLRC							;Keep CS low after the command sending
			CALL	#WriteLCDCmd			;Send the command to LCD

ILCDDataNxt:
			JZ		ILCDNext				;No more data bytes to send? => Check for next
											; LCD command. Zero flag comes from TST R14
											; operand executed earlier, since WriteLCDCmd
											; does not affect flags
			MOV.B	@R13+,R15				;Get one byte of data
			CLRC							;Carry must be cleared to keep sending data
			CALL	#WriteLCDData8			;Can use 8 bit transaction because WriteLCDCmd
											; earlier reset the higher byte of LCD data bus
			DEC		R14						;One data byte less
			JMP		ILCDDataNxt				;Read next data byte...

			;The following code is for helper commands to InitLCD and not the LCD itself:
			;080h => Execute Delay
			;All other values => End of initialisation sequence
InitCmd:	CMP.B	#0FFh,R14				;Is it an END command?
			JEQ		InitEnd					;Yes => Execute delay loop
			BIT.B	#002h,R14				;Do we need to set Reset pin?
			JZ		InitDelay				;No => Then it is a Delay command
			BIT.B	#001h,R14				;Set or Reset?
			JZ		InitReset				;0 => Activate Reset pin
			BIS.B	#LCD_RES,&LCDCtrl		;1 => Deactivate Reset pin
			JMP		ILCDNext				;Next command, please...
InitReset:	BIC.B	#LCD_RES,&LCDCtrl		;Lower Reset pin
			JMP		ILCDNext				;Next command...
InitEnd:	MOV		#001DFh,&LCDMaxX		;Maximum value of X axis is 479
			MOV		#0013Fh,&LCDMaxY		;Maximum value of Y axis is 319
			MOV		#ORIENTFLG,&LCDFlags	;Mark orientation as LANDSCAPE
			MOV.W	#00000h,&TxtWinT		;Valid text window is the whole screen
			MOV.W	#00000h,&TxtWinL
			MOV.W	&LCDMaxX,&TxtWinR
			MOV.W	&LCDMaxY,&TxtWinB
			MOV.W	#00000h,&CurXPos		;The text cursor points to the top left corner of
			MOV.W	#00000h,&CurYPos		; the screen
			RET								;else, need to exit
			;The following code part must be implemented again, using timers
InitDelay:	MOV.B	@R13+,R15				;Get the highest byte of the delay value
			SWPB	R15						;Bring it to the highest position
			MOV.B	@R13+,R14				;Logic or to the lower byte
			BIS		R14,R15					;Logic OR the two bytes to form the 16 bit factor
IDelayLoop:	DEC		R15						;Decrement the counter
			JMP		$+2						;Wait 26 clock pulses (total of 30 for the loop)
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JMP		$+2
			JNZ		IDelayLoop				;Repeat until expiration
			JMP		ILCDNext				;Next command...
;-------------------------------------------

FillRegion:
; Fills a region of consecutive pixels with the same colour. The region should be set earlier
; using the appropriate commands to the LCD. At least one pixel is set.
; Input:				R15: contains the colour data to be sent,
;						R14: contains the number of pixels to set (0 means 65536)
;						Carry Flag: 0 => Keep CS low (more data to send on the same
;							transaction), 1 => Raise CS (No more data to send)
; Output:				None
; Registers Used:		R14, R15
; Registers Altered:	R14 => is cleared, No flags affected
; Stack Usage:			2 bytes for storing the flags (SR register)
; Depend On Defs:		LCD_DC, LCD_CS, LCD_WR, LCDCtrl, LCDDataH, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		None
			BIS.B	#LCD_DC,&LCDCtrl		;Setup D/C high to send a data word to LCD
			PUSH	SR						;Going to check current Carry flag
			BIC.B	#LCD_CS+LCD_WR,&LCDCtrl	;Lower CS and WR to enable LCD in Read mode
			MOV.B	R15,&LCDDataL			;Set the lower byte of data
			SWPB	R15						;Swap the bytes in order to...
			MOV.B	R15,&LCDDataH			;... set the higher byte of the data
			BIS.B	#LCD_WR,&LCDCtrl		;Bring WR signal high to make the transaction
			SWPB	R15						;Swap the bytes to bring R15 to its original
											; state
FR_Loop:	DEC		R14						;One pixel less
			JZ		FR_CSTest				;If no more pixels to set, then exit
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again
			BIS.B	#LCD_WR,&LCDCtrl		;Raise it again to set the pixel
			JMP		FR_Loop					;Repeat for more pixels
FR_CSTest:	POP		SR						;Restore flags
			JNC		FR_Exit					;Is Carry Flag cleared? => Do not raise CS
			BIS.B	#LCD_CS,&LCDCtrl		;else, Disable LCD module bus.
FR_Exit:	RET
;-------------------------------------------

ClearScreen:
; Fills the screen with a colour. It uses the fast fill algorythm
; Input:				R15 contains the colour to be used as background of screen
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R8, R9, R14, R15
; Registers Altered:	R4 = 0, R5 = MAXX, R6 = 0, R7 = MAXY, R8 = 0, R9 = 0FFFFh,
;						Flags are modified
; Stack Usage:			2 for helper calls
; Depend On Defs:		LCD_CS, LCD_DC, LCD_WR, LCDCtrl, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		FillRegion
			XOR		R4,R4
			MOV		R4,R6
			MOV		#LANDSCAPE_MAXX,R5
			MOV		#LANDSCAPE_MAXY,R7
;			JMP		FillRect				;Fill a rectangle of the whole screen
;-------------------------------------------

FillRect:
; Fills a whole rectangle with a colour. It uses hardware multiplier
; Input:				R4:		Left
;						R5:		Right
;						R6:		Top
;						R7:		Bottom
;						R15:	Colour
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R8, R9, R14, R15
; Registers Altered:	R8 -> 0, R9 -> 0FFFFh, Flags are modified
; Stack Usage:			2 bytes for helper calls
; Depend On Defs:		LCD_CS, LCD_DC, LCD_WR, LCDCtrl, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		FillRegion
			;Going to send command 2A (set_column_address) to define the horizontal region
			BIC.B	#LCD_DC+LCD_CS+LCD_WR,&LCDCtrl	;Lower CS and WR to enable LCD in
											; Read mode. Sending command
			MOV.B	#02Ah,&LCDDataL			;Set column address command. (High byte of
											; data for transaction does not care)
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIS.B	#LCD_DC,&LCDCtrl		;Going to send data
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			SWPB	R4
			MOV.B	R4,&LCDDataL			;Send the high byte of Left border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			SWPB	R4
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	R4,&LCDDataL			;Send the low byte of Left border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			SWPB	R5
			MOV.B	R5,&LCDDataL			;Send the high byte of Right border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			SWPB	R5
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	R5,&LCDDataL			;Send the low byte of Right border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command

			;Command 2B (set_page_address) follows to define the vertical region
			BIC.B	#LCD_DC+LCD_WR,&LCDCtrl	;Going to send command.
			MOV.B	#02Bh,&LCDDataL			;Set column address command. (High byte of
											; data for transaction does not care)
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIS.B	#LCD_DC,&LCDCtrl		;Going to send data
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			SWPB	R6
			MOV.B	R6,&LCDDataL			;Send the high byte of Top border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			SWPB	R6
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	R6,&LCDDataL			;Send the low byte of Top border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			SWPB	R7
			MOV.B	R7,&LCDDataL			;Send the high byte of Bottom border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			SWPB	R7
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	R7,&LCDDataL			;Send the low byte of Bottom border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command

			;Command 2C (write_memory_start) follows to start filling pixels
			BIC.B	#LCD_DC+LCD_WR,&LCDCtrl	;Going to send command.
			MOV.B	#02Ch,&LCDDataL			;Write memory start command. (High byte of
											; data for transaction does not care)
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIS.B	#LCD_DC,&LCDCtrl		;Going to send data

			PUSH	SR						;Need to check Carry Flag afterwards

			;Now lets calculate the number of pixels to be filled
			MOV		R5,R8					;Get the right border
			SUB		R4,R8					;Subtract the left one
			INC		R8						;Add 1 because right pixel is included in the
											; region. R8 now contains the horizontal length
			MOV		R7,R9					;Get the bottom border
			SUB		R6,R9					;Subtract the top one
			INC		R9						;Add 1 to calculate the whole height, as before

			MOV		R8,&MPY					;Going to multiply the width times...
			MOV		R9,&OP2					; ... height
			MOV		&RESLO,R8				;Get the lower part of the result
			MOV		&RESHI,R9				;Get the higher byte
			XOR		R14,R14					;Clear R14 (for 65536 pixels)
FRct_Next:	DEC		R9						;Going to send R8 times 65536 pixels
			JNC		FRct_Rest				;Was R9 == 0? => Only R8 pixels left
			MOV		@SP,SR					;Refresh flags from stack
			CALL	#FillRegion				;Fill 65536 pixels
			JMP		FRct_Next				;Repeat
FRct_Rest:	MOV		R8,R14					;Lets send the rest of the pixels
			POP		SR						;Restore flags from stack
			JMP		FillRegion
;-------------------------------------------

SetOrientation:
; Sets the orientation using set_address_mode. The available address modes are:
;	PORTRAIT_TOPLEFT, PORTRAIT_BOTTOMLEFT, PORTRAIT_TOPRIGHT, PORTRAIT_BOTTOMRIGHT
;	LANDSCAPE_TOPLEFT, LANDSCAPE_BOTTOMLEFT, LANDSCAPE_TOPRIGHT, LANDSCAPE_BOTTOMRIGHT
; Input:				R4: Orientation code
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R15
; Registers Altered:	R15 -> Becomes equal to R4, No flags are modified
; Stack Usage:			2 bytes for helper calls
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			PUSH	SR
			BIT		#BIT5,R4				;Portrait or Landscape?
			JNZ		LSO_Land				;Landscape => LCD_Port
			MOV		#PORTRAIT_MAXX,&LCDMaxX	;else, set vars for Portrait
			MOV		#PORTRAIT_MAXY,&LCDMaxY
			BIC		#ORIENTFLG,&LCDFlags
			JMP		LSO_Exec
LSO_Land:	BIS		#ORIENTFLG,&LCDFlags	;Landscape settings
			MOV		#LANDSCAPE_MAXX,&LCDMaxX
			MOV		#LANDSCAPE_MAXY,&LCDMaxY
LSO_Exec:	POP		SR
			MOV.B	#036h,R15				;Going to send the command set_address_mode
			CALL	#WriteLCDCmd
			MOV		R4,R15					;And now the orientation as data
			JMP		WriteLCDData8
;-------------------------------------------

LCDSetPageAddr:
; Sets the page address of the next pixel to be altered
; Input:				R4: Page address.
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R15
; Registers Altered:	R15 -> Becomes the maximum valid page address, No flags are modified
; Stack Usage:			2 bytes for helper calls
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			MOV.B	#02Bh,R15				;Going to send the command set_page_address
			CALL	#WriteLCDCmd
			SWPB	R4
			MOV.B	R4,R15
			CALL	#WriteLCDData8			;the high byte of the starting page address
			SWPB	R4
			MOV.B	R4,R15
			CALL	#WriteLCDData8			;the low byte of the starting page address
			MOV		&LCDMaxY,R15			;End of region must be the maximum valid
			SWPB	R15
			CALL	#WriteLCDData8			;Send the higher byte first
			SWPB	R15
			JMP		WriteLCDData8			;then the lower and exit
;-------------------------------------------

LCDSetColAddr:
; Sets the column address of the next pixel to be altered
; Input:				R4: Column address.
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R15
; Registers Altered:	R15 -> Becomes equal to the maximum valid column, No flags are
;							modified
; Stack Usage:			2 bytes for helper calls
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			MOV.B	#02Ah,R15				;Going to send the command set_column_address
			CALL	#WriteLCDCmd
			SWPB	R4
			MOV.B	R4,R15
			CALL	#WriteLCDData8			;the higher byte of column address
			SWPB	R4
			MOV.B	R4,R15
			CALL	#WriteLCDData8			;the lower byte of the column address
			MOV		&LCDMaxX,R15			;End of region must be the maximum valid
			SWPB	R15
			CALL	#WriteLCDData8			;Send the higher byte first
			SWPB	R15
			JMP		WriteLCDData8			;Finally send the lower byte and exit
;-------------------------------------------

Text2Region:
; Sets the region of the screen to be same as the text region specified earlier
; Input:				Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R15
; Registers Altered:	R4 contains the left border of text area
;						R5 contains the right border of text area
;						R6 contains the top border of text area
;						R7 contains the bottom border of text area
;						R15 -> Becomes equal to the maximum page set, No flags are
;							modified
; Stack Usage:			2 bytes for helper calls
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		GetTextWindow, LCDSetRegion, WriteLCDCmd, WriteLCDData8
			CALL	#GetTextWindow			;Get the coordinates of the currenty set text
											; region
;			JMP		LCDSetRegion			;And set the region to the LCD module. Since
											; LCDSetRegion follows, no need to execute a jump
;-------------------------------------------

LCDSetRegion:
; Sets the page and column address of the pixels to be altered. R4 must be less or equal to
; R5 and R6 must be less or equal to R7.
; Input:				R4: Starting column address (Left)
;						R5:	Ending column address (Right)
;						R6:	Starting page address (Top)
;						R7: Ending page address (Bottom)
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R15
; Registers Altered:	R15 -> Becomes equal to the maximum page set, No flags are
;							modified
; Stack Usage:			2 bytes for helper calls
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			MOV.B	#02Ah,R15				;Going to send the command set_column_address
			CALL	#WriteLCDCmd
			SWPB	R4
			MOV.B	R4,R15
			CALL	#WriteLCDData8			;the higher byte of the starting column address
			SWPB	R4
			MOV.B	R4,R15
			CALL	#WriteLCDData8			;the lower byte of the starting column address
			MOV		R5,R15					;Going to send the ending column address
			SWPB	R15
			CALL	#WriteLCDData8			;Send the higher byte first
			SWPB	R15
			CALL	#WriteLCDData8			;Then send the lower byte

			MOV.B	#02Bh,R15				;Going to send the command set_page_address
			CALL	#WriteLCDCmd
			SWPB	R6
			MOV.B	R6,R15
			CALL	#WriteLCDData8			;the higher byte of the starting page address
			SWPB	R6
			MOV.B	R6,R15
			CALL	#WriteLCDData8			;the lower byte of the starting page address
			MOV		R7,R15					;Going to send the ending page address
			SWPB	R15
			CALL	#WriteLCDData8			;Send the higher byte first
			SWPB	R15
			JMP		WriteLCDData8			;Finally send the lower byte
;-------------------------------------------

DrawRect:
; Draws a rectangle on the screen from (x1,y1) to (x2,y2) inclusive.
; Input:				R4: x1
;						R5:	x2
;						R6:	y1
;						R7:	y2
;						R15: Colour
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R13, R14, R15
; Registers Altered:	R4 -> Contains the Set Orientation command
;						R13 -> Contains y1 coorinate
;						R14 -> Is cleared
;						No flags affected
; Stack Usage:			6 bytes, 4 for pushing registers and 2 bytes for calling other funcs
; Depend On Defs:		LANDSCAPE_BOTTOMRIGHT, LANDSCAPE_TOPLEFT, PORTRAIT_BOTTOMRIGHT,
;						PORTRAIT_TOPLEFT
; Depend On Vars:		None
; Depend On Funcs:		FillRegion, LCDContData, LCDSetRegion, LCDStartData, SetOrientation
			PUSH	SR
			PUSH	R15
			MOV		R4,R8					;Need to keep the old coordinates and we use
			MOV		R5,R9					; R8, R9, R14 and R15, as these registers can be
			MOV		R6,R13					; used later, these are faster than push/pop and
			MOV		R7,R14					; we don't have to use other registers than
											; necessary on this function
			CALL	#LCDSetRegion			;Select only the region of the rectangle
			CALL	#LCDStartData			;Start sending pixel data. This makes the
											; selection of the starting point to be drawn
			MOV		#00000h,R4				;Going to select the maximum possible region for
			MOV		#001DFh,R5				; both portrait and landscape orientations
			MOV		#00000h,R6
			MOV		#001DFh,R7
			CALL	#LCDSetRegion
			;The reason for the maximum region selection is that when we change orientation
			; the LCD controller changes the origin position and it does not translate the
			; selected region's position. So, by selecting the maximum region we ensure that
			; every time there is an orientation change, the coordinates of the line to be
			; drawn will be inside the selected region
			MOV		R14,R7					;Restore the registers that hold the coordinates
			MOV		R13,R6					; of the rectangle
			MOV		R9,R5
			MOV		R8,R4
			CALL	#LCDContData
			MOV		R5,R8					;Lets calculate the width of the rectangle
			SUB		R4,R8
;			INC		R8
			MOV		R7,R9					;Lets also calculate the height of the rectangle
			SUB		R6,R9
;			INC		R9
			MOV		R8,R14					;Size of line to be drawn
			MOV		@SP,R15					;Refresh colour value
			CALL	#FillRegion				;Draw the first horizontal line (top)
			MOV.B	#PORTRAIT_TOPLEFT,R4
			CALL	#SetOrientation
			CALL	#LCDContData
			MOV		R9,R14
			MOV		@SP,R15					;Refresh colour value
			CALL	#FillRegion				;Draw the first vertical line (right)

			MOV.B	#LANDSCAPE_BOTTOMRIGHT,R4
			CALL	#SetOrientation

			CALL	#LCDContData
			MOV		R8,R14
			MOV		@SP,R15					;Refresh colour value
			CALL	#FillRegion				;Draw the second horizontal line (bottom)

			MOV.B	#PORTRAIT_BOTTOMRIGHT,R4
			CALL	#SetOrientation

			CALL	#LCDContData
			MOV		R9,R14
			POP		R15						;Get R15 out of stack
			CALL	#FillRegion				;Draw the second vertical line (left)

			MOV.B	#LANDSCAPE_TOPLEFT,R4
			POP		SR						;Get CPU Flags out of stack. Carry flag is needed
			JMP		SetOrientation			;Restore orientation to default
;-------------------------------------------

DrawLine:
; Draws a line on the screen from (x1,y1) to (x2,y2) inclusive.
; Input:				R4: x1
;						R5:	x2
;						R6:	y1
;						R7:	y2
;						R15: Colour
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R8, R9, R10, R14, R15
; Registers Altered:	R4, R5, R6, R7, R8, R9, R10, R14: Unpredicted
;						No flags are modified
; Stack Usage:			4 bytes for register storage + 2 bytes for calling other functions
; Depend On Defs:		LANDSCAPE_BOTTOMLEFT, LANDSCAPE_TOPLEFT, LANDSCAPE_TOPRIGHT,
;						PORTRAIT_BOTTOMLEFT, SWAPXFLG, SWAPYFLG
; Depend On Vars:		LCDFlags
; Depend On Funcs:		FillRegion, LCDSetRegion, LCDStartData, SetOrientation
			PUSH	SR						;Need to keep Carry Flag
			PUSH	R15						;Keep the colour of the line in stack
			MOV		#PORTRAIT_BOTTOMLEFT,R10;Calculate the orientation of the line
			BIC		#SWAPXFLG+SWAPYFLG,&LCDFlags
											;Reset swapping flags
			MOV		R5,R8					;R8 will hold the width of the line
			SUB		R4,R8
			JZ		DrawVLine				;If starting and ending points are equal then we
											; have a vertical line
			JC		DLN_NoXSwp				;Positive result => Do not swap X axes
			INV		R4						;else normalise horizontal points
			INV		R5
			ADD		#001E0h,R4
			ADD		#001E0h,R5
			BIS		#SWAPXFLG,&LCDFlags		;Flag the X axes swapping
											;And alter the orientation bit
			XOR		#LANDSCAPE_TOPLEFT ^ LANDSCAPE_TOPRIGHT,R10
			;In the previous command it would be the same if we had
			; PORTRAIT_BOTTOMLEFT ^ PORTRAIT_TOPLEFT, as this bit reflects to the same
			; LCD axis, despite the orientation
			INV		R8						;Convert R8 to positive
			INC		R8
DLN_NoXSwp:	MOV		R7,R9					;R9 will hold the height of the line
			SUB		R6,R9
			JZ		DrawDSLine				;Zero height? => Draw a horizontal line
			JC		DLN_NoYSwp				;Positive result => Do not swap Y axes
			INV		R6						;else normalise vertical points
			INV		R7
			ADD		#00140h,R6
			ADD		#00140h,R7
			BIS		#SWAPYFLG,&LCDFlags		;Flag the Y axes swapping
											;And alter the orientation bit
			XOR		#LANDSCAPE_TOPLEFT ^ LANDSCAPE_BOTTOMLEFT,R10
			;In the previous command it would be the same if we used
			; PORTRAIT_BOTTOMLEFT ^ PORTRAIT_BOTTOMRIGHT, as this bit reflects to the same
			; LCD axis, despite orientation
			INV		R9						;Convert R9 to positive
			INC		R9
DLN_NoYSwp:	INC		R8						;Include the ending point in the line width
			INC		R9						;Include the ending point to the line height
			;Now lets find if we must be in portrait or landscape mode
			CMP		R9,R8					;Compare Height with Width
			JHS		DLN_LScape				;Height <= Width? -> Landscape mode
			;Need to revert to Portrait mode
			XOR		R8,R9					;Swap width and height for portrait mode
			XOR		R9,R8
			XOR		R8,R9
			XOR		R4,R6					;Swap X axis with Y axis ...
			XOR		R6,R4
			XOR		R4,R6
			XOR		R5,R7					;... for both points, starting and ending
			XOR		R7,R5
			XOR		R5,R7
			;Consume 1 cycle, only for ease of code by setting and reseting the Landscape
			; flag in orientation byte. For Landscape mode, only the second XOR is executed
			XOR		#LANDSCAPE_TOPLEFT ^ PORTRAIT_BOTTOMLEFT, R10
DLN_LScape:	XOR		#LANDSCAPE_TOPLEFT ^ PORTRAIT_BOTTOMLEFT, R10
			PUSH	R4						;Orientation setting uses R4, so stack helps
			MOV		R10,R4					;Set the calculated orientation
			CALL	#SetOrientation
			POP		R4						;Restore R4
			CALL	#LCDSetRegion			;Also, select the region to be used
			;The rest of the code is for drawing a line with greater width than height and
			;from smaller point axis values to larger one. The registers that describe the
			;line to be printed are:
			;R4: Left point
			;R5: Right point
			;R6: Top point
			;R7: Bottom point
			;R8: Width
			;R9: Height
			;All registers are normilised to reflect the values according to current screen
			;orientation
;			MOV		R14,R9					;R9 must hold the width
			MOV		R8,R10
			RRA		R10						;R10 is half of the width (Virtual Modulo)
DL_NextSeg:	CLRC
			CALL	#LCDStartData			;Start writing colour data to the LCD
			BIS.B	#LCD_DC,&LCDCtrl		;Going to send data to the LCD
			MOV		@SP,R15					;Get the colour of the value from the stack
			MOV.B	R15,&LCDDataL			;Set the valid colour to the LCD data port
			SWPB	R15
			MOV.B	R15,&LCDDataH
			SWPB	R15
DL_NxtDot:	BIC.B	#LCD_WR,&LCDCtrl		;Create a WR pulse => Draws a pixel
			BIS.B	#LCD_WR,&LCDCtrl
			CMP		R5,R4					;Did we reach the end?
			JHS		DL_End					;Yes => then exit
			INC		R4						;Track the left side
			SUB		R9,R10					;Subtract Height from current "Virtual Modulo"
			JC		DL_NxtDot				;Still positive? => Next pixel follows
			INC		R6						;else, we need to change line
			ADD		R8,R10					;Bring Virtual Modulo back to positive
			CLRC							;Do not raise CS after the command setting
			CALL	#LCDSetRegion			;Set the new region to the new line
			JMP		DL_NextSeg				;Repeat for next line segment
DL_End:		POP		R15						;Get colour number out of stack
			POP		SR						;Restore Carry flag
			MOV		#LANDSCAPE_TOPLEFT,R4	;Restore the normal orientation
			JMP		SetOrientation

DrawVLine:	MOV		R7,R14					;Going to calculate the height of the vertical
			SUB		R6,R14					; line
			JC		DrawSLine				;If positive result => Draw the line
			INV		R14						;Convert it to positive number
			INC		R14
			XOR		R6,R7					;And swap the two ends
			XOR		R7,R6
			XOR		R6,R7
			JMP		DrawSLine				;And draw the line

DrawDSLine:	;R4 and R5 are normilised, R8 contains the size of the line -1
			MOV		R8,R14

DrawSLine:	CALL	#LCDSetRegion			;Select the region of the line
			INC		R14						;Include the ending point in the whole size
			CLRC
			CALL	#LCDStartData			;Start drawing pixels
			POP		R15						;Restore the colour
			POP		SR						;Also restore the flags
			JMP		FillRegion				;Fill the line's pixels with colour
;-------------------------------------------

DrawRoundRect:
; Draws a rectangle on the screen from (x1,y1) to (x2,y2) inclusive. The rectangle has rounded
; corners. The radius of the corners can be set
; Input:				R4: x1
;						R5:	x2
;						R6:	y1
;						R7:	y2
;						R10: Corner radius
;						R15: Colour
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R8, R9, R10, R11, R15 (and R12, R13, R14 by DrawRect)
; Registers Altered:	R4, R5, R6, R7, R8, R9, R11, R12, R13, R14
;						No flags are affected
; Stack Usage:			26 (12 for pushing registers, 2 for Call and 12 used by DrawArcs)
; Depend On Defs:		OP_CIRCLE
; Depend On Vars:		None
; Depend On Funcs:		DrawArcs, DrawLine
			;Lets prepare the four corners of the rectangle. The circle must have the center
			; at (x1+R,y1+R) and dCx and dCy myst be twice the Radius of the rounded corners
			PUSH	SR						;Store flags
			PUSH	R10						;Store radius value to stack...
			PUSH	R5						;... right axis...
			PUSH	R7						;... bottom axis...
			PUSH	R6						;... top axis...
			PUSH	R4						;... and left axis
			MOV		R4,R8					;Lets prepare the center of the circle
			ADD		R10,R8					;X = left + radius
			MOV		R6,R9
			ADD		R10,R9					;Y = top + radius
			SUB		R4,R5					;Lets calculate the horizontal distance dCx =...
			SUB		R10,R5					; ... = Width - 2*R
			SUB		R10,R5
			MOV		R5,R4					;and store it in R4
			SUB		R6,R7					;Same trick for the vertical distance dCy =...
			SUB		R10,R7					; ... = Height -2*R
			SUB		R10,R7
			MOV		R7,R6					;Store it in R6
			MOV		#OP_CIRCLE,R11			;All parts of the circle must be drawn
			CLRC							;Keep CS low
			CALL	#DrawArcs				;Draw the corners
			POP		R4						;Restore left coordinate from stack without
											; removing it
			ADD		R10,R4					;x1+R
			MOV		4(SP),R5				;Restore right coordinate
			SUB		R10,R5					;x2-R
			MOV		@SP,R6						;Restore y1 for top line of the rectangle
			MOV		R6,R7					;Horizontal line, so y2 = y1
			CLRC
			CALL	#DrawLine				;Top horizontal line
			MOV		2(SP),R6					;Restore y1 for bottom line of the rectangle
			MOV		R6,R7					;Horizontal line, so y2 = y1
			CLRC
			CALL	#DrawLine				;Bottom horizontal line
			MOV		6(SP),R10				;Restore radius
			SUB		R10,R4					;Restore most left axis of the rectangle
			MOV		R4,R5					;Vertical line, so x2 = x1
			SUB		R10,R7					;Ending y2 = y2 -R
			POP		R6						;Restore starting y1
			ADD		R10,R6					;And add the radius
			CLRC
			CALL	#DrawLine				;Draw the line
			INCD	SP						;Forget y2
			POP		R4						;pop x2
			MOV		R4,R5
			MOV		2(SP),SR				;restore flags
			CALL	#DrawLine				;Draw the right vertical line
			POP		R10						;Restore radius
			POP		SR						;Restore flags
			RET
;-------------------------------------------

SetHScroll:
; Sets the scroll area of the LCD
; Input:				R4: x1 (Left point)
;						R5:	x2 (Right point, inclusive)
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R15
; Registers Altered:	R15 -> Becomes same as R4
;						No flags are modified
; Stack Usage:			2 bytes for register storage + 2 bytes for calling other functions
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			PUSH	SR
			MOV.B	#033h,R15
			CALL	#WriteLCDCmd			;Issue the set_scroll_area command
			MOV		#001DFh,R15				;Real coordinates are from right to left
			SUB		R5,R15					;Top Fixed Area is the right value from the right
											; LCD border
			SWPB	R15
			CALL	#WriteLCDData8			;High byte of TFA
			SWPB	R15
			CALL	#WriteLCDData8			;Low byte of TFA
			MOV		R5,R15					;Need to find the length of Vertical Scrolling
			SUB		R4,R15					; area, ...
			INC		R15						;... including the final line
			SWPB	R15
			CALL	#WriteLCDData8			;Send the high byte of VSA
			SWPB	R15
			CALL	#WriteLCDData8			;Send the low byte of VSA
			MOV		R4,R15					;And the rest of the lines are for Bottom Fixed
			SWPB	R15						; Area (BFA)
			CALL	#WriteLCDData8			;Send the high byte of BFA first
			SWPB	R15
			POP		SR
			JMP		WriteLCDData8			;Finally send its low byte
;-------------------------------------------

HScroll:
; Sets the horizontal scroll position of the LCD
; Input:				R4: contains the X Axis that becomes the starting point of the
;							scrolling region previously set with SetHScroll
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R15
; Registers Altered:	R15 -> Contains the normalised value of R4
;						No flags are modified
; Stack Usage:			4 bytes for register storage + 2 bytes for calling other functions
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDCmd, WriteLCDData8
			PUSH	SR						;Need to store some registers in order to leave
			PUSH	R4						; their values unaffected
			MOV		#00037h,R15				;Going to send set_scroll_start command
			CALL	#WriteLCDCmd
			MOV		#001DFh,R15				;Need to normalise the VSP as 479 - R4
			SUB		R4,R15					;This is the new VSP
			SWPB	R15						;Going to send the high byte of VSP
			CALL	#WriteLCDData8
			SWPB	R15						;And then the low byte
			POP		R4						;Restore registers
			POP		SR
			JMP		WriteLCDData8
;-------------------------------------------

Plot:
; Plots one pixel
; Input:				R4:	X Axis of pixel to be drawn
;						R6:	Y Axis of the pixel to be drawn
;						R15: Colour of the pixels
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R6, R15
; Registers Altered:	None, No flags are affected
; Stack Usage:			None
; Depend On Defs:		LCD_CS, LCD_DC, LCD_WR, LCDCtrl, LCDDataH, LCDDataL
; Depend On Vars:		None
; Depend On Funcs:		WriteLCDData
			;Going to send command 2A (set_column_address) to define the horizontal region
			; In this region starting and ending column have the same value
			PUSH	SR						;Store flags
			CMP		#LANDSCAPE_MAXX +1,R4	;X out of bounds?
			JHS		PlotExit				;Yes => Exit without plotting
			CMP		#LANDSCAPE_MAXY +1,R6	;Y out of bounds?
			JHS		PlotExit				;Yes => Exit without plotting
			POP		SR						;Restore flags
			BIC.B	#LCD_DC+LCD_CS+LCD_WR,&LCDCtrl	;Lower CS and WR to enable LCD in
											; Read mode. Sending command
			MOV.B	#02Ah,&LCDDataL			;Set column address command. (High byte of
											; data for transaction does not care)
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIS.B	#LCD_DC,&LCDCtrl		;Going to send data
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			SWPB	R4
			MOV.B	R4,&LCDDataL			;Send the high byte of Left border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			SWPB	R4
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	R4,&LCDDataL			;Send the low byte of Left border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
;			SWPB	R4
			MOV.B	#(LANDSCAPE_MAXX >> 8),&LCDDataL
											;Send the high byte of Right border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
;			SWPB	R4
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	#(LANDSCAPE_MAXX & 0FFh),&LCDDataL
											;Send the low byte of Right border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command

			;Command 2B (set_page_address) follows to define the vertical region
			;Also, in this region the starting and ending rows are the same
			BIC.B	#LCD_DC+LCD_WR,&LCDCtrl	;Going to send command.
			MOV.B	#02Bh,&LCDDataL			;Set column address command. (High byte of
											; data for transaction does not care)
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIS.B	#LCD_DC,&LCDCtrl		;Going to send data
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			SWPB	R6
			MOV.B	R6,&LCDDataL			;Send the high byte of Top border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			SWPB	R6
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	R6,&LCDDataL			;Send the low byte of Top border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
;			SWPB	R6
			MOV.B	#(LANDSCAPE_MAXY >> 8),&LCDDataL
											;Send the high byte of Bottom border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
;			SWPB	R6
			BIC.B	#LCD_WR,&LCDCtrl		;Lower WR again to prepare data
			MOV.B	#(LANDSCAPE_MAXY & 0FFh),&LCDDataL
											;Send the low byte of Bottom border
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command

			;Command 2C (write_memory_start) follows to start filling pixels
			BIC.B	#LCD_DC+LCD_WR,&LCDCtrl	;Going to send command.
			MOV.B	#02Ch,&LCDDataL			;Write memory start command. (High byte of
											; data for transaction does not care)
			BIS.B	#LCD_WR,&LCDCtrl		;Raise WR to send the command
			BIS.B	#LCD_DC,&LCDCtrl		;Going to send data

			JMP		WriteLCDData			;Send the pixel
PlotExit:	POP		SR						;Restore flags and
			RET								; exit
;-------------------------------------------

OctaPlot:
; Plots eight pixels according to the input drawing flag. The pixels to be drawn are:
; (x+dx,y+dy), (x-dx,y+dy), (x+dx,y-dy), (x-dx,y-dy)
; (x+dy,y+dx), (x+dy,y-dx), (x-dy,y+dx), (x-dy,y-dx)
; NOTE: The function always leaves the CS low!
; Input:				R4:	dCx	is the center extra addition for right part arcs
;						R5:	dx
;						R6:	dCy is the center extra addition for bottom part arcs
;						R7:	dy
;						R8:	X
;						R9:	Y
;						R11: Flag for each part to be skipped drawing
;						R15: Colour of the pixels
; Output:				None
; Registers Used:		R4, R5, R6, R7, R8, R9, R11, R15
; Registers Altered:	None
; Stack Usage:			8 bytes: 6 for pushing R4, R6, R11 and 2 for Call Plot
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		Plot
			PUSH	R11
			PUSH	R4
			PUSH	R6
			ADD		R8,R4					;R4 = X+dCx+dx
			ADD		R5,R4
			ADD		R9,R6					;R6 = Y+dCy+dy
			ADD		R7,R6
			RRC.B	R11						;Carry contains the LSB of drawing flags
			JC		OP_SkipBP				; OP_BOTTOMPLUS
			CALL	#Plot					;Plot(X+dCx+dx,Y+dCy+dy)
OP_SkipBP:	MOV		R9,R6					;R6 = Y-dy
			SUB		R7,R6
			RRC.B	R11						;Carry contains the next OctalPlot flag
			JC		OP_SkipTP				; OP_TOPPLUS
			CALL	#Plot					;Plot(X+dCx+dx,Y-dy)
OP_SkipTP:	MOV		R8,R4					;R4 = X-dx
			SUB		R5,R4
			RRC.B	R11						;Carry flag now contains the next OctalPlot
			JC		OP_SkipTM				; flag OP_TOPMINUS
			CALL	#Plot					;Plot(X-dx,Y-dy)
OP_SkipTM:	MOV		@SP,R6					;Restore dCy from stack without removing it
			ADD		R9,R6					;R6 = Y+dCy+dy
			ADD		R7,R6
			RRC.B	R11						;Carry contains the next OctalPlot flag
			JC		OP_SkipBM				;OP_BOTTOMMINUS
			CALL	#Plot					;Plot(X-dx,Y+dCy+dy)
OP_SkipBM:	MOV		2(SP),R4				;Restore dCx value from stack without removing it
			ADD		R8,R4					;R4 = X+dCx+dy
			ADD		R7,R4
			MOV		@SP,R6					;Also restore dCy from stack without removing it
			ADD		R9,R6					;R6 = Y+dCy+dx
			ADD		R5,R6
			RRC.B	R11						;Carry flag contains the next OctalPlot flag
			JC		OP_SkipRP				; OP_RIGHTPLUS
			CALL	#Plot					;Plot(X+dCx+dy,Y+dCy+dx)
OP_SkipRP:	MOV		R8,R4					;R4 = X-dy
			SUB		R7,R4
			RRC.B	R11						;Carry contains the next OctalPlot flag
			JC		OP_SkipLP				; OP_LEFTPLUS
			CALL	#Plot					;Plot(X-dy,Y+dCy+dx)
OP_SkipLP:	MOV		R9,R6					;R6 = Y-dx
			SUB		R5,R6
			RRC.B	R11						;Carry Flag contains the next flag
			JC		OP_SkipLM				; OP_LEFTMINUS
			CALL	#Plot					;Plot(X-dy,Y-dx)
OP_SkipLM:	MOV		2(SP),R4				;Restore dCx value from stack without removing it
			ADD		R8,R4					;R4 = X+dCx+dy
			ADD		R7,R4
			RRC.B	R11						;Carry contains the next OctalPlot flag
			JC		OP_SkipRM				; OP_RIGHTMINUS
			CALL	#Plot					;Plot(X+dCx+dy,Y-dx)
OP_SkipQd:
OP_SkipRM:	POP		R6						;Restore R6
			POP		R4						;Restore R4
			POP		R11						;Restore R11
			RET
;-------------------------------------------

DrawArcs:
; Draws an arc of 90 degrees. The algorythm uses a modified middle point algorythm:
;	dx=0; dy=R; d=5-4*R;
;	dA=12; dB=20-8*R;
;	while (dx<dy)
;		plot(X+dx,Y+dy);
;		if(d<0)
;			d=d+dA; dB=dB+8;
;		else
;			dy=dy-1;
;			d=d+dB; dB=dB+16;
;		end if
;		dx=dx+1; dA=dA+8;
;	end while
;
; Input:				R4:	dCx value for moving the right part of the arcs right
;						R6: dCy value for moving the bottom part of the arcs down
;						R8: X Axis of the centre
;						R9: Y Axis of the centre
;						R10: Radius of the circle
;						R11: Flag for the 8 parts of the circle to be skipped drawing
;						R15: Colour of the circle
;						Carry Flag: 0 => Do not disable the LCD CS after reading
;							1 => Disable the LCD CS after reading
; Output:				None
; Registers Used:		R4, R5, R6, R7, R8, R9, R10, R11
;						R12: d
;						R13: dA
;						R14: dB
; Registers Altered:	R12, R13, R14
; Stack Usage:			12 total (2 bytes for storing flags, 2 bytes for Call and 8 bytes in
;						OctaPlot)
; Depend On Defs:		LCD_CS, LCDCtrl
; Depend On Vars:		None
; Depend On Funcs:		OctaPlot
			PUSH	SR						;Need to store Carry Flag
			MOV		#000h,R5				;Starting dx = 0
			MOV		R10,R7					;Starting dy = In(R) (bottom pixel)
			MOV		R10,R13					;dA = In(R) * 4, dA is used as a temporary value
			ADD		R13,R13
			ADD		R13,R13
			MOV.B	#005h,R12				;d = 5 - In(R) * 4
			SUB		R13,R12
			ADD		R13,R13					;dA = In(R) * 8, again as temporary value
			MOV.B	#014h,R14				;dB = 20 - 8 * In(R)
			SUB		R13,R14
			MOV.B	#00Ch,R13				;dA = 12, its final value
DAs_Loop:
			CLRC
			CALL	#OctaPlot				;Plot eight plots of the circle
			CMP		#000h,R12				;Going to test if d is negative
			JN		DAs_dN					;Yes => DAs_dN
			DEC		R7						;dy = dy -1
			ADD		R14,R12					;d = d + dB
			ADD		#00010h,R14				;dB = dB +16
			JMP		DAs_Cont				;Continue to process for next pixel
DAs_dN:		ADD		R13,R12					;d = d + dA
			ADD		#00008h,R14				;dB = dB +8
DAs_Cont:	INC		R5						;dx = dx +1
			ADD		#00008h,R13				;dA = dA +8
			CMP		R5,R7					;Compare dy and dx
			JGE		DAs_Loop				;if dx<=dy then repeat the loop for next pixels
			POP		SR						;Restore carry flag
			JNC		DAs_SkipCS				; decides wether to raise CS again or not
			BIS.B	#LCD_CS,&LCDCtrl		;Carry=1? => Disable LCD module bus.
DAs_SkipCS:	RET
;-------------------------------------------

SetTextWindow:
; Sets the region of the screen that a text will be printed
; Input:				R4:	Left border
;						R5: Right border
;						R6: Top border
;						R7: Bottom border
; Output:				Registers may be altered. Left must be less than right and top less
;						than bottom. Also, the margins must be inside the screen borders
; Registers Used:		R4...R7
; Registers Altered:	The register values are swapped if L>R or T>B and they are also
;						truncated to contain values inside the screen borders
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		CurXPos, CurYPos, LCDMaxX, LCDMaxY, TxtWinB, TxtWinL, TxtWinR, TxtWinT
; Depend On Funcs:		None
			CMP		R4,R5					;Is left less than right margin?
			JGE		STW_LROK				;Yes => Nothing to do
			XOR		R4,R5					;else, swap left with right value
			XOR		R5,R4
			XOR		R4,R5
STW_LROK:	MOV		#00000h,&TxtWinL		;Lets assume that left should be 0
			CMP		#00000h,R4				;This is valid if left margin is negative (or 0)
			JN		STW_LSetOK				;Negative? => then we correctly set it as 0
			MOV		&LCDMaxX,&TxtWinL		;else, lets assume that it should be maximum
			CMP		R4,&LCDMaxX				;Is the left value out of bounds?
			JL		STW_LSetOK				;Yes => then we correctly set it to maximum
			MOV		R4,&TxtWinL				;else, set the specified value
STW_LSetOK:	MOV		&TxtWinL,R4				;Reset R4 to the normalised value
			MOV		R4,&CurXPos				;Also set the cursor position to the left border
											; of the new window
			MOV		#00000h,&TxtWinR		;Same tactics we use for setting the right value
			CMP		#00000h,R5
			JN		STW_RSetOK
			MOV		&LCDMaxX,&TxtWinR
			CMP		R5,&LCDMaxX
			JL		STW_RSetOK
			MOV		R5,&TxtWinR
STW_RSetOK:	MOV		&TxtWinR,R5

			CMP		R6,R7					;Is top value less than bottom?
			JGE		STW_TBOK				;Yes => Use them as they are
			XOR		R6,R7					;else, swap these values
			XOR		R7,R6
			XOR		R6,R7
STW_TBOK:	MOV		#00000h,&TxtWinT		;Use the same idea we used earlier to set the top
			CMP		#00000h,R6
			JN		STW_TSetOK
			MOV		&LCDMaxY,&TxtWinT
			CMP		R6,&LCDMaxY
			JL		STW_TSetOK
			MOV		R6,&TxtWinT
STW_TSetOK:	MOV		&TxtWinT,R6
			MOV		R6,&CurYPos				;Also set the top position of the text cursor to
											; be at the top of the new text window
			MOV		#00000h,&TxtWinB		;... and bottom values of the text box
			CMP		#00000h,R7
			JN		STW_BSetOK
			MOV		&LCDMaxY,&TxtWinB
			CMP		R7,&LCDMaxY
			JL		STW_BSetOK
			MOV		R7,&TxtWinB
STW_BSetOK:	MOV		&TxtWinB,R7
			RET
;-------------------------------------------

GetTextWindow:
; Gets the selected region of the screen that a text can be printed
; Input:				None
; Output:				R4:	Left border
;						R5: Right border
;						R6: Top border
;						R7: Bottom border
; Registers Used:		R4, R5, R6, R7
; Registers Altered:	R4, R5, R6, R7
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		TxtWinB, TxtWinL, TxtWinR, TxtWinT
; Depend On Funcs:		None
			MOV		&TxtWinL,R4				;Get the left border of the text region
			MOV		&TxtWinR,R5				;Get the right border of the text region
			MOV		&TxtWinT,R6				;Get the top border of the text region
			MOV		&TxtWinB,R7				;Get the bottom border of the text region
			RET
;-------------------------------------------

SetTextRegion:
; Sets both the text area and the LCD Module's graphical region of the screen that a text will
; be printed
; Input:				R4:	Left border
;						R5: Right border
;						R6: Top border
;						R7: Bottom border
; Output:				None
; Registers Used:		R4, R5, R6, R7, R15
; Registers Altered:	The register values are swapped if L>R or T>B and they are also
;						truncated to contain values inside the screen borders
;						R15 -> Becomes equal to the maximum page set, No flags are
;							modified
; Stack Usage:			2 bytes
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		LCDSetRegion, SetTextWindow
			PUSH	SR						;Store SFRs (Carry flag needed)
			CALL	#SetTextWindow			;Normalise text area values
			POP		SR						;Restore carry flag from stack
			JMP		LCDSetRegion			;Set the LCD region to be used
;-------------------------------------------

SetBkGrnd:
; Sets the background colour for text printing
; Input:				R15: Colour
; Output:				None
; Registers Used:		R15
; Registers Altered:	None
;						No flags are modified
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		BkGrndClr
; Depend On Funcs:		None
			MOV		R15,&BkGrndClr
			RET
;-------------------------------------------

GetBkGrnd:
; Gets the background colour for text printing
; Input:				None
; Output:				R15 contains the colour
; Registers Used:		R15
; Registers Altered:	None
;						No flags are modified
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		BkGrndClr
; Depend On Funcs:		None
			MOV		&BkGrndClr,R15
			RET
;-------------------------------------------

SetFrGrnd:
; Sets the foreground colour for text printing
; Input:				R15: Colour
; Output:				None
; Registers Used:		R15
; Registers Altered:	None
;						No flags are modified
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		FrGrndClr
; Depend On Funcs:		None
			MOV		R15,&FrGrndClr
			RET
;-------------------------------------------

GetFrGrnd:
; Gets the foreground colour for text printing
; Input:				None
; Output:				R15: Colour
; Registers Used:		R15
; Registers Altered:	None
;						No flags are modified
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		FrGrndClr
; Depend On Funcs:		None
			MOV		&FrGrndClr,R15
			RET
;-------------------------------------------

SetTxtXRel:
; Sets the X position of the text cursor, relative to left text window border
; Input:				R4: X Position of top left pixel of character to be printed
; Output:				Carry Flag shows if the setting is correct:
;							0: The specified value was out of bounds and were truncated
;							1: X position is now the specified one
; Registers Used:		R4, R13, R14
; Registers Altered:	R4 contains the normalised absolute X position set
;						R13 points to the current font's structure
;						R14 containst the minimum or maximum absolute valid value of X axis
; Stack Usage:			None
; Depend On Defs:		FTbl_WIDTH
; Depend On Vars:		CurFontPtr, CurXPos, TxtWinL, TxtWinR
; Depend On Funcs:		None
			ADD		&TxtWinL,R4				;Add the left text window border
;			JMP		SetTxtXPos				;No need to execute this Jump, SetTxtXPos follows
;-------------------------------------------

SetTxtXPos:
; Sets the absolute X position of the text cursor
; Input:				R4: X Position of top left pixel of character to be printed
; Output:				Carry Flag shows if the setting is correct:
;							0: The specified value was out of bounds and was truncated
;							1: X position is now the specified one
; Registers Used:		R4, R13, R14
; Registers Altered:	R4 contains the X position set (may be normalised)
;						R13 points to the current font's structure
;						R14 containst the minimum or maximum valid value of X axis
; Stack Usage:			None
; Depend On Defs:		FTbl_WIDTH
; Depend On Vars:		CurFontPtr, CurXPos, TxtWinL, TxtWinR
; Depend On Funcs:		None
			MOV		&TxtWinL,R14			;Get the lower valid value of X axis
			CMP		R14,R4					;Is the input value less than that?
			JLO		SXP_SetNew				;Yes => Set it to the valid one
			MOV		&TxtWinR,R14			;Get the maximum valid value of X axis
			MOV		&CurFontPtr,R13			;R13 points to the current font's structure
			SUB		FTbl_WIDTH(R13),R14		;Subtract the width of each character
			INC		R14						;Maximum value can be one more because the width
											; of the character contains both starting and
											; ending points
			CMP		R4,R14					;Is the new value out of bounds?
			JGE		SXP_Valid				;No => set it
SXP_SetNew:	CLRC							;else, Carry is cleared for truncation of value
			MOV		R14,R4					;Set it to the valid value
SXP_Valid:	MOV		R4,&CurXPos				;Store the value
			RET
;-------------------------------------------

GetTxtXPos:
; Gets the current absolute X position of the text cursor
; Input:				None
; Output:				R4 contains the X position
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		CurXPos
; Depend On Funcs:		None
			MOV		&CurXPos,R4
			RET
;-------------------------------------------

SetTxtYRel:
; Sets the Y position of the text cursor relative to top border of text window
; Input:				R6: Y Position of top left pixel of character to be printed
; Output:				Carry flag shows if the setting is valid:
;							0: Setting was invalid and truncated to the maximum valid value
;							1: Y position is set to the specified value
; Registers Used:		R6, R13, R14
; Registers Altered:	R6 contains the new Y axis value
;						R13 points to the current font's structure
;						R14 contains the maximum valid Y axis value
; Stack Usage:			None
; Depend On Defs:		FTbl_HEIGHT
; Depend On Vars:		CurFontPtr, CurYPos, LCDMaxY
; Depend On Funcs:		None
			ADD		&TxtWinT,R6				;Add the top border Y axis value
;			JMP		SetTxtYPos				;No need to execute this jump, SetTxtYPos follows
;-------------------------------------------

SetTxtYPos:
; Sets the Y position of the text cursor
; Input:				R6: Y Position of top left pixel of character to be printed
; Output:				Carry flag shows if the setting is valid:
;							0: Setting was invalid and truncated to the maximum valid value
;							1: Y position is set to the specified value
; Registers Used:		R6, R13, R14
; Registers Altered:	R6 contains the new Y axis value
;						R13 points to the current font's structure
;						R14 contains the maximum valid Y axis value
; Stack Usage:			None
; Depend On Defs:		FTbl_HEIGHT
; Depend On Vars:		CurFontPtr, CurYPos, LCDMaxY
; Depend On Funcs:		None
			MOV		&CurFontPtr,R13			;Get the pointer to current font's structure
			MOV		&TxtWinT,R14			;Get the minimum valid Y axis value
			CMP		R14,R6					;Is the input value less than the needed one?
			JLO		SYP_SetNew				;Yes => Set it to the valid one
			MOV		&TxtWinB,R14			;Get the maximum valid value of Y axis
			SUB		FTbl_HEIGHT(R13),R14	;Subtract the height of a character
			INC		R14						;Maximum value can be one more because the height
											; of the character contains both starting and
											; ending points
			CMP		R6,R14					;Is the new value out of bounds?
			JGE		SYP_Valid				;No => set it
SYP_SetNew:	CLRC							;else, Carry is cleared to signal the truncation
			MOV		R14,R6					;Set the maximum valid value
SYP_Valid:	MOV		R6,&CurYPos				;Store the new value of Y axis
			RET
;-------------------------------------------

GetTxtYPos:
; Gets the current absolute Y position of the text cursor
; Input:				None
; Output:				R6 contains the Y position
; Registers Used:		R6
; Registers Altered:	R6
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		CurYPos
; Depend On Funcs:		None
			MOV		&CurYPos,R4
			RET
;-------------------------------------------

GetTxtPos:
; Gets the current absolute coordinates of the text cursor
; Input:				None
; Output:				R4 contains the X position
;						R6 contains the Y position of the cursor
; Registers Used:		R4, R6
; Registers Altered:	R4, R6
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		CurXPos, CurYPos
; Depend On Funcs:		None
			MOV		&CurXPos,R4
			MOV		&CurYPos,R6
			RET
;-------------------------------------------

AdvanceCursor:
;Advances the text pointer to the next possible character
; Input:				R10 contains the character height
;						R11 contains the character width
; Output:				Carry flag shows the success of the cursor advancing:
;							0: No room left for text...
;							1: Cursor is advanced successfully
; Registers Used:		R4, R6, R10, R11 (and R13, R14 by other calls)
; Registers Altered:	R4, R6, contain the new X and Y absolute position of text cursor
;						R13 points to the current font's structure
;						R14 is altered
; Stack Usage:			2 bytes for Call
; Depend On Defs:		None
; Depend On Vars:		CurXPos, CurYPos
; Depend On Funcs:		SetTxtXPos, SetTxtXRel, SetTxtYPos
			MOV		&CurXPos,R4				;Get the current horizontal position of text
			ADD		R11,R4					; cursor and add the character's width
			CALL	#SetTxtXPos				;Try to set this position
			JC		ADVC_Exit				;If position set then exit
			MOV		#00000h,R4				;else, bring X position to the beginning of line
			CALL	#SetTxtXRel				;Set this relative position
			MOV		&CurYPos,R6				;Get the current vertical position of text cursor
			ADD		R10,R6					;Advance it by height
			CALL	#SetTxtYPos				;Try to set the position of the cursor
ADVC_Exit:	RET								;While exiting carry flag from previous call shows
											; if the position setting was done correctly
;-------------------------------------------

SetFont:
; Sets the current font to be used.
; Input:				R4: Index of font to be used
; Output:				None
; Registers Used:		R4
; Registers Altered:	R4 contains the address of font structure (in FontsTbl)
; Stack Usage:			None
; Depend On Defs:		DEFFONT, FTbl_MAXINDEX, FTbl_SIZE
; Depend On Vars:		CurFontIdx, CurFontPtr, FontsTbl
; Depend On Funcs:		None
			CMP		#000h,R4				;Is the index 0?
			JZ		SF_Zero					;Yes => No need for calculations
			CMP		#FTbl_MAXINDEX +1,R4	;else, is it a valid number?
			JLO		SF_Valid				;Yes => OK
			MOV		#DEFFONT,R4				;else set the index for the default font
SF_Valid:	MOV		R4,&CurFontIdx			;Store the current font's index
			PUSH	SR						;Store flags (We need GIE flag)
			DINT							;Disable interrupts
			MOV		R4,&MPY					;Need to multiply it by...
			MOV		#FTbl_SIZE,&OP2			;... the size of each entry in FontsTbl
			MOV		&RESLO,R4				;The result of the multiplication...
			POP		SR						;(Restore interrupts)
			ADD		#FontsTbl,R4			;... is added to the beginning of FontsTbl
			MOV		R4,&CurFontPtr			;... and the address is stored in Current Font's
											; pointer
			RET

SF_Zero:	MOV		#000h,&CurFontIdx		;Index to be used is 0
			MOV		#FontsTbl,&CurFontPtr	;Pointer of current font's structure is at the
											; beginning of FontsTbl
			RET
;-------------------------------------------

GetFont:
; Gets the currently selected font for text printing.
; Input:				None
; Output:				R4
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		CurFontIdx
; Depend On Funcs:		None
			MOV		&CurFontIdx,R4
			RET
;-------------------------------------------

SetPropFont:
;Makes use of a font as proportional
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		FONT_PROPORTIONAL
; Depend On Vars:		FontProps
; Depend On Funcs:		None
			BIS		#FONT_PROPORTIONAL,&FontProps
											;Set the Proportional flag in Font properties
			RET
;-------------------------------------------

GetPropFont:
;Makes use of a font as proportional
; Input:				None
; Output:				Carry flag is set if proportional font is in use, else cleared
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		FONT_PROPORTIONAL
; Depend On Vars:		FontProps
; Depend On Funcs:		None
			BIT		#FONT_PROPORTIONAL,&FontProps
											;Get the Proportional flag status in Font
											; properties
			RET
;-------------------------------------------

SetFixedFont:
;Makes use of a font as fixed size
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		FONT_PROPORTIONAL
; Depend On Vars:		FontProps
; Depend On Funcs:		None
			BIC		#FONT_PROPORTIONAL,&FontProps
											;Set the Proportional flag in Font properties
			RET
;-------------------------------------------

PrintChr:
; Prints a character at the current text cursor position using the selected font
; Input:				R4: Contains the character to be printed on screen
; Output:				Carry flag shows if there was an error (like not supported character)
;						Zero flag shows if there is the need to make space on screen for the
;						next character (after crossing the bounds of screen)
; Registers Used:		R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15
; Registers Altered:	All registers are altered.
; Stack Usage:			Maximum 6 bytes (2 for Push, 2 for call LCDSetRegion and 2 by
;						LCDSetRegion itself)
; Depend On Defs:		FONT_0A, FONT_0D, FONT_PROPORTIONAL, FTbl_GLEN, FTbl_HEIGHT,
;						FTbl_MAXCHAR, FTbl_MINCHAR, FTbl_PROP, FTbl_WIDTH, LCD_CS, LCD_DC,
;						LCD_WR
; Depend On Vars:		BkGrndClr, CurFontPtr, CurXPos, CurYPos, FontProps, FrGrndClr,
;						ImgBuffer, LCDCtrl, LCDDataH, LCDDataL
; Depend On Funcs:		AdvanceCursor, LCDSetRegion, LCDStartData, WriteLCDData
			MOV		&CurFontPtr,R13			;R13 points to the current font's info structure
			CMP		FTbl_MINCHAR(R13),R4	;Is it below the first valid character of the set?
			JL		PC_CheckCmd				;Yes => Check if this is a known ASCII command
			BIC		#FONT_0A+FONT_0D+FONT_FORCEDY,&FontProps
											;Last character used is not one of 0A or 0D, so
											; clear these flags
			CMP		FTbl_MAXCHAR(R13),R4	;Is it out of bounds?
			JHS		PC_Invalid				;Yes => Then invalid. Just exit (Carry flag is 1)
			SUB		FTbl_MINCHAR(R13),R4	;Normalise it (0 is the first available character
											; by the selected font)
			MOV		FTbl_HEIGHT(R13),R10	;Get the height of the character
			MOV		FTbl_WIDTH(R13),R11		;Get the width of the character to be printed
			CMPX.A	#00000h,FTbl_PROP(R13)	;Is there proportional table for the font?
			JEQ		PC_NoProp				;No => Use it as fixed size font (Monospace)
			BIT		#FONT_PROPORTIONAL,&FontProps	;Do we need to use proportional font?
			JZ		PC_NoProp				;No => Use it as fixed size
			MOVA	FTbl_PROP(R13),R11		;Get the address of the proportional char widths
			ADDA	R4,R11					;Add the character offset...
			ADDA	R4,R11					;... twice because proportional data are 2 bytes
			MOVX.W	@R11,R11				;Get the proportional left/width of the character
			SWPB	R11						;Swap the bytes to bring glyph width at LSB

PC_NoProp:	MOV.B	R11,R8					;Clear the left border data
			PUSH	R4						;Need to use R4 later, so push it to stack
			MOV		&CurXPos,R4				;Get current X position
			MOV		&CurYPos,R6				;Get current Y position
			MOV		R4,R5					;Ending X position of the rectangle to be used...
			ADD		R8,R5					;... must be WIDTH -1 pixels right
			DEC		R5						;This is the -1 of the previous calculation
			MOV		R6,R7					;Ending Y position of the rectangle to be used...
			ADD		R10,R7					;... for the character is HEIGHT -1 pixels down
			DEC		R7						;Again, the -1 of the previous calculation
			CLRC
			CALL	#LCDSetRegion			;Set the region that we will draw
			POP		R4						;Restore the char code in character set to be
											; printed

			;Buffer preparation. The buffer must hold tha data of the character
			PUSH	SR						;Store the interrupts state
			DINT							;Multiplier must stay unaffected, so disable ints
			MOV		R4,&MPY					;The normalised value must be multiplied by
			MOV		FTbl_GLEN(R13),&OP2		; the number of bytes a character glyph is formed
			MOV		&RESLO,R14				;This is the offset of the first byte of the
											; needed character, in the font area
			POP		SR						;Restore interrupts to their previous state
			ADDX.A	@R13,R14				;Add the starting address of the font and R14
											; now points to the address that contains the
											; character's data
			;Time to copy character's data into Image Buffer. Register contents are:
			;R10 contains the height of the character in pixels
			;R11 contains the proportional data (left:width) of the character in pixels
			;R13 points to the font's information structure
			;R14 points to the character data to be printed
			MOV.B	R11,R8					;Get the width of the glyph
			PUSH	SR						;Must keep the state of interrupts
			DINT							;Disable them to keep multiplier unaffected
			MOV		R10,&MPY				;Multiply height times ...
			MOV		R8,&OP2					;... width to find out ...
			MOV		&RESLO,R15				;... the number of pixels needed for this glyph
			POP		SR						;Restore interrupts state
			RRAM.W	#3,R15					;Devide by 16 to find out the number of words
			ADD		#ImgBuffer+4,R15		;in the Image Buffer
			BIC		#BIT0,R15				;Word align it
PC_ClrBuf:	MOV		#00000h,0(R15)			;Reset a word
			DECD	R15						;Previous word to target
			CMP		#ImgBuffer,R15			;Passed the ImgBuffer?
			JHS		PC_ClrBuf				;No => Keep clearing words

			MOV		#00000h,R15				;Offset in Image buffer in pixels
			MOV		FTbl_WIDTH(R13),R7		;Get the in memory width of the glyph
			DEC		R7						;Index of pixels from 0
			RRAM.W	#3,R7					;This is the number of bytes needed (Pixels/8)
			INC		R7						;One more byte for spare bits
PC_NextLine:
			MOV.B	R11,R12					;R12 contains the width of the character left to
											; store in buffer
			MOV		R7,R5					;R5 Temporarilly stores the number of bytes needed
			
			BIT		#FONT_PROPORTIONAL,&FontProps	;Do we need to use proportional font?
			JZ		PC_NoLBrdr				;No => Use it as fixed size
			MOV		R11,R8
			SWPB	R8						;Get the number of bits of the glyph's left border
			MOV.B	R8,R8					;Keep only the lower part (left border)
			CMP		#00000h,R8				;Is it 0?
			JZ		PC_NoLBrdr				;Yes => No need to skip the glyph's left border
			ADD		R8,R12					;Now we must use the character's width+left_border
			SUB		R8,R15					;The space is printed earlier
PC_MoreL:	CMP		#-7,R15					;Is the pointer more than one bytes away?
			JGE		PC_NoLBrdr				;No => OK, keep with the character data
			INCX.A	R14						;Skip one character byte
			DEC		R5						;One byte less to read
			SUB		#00008h,R12				;8 bits less width
			ADD		#00008h,R15				;Add those 8 bits we skipped
			JMP		PC_MoreL				;Repeat
PC_NoLBrdr:
PC_NextByte:
			MOVX.B	@R14+,R9				;Get one byte of the character to be printed
											; and advance the pointer
			DEC		R5						;One byte less to read
			
PC_NoSkipL:	MOV		R15,R8					;Get the counter of the bits used
			AND.B	#007h,R8				;Filter only the bits in a byte
			JZ		PC_BitsOK				;No bits used => there is no need to normalise the
											; value, just store the new value (also erases the
											; rest of the unused bits)
			SWPB	R9						;else, Swap the bytes to bring the manipulated one
											; to MSB
PC_ReShift:	CLRC							;Carry must be cleared
			RRC		R9						;Shift right the byte
			DEC		R8						;This must be done as many times as the used bits
			JNZ		PC_ReShift				;Repeat until all times have been processed
			;If this is the first byte of a line and there is left border in proportional mode
			; then the first byte contains only the border that should not be used! By default
			;the lower byte contains the main data of the character, while the higher byte MAY
			; contain more data
			MOV		R15,R8					;Need to filter the offset in bytes, so get the...
			RRAM.W	#003h,R8				;... pixel offset and devide it by 8
			BIS.B	R9,ImgBuffer+1(R8)		;Store the lower byte to the buffer (lower bits
											; go to the next byte in Image buffer)
			JN		PC_AdvImgPtr			;If R15 is negative, then skip writing to it
			SWPB	R9						;Prepare the higher byte to be stored
			BIS.B	R9,ImgBuffer(R8)		;Store it to the next byte (Only set its bits as
											; they may coexist with previous data in the same
											; byte)
PC_AdvImgPtr:
			CMP		#00009h,R12				;Is the width of the character more than one byte?
			JL		PC_SubWidth				;No => then sub the width of the character
			ADD		#00008h,R15				;else, increment the pixel pointer by one byte
			SUB		#00008h,R12				;8 bits less from the width of the character
			JMP		PC_NextByte				;The current line of the character is not complete
											; so repeat the "transfer character data" process
			;If the bits to be stored form a whole byte in image buffer then we need to store
			; it without shifting right
PC_BitsOK:	MOV		R15,R8					;Need to filter the offset in bytes, so get the...
			RRAM.W	#003h,R8				;..,. pixel offset and devide it by 8
			JN		PC_AdvImgPtr			;Negative pixel in buffer? => Skip storage
			BIS.B	R9,ImgBuffer(R8)		;Store the whole byte
			JMP		PC_AdvImgPtr			;Proceed to advancing the image pixel pointer...

			;If the pixels stored are less than a byte, we have a complete line. So, advance
			; the pixel pointer for Image Buffer and count out the completed line. Proceed
			; until the complete character is copied to the buffer
PC_SubWidth:
			ADD		R12,R15					;Advance the pixel pointer as many bits as the
											; character width specifies. The line of the
											; character to be printed is transfered!
			ADDX.A	R5,R14					;Skip the rest of the bytes of the glyph's line
PC_NoExtB:	DEC		R10						;One line less
			JNZ		PC_NextLine				;More lines to copy? => Repeat
			
			;Now the Image buffer contains the pixels that form the character glyph to be
			; printed. Finally the data must be drawn on screen. Register contents are now:
			;R10 contains the height of the character in pixels
			;R11 contains the width of the character in pixels
			;R13 points to the font's information structure
PC_ImgPrint:
			CALL	#LCDStartData			;Need to start writing data to the LCD module
			MOV		&BkGrndClr,R15			;R15 contains the colour to be used. Starting with
											; the colour of the background
			MOV.B	R15,&LCDDataL			;Set the colour at the LCD data ports
			SWPB	R15
			MOV.B	R15,&LCDDataH
			SWPB	R15
			BIS.B	#LCD_DC,&LCDCtrl		;Next pulses are for data
			MOV		&FrGrndClr,R14			;R14 contains the foreground colour
			XOR		R15,R14					;Now R14 contains the Xored value of the colour
											;Every time we move from background to foreground
											; pixel, we XOR the current colour with this value
											; and the colour value to LCD is exchanged
			MOV		FTbl_HEIGHT(R13),R10	;Get the height of the character
			MOV.B	R11,R11					;Get only the width of the character
			PUSH	SR						;Need to keep the state of interrupts
			DINT							;Disable interrupts to leave MPY alone
			MOV		R10,&MPY				;Going to multiply character height...
			MOV		R11,&OP2					;... by character width, to find out the...
			MOV		&RESLO,R12				;... number of pixels to send to the LCD
			POP		SR						;Restore interrupts to their previous state
			MOV.B	#000h,R4				;Flag that data contain background colour
			MOV		#ImgBuffer,R9			;R9 points to the buffer
PCP_NextByte:
			MOV.B	@R9+,R5					;R5 contains the byte to be send (8 pixels)
											; The leftmost pixel is the first to be sent
			MOV		#008h,R6				;Counter of bits in the byte
PCP_ReByte:	MOV		#000h,R7				;R7 is going to be used for previous and next
											; pixel colour, in order to 
			RLC.B	R5						;Leftmost bit goes to Carry flag
			RLC.B	R7						;Get the bit as a value. R7 contains 0 if the bit
											; is a background one, or 1 if the bit to be sent
											; is a foreground bit
			CMP		R4,R7					;Is the last colour used the same as the current
											; pixel's?
			JEQ		PCP_NoColour			;Yes => Just pulse CS
			XOR		R14,R15					;else, swap colours
			MOV		R7,R4					;Set the value of the last printed pixel
			CALL	#WriteLCDData			;Sends a pixel of the defined colour to the LCD
PCP_Cont:	DEC		R12						;One bit less from the total image
			CLRC
			JZ		PCP_Exit				;No more pixels? => Exit
			DEC		R6						;One bit less in this byte
			JNZ		PCP_ReByte				;More bits in this byte? => Stay in the same byte
			JMP		PCP_NextByte			;else, proceed to next byte in image buffer
PCP_NoColour:
			BIC.B	#LCD_WR+LCD_CS,&LCDCtrl	;Lower CS and WR to prepare sending
			BIS.B	#LCD_WR,&LCDCtrl		;Raise it again to send the pixel colour to LCD
			JMP		PCP_Cont
PCP_Exit:
			CALL	#AdvanceCursor			;Text cursor now goes one character left
			JC		PC_Invalid				;Cursor normally advanced? => Just exit
			BIS		#FONT_FORCEDY,&FontProps;else, Flag that we are forced in screen
			SETZ							;Screen is out of bounds
			CLRC							;Normal character manipulated
			RET

PC_Invalid:	CLRC							;Normal character manipulated
			CLRZ							;Zero flag is also reset (No need to make space on
											; screen)
			RET

;The rest of the function is for manipulating ASCII command characters, such as Newline, or
;(later) Escape sequences
PC_CheckCmd:
			CMP.B	#00Ah,R4				;Check if the command byte is 0Ah
			JEQ		PCC_Check0A				;Yes => need to check if it belongs to a newline
											; sequence
			CMP.B	#00Dh,R4				;Check if the command byte is 0Dh
			JEQ		PCC_Check0D				;Yes => need to check if it belongs to a newline
											; sequence
			BIC		#FONT_0A+FONT_0D,&FontProps
											;Last character is not one of CR/LF
			SETC							;Flag this is not supported character
			RET
PCC_Check0A:
			BIT		#FONT_0D,&FontProps		;Was the previous character 0Dh?
			BIS		#FONT_0A,&FontProps		;Set the flag for 0A char
			JZ		PCC_NewLine				;No => then execute New line
											;else, clear both flags and exit, new line was
											; executed earlier (Carry flag is 0)
			BIC		#FONT_0A+FONT_0D,&FontProps
			CLRZ							;Zero flag is also reset (No need to make space on
											; screen)
			RET
PCC_Check0D:
			BIT		#FONT_0A,&FontProps		;Was the previous character 0Ah?
			BIS		#FONT_0D,&FontProps		;Set the flag for this 0Dh
			JZ		PCC_NewLine				;No => Execute the new line command
											;else, clear both flags and exit, new line was
											; executed earlier (Carry flag is 0)
			BIC		#FONT_0A+FONT_0D,&FontProps
			CLRZ							;Zero flag is also reset (No need to make space on
											; screen)
			RET
PCC_NewLine:
			MOV		&TxtWinL,&CurXPos		;Position the cursor at the beginning of line
			MOV		&CurYPos,R6				;Get current Y cursor position
			ADD		FTbl_HEIGHT(R13),R6		;Add the height of the glyphs
			MOV		&TxtWinB,R7				;Get the maximum value. The maximum Y position of
			SUB		FTbl_HEIGHT(R13),R7		;cursor must be one height less, to be able to
											;contain a character
			INC		R7						;Bottom is included in the chracter height
			CMP		R6,R7					;Compare these values to see if it is true
			JL		PCC_NoSetY				;Passed the valid Y point? => Do not set Y axis
			MOV		R6,&CurYPos				;else, set the new Y value
			CLRC							;Just used a valid character/command
			CLRZ							;No need to make more space on screen for the next
											; character
			RET

PCC_NoSetY:	;Carry flag is cleared (JL command ensures it)
			BIS		#FONT_FORCEDY,&FontProps;Flag the cursor forced in screen
			SETZ							;Zero flag is raised to express the need of making
											; space n screen for the next character
			RET
;-------------------------------------------

GetEndOfScreen:
;Gets the last status of Forced Y bit from last character printing
; Input:				None
; Output:				Carry flag is set if there was a Forced_Y flag, else cleared
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		FONT_FORCEDY
; Depend On Vars:		FontProps
; Depend On Funcs:		None
			BIT		#FONT_FORCEDY,&FontProps
			RET
;-------------------------------------------

PrintStr:
;Prints a whole string
; Input:				R5 points to the string to be printed. The string must be ASCIIZ
; Output:				None
; Registers Used:		R4, R5, all others by PrintChr
; Registers Altered:	All, R5 points just after the terminating zero of the string
; Stack Usage:			8 (2 bytes for Call and 6 bytes by PrintChr)
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		PrintChr
PS_NextChr:	MOV.B	@R5+,R4					;Get one character to print
			CMP.B	#000h,R4				;Is it the terminating one?
			JEQ		PS_Exit					;Yes => exit
			PUSH	R5						;Need to keep the pointer unaffected
			CALL	#PrintChr				;Print this character
			POP		R5						;Restore the pointer
			JMP		PS_NextChr				;Repeat for all characters in string
PS_Exit:	RET
;-------------------------------------------

CalcFont:
;Calculates the proportional data of the currently selected font. The data are stored in
; ImgBuffer and their length is given by R4 register on output. For the data to be used a
; breakpoint must be specified at the end of this function. When the processor stops, data
; stored in ImgBuffer can be saved, manipulated and inserted in font's data.
; @NOTE: This is a helper function and not usable in the final product
; Input:				None
; Output:				R4 contains the length of data written in ImgBuffer
; Registers Used:		All
; Registers Altered:	All
; Stack Usage:			None
; Depend On Defs:		FTbl_ADDR, FTbl_HEIGHT, FTbl_MAXCHAR, FTbl_MINCHAR, FTbl_WIDTH
; Depend On Vars:		CurFontPtr, ImgBuffer
; Depend On Funcs:		None
			MOV		#00000h,R4				;Target offset that will store the calculations
			MOV		&CurFontPtr,R6			;Pointer to the font info structure
			MOV		FTbl_WIDTH(R6),R7		;Width of a character in pixels
			DEC		R7						;The width in bytes is [(WIDTH-1)/8]+1
			RRA		R7
			RRA		R7
			RRA		R7
			INC		R7
			MOV		FTbl_MAXCHAR(R6),R9		;Maximum character supported by this font
			SUB		FTbl_MINCHAR(R6),R9
;			INC		R9						;R9 contains the number of characters in this font
			;In the fonts information table the INC is done for the maximum character number,
			; so we must not execute it

			MOVX.A	FTbl_ADDR(R6),R10		;Address that the font data appear in Flash
CF_NxtGlph:	MOV		#00000h,R11				;Offset in buffer for Image data
			MOV		FTbl_HEIGHT(R6),R8		;Height of the character in pixels
			MOV		R7,R12					;Temprary width in bytes
CF_ClrNext:	MOV.B	#000000h,ImgBuffer+512(R11)	;Clear one byte
			INC		R11						;Next byte
			DEC		R12						;One byte less
			JNZ		CF_ClrNext				;Repeat for all bytes
CF_CpyLine:	MOV		R7,R12					;Temporary width of the character
			MOV		#00000h,R11				;Offset in buffer
CF_CpyNext:	BISX.B	@R10+,ImgBuffer+512(R11);Logic OR this value (and advance source pointer)
			INC		R11						;Next offset
			DEC		R12						;One byte less
			JNZ		CF_CpyNext				;Repeat for all bytes
			DEC		R8						;One row less
			JNZ		CF_CpyLine				;Repeat for all rows

			MOV		#00000h,R12				;Number of zeroed bits at the left of the glyph
											; bits to check...
CF_NxtLeft:	MOV		R7,R11					;Must rotate left, so start from the last byte
			MOV		#00000h,R5				;Temprary storage of the last flag
CF_RLBytes:	DEC		R11						;Offset in buffer (one less than the length)
			RRC.B	R5						;Carry flag is at the beginning 0 and the rest of
											; the itterations it takes the last rotated value
			RLC.B	ImgBuffer+512(R11)		;Rotate left one byte
			RLC.B	R5						;Store the leftmost bit (Carry flag) to R5 LSb
			CMP		#00000h,R11				;All bytes shifted left?
			JNZ		CF_RLBytes				;Repeat for all bytes
			CMP		#00000h,R5				;Last rotated carry is 1?
			JNZ		CF_LeftOK				;Yes => then left zeroed bits are counted
			INC		R12						;One more zero bit at the left border of the glyph
			CMP		FTbl_WIDTH(R6),R12		;Did we reach the end of glyph?
			JNE		CF_NxtLeft				;No => Repeat

CF_LeftOK:	MOV.B	#000h,R13				;Flag for decrement of left border
			CMP.B	#000h,R12				;Did we find any left border?
			JEQ		CF_StoreL				;No => OK, store this value
			DEC.B	R12						;else, decrement by one to have a small left space
			INC.B	R13						;We need to add that space to the total width later
CF_StoreL:	MOV.B	R12,ImgBuffer(R4)		;Store the value of left border of the character
			INC		R4						;Advance the pointer

			MOV		R7,R12					;Get the number of bytes used for the glyph
			RLA		R12						;Number of bits are 8 times the bytes
			RLA		R12
			RLA		R12
			INC		R12						;Plus 1 for the last carry flag pushed out during
			; the previous operation. It holds one bit of the character that may be 1...

CF_NxtRght:	MOV		#00000h,R11				;Pointer to the first byte of the character
			CLRC							;First, R5 holds the MSb of the previous rotation
CF_RRBytes:	RRC.B	R5						;Last Carry value from temporary storage to Flag
			RRC.B	ImgBuffer+512(R11)		;Rotate right one byte
			RLC.B	R5						;Insert carry flag into R5 (LSb)
			INC		R11						;Advance the pointer to the next byte
			CMP		R7,R11					;Did it reach the end of glyph?
			JNE		CF_RRBytes				;No => repeat rotation for all bytes
			CMP		#00000h,R5				;Do we have 1 at the most right part of glyph?
			JNE		CF_RightOK				;Yes => Found the width of the character
			DEC		R12						;One bit less in width of character
			JNZ		CF_NxtRght				;More bits in character glyph? => Repeat

CF_RightOK:	ADD.B	R13,R12					;Add the possible width change of the left border
											; to include it in the total width of the glyph
			INC.B	R12						;Add 1 more bit for right space in glyph
			CMP.B	FTbl_WIDTH(R6),R12		;Is the width found at its maximum?
			JL		CF_StoreW				;No =< OK, store this value as width
			MOV		FTbl_WIDTH(R6),R12		;else use the maximum width
CF_StoreW:	MOV.B	R12,ImgBuffer(R4)		;Store the width found
			INC		R4						; and advance pointer

			DEC		R9						;More glyphs to check?
			JNZ		CF_NxtGlph				;Yes => repeat for all glyphs
			RET
;-------------------------------------------

LCDBackLightOn:
; Lights up the LCD backlight at full luminocity, without using the timer
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		LCD_BL, LCDBLDIR, LCDBLOUT, LCDBLSEL
; Depend On Vars:		None
; Depend On Funcs:		None
			BIS.B	#LCD_BL,&LCDBLOUT		;Going to set the control pin for the backlight
;			BIS.B	#LCD_BL,&LCDBLDIR		;Going to use this pin as simple output
			BIC.B	#LCD_BL,&LCDBLSEL		;Do not use it as a special function
			RET
;-------------------------------------------

LCDBackLightOff:
; Turns off the backlight of the LCD module, without using the timer
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		LCD_BL, LCDBLDIR, LCDBLOUT, LCDBLSEL
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			BIC.B	#LCD_BL,&LCDBLOUT		;Going to reset the backlight control pin
;			BIS.B	#LCD_BL,&LCDBLDIR		;Going to use this pin as simple output
			BIC.B	#LCD_BL,&LCDBLSEL		;Do not use it as a special function
			RET
;-------------------------------------------

LCDBackLightPWM:
; Enables the backlight control using the associated timer module.
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		BLCCTL, LCD_BL, LCDBLDIR, LCDBLSEL
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			BIS.B	#LCD_BL,&LCDBLDIR		;This pin must be used as an output
			BIS.B	#LCD_BL,&LCDBLSEL		;This pin must be used as a special function
			MOV.W	#CCIS_2+OUTMOD_7,&BLCCTL;Setup Capture/Compare control register for using
											; output mode 7 (Reset/Set) = Resets on BLCCR,
											; Sets on BLCCR0.
			RET
;-------------------------------------------

LCDBackLightSet:
; Sets the willing level of backlight illumination
; Input:				R4 contains the final value of backlight level
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		BLCCTL, DEFBLSTEP
; Depend On Vars:		BLCounter, BLCurVal, BLMaxCntr, BLMaxVal, BLStep
; Depend On Constants:	None
; Depend On Funcs:		None
			MOV		R4,&BLMaxVal			;Set the needed value
			MOV		#DEFBLSTEP,&BLStep		;Set positive step value
			CMP		&BLCurVal,R4			;Greater, Less, Equal?
			JZ		BLSExit					;Equal => Nothing to do
			JHS		BLSPosStep				;Greater => use positive step value
			MOV		#-DEFBLSTEP,&BLStep		;Use the negative value of default PWM step
BLSPosStep:	MOV		&BLMaxCntr,&BLCounter	;Set the initial PWM step delay
			BIC		#CCIFG,&BLCCTL			;Clear any pending interrupt of Capture/Compare
			BIS		#CCIE,&BLCCTL			;Enable the interrupt for backlight PWM transition
BLSExit:	RET
;-------------------------------------------

ScrollTextUp:
; Copies what is printed on screen on text area from the second line to bottom of text area,
; to first line and down
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			BIC		#READLAST,&LCDFlags		;Reset the flag for last read block
			CALL	#Text2Region			;Select the whole text region on LCD Module
			MOV		R7,R8					;Get a copy of bottom border
			MOV		&CurFontPtr,R13			;Get the pointer to font properties
			SUB		FTbl_HEIGHT(R13),R8		;Reach one character line before (last graphical
											; line of the character line before last)
			INC		R8						;Points to the first graphical line of the last
											; character line
			SUB		R6,R8					;Subtract the top graphical line to find the
											; number of graphical lines between
			MOV		R5,R9					;Get the right border
			SUB		R4,R9					;Subtract the left border to find the number of
											; pixels per line
			INC		R9						;Well, ending pixel included
			PUSH	SR						;Store interrupts status
			DINT							;No one should alter multiplier
			MOV		R8,&MPY					;Going to multiply lines times...
			MOV		R9,&OP2					;... columns
			MOV		&RESHI,R11				;R11:R10 is the pixel counter for movement
			MOV		&RESLO,R10
			POP		SR						;Restore interrupts
			CMP		FTbl_HEIGHT(R13),R8		;Must be at least one character line in height
			JL		ScrLastLine				;Only one character line in text area => Clear it

			CLRC
			CALL	#LCDStartData			;Issue a Write_Memory_Start command to LCD module
											; to set the write pointer to the beginning pixel
			ADD		FTbl_HEIGHT(R13),R6		;Top pixel of reading point is the second
											; character line
			CALL	#LCDSetRegion			;Select this region
			MOV.B	#02Eh,R15				;Going to issue a Read_Memory_Start command to set
			CLRC
			CALL	#WriteLCDCmd			; the starting pixel to LCD read pointer
			CALL	#ReadLCD				;Perform a dummy read (First read is dummy)
			MOV		#LCDBUFFLEN,R14			;Counter for buffer

			CMP		#00000h,R11				;Compare R11:R10 (number of pixels to be copied)
			JNZ		STUReadBlk				; to R14. If R10 is greater then use R14 to copy
			CMP		R14,R10					; a full block of pixels (according to buffer
			JHS		STUReadBlk				; size)
			MOV		R10,R14					; else use R10 to copy the rest of the pixels to
											; complete the text scroll

STUReadBlk:	CLRC
			CALL	#ReadNextLCD			;Read one word (R and G of first pixel)
			MOV		R15,R5
			CALL	#ReadNextLCD			;Another word from LCD (B of first pixel, R from
			MOV		R15,R6					; second pixel)
			CALL	#ReadNextLCD			;Last word from LCD (G and B of second pixel)
			MOV		R5,R4
			AND		#0FE00h,R4				;Filter first pixel's R
			RLAM.W	#2,R4					;Move it 2 bits left
			AND		#000FFh,R5				;Filter only first pixel's G
			RLAM.W	#4,R5					;Position it 5 bits left
			RLAM.W	#1,R5
			BIS		R5,R4					;Merge it with R
			MOV		R6,R5					;Get a copy of B (on high byte)
			SWPB	R5						;Bring B to lower byte
			RRA.B	R5						;Keep only the high 5 bits of B and filter out
											; second pixel's R
			BIS		R5,R4					;Merge B with RG to form the full pixel colour

ScrLastLine:								;Use fill region

;============================================================================================
; INTERRUPT VECTORS
;--------------------------------------------------------------------------------------------
;			.sect	".reset"				; MSP430 RESET Vector
;			.short	StartMe					; Points to the Starting point

			.end
