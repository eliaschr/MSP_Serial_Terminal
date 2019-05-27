;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;*
;********************************************************************************************
			.title	"Aiolos Project - MSP Serial Terminal"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------
BACKGRD_COLOUR		.equ	00000h			;The default background colour of the program

;The following definitions define the place and colour that the time appears on screen
DEF_TIME_L	.equ		0013Eh				;Left starting point is 318
DEF_TIME_T	.equ		00001h				;Top startint point is 1
DEF_TIME_R	.equ		001DFh				;Right ending point is 479
DEF_TIME_B	.equ		0002Fh				;Bottom ending point is 47
DEF_TIME_FG	.equ		008FFh				;The colour to be used for time printing
DEF_TIME_BG	.equ		00000h				;The colour of the background of the time

;TERMINALW	.equ		29					;The serial terminal's width in characters
;TERMINALH	.equ		16					;The serial terminal's height in characters
;CHARW		.equ		16					;Each character's width
;CHARH		.equ		16					;Each character's height
;TERMFONT	.equ		FONT_BIG			;The default terminal font

TERMINALW	.equ		59					;The serial terminal's width in characters
TERMINALH	.equ		22					;The serial terminal's height in characters
CHARW		.equ		8					;Each character's width
CHARH		.equ		12					;Each character's height
TERMFONT	.equ		FONT_SMALL			;The default terminal font

RelaysPort	.equ		1						;The port that controls the state of the load
											; relays
RELAYS_CLR	.equ		BIT6					;Bit that clears all relays at once
RELAY_HEAT	.equ		BIT7					;Bit that activates/deactivates the heater
RELAY_WATER	.equ		BIT5					;Bit that activates/deactivates the water heater
RELAYS_ALL	.equ		RELAYS_CLR + RELAY_HEAT + RELAY_WATER

			.ref	PORTRAIT_TOPLEFT
			.ref	PORTRAIT_BOTTOMLEFT
			.ref	PORTRAIT_TOPRIGHT
			.ref	PORTRAIT_BOTTOMRIGHT
			.ref	LANDSCAPE_TOPLEFT
			.ref	LANDSCAPE_BOTTOMLEFT
			.ref	LANDSCAPE_TOPRIGHT
			.ref	LANDSCAPE_BOTTOMRIGHT

			.ref	LANDSCAPE_MAXX
			.ref	LANDSCAPE_MAXY
			.ref	PORTRAIT_MAXX
			.ref	PORTRAIT_MAXY

			.ref	OP_BOTTOMPLUS
			.ref	OP_BOTTOMMINUS
			.ref	OP_TOPPLUS
			.ref	OP_TOPMINUS
			.ref	OP_LEFTPLUS
			.ref	OP_LEFTMINUS
			.ref	OP_RIGHTPLUS
			.ref	OP_RIGHTMINUS
			.ref	OP_TOPRIGHT90
			.ref	OP_TOPLEFT90
			.ref	OP_BOTTOMRIGHT90
			.ref	OP_BOTTOMLEFT90
			.ref	OP_LEFT180
			.ref	OP_RIGHT180
			.ref	OP_TOP180
			.ref	OP_BOTTOM180
			.ref	OP_CIRCLE

;============================================================================================
; AUTO DEFINITIONS - This section contains definitions calculated by preprocessor, mainly
; according to the previously specified ones
;--------------------------------------------------------------------------------------------
		.if (RelaysPort == 1)
RELAYSIN	.equ		P1IN
RELAYSOUT	.equ		P1OUT
RELAYSDIR	.equ		P1DIR
RELAYSSEL	.equ		P1SEL
RELAYSREN	.equ		P1REN
		.elseif (RelaysPort == 2)
RELAYSIN	.equ		P2IN
RELAYSOUT	.equ		P2OUT
RELAYSDIR	.equ		P2DIR
RELAYSSEL	.equ		P2SEL
RELAYSREN	.equ		P2REN
		.elseif (RelaysPort == 3)
RELAYSIN	.equ		P3IN
RELAYSOUT	.equ		P3OUT
RELAYSDIR	.equ		P3DIR
RELAYSSEL	.equ		P3SEL
RELAYSREN	.equ		P3REN
		.elseif (RelaysPort == 4)
RELAYSIN	.equ		P4IN
RELAYSOUT	.equ		P4OUT
RELAYSDIR	.equ		P4DIR
RELAYSSEL	.equ		P4SEL
RELAYSREN	.equ		P4REN
		.elseif (RelaysPort == 5)
RELAYSIN	.equ		P5IN
RELAYSOUT	.equ		P5OUT
RELAYSDIR	.equ		P5DIR
RELAYSSEL	.equ		P5SEL
RELAYSREN	.equ		P5REN
		.elseif (RelaysPort == 6)
RELAYSIN	.equ		P6IN
RELAYSOUT	.equ		P6OUT
RELAYSDIR	.equ		P6DIR
RELAYSSEL	.equ		P6SEL
RELAYSREN	.equ		P6REN
		.elseif (RelaysPort == 7)
RELAYSIN	.equ		P7IN
RELAYSOUT	.equ		P7OUT
RELAYSDIR	.equ		P7DIR
RELAYSSEL	.equ		P7SEL
RELAYSREN	.equ		P7REN
		.elseif (RelaysPort == 8)
RELAYSIN	.equ		P8IN
RELAYSOUT	.equ		P8OUT
RELAYSDIR	.equ		P8DIR
RELAYSSEL	.equ		P8SEL
RELAYSREN	.equ		P8REN
		.else
			.emsg	"RelaysPort was not defined correctly!"
		.endif


;============================================================================================
; VARIABLES - This section contains local variables
;--------------------------------------------------------------------------------------------
			.sect	".bss"
			.align	1
Status:		.space	2						;Flags for system status

SPIA0_RXERR	.equ	BIT0					;Bit that flags a wrong interrupt by UCA0 Rx
SPIB0_RXERR	.equ	BIT1					;Bit that flags a wrong interrupt by UCB0 Rx

ClkFont:	.space	2						;The font that will be used to draw the time
ClkWinL:	.space	2						;The left coordinate of the Time window
ClkWinR:	.space	2						;The right coordinate of the Time window
ClkWinT:	.space	2						;The top coordinate of the Time window
ClkWinB:	.space	2						;The bottom coordinate of the Time window
ClkColour:	.space	2						;The foreground colour of the Time
ClkBkGrnd:	.space	2						;The background colour of the Time

SelTxtFg:	.space	2						;Keeps temporarilly the text foreground colour
SelTxtBg:	.space	2						;Keeps temporarilly the text background colour
SelTxtXPos:	.space	2						;Keeps temporarilly the text X coordinate
SelTxtYPos:	.space	2						;Keeps temporarilly the text Y coordinate
SelTxtL:	.space	2						;Keeps temporarilly the text area's left border
SelTxtR:	.space	2						;Keeps temporarilly the text area's right border
SelTxtT:	.space	2						;Keeps temporarilly the text area's top border
SelTxtB:	.space	2						;Keeps temporarilly the text area's bottom border
SelTxtFont:	.space	2						;Keeps temporarilly the font used for text
											; printing
SelTxtProp:	.space	2						;Keeps temporarilly the proportional font flag

TimeStr:	.space	6						;5 bytes, 2 for hour, one for separator and 2 for
											; minutes. The last one is the terminating char

;==< specify which must be global >==========================================================


;==< referenced variables defined in other files >===========================================


;============================================================================================
; CONSTANTS - This section contains constant data written in Flash (.const section)
;--------------------------------------------------------------------------------------------
			.sect	".const"
			.align	1
ColoursTbl:	.word	0F800h					;Full Red
			.word	007E0h					;Full Green
			.word	0001Fh					;Full Blue
			.word	0FFFFh					;Full White

SerialTitle:
			.byte	"  Serial Terminal  ",000h

;============================================================================================
; Lets find the stack sector (RAM top)
;INIT_STACK	.equ	03100h


;============================================================================================
; PROGRAM FUNCTIONS
;--------------------------------------------------------------------------------------------
;--< Some of the labels must be available to other files >-----------------------------------
			.def	StartMe					;Entry point must be global

;==< referenced functions defined in other files >===========================================
; ==> GraphicsLCD library
			.ref	BLFadeISR				;The interrupt service routine for backlight
											; smooth transition
			.ref	BL_VECTOR				;The vector address of the timer used for LCD
											; backlight PWM
			.ref	BLIV					;The timer's IV value associated with the LCD
											; backlight transition timer

			.ref	InitLCDPorts			;Initialises the port pins for LCD communication
			.ref	InitLCD					;Initialises the LCD module
			.ref	LCDStartData			;Puts the LCD in writing pixel data mode
			.ref	LCDContData				;Puts the LCD in writing pixel data mode
											; (continuation from last address)
			.ref	WriteLCDData			;Writes data to the LCD module
			.ref	ClearScreen				;Fills the whole screen with a colour
			.ref	FillRegion				;Fills a consecutive region of pixels with a
											; specific colour
			.ref	SetOrientation			;Sets the orientation of the LCD Frame Memory
			.ref	LCDSetPageAddr			;Sets the row address of the next pixel
			.ref	LCDSetColAddr			;Sets the column address of the next pixel
			.ref	LCDSetRegion			;Selects a whole rectangular region
			.ref	DrawLine				;Draws a line on screen
			.ref	DrawRect				;Draws an empty rectangle
			.ref	DrawRoundRect			;Draws an empty rectangle with rounded corners
			.ref	FillRect				;Creates a filled rectangle
			.ref	SetHScroll				;Sets the horizontal scroll area
			.ref	HScroll					;Sets the horizontal scroll start offset
			.ref	Plot					;Plots a pixel
			.ref	DrawArcs				;Draws up to 8 arcs, forming parts of a circle

			.ref	SetBkGrnd				;Sets the background colour of the text
			.ref	SetFrGrnd				;Sets the foreground colour of the text
			.ref	SetFont					;Selects the font to be used for following messages
			.ref	SetTextWindow			;Sets the window to be used for text
			.ref	SetTextRegion			;Sets both text window and LCD graphical region to
											; be used for printing
			.ref	Text2Region				;Sets the LCD graphical region according to
											; previously set text area
			.ref	SetTxtXPos				;Sets the X position of the text cursor on screen
			.ref	SetTxtYPos				;Sets the Y position of the text cursor on screen
			.ref	GetBkGrnd				;Gets the background colour of the text
			.ref	GetFrGrnd				;Gets the foreground colour of the text
			.ref	GetFont					;Gets the font used to print text
			.ref	GetTextWindow			;Gets the selected window used for text
			.ref	GetTxtXPos				;Gets the X position of the text cursor on screen
			.ref	GetTxtYPos				;Gets the Y position of the text cursor on screen
			.ref	GetTxtPos				;Gets the coordinates of the text cursor on screen
			.ref	SetTxtXRel				;Sets the X position of the text cursor relative
											; to the left text window border
			.ref	SetTxtYRel				;Sets the Y position of the text cursor relative
											; to the top text window border
			.ref	SetPropFont				;Makes use of a font as proportional
			.ref	SetFixedFont			;Makes use of a font as fixed size
			.ref	GetPropFont				;Gets the type of font used for text printing
			.ref	ScrollTextUp			;Scrolls the text area up by one character line
			.ref	PrintChr				;Prints a character on screen, using the selected
											; font
			.ref	GetEndOfScreen			;Gets the "EndOfScreen" flag
			.ref	PrintStr				;Prints a whole ASCIIZ string
			.ref	CalcFont				;Proportional font calculator

			.ref	LCDBackLightOff			;Switces off the backlight, without using timer
			.ref	LCDBackLightPWM			;Enables the PWM functionality for controlling the
											; LCD Backlight
			.ref	LCDBackLightOn			;Switches on the backlight, without using timer
			.ref	LCDBackLightSet			;Sets the level of PWM for LCD backlight

			.ref	FONT_SMALL				;The small font's index in fonts table
			.ref	FONT_BIG				;The big font's index in fonts table
			.ref	FONT_INCONSOLA			;The Inconsola font's index in fonts table
			.ref	FONT_7SEG				;The big seven segment font's index

; ==> Real Time Clock library
			.ref	RTCAlarmISR				;Interrupt Service Routine for RTC
			.ref	RTC_CS					;Chip Select pin for RTC
			.ref	RTCCTLOUT				;Chip select port for RTC CS checking
			.ref	RTCSPI					;Is a string describing the port used for SPI
			.ref	RTC_IRQ					;Is the pin specified for serving interrupts

			.ref	RTC_cS					;Get/Set milliseconds
			.ref	RTC_Secs				;Get/Set seconds
			.ref	RTC_Mins				;Get/Set minutes
			.ref	RTC_Hours				;Get/Set Hours
			.ref	RTC_Day					;Get/Set Day of week (1 to 7)
			.ref	RTC_Date				;Get/Set Date
			.ref	RTC_MonCent				;Get/Set Century and Month
			.ref	RTC_Year				;Get/Set Year (00-99)
			.ref	RTC_cSAlm				;Get/Set Alarm milliseconds
			.ref	RTC_SecsAlm				;Get/Set Alarm Seconds and Alarm Mask 1 (AM1)
			.ref	RTC_MinsAlm				;Get/Set Alarm Minutes and Alarm Mask 2 (AM2)
			.ref	RTC_HoursAlm			;Get/Set Alarm Hours and Alarm Mask 3 (AM3)
			.ref	RTC_DayDateAlm			;Get/Set Alarm Day or Date and Alarm Mask 4 (AM4)
			.ref	RTC_Control				;Get/Set RTC Control Register
			.ref	RTC_Status				;Get/Set RTC Status Register
			.ref	RTC_Charger				;Get/Set Trickle Charger Status

			.ref	RTC_12HoursMask			;Mask for reading Hours in 12 hour mode
			.ref	RTC_MonthMask			;Mask for reading Month
			.ref	RTC_AlmSecMask			;Mask for reading alarm's seconds
			.ref	RTC_AlmMinMask			;Mask for reading alarm's minutes
			.ref	RTC_AlmDayMask			;Mask for reading day of alarm
			.ref	RTC_AlmDateMask			;Mask for reading date of alarm
			.ref	RTC_AlmMask				;Alarm Mask Filter
			.ref	RTC_CenturyMask			;Century Mask Filter
			.ref	RTC_1224Mask			;12/24 Hour Mode Filter
			.ref	RTC_12Flg				;Value for 12 Hour Mode
			.ref	RTC_24Flg				;Value for 24 Hour Mode
			.ref	RTC_AMPMMask			;AM/PM Mask
			.ref	RTC_AMFlg				;Value for AM Hour
			.ref	RTC_PMFlg				;Value for PM Hour
			.ref	RTC_DayDateMask			;Day/Date Mask setting for Alarm
			.ref	RTC_DateFlg				;Value for Date Setting/Reading
			.ref	RTC_DayFlg				;Value for Day Setting/Reading

			.ref	RTC_CtlEOSC				;Enable Oscillator Mask bit for Control Register
			.ref	RTC_CtlBBSQI			;Battery-Backed and Square-Wave Interrupt Enable
											; Mask bit for Control Register
			.ref	RTC_CtlINTCN			;Interrupt Control Mask bit for Control Register
			.ref	RTC_CtlAIE				;Alarm Interrupt Enable Mask bit for Control Reg.
			.ref	RTC_CtlRateMask			;Control register bit mask for Rate Selection
			.ref	RTC_CtlRate1			;Rate Selection value for 1Hz Square Wave
			.ref	RTC_CtlRate4K			;Rate Selection value for 4096Hz Square Wave
			.ref	RTC_CtlRate8K			;Rate Selection value for 8192Hz Square Wave
			.ref	RTC_CtlRate32K			;Rate Selection Value for 32768Hz Square Wave

			.ref	RTC_StatOSF				;Oscillator Stop Status Flag bit
			.ref	RTC_StatAF				;Oscillator Alarm Status Flag bit

			.ref	RTC_TCSPasswd			;Trickle Charger - Password value
			.ref	RTC_TCSDiodeMsk			;Trickle charger mask for diode setting
			.ref	RTC_TCSDiode			;Trickle Charger - Use Diode value
			.ref	RTC_TCSNoDiode			;Trickle Charger - Do Not Use Diode value
			.ref	RTC_TCSResMask			;Trickle charger mask for resistor setting
			.ref	RTC_TCSRes250			;Trickle Charger - Use 250 Ohm resistor
			.ref	RTC_TCSRes2K			;Trickle Charger - Use 2 KOhm resistor
			.ref	RTC_TCSRes4K			;Trickle Charger - Use 4 KOhm resistor
			.ref	RTC_TCSDisable			;Trickle Charger - Disable charger

			.ref	RTC_ALMRPTCS			;Alarm interrupt repetition every 100th of a
											; second
			.ref	RTC_ALMRPTDS			;Alarm interrupt repetition every 10th of a second
			.ref	RTC_ALMRPTSEC			;Alarm interrupt repetition every second
			.ref	RTC_ALMRPTMIN			;Alarm interrupt repetition every minute
			.ref	RTC_ALMRPTHOUR			;Alarm interrupt repetition every hour
			.ref	RTC_ALMRPTDAY			;Alarm interrupt repetition every day
			.ref	RTC_ALMRPTWEEK			;Alarm interrupt repetition every week
			.ref	RTC_ALMRPTMONTH			;Alarm interrupt repetition every month

			.ref	RTCTxISR				;Interrupt service routine for SPI Tx
			.ref	RTCRxISR				;Interrupt service routine for SPI Rx
			.ref	InitRTCPorts			;Initialises the port pins used for RTC
			.ref	InitRTCUSC				;Initialises the serial bus of the RTC
			.ref	InitRTCSys				;Initialises the RTC subsystem's variables
			.ref	RTCIsBusy				;Checks if the RTC bus is busy or not
			.ref	RTCWaitData				;Blocks main thread until RTC SPI is free again
			.ref	RTCReceive				;Fetch one byte of those returned by RTC during a
											; read command
			.ref	RTCReadAll				;Fetches all RTC registers in RAM
			.ref	RTCReadcSecs			;Reads current CentiSeconds
			.ref	RTCReadLastcSecs		;Reads CentiSeconds previously read from RTC
			.ref	RTCSetcSecs				;Sets value to CentiSeconds
			.ref	RTCReadSecs				;Reads current Seconds
			.ref	RTCReadLastSecs			;Reads Seconds previously read from RTC
			.ref	RTCSetSecs				;Sets value to Seconds
			.ref	RTCReadMins				;Reads current Minutes
			.ref	RTCReadLastMins			;Reads Minutes previously read from RTC
			.ref	RTCSetMins				;Sets value to Minutes
			.ref	RTCReadHours			;Reads current Hours + AM/PM + 12/24 mode
			.ref	RTCReadLastHours		;Reads Hours (AM + Mode) previously read from RTC
			.ref	RTCSetHours				;Sets value to Hours, AM/PM flag and 12/24 Mode
			.ref	RTCReadWeekDay			;Reads current Day of week
			.ref	RTCReadLastWeekDay		;Reads Day of week previously read from RTC
			.ref	RTCSetWeekDay			;Sets value to Day of week
			.ref	RTCReadDate				;Reads current Day of month
			.ref	RTCReadLastDate			;Reads Day of month previously read from RTC
			.ref	RTCSetDate				;Sets value to Day of month
			.ref	RTCReadMonCent			;Reads current Month and Century flag
			.ref	RTCReadLastMonCent		;Reads Month/Century previously read from RTC
			.ref	RTCSetMonCent			;Sets value to Month and Century flag
			.ref	RTCReadYear				;Reads current Year
			.ref	RTCReadLastYear			;Reads Yesr previously read from RTC
			.ref	RTCSetYear				;Sets value to Year
			.ref	RTCReadAlmcSecs			;Reads current Alarm CentiSeconds
			.ref	RTCReadLastAlmcSecs		;Reads Alarm CentiSeconds previously read from RTC
			.ref	RTCSetAlmcSecs			;Sets value to Alarm CentiSeconds
			.ref	RTCReadAlmSecs			;Reads current Alarm Seconds
			.ref	RTCReadLastAlmSecs		;Reads Alarm Seconds previously read from RTC
			.ref	RTCSetAlmSecs			;Sets value to Alarm Seconds
			.ref	RTCReadAlmMins			;Reads current Alarm Minutes
			.ref	RTCReadLastAlmMins		;Reads Alarm Minutes previously read from RTC
			.ref	RTCSetAlmMins			;Sets value to Alarm Minutes
			.ref	RTCReadAlmHours			;Reads current Alarm Hours + AM/PM + 12/24 Mode
			.ref	RTCReadLastAlmHours		;Reads Alarm Hours previously read from RTC
			.ref	RTCSetAlmHours			;Sets value to Alarm Hours + AM/PM + 12/24 Mode
			.ref	RTCReadAlmDayDate		;Reads current Alarm Day/Date
			.ref	RTCReadLastAlmDayDate	;Reads Alarm Day/Date previously read from RTC
			.ref	RTCSetAlmDayDate		;Sets value to Alarm Day/Date
			.ref	RTCReadCtrl				;Reads current Control register
			.ref	RTCReadLastCtrl			;Reads Control register previously read from RTC
			.ref	RTCSetCtrl				;Sets value to Control Register
			.ref	RTCReadStatus			;Issues a Read Status command and return its value
			.ref	RTCReadLastStatus		;Returns the last read value of Status register
											; without issuing any command)
			.ref	RTCSetStatus			;Sets value to Status register (Actually resets
											; bits)
			.ref	RTCReadChrg				;Reads current Trickle Charger register
			.ref	RTCReadLastChrg			;Reads Trickle Charger previously read from RTC
			.ref	RTCSetChrg				;Sets value to Trickle Charger register
			.ref	RTCWriteMulti			;Writes a mutlibyte command to RTC
			.ref	ReadTimeStr				;Reads the time from RTC and converts it to string
											; in specified buffer
			.ref	ReadLastTimeStr			;Converts the time stored in variables to string
											; in specified buffer, without issuing a command
											; to RTC
			.ref	RTCSetAlmRate			;Sets all the alarm repetition flags according to
											; the input.
			.ref	RTCCheckServe			;Checks and then resets the Serve flag, set when
											; RTC was the one who woke up the system
			.ref	RTCCpHour2Alm			;Reads current time from RTC and copies it to
											; Alarm registers only in memory
			.ref	RTCCpLastHour2Alm		;Copies last read time to Alarm registers, without
											; issuing a read command.
			.ref	RTCChkSPITxISR			;
			.ref	RTCEnableInts			;
			.ref	RTCEnableAlarmInt		;
			.ref	RTCCTLOUT				;

; ==> RS232 Serial Communications library
			.ref	RS232TxISR
			.ref	RS232RxISR
			.ref	RS232TimerISR
			.ref	InitRS232Ports
			.ref	InitRS232USC
			.ref	InitRS232Sys
			.ref	RS232EnableInts
			.ref	RS232DisableInts
			.ref	RS232SetBinMode
			.ref	RS232SetTxtMode
			.ref	RS232GetMode
			.ref	RS232CheckServe
			.ref	RS232Receive

;-------------------------------------------------------------------------------
			.text							; Assemble into program memory
			.retain							; Override ELF conditional linking
											; and retain current section
			.retainrefs						; Additionally retain any sections
											; that have references to current
											; section
			.def		_main					; Entry point must be global
;-------------------------------------------------------------------------------
;==< Interrupt Service Routines >============================================================
P1ISR:
			BIT.B	#RTC_IRQ,&P1IFG			;Check if the interrupt source is RTC
			JNZ		RTCAlarmISR				;Yes => Service RTC Alarm
P1NoXPT:
			RETI

USCIAB0RXISR:
; This function is used as a dispatcher for shared reception interrupt handling for SPI busses
; UCA0 and UCB0. Both busses trigger a Data Ready interrupt when there is a new data byte in
; their receiving buffer. On each bus there can be more than one peripherals connected. Each
; one of these peripherals must have a Chip Select pin. So, the first thing this function does
; is to find from which bus the interrupt triggered, and the second thing is to find which one
; of the connected peripherals to that bus was active during the transaction.
			BIT.B	#UCA0RXIFG,&IFG2		;Did the interrupt be triggered by UCA0?
			JNZ		UA0RISR					;Yes => Run checks of UCA0
UB0RISR:									;else proceed to UCB0 checks

;			BIC.B	#UCB0RXIFG,&IFG2		;No one to serve => clear this interrupt flag
			PUSH	R4
			MOV.B	&UCB0RXBUF,R4			;Dummy read of the byte
			POP		R4
			BIS		#SPIB0_RXERR,&Status	;Flag the wrong interrupt by the system!
			RETI
UA0RISR:
			BIT.B	#RTC_CS,&RTCCTLOUT		;Is the bus active for Real time clock?
			JZ		RTCRxISR				;Yes => Execute RTC's transmit ISR

;			BIC.B	#UCA0RXIFG,&IFG2		;else, clear the interrupt flag...
			PUSH	R4
			MOV.B	&UCA0RXBUF,R4			;Dummy read of the byte
			POP		R4
			BIS		#SPIA0_RXERR,&Status	;Flag the wrong interrupt by the system
			RETI							;Nothing to do => Exit
;-------------------------------------------

USCIAB0TXISR:
; This function is a dispatcher for all the shared peripherals using USCIA0 or USCIB0 data
; busses. The function determines the bus first, by using the Transmition Ready flag and then
; checking each Chip Select pins of each peripheral connected to the bus in question. The
; problem is that when a transmition ready flag is high, it may generated the interrupt but it
; could also be in a wait state (raised before and no more transactions were scheduled). The
; MSP system is designed in a way that a raised transmit flag always generated an interrupt,
; whether it just emptied the transmition buffer or is just waiting for input. Thus, the
; ISR should deactivate the associated interrupt if there is no active hardware on that bus.
			BIT.B	#UCA0TXIE,&IE2			;Is this interrupt enabled?
			JZ		UB0TISR					;No => Skip checking this bus' peripherals
			;*** WORKAROUND FOR FALSE TRANSMIT PRIORITY!!! ***
			BIT.B	#UCA0RXIFG,&IFG2		;Should we give the receive interrupt priority?
			JNZ		UB0TISR					;Yes => skip transmition checking (will be fired
											; again later)
			;*************************************************
			BIT.B	#UCA0TXIFG,&IFG2		;Interrupt comes from UCA0?
			JZ		UB0TISR					;No => Check for UCB0
			BIT.B	#RTC_CS,&RTCCTLOUT		;Is RTC enabled?
			JZ		RTCTxISR				;Yes => Then jump to its service routine
UBA0TxNoXPT:
			;Calls to other interrupt check routines for peripherals connected to UCA0 follow

			;When no other hardware is active on this bus, call their check functions to
			; determine if any device needs attention
			CALL	#RTCChkSPITxISR			;Does real time clock needs attention?
			;Each of these calls determine if a peripheral needs attention, and if yes, it
			; does not return. Instead it executes the associated interrupt service routine.
			; Thus, if the code reaches this point, neither peripheral needs to use the bus
			; so disable its interrupt
			BIC.B	#UCA0TXIE,&IE2			;Disable transmition interrupt for channel A
UB0TISR:
			BIT.B	#UCB0TXIE,&IE2			;Is this interrupt enabled?
			JZ		UAB0ISRExit				;No => Skip checking this bus' peripherals
			;*** WORKAROUND FOR FALSE TRANSMIT PRIORITY!!! ***
			BIT.B	#UCB0RXIFG,&IFG2		;Should we give the receive interrupt priority?
			JNZ		UAB0ISRExit				;Yes => skip transmition checking (will be fired
											; again later)
			;*************************************************
			BIT.B	#UCB0TXIFG,&IFG2		;Test if UCB0 needs attention
			JZ		UAB0ISRExit				;No => skip tests
			;Calls to other interrupt check routines for peripherals connected to UCB0 follow

			;When no other hardware is active on this bus, call their check functions to
			; determine if any device needs attention

			;Each of these calls determine if a peripheral needs attention, and if yes, it
			; does not return. Instead it executes the associated interrupt service routine.
			; Thus, if the code reaches this point, neither peripheral needs to use the bus
			; so disable its interrupt
			BIC.B	#UCB0TXIE,&IE2			;Disable transmition interrupt for channel B
UAB0ISRExit:
			RETI							;Nothing to do => Exit
;-------------------------------------------

TIMERB1ISR:
; This function binds the necessary timer interrupt service routines of all the peripherals to
; this table, according to definitions in other peripheral's library files. It acts as a
; dispatcher routine
			ADD		&TBIV,PC				;Jump to the appropriate value according to TBIV
			RETI							;Vector 0: No interrupt source
			RETI							;Vector 2: TBCCR1
			JMP		Vect4					;Vector 4: TBCCR2
			RETI							;Vector 6: TBCCR3
			RETI							;Vector 8: TBCCR4
			RETI							;Vector A: TBCCR5
			JMP		BLFadeISR				;Vector C: TBCCR6
			RETI							;Vector F: TBIFG
Vect4:		JMP		RS232TimerISR

;==< Main Program >==========================================================================
InitRTCModule:
; Initializes the real time clock if it is not initialised.
; Input:				None
; Output:				None
; Registers Used:		R4, R5, R6, R7, R14, R15
; Registers Altered:	R4, R5, R6, R7, R14, R15
; Stack Usage:			14 (2 for CALL and 12 by RTCSet* set of commands)
; Depend On Defs:		FONT_7SEG, RTC_ALMRPTMIN, RTC_CtlAIE, RTC_CtlINTCN, RTC_StatOSF
; Depend On Vars:		ClkFont
; Depend On Constants:	None
; Depend On Funcs:		RTCReadAll, RTCReadLastCtrl, RTCReadLastStatus, RTCSetAlmcSecs,
;						RTCSetAlmRate, RTCSetAlmSecs, RTCSetCtrl, RTCSetStatus, RTCWaitData
			MOV		#FONT_7SEG,&ClkFont		;Time will be displayed using this font, if OK
			CALL	#RTCWaitData			;Wait for RTC data to be fetched
			CALL	#RTCReadLastStatus		;Get the status register read earlier
			BIT.B	#RTC_StatOSF,R4			;Is the Oscillator Stop Flag status bit set?
			JZ		RTCInitOK				;No => Skip initialising the RTC module
RTCDoInit:
;			MOV.B	#004h,R6
;			CALL	#RTCSetWeekDay
;			CALL	#RTCWaitData
;			MOV.B	#002h,R6
;			CALL	#RTCSetDate
;			CALL	#RTCWaitData
;			MOV.B	#004h,R6
;			CALL	#RTCSetMonCent
;			CALL	#RTCWaitData
;			MOV.B	#015h,R6
;			CALL	#RTCSetYear
;			CALL	#RTCWaitData
;			MOV.B	#001h,R6
;			CALL	#RTCSetHours
;			CALL	#RTCWaitData
;			MOV.B	#000h,R6
;			CALL	#RTCSetMins
;			CALL	#RTCWaitData
;			MOV.B	#000h,R6
;			CALL	#RTCSetSecs
;			CALL	#RTCWaitData
;			CALL	#RTCCpLastHour2Alm		;Copy current time to alarm
			MOV.B	#000h,R6
			CALL	#RTCSetAlmcSecs			;Reset 100ths of a second in alarm
			CALL	#RTCWaitData			;Wait for the command to be executed
			MOV.B	#000h,R6
			CALL	#RTCSetAlmSecs			;Reset seconds in alarm
			CALL	#RTCWaitData			;Wait for the command to be executed
			MOV.B	#RTC_ALMRPTMIN,R4		;Going to use alarm interrupt every minute
			CALL	#RTCSetAlmRate			;Set the alarm repetition rate
			CALL	#RTCWaitData			;Wait for the command to be executed
			CALL	#RTCReadLastCtrl		;Read the control register
			BIS.B	#RTC_CtlINTCN,R4		;Set INTCN to produce interrupt in SQW/INT pin
											; together with AIE to enable interrupt generation
			BIS.B	#RTC_CtlAIE,R4			;Set INTCN to produce interrupt in SQW/INT pin
											; together with AIE to enable interrupt generation
			MOV.B	R4,R6					;Going to set this new value
			CALL	#RTCSetCtrl				;Set control register of RTC
			CALL	#RTCWaitData			;Wait for the command to be executed
			CALL	#RTCReadAll
			CALL	#RTCWaitData
			MOV		#FONT_7SEG,&ClkFont		;Time will be displayed using this font if RTC is
											; not initialised
RTCInitOK:	CALL	#RTCWaitData			;Wait for the command to be executed
			MOV.B	#000h,R6
			JMP		RTCSetStatus			;Clear status register
;-------------------------------------------

PrintTime:
; Prints the time into a specified text window on screen. The window coordinates are stored in
; associated variables
; Input:				None
; Output:				None
; Registers Used:		R4, R5, R6, R7, R14, R15
; Registers Altered:	All registers are altered
; Stack Usage:			8 bytes (by PrintStr)
; Depend On Defs:		None
; Depend On Vars:		ClkBkGrnd, ClkColour, ClkFont, ClkWinB, ClkWinL, ClkWinR, ClkWinT,
;						TimeStr
; Depend On Constants:	None
; Depend On Funcs:		PrintStr, ReadLastTimeStr, SetBkGrnd, SetFont, SetFrGrnd,
;						SetTextWindow
			MOV		&ClkWinL,R4				;Left starting point is 318
			MOV		&ClkWinT,R6				;Top startint point is 1
			MOV		&ClkWinR,R5				;Right ending point is 319
			MOV		&ClkWinB,R7				;Bottom ending point is 47
			CALL	#SetTextWindow			;Set text window for time
			MOV		&ClkColour,R15
			CALL	#SetFrGrnd				;Set the colour of Time
			MOV		&ClkBkGrnd,R15
			CALL	#SetBkGrnd				;Set the background colour
			MOV		#TimeStr,R15			;Going to set the text of current time
			MOV		#00005h,R14				;Only 5 characters
			CALL	#ReadLastTimeStr		;Get the string of time
			MOV.B	#000h,&TimeStr+5		;Set the terminating character
			MOV		#TimeStr,R5				;Print Time string
			MOV		&ClkFont,R4
			CALL	#SetFont				;Set the font to be used for time printing
			JMP		PrintStr				;Print time and return to caller
;-------------------------------------------

GetTextStatus:
; Gets all necessary variables of the currently used text area. It is used whenever the system
; needs to print something else than the ordinary part and need to restore those settings
; after using the screen module
; Input:				None
; Output:				None
; Registers Used:		R4, R5, R6, R7, R15
; Registers Altered:	R4, R5, R6, R7, R15
; Stack Usage:			2 bytes
; Depend On Defs:		None
; Depend On Vars:		SelTxtB, SelTxtBg, SelTxtFg, SelTxtFont, SelTxtL, SelTxtProp, SelTxtR,
;						SelTxtT, SelTxtXPos, SelTxtYPos
; Depend On Constants:	None
; Depend On Funcs:		GetBkGrnd, GetFont, GetFrGrnd, GetPropFont, GetTextWindow, GetTxtPos
			CALL	#GetFrGrnd				;Get the foreground colour
			MOV		R15,&SelTxtFg			;Store it to temporary variable
			CALL	#GetBkGrnd				;Get the background colour
			MOV		R15,&SelTxtBg			;Store it to its temporary valiable
			CALL	#GetTxtPos				;Get the coordinates of the cursor
			MOV		R4,&SelTxtXPos			;Store X position to its temporary variable
			MOV		R6,&SelTxtYPos			;Store Y position to its temporary variable
			CALL	#GetTextWindow			;Get the text area
			MOV		R4,&SelTxtL				;Store the left border to its temporary variable
			MOV		R5,&SelTxtR				;Store the right border to its temporary variable
			MOV		R6,&SelTxtT				;Store the top border to its temporary variable
			MOV		R7,&SelTxtB				;Store the bottom border to its temporary variable
			CALL	#GetFont				;Get the font used for printing
			MOV		R4,&SelTxtFont			;Store the font index to its temporary variable
			CALL	#GetPropFont			;Get if the font used is proportional
			ADDC	&SelTxtProp,&SelTxtProp	;Push the result of carry flag to the associated
											; variable
			RET
;-------------------------------------------

ResetTextStatus:
; Restores all necessary text variables stored earlier using GetTextStatus.
; Input:				None
; Output:				None
; Registers Used:		R4, R5, R6, R7, R13, R14, R15
; Registers Altered:	R4, R5, R6, R7, R13, R14, R15
; Stack Usage:			2 bytes
; Depend On Defs:		None
; Depend On Vars:		SelTxtB, SelTxtBg, SelTxtFg, SelTxtFont, SelTxtL, SelTxtProp, SelTxtR,
;						SelTxtT, SelTxtXPos, SelTxtYPos
; Depend On Constants:	None
; Depend On Funcs:		SetBkGrnd, SetFont, SetFrGrnd, SetPropFont, SetTextWindow, SetTxtXPos,
;						SetTxtYPos
			MOV		&SelTxtFg,R15			;Get foreground colour from temporary variable
			CALL	#SetFrGrnd				;Set the foreground colour
			MOV		&SelTxtBg,R15			;Get background colour from temporary valiable
			CALL	#SetBkGrnd				;Set the background colour
			MOV		&SelTxtFont,R4			;Get the font index from temporary variable
			CALL	#SetFont				;Set the font
			MOV		&SelTxtL,R4				;Get the left border from temporary variable
			MOV		&SelTxtR,R5				;Get the right border from temporary variable
			MOV		&SelTxtT,R6				;Get the top border from temporary variable
			MOV		&SelTxtB,R7				;Get the bottom border from temporary variable
			CALL	#SetTextWindow			;Set the text area
			MOV		&SelTxtXPos,R4			;Get cursor's X position from temporary variable
			CALL	#SetTxtXPos				;Set the Y coordinate of the text cursor
			MOV		&SelTxtYPos,R6			;Get cursor's Y position from temporary variable
			CALL	#SetTxtYPos				;Set the Y coordinate of the text cursor
			RRA		&SelTxtProp				;Get the proportional status of the font
			JC		SetPropFont				;Proportional font used? => Set it
			JMP		SetFixedFont			;else, set it as fixed font
;-------------------------------------------

InitClock:
; Initializes the clock system to use the external crystal of 16MHz
; Input:				None
; Output:				None
; Registers Used:		R15
; Registers Altered:	R15 = 0, Zero and Carry Flags are set
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		None
			BIC.W	#OSCOFF,SR				;Turn on oscillator module (for LFXT1)
			BIC.B	#XT2OFF,&BCSCTL1		;Enable XT2 crystal clock
			BIC.B	#XTS,&BCSCTL1			;LFXT1 is set for low frequency crystal
			BIC.B	#XCAP_3,&BCSCTL3
			BIS.B	#XT2S_2+XCAP_3,&BCSCTL3	;3-16MHz Crystal
IClkCheck:
			BIC.B	#OFIFG,&IFG1			;Clear OFIFG flag
			MOV.W	#0FFh,R15				;Delay factor
IClkDelay:	DEC.W	R15						;2 clock pulses
			JNZ		IClkDelay				;2 clock pulses
			BIT.B	#OFIFG,&IFG1			;Re-test OFIFG
			JNZ		IClkCheck				;Repeat test if needed
IClkEnd:	BIS.B	#SELM1+SELS,&BCSCTL2	;Select XT2 crystal oscilator as MCLK and SMCLK
			BIC.B	#DIVA0+DIVA1,&BCSCTL1	;AClk is not devided, equal to LFXT1
			RET
;-------------------------------------------

InitTimers:
; Sets the registers of the Timer modules
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		None
; Depend On Funcs:		None
			MOV		#00064h,&TBCCR0			;Value for 120 Hz frequency of timer
			MOV		#00000h,&TBR			;Clear timer's counter
			MOV		#TBSSEL_1+MC_1,&TBCTL	;Sync from AClk and count up to CCR0
			RET
;-------------------------------------------

InitRelays:
; Sets the port pins that control the load relay switches and deactivates them
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RELAYS_ALL, RELAYS_CLR, RELAYSDIR, RELAYSOUT
; Depend On Vars:		None
; Depend On Funcs:		None
			BIS.B	#RELAYS_ALL,&RELAYSDIR	;Relays control pins are all outputs
			BIC.B	#RELAYS_ALL,&RELAYSOUT	;They must be reset
			BIS.B	#RELAYS_CLR,&RELAYSOUT	;In case of a relay that is still active, force
			BIC.B	#RELAYS_CLR,&RELAYSOUT	; the clear command by pulsing RELAYS_CLR
			RET
;-------------------------------------------

FillScreen:
; Fills the screen with four horizontal bars. It uses the fast fill algorythm
; Input:				None
; Output:				None
; Registers Used:		R5, R14, R15
; Registers Altered:	R14 = 0, Zero and Carry Flags are set
; Stack Usage:			2 for calling FillRegion
; Depend On Defs:		None
; Depend On Vars:		ColoursTbl
; Depend On Funcs:		FillRegion
			MOV.B	#006h,R5				;Counter for colours
FS_NxtBar:	MOV.W	#09600h,R14				;Counter for pixels
			MOV.W	ColoursTbl(R5),R15		;Get current colour
			CLRC							;Keep CS low after transaction
			CALL	#FillRegion				;Fill a region of R14 number of pixels
			DECD	R5						;One colour bar less
			JC		FS_NxtBar				;Repeat for all bars (if there are more)
			RET
;-------------------------------------------

;*********************************************************************************************
;*                                    Application Starts                                     *
;*********************************************************************************************
main:
_main:
start:
StartMe:
;=> Initialise the MSP430 subsystems
			MOV.W	#INIT_STACK,SP 			;Initialize stack pointer
			MOV.W	#WDTPW+WDTHOLD,&WDTCTL	;Stop WDT (Watch Dog Timer)
;--> Initialise ports for relays
			CALL	#InitRelays				;Initialise the relay ports and disable all loads
;--> Initialise main system variables
			MOV		#00000h,&Status			;Initialise status variable
;--> Finally initialise the clock of MSP
			CALL	#InitClock				;Initialise clock subsystem
;--> Many subsystems of the application need timers
			CALL	#InitTimers				;Initialises the timer blocks

;=> Initialise application subsystems (Port pins and MSP430 resources)
;--> LCD Module
			CALL	#InitLCDPorts			;Initialise the hardware to communicate to LCD
;--> Real time clock
			CALL	#InitRTCPorts			;Initialise the ports the Real Time Clock is
											; connected to.
			CALL	#InitRTCSys				;Initialise RTC subsystem's variables
			CALL	#InitRTCUSC				;Initialise the serial port of RTC. It has almost
											; the same settings as XPT, and it is connected to
											; the same serial bus. So no need to execute this
											; init process
;--> RS232 communications with PC
			CALL	#InitRS232Ports			;Initialise the port pins that are used for RS232
			CALL	#InitRS232USC			;Initialise the serial interface for RS232
											; communications
			CALL	#InitRS232Sys			;Initialise RS232 subsystem

;=> Initialisation of modules themselves
;--> Initialise LCD module to be ready to communicate with MSP
			CALL	#InitLCD				;Initialise the LCD module
			CALL	#LCDBackLightPWM		;Backlight will be driven by PWM
			MOV		#00064h,R4				;Maximum value of PWM
			CALL	#LCDBackLightSet		;Backlight set to maximum

;--> Initialise Real time clock
			CALL	#RTCEnableInts			;Enable interrupts of RTC
			CALL	#RTCReadAll				;Fetch all registers from RTC

;--> Initialise RS232
			CALL	#RS232EnableInts		;Enable RS232 interrupts

;================================= Main design part is here =================================
			EINT

;--> Draw the initial screen
			MOV		#BACKGRD_COLOUR,R15		;Setup the background colour to the default one
			CALL	#ClearScreen			;Fills the screen with colours

;--> Print time from Real time clock
			MOV		#DEF_TIME_L,&ClkWinL	;Left starting point is 318
			MOV		#DEF_TIME_T,&ClkWinT	;Top startint point is 1
			MOV		#DEF_TIME_R,&ClkWinR	;Right ending point is 319
			MOV		#DEF_TIME_B,&ClkWinB	;Bottom ending point is 47
			MOV		#DEF_TIME_FG,&ClkColour	;The colour to be used for time printing
			MOV		#DEF_TIME_BG,&ClkBkGrnd	;The colour of the background of the time
			CALL	#InitRTCModule			;Initialise the real time clock chip
			CALL	#PrintTime				;Prints the current time
			CALL	#RTCEnableAlarmInt		;Enable alarm interrupts

;--> Print main text window
;Start with the label box
			MOV		#00000h,R4				;Need to draw a rectangle at (0,48)(215,49)
			MOV		#000CCh,R5
			MOV		#00030h,R6
			MOV		#00031h,R7
			MOV		#0FFE0h,R15				;Yellow colour
			CALL	#DrawRect				;Draw this empty rectangle
			MOV		#00000h,R4				;Need to draw a rounded rectangle at
			MOV		#000CCh,R5				; (0,32)(215,48)
			MOV		#00020h,R6
			MOV		#00032h,R7
			MOV		#00003h,R10				;Radius is 3 pixels
			MOV		#07BEFh,R15				;Gray colour
			CALL	#DrawRoundRect			;Draw the rectangle
;--> Print the label
			MOV		#FONT_BIG,R4			;Use big font
			CALL	#SetFont
			CALL	#SetPropFont			;Proportional
			MOV		#0003Fh,R15				;Light blue text colour
			CALL	#SetFrGrnd
			MOV		#0FFE0h,R15				;On yellow background
			CALL	#SetBkGrnd
			MOV		#00001h,R4				;The region of the printing is (1,33)(479,319)
			MOV		#001DFh,R5
			MOV		#00021h,R6
			MOV		#0013Fh,R7
			CALL	#SetTextWindow			;Set the text window
			MOV		#SerialTitle,R5
			CALL	#PrintStr				;Print the title

;--> Prepare the text area
			MOV		#00000h,R4				;Wrap the text area of the serial terminal in a
			MOV		#TERMINALW*CHARW+1,R5	; rectangle at (0,50)(479,319)
			MOV		#00032h,R6
			MOV		#TERMINALH*CHARH+00032h +2,R7
			MOV		#07BEFh,R15				;Gray colour
			CALL	#DrawRect				;Draw this rectangle

;--> Prepare the font window and settings for the RS232 terminal
			MOV		#TERMFONT,R4			;Use small font
			CALL	#SetFont
			CALL	#SetFixedFont			;Fixed mode for terminal
			MOV		#0FFFFh,R15				;White colour text
			CALL	#SetFrGrnd
			MOV		#00000h,R15				;Black background
			CALL	#SetBkGrnd
			MOV		#00001h,R4				;The text area is (1,51)(478,318)
			MOV		#TERMINALW*CHARW,R5
			MOV		#00033h,R6
			MOV		#TERMINALH*CHARH+00033h,R7
			CALL	#SetTextWindow			;Set the text area

;*********************************************************************************************
;*                        Main Thread of the application - Event Loop                        *
;*********************************************************************************************
Sleep:		BIS		#LPM0,SR				;Sleep to LPM0
ReTest:		CALL	#RTCCheckServe			;Did the wake up need to serve RTC?
			JC		ServeRTCAlarm			;Yes => Serve RTC
			CALL	#RS232CheckServe		;Did RS232 woke up the system?
			JC		ServeRS232				;Yes => Serve RS232 data
			JMP		Sleep					;Nobody to be serviced... Sleep again

ServeRTCAlarm:
			CALL	#GetTextStatus			;Get text variables
			CALL	#PrintTime				;Just print the time on the right place
			CALL	#ResetTextStatus		;Set those variables again
			JMP		ReTest

ServeRS232:
			CALL	#RS232Receive			;Get one character
			JC		ReTest					;No character to print? => Exit RS232
			CALL	#PrintChr				;Print this character
			JNZ		ServeRS232
			CALL	#Text2Region			;Get the coordinates of the active text window
			MOV		#00000h,R15
			CALL	#FillRect				;Fill with background colour
			MOV		#00000h,R4
			CALL	#SetTxtXRel				;Cursor to Left border of text
			MOV		#00000h,R6
			CALL	#SetTxtYRel				;Cursor to Top border of text
			JMP		ServeRS232				;Repeat until all characters are printed

ServeTouch:
			JNC		ServeRS232				;If there is no problem on printing skip clear
											; screen

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
			.def		INIT_STACK
			.sect	.stack
INIT_STACK:	.space	2

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
			.sect	".reset"				; MSP430 RESET Vector
			.short	_main
