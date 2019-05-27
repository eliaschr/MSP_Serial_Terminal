;********************************************************************************************
;*                                     Aiolos Project                                       *
;*                             MSP Hydro and Temperature Meter                              *
;********************************************************************************************
;* Real Time Clock handling for Maxim-Dallas DS1390 and compatible ICs.                     *
;* Note that in SPI, when a master transmits a byte it receives one simultaneously          *
;* This library provides functions for interrupts, but it does not bind them to specific    *
;* interrupt vectors. It is assumed that the binding will happen at the main program,       *
;* because the interrupt vectors belonging to USC, Timers or port pins that are shared with *
;* other processes. The interrupts needed are three:                                        *
;********************************************************************************************
			.title	"Aiolos Project: MSP Serial Terminal - Real Time Clock Library"
			.tab	4

			.cdecls C,LIST,"msp430.h"		; Include device header file

;============================================================================================
; DEFINITIONS - This section contains all necessary definition visible only to this file
;--------------------------------------------------------------------------------------------
RS232BUS	.equ	"UCA1"					;The bus used for RS232 communications
RS232TIMER	.equ	"B2"					;Specifies the timer used for waking up the system
											; when in binary mode

;SHAREDBUS	.equ	1						;If RS232 seats on a shared to other peripherals
											; bus this line should be uncommented, else by
											; commenting out this line or by setting it to 0
											; you define that the bus is used only by this
											; peripheral

TXBUFLEN	.equ	32						;The number of bytes in cyclic transmit buffer
RXBUFLEN	.equ	512						;The number of bytes in cyclic receive buffer
RXWAKELIM	.equ	128						;The number of bytes that when the buffer reaches
											; it will wake up the system
;USEACLK	.equ	1						;Define if the clock source is ACLK. If it is 0 or
											; commented out the clock source is SMCLK
DATABITS	.equ	8						;Number of data bits (7 or 8)
PARITY		.equ	"NONE"					;Expresses the parity setting. Can be one of
											; "NONE", "ODD" or "EVEN"
STOPBITS	.equ	1						;Number of stop bits

			.if $isdefed("CPUSMCLK") == 0
CPUSMCLK		.equ	16000000			;The SMCLK clock frequency in Hz
			.endif

			.if $isdefed("CPUACLK") == 0
CPUACLK			.equ	32768				;The ACLK clock frequency in Hz
			.endif

BAUDRATE	.equ	115200					;The Baud Rate needed

			.if $isdefed("TIMERCLK") == 0
TIMERCLK		.equ	32768				;The clock that feeds the timer used by RS232
			.endif

WAKEUPTIME	.equ	10						;The time in serial characters that when idle, the
											; RS232 subsystem wakes up the system to use the
											; received data

;The folowing definition forces the oversampling bit setting in UCAxMCTL register. If it is
; comented out, the preprocessor selects its optimal value
;BROS16		.set	0						;If defined sets UCOS16 bit of UCAxMCTL

;The following definitions if commented out they are calculated by the preprocessor. If they
; are set, no caclulation is done on them. They construct UCAxMCTL's value. None or All must
; be specified
;BRSMOD		.set	0						;If defined sets UCBRSx base value in UCAxMCTL
;BRFMOD		.set	0Bh						;If defined sets UCBRFx base value in UCAxMCTL

;============================================================================================
; AUTO DEFINITIONS - This section contains definitions calculated by preprocessor, mainly
; according to the previously specified ones
;--------------------------------------------------------------------------------------------
;Some definitions necessary to setup the correct bus:
;RS232IN		: The PxIN register of the corresponding port
;RS232OUT		: The PxOUT register of the corresponding port
;RS232DIR		: The PxDIR register of the corresponding port
;RS232REN		: The PxREN register of the corresponding port
;RS232SEL		: The PxSEL register of the corresponding port
;RS232CTL0		: The associated UCAxCTL0 control register
;RS232CTL1		: The associated UCAxCTL1 control register
;RS232BR0		: The associated UCAxBR0 Baud Rate register
;RS232BR1		: The associated UCAxBR1 Baud Rate register
;RS232MCTL		: The associated UCAxMCTL Baud Rate Modulator register
;RS232STAT		: The associated UCAxSTAT Status register
;RS232RXBUF		: The associated UCAxRXBUF Input buffer register
;RS232TXBUF		: The associated UCAxTXBUF Output buffer register
;RS232ABCTL		: The associated UCAxABCTL Automatic baud rate control register
;RS232IRTCLT	: The associated UCAxIRTCTL IR Transmition control register
;RS232IRRCTL	: The associated UCAxIRRCTL IR Receptio control register
;RS232IE		: The associated Interrupt Enable register
;RS232IFG		: The associated Interrupt Status Flag register
;RS232RXD		: Bit mask for RxD pin of RS232
;RS232TXD		: Bit mask for TxD pin of RS232
;RS232TXIE		: Bit mask for Transmit interrupt, Interrupt and Flag registers
;RS232RXIE		: Bit mask for Receive interrupt, Interrupt and Flag registers
;RS232TXVECTOR	: The interrupt vector the transmit ISR belongs to
;RS232RXVECTOR	: The interrupt vector the receive ISR belongs to
;BRx			: Contains the value of Baud Rate Setting registers for the given CPUSMCLK and
;					BAUDRATE definitions

			.if RS232BUS == "UCA0"
RS232IN			.equ	P3IN
RS232OUT		.equ	P3OUT
RS232DIR		.equ	P3DIR
RS232REN		.equ	P3REN
RS232SEL		.equ	P3SEL
RS232CTL0		.equ	UCA0CTL0
RS232CTL1		.equ	UCA0CTL1
RS232BR0		.equ	UCA0BR0
RS232BR1		.equ	UCA0BR1
RS232MCTL		.equ	UCA0MCTL
RS232STAT		.equ	UCA0STAT
RS232RXBUF		.equ	UCA0RXBUF
RS232TXBUF		.equ	UCA0TXBUF
RS232ABCTL		.equ	UCA0ABCTL
RS232IRTCLT		.equ	UCA0IRTCTL
RS232IRRCTL		.equ	UCA0IRRCTL
RS232IE			.equ	IE2
RS232IFG		.equ	IFG2
RS232TXVECTOR	.equ	"USCIAB0TX"
RS232RXVECTOR	.equ	"USCIAB0RX"

RS232RXD		.equ	BIT5
RS232TXD		.equ	BIT4
RS232TXIE		.equ	UCA0TXIE
RS232RXIE		.equ	UCA0RXIE
			.elseif RS232BUS == "UCA1"
RS232IN			.equ	P3IN
RS232OUT		.equ	P3OUT
RS232DIR		.equ	P3DIR
RS232REN		.equ	P3REN
RS232SEL		.equ	P3SEL
RS232CTL0		.equ	UCA1CTL0
RS232CTL1		.equ	UCA1CTL1
RS232BR0		.equ	UCA1BR0
RS232BR1		.equ	UCA1BR1
RS232MCTL		.equ	UCA1MCTL
RS232STAT		.equ	UCA1STAT
RS232RXBUF		.equ	UCA1RXBUF
RS232TXBUF		.equ	UCA1TXBUF
RS232ABCTL		.equ	UCA1ABCTL
RS232IRTCLT		.equ	UCA1IRTCTL
RS232IRRCTL		.equ	UCA1IRRCTL
RS232IE			.equ	UC1IE
RS232IFG		.equ	UC1IFG
RS232TXVECTOR	.equ	"USCIAB1TX"
RS232RXVECTOR	.equ	"USCIAB1RX"

RS232RXD		.equ	BIT7
RS232TXD		.equ	BIT6
RS232TXIE		.equ	UCA1TXIE
RS232RXIE		.equ	UCA1RXIE
			.else
				.emsg	"RS232BUS must be defined as UCA0 or UCA1!"
			.endif

RS232ALL	.equ	RS232RXD+RS232TXD		; Mask bit for both Receive and Transmit pins

			.asg	0,CTL0VAL
			.asg	UCSWRST,CTL1VAL

;Going to construct UCSxCTL0 register's value according to data format specified earlier
			.asg	10,CHARTICKS			;CHARTICKS will hold the total number of bits per
											; RS232 character; one is the Start bit and 8 bits
											; in case 8-bit interface is selected and one stop
											; bit. These make a total of 10
			.if DATABITS == 7
				.asg	(CTL0VAL + UC7BIT),CTL0VAL
				.asg	(CHARTICKS-1),CHARTICKS	;Earlier we used 8 bits of data to CHARTICKS
											; but we use 7. So subtract one
			.elseif DATABITS != 8
				.emsg "DATABITS can be 7 or 8"
			.endif

			.if PARITY == "ODD"
				.asg	(CTL0VAL + UCPEN),CTL0VAL
				.asg	(CHARTICKS +1),CHARTICKS	;Add the parity bit to CHARTICKS
			.elseif PARITY == "EVEN"
				.asg	(CTL0VAL + UCPEN + UCPAR),CTL0VAL
				.asg	(CHARTICKS +1),CHARTICKS	;Add the parity bit to CHARTICKS
			.elseif PARITY != "NONE"
				.emsg "PARITY should be a litteral value NONE, ODD or EVEN"
			.endif

			.if STOPBITS == 2
				.asg	(CTL0VAL + UCSPB),CTL0VAL
				.asg	(CHARTICKS +1),CHARTICKS	;Add the second stop bit to CHARTICKS
			.elseif STOPBITS != 1
				.emsg "STOPBITS can be 1 or 2"
			.endif

;Next try to construct the value of UCAxCTL1 register, according to values specified earlier
			.if $isdefed("USEACLK") == 0
USEACLK			.set	0
			.endif
			.if USEACLK == 1
BRCLK			.set	CPUACLK
				.asg	(CTL1VAL + UCSSEL_1),CTL1VAL
			.elseif USEACLK == 0
BRCLK			.set	CPUSMCLK
				.asg	(CTL1VAL + UCSSEL_2),CTL1VAL
			.else
				.emsg "USEACLK can be undefined, 0 or 1"
			.endif

;Modulation control follows. UCAxBRx value must define the prescaler of clock to create the
; bit clock frequency. If there is oversampling then this register contains 1/16th of the
; normal value. So, the calculations include the setting of oversampling bit in UCAxMCTL
; register
			.asg	(BRCLK/BAUDRATE),BRx	;Normal Baud Rate prescaler setting
;If BROS16 is not defined then we have to calculate it by ourselves. For low frequency bit
; clock this bit should be 0. In case of a high frequecy bit clock if set, this bit devides
; the bit clock by 16. Of cource, if BROS16 is defined we should keep that setting
			.if $isdefed("BROS16") == 0
				.asg	0,BROS16
				.if BRCLK >32768
					.if BRx >= 16
						.asg	1,BROS16
					.endif
				.endif
			.endif

			.if BROS16 == 1
				.asg	(BRCLK / (BAUDRATE *16)),BRx
			.elseif BROS16 != 0
				.emsg	"BROS16 is a bit value. It can be 0 or 1 only"
			.endif

;Lets try to calculate UCBRFx and UCBRSx values. These definitions must be both set, or not
; set. If UCBRFx value is defined then UCBRSx value must also be defined and vice versa
			.asg	2,BRDEFS
			.if $isdefed("BRFMOD") == 0
				.asg	(BRDEFS -1),BRDEFS
			.endif
			.if $isdefed("BRSMOD") == 0
				.asg	(BRDEFS -1),BRDEFS
			.endif

;At this point if BRDEFS is 0, neither UCBRFx nor UCBRSx values are defined (OK). If it is 2
; both definitions are made (OK). If it is 1 then one of the values is not defined while the
; other one is (FAIL)
			.if BRDEFS == 0					;No definitions are made, lets calculate values
				.asg	10000,MODACCURACY
				.asg	(BRCLK*MODACCURACY/BAUDRATE),BRx100
				.asg	(BRx100 - (BRx * MODACCURACY)),BRDOT
				.asg	((BRDOT + 5) *8 / MODACCURACY),BRSMOD
				.asg	0,BRFMOD
				.if BRSMOD == 8
					.asg	7,BRSMOD
				.endif
				.if BROS16 == 1
					.asg	(BRCLK / (BAUDRATE *16)),BRx
					.asg	(BRCLK * MODACCURACY / (BAUDRATE *16)),BRx100
					.asg	(BRx100 - (BRx * MODACCURACY)),BRDOT
					.asg	((BRDOT +5) * 16 / MODACCURACY),BRFMOD
					.if BRFMOD == 16
						.asg	15,BRFMOD
					.endif
					.asg	((16 * BRx + BRFMOD) * MODACCURACY),BRF16
					.asg	((BRCLK * MODACCURACY - BRF16 * BAUDRATE) / BAUDRATE),BRDOT16
					.asg	((BRDOT16 + 5) *8 / MODACCURACY),BRSMOD
					.if BRSMOD == 8
						.asg	7,BRSMOD
					.endif
				.endif
			.elseif BRDEFS != 2				;Only one of those two values is defined
				.emsg	"All or none of BRSMOD and BRFMOD must be defined"
			.endif

			.asg	((BRFMOD << 4) + (BRSMOD << 1) + BROS16),MCTLVAL

;Time to setup the timer definitions according to the defined timer used for waking up the
; system when binary reception mode is used
		.if (RS232TIMER == "A0")
RS232TIMVECTOR	.equ	"TIMERA0"
RS232CCTL		.equ	TACCTL0
RS232CCR0		.equ	TACCR0
RS232CCR		.equ	TACCR0
RS232TCTL		.equ	TACTL
RS232TR			.equ	TAR
		.elseif (RS232TIMER == "A1")
RS232TIMVECTOR	.equ	"TIMERA1"
RS232CCTL		.equ	TACCTL1
RS232IV			.equ	TAIV_TACCR1
RS232CCR0		.equ	TACCR0
RS232CCR		.equ	TACCR1
RS232TCTL		.equ	TACTL
RS232TR			.equ	TAR
		.elseif (RS232TIMER == "A2")
RS232TIMVECTOR	.equ	"TIMERA1"
RS232CCTL		.equ	TACCTL2
RS232IV			.equ	TAIV_TACCR2
RS232CCR0		.equ	TACCR0
RS232CCR		.equ	TACCR2
RS232TCTL		.equ	TACTL
RS232TR			.equ	TAR
		.elseif (RS232TIMER == "B0")
RS232TIMVECTOR	.equ	"TIMERB0"
RS232CCTL		.equ	TBCCTL0
RS232CCR0		.equ	TBCCR0
RS232CCR		.equ	TBCCR0
RS232TCTL		.equ	TBCTL
RS232TR			.equ	TBR
		.elseif (RS232TIMER == "B1")
RS232TIMVECTOR	.equ	"TIMERB1"
RS232CCTL		.equ	TBCCTL1
RS232IV			.equ	TBIV_TBCCR1
RS232CCR0		.equ	TBCCR0
RS232CCR		.equ	TBCCR1
RS232TCTL		.equ	TBCTL
RS232TR			.equ	TBR
		.elseif (RS232TIMER == "B2")
RS232TIMVECTOR	.equ	"TIMERB1"
RS232CCTL		.equ	TBCCTL2
RS232IV			.equ	TBIV_TBCCR2
RS232CCR0		.equ	TBCCR0
RS232CCR		.equ	TBCCR2
RS232TCTL		.equ	TBCTL
RS232TR			.equ	TBR
		.elseif (RS232TIMER == "B3")
RS232TIMVECTOR	.equ	"TIMERB1"
RS232CCTL		.equ	TBCCTL3
RS232IV			.equ	TBIV_TBCCR3
RS232CCR0		.equ	TBCCR0
RS232CCR		.equ	TBCCR3
RS232TCTL		.equ	TBCTL
RS232TR			.equ	TBR
		.elseif (RS232TIMER == "B4")
RS232TIMVECTOR	.equ	"TIMERB1"
RS232CCTL		.equ	TBCCTL4
RS232IV			.equ	TBIV_TBCCR4
RS232CCR0		.equ	TBCCR0
RS232CCR		.equ	TBCCR4
RS232TCTL		.equ	TBCTL
RS232TR			.equ	TBR
		.elseif (RS232TIMER == "B5")
RS232TIMVECTOR	.equ	"TIMERB1"
RS232CCTL		.equ	TBCCTL5
RS232IV			.equ	TBIV_TBCCR5
RS232CCR0		.equ	TBCCR0
RS232CCR		.equ	TBCCR5
RS232TCTL		.equ	TBCTL
RS232TR			.equ	TBR
		.elseif (RS232TIMER == "B6")
RS232TIMVECTOR	.equ	"TIMERB1"
RS232CCTL		.equ	TBCCTL6
RS232IV			.equ	TBIV_TBCCR6
RS232CCR0		.equ	TBCCR0
RS232CCR		.equ	TBCCR6
RS232TCTL		.equ	TBCTL
RS232TR			.equ	TBR
		.else
			.emsg	"Wrong definition of Timer Capture/Compare RS232TIMER!"
		.endif

;Need to calculate the TIMERTICKS which is the number of timer's clock ticks need to count
; WAKEUPTIME RS232 characters time. In the calculated value we add 1 to ensure the whole time
; pass
TIMERTICKS		.set	(CHARTICKS * WAKEUPTIME * TIMERCLK / BAUDRATE) +1

		.def	RS232TIMVECTOR
		.if $isdefed("RS232IV")
			.def	RS232IV
		.endif

;Lets also see if RS232 seats on a shared bus (shared interrupt vector)
		.if $isdefed("SHAREDBUS") == 0
SHAREDBUS		.equ	0
		.endif

		.if SHAREDBUS == 0
SINGLEISR		.equ	1
		.else
SINGLEISR		.equ	0
		.endif

;============================================================================================
; VARIABLES - This section contains local variables
;--------------------------------------------------------------------------------------------
			.sect	".bss"
			.align	1
RSFlags:	.space	2						;Flags to control the functionality of RS232
											; subsystem
RSServe		.equ	BIT0					;Flags that RS232 subsystem needs attention
RSRxError	.equ	BIT1					;Flags that a character was received while the
											; buffer was full
RS0A		.equ	BIT2					;Last character received was 0Ah (perhaps part of
											; a newline character)
RS0D		.equ	BIT3					;Last character received was 0Dh (perhaps part of
											; a newline character)
RSRxEol		.equ	BIT4					;Flags that the system has just received a new
											; line character (force wake up by RX ISR)
RSBinary	.equ	BIT5					;Flags binary mode. It does not filter any
											; characters and the wake up is controlled by
											; timer
RSUpDown	.equ	BIT6					;Flags that the timer is used in Up/Down mode
RSCountDown	.equ	BIT7					;Flags that the timer counts towards down
											; direction
RSNeedDown	.equ	BIT8					;Flags that a full period is considered when
											; counting down

TCounter:	.space	4						;Counter for hit itterations of the timer until
											; considered expired (Long number = QuadByte)
TxBufStrt:	.space	2						;Offset in transmition buffer of the first
											; character to be transmitted
TxBufLen:	.space	2						;Length of data waiting to be sent in the
											; transmition buffer
RxBufStrt:	.space	2						;Offset in reception buffer of the first character
											; received earlier by RS232
RxBufLen:	.space	2						;Number of bytes waiting to be read in the
											; reception buffer
WakeLim:	.space	2						;The wake up buffer limit. When the receiving
											; buffer reaches this limit it wakes up the system
											; to handle those data
TxCBuf:		.space	TXBUFLEN				;Cyclic buffer to hold the data to be sent
RxCBuf:		.space	RXBUFLEN				;Cyclic buffer to hold the data received

;============================================================================================
; CONSTANTS - This section contains constant data written in Flash (.const section)
;--------------------------------------------------------------------------------------------
			.sect	".const"
			.align	1


;============================================================================================
; PROGRAM FUNCTIONS
;--------------------------------------------------------------------------------------------
;--< Need some functions defined in other files >--------------------------------------------
			.ref	UDivide32
			.ref	DIVIDENT_H
			.ref	DIVIDENT_L
			.ref	DIVISOR
			.ref	RESULT_H
			.ref	RESULT_L
			.ref	MODULO

;--< Some of the labels must be available to other files >-----------------------------------
			.def	RS232TXVECTOR
			.def	RS232RXVECTOR
			.def	RS232TxISR
			.def	RS232RxISR
			.def	RS232TimerISR
			.def	InitRS232Ports
			.def	InitRS232USC
			.def	InitRS232Sys
			.def	RS232EnableInts
			.def	RS232DisableInts
			.def	RS232SetBinMode
			.def	RS232SetTxtMode
			.def	RS232GetMode
			.def	RS232CheckServe
			.def	RS232Send
			.def	RS232Receive

;==< Interrupt Service Routines >============================================================
			.text							;Place program in ROM (Flash)
			.align	1
RS232TxISR:
; Sends one byte from the transmition buffer to the bus
; Input:				None
; Output:				None
; Registers Used:		R4
; Registers Altered:	None
; Stack Usage:			2 bytes for storing registers
; Depend On Defs:		RS232IE, RS232TXBUF, RS232TXIE, TXBUFLEN
; Depend On Vars:		TxBufLen, TxBufStrt, TxCBuf
; Depend On Constants:	None
; Depend On Funcs:		None
			CMP		#00000h,&TxBufLen		;Are there any data in transmit buffer?
			JZ		RTX_Exit				;No => Exit
			PUSH	R4
			MOV		&TxBufStrt,R4			;Get the starting pointer of transmit buffer
			MOV.B	TxCBuf(R4),&RS232TXBUF	;Send one byte from the buffer to the bus
			INC		R4						;Advance the starting pointer to the next byte
			CMP		#TXBUFLEN,R4			;Did we reach the end of physical buffer space?
			JNE		TxSR_RvtBuf				;No => Do not revert to the beginning
			MOV		#00000h,R4				;else move the pointer to the beginning of buffer
TxSR_RvtBuf:
			MOV		R4,&TxBufStrt			;Store the new starting pointer
			DEC		&TxBufLen				;One character less in transmit buffer
			JNZ		TxSR_NoDis				;Reached the end?
			BIC.B	#RS232TXIE,&RS232IE		;Yes => Disable this interrupt
TxSR_NoDis:	POP		R4						;else, just exit,restoring registers used
RTX_Exit:	RETI
;-------------------------------------------

RS232RxISR:
; Initialises the port pins used for the serial bus
; Input:				None
; Output:				None
; Registers Used:		R4, R5
; Registers Altered:	None
; Stack Usage:			4 bytes for registers storage
; Depend On Defs:		RS232RXBUF, RS0A, RS0D, RSBinary, RSRxEol, RSRxError, RSServe,
;						RXBUFLEN
; Depend On Vars:		RSFlags, RxBufLen, RxBufStrt, RxCBuf, WakeLim
; Depend On Constants:	None
; Depend On Funcs:		None
			CMP		#RXBUFLEN,&RxBufLen		;Is the receive buffer full?
			JEQ		RxSRFail				;Yes => Flag the failure and exit
			PUSH	R4						;Store used registers
			PUSH	R5
			MOV		&RxBufStrt,R4			;Get the starting pointer of the buffer
			ADD		&RxBufLen,R4			;Add the length of stored data
			CMP		#RXBUFLEN,R4			;Is it above the physical boundary of buffer?
			JL		RxSR_NoRvt				;No => Skip revert to its beginning
			SUB		#RXBUFLEN,R4			;else, Subtract the length of buffer to revert it
											; to its beginning
RxSR_NoRvt:	MOV.B	&RS232RXBUF,R5			;Get incoming byte
			BIT		#RSBinary,&RSFlags		;Are we in binary mode?
			JNZ		RxSRBinTim				;If yes => Do not filter incoming character; store
											; it as is
			CMP.B	#00Ah,R5				;Is it 0Ah (One of the line terminating values)
			JNE		RxSRNo0A				;No => OK, Check for other
			BIS		#RS0A+RSRxEol,&RSFlags	;Flag the character reception and the need to wake
											; up the system
			BIT		#RS0D,&RSFlags			;Was the last character 0Dh (the other new line
											; character)
			JZ		RxSRStore				;No => OK, Keep going on storing it
			BIC		#RS0A+RS0D,&RSFlags		;else, Clear both flags for character reception
			JMP		RxSR_WakeUp				;The second character is not stored. It just wakes
											; up the system
RxSRNo0A:	CMP.B	#00Dh,R5				;Is the received character 0Dh?
			JNE		RxSRNo0D				;No => OK, Store the character
			BIS		#RS0D+RSRxEol,&RSFlags	;Flag the reception of this character and the
											; necessity to wake up the system
			BIT		#RS0A,&RSFlags			;Was the last character a 0A?
			JZ		RxSRStore				;No => just store the character
			BIC		#RS0A+RS0D,&RSFlags		;else, clear the character reception flags
			JMP		RxSR_WakeUp				;and wake up the system. No need to store the
											; second character of the "New Line" sequence
RxSRBinTim:	CALL	#SetupTimer
RxSRNo0D:	BIC		#RS0A+RS0D,&RSFlags		;Ordinary character => No 0Ah or 0Dh
RxSRStore:	MOV.B	R5,RxCBuf(R4)			;Insert the newly received value
			INC		&RxBufLen				;Increment the length of stored data in the buffer
			BIT		#RSRxEol,&RSFlags		;Do we need to force wake up?
			JNZ		RxSR_WakeUp				;Yes => Wake the system up
			CMP		&WakeLim,&RxBufLen		;Do we need to wake the system up?
			JL		RxSR_NoWake				;No =>  Skip waking up
RxSR_WakeUp:
			BIC		#RSRxEol,&RSFlags		;Clear this flag if it is set
			BIS		#RSServe,&RSFlags		;Flag the need to be served
			BIC		#CPUOFF+SCG0+SCG1+OSCOFF,4(SP)	;Wake the system up
RxSR_NoWake:
			POP		R5						;Restore used registers
			POP		R4
			RETI
RxSRFail:	BIS		#RSRxError,&RSFlags		;Flag the reception error
			BIC		#RS0A+RS0D,&RSFlags		;No matter what the previous character was...
			BIC.B	#RS232RXIE,&RS232IFG	;Clear receive interrupt
			RETI
;-------------------------------------------

RS232TimerISR:
; When the timer is fired, the system has been idle for 10 characters time length. This means
; that if there are any characters in the reception buffer, the system needs to wake up and
; use these characters
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RS232CCR, RS232CCTL, RSServe
; Depend On Vars:		RSFlags, RxBufLen, TCounter
; Depend On Constants:	None
; Depend On Funcs:		None
			CMP		#00000h,&RxBufLen		;Are there any characters waiting in the queue?
			JEQ		TISR_Unused				;No => exit. No reason to wake up the system
			CMP		#00000h,&TCounter+2		;Is the high word zeroed?
			JNE		TISR_NoWake				;No => Do not wake up the system... Keep counting
			CMP		#00000h,&TCounter		;Is the itteration counter zeroed?
			JEQ		TISR_WakeUp				;Yes => Wake up the system
TISR_NoWake:
			DEC		&TCounter				;Decrement the itteration counter
			SUBC	#00000h,&TCounter+2		;... all 32 bit counter value
			RETI							;and return to interrupted process

TISR_WakeUp:
			BIC		#CPUOFF+OSCOFF+SCG0+SCG1,0(SP)	;Wake up
			BIS		#RSServe,&RSFlags		;Flag the necessity to be serviced
TISR_Unused:
			MOV		#00000h,&RS232CCR		;Clear the counter to have the advantage of OUTx
											; following the counting direction in Up/Down mode
			BIC		#CCIE+CCIFG,&RS232CCTL	;Clear any pending interrupts and disable this
											; timer's interrupt
			RETI							;Return to interrupted process
;-------------------------------------------


;==< Main Functions >========================================================================
InitRS232Ports:
; Initialises the port pins used for the serial bus
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RS232ALL, RS232DIR, RS232RXD, RS232SEL, RS232TXD
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			BIS.B	#RS232ALL,&RS232SEL		;Flag that these pins are not used for I/O
			BIS.B	#RS232TXD,&RS232DIR		;TxD pin is an output
			BIC.B	#RS232RXD,&RS232DIR		;while RxD is an input
			RET
;-------------------------------------------

InitRS232USC:
; Initialises the USCI that is used for RS232 communications
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		BRx, CTL0VAL, CTL1VAL, MCTLVAL, RS232BR0, RS232BR1, RS232CTL0,
;						RS232CTL1, RS232MCTL
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			BIS.B	#UCSWRST,&RS232CTL1		;Keep USCI in reset mode
			MOV.B	#(BRx & 0FFh),&RS232BR0	;Set the low byte of baud rate prescaler
			MOV.B	#(BRx >> 8),&RS232BR1	;Set the high byte of baud rate prescaler
			MOV.B	#CTL0VAL,&RS232CTL0		;Set Data format
			MOV.B	#CTL1VAL,&RS232CTL1		;Set the control of the bus
			MOV.B	#MCTLVAL,&RS232MCTL		;Set the Modulation Control register
			BIC.B	#UCSWRST,&RS232CTL1		;Release Serial module
			RET
;-------------------------------------------

InitRS232Sys:
; Initialises the RS232 systems variables and Timer module
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RXWAKELIM
; Depend On Vars:		RSFlags, RxBufLen, RxBufStrt, TxBufLen, TxBufStrt, WakeLim
; Depend On Constants:	None
; Depend On Funcs:		None
			MOV		#000h,&TxBufStrt		;Move starting pointer to the beginning of buffer
			MOV		#000h,&TxBufLen			;Transmition buffer does not contain data
			MOV		#000h,&RxBufStrt		;Move starting pointer to the beginning of buffer
			MOV		#000h,&RxBufLen			;Reception buffer does not contain data
			MOV		#00000h,&RSFlags		;Reset flags
			MOV		#RXWAKELIM,&WakeLim		;Setup the default wake up limit
			MOV		#00000h,&RS232CCR		;Reset the point of interrupt
			MOV		#OUTMOD_3,&RS232CCTL	;Set/Reset mode. TxCCR0 resets out, our CCR sets
			; it. No interrupts enabled. OUTx bit follows the timer's direction of counting in
			; Up/Down mode
			RET
;-------------------------------------------

RS232EnableInts:
; Enables the receiving interrupt of RS232
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RS232IE, RS232IFG, RS232RXIE
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			BIC.B	#RS232RXIE,&RS232IFG	;Clear any pending interrupts of UCAxRX
			BIS.B	#RS232RXIE,&RS232IE		;Enable the reception interrupt of RS232
			RET
;-------------------------------------------

RS232DisableInts:
; Disables the receiving interrupt of RS232. Transmition interrupt is disabled automatically
; when there is no data to be sent
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RS232IE, RS232IFG, RS232RXIE
; Depend On Vars:		None
; Depend On Constants:	None
; Depend On Funcs:		None
			BIC.B	#RS232RXIE,&RS232IFG	;Clear any pending interrupts of UCAxRX
			BIC.B	#RS232RXIE,&RS232IE		;Disable the reception interrupt of RS232
			RET


RS232SetBinMode:
; Sets the receiving mode to Binary. No data is filtered upon receiving. Timer wakes up the
; system to handle the received data
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RSBinary
; Depend On Vars:		RSFlags
; Depend On Constants:	None
; Depend On Funcs:		None
			BIS		#RSBinary,&RSFlags		;Set binary flag
			RET
;-------------------------------------------


RS232SetTxtMode:
; Sets the receiving mode to text. New line sequences are filtered. No timer is used
; Input:				None
; Output:				None
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RSBinary
; Depend On Vars:		RSFlags
; Depend On Constants:	None
; Depend On Funcs:		None
			BIC		#CCIE+CCIFG,&RS232CCTL	;Disable timer interrupt in this mode
			BIC		#RSBinary,&RSFlags		;Clear binary flag
			RET
;-------------------------------------------

RS232GetMode:
; Gets the receiving mode
; Input:				None
; Output:				Carry flag is set on binary mode, reset on text mode
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RSBinary
; Depend On Vars:		RSFlags
; Depend On Constants:	None
; Depend On Funcs:		None
			BIT		#RSBinary,&RSFlags		;Test binary flag
			RET
;-------------------------------------------

SetupTimer:
; Test the state of the associated timer counter and calculate the timing variables according
; to it.
; Input:				None
; Output:				None
; Registers Used:		R6, R14, DIVIDENT_H, DIVIDENT_L, DIVISOR, MODULO, RESULT_H, RESULT_L
; Registers Altered:	None
; Stack Usage:			18 bytes (16 for storing registers +2 for CALL)
; Depend On Defs:		DIVIDENT_H, DIVIDENT_L, DIVISOR, MODULO, RESULT_H, RESULT_L, RS232CCR,
;						RS232CCR0, RS232CCTL, RS232TCTL, RS232TR, RSCountDown, RSNeedDown,
;						RSUpDown, TIMERTICKS
; Depend On Vars:		RSFlags, TCounter
; Depend On Constants:	None
; Depend On Funcs:		UDivide32
			PUSH	R6						;Store all used registers. This function is called
			PUSH	DIVIDENT_H				; from inside a ISR, so must keep the registers
			PUSH	DIVIDENT_L				; unaffected
			PUSH	DIVISOR
			PUSH	RESULT_H
			PUSH	RESULT_L
			PUSH	MODULO
			PUSH	R14
			BIC		#RSUpDown+RSCountDown+RSNeedDown,&RSFlags	;Clear unecessary bits
			MOV		&RS232TCTL,R6			;Get the control byte of TxCTL
			AND		#MC0+MC1,R6				;Filter only the running status of the timer
			JZ		TTimCont				;0 => Timer is stopped
			CMP		#MC1,R6					;else, MC1 only set?
			JZ		TTimCont				;Yes => timer is running in Continuous mode
			MOV		#(TIMERTICKS >> 8),DIVIDENT_H	;Going to divide the TIMERTICKS value...
			MOV		#(TIMERTICKS & 0FFh),DIVIDENT_L
			MOV		&RS232CCR0,DIVISOR		;By the period of timer
			CALL	#UDivide32				;Perform the division
			CMP		#MC0,R6					;MC0 only set?
			JZ		TTimCSetT				;Yes => Then set the calculated period settings
			;else, timer is running in Up/Down mode
			BIS		#RSUpDown,&RSFlags		;Flag the mode of timer is Up/Down
			ADD		RESULT_L,RESULT_L		;The number of itterations is twice the number of
			ADDC	RESULT_H,RESULT_H		; itterations needed in Up mode
			ADD		&RS232TR,MODULO			;Add NOW to timer pulses left
			JMP		TTimCSetT
TTimCont:
			MOV		&RS232TCTL,R6			;Get the Timer's control registers
			MOV		#0FFFFh,DIVISOR			;Set the Counter Register mask
			MOV		#00000h,RESULT_H		;RESULT_H:RESULT_L:R9 holds the number of timer
			MOV		#(TIMERTICKS >> 8),RESULT_L	; ticks needed for 10 characters time period
			MOV		#(TIMERTICKS & 0FFh),R9	; (to caclulate the timer interrupt itterations)
			MOV		R9,MODULO				;Also, get the remnant
			AND		#CNTL1+CNTL0,R6			;Filter only the length of timer's counter
			JZ		TTimCSetT				;16 Bit counter? => Set period
			MOV		#00FFFh,DIVISOR			;Mask only 12 bits
			AND		DIVISOR,MODULO			;Truncate remnant to 12 bits
			MOV.B	#004h,R14				;Counter for left shift of timerticks
TTimC12Bit:	ADD		R9,R9					;Shift left the set of RESULT_H:RESULT_L:R9 once
			ADDC	RESULT_L,RESULT_L
			ADDC	RESULT_H,RESULT_L
			DEC		R14						;More times needed?
			JNZ		TTimC12Bit				;Yes => Repeat for 12 bit counter setting
			CMP		#CNTL0,R6				;Is it really a 12 bit counter
			JZ		TTimCSetT				;Yes => Set period
			MOV		#003FFh,DIVISOR			;Set mask to 10 bits
			AND		DIVISOR,MODULO			;Truncate remnant to 10 bits
			ADD		R9,R9					;Shift left the set of RESULT_H:RESULT_L:R9, once
			ADDC	RESULT_L,RESULT_L
			ADDC	RESULT_H,RESULT_L
			ADD		R9,R9					;Shift left the set of RESULT_H:RESULT_L:R9, twice
			ADDC	RESULT_L,RESULT_L
			ADDC	RESULT_H,RESULT_L
			CMP		#CNTL1,R6				;10 bit mode for timer?
			JZ		TTimCSetT				;Yes => then set period
			MOV		#000FFh,DIVISOR			;Set counter mask to 8 bits
			AND		DIVISOR,MODULO			;Truncate remnant to 8 bits
			ADD		R9,R9					;Shift left the set of RESULT_H:RESULT_L:R9, once
			ADDC	RESULT_L,RESULT_L
			ADDC	RESULT_H,RESULT_L
			ADD		R9,R9					;Shift left the set of RESULT_H:RESULT_L:R9, twice
			ADDC	RESULT_L,RESULT_L
			ADDC	RESULT_H,RESULT_L
TTimCSetT:	
			MOV		RESULT_L,&TCounter		;Set the number of timer interrupt itterations
			MOV		RESULT_H,&TCounter+2	; needed to wait for 10 characters time
			ADD		&RS232TR,MODULO			;Add NOW to calculated modulo
			CMP		DIVISOR,MODULO			;Is it above the limit?
			JLO		TTimCNoRvt				;No => Skip reverting to zero
			SUB		DIVISOR,MODULO			;else subtract the maximum value
TTimCNoRvt:	MOV		MODULO,&RS232CCR		;Set the remnant of time to form the whole 10
											; characters time wait
			BIC		#CCIFG,&RS232CCTL		;Clear any pending interrupt of this timer's CCR
			BIS		#CCIE,&RS232CCTL		;Enable timer's associated CCR interrupt
			BIT		#MC1+MC0,&RS232TCTL		;Is the timer counting?
			JNZ		TTimRunsOK				;Yes => then do not start it
			BIS		#MC1,&RS232TCTL			;else, start the timer in continuous mode
TTimRunsOK:	
			POP		R14						;Restore registers back to their original values
			POP		MODULO
			POP		RESULT_L
			POP		RESULT_H
			POP		DIVISOR
			POP		DIVIDENT_L
			POP		DIVIDENT_H
			POP		R6
			RET
;-------------------------------------------

RS232CheckServe:
; Gets the status of Serve flag. After reading the RSServe flag, it resets it
; Input:				None
; Output:				Carry flag is set on need to get the reception buffer's data
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RSServe
; Depend On Vars:		RSFlags
; Depend On Constants:	None
; Depend On Funcs:		None
			BIT		#RSServe,&RSFlags		;Carry flag contains the value of Serve flag
			BIC		#RSServe,&RSFlags		;Clear this flag
			RET
;-------------------------------------------

RS232Send:
; Sends a byte to the RS232 bus
; Input:				R4 contains the byte to be sent
; Output:				Carry flag is set on error (buffer full), cleared on success
; Registers Used:		None
; Registers Altered:	None
; Stack Usage:			None
; Depend On Defs:		RS232IE, RS232IFG, RS232TXBUF, RS232TXIE, TXBUFLEN
; Depend On Vars:		TxBufLen, TxBufStrt, TxCBuf
; Depend On Constants:	None
; Depend On Funcs:		None
			CMP		#000h,&TxBufLen			;Do we have characters in the buffer?
			JZ		RSS_Send				;No => Try to send the byte at once
			CMP		#TXBUFLEN,&TxBufLen		;Is the buffer full?
			JHS		RSS_Exit				;Yes => exit with carry flag set
			PUSH	SR						;Store the state of interrupts
			DINT							;Pause interrupts for a little bit
RSS_Store:	MOV		&TxBufStrt,R5			;Get the strting offset of the first character
			ADD		&TxBufLen,R5			;Add the length of data stored in the buffer to
											; find the first empty cell in it
			POP		SR						;Restore interrupts
			CMP		#TXBUFLEN,R5			;Passed the end of physical buffer?
			JLO		RSSNoRvt				;No => Do not revert to its beginning
			SUB		#TXBUFLEN,R5			;else bring it inside buffer's bounds
RSSNoRvt:	MOV.B	R4,TxCBuf(R5)			;Store the byte into the buffer
			INC		&TxBufLen				;Increment the stored buffer data length by one
			CLRC							;Clear carry to flag success
RSS_Exit:	RET
RSS_Send:	PUSH	SR						;Store interrupts' status
			DINT							;Disable them
			BIT.B	#RS232TXIE,&RS232IFG	;Is the buffer in use?
			JZ		RSS_Store				;Yes => Store the byte for later transmition
			POP		SR						;Restore interrupts' status
			MOV.B	R4,&RS232TXBUF			;Send it now
			BIS.B	#RS232TXIE,&RS232IE		;Enable transmit interrupt
			CLRC							;Clear carry to flag success
			RET								;and exit
;-------------------------------------------

RS232Receive:
; Fetches a byte from the RS232 reception buffer
; Input:				None
; Output:				R4 contains the byte fetched. Carry flag is set on error (buffer full)
;						or cleared on success
; Registers Used:		R4, R5
; Registers Altered:	R4, R5
; Stack Usage:			2 bytes for storing flags
; Depend On Defs:		RXBUFLEN
; Depend On Vars:		RxBufLen, RxBufStrt, RxCBuf
; Depend On Constants:	None
; Depend On Funcs:		None
			CMP		#00000h,&RxBufLen		;Is there any data in the receiving buffer?
			JZ		RSRecFail				;No => exit with carry flag set
			MOV		&RxBufStrt,R5			;Get the starting offset of the first character
			MOV.B	RxCBuf(R5),R4			;Get this byte
			PUSH	SR						;Store the state of interrupts
			DINT							;Both start and length should be changed before
											; another process use them
			DEC		&RxBufLen				;One character less in the buffer
			INC		R5						;Advance the starting pointer to the next stored
											; character
			CMP		#RXBUFLEN,R5			;Crossed the physical buffer's boundary?
			JLO		RSRecNoRvt				;No => do not revert to the beginning
			MOV		#00000h,R5				;else, move pointer to the beginning of the buffer
RSRecNoRvt:	MOV		R5,&RxBufStrt			;Store the starting pointer
			POP		SR						;Restore interrupts
			CLRC							;Flag success
RSRecFail:	RET								;and return to caller
;-------------------------------------------


;============================================================================================
; INTERRUPT VECTORS
;--------------------------------------------------------------------------------------------
			.if SINGLEISR == 1
				.sect	RS232TXVECTOR		;Transmit vector for RTC
				.short	RS232TxISR			;Points to the transmit ISR

				.sect	RS232RXVECTOR		;Receive vector for RTC
				.short	RS232RxISR			;Points to the receive ISR
			.endif
			.end
