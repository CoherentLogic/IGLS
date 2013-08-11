KBBMMENU ;CLD/JOLLIS-MENU TOOLS ;10:24 PM 2-21-2013
 ;;0.1;CLIME;****;Feb. 21, 2013

;
; MA structure
; MA("TITLE")="Menu Title"
; MA("DEFAULT")=Index to default menu item
; MA("ITEMS",KEY)="CODE TO EXECUTE"
;

GO(MA)
 N ITEM,CHOICE,SUCCESS,ICNT S ITEM="",(SUCCESS,ICNT)=0
 N CHLEN,MCNT,MATCHES,CHCEMAT,FIRST S FIRST="",MCNT=0
INVALID
 I $G(MA("DEFAULT"),"")="" S MA("DEFAULT")=$O(MA("ITEMS",FIRST))
 W !,"RESPOND ",MA("TITLE"),": ",MA("DEFAULT"),"//"
 R CHOICE
 I CHOICE="^" Q
 I CHOICE="?" D DISPMENU(.MA) G INVALID
 I CHOICE="" X MA("ITEMS",MA("DEFAULT")) G ENDGO
 S ITEM=""
 S CHOICE=$$UCASE^KBBMMENU(CHOICE)
 S CHLEN=$L(CHOICE)
 K MATCHES
 S MCNT=0
 F  S ITEM=$O(MA("ITEMS",ITEM)) Q:ITEM=""  D
 .I $E($$UCASE^KBBMMENU(ITEM),1,CHLEN)=CHOICE D
 ..S MCNT=MCNT+1
 ..S MATCHES(MCNT)=ITEM
 S SUCCESS=0
 I MCNT=1 S SUCCESS=1 W $E(MATCHES(1),CHLEN+1,$L(MATCHES(1))),! X MA("ITEMS",MATCHES(1))
 I MCNT>1 D
 .W !
 .F I=1:1:MCNT  D
 ..W $J(I,6),"  ",MATCHES(I),!
 .W "Press '^' to exit this list, or choose 1-",MCNT,": "
 .R CHCEMAT
 .I CHCEMAT="^" W ! G INVALID
 .I (CHCEMAT'<1)&(CHCEMAT'>MCNT) S SUCCESS=1 W ! X MA("ITEMS",MATCHES(CHCEMAT))
 .I (CHCEMAT<1)!(CHCEMAT>MCNT) S SUCCESS=0
 I SUCCESS=0 W "??",! G INVALID
ENDGO
 Q

DISPMENU(MA)
 W !
 F  S ITEM=$O(MA("ITEMS",ITEM)) Q:ITEM=""  D
 . W "   ",ITEM,!
 Q

UCASE(STR)
 Q $TR(STR,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
