TT
 ;S $ETRAP="G ERROR^TT"
 S $ZDATEFORM=2 
 D INIT
 N RESP
 D PRIMARY

PRIMARY
 N MA
 S MA("TITLE")="MAIN MENU"
 S MA("DEFAULT")="LIST LOGS"
 S MA("ITEMS","GENERAL LEDGER SYSTEM")="D ^TTACCOUNT"
 S MA("ITEMS","START LOG")="D START^TTLOG"
 S MA("ITEMS","STOP LOG")="D STOP^TTLOG"
 S MA("ITEMS","LIST LOGS")="D LIST^TTLOG"
 S MA("ITEMS","CUSTOMER MANAGEMENT")="D ^TTCUST"
 S MA("ITEMS","SETUP SYSTEM")="D ^TTSETUP"
 S MA("ITEMS","NEW ENTRY")="D CREATE^TTENTRY"
 S MA("ITEMS","RUN INVOICES")="D ^TTINVOICE"
 S MA("ITEMS","PREVIEW INVOICE")="D PREVIEW^TTINVOICE"
 S MA("ITEMS","RECEIVE PAYMENT")="D RECEIVE^TTPAYMENT"
 S MA("ITEMS","QUIT IGLS")="D QUITIGLS^TT"
 D GO^TTMENU(.MA)
 G PRIMARY

QUITIGLS
 D ESC^TTRNSI("c")
 HALT

INIT
 U $P:CONVERT
 D INIT^TTRNSI
 D NOSCROLLREGION^TTRNSI
 D SETCOLOR^TTRNSI("WHITE","BLACK")
 D CLEAR^TTRNSI
 D SCROLLREGION^TTRNSI(3,22)
 D LOCATE^TTRNSI(1,1)
 D SETATTR^TTRNSI("BRIGHT")
 D SETCOLOR^TTRNSI("CYAN","BLACK")
 W "IGLS"
 D SETATTR^TTRNSI("RESET")
 D SETCOLOR^TTRNSI("GREEN","BLACK")
 D LOCATE^TTRNSI(1,69)
 W "VERSION 0.01"
 D SETCOLOR^TTRNSI("GREEN","BLACK")
 D LOCATE^TTRNSI(2,1)
 F I=1:1:80 W "-"
 D LOCATE^TTRNSI(23,1)
 F I=1:1:80 W "-"
 D LOCATE^TTRNSI(3,1)
 Q

ERROR
 D ESC^TTRNSI("c")
 ZWR
 BREAK
 Q

RESET
 D ESC^TTRNSI("c")
 Q