%TERMIO
 Q
 ; 
 ; GETCH
 ; Equivalent to getch() in [n]curses
 ;  EVENT: Return structure (by reference)
 ;   EVENT("IS_SPECIAL")=0|1 (where 1 means this is a special key)
 ;
GETCH(EVENT)
 N TMP,ZB,RETVAL
 U $P:ESC
 R *TMP S ZB=$ZB
 I $G(%IOKB(ZB))'="" D 
 . S EVENT("IS_SPECIAL")=1,RETVAL=$G(%IOKB(ZB))
 E  D
 . S EVENT("IS_SPECIAL")=0,RETVAL=$C(TMP)
 . S EVENT("READ_TERMINATOR")=ZB
 Q RETVAL
 ;
 ; GETSTR
 ; Equivalent to tgetstr() in termcap library
 ;  CODE: capability code (by value)
 ;
GETSTR(CODE)
 I $G(%IOCAP(CODE))'="" Q %IOCAP(CODE)		;try the first-level entry
 I $G(%IOCAP(CODE))="" Q $G(%IOCAP("tc",CODE))  ;if empty, try the more specific one
 ;
 ; GOTO
 ; Equivalent to tgoto() in termcap library
 ;  HPOS: Column
 ;  VPOS: Row
 ;
GOTO(HPOS,VPOS)
 N PA S PA(1)=VPOS,PA(2)=HPOS
 D ^PARAM($$GETSTR("cm"),.PA)
 D
 ;
 ; INITSCR
 ; Must be called first. Initializes memory data structures for
 ; terminal I/O.
 ;
INITSCR
 N TC,TN
 ; 
 ; Get environment variable and read in term def.
 ; 
 S TERM=$ZTRNLNM("TERM")
 G:TERM="" NOTERM	; TERM wasn't set. Error out.
 M %IOCAP=^%IOCAP("TERMCAP",TERM)
 ;
 ; Merge in more specific capability strings indirected through
 ; tc capability string.
 ;
 S TN=%IOCAP("tc")
 M TC=^%IOCAP("TERMCAP",TN)
 M %IOCAP("tc")=TC
 ;
 ; Set up %IOKB for special key lookup.  
 ; Used by $$GETCH.
 ;
 S %IOKB($$GETSTR("kd"))="KEY_DOWN"
 S %IOKB($$GETSTR("ku"))="KEY_UP"
 S %IOKB($$GETSTR("kl"))="KEY_LEFT"
 S %IOKB($$GETSTR("kr"))="KEY_RIGHT"
 S %IOKB($$GETSTR("kh"))="KEY_HOME"
 S %IOKB($$GETSTR("k1"))="KEY_F1"
 S %IOKB($$GETSTR("k2"))="KEY_F2"
 S %IOKB($$GETSTR("k3"))="KEY_F3"
 S %IOKB($$GETSTR("k4"))="KEY_F4"
 S %IOKB($$GETSTR("k5"))="KEY_F5"
 S %IOKB($$GETSTR("k6"))="KEY_F6"
 S %IOKB($$GETSTR("k7"))="KEY_F7"
 S %IOKB($$GETSTR("k8"))="KEY_F8"
 S %IOKB($$GETSTR("k9"))="KEY_F9"
 S %IOKB($$GETSTR("kN"))="KEY_NPAGE"
 S %IOKB($$GETSTR("kP"))="KEY_PPAGE"
 S %IOKB($$GETSTR("@7"))="KEY_END"
 K %IOKB("")		; make sure we don't have an empty entry
 Q
 ;
 ; Inserts parameters into CODE and returns expanded string.
 ;  CODE: capability code (by value)
 ;  PA: params array (by reference)
 ;    PA(n,paramValue)
 ;
PARAM(CODE,PA)
 N OUTSTR S OUTSTR=""	
 N PARMIDX S PARMIDX=1	; index of current param
 ;
 ; We don't need to expand params if PA(1) is empty.
 ;
 I $G(PA(1))="" S OUTSTR=CODE Q OUTSTR
 ; 
 ; Flags for the parameter alteration sequences
 ;
 N FLG,CTR S CTR=0	; counter for increment, transpose
 S FLG("INCREMENT")=0	; increment next two params
 S FLG("TRANSPOSE")=0 	; transpose next two params
 S FLG("SKIP")=0	; skip next one param with no output
 ;
 N LEN S LEN=$L(CODE)
 F I=1:1:L  D
 . S C=$E(CODE,I,I)
 . I 
 Q OUTSTR
 ;
 ; Swap the values at nodes PA(P1) and PA(P2)
 ;  PA: Parameter array (by reference)
 ;
PARMSWAP(PA,P1,P2)
 N T1,T2 S T1=PA(P1),T2=PA(P2)
 S PA(P1)=T2,PA(P2)=T1
 Q
 ; 
 ; Disables echoing
 ;
NOECHO
 U $P:NOECHO
 Q
 ;
 ; ENDWIN
 ;  Clean up memory structures
 ;
ENDWIN
 K %IOCAP
 K %IOKB
 K TERM
 Q
 ;
 ; ERROR SUBROUTINES
 ;
NOTERM
 W "%TERMIO-F-NOTERMENV, The TERM environment variable is not set."
 H