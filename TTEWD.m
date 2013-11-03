TTEWD
 Q
 ;
INIT(sessid)
 D COA(sessid)
 Q ""
 ;
LOGIN(sessid)
 N RET,USERNAME,PASSWORD
 S USERNAME=$$getSessionValue^%zewdAPI("txtUsername",sessid)
 S PASSWORD=$$getSessionValue^%zewdAPI("txtPassword",sessid)
 S RET=$$AUTH^TTAUTH(USERNAME,PASSWORD)
 Q:RET=0 "Invalid username or password."
 Q ""
 ;
COA(sessid)
 N GRID,GIDX,ANUM S GIDX=1,ANUM=""
 F  S ANUM=$O(^TT("ACCT",ANUM)) Q:ANUM=""  D
 . S GRID(GIDX,"ACCT")=ANUM
 . S GRID(GIDX,"NAME")=^TT("ACCT",ANUM)
 . S GRID(GIDX,"TYPE")=^TT("ACCT",ANUM,"TYPE")
 . S GRID(GIDX,"BALANCE")=$$BALF^TTACCOUNT(ANUM)
 . S GIDX=$I(GIDX)
 D deleteFromSession^%zewdAPI("grdAccounts",sessid)
 D mergeArrayToSession^%zewdAPI(.GRID,"grdAccounts",sessid)
 Q
 ;