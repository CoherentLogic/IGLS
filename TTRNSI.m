TTRNSI
 Q

ESC(SEQ)
 W $C(27)_SEQ
 Q

RESET
 D ESC("c")
 Q

CLEAR
 D ESC("[2J")
 Q

HOME
 D LOCATE(24,80)
 Q

SCROLLREGION(TOP,BOTTOM)
 N ES S ES="["_TOP_";"_BOTTOM_"r"
 D ESC(ES)
 Q

NOSCROLLREGION
 D ESC("[r")
 Q

SETCOLOR(FG,BG)
 N ES S ES="["_SCRAT(FG)_";"_(SCRAT(BG)+10)_"m"
 D ESC(ES)
 Q

SETATTR(ATTR)
 N ES S ES="["_SCRAT(ATTR)_"m"
 D ESC(ES)
 Q

ERASETOEOL
 N ES S ES="[K"
 D ESC(ES)
 Q

ERASETOBOL
 N ES S ES="[1K"
 D ESC(ES)
 Q

ERASELINE
 N ES S ES="[2K"
 D ESC(ES)
 Q

ERASEDOWN
 N ES S ES="[J"
 D ESC(ES)
 Q

ERASEUP
 N ES S ES="[1J"
 D ESC(ES)
 Q


LOCATE(ROW,COL)
 S $X=COL,$Y=ROW
 N ES S ES="["_ROW_";"_COL_"H"
 D ESC(ES)
 Q

INIT
 D INIT^%TERMIO
 S G0=$C(27)_"(B"
 S G1=$C(27)_"(0"
 S BOX("UL")=G1_"l"_G0,BOX("UR")=G1_"k"_G0,BOX("LL")=G1_"m"_G0,BOX("LR")=G1_"j"_G0
 S BOX("LT")=G1_"t"_G0,BOX("RT")=G1_"u"_G0,BOX("V")=G1_"x"_G0,BOX("H")=G1_"q"_G0
 S SCRAT("RESET")=0
 S SCRAT("BRIGHT")=1
 S SCRAT("DIM")=2
 S SCRAT("UNDERSCORE")=4
 S SCRAT("BLINK")=5
 S SCRAT("REVERSE")=7
 S SCRAT("HIDDEN")=8
 S SCRAT("BLACK")=30
 S SCRAT("RED")=31
 S SCRAT("GREEN")=32
 S SCRAT("YELLOW")=33
 S SCRAT("BLUE")=34
 S SCRAT("MAGENTA")=35
 S SCRAT("CYAN")=36
 S SCRAT("WHITE")=37
 Q