#include "rwmake.ch"

User Function FUNCNPJ()

Local aSaveArea := GetArea()

Local _cReturn := " "
local _nrecno  := 0
local _ccodemp := SM0->M0_CODIGO

DbSelectArea("SM0")
_nrecno := recno()

dbgotop()
while !eof()
 if m0_codfil == "01" .and. m0_codigo==_ccodemp
   _cReturn := SM0->M0_CGC
 end
 dbskip()
End

dbgoto(_nrecno)

RestArea(aSaveArea) //restaura a Area de entrada

Return(_cReturn)
