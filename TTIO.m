TTIO
 Q

GET(EVENT)
 N FIRST,SECOND,THIRD 
 S (FIRST,SECOND,THIRD)=""
 S EVENT("CONTROL")="KEYPRESS"
 R *FIRST
 I FIRST=27 D 
 . R *SECOND,*THIRD
 . S EVENT("CODE",2)=SECOND,EVENT("CODE",3)=THIRD
 . S EVENT("CHARACTER",2)=$C(SECOND),EVENT("CHARACTER",3)=$C(THIRD)
 . I $C(THIRD)="A" S EVENT("CONTROL")="UP"
 . I $C(THIRD)="B" S EVENT("CONTROL")="DOWN"
 . I $C(THIRD)="C" S EVENT("CONTROL")="RIGHT"
 . I $C(THIRD)="D" S EVENT("CONTROL")="LEFT"
 I FIRST=13 S EVENT("CONTROL")="ENTER"
 S EVENT("CODE",1)=FIRST
 S EVENT("CHARACTER",1)=$C(FIRST)
 Q

OPENTEMP(HANDLE)
 S HANDLE="TT/"_$J_".TMP"
 O HANDLE:(TRUNCATE:NEWVERSION)
 U HANDLE 
 Q

CLOSETEMP(HANDLE)
 U $P
 C HANDLE
 Q
