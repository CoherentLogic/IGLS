KBAWTCC ;DLW**Compiles a database of termcap entries ; 3/22/10 4:04pm
 ;;0.1;MASH;;David Wicksell @2010
 ;
 ; $Source: /home/vpe/dev/RCS/KBAWTCC.m,v $
 ; $Revision: 20100322.1 $
 ;
 ; Copyright © 2010 Fourth Watch Software
 ; DL Wicksell <dlw@linux.com>
 ; Licensed under the terms of the GNU Affero General
 ; Public License. See attached copy of the License.
 ;
 L +^%IOCAP("TERMCAP"):1
 I '$T W "Global %IOCAP(""TERMCAP"") not available." Q
 K ^%IOCAP("TERMCAP")
 ;
 N %TM,%DATA,%CDATA
 S %TM="" F  S %TM=$O(^%IOCAP("SOURCE","TERMCAP",%TM)) Q:%TM=""  D
 . S ^%IOCAP("TERMCAP",%TM)=^(%TM)
 . N %CP
 . S %CP="" F  S %CP=$O(^%IOCAP("SOURCE","TERMCAP",%TM,%CP)) Q:%CP=""  D
 . . S %DATA=^(%CP)
 . . I %DATA["\E" N I F I=1:1:$L(%DATA,"\E") D
 . . . S %CDATA=$G(%CDATA)_$P(%DATA,"\E",I)_$C(27)
 . . S %CDATA=$E(%CDATA,1,$L(%CDATA)-1)
 . . E  S %CDATA=%DATA
 . . S ^%IOCAP("TERMCAP",%TM,%CP)=%CDATA,%CDATA=""
 ;
 L -^%IOCAP("TERMCAP")
 Q
 ;
 ; $RCSfile: KBAWTCC.m,v $
