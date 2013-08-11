TTPAYMENT
 Q

RECEIVE
 N DATE,CHKNUM,MEMO,CUSTCODE,AMOUNT,NMGRTAMOUNT
 N CUSTREC,PMTIDX
 S CUSTCODE=$$CHOOSE^TTCUST(.CUSTREC) 
 W !,"RESPOND PAYMENT DATE   "
 S DATE=$$CHOOSE^TTDATE
 W !,"RESPOND CHECK NUMBER   "
 R CHKNUM
 W !,"RESPOND PAYMENT MEMO   "
 R MEMO
 W !,"RESPOND PAYMENT AMOUNT "
 R AMOUNT
 W !,"RESPOND NMGRT TAXABLE AMOUNT "
 R NMGRTAMOUNT
 S PMTIDX=^TT("COMPANY","PMTIDX")
 S ^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"DATE")=DATE
 S ^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"CHKNUM")=CHKNUM
 S ^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"MEMO")=MEMO
 S ^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"AMOUNT")=AMOUNT
 S ^TT("CUSTOMER",CUSTCODE,"PAYMENTS",PMTIDX,"NMGRTAMOUNT")=NMGRTAMOUNT
 S ^TT("COMPANY","PMTIDX")=PMTIDX+1
 I ^TT("CUSTOMER",CUSTCODE,"ACCTINTEG")="TRUE" D
 . N ACCTPER,DEBACCT,CREDACCT,POSTDATE,JOURNAL,POSTAMT
 . W !,"ENTERING PAYMENT TO ACCOUNTING SYSTEM",!
 . W !,"PAYMENT POST DATE: ",!
 . S POSTDATE=$$CHOOSE^TTDATE
 . S ACCTPER=$$CHOOSEPERIOD^TTACCOUNT
 . S DEBACCT=^TT("CUSTOMER",CUSTCODE,"PMTDEB")
 . S CREDACCT=^TT("CUSTOMER",CUSTCODE,"PMTCRED")
 . S JOURNAL=^TT("CUSTOMER",CUSTCODE)_" PAYMENT "_PMTIDX
 . S POSTAMT=AMOUNT
 . D POST^TTACCOUNT(POSTDATE,POSTAMT,CREDACCT,DEBACCT,ACCTPER,JOURNAL)
 Q