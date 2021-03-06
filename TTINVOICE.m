TTINVOICE ;CLD/JPW - IGLS INVOICE ROUTINE;15 FEB 2017
;;0.9;IGLS;****;15 FEB 2017;Build 10
 N RESP,CONF,FILE,BACKDATE,BACKNUMBER,INVNUMBER,INVDATE
 N CUST S (CUST,INVNUMBER,INVDATE)="",(BACKDATE,BACKNUMBER)=0
 W # D INIT^TT
 D CAPTION^TTUI("RUN INVOICES")
 F  S CUST=$O(^TT("CUSTOMER",CUST)) Q:CUST=""  D
 . S RESP=$$CONFIRM^TTUI("RUN INVOICE FOR "_^TT("CUSTOMER",CUST)_"?")
 . D INIT^TT
 . D CAPTION^TTUI("RUN INVOICES")
 . I RESP="Y" D
 . . N FILENAME S FILENAME="TT/INVOICES/INVOICE_"_CUST_"_"_^TT("COMPANY","INVIDX")_".TXT"
 . . N FILE S FILE=FILENAME
 . . D INVOICE(CUST,$P,0)
 . . S CONF=$$CONFIRM^TTUI("SAVE AND SUBMIT TO CUSTOMER?")
 . . I CONF="Y" D
 . . . S RESP=$$CONFIRM^TTUI("BACKDATE THIS INVOICE?")
 . . . I RESP="Y" D
 . . . . S BACKDATE=1
 . . . . D CHOOSE^TTDATE($ZDATE($H),"INVOICE BACKDATE")
 . . . . S INVDATE=INTVAL
 . . . E  D
 . . . . S INVDATE=$ZDATE($H)
 . . . S RESP=$$CONFIRM^TTUI("BACKNUMBER THIS INVOICE?")
 . . . I RESP="Y" D
 . . . . S BACKNUMBER=1
 . . . . W !,"RESPOND INVOICE NUMBER "
 . . . . R INVNUMBER
 . . . . I $G(^TT("CUSTOMER",CUST,"INV",INVNUMBER))'="" D
 . . . . . W !,"INVOICE NUMBER ALREADY EXISTS.",! G BOTTOM
 . . . . S FILENAME="TT/INVOICES/INVOICE_"_CUST_"_"_INVNUMBER_".TXT"
 . . . . S FILE=FILENAME
 . . . O FILE:NEWVERSION
 . . . D INVOICE(CUST,FILE,1,INVDATE,INVNUMBER)
 . . . CLOSE FILE
 . . . D MAILCUST^TTNET(CUST,"Invoice","INVBODY.TXT",FILENAME)
 . . . D MAILTO^TTNET(^TT("COMPANY","EMAIL"),"Invoice","INVBODY.TXT",FILENAME)
 . . . D MSGBOX^TTUI("INVOICE "_(^TT("COMPANY","INVIDX")-1)_" SUBMITTED",0,"INVOICING")
 . . D INIT^TT
 . . D CAPTION^TTUI("RUN INVOICES")
BOTTOM
 Q

PREVIEW
 N CUSTCODE,RESULT,FILE
 S CUSTCODE=$$CHOOSE^TTCUST(.RESULT)
 D OPENTEMP^TTIO(.FILE)
 D INVOICE(CUSTCODE,FILE,0)
 D CLOSETEMP^TTIO(.FILE)
 D VIEW^TTFILE(FILE,"INVOICE PREVIEW")
 Q 

INVOICE(CUSTCODE,FILE,SETBILL,BACKDATE,BACKNUMBER)
 N INVDATE
 I $G(^TT("CUSTOMER",CUSTCODE))="" Q "ERROR"
 U FILE W !
 F I=1:1:32 W " "
 W "I N V O I C E",!,!
 S INVDATE=$G(BACKDATE,$ZDATE($H))
 I $G(BACKDATE)="" W "DATE:           ",$ZDATE($H),!
 E  W "DATE:           ",BACKDATE,! S INVDATE=BACKDATE
 I $G(BACKNUMBER)="" W "INVOICE #:      ",^TT("COMPANY","INVIDX"),!
 E  W "INVOICE #:      ",BACKNUMBER,! 
 W "CUSTOMER ID:    ",CUSTCODE,!,!
 W ^TT("COMPANY","NAME"),!
 W ^TT("COMPANY","STREET"),!
 W ^TT("COMPANY","CITY"),", ",^TT("COMPANY","STATE"),"  "
 W ^TT("COMPANY","ZIP"),!
 W "PHONE: ",^TT("COMPANY","PHONE"),!
 I ^TT("COMPANY","FAX")'="" W "FAX: ",^TT("COMPANY","FAX"),!
 W ^TT("COMPANY","URL")
 W !,!,"BILL TO:",!
 W ^TT("CUSTOMER",CUSTCODE),!
 W "ATTN: ",^TT("CUSTOMER",CUSTCODE,"POC"),!
 W ^TT("CUSTOMER",CUSTCODE,"STREET"),!
 W ^TT("CUSTOMER",CUSTCODE,"CITY"),", ",^TT("CUSTOMER",CUSTCODE,"STATE"),"  ",^TT("CUSTOMER",CUSTCODE,"POSTCODE"),!,!
 W "DATE" F I=0:1:49 W " "
 W $J("RATE/UNIT",11),$J("UNITS",7),$J("TOTAL",9),!
 F I=0:1:80 W "-"
 W !
 N DESC,DATE,UNITS,UNITPRICE,UNITTYPE
 N TAXRATE S TAXRATE=^TT("CUSTOMER",CUSTCODE,"TAXRATE")
 N UNITSTOT,INVTOT S (UNITSTOT,INVTOT)=0
 N INVIDX 
 I $G(BACKNUMBER)="" S INVIDX=^TT("COMPANY","INVIDX") 
 I $G(BACKNUMBER)'="" S INVIDX=BACKNUMBER
 N BILLED
 N ENTR S ENTR=""
 F  S ENTR=$O(^TT("ENTR",CUSTCODE,ENTR)) Q:ENTR=""  D
 . S DESC=^TT("ENTR",CUSTCODE,ENTR,"ITEM")
 . S UNITS=^TT("ENTR",CUSTCODE,ENTR,"UNITS")
 . S UNITPRICE=^TT("ENTR",CUSTCODE,ENTR,"UNITPRICE")
 . S UNITTYPE=^TT("ENTR",CUSTCODE,ENTR,"UNITTYPE")
 . S DATE=^TT("ENTR",CUSTCODE,ENTR,"DATE")
 . S BILLED=^TT("ENTR",CUSTCODE,ENTR,"BILLED")
 . I BILLED="NO" D
 . . S UNITSTOT=UNITSTOT+UNITS
 . . S INVTOT=INVTOT+$$LINEITEM(DESC,DATE,UNITPRICE,UNITS,UNITTYPE)
 . . I SETBILL=1 D
 . . . S ^TT("ENTR",CUSTCODE,ENTR,"BILLED")="YES"
 . . . I $G(BACKDATE)="" S ^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"DATE")=$ZDATE($H)
 . . . I $G(BACKDATE)'="" S ^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"DATE")=BACKDATE
 . . . S ^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"ITEMS",ENTR)=""
 D SUMMITEM("UNITS"," ",UNITSTOT,2)
 D SUMMITEM("SUBTOTAL","$",INVTOT,2)
 D SUMMITEM("TAX RATE %"," ",TAXRATE*100,4)
 N TAXAMT S TAXAMT=INVTOT*TAXRATE
 D SUMMITEM("TAX","$",TAXAMT,2)
 N GRANDTOT S GRANDTOT=INVTOT+TAXAMT
 D SUMMITEM("TOTAL","$",GRANDTOT,2)
 I SETBILL=1 D
 . S ^TT("COMPANY","INVIDX")=^TT("COMPANY","INVIDX")+1
 . S ^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"TOTAL")=GRANDTOT
 . S ^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"UNITS")=UNITSTOT
 . S ^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"DATE")=INVDATE
 . S ^TT("CUSTOMER",CUSTCODE,"INV",INVIDX,"PAID")=0
 U $P
 I SETBILL=1 D
 . I $G(^TT("CUSTOMER",CUSTCODE,"ACCTINTEG"))="TRUE" D
 . . N ACCTPER,DEBACCT,CREDACCT,POSTDATE,JOURNAL,POSTAMT,CHKNUM
 . . D CHOOSE^TTDATE($ZDATE($H),"INVOICE-ACCOUNTING POST DATE")
 . . S POSTDATE=INTVAL
 . . S ACCTPER=$$CHOOSEPERIOD^TTACCOUNT
 . . S DEBACCT=^TT("CUSTOMER",CUSTCODE,"INVDEB")
 . . S CREDACCT=^TT("CUSTOMER",CUSTCODE,"INVCRED")
 . . S JOURNAL=^TT("CUSTOMER",CUSTCODE)_" INVOICE "_INVIDX
 . . S POSTAMT=INVTOT
 . . S CHKNUM=INVIDX
 . . D POST^TTACCOUNT(POSTDATE,POSTAMT,CREDACCT,DEBACCT,ACCTPER,JOURNAL,CHKNUM)
 Q

LINEITEM(DESC,DATE,UNITPRICE,UNITS,UNITTYPE)
 N DATEPAD,UPTEXT
 S UPTEXT=$J(UNITPRICE,1,2)_"/"_UNITTYPE
 N TOTAL S TOTAL=UNITPRICE*UNITS
 S DATEPAD=64-$L(DATE)-$L(UPTEXT)
 W DATE F I=0:1:DATEPAD W " "
 W UPTEXT
 W $J(UNITS,7,2)
 W $J(TOTAL,9,2),!,"    ",DESC,!
 Q TOTAL

SUMMITEM(CAPTION,DEL,AMOUNT,PLACES)
 F I=0:1:55 W " "
 N CPAD S CPAD=13-$L(CAPTION)
 W CAPTION F I=0:1:CPAD W " "
 W DEL,$J(AMOUNT,9,PLACES),!
 Q

OUTSTAND(COMPCODE)
 N INVIDX S INVIDX=""
 N TOTAL S TOTAL=0
 F  S INVIDX=$O(^TT("CUSTOMER",COMPCODE,INVIDX)) Q:INVIDX=""  D
 . S TOTAL=TOTAL+^TT("CUSTOMER",COMPCODE,INVIDX,"TOTAL")
 Q TOTAL
