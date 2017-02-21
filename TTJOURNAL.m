TTJOURNAL
 Q

COMBINED
 N TRNSACTS
 M TRNSACTS=^TT("JNL")
 D VIEW(.TRNSACTS,"COMBINED JOURNAL")
 Q

 ;
 ; Main journal editor
 ;
VIEW(TRNSACTS,CAPTION)
 N CUR,JNL,IDX,CURLINE,KEY,EV S (CUR,IDX)=1,CURLINE=4
 N INDEX,CREC,ARES,TOT,QUITFLG,RCNT S INDEX="",QUITFLG=0
 N JSEQ,CRSEQ,DRSEQ,DATE,DESC,AMT,DR,CR,CREDREC,DEBREC
 N CURREC S CURREC=1
 N CONF S CONF=""
 N ENDLINE S ENDLINE=%IOCAP("ROWS")-2
RELOAD
 S (CUR,IDX)=1,CURLINE=4,INDEX="",QUITFLG=0,CURREC=1,CONF=""
 F  S CUR=$O(TRNSACTS(CUR)) Q:CUR=""  D
 . S JNL(IDX)=CUR
 . S IDX=IDX+1
 S RCNT=IDX-1
 S CUR=1
REDISPLAY
 D INIT^TT,CAPTION^TTUI(CAPTION)
 D SETCOLOR^TTRNSI("BLACK","CYAN")
 D LOCATE^TTRNSI(3,1),ERASETOEOL^TTRNSI
 W "SEQ"
 D LOCATE^TTRNSI(3,8) W "DATE"
 D LOCATE^TTRNSI(3,20) W "DESCRIPTION"
 D LOCATE^TTRNSI(3,50) W "AMOUNT"
 D LOCATE^TTRNSI(3,60) W "DEBIT"
 D LOCATE^TTRNSI(3,70) W "CREDIT"
 D SETCOLOR^TTRNSI("GREEN","BLACK")
 S OLDCUR=CUR
 ;I RCNT<18 S ENDLINE=RCNT+3
 I RCNT<(%IOCAP("ROWS")-6)
 F LINE=4:1:ENDLINE  D
 . S INDEX=JNL(CUR)
 . M CREC=^TT("JNL",JNL(CUR))
 . S TOT=$$LOOKUP(JNL(CUR),.ARES)
 . S JSEQ=JNL(CUR)
 . S PERIOD=ARES("CREDIT","PERIOD")
 . S DATE=CREC("DATE")
 . S DESC=$E(CREC,1,29)
 . S DR=ARES("DEBIT","ACCOUNT")
 . S CR=ARES("CREDIT","ACCOUNT")
 . S CRSEQ=ARES("CREDIT","SEQ")
 . S DRSEQ=ARES("DEBIT","SEQ")
 . S AMT=^TT("ACCT",DR,PERIOD,DRSEQ)
 . I AMT<0 S AMT=$P(AMT,"-",2)
 . S AMT="$"_$J(AMT,8,2)
 . D LOCATE^TTRNSI(LINE,1)
 . I CUR=CURREC D SETATTR^TTRNSI("BRIGHT"),ERASETOEOL^TTRNSI S CURSLINE=LINE
 . E  D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 . D LOCATE^TTRNSI(LINE,1) W JSEQ
 . D LOCATE^TTRNSI(LINE,8) W DATE
 . D LOCATE^TTRNSI(LINE,20) W DESC
 . D LOCATE^TTRNSI(LINE,50) W AMT
 . D LOCATE^TTRNSI(LINE,60) W DR
 . D LOCATE^TTRNSI(LINE,70) W CR
 . S CUR=CUR+1
 S CUR=OLDCUR
 D LOCATE^TTRNSI(%IOCAP("ROWS")-1,1)
 F I=1:1:80 W BOX("H")
 D LOCATE^TTRNSI(%IOCAP("ROWS"),1),SETCOLOR^TTRNSI("MAGENTA","BLACK")
 D SETATTR^TTRNSI("BRIGHT")
 W "F1:HELP     F2:EDIT     F3:DESCRIBE     F4:ROLLBACK     F6:EXIT ["_CURREC_" OF "_RCNT_"]"
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 D HOME^TTRNSI
 S KEY=$$GETCH^%TERMIO(.EV)
 S CHFLG=0
 I KEY="KEY_DOWN" D
 . I CURREC<RCNT D 
 . . S CURREC=CURREC+1
 . . I CURSLINE=(%IOCAP("ROWS")-2) S CUR=CUR+1
 I KEY="KEY_UP" D
 . I CURREC>1 D
 . . S CURREC=CURREC-1
 . . I CURSLINE=4 S CUR=CUR-1 
 I KEY="KEY_F3" D DESCRIBE(JNL(CURREC))
 I KEY="KEY_F4" D
 . S CONF=$$CONFIRM^TTUI("ROLLBACK JOURNAL SEQ. #"_JNL(CURREC)_"?")
 . I CONF="Y" D
 . . D ROLLBACK^TTJOURNAL(JNL(CURREC))
 . . D MSGBOX^TTUI("JOURNAL SEQ. #"_JNL(CURREC)_" ROLLED BACK.",0,"IGLS")
 . . G RELOAD
 I KEY="KEY_F6" S QUITFLG=1
 ;I KEY="KEY_PPAGE" D
 ;. I CUR>22 S CUR=CUR-22,CURREC=CURREC-22
 ;I KEY="KEY_NPAGE" D
 ;. I CUR<(RCNT-22) S CUR=CUR+22,CURREC=CURREC+22
 I KEY="A" S CUR=1,CURREC=1
 I KEY="Z" S CUR=(RCNT-(%IOCAP("ROWS")-5)),CURREC=RCNT-1
 G:QUITFLG=0 REDISPLAY
 Q

 ; 
 ; Retrieve account information/sequence numbers
 ; for journal JSEQ
 ; 
 ; JSEQ:	Journal sequence number
 ; RESULT: 	Return array (by reference)
 ;  RESULT("CREDIT","ACCOUNT")=<credit account number>
 ;  RESULT("CREDIT","SEQ")=<credit sequence number>
 ;  RESULT("CREDIT","PERIOD")=<credit accounting period>
 ;  RESULT("DEBIT","ACCOUNT")=<debit account number>
 ;  RESULT("DEBIT","SEQ")=<debit sequence number>
 ;  RESULT("DEBIT","PERIOD")=<debit sequence number>
 ;
LOOKUP(JSEQ,RESULT)
 N ANUM,PERIOD,SEQ,MATCHES S (ANUM,PERIOD,SEQ)=""
 N MCNT,AMT S MCNT=1,AMT=0
 F  S ANUM=$O(^TT("ACCT",ANUM)) Q:ANUM=""  D
 . F  S PERIOD=$O(^TT("ACCT",ANUM,PERIOD)) Q:PERIOD=""  D
 . . F  S SEQ=$O(^TT("ACCT",ANUM,PERIOD,SEQ)) Q:SEQ=""  D
 . . . I ^TT("ACCT",ANUM,PERIOD,SEQ,"JSEQ")=JSEQ D
 . . . . S AMT=^TT("ACCT",ANUM,PERIOD,SEQ)
 . . . . S MATCHES(MCNT,"AMOUNT")=AMT
 . . . . S MATCHES(MCNT,"ANUM")=ANUM
 . . . . S MATCHES(MCNT,"PERIOD")=PERIOD
 . . . . S MATCHES(MCNT,"SEQ")=SEQ
 . . . . S MCNT=MCNT+1
 S MCNT=MCNT-1
 N ATYPE,CREDOP,DEBOP
 F I=1:1:MCNT  D
 . S ANUM=MATCHES(I,"ANUM")
 . S AMT=MATCHES(I,"AMOUNT")
 . S ATYPE=$$ATYPE^TTACCOUNT(ANUM)
 . S DEBOP=$$OPER^TTACCOUNT(ANUM,"DEBIT")
 . S CREDOP=$$OPER^TTACCOUNT(ANUM,"CREDIT")
 . I $$ISCREDIT^TTACCOUNT(CREDOP,AMT) D
 . . S RESULT("CREDIT","ACCOUNT")=ANUM
 . . S RESULT("CREDIT","SEQ")=MATCHES(I,"SEQ")
 . . S RESULT("CREDIT","PERIOD")=MATCHES(I,"PERIOD")
 . . S RESULT("CREDIT","AMOUNT")=MATCHES(I,"AMOUNT")
 . I $$ISDEBIT^TTACCOUNT(DEBOP,AMT) D
 . . S RESULT("DEBIT","ACCOUNT")=ANUM
 . . S RESULT("DEBIT","SEQ")=MATCHES(I,"SEQ")
 . . S RESULT("DEBIT","PERIOD")=MATCHES(I,"PERIOD")
 . . S RESULT("DEBIT","AMOUNT")=MATCHES(I,"AMOUNT")
 Q MCNT

ROLLBACK(JSEQ)
 N RES,MCNT
 N CAMT,DAMT,CPERIOD,DPERIOD,CSEQ,DSEQ,DATE,DESC
 N CANUM,DANUM,CANAM,DANAM
 S MCNT=$$LOOKUP(JSEQ,.RES)
 S CPERIOD=RES("CREDIT","PERIOD")
 S DPERIOD=RES("DEBIT","PERIOD")
 S CANUM=RES("CREDIT","ACCOUNT")
 S DANUM=RES("DEBIT","ACCOUNT")
 S CANAM=^TT("ACCT",CANUM)
 S DANAM=^TT("ACCT",DANUM)
 S CAMT=RES("CREDIT","AMOUNT")
 S DAMT=RES("DEBIT","AMOUNT")
 I CAMT<0 S CAMT=$P(CAMT,"-",2)
 I DAMT<0 S DAMT=$P(DAMT,"-",2)
 S CSEQ=RES("CREDIT","SEQ")
 S DSEQ=RES("DEBIT","SEQ")
 S DATE=^TT("JNL",JSEQ,"DATE")
 S DESC=^TT("JNL",JSEQ)
 TS
 K ^TT("JNL",JSEQ)
 K ^TT("ACCT",CANUM,CPERIOD,CSEQ)
 K ^TT("ACCT",DANUM,DPERIOD,DSEQ)
 TC
 Q

RBA 
 N JSEQ S JSEQ=""
 F  S JSEQ=$O(^TT("JNL",JSEQ)) Q:JSEQ=""  D
 . D ROLLBACK^TTJOURNAL(JSEQ)
 N ANUM S ANUM=""
 F  S ANUM=$O(^TT("ACCT",ANUM)) Q:ANUM=""  D
 . S ^TT("ACCT",ANUM,"SEQ")=100
 S ^TT("COMPANY","JSEQ")=100
 Q

DESCRIBE(JSEQ)
 N RES,MCNT
 N CAMT,DAMT,CPERIOD,DPERIOD,CSEQ,DSEQ,DATE,DESC
 N CANUM,DANUM,CANAM,DANAM
 S MCNT=$$LOOKUP(JSEQ,.RES)
 S CPERIOD=RES("CREDIT","PERIOD")
 S DPERIOD=RES("DEBIT","PERIOD")
 S CANUM=RES("CREDIT","ACCOUNT")
 S DANUM=RES("DEBIT","ACCOUNT")
 S CANAM=^TT("ACCT",CANUM)
 S DANAM=^TT("ACCT",DANUM)
 S CAMT=RES("CREDIT","AMOUNT")
 S DAMT=RES("DEBIT","AMOUNT")
 I CAMT<0 S CAMT=$P(CAMT,"-",2)
 I DAMT<0 S DAMT=$P(DAMT,"-",2)
 S CSEQ=RES("CREDIT","SEQ")
 S DSEQ=RES("DEBIT","SEQ")
 S DATE=^TT("JNL",JSEQ,"DATE")
 S DESC=^TT("JNL",JSEQ)
 D INIT^TT,CAPTION^TTUI("JOURNAL SEQ. #"_JSEQ)
 D SETCOLOR^TTRNSI("GREEN","BLACK")
 D LOCATE^TTRNSI(4,6) W "DESCRIPTION:    ",DESC
 D LOCATE^TTRNSI(5,6) W "DATE:           ",DATE
 D LOCATE^TTRNSI(8,6),SETATTR^TTRNSI("BRIGHT") W "DEBIT TRANSACTION"
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 D LOCATE^TTRNSI(9,10) W "ACCOUNT #:       ",DANUM
 D LOCATE^TTRNSI(10,10) W "ACCOUNT NAME:    ",DANAM
 D LOCATE^TTRNSI(11,10) W "SEQUENCE NUMBER: ",DSEQ
 D LOCATE^TTRNSI(12,10) W "ACCTG. PERIOD:   ",DPERIOD
 D LOCATE^TTRNSI(13,10) W "AMOUNT:          ",DAMT
 D LOCATE^TTRNSI(15,6),SETATTR^TTRNSI("BRIGHT") W "CREDIT TRANSACTION"
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 D LOCATE^TTRNSI(16,10) W "ACCOUNT #:       ",CANUM
 D LOCATE^TTRNSI(17,10) W "ACCOUNT NAME:    ",CANAM
 D LOCATE^TTRNSI(18,10) W "SEQUENCE NUMBER: ",CSEQ
 D LOCATE^TTRNSI(19,10) W "ACCTG. PERIOD:   ",CPERIOD
 D LOCATE^TTRNSI(20,10) W "AMOUNT:          ",CAMT
 D LOCATE^TTRNSI(22,6)
 I CAMT=DAMT D
 . D SETCOLOR^TTRNSI("GREEN","BLACK"),SETATTR^TTRNSI("BRIGHT")
 . W "THIS TRANSACTION IS IN BALANCE"
 E  D
 . D SETCOLOR^TTRNSI("RED","BLACK"),SETATTR^TTRNSI("BRIGHT")
 . W "THIS TRANSACTION IS OUT OF BALANCE"
 D SETATTR^TTRNSI("RESET"),SETCOLOR^TTRNSI("GREEN","BLACK")
 D LOCATE^TTRNSI(%IOCAP("ROWS")-1,1) 
 F I=1:1:80 W BOX("H")
 D LOCATE^TTRNSI(%IOCAP("ROWS"),1),SETCOLOR^TTRNSI("MAGENTA","BLACK")
 D SETATTR^TTRNSI("BRIGHT") W "F1:HELP     F6:EXIT"
 D HOME^TTRNSI
 R *TMP
 Q

