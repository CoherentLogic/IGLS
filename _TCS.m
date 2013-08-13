KBAWTCS ;DLW**Builds a database of termcap source entries ; 3/22/10 4:04pm
 ;;0.1;MASH;;David Wicksell @2010
 ;
 ; $Source: /home/vpe/dev/RCS/KBAWTCS.m,v $
 ; $Revision: 20100322.1 $
 ;
 ; Copyright © 2010 Fourth Watch Software
 ; DL Wicksell <dlw@linux.com>
 ; Licensed under the terms of the GNU Affero General
 ; Public License. See attached copy of the License.
 ;
 N %FILE S %FILE="termtypes.tc"
 S %TST=$$RET("ls "_%FILE)
 I %TST["ls:" W "termtypes.tc file does not exist in this directory.",! Q
 O %FILE:(READONLY:EXCEPTION="G EOF")
 L +^%IOCAP("SOURCE","TERMCAP"):1
 I '$T W "Global %IOCAP(""SOURCE"",""TERMCAP"") not available." Q
 K ^%IOCAP("SOURCE","TERMCAP")
 ;
 N %EOF,%VER,%INDEX S %EOF=0,%VER=1
 F  D  Q:%EOF
 . N %LINE,%POS
 . U:'%EOF %FILE R %LINE
 . I %VER,%LINE["Version" D
 . . S %POS=$F(%LINE,"V"),^%IOCAP("SOURCE","TERMCAP")=$E(%LINE,%POS-1,80),%VER=0
 . I $E(%LINE)="#" Q
 . I $L(%LINE)<2 Q
 . N %TERM,%RINDEX
 . I $E(%LINE)'=$C(9)&($E(%LINE)'=" ") D  Q
 . . S %TERM=$P(%LINE,":"),%INDEX=$P(%TERM,"|"),%RINDEX=$P(%TERM,"|",2,5)
 . . S ^%IOCAP("SOURCE","TERMCAP",%INDEX)=%RINDEX
 . N %NUM,%ATTR,%NAME,%VAL
 . I $E(%LINE)=$C(9)!($E(%LINE)=" ") D
 . . S %NUM=$L(%LINE,":") N %I F %I=2:1:%NUM-1 D
 . . . S %ATTR=$P(%LINE,":",%I)
 . . . I %ATTR["=" D  Q
 . . . . S %NAME=$P(%ATTR,"="),%VAL=$P(%ATTR,"=",2)
 . . . . S ^%IOCAP("SOURCE","TERMCAP",%INDEX,%NAME)=%VAL
 . . . I %ATTR["#" D  Q
 . . . . S %NAME=$P(%ATTR,"#"),%VAL=$P(%ATTR,"#",2)
 . . . . S ^%IOCAP("SOURCE","TERMCAP",%INDEX,%NAME)=%VAL
 . . . S ^%IOCAP("SOURCE","TERMCAP",%INDEX,%ATTR)=""
 L -^%IOCAP("SOURCE","TERMCAP")
 Q
 ;
EOF ; Handle End-of-File
 C %FILE
 S %EOF=1
 Q
 ;
RET(%COM) ; Execute a shell command & return the resulting value
 ; COM is the string value of the Linux command
 N %TVAL S %TVAL="" ; value to return
 N %TFILE S %TFILE="/tmp/termtypes"_$J_".txt" ; temporary results file
 ZSY %COM_" > "_%TFILE_" 2>&1" ; execute command & save result
 O %TFILE:REWIND U %TFILE
 R:'$ZEOF %TVAL:99 ; fetch value until end of file
 C %TFILE:DELETE ; delete file
 Q %TVAL
 ;
 ; $RCSfile: KBAWTCS.m,v $
