;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                                   MSP Serial Terminal                                    *
;********************************************************************************************
;* Real Time Clock handling for Maxim-Dallas DS1390 and compatible ICs.                     *
;* Note that in SPI, when a master transmits a byte it receives one simultaneously          *
;* This library provides functions for interrupts. There are cases that a bus is shared     *
;*  with other peripherals; the only different pin is the chip selector. There is a         *
;*  specific definition that tells the library preprocessor if the RTC is on a shared bus   *
;*  or not. The name of the definition is SHAREDBUS. If it is 0 or not defined then it is   *
;*  assumed the RTC is alone on the bus so the system binds the interrupt service routines  *
;*  to the necessary interrupt vectors. If the SHAREDBUS has a value of 1, it does not bind *
;*  them. In that case it is assumed that the binding will happen at the main program,      *
;*  because the interrupt vectors belonging to USC, Timers or port pins are shared with     *
;*  other processes. Thus, the main program must have a kind of dispatcher that should test *
;*  which of the peripherals need attention and dispatch the program to the appropriate ISR.*
;* The interrupts needed are three:                                                         *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - Real Time Clock Library"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------
		.if $defined("RTCSPI")				;RTCSPI could be defined in command line
_RTCSPI		.equ		RTCSPI				;The UCSI that communicates to RTC
		.else
_RTCSPI		.equ		"UCA0"
		.endif

		.if $defined("RTCCtlPort")			;RTCCtlPort could be defined in command line
_RTCCtlPort	.equ		RTCCtlPort			;The port the control pins of RTC are connected
		.else
_RTCCtlPort	.equ		1
		.endif

		.if $defined("RTCIntPort")			;RTCCtlPort could be defined in command line
_RTCIntPort	.equ		RTCIntPort
		.else
;_RTCIntPort	.equ		1				;Uncomment if RTC interrupt is on a different port
		.endif								; than RTCCtlPort. Could also be defined in CLI

		.if $defined("RTC_IRQ")				;RTC_IRQ could be defined in command line
_RTC_IRQ	.equ		RTC_IRQ
		.else
_RTC_IRQ	.equ		BIT4				;Interrupt pin
		.endif

		.if $defined("RTC_CS")				;RTC_CS could be defined in command line
_RTC_CS		.equ		RTC_CS
		.else
_RTC_CS		.equ		BIT3				;Chip select pin
		.endif

		.if $defined("SHAREDBUS")			;SHAREDBUS could be defined in command line
_SHAREDBUS	.equ		SHAREDBUS			;Giving a value of 0 means that the bus is used
		.else								; only by this peripheral. A value of 1 means
_SHAREDBUS	.equ		1					; that SPI bus is shared with other peripherals
		.endif

		.if $defined("CPUSMCLK")
_CPUSMCLK	.equ		CPUSMCLK
		.else
_CPUSMCLK	.equ		16000000			;The CPU SMCLK clock frequency in Hz
		.endif

		.if $defined("RTCRXBUFLEN")			;RTCRXBUFLEN could be defined in command line
_RTCRXBUFLEN	.equ	RTCRXBUFLEN
		.else
_RTCRXBUFLEN	.equ	18					;Size of incoming stream buffer
		.endif

		.if $defined("RTCTXBUFLEN")			;RTCTXBUFLEN could be defined in command line
_RTCTXBUFLEN	.equ	RTCTXBUFLEN
		.else
_RTCTXBUFLEN	.equ	18					;Size of outgoing stream buffer
		.endif

;============================================================================================
; LIBRARY DEFINITIONS - This section contains definitions, global to all program
;--------------------------------------------------------------------------------------------
RTC_cS			.equ		000h			;Command for reading current centiseconds (BCD)
RTC_Secs		.equ		001h			;Command for seconds (BCD)
RTC_Mins		.equ		002h			;Command for minutes (BCD)
RTC_Hours		.equ		003h			;Command for hours. For 24 mode is just BCD, for
											; 12 hour mode, uses also the AM/PM bit
RTC_Day			.equ		004h			;Command for reading day of week (1 to 7)
RTC_Date		.equ		005h			;Command for reading day of month (1 to 31 BCD)
RTC_MonCent		.equ		006h			;Command for reading month (BCD) and century bit
RTC_Year		.equ		007h			;Command for reading year's two last digits (BCD)
RTC_cSAlm		.equ		008h			;Read Alarm's centiseconds (BCD)
RTC_SecsAlm		.equ		009h			;Read Alarm's seconds (BCD)/Alarm Mask 1
RTC_MinsAlm		.equ		00Ah			;Read Alarm's minutes (BCD)/Alarm Mask 2
RTC_HoursAlm	.equ		00Bh			;Read Alarm's Hour (BCD for 24 mode/BCD + AM/PM
											; flag for 12 hour mode). Also read Alarm Mask 3
RTC_DayDateAlm	.equ		00Ch			;Read Alarm's Day or Date value (BCD)/AM4
RTC_Control		.equ		00Dh			;Read Control Register
RTC_Status		.equ		00Eh			;Read Status Register
RTC_Charger		.equ		00Fh			;Read Trickle Charger settings

RTC_CmdMask		.equ		00Fh			;Mask the bits that represent a reading command
RTC_Write		.equ		080h			;Set this bit to construct a Write command

RTC_12HoursMask	.equ		01Fh			;Mask for reading Hours in 12 hour mode
RTC_MonthMask	.equ		01Fh			;Mask for reading Month
RTC_CenturyMask	.equ		080h			;Mask for reading century flag
RTC_AlmMask		.equ		080h			;Mask for reading AMx bits
RTC_AlmSecMask	.equ		07Fh			;Mask for reading alarm's seconds
RTC_AlmMinMask	.equ		07Fh			;Mask for reading alarm's minutes
RTC_1224Mask	.equ		040h			;Mask for reading hour format (12 or 24 mode)
RTC_12Flg		.equ		040h			;Flag for setting 12 mode format
RTC_24Flg		.equ		000h			;Flag for setting 24 mode format
RTC_AMPMMask	.equ		020h			;Mask for reading AM/PM bit
RTC_AMFlg		.equ		000h			;Flag for setting AM hour
RTC_PMFlg		.equ		020h			;Flag for setting PM hour
RTC_DayDateMask	.equ		040h			;Mask for Day/Date bit reading (for Day value = 0)
RTC_AlmDayMask	.equ		00Fh			;Mask for reading day of alarm
RTC_AlmDateMask	.equ		03Fh			;Mask for reading date of alarm
RTC_DateFlg		.equ		000h			;Flag for setting date
RTC_DayFlg		.equ		040h			;Flag for setting day

RTC_CtlEOSC		.equ		080h			;Control register bit mask for EOSC
RTC_CtlBBSQI	.equ		020h			;Control register bit mask for BBSQI
RTC_CtlINTCN	.equ		004h			;Control register bit mask for INTCN
RTC_CtlAIE		.equ		001h			;Control register bit mask for AIE
RTC_CtlRateMask	.equ		018h			;Control register bit mask for Rate Selection
RTC_CtlRate1	.equ		000h			;Control register bit setting for 1Hz output rate
RTC_CtlRate4K	.equ		008h			;Control register bit setting for 4092Hz rate
RTC_CtlRate8K	.equ		010h			;Control register bit setting for 8192Hz rate
RTC_CtlRate32K	.equ		018h			;Control register bit setting for 32768Hz rate

RTC_StatOSF		.equ		080h			;Status register bit mask for OSF
RTC_StatAF		.equ		001h			;Status register bit mask for AF

RTC_TCSPasswd	.equ		0A0h			;Trickle charger register enabling password
RTC_TCSDiodeMsk	.equ		00Ch			;Trickle charger mask for diode setting
RTC_TCSDiode	.equ		008h			;Trickle charger bit setting for diode usage
RTC_TCSNoDiode	.equ		004h			;Trickle charger bit setting for using no diode
RTC_TCSResMask	.equ		003h			;Trickle charger mask for resistor setting
RTC_TCSRes250	.equ		001h			;Trickle charger bit setting for 250Ω resistor
RTC_TCSRes2K	.equ		002h			;Trickle charger bit setting for 2KΩ resistor
RTC_TCSRes4K	.equ		003h			;Trickle charger bit setting for 4KΩ resistor
RTC_TCSDisable	.equ		000h			;Trickle charger bit setting for disabling charger

RTC_ALMRPTCS	.equ		000h			;Alarm interrupt repetition every 100th of a
											; second
RTC_ALMRPTDS	.equ		002h			;Alarm interrupt repetition every 10th of a second
RTC_ALMRPTSEC	.equ		004h			;Alarm interrupt repetition every second
RTC_ALMRPTMIN	.equ		006h			;Alarm interrupt repetition every minute
RTC_ALMRPTHOUR	.equ		008h			;Alarm interrupt repetition every hour
RTC_ALMRPTDAY	.equ		00Ah			;Alarm interrupt repetition every day
RTC_ALMRPTWEEK	.equ		00Ch			;Alarm interrupt repetition every week
RTC_ALMRPTMONTH	.equ		00Eh			;Alarm interrupt repetition every month

			.def	RTC_cS					;Get/Set milliseconds
			.def	RTC_Secs				;Get/Set seconds
			.def	RTC_Mins				;Get/Set minutes
			.def	RTC_Hours				;Get/Set Hours
			.def	RTC_Day					;Get/Set Day of week (1 to 7)
			.def	RTC_Date				;Get/Set Date
			.def	RTC_MonCent				;Get/Set Century and Month
			.def	RTC_Year				;Get/Set Year (00-99)
			.def	RTC_cSAlm				;Get/Set Alarm milliseconds
			.def	RTC_SecsAlm				;Get/Set Alarm Seconds and Alarm Mask 1 (AM1)
			.def	RTC_MinsAlm				;Get/Set Alarm Minutes and Alarm Mask 2 (AM2)
			.def	RTC_HoursAlm			;Get/Set Alarm Hours and Alarm Mask 3 (AM3)
			.def	RTC_DayDateAlm			;Get/Set Alarm Day or Date and Alarm Mask 4 (AM4)
			.def	RTC_Control				;Get/Set RTC Control Register
			.def	RTC_Status				;Get/Set RTC Status Register
			.def	RTC_Charger				;Get/Set Trickle Charger Status

			.def	RTC_12HoursMask			;Mask for reading Hours in 12 hour mode
			.def	RTC_MonthMask			;Mask for reading Month
			.def	RTC_AlmSecMask			;Mask for reading alarm's seconds
			.def	RTC_AlmMinMask			;Mask for reading alarm's minutes
			.def	RTC_AlmDayMask			;Mask for reading day of alarm
			.def	RTC_AlmDateMask			;Mask for reading date of alarm
			.def	RTC_AlmMask				;Alarm Mask Filter
			.def	RTC_CenturyMask			;Century Mask Filter
			.def	RTC_1224Mask			;12/24 Hour Mode Filter
			.def	RTC_12Flg				;Value for 12 Hour Mode
			.def	RTC_24Flg				;Value for 24 Hour Mode
			.def	RTC_AMPMMask			;AM/PM Mask
			.def	RTC_AMFlg				;Value for AM Hour
			.def	RTC_PMFlg				;Value for PM Hour
			.def	RTC_DayDateMask			;Day/Date Mask setting for Alarm
			.def	RTC_DateFlg				;Value for Date Setting/Reading
			.def	RTC_DayFlg				;Value for Day Setting/Reading

			.def	RTC_CtlEOSC				;Enable Oscillator Mask bit for Control Register
			.def	RTC_CtlBBSQI			;Battery-Backed and Square-Wave Interrupt Enable
											; Mask bit for Control Register
			.def	RTC_CtlINTCN			;Interrupt Control Mask bit for Control Register
			.def	RTC_CtlAIE				;Alarm Interrupt Enable Mask bit for Control Reg.
			.def	RTC_CtlRateMask			;Control register bit mask for Rate Selection
			.def	RTC_CtlRate1			;Rate Selection value for 1Hz Square Wave
			.def	RTC_CtlRate4K			;Rate Selection value for 4096Hz Square Wave
			.def	RTC_CtlRate8K			;Rate Selection value for 8192Hz Square Wave
			.def	RTC_CtlRate32K			;Rate Selection Value for 32768Hz Square Wave

			.def	RTC_StatOSF				;Oscillator Stop Status Flag bit
			.def	RTC_StatAF				;Oscillator Alarm Status Flag bit

			.def	RTC_TCSPasswd			;Trickle Charger - Password value
			.def	RTC_TCSDiodeMsk			;Trickle charger mask for diode setting
			.def	RTC_TCSDiode			;Trickle Charger - Use Diode value
			.def	RTC_TCSNoDiode			;Trickle Charger - Do Not Use Diode value
			.def	RTC_TCSResMask			;Trickle charger mask for resistor setting
			.def	RTC_TCSRes250			;Trickle Charger - Use 250 Ohm resistor
			.def	RTC_TCSRes2K			;Trickle Charger - Use 2 KOhm resistor
			.def	RTC_TCSRes4K			;Trickle Charger - Use 4 KOhm resistor
			.def	RTC_TCSDisable			;Trickle Charger - Disable charger

			.def	RTC_ALMRPTCS			;Alarm interrupt repetition every 100th of a
											; second
			.def	RTC_ALMRPTDS			;Alarm interrupt repetition every 10th of a second
			.def	RTC_ALMRPTSEC			;Alarm interrupt repetition every second
			.def	RTC_ALMRPTMIN			;Alarm interrupt repetition every minute
			.def	RTC_ALMRPTHOUR			;Alarm interrupt repetition every hour
			.def	RTC_ALMRPTDAY			;Alarm interrupt repetition every day
			.def	RTC_ALMRPTWEEK			;Alarm interrupt repetition every week
			.def	RTC_ALMRPTMONTH			;Alarm interrupt repetition every month


;============================================================================================
; AUTO DEFINITIONS - This section contains definitions calculated by preprocessor, mainly
; according to the previously specified ones
;--------------------------------------------------------------------------------------------
RTCBAUD		.equ		(_CPUSMCLK / 4000000)	;The baud rate factor for BR0 and BR1 registers

		.if _RTCSPI == "UCA0"
RTCDataPort	.equ		3
RTC_SIMO	.equ		BIT4
RTC_SOMI	.equ		BIT5
RTC_CLK		.equ		BIT0
RTC_ALL		.equ		RTC_SIMO+RTC_SOMI+RTC_CLK
RTCIN		.equ		P3IN
RTCOUT		.equ		P3OUT
RTCDIR		.equ		P3DIR
RTCSEL		.equ		P3SEL
RTCREN		.equ		P3REN
RTCCLKIN	.equ		P3IN
RTCCLKOUT	.equ		P3OUT
RTCCLKDIR	.equ		P3DIR
RTCCLKSEL	.equ		P3SEL
RTCCLKREN	.equ		P3REN
RTCCTL0		.equ		UCA0CTL0
RTCCTL1		.equ		UCA0CTL1
RTCBR0		.equ		UCA0BR0
RTCBR1		.equ		UCA0BR1
RTCMCTL		.equ		UCA0MCTL
RTCSTAT		.equ		UCA0STAT
RTCRXBUF	.equ		UCA0RXBUF
RTCTXBUF	.equ		UCA0TXBUF
RTCTXIE		.equ		UCA0TXIE
RTCRXIE		.equ		UCA0RXIE
RTCIE		.equ		IE2
RTCIFG		.equ		IFG2
RTCTXVECTOR	.equ		"USCIAB0TX"
RTCRXVECTOR	.equ		"USCIAB0RX"
		.elseif _RTCSPI == "UCA1"
RTCDataPort	.equ		3
RTCClkPort	.equ		5
RTC_SIMO	.equ		BIT6
RTC_SOMI	.equ		BIT7
RTC_CLK		.equ		BIT0
RTC_ALL		.equ		RTC_SIMO+RTC_SOMI
RTCIN		.equ		P3IN
RTCOUT		.equ		P3OUT
RTCDIR		.equ		P3DIR
RTCSEL		.equ		P3SEL
RTCREN		.equ		P3REN
RTCCLKIN	.equ		P5IN
RTCCLKOUT	.equ		P5OUT
RTCCLKDIR	.equ		P5DIR
RTCCLKSEL	.equ		P5SEL
RTCCLKREN	.equ		P5REN
RTCCTL0		.equ		UCA1CTL0
RTCCTL1		.equ		UCA1CTL1
RTCBR0		.equ		UCA1BR0
RTCBR1		.equ		UCA1BR1
RTCMCTL		.equ		UCA1MCTL
RTCSTAT		.equ		UCA1STAT
RTCRXBUF	.equ		UCA1RXBUF
RTCTXBUF	.equ		UCA1TXBUF
RTCTXIE		.equ		UCA1TXIE
RTCRXIE		.equ		UCA1RXIE
RTCIE		.equ		UC1IE
RTCIFG		.equ		UC1IFG
RTCTXVECTOR	.equ		"USCIAB1TX"
RTCRXVECTOR	.equ		"USCIAB1RX"
		.elseif _RTCSPI == "UCB0"
RTCDataPort	.equ		3
RTC_SIMO	.equ		BIT1
RTC_SOMI	.equ		BIT2
RTC_CLK		.equ		BIT3
RTC_ALL		.equ		RTC_SIMO+RTC_SOMI+RTC_CLK
RTCIN		.equ		P3IN
RTCOUT		.equ		P3OUT
RTCDIR		.equ		P3DIR
RTCSEL		.equ		P3SEL
RTCREN		.equ		P3REN
RTCCLKIN	.equ		P3IN
RTCCLKOUT	.equ		P3OUT
RTCCLKDIR	.equ		P3DIR
RTCCLKSEL	.equ		P3SEL
RTCCLKREN	.equ		P3REN
RTCCTL0		.equ		UCB0CTL0
RTCCTL1		.equ		UCB0CTL1
RTCBR0		.equ		UCB0BR0
RTCBR1		.equ		UCB0BR1
RTCMCTL		.equ		UCB0MCTL
RTCSTAT		.equ		UCB0STAT
RTCRXBUF	.equ		UCB0RXBUF
RTCTXBUF	.equ		UCB0TXBUF
RTCTXIE		.equ		UCB0TXIE
RTCRXIE		.equ		UCB0RXIE
RTCIE		.equ		IE2
RTCIFG		.equ		IFG2
RTCTXVECTOR	.equ		"USCIAB0TX"
RTCRXVECTOR	.equ		"USCIAB0RX"
		.elseif _RTCSPI == "UCB1"
RTCDataPort	.equ		5
RTC_SIMO	.equ		BIT1
RTC_SOMI	.equ		BIT2
RTC_CLK		.equ		BIT3
RTC_ALL		.equ		RTC_SIMO+RTC_SOMI+RTC_CLK
RTCIN		.equ		P5IN
RTCOUT		.equ		P5OUT
RTCDIR		.equ		P5DIR
RTCSEL		.equ		P5SEL
RTCREN		.equ		P5REN
RTCCLKIN	.equ		P5IN
RTCCLKOUT	.equ		P5OUT
RTCCLKDIR	.equ		P5DIR
RTCCLKSEL	.equ		P5SEL
RTCCLKREN	.equ		P5REN
RTCCTL0		.equ		UCB1CTL0
RTCCTL1		.equ		UCB1CTL1
RTCBR0		.equ		UCB1BR0
RTCBR1		.equ		UCB1BR1
RTCMCTL		.equ		UCB1MCTL
RTCSTAT		.equ		UCB1STAT
RTCRXBUF	.equ		UCB1RXBUF
RTCTXBUF	.equ		UCB1TXBUF
RTCTXIE		.equ		UCB1TXIE
RTCRXIE		.equ		UCB1RXIE
RTCIE		.equ		UC1IE
RTCIFG		.equ		UC1IFG
RTCTXVECTOR	.equ		"USCIAB1TX"
RTCRXVECTOR	.equ		"USCIAB1RX"
		.else
			emsg	"===> _RTCSPI can be one of UCA0, UCA1, UCB0 or UCB1"
		.endif

		.if (_RTCCtlPort == 1)
RTCCTLIN	.equ		P1IN
RTCCTLOUT	.equ		P1OUT
RTCCTLDIR	.equ		P1DIR
RTCCTLSEL	.equ		P1SEL
RTCCTLREN	.equ		P1REN
		.elseif (_RTCCtlPort == 2)
RTCCTLIN	.equ		P2IN
			.eval		P2OUT,RTCCTLOUT
RTCCTLDIR	.equ		P2DIR
RTCCTLSEL	.equ		P2SEL
RTCCTLREN	.equ		P2REN
		.elseif (_RTCCtlPort == 3)
RTCCTLIN	.equ		P3IN
			.eval		P3OUT,RTCCTLOUT
RTCCTLDIR	.equ		P3DIR
RTCCTLSEL	.equ		P3SEL
RTCCTLREN	.equ		P3REN
		.elseif (_RTCCtlPort == 4)
RTCCTLIN	.equ		P4IN
			.eval		P4OUT,RTCCTLOUT
RTCCTLDIR	.equ		P4DIR
RTCCTLSEL	.equ		P4SEL
RTCCTLREN	.equ		P4REN
		.elseif (_RTCCtlPort == 5)
RTCCTLIN	.equ		P5IN
			.eval		P5OUT,RTCCTLOUT
RTCCTLDIR	.equ		P5DIR
RTCCTLSEL	.equ		P5SEL
RTCCTLREN	.equ		P5REN
		.elseif (_RTCCtlPort == 6)
RTCCTLIN	.equ		P6IN
			.eval		P6OUT,RTCCTLOUT
RTCCTLDIR	.equ		P6DIR
RTCCTLSEL	.equ		P6SEL
RTCCTLREN	.equ		P6REN
		.elseif (_RTCCtlPort == 7)
RTCCTLIN	.equ		P7IN
			.eval		P7OUT,RTCCTLOUT
RTCCTLDIR	.equ		P7DIR
RTCCTLSEL	.equ		P7SEL
RTCCTLREN	.equ		P7REN
		.elseif (_RTCCtlPort == 8)
RTCCTLIN	.equ		P8IN
			.eval		P8OUT,RTCCTLOUT
RTCCTLDIR	.equ		P8DIR
RTCCTLSEL	.equ		P8SEL
RTCCTLREN	.equ		P8REN
		.else
			emsg	"_RTCCtlPort was not defined correctly!"
		.endif


		.if $defined("_RTCIntPort")
UseInt		.equ		_RTCIntPort
		.else
UseInt		.equ		_RTCCtlPort
		.endif

		.if UseInt == 1
RTCINTIN	.equ		P1IN
RTCINTOUT	.equ		P1OUT
RTCINTDIR	.equ		P1DIR
RTCINTSEL	.equ		P1SEL
RTCINTREN	.equ		P1REN
RTCINTIE	.equ		P1IE
RTCINTIES	.equ		P1IES
RTCINTIFG	.equ		P1IFG
RTCINTVECTOR	.equ	"PORT1"
		.elseif UseInt == 2
RTCINTIN	.equ		P2IN
RTCINTOUT	.equ		P2OUT
RTCINTDIR	.equ		P2DIR
RTCINTSEL	.equ		P2SEL
RTCINTREN	.equ		P2REN
RTCINTIE	.equ		P2IE
RTCINTIES	.equ		P2IES
RTCINTIFG	.equ		P2IFG
RTCINTVECTOR	.equ	"PORT2"
		.else
			emsg	"Wrong definition of UseInt. Somehow it does not belong to port 1 or 2"
		.endif

		.if $defined("_SHAREDBUS") = 0
SINGLEISR		.equ	1
		.else
			.if _SHAREDBUS == 0
SINGLEISR		.equ	1
			.else
SINGLEISR		.equ	0
			.endif
		.endif

;-------------------------< Specify which of them should be public >-------------------------
			.def	_RTCSPI					;Is a string describing the port used for SPI
			.def	_RTC_IRQ					;Is the pin specified for serving interrupts
			.def	_RTC_CS					;Chip select pin for bus checking
			.def	RTCCTLOUT
			.def	RTCTXVECTOR
			.def	RTCRXVECTOR
			.def	RTCINTVECTOR

;============================================================================================
; VARIABLES - This section contains local variables
;--------------------------------------------------------------------------------------------
			.sect	".bss"
			.align 1
RTCFlags:	.space	2						;Some flags for controlling the function of RTC

FLG_InCmd	.equ	BIT0					;Bit 0 shows if there is any command scheduling in
											; progress, so no one else must alter
FLG_CmdOK	.equ	BIT1					;Bit 1 of RTCFlags presents if there is a
											; complete command in transfer buffer
FLG_Abord	.equ	BIT2					;Bit 2 of RTCFlags shows if there is the need to
											; force command termination (due to error)
FLG_WakeUp	.equ	BIT3					;Bit 3 of RTCFlags shows that after a complete
											; command reading, system should be waken up
FLG_LateAlm	.equ	BIT4					;Bit 4 of RTCFlags shows if there is the need to
											; service an alarm just after sending the command
											; in progress
FLG_CmdByte	.equ	BIT5					;Shows that the byte send was a command to RTC
FLG_Vars	.equ	BIT6					;The receiving ISR should use the variables area
											; directly
FLG_Write	.equ	BIT7					;Flags that we are using a Write command
											; (receiving data must be discarded)
FLG_Serve	.equ	BIT8					;Flags if Alarm woke up the system
RTCRxCBuf:	.space	_RTCRXBUFLEN				;The incomming stream circular buffer
RTCTxCBuf:	.space	_RTCTXBUFLEN				;The outgoing stream circular buffer
RxBufStrt:	.space	1						;The offset of the first character in the Rx
											; buffer
RxBufLen:	.space	1						;The length of data waiting in the Rx buffer
TxBufStrt:	.space	1						;The offset of the first character in the Tx
											; buffer
TxBufLen:	.space	1						;The length of data waiting in the Tx buffer
CentiSecs:	.space	1						;Current centiseconds
Seconds:	.space	1						;Current seconds
Minutes:	.space	1						;Current minutes
Hours:		.space	1						;Current hours/12-24 mode/AM-PM
WeekDay:	.space	1						;Current day of week
Date:		.space	1						;Current day of month
Month:		.space	1						;Current month/Century
Year:		.space	1						;Current year (in century)
AlmCentiSecs:	.space	1					;Alarm's centiseconds
AlmSeconds:	.space	1						;Alarm's seconds + AM1
AlmMinutes:	.space	1						;Alarm's minutes + AM2
AlmHours:	.space	1						;Alarm's hours/12-24 mode/AM-PM + AM3
AlmDayDate:	.space	1						;Alarm's Day or Date setting + AM4
ControlReg:	.space	1						;Control register
StatusReg:	.space	1						;Status register
Charger:	.space	1						;Trickle charger register
ServePtr:	.space	1						;When serving an alarm, data are stored directly
											; in their original positions and not the receive
											; buffer. This is the pointer to the next variable
											; to be stored, relative to CentiSecs
MAXSERVEPTR	.equ	010h					;Maximum number of data stored in case of alarm
											; serving storage


;============================================================================================
; CONSTANTS - This section contains constant data written in Flash (.const section)
;--------------------------------------------------------------------------------------------
			.sect	".const"
			.align	1
			;The following table is a lookup table for alarm repetition settings of 100ths of
			; seconds (first byte in each entry) and the Alarm Mask bits (second byte of each
			; entry). The second byte contains AM1 at LSbit to AM4 at bit 3 and Day/Date flag
			; is on bit 4
AlmRptTbl:	.byte	0FFh,00Fh				;Repetition every 100th of a second
			.byte	0F0h,00Fh				;Repetition every 10th of a second (centisecond)
			.byte	000h,00Fh				;Repetition every second
			.byte	000h,00Eh				;Repetition every minute
			.byte	000h,00Ch				;Repetition every hour
			.byte	000h,008h				;Repetition every day
			.byte	000h,010h				;Repetition every week
			.byte	000h,000h				;Repetition every month

;============================================================================================
; PROGRAM FUNCTIONS
;--------------------------------------------------------------------------------------------
;--< Some of the labels must be available to other files >-----------------------------------
			.def	RTCTxISR				;Interrupt service routine for SPI Tx
			.def	RTCRxISR				;Interrupt service routine for SPI Rx
			.def	RTCAlarmISR				;Interrupt service routine for RTC Alarm function
			.def	InitRTCPorts			;Initialises the port pins used for RTC
			.def	InitRTCUSC				;Initialises the serial bus of the RTC
			.def	InitRTCSys				;Initialises the RTC subsystem's variables
			.def	RTCChkSPITxISR			;Checks if RTC needs attention
			.def	RTCEnableInts			;Enables all interrupts of RTC subsystem
			.def	RTCDisableInts			;Disables all interrupts of RTC subsystem
			.def	RTCEnableAlarmInt		;Enables only the alarm interrupt fo RTC
			.def	RTCDisableAlarmInt		;Disables only the alarm interrupt of RTC
			.def	RTCWaitData				;Blocks main thread until SPI finishes
			.def	RTCIsBusy				;Checks if the RTC bus is busy or not
			.def	RTCReceive				;Fetch one byte of those returned by RTC during a
											; read command
			.def	RTCReadAll				;Reads all memory of Real Time Clock
			.def	RTCReadcSecs			;Reads current CentiSeconds
			.def	RTCReadLastcSecs		;Reads CentiSeconds previously read from RTC
			.def	RTCSetcSecs				;Sets value to CentiSeconds
			.def	RTCReadSecs				;Reads current Seconds
			.def	RTCReadLastSecs			;Reads Seconds previously read from RTC
			.def	RTCSetSecs				;Sets value to Seconds
			.def	RTCReadMins				;Reads current Minutes
			.def	RTCReadLastMins			;Reads Minutes previously read from RTC
			.def	RTCSetMins				;Sets value to Minutes
			.def	RTCReadHours			;Reads current Hours + AM/PM + 12/24 mode
			.def	RTCReadLastHours		;Reads Hours (AM + Mode) previously read from RTC
			.def	RTCSetHours				;Sets value to Hours, AM/PM flag and 12/24 Mode
			.def	RTCReadWeekDay			;Reads current Day of week
			.def	RTCReadLastWeekDay		;Reads Day of week previously read from RTC
			.def	RTCSetWeekDay			;Sets value to Day of week
			.def	RTCReadDate				;Reads current Day of month
			.def	RTCReadLastDate			;Reads Day of month previously read from RTC
			.def	RTCSetDate				;Sets value to Day of month
			.def	RTCReadMonCent			;Reads current Month and Century flag
			.def	RTCReadLastMonCent		;Reads Month/Century previously read from RTC
			.def	RTCSetMonCent			;Sets value to Month and Century flag
			.def	RTCReadYear				;Reads current Year
			.def	RTCReadLastYear			;Reads Yesr previously read from RTC
			.def	RTCSetYear				;Sets value to Year
			.def	RTCReadAlmcSecs			;Reads current Alarm CentiSeconds
			.def	RTCReadLastAlmcSecs		;Reads Alarm CentiSeconds previously read from RTC
			.def	RTCSetAlmcSecs			;Sets value to Alarm CentiSeconds
			.def	RTCReadAlmSecs			;Reads current Alarm Seconds
			.def	RTCReadLastAlmSecs		;Reads Alarm Seconds previously read from RTC
			.def	RTCSetAlmSecs			;Sets value to Alarm Seconds
			.def	RTCReadAlmMins			;Reads current Alarm Minutes
			.def	RTCReadLastAlmMins		;Reads Alarm Minutes previously read from RTC
			.def	RTCSetAlmMins			;Sets value to Alarm Minutes
			.def	RTCReadAlmHours			;Reads current Alarm Hours + AM/PM + 12/24 Mode
			.def	RTCReadLastAlmHours		;Reads Alarm Hours previously read from RTC
			.def	RTCSetAlmHours			;Sets value to Alarm Hours + AM/PM + 12/24 Mode
			.def	RTCReadAlmDayDate		;Reads current Alarm Day/Date
			.def	RTCReadLastAlmDayDate	;Reads Alarm Day/Date previously read from RTC
			.def	RTCSetAlmDayDate		;Sets value to Alarm Day/Date
			.def	RTCReadCtrl				;Reads current Control register
			.def	RTCReadLastCtrl			;Reads Control register previously read from RTC
			.def	RTCSetCtrl				;Sets value to Control Register
			.def	RTCReadStatus			;Issues a Read Status command and return its value
			.def	RTCReadLastStatus		;Returns the last read value of Status register
											; without issuing any command)
			.def	RTCSetStatus			;Sets value to Status register (Actually resets
											; bits)
			.def	RTCReadChrg				;Reads current Trickle Charger register
			.def	RTCReadLastChrg			;Reads Trickle Charger previously read from RTC
			.def	RTCSetChrg				;Sets value to Trickle Charger register
			.def	RTCWriteMulti			;Writes a mutlibyte command to RTC
			.def	ReadTimeStr				;Reads the time from RTC and converts it to string
											; in specified buffer
			.def	ReadLastTimeStr			;Converts the time stored in variables to string
											; in specified buffer, without issuing a command
											; to RTC
			.def	RTCSetAlmRate			;Sets all the alarm repetition flags according to
											; the input.
			.def	RTCCheckServe			;Checks and then resets the Serve flag, set when
											; RTC was the one who woke up the system
			.def	RTCCpHour2Alm			;Reads current time from RTC and copies it to
											; Alarm registers only in memory
			.def	RTCCpLastHour2Alm		;Copies last read time to Alarm registers, without
											; issuing a read command.

;==< Interrupt Service Routines >============================================================
			.text							;Place program in ROM (Flash)
			.align	1
RTCTxISR:
; After a byte is sent to RTC, the SPI bus triggers this interrupt. The interrupt sends
; another character from the circular transmit buffer to RTC, if any. It also checks for
; incomplete commands in buffer that must be discarded, or even the late alarm interrupt
; triggering, in case there was already a command scheduling in progress while the original
; alarm interrupt was triggered
; Input:				None
; Output:				None
; Registers Used:		R4
; Registers Altered:	None
; Stack Usage:			2 bytes maximum
; Depend On Defs:		FLG_Abord, FLG_CmdByte, FLG_CmdOK, FLG_LateAlm, RTC_CmdMask, _RTC_CS,
;						_RTC_IRQ, RTCCTLOUT, RTCIE, RTCINTIFG, RTCTXBUF, _RTCTXBUFLEN, RTCTXIE,
;						SINGLEISR
; Depend On Vars:		RTCFlags, RTCTxCBuf, ServePtr, TxBufLen, TxBufStrt
; Depend On Funcs:		None
			BIT		#FLG_Abord,&RTCFlags	;Do we have an incomplete command in buffer?
			JNZ		RTCTx_Discard			;Yes => Discard data
			CMP.B	#000h,&TxBufLen			;Is the buffer empty?
			JEQ		RTCTx_Exit				;Yes => Nothing to send... Just exit

RTCTx_New:	PUSH	R4						;R4 must stay unaffected
			MOV.B	&TxBufStrt,R4			;Get the starting offset
			BIC		#FLG_CmdByte,&RTCFlags	;Normally we send data bytes. The reason we clear
			; FLG_CmdByte flag here and not in receiving ISR is that if a data byte is
			; transmitted there will also be a data byte reception which will make the dummy
			; byte received earlier be discarded
			BIT.B	#_RTC_CS,&RTCCTLOUT		;Is the CS of RTC enabled?
			JZ		RTCTx_CSOK				;Yes => Every thing is fine, keep sending data

			.if SINGLEISR == 0				;Only when ISR is shared
				CALL	#InitRTCUSC			;Initialise the bus as RTC needs it
				BIS.B	#RTCTXIE+RTCRXIE,&RTCIE		;Re-enable SPI interrupts (disabled by
											; init when raised UCSWRST)
			.endif

			BIS		#FLG_CmdByte+FLG_Write,&RTCFlags	;Flag that we are sending a command
											; byte as a Write command
			MOV.B	RTCTxCBuf(R4),&ServePtr	;Store the offset of the variable to be used for
			AND.B	#RTC_CmdMask,&ServePtr	; reading
			BIC.B	#_RTC_CS,&RTCCTLOUT		;Enable communication to RTC
			BIT.B	#RTC_Write,RTCTxCBuf(R4);Is this a write command?
			JNZ		RTCTx_CSOK				;Yes => everything is fine, keep on
			BIC		#FLG_Write,&RTCFlags	;Flag that this is a read command
RTCTx_CSOK:	MOV.B	RTCTxCBuf(R4),&RTCTXBUF	;Transfer the byte to SPI
			DEC.B	&TxBufLen				;One byte less in the buffer
;			MOV.B	&TxBufStrt,R4			;Get the starting offset again
			INC.B	R4						;Try to advance the pointer to the following byte
			CMP.B	#_RTCTXBUFLEN,R4			;Pass the end of buffer?
			JL		RTCTx_NoRvt				;No => Do not revert to first buffer cell
			MOV.B	#000h,R4				;else, revert to the starting offset of buffer
RTCTx_NoRvt:
			MOV.B	R4,&TxBufStrt			;Store the new offset value
			;*** WORKARROUND ***
			BIC.B	#RTCTXIE,&RTCIE			;Temporarilly disable this interrupt
			;*******************
			POP		R4						;Restore R4
RTCTx_Exit:	RETI
RTCTx_Discard:
			MOV.B	#000h,&TxBufLen			;No data in transmition buffer
			BIC		#FLG_Abord,&RTCFlags	;Clear the "Incomplete Command" flag
			JMP		RTCRTx_End				;Exit from interrupt without sending any data
;-------------------------------------------


RTCRxISR:
; When an Rx interrupt is triggered, another byte is at the reveiving buffer of SPI module.
; This ISR writes the incomming byte to the Receiving circular buffer. In case the incoming
; stream is to serve Alarm interrupt then the incoming data are stored directly to their
; associated variables, to save time and wakes up the system to use the new data
; Input:				None
; Output:				None
; Registers Used:		R4
; Registers Altered:	None
; Stack Usage:			2 bytes maximum
; Depend On Defs:		FLG_WakeUp, MAXSERVEPTR, RTCRXBUF, _RTCRXBUFLEN
; Depend On Vars:		RTCFlags, RTCRxCBuf, RxBufLen, RxBufStrt, ServePtr, TxBufLen
; Depend On Funcs:		None
			BIT		#FLG_CmdByte + FLG_Write,&RTCFlags	;Did we send a command byte or serving
											; a Write command? (in that case the data received
											; is dummy)
			JZ		RTCRx_Norm				;No => Keep on receiving the byte
RTCRx_Dummy:
			PUSH	R4						;Store R4 to leave it unaffected
			MOV.B	&RTCRXBUF,R4			;Dummy read of this byte
RTCRx_FinCh:
			POP		R4						;Restore the old value of R4
			;*** WORKARROUND ***
			BIS.B	#RTCTXIE,&RTCIE			;Re-enable this interrupt (was disabled during
											; RTXTxISR)
			;*******************
			CMP.B	#000h,&TxBufLen			;Was this the last byte?
			JNZ		RTCRx_Exit				;No => just exit

			BIT		#FLG_CmdOK,&RTCFlags	;Did we transfer a complete command?
			JZ		RTCRTx_SkipCS			;No => Skip raising CS of RTC
RTCRTx_End:	BIC		#FLG_CmdOK+FLG_Vars,&RTCFlags	;Restore flags to their original state
			BIS.B	#_RTC_CS,&RTCCTLOUT		;Disable communication to RTC
			BIT		#FLG_LateAlm,&RTCFlags	;Do we have to late execute the alarm interrupt?
			JZ		RTCRTx_SkipAlm			;No => Do not fire alarm interrupt
			BIC		#FLG_LateAlm,&RTCFlags	;Alarm late firing is scheduled
			BIS.B	#_RTC_IRQ,&RTCINTIFG		;Fire the alarm interrupt
RTCRTx_SkipAlm:
			BIT		#FLG_WakeUp,&RTCFlags	;Test if we need to wake the system up
			JZ		RTCRTx_SkipCS			;No => then do not wake up the system
			BIC		#FLG_WakeUp,&RTCFlags	;(OK, the alarm is serviced now!)
			BIC		#CPUOFF+SCG0+SCG1+OSCOFF,0(SP)	;Wake up the system

RTCRTx_SkipCS:
			.if SINGLEISR == 1
				BIC.B	#RTCTXIE,&RTCIE		;Disable Tx Interrupt from RTC
			.endif
;			The reason the interrupt may not be disabled in here is that when the interrupt is
;			shared, the main dispatcher must disable it when there is no active hardware
;			waiting for communications and not the ISR function itself
RTCRx_Exit:	RETI

RTCRx_Norm:	BIT		#FLG_Vars,&RTCFlags		;Do we have to use variables directly to store the
											; received bytes in place?
			JNZ		RTCRx_Vars				;Yes => Store data to alternative buffer

			CMP.B	#_RTCRXBUFLEN,&RxBufLen	;Is there any space left in receiving buffer?
			JHS		RTCRx_Dummy				;No => just exit... The incoming data are gone!...
			PUSH	R4						;R4 must stay unaffected out of ISR, so store it
			MOV.B	&RxBufLen,R4			;Get the length of the buffer
			ADD.B	&RxBufStrt,R4			;Add the offset of the first byte
			CMP.B	#_RTCRXBUFLEN,R4			;Is the total passed the end of buffer?
			JL		RTCRx_NoRvt				;No => then do not revert to the beginning of it
			SUB.B	#_RTCRXBUFLEN,R4			;else, revert to the beginning of buffer
RTCRx_NoRvt:
			MOV.B	&RTCRXBUF,RTCRxCBuf(R4)	;Store the new character
			INC.B	&RxBufLen				;Buffer contains one more byte
			JMP		RTCRx_FinCh

			;For alarm servicing or when we need to directly store the receiving data to their
			; appropriate variables, we use the variables space as an alterative buffer.
RTCRx_Vars:	CMP.B	#MAXSERVEPTR,&ServePtr	;Did we reach the maximum number of bytes allowed?
			JHS		RTCRx_Dummy				;Yes => Just ignore this byte
            PUSH	R4						;R4 must stay unaffected, so stack it
			MOV.B	&ServePtr,R4			;Relative pointer of variable to be used
			INC.B	&ServePtr				;Advance the pointer by one
			MOV.B	&RTCRXBUF,CentiSecs(R4)	;Store the byte read in its appropriate variable
			JMP		RTCRx_FinCh				;Check if finished
;-------------------------------------------


RTCAlarmISR:
; Real Time Clock gives the ability to schedule an alarm. When the time has come, an interrupt
; coming from the RTC chip triggers this ISR. Its job is to get the time from the RTC and wake
; up the system (when all data were read from RTC). The main loop of the main program, then,
; can act as desired
; Input:				None
; Output:				None
; Registers Used:		R4, R5 (through RTCSchedule and RTCSend functions), R6
; Registers Altered:	None
; Stack Usage:			12 bytes (6 for pushing registers and 6 when calling RTCSend)
; Depend On Defs:		FLG_Abord, FLG_InCmd, FLG_LateAlm, FLG_WakeUp, RTC_cS
; Depend On Vars:		RTCFlags, ServePtr
; Depend On Funcs:		RTCSchedule, RTCSend
			BIT		#FLG_InCmd,&RTCFlags	;Is there a command in progress by another process
			JNZ		AlmISR_Later			;Yes => do not alter it, schedule yourself later
			PUSH	R4						;Store used registers. They must stay unaffected
			PUSH	R5						; by the interrupt service routine
			PUSH	R6
;			MOV.B	#000h,&ServePtr			;Going to start a new packet of data
			MOV.B	#RTC_cS,R4				;Going to read the whole RTC memory map
			CALL	#RTCSchedule			;Send this Read command to RTC
			JC		AlmISR_End				;If there is another command in transmition, do
											; not do anything, just exit
			BIS		#FLG_Abord,&RTCFlags	;If we fail sending a byte then we must flag that
											; this is not a complete command
			MOV.B	#000h,R4				;Next bytes just create the clock pulses
			MOV.B	#007h,R6				;Going to read 8 bytes to read the complete RTC
											; time/date, so 7 will be scheduled and the last
											; will complete the command
AlmISR_Nxt:	CALL	#RTCSchedule			;Send one dummy byte
			JC		AlmISR_End				;In case of error just abord sending command
			DEC.B	R6						;One byte less to read
			JNZ		AlmISR_Nxt				;Repeat until all dummy bytes have been sent
			CALL	#RTCSend				;Send the whole command
			JC		AlmISR_End				;In case of error exit. Abord flag is set
			;Just after the exit of this interrupt, a burst of data will start flowing through
			;SPI bus to RTC. When this is over, the receiving interrupt should transfer those
			;data to their appropriate variables in RAM and wake up the system
			BIC		#FLG_Abord,&RTCFlags	;Well, now we have a complete comand in buffer
			BIS		#FLG_Serve+FLG_WakeUp+FLG_Vars,&RTCFlags	;And the data must be stored
											; to their propper variables directly, the system
											; should wake up after executing the command and
											; the Alarm was the one who woke up the system
AlmISR_End:	BIC.B	#_RTC_IRQ,&RTCINTIFG		;Well this interrupt is serviced
			POP		R6						;Restore registers to their original values
			POP		R5
			POP		R4
			RETI
			;In case there is a process that has already started to schedule a command to RTC
			; addind data there would alter the whole command with unpredictable result. Here
			; we do not really serve the alarm interrupt, but instead we schedule it for later
			; usage (just after sending the command that is in progress)
AlmISR_Later:
			BIS		#FLG_LateAlm,&RTCFlags	;Flag the bit that this should be served later
			RETI							;and return to interrupted process
;-------------------------------------------


;==< Main Program >==========================================================================
RTCChkSPITxISR:
; Checks if RTC needs to use the bus. If yes, it takes the ownership and sends the bytes
; stored in the buffer, acting as an interrupt process. If not, then it just returns to the
; calling dispatcher routine
; Input:				Expects the bus to be free. That is why the dispatcher calls this
;						 function (using a simple CALL command) only when it discovers the bus
;						 is free.
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			2 bytes maximum (by RTCTxISR interrupt service routine)
; Depend On Defs:		FLG_Abord, SINGLEISR
; Depend On Vars:		RTCFlags, TxBufLen
; Depend On Funcs:		RTCTxISR
			.if SINGLEISR == 0				;This part of code is needed only if RTC seats on
											; a shared bus
				TST.B	&TxBufLen			;Is the buffer empty?
				JZ		RTCChkExit			;Yes => Just return to the dispatcher
				INCD	SP					;Remove the return to caller address to act as an
											; interrupt service routine
				BIT		#FLG_Abord,&RTCFlags;Do we have an incomplete command in buffer?
				JNZ		RTCTx_Discard		;Yes => Discard data
				JMP		RTCTx_New			;Aquire the bus and send a byte from the buffer
			.endif

RTCChkExit:	RET								;else, Return to calling dispatcher
;-------------------------------------------

InitRTCPorts:
; Configures the ports that the Real Time Clock chip is connected to, according to the
; definitions at the top of the file
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RTC_ALL, RTC_CLK, _RTC_CS, _RTC_IRQ, RTCClkPort, RTCCLKSEL, RTCCTLDIR,
;						RTCCTLREN, RTCCTLOUT, RTCINTDIR, RTCINTIES, RTCINTIFG, RTCINTOUT,
;						_RTCIntPort, RTCINTREN, RTCSEL
; Depend On Vars:		None
; Depend On Funcs:		None
			BIS.B	#RTC_ALL,&RTCSEL		;All bits of RTC data port belong to USCI module
		.if $defined("RTCClkPort")			;If clock port is different from the data port
			BIS.B	#RTC_CLK,&RTCCLKSEL		;it should be set as special function, too
		.endif
			BIS.B	#_RTC_CS,&RTCCTLDIR		;Chip select pin is Output
		.if $defined("_RTCIntPort")			;If the interrupt port is different then
			BIC.B	#_RTC_IRQ,&RTCINTDIR		;explicitly define this pin as input
			BIS.B	#_RTC_IRQ,&RTCINTREN		;Enable the resistor of IRQ pin
			BIS.B	#_RTC_IRQ,&RTCINTOUT		;And make the resistor a pull-up one
		.else								;else, we can use only one command to set these
			BIC.B	#_RTC_IRQ,&RTCCTLDIR		;pins as inputs
			BIS.B	#_RTC_IRQ,&RTCCTLREN		;and enable their internal resistors
			BIS.B	#_RTC_IRQ,&RTCCTLOUT		;Make the IRQ resistor a pull-up one
		.endif
			BIS.B	#_RTC_IRQ,&RTCINTIES		;Trigger interrupt on falling edge of IRQ
			BIC.B	#_RTC_IRQ,&RTCINTIFG		;Clear any pending interrupt flag
			BIS.B	#_RTC_CS,&RTCCTLOUT		;Raise CS to deactivate RTC bus
			RET
;-------------------------------------------

InitRTCUSC:
; RTC is communicating with the processor through a serial SPI bus. This function initialises
; the USC module the RTC is connected to, as SPI at 4 MHz clock
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RTCBAUD, RTCBR0, RTCBR1, RTCCTL0, RTCCTL1, RTCMCTL
; Depend On Vars:		None
; Depend On Funcs:		None
			BIS.B	#UCSWRST,&RTCCTL1		;Reset and hold UCSI of touchscreen controller
			MOV.B	#UCMSB+UCMST+UCSYNC,&RTCCTL0 ; UCCKPH = 0 for sampling at falling
				; edge of CLK, UCCKPL = 0 for keeping low CLK when bus is inactive,
				; UCMSB = 1 for sending MSB first, UC7BIT = 0 for using 8 bit transactions
				; UCMST = 1 for MSP being a SPI Master, UCMODEx = 00 for 3-wire bus and
				; UCSYNC = 1 because SPI is always synchronous bus
			MOV.B	#UCSSEL1+UCSWRST,&RTCCTL1	;Still in reset mode, SMCLK clocks the module
			MOV.B	#(RTCBAUD >> 8),&RTCBR1	;Set the Baud Rate to 2.5MHz
			MOV.B	#(RTCBAUD & 0FFh),&RTCBR0
			MOV.B	#00000h,&RTCMCTL		;In SPI no modulation control is allowed
			
			BIC.B	#UCSWRST,&RTCCTL1		;Let UCSI run
			RET
;-------------------------------------------

InitRTCSys:
; RTC subsystem uses some variables to achieve its goal. Some of them must be initialised
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		RTCFlags, RxBufLen, RxBufStrt, TxBufLen, TxBufStrt, ServePtr
; Depend On Funcs:		None
			MOV.B	#000h,&RxBufStrt		;Receive buffer start pointer to the beginning
			MOV.B	#000h,&RxBufLen			;No data written in receive buffer
			MOV.B	#000h,&TxBufStrt		;Transmit buffer start pointer to the beginning
			MOV.B	#000h,&TxBufLen			;No data written in transmit buffer
			MOV.B	#000h,&ServePtr			;Pointer fo data storage during alarm serving
			MOV		#00000h,&RTCFlags		;Reset all flags
			RET
;-------------------------------------------

RTCEnableInts:
; Enables all the interrupts associated with RTC's functionality. These are: Interrupt for
; sending and receiving data and port interrupt for Alarm IRQ. The GIE bit is not controlled
; by this function
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		_RTC_IRQ, RTCINTIE, RTCINTIFG, RTCIE, RTCRXIE
; Depend On Vars:		None
; Depend On Funcs:		None
			BIS.B	#RTCRXIE,&RTCIE			;Enable SPI Rx interrupts
;			BIC.B	#_RTC_IRQ,&RTCINTIFG		;Reset any pending Alarm Interrupt
;			BIS.B	#_RTC_IRQ,&RTCINTIE		;Enable Alarm Interrupt
			RET
;-------------------------------------------


RTCDisableInts:
; Disables all the interrupts associated with RTC's functionality
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		_RTC_IRQ, RTCINTIE, RTCINTIFG, RTCIE, RTCRXIE
; Depend On Vars:		None
; Depend On Funcs:		None
			BIC.B	#RTCRXIE,&RTCIE			;Disable SPI interrupts (only Rx. Tx will be
											; disabled when it finishes sending data)
			BIC.B	#_RTC_IRQ,&RTCINTIE		;Disable Alarm interrupts
			BIC.B	#_RTC_IRQ,&RTCINTIFG		;and reset any pending Alarm Interrupt
			RET
;-------------------------------------------

RTCEnableAlarmInt:
; Enables RTC Alarm interrupt
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		_RTC_IRQ, RTCINTIE, RTCINTIFG
; Depend On Vars:		None
; Depend On Funcs:		None
			BIC.B	#_RTC_IRQ,&RTCINTIFG		;Clear any pending interrupt by RTC Alarm
			BIS.B	#_RTC_IRQ,&RTCINTIE		;Enable Alarm Interrupt
			RET
;-------------------------------------------

RTCDisableAlarmInt:
; Disables the RTC Alarm interrupt
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		_RTC_IRQ, RTCINTIE
; Depend On Vars:		None
; Depend On Funcs:		None
			BIC.B	#_RTC_IRQ,&RTCINTIE		;Disable Alarm interrupts
			RET
;-------------------------------------------

RTCSchedule:
; Schedules a byte to be sent to the Real Time Clock by storing it in Transmit Buffer.
; Input:				R4 contains the byte to be scheduled
; Output:				Carry Flag is cleared on success, or set if transmition buffer is full
;                       or even when there is a complete command in transmition buffer, so no
;						new command can be scheduled
; Registers Used:		R4, R5
; Registers Altered:	R5 may contain the offset of the byte used for storage
; Stack Usage:			2 bytes for storing SFR
; Depend On Defs:		_RTC_CS, RTCCTLOUT, RTCIE, RTCIFG, RTCTXBUF, _RTCTXBUFLEN, RTCTXIE
; Depend On Vars:		TxBufLen, TxBufStrt, RTCTxCBuf
; Depend On Funcs:		None
			CMP.B	#_RTCTXBUFLEN,&TxBufLen	;Is there space in the buffer?
			JHS		RS_NoRoom				;No => then exit... (Carry is already set)
			BIT		#FLG_CmdOK,&RTCFlags	;Is there another complete command in buffer?
			SETC							;Flag the possible error for output (Does not
											; affect Z Flag)
			JNZ		RS_NoRoom				;Yes => then exit with carry flag set
			BIS		#FLG_InCmd,&RTCFlags	;Flag there's a command scheduling in progress
			PUSH	SR						;Need to keep interrupt flag unaffected, so store
											; its state
			DINT							;Disable interrupts in case there is a transmit
											; interrupt during the buffer filling
RS_Store:	MOV.B	&TxBufLen,R5			;Get the current length of stream
			ADD.B	&TxBufStrt,R5			;Add the starting offset of the data
			CMP.B	#_RTCTXBUFLEN,R5			;Did the pointer passed the end of buffer?
			JL		RS_NoRvt				;No => Do not revert the pointer
			SUB.B	#_RTCTXBUFLEN,R5			;else, revert the pointer to the beginning of
											; Transmit circular buffer
RS_NoRvt:	MOV.B	R4,RTCTxCBuf(R5)		;Insert the byte in the buffer
			INC.B	&TxBufLen				;Increment the length of data stored in stream
			POP		SR
			CLRC							;Clear carry to flag success
RS_NoRoom:	RET
;-------------------------------------------

RTCSend:
; Completes a prescheduled command and starts its transmition. RTC separeates consecutive
; commands by using CS pin. In order to be able to transfer a full command to RTC chip and use
; CS pulses correctly, the command has to be prescheduled. This means that every single byte
; in the command must be scheduled 
; Input:				R4 contains the byte to be scheduled
; Output:				Carry Flag is cleared on success, or set if transmition buffer is full
;                       or even when there is a complete command in transmition buffer, so no
;						new command can be scheduled
; Registers Used:		R4, R5
; Registers Altered:	R4 may contain the first byte to be sent
;						R5 may contain the offset of the byte used for storage
; Stack Usage:			4 bytes (maximum when calling RTCSchedule)
; Depend On Defs:		FLG_CmdOK, FLG_InCmd, _RTC_CS, RTCCTLOUT, RTCFlags, RTCIE, RTCIFG,
;						RTCTXBUF, _RTCTXBUFLEN, RTCTXIE, SINGLEISR
; Depend On Vars:		RTCTxCBuf, TxBufLen, TxBufStrt
; Depend On Funcs:		RTCSchedule
			CALL	#RTCSchedule			;Schedule the byte to be transmitted later
			JC		RS_SndEnd				;Not successful => Exit with Carry flag set
			BIS		#FLG_CmdOK,&RTCFlags	;Flag that this is a complete command
			BIC		#FLG_InCmd,&RTCFlags	;Command is compete, so not in progress :)
			BIS.B	#RTCTXIE,&RTCIE			;Enable bus interrupt. It will handle data sending
RS_SndOK:	CLRC							;Clear carry flag to signal success
RS_SndEnd:	RET
;-------------------------------------------

RTCReceive:
; Fetches one byte from the receiving cyclic buffer
; Input:				None
; Output:				R4 contains the byte fetched
;						Carry flag shows if the data is correct or the buffer was empty:
;							0: R4 data is valid
;							1: Receiving buffer is empty, no data to fetch
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		_RTCRXBUFLEN
; Depend On Vars:		RxBufLen, RxBufStrt, RTCRxCBuf
; Depend On Funcs:		None
			CMP.B	#000h,&RxBufLen			;Is the receiving buffer empty?
			SETC							;Need to set carry flag in case of empty buffer
			JEQ		RR_Empty				;Yes => Exit with carry flag set
			MOV.B	&RxBufStrt,R4			;Get the offset of the first byte in the stream
			CMP.B	#_RTCRXBUFLEN-1,R4		;Is it at the final position?
			MOV.B	RTCRxCBuf(R4),R4		;Get the byte stored there (Flags are not affected
											; by this command)
			JEQ		RR_RvtStrt
			INC.B	&RxBufStrt				;Point to next position in buffer
RR_ExitOK:	DEC.B	&RxBufLen				;One byte less in the stream
			CLRC
RR_Empty:	RET
RR_RvtStrt:	MOV.B	#000h,&RxBufStrt		;Buffer is reverted to the beginning
			JMP		RR_ExitOK
;-------------------------------------------

RTCWaitData:
; Blocks the main thread until RTC SPI command is completed
; NOTE: INTERRUPTS MUST BE ENABLED IN ORDER TO SERVICE SPI!
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		_RTC_CS, RTCCLTOUT
; Depend On Vars:		TxBufLen
; Depend On Funcs:		None
			CMP.B	#000h,&TxBufLen				;Is the buffer free?
			JNZ		RTCWaitData					;No => Wait until it is
RTCWaitBus:	BIT.B	#_RTC_CS,&RTCCTLOUT			;Is the SPI bus active for RTC?
			JZ		RTCWaitBus					;Yes => Wait until is finished exchanging data
			RET
;-------------------------------------------

RTCIsBusy:
; Checks if the SPI bus is busy for RTC. It is non blocking function
; Input:				None
; Output:				Zero flag contains the status of SPI Busy: 0: Is free, 1: Is Busy
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		_RTC_CS, RTCCLTOUT
; Depend On Vars:		TxBufLen
; Depend On Funcs:		None
			CMP.B	#000h,&TxBufLen				;Is the buffer free?
			JNZ		RTCBusy						;No => Exit with Zero Flag set (Busy)
			BIT.B	#_RTC_CS,&RTCCTLOUT			;Is the SPI bus active for RTC?
RTCBusy:	RET									;Return the status, Zero flag reflects the
												; status needed
;-----------------------------------------------

RTCReadAll:
; Fetches all the RTC memory. If the command succeedes it will return with carry flag cleared.
; Just after the return of this command a burst of data through SPI starts.
; Input:				None
; Output:				Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCSchedule and RTCSend), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (used by RTCMultiReadVars)
; Depend On Defs:		RTC_cS
; Depend On Vars:		None
; Depend On Funcs:		RTCMultiReadVars
			MOV.B	#RTC_cS,R4				;Going to read the whole RTC memory map
			MOV.B	#MAXSERVEPTR,R6		;Going to read bytes to fill the complete RTC
											; memory
;			JMP		RTCMultiReadVars		;RTCMultiReadVars follows, so no need to execute
											; this jump command
;-------------------------------------------

RTCMultiReadVars:
; Fetches data from RTC memory. If the command succeedes it will return with carry flag
; cleared. Just after the return of this command a burst of data through SPI starts.
; Input:				R4 contains the Read command to be issued
;						R6 contains the number of bytes to be read from RTC (without the dummy
;						one because of the Command byte itself)
; Output:				Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCSchedule and RTCSend), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (6 used by RTCMultiReadData)
; Depend On Defs:		FLG_Vars
; Depend On Vars:		RTCFlags, TxBufLen
; Depend On Funcs:		RTCMultiReadData
			CMP.B	#000h,&TxBufLen			;Is the buffer empty?
			JNZ		RMVExit					;No => Do not try to send anything, bus is in use
			PUSH	SR						;Need to store interrupt enable bit
			DINT							;Disable interrupts for not interrupting the
											; scheduling
			BIS		#FLG_Vars,&RTCFlags		;Data read must be stored to their propper vars
			JMP		RTCMultiReadCont		;Skip storing again interrupt status in stack
;-------------------------------------------

RTCMultiReadData:
; Fetches all the RTC memory. If the command succeedes it will return with carry flag cleared.
; Just after the return of this command a burst of data through SPI starts.
; Input:				R4 contains the Read command to be issued
;						R6 contains the number of bytes to be read from RTC (without the dummy
;						one because of the Command byte itself)
; Output:				Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCSchedule and RTCSend), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for SFR, 2 for calling RTCSchedule/RTCSend and 4 by
;						RTCSend)
; Depend On Defs:		FLG_Vars
; Depend On Vars:		RTCFlags, TxBufLen
; Depend On Funcs:		RTCSchedule, RTCSend
			PUSH	SR						;Need to store interrupt enable bit
			DINT							;Disable interrupts for not interrupting the
											; scheduling
RTCMultiReadCont:
			CALL	#RTCSchedule			;Send this Read command to RTC
			JC		RA_Fail					;If there is another command in transmition, do
											; not do anything, just exit
			MOV.B	#000h,R4				;Next bytes just create the clock pulses
RA_NxtData:	DEC.B	R6						;One byte less to read
			JZ		RA_Last
			CALL	#RTCSchedule			;Send one dummy byte
			JC		RA_RollBack				;In case of error just abord sending command
			JMP		RA_NxtData				;Repeat until all dummy bytes have been sent
RA_Last		CALL	#RTCSend				;Send the whole command
			JC		RA_RollBack				;In case of error exit. Abord flag is set
			POP		SR						;Restore flags (especially needed GIE)
			CLRC							;Flag success
RMVExit:	RET								;and exit to caller
RA_RollBack:
			MOV.B	#000h,&TxBufLen			;Nothing to send
RA_Fail:	BIC		#FLG_Vars,&RTCFlags		;Reset flags for storing data directly into vars
			POP		SR						;Restore flags (especially needed GIE)
			SETC							;Flag the failure
			RET
;-------------------------------------------

RTCReadCmd:
; Issues a Read command to RTC through SPI. The function uses blocking mode, meaning that it
; waits until the responce is fetched from RTC.
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCSchedule and RTCSend), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			10 bytes (2 for calling RTCMultiReadData and 8 by the latter)
; Depend On Defs:		None
; Depend On Vars:		TxBufLen
; Depend On Funcs:		RTCReceive, RTCSchedule, RTCSend
			CMP.B	#000h,&TxBufLen			;Is the buffer empty?
			JNZ		RCmdExit				;No => Do not try to send anything, bus is in use
			MOV.B	#001h,R6				;Only one byte should be received
			CALL	#RTCMultiReadData		;Read all needed data into receiving buffer
			JC		RCmdExit				;Error => Exit
RCmdWait:	CMP.B	#000h,&TxBufLen			;Wait until the transmition buffer is empty
			JNZ		RCmdWait
			CALL	#RTCReceive				;Read the responce of the issued command
RCmdExit:	RET								;Return to caller
;-------------------------------------------

RTCReadCmdVar:
; Issues a Read command to RTC through SPI. The function uses blocking mode, meaning that it
; waits until the responce is fetched from RTC. The value read is stored directly to its
; associated variable
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCSchedule and RTCSend), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			10 bytes (2 for calling RTCMultiReadVars and 8 by the latter)
; Depend On Defs:		None
; Depend On Vars:		TxBufLen
; Depend On Funcs:		RTCReceive, RTCSchedule, RTCSend
			CMP.B	#000h,&TxBufLen			;Is the buffer empty?
			JNZ		RCmdVExit				;No => Do not try to send anything, bus is in use
			MOV.B	#001h,R6				;Only one byte should be received
			CALL	#RTCMultiReadVars		;Read all needed data into variableS space
			JC		RCmdVExit				;Error => Exit
RCmdVWait:	CMP.B	#000h,&TxBufLen			;Wait until the transmition buffer is empty
			JNZ		RCmdVWait
			CLRC							;Flag success
RCmdVExit:	RET								;Return to caller
;-------------------------------------------

RTCReadcSecs:
; Issues a Read CentiSeconds command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_cS
; Depend On Vars:		CentiSecs
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastcSecs
			MOV		#RTC_cS,R4				;Going to issue RTC_cS command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastcSecs		;Since RTCReadLastcSecs follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastcSecs:
; Returns the value of centiseconds register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC CentiSeconds
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		CentiSecs
; Depend On Funcs:		None
			MOV.B	&CentiSecs,R4			;Get the necessary variable
			RET
;-------------------------------------------

RTCSetcSecs:
; Sends the command to RTC that sets the CentiSeconds
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_cS
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_cS,R4				;Prepare the command to be sent to RTC
;			JMP		RTCWriteCmd				;Issue Write command. SInce RTCWriteCmd follows
											; there is no need to execute a jump to it
;-------------------------------------------

RTCWriteCmd:
; Sends a command to RTC. The command can have only one byte for data to be send
; Input:				R4 contains the command to be send
;						R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes (6 for storing registers, 2 for calling RTCSchedule/RTCSend
;						and 4 by RTCSend)
; Depend On Defs:		RTC_Status, RTC_Write
; Depend On Vars:		CentiSecs, TxBufLen
; Depend On Funcs:		RTCSchedule, RTCSend
			CMP.B	#000h,&TxBufLen			;Is the bus in use?
			JNZ		RTCSS_Out				;Yes => exit without doing anything, carry is set
			PUSH	R4						;Store registers
			PUSH	R6
			PUSH	SR						;Store interrupts state
			DINT							;Disable interrupts. No one should alter the
											; command scheduling
			BIS.B	#RTC_Write,R4			;Set the Write bit of the command
			CALL	#RTCSchedule			;Start scheduling a command
			JC		RTCSS_Exit				;Problem? => exit with carry flag set
			MOV.B	R6,R4					;Get the value needed
			CALL	#RTCSend				;Send this byte and start transmition
			JC		RTCSS_Fail				;Everything OK? => Exit. Carry flag is cleared
			POP		SR						;Restore interrupts
			CLRC							;Clear carry to flag success
			POP		R6						;Restore registers
			POP		R4
			MOV.B	R6,CentiSecs(R4)		;Store the new value to the associated variable
			RET								;Return to caller
RTCSS_Fail:	MOV.B	#000h,&TxBufLen			;Set that the buffer is empty.
RTCSS_Exit:	POP		SR						;Restore interrupts state
			SETC							;Set carry to flag failure
			POP		R6						;Restore registers
			POP		R4
RTCSS_Out:	RET								;and return to caller
;-------------------------------------------

RTCReadSecs:
; Issues a Read Seconds command to RTC through SPI. The function uses blocking mode, meaning
; that it waits until the responce is fetched from RTC. If there is an error issuing the
; command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Secs
; Depend On Vars:		Seconds
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastSecs
			MOV		#RTC_Secs,R4			;Going to issue RTC_Secs command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastSecs			;Since RTCReadLastSecs follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastSecs:
; Returns the value of Seconds register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Seconds
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		Seconds
; Depend On Funcs:		None
			MOV.B	&Seconds,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetSecs:
; Sends the command to RTC that sets the Seconds
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Secs
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Secs,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Issue Write command
;-------------------------------------------

RTCReadMins:
; Issues a Read Minutes command to RTC through SPI. The function uses blocking mode, meaning
; that it waits until the responce is fetched from RTC. If there is an error issuing the
; command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Mins
; Depend On Vars:		Minutes
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastMins
			MOV		#RTC_Mins,R4			;Going to issue RTC_Mins command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastMins			;Since RTCReadLastMins follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastMins:
; Returns the value of Minutes register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Minutes
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		Minutes
; Depend On Funcs:		None
			MOV.B	&Minutes,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetMins:
; Sends the command to RTC that sets the Minutes
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Mins
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Mins,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Issue Write command
;-------------------------------------------

RTCReadHours:
; Issues a Read Hours command to RTC through SPI. The function uses blocking mode, meaning
; that it waits until the responce is fetched from RTC. If there is an error issuing the
; command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Hours
; Depend On Vars:		Hours
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastHours
			MOV		#RTC_Hours,R4			;Going to issue RTC_Hours command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastHours			;Since RTCReadLastHours follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastHours:
; Returns the value of Hours register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Hours
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		Hours
; Depend On Funcs:		None
			MOV.B	&Hours,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetHours:
; Sends the command to RTC that sets the Hours
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Hours
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Hours,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Issue Write command
;-------------------------------------------

RTCReadWeekDay:
; Issues a Read Day Of Week command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Day
; Depend On Vars:		DayOfWeek
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastWeekDay
			MOV		#RTC_Day,R4				;Going to issue RTC_Day command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastWeekDay		;Since RTCReadLastWeekDay follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastWeekDay:
; Returns the value of WeekDay register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC WeekDay
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		WeekDay
; Depend On Funcs:		None
			MOV.B	&WeekDay,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetWeekDay:
; Sends the command to RTC that sets the Week's Day
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Day
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Day,R4				;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC.
;-------------------------------------------

RTCReadDate:
; Issues a Read Date command to RTC through SPI. The function uses blocking mode, meaning
; that it waits until the responce is fetched from RTC. If there is an error issuing the
; command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Date
; Depend On Vars:		Date
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastDate
			MOV		#RTC_Date,R4			;Going to issue RTC_Date command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastDate			;Since RTCReadLastDate follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastDate:
; Returns the value of Date register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Date
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		Date
; Depend On Funcs:		None
			MOV.B	&Date,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetDate:
; Sends the command to RTC that sets the Date of Month
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Date
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Date,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC.
;-------------------------------------------

RTCReadMonCent:
; Issues a Read Month/Century command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_MonCent
; Depend On Vars:		Month
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastMonCent
			MOV		#RTC_MonCent,R4			;Going to issue RTC_Date command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastDate			;Since RTCReadLastMonCent follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastMonCent:
; Returns the value of Month/Century register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Month/Century
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		Month
; Depend On Funcs:		None
			MOV.B	&Month,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetMonCent:
; Sends the command to RTC that sets the Month/Century
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_MonCent
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_MonCent,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC.
;-------------------------------------------

RTCReadYear:
; Issues a Read Year command to RTC through SPI. The function uses blocking mode,meaning that
; it waits until the responce is fetched from RTC. If there is an error issuing the command to
; RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Year
; Depend On Vars:		Year
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastYear
			MOV		#RTC_Year,R4			;Going to issue RTC_Year command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastYear			;Since RTCReadLastYear follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastYear:
; Returns the value of Year register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Year
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		Year
; Depend On Funcs:		None
			MOV.B	&Year,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetYear:
; Sends the command to RTC that sets the Year
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Year
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Year,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC.
;-------------------------------------------

RTCReadAlmcSecs:
; Issues a Read Alarm's CentiSeconds command to RTC through SPI. The function uses blocking
; mode, meaning that it waits until the responce is fetched from RTC. If there is an error
; issuing the command to RTC, the return value contains the last read value and the carry flag
; is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_cSAlm
; Depend On Vars:		AlmCentiSecs
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastAlmcSecs
			MOV		#RTC_cSAlm,R4			;Going to issue RTC_cSAlm command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastAlmcSecs		;Since RTCReadLastAlmcSecs follows there is no
											; need to jump there
;-------------------------------------------

RTCReadLastAlmcSecs:
; Returns the value of Alarm's centiseconds register read earlier. Does not issue a new read
; command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Alarm's CentiSeconds
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		AlmCentiSecs
; Depend On Funcs:		None
			MOV.B	&AlmCentiSecs,R4		;Get the necessary variable
			RET
;-------------------------------------------

RTCSetAlmcSecs:
; Sends the command to RTC that sets the Alarm's CentiSeconds
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_cSAlm
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_cSAlm,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Issue Write command.
;-------------------------------------------

RTCReadAlmSecs:
; Issues a Read Alarm's Seconds command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_SecsAlm
; Depend On Vars:		AlmSeconds
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastAlmSecs
			MOV		#RTC_SecsAlm,R4			;Going to issue RTC_SecsAlm command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastAlmSecs		;Since RTCReadLastAlmSecs follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastAlmSecs:
; Returns the value of Alarm's Seconds register read earlier. Does not issue a new read
; command to RTC
; Input:				None
; Output:				R4 contains the value of RTC Alarm's Seconds
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		AlmSeconds
; Depend On Funcs:		None
			MOV.B	&AlmSeconds,R4			;Get the necessary variable
			RET
;-------------------------------------------

RTCSetAlmSecs:
; Sends the command to RTC that sets the Alarm's Seconds
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_SecsAlm
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_SecsAlm,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Issue Write command
;-------------------------------------------

RTCReadAlmMins:
; Issues a Read Alarm's Minutes command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_MinsAlm
; Depend On Vars:		AlmMinutes
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastAlmMins
			MOV		#RTC_MinsAlm,R4			;Going to issue RTC_MinsAlm command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastAlmMins		;Since RTCReadLastAlmMins follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastAlmMins:
; Returns the value of Alarm's Minutes register read earlier. Does not issue a new read
; command to RTC
; Input:				None
; Output:				R4 contains the value of RTC Alarm's Minutes
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		AlmMinutes
; Depend On Funcs:		None
			MOV.B	&AlmMinutes,R4			;Get the necessary variable
			RET
;-------------------------------------------

RTCSetAlmMins:
; Sends the command to RTC that sets the Alarm's Minutes
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_MinsAlm
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_MinsAlm,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Issue Write command
;-------------------------------------------

RTCReadAlmHours:
; Issues a Read Alarm's Hours command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_HoursAlm
; Depend On Vars:		AlmHours
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastAlmHours
			MOV		#RTC_HoursAlm,R4		;Going to issue RTC_HoursAlm command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastAlmHours		;Since RTCReadLastAlmHours follows there is no
											; need to jump there
;-------------------------------------------

RTCReadLastAlmHours:
; Returns the value of Alarm's Hours register read earlier. Does not issue a new read command
; to RTC
; Input:				None
; Output:				R4 contains the value of RTC Alarm's Hours
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		AlmHours
; Depend On Funcs:		None
			MOV.B	&AlmHours,R4			;Get the necessary variable
			RET
;-------------------------------------------

RTCSetAlmHours:
; Sends the command to RTC that sets the Alarm's Hours
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_HoursAlm
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_HoursAlm,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Issue Write command
;-------------------------------------------

RTCReadAlmDayDate:
; Issues a Read Alarm's Day/Date command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_DayDateAlm
; Depend On Vars:		AlmDayDate
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastAlmDayDate
			MOV		#RTC_DayDateAlm,R4		;Going to issue RTC_DayDateAlm command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastAlmDayDate	;Since RTCReadLastAlmDayDate follows there is no
											; need to jump there
;-------------------------------------------

RTCReadLastAlmDayDate:
; Returns the value of Alarm's Day/Date register read earlier. Does not issue a new read
; command to RTC
; Input:				None
; Output:				R4 contains the value of RTC Alarm's Day/Date
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		AlmDayDate
; Depend On Funcs:		None
			MOV.B	&AlmDayDate,R4			;Get the necessary variable
			RET
;-------------------------------------------

RTCSetAlmDayDate:
; Sends the command to RTC that sets the Alarm's Day/Date
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_DayDateAlm
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_DayDateAlm,R4		;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC.
;-------------------------------------------

RTCReadCtrl:
; Issues a Read Control command to RTC through SPI. The function uses blocking mode, meaning
; that it waits until the responce is fetched from RTC. If there is an error issuing the
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Control
; Depend On Vars:		ControlReg
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastCtrl
			MOV		#RTC_Control,R4			;Going to issue RTC_Control command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastCtrl			;Since RTCReadLastCtrl follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastCtrl:
; Returns the value of Control register read earlier. Does not issue a new read command to RTC
; Input:				None
; Output:				R4 contains the value of RTC Control register
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		ControlReg
; Depend On Funcs:		None
			MOV.B	&ControlReg,R4			;Get the necessary variable
			RET
;-------------------------------------------

RTCSetCtrl:
; Sends the command to RTC that sets the control register
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Control
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Control,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC
;-------------------------------------------

RTCReadStatus:
; Issues a Read Status command to RTC through SPI. The function uses blocking mode, meaning
; that it waits until the responce is fetched from RTC. If there is an error issuing the
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Status
; Depend On Vars:		StatusReg
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastStatus
			MOV		#RTC_Status,R4			;Going to issue RTC_Status command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastStatus		;Since RTCReadLastStatus follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastStatus:
; Returns the value of Status register read earlier. Does not issue a new read command to RTC
; Input:				None
; Output:				R4 contains the value of RTC Status register
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		StatusReg
; Depend On Funcs:		None
			MOV.B	&StatusReg,R4			;Get the necessary variable
			RET
;-------------------------------------------

RTCSetStatus:
; Sends the command to RTC that sets the status register
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Status
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Status,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC.
;-------------------------------------------

RTCReadChrg:
; Issues a Read Trickle Charger command to RTC through SPI. The function uses blocking mode,
; meaning that it waits until the responce is fetched from RTC. If there is an error issuing
; the command to RTC, the return value contains the last read value and the carry flag is set
; NOTE: The function expects GIE to be enabled (and SPI interrupts for RTC)
; Input:				R4 contains the command to be sent to RTC
; Output:				R4 contains the byte received as a responce
;						Carry flag is cleared on success, set on failure
; Registers Used:		R4, R5 (through RTCReadCmdVar), R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for calling RTCReadCmdVar and 6 more used by the latter)
; Depend On Defs:		RTC_Charger
; Depend On Vars:		Charger
; Depend On Funcs:		RTCReadCmdVar, RTCReadLastChrg
			MOV		#RTC_Charger,R4			;Going to issue RTC_Charger command
			CALL	#RTCReadCmdVar			;Send the command and fetch the result
;			JMP		RTCReadLastChrg			;Since RTCReadLastChrg follows there is no need
											; to jump there
;-------------------------------------------

RTCReadLastChrg:
; Returns the value of Trickle Charger register read earlier. Does not issue a new read
; command to RTC
; Input:				None
; Output:				R4 contains the value of RTC Trickle Charger register
; Registers Used:		R4
; Registers Altered:	R4
; Stack Usage:			None
; Depend On Defs:		None
; Depend On Vars:		Charger
; Depend On Funcs:		None
			MOV.B	&Charger,R4				;Get the necessary variable
			RET
;-------------------------------------------

RTCSetChrg:
; Sends the command to RTC that sets the trickle charger register
; Input:				R6 contains the value to be written to RTC
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5 and R6 (used by RTCSchedule/RTCSend)
; Registers Altered:	R5
; Stack Usage:			12 bytes by RTCWriteCmd
; Depend On Defs:		RTC_Charger
; Depend On Vars:		None
; Depend On Funcs:		RTCWriteCmd
			MOV.B	#RTC_Charger,R4			;Prepare the command to be sent to RTC
			JMP		RTCWriteCmd				;Send the command to RTC
;-------------------------------------------

ReadTimeStr:
; Reads the time from RTC and returns an ASCII string of specified length
; Input:				R14	contains the maximum number of bytes available in the target
;							buffer
;						R15 points to the buffer that the string will be stored
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5, R6, R7, R14, R15 (the latter three from ReadLastTimeStr)
; Registers Altered:	R4, R5, R6, R7, R14, R15 (the latter three from ReadLastTimeStr)
; Stack Usage:			8 bytes (2 for CALL and 6 by RTCMultiReadVars)
; Depend On Defs:		RTC_cS
; Depend On Vars:		None
; Depend On Funcs:		ReadLastTimeStr, RTCMultiReadVars
			MOV.B	#RTC_cS,R4				;Going to read all time, even centiseconds
			MOV.B	#004h,R6				; up to hours inclusive
			CALL	#RTCMultiReadVars		;Send this Read command to RTC
			JC		RTS_Fail				;On error exit (Carry flag is set)

ReadLastTimeStr:
; Reads the time from variables without issuing a commans to RTC and returns an ASCII string
; of specified length in a buffer
; Input:				R14	contains the maximum number of bytes available in the target
;							buffer
;						R15 points to the buffer that the string will be stored
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5, R6, R7, R14, R15
; Registers Altered:	R4, R5, R6, R7, R14, R15
; Stack Usage:			None
; Depend On Defs:		RTS_1224Mask
; Depend On Vars:		CentiSecs, Hours
; Depend On Funcs:		None
			MOV.B	#03Fh,R7				;Default hours mask for 24 Hour mode
			BIT.B	#RTC_1224Mask,&Hours	;Is it 24 Hour mode?
			JZ		RTS_MaskOK				;Yes => Skip changing the mask. It is OK
			MOV.B	#01Fh,R7				;Hours mask for 12 Hour mode
RTS_MaskOK:	MOV.B	#':',R6					;Time separator is ':'
			MOV		#Hours-CentiSecs,R5		;Offset in table of variables for hours reading

RTS_NxtVal:	MOV.B	CentiSecs(R5),R4		;Get the value of hours
			AND.B	R7,R4					;Filter only the bits of the mask
			MOV.B	#0FFh,R7				;Do not filter out bits anymore
			RRUM.W	#4,R4					;Bring higher digit to lower nibble, keep leading
											; zeroes
			BIS.B	#030h,R4				;Make it an ASCII digit
			MOV.B	R4,0(R15)				;Store it in memory
			INC		R15						;Advance the target pointer by one
			DEC		R14						;One character less left
			JZ		RTS_Exit				;Out of space? => Just exit with carry cleared

			MOV.B	CentiSecs(R5),R4		;Get again the value to be used
			AND.B	#00Fh,R4				;Filter only the lower nibble
			BIS.B	#030h,R4				;Convert it to ASCII digit
			MOV.B	R4,0(R15)				;Store this value
			INC		R15						;Advance the pointer by one
			DEC		R14						;One digit less
			JZ		RTS_Exit				;Run out of space? => Exit with carry cleared

			CMP.B	#001h,R5				;Did we just stored seconds?
			JNZ		RTS_NoSec				;No => skip changing the separator character
			MOV.B	#'.',R6					;After seconds the separator must be just a dot
RTS_NoSec:	MOV.B	R6,0(R15)				;Store the number separator
			INC		R15
			DEC		R14						;One digit less, again
			JZ		RTS_Exit				;If out of space => Exit with carry cleared

			DEC		R5						;Going to read next value (it is stored in
											; previous variable in memory)
RTS_NocS:	JC		RTS_NxtVal				;Still in variables table limits => Repeat
RTS_Exit:	CLRC							;Clear carry to flag success
RTS_Fail:	RET								;and return to caller
;-------------------------------------------

RTCWriteMulti:
; Writes a whole block of data to RTC.
; Input:				R4 contains the starting register of RTC
;						R14	contains the number of bytes available in the source buffer
;						R15 points to the buffer of the data to be transmitted
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5, R6, R14, R15 (Some used by calling functions)
; Registers Altered:	R4, R5, R6, R14, R15 (R4, R14 and R15 are not altered on failure)
; Stack Usage:			8 bytes (2 for storage, 2 for CALL and 4 by RTCSend)
; Depend On Defs:		MAXSERVEPTR, RTC_Write
; Depend On Vars:		CentiSecs, TxBufLen
; Depend On Funcs:		RTCSchedule, RTCSend
			CMP.B	#000h,&TxBufLen			;Test if the RTC bus is not waiting for data
			JNZ		RWM_Exit				;If yes => Bus is in use, just exit
			PUSH	R4						;Store these registers for later
			PUSH	R14
			PUSH	R15
			PUSH	SR						;Store interrupts status
			DINT							;Disable interrupts. No one should disturb the
											; scheduling of the command to be sent
			BIS.B	#RTC_Write,R4			;Make it a Write command
			CALL	#RTCSchedule			;Schedule the first byte of it
			JC		RWM_Fail				;On error, just exit with carry flag set
RWM_Next:	MOV.B	@R15+,R4				;Get one byte from the source buffer and advance
											; the pointer by one
			DEC		R14						;One byte less
			JNC		RWM_Final				;Is it the last one?
			CALL	#RTCSchedule			;No => schedule it
			JC		RWM_Abord				;On error abord sending this command and exit with
											; carry flag set
			JMP		RWM_Next				;Repeat for all bytes in buffer
RWM_Final:	CALL	#RTCSend				;else => finalise the command
			JC		RWM_Abord				;On error abord command sending with carry set
			POP		SR						;Restore interrupts state (Starts a whole burst of
											; data to RTC
			POP		R15						;Also restore registers
			POP		R14
			POP		R4
RWM_NxtUpd:	MOV.B	@R15+,CentiSecs(R4)		;Move one byte to local variables
			INC.B	R4						;Advance the target variable to the next one
			CMP.B	#MAXSERVEPTR,R4			;Did we reach the end of variables space?
			JNE		RWM_SkipRvt				;No => Skip reverting to the beginning of space
			MOV.B	#000h,R4				;else, restart from the beginning
RWM_SkipRvt:
			DEC		R14						;One byte less to update
			JNZ		RWM_NxtUpd				;Reached the end? No => update next variable
			CLRC							;Flag success
			RET								;and return to caller
RWM_Abord:	MOV.B	#000h,&TxBufLen			;Buffer does not contain any data
RWM_Fail:	POP		SR						;Restore interrupts
			POP		R15						;Also restore registers
			POP		R14
			POP		R4
			SETC							;Set carry to flag failure
RWM_Exit:	RET								;Return to caller
;-------------------------------------------

RTCSetAlmRate:
; Sets the RTC Alarm variables according to the input value. The input value can be one of the
; predefined public values RTC_ALMRPT*.
; NOTE: This function does not enable alarm interrupt in configuration register. It only
; updates the value of alarm repetition
; Input:				R4 contains the new value for the RTC Alarm Repetition setting
; Output:				Carry flag is creared on success or set on failure
; Registers Used:		R4, R5, R6, R7, R14, R15
; Registers Altered:	R4, R5, R6, R7, R14, R15
; Stack Usage:			8 bytes (2 for push, 2 for CALL and 4 by RTCSend)
; Depend On Defs:		RTC_AlmMask, RTC_cSAlm, RTC_DayDateMask, RTC_Write, _RTCTXBUFLEN
; Depend On Vars:		AlmCentiSecs, AlmSeconds, RTCTxCBuf, TxBufLen, TxBufStrt
; Depend On Constants:	AlmRptTbl
; Depend On Funcs:		RTCSchedule, RTCSend
			MOV.B	AlmRptTbl(R4),R7		;R7 contains the value for 100ths of a second
			MOV.B	AlmRptTbl+1(R4),R6		;R8 contains the value for AMx bits and Day/Date
			MOV.B	#RTC_cSAlm+RTC_Write,R4	;Going to issue a Write to Alarm CentiSeconds cmd
			PUSH	SR						;Keep Interrupts state
			DINT							;Disable interrupts. No one must alter scheduling
			CALL	#RTCSchedule			;Schedule the command
			JC		SAR_Fail				;On error just exit, with carry flag set
			MOV.B	R7,R4					;Send the new centiseconds value
			CALL	#RTCSchedule			;Schedule this value
			JC		SAR_Abord				;On error abord...
			MOV.B	#004h,R14				;Counter of bytes to be manipulated (Only the
											; first three are simple. The fourth needs extra
											; attention as it also contains Day/Date flag)
			MOV		#AlmSeconds,R15			;Point to the first variable containing AMx
SAR_RptAMx:	MOV.B	@R15+,R4				;Get this value (and advance the pointer)
			BIC.B	#RTC_AlmMask,R4			;Clear current mask bit
			RRA		R6						;Value of current AMx bit in carry flag
			JNC		SAR_AMxOK				;If 0 then do not alter it
			BIS.B	#RTC_AlmMask,R4			;else, set it
SAR_AMxOK:	DEC		R14						;One value less
			JZ		SAR_AMxLast				;Last one? => Need extra attention
			CALL	#RTCSchedule			;else, Schedule this register value
			JNC		SAR_RptAMx				;No error => Keep on
SAR_Abord:	MOV.B	#000h,&TxBufLen			;Well, no data available in transimition buffer
SAR_Fail:	POP		SR						;Restore interrupts
			SETC							;Flag the error using Carry flag
			RET								;and return to caller
SAR_AMxLast:
			BIC.B	#RTC_DayDateMask,R4		;Clear Day/Date flag
			RRA		R6						;New Day/Date value in carry flag
			JNC		SAR_Send				;Is it 0 => do not alter it, send the command
			BIS.B	#RTC_DayDateMask,R4		;else set Day/Date bit
SAR_Send:	CALL	#RTCSend				;Complete the command
			JC		SAR_Abord				;On error abord command sending
            ;Since the command is set, (not send yet, because interrupts are still disabled)
			; the transmition buffer contains the whole command and all the new values. These
			; are the last known values of RTC Alarm registers. Simply copy them to the
			; variables space to update those values without having to read them from RTC
			MOV.B	&TxBufStrt,R15			;Get the startng pointer in transmition buffer
			MOV.B	&TxBufLen,R14			;Get the length of data stored there
			MOV		#AlmCentiSecs,R4		;Target pointer to alarm's 100th of seconds
SAR_NxtVal:	INC.B	R15						;The first byte is the command byte and should be
											; skipped, so just advance to next value
			CMP.B	#_RTCTXBUFLEN,R15		;Did we reach the end of buffer
			JLO		SAR_SkipRvt				;No => Skip reverting to its beginning
			MOV.B	#000h,R15				;else, point to the beginning of buffer
SAR_SkipRvt:
			DEC		R14						;One byte less to send
			JZ		SAR_MvDone				;No more values to transfer? => End
			MOV.B	RTCTxCBuf(R15),0(R4)	;Copy one byte ro variables space
			INC		R4						;Advance the target pointer
			JMP		SAR_NxtVal				;Repeat
SAR_MvDone:	POP		SR						;Restore interrupts
			CLRC							;Flag success
			RET								;and exit to caller
;-------------------------------------------

RTCCheckServe:
; Checks the FLG_Serve flag and returns its value. This flag is set when RTC needs attention.
; After reading the flag it resets it
; Input:				None
; Output:				Carry flag is set if FLG_Serve is also set
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		FLG_Serve
; Depend On Vars:		RTCFlags
; Depend On Constants:	None
; Depend On Funcs:		None
			BIT		#FLG_Serve,&RTCFlags	;Carry flag contains the value of Serve flag
			JNC		SrvExit
			CALL	#RTCWaitData			;Ensure there is no data in transfer buffer
			MOV.B	&StatusReg,R6			;Get the status register value
			BIC.B	#RTC_StatAF,R6			;Clear AF flag of status register
			CALL	#RTCSetStatus			;Set the status register new value
			JC		SrvExit					;In case of error, status register could not be
											; changed, so keep the serve flag enabled, but
											; set the system to serve RTC
			BIC		#FLG_Serve,&RTCFlags	;Clear this flag
SrvFail:	SETC
SrvExit:	RET
;-------------------------------------------

RTCCpHour2Alm:
; Copies current time to alarm time (all 5 registers)
; NOTE: Resets the Alarm Mask Bits, so it is necessary to set the alarm repetition time again.
; For that reason the copy is made only in memory variables and the new alarm values are not
; sent to RTC itself!
; Input:				None
; Output:				Carry flag is cleared on success or set on failure
; Registers Used:		R4, R5, R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for CALL and 6 by RTCMultiReadVars)
; Depend On Defs:		RTC_cS
; Depend On Vars:		AlmCentiSecs, CentiSecs
; Depend On Constants:	None
; Depend On Funcs:		RTCMultiReadVars, RTCWaitData, RTCCpLastHour2Alm
			MOV.B	#RTC_cS,R4				;Going to read whole time
			MOV.B	#008h,R6				;8 consecutive registers
			CALL	#RTCMultiReadVars		;Execute the read command
			JC		H2A_Fail				;On error exit with carry flag set
			CALL	#RTCWaitData			;Wait until all data have been received
;			JMP		RTCCpLastHour2Alm		;Since RTCCpLastHour2Alm follows there is no need
											; to execute this jump
;-------------------------------------------

RTCCpLastHour2Alm:
; Copies last read time to alarm time (all 5 registers). It does not issue a read command.
; NOTE: Resets the Alarm Mask Bits, so it is necessary to set the alarm repetition time again.
; For that reason the copy is made only in memory variables and the new alarm values are not
; sent to RTC itself!
; Input:				None
; Output:				Carry flag is cleared on success or set on failure
; Registers Used:		R4, R5, R6
; Registers Altered:	R4, R5, R6
; Stack Usage:			8 bytes (2 for CALL and 6 by RTCMultiReadVars)
; Depend On Defs:		RTC_cS
; Depend On Vars:		AlmCentiSecs, CentiSecs
; Depend On Constants:	None
; Depend On Funcs:		None
			MOV		#CentiSecs,R4			;Going to copy current time...
			MOV		#AlmCentiSecs,R6		;... to Alarm registers
			MOV		#005h,R5				;All 5 alarm registers are going to be copied
H2A_CpNxt:	MOV.B	@R4+,0(R6)				;Copy one byte and advance source pointer
			INC		R6						;Advance destination pointer also
			DEC		R5						;One byte less
			JNZ		H2A_CpNxt				;Repeat for all Alarm registers
			CLRC							;Clear carry to flag success
H2A_Fail:	RET								;and return to caller
;-------------------------------------------


;============================================================================================
; INTERRUPT VECTORS
;--------------------------------------------------------------------------------------------
		.if SINGLEISR == 1
			.sect	RTCTXVECTOR				;Transmit vector for RTC
			.short	RTCTxISR				;Points to the transmit ISR

			.sect	RTCRXVECTOR				;Receive vector for RTC
			.short	RTCRxISR				;Points to the receive ISR
		.endif

			.end
