#INCLUDE "rwmake.ch"

User Function ReimpCX()
local _cPerg:= "RELFCX"
local _cData

Pergunte(_cPerg,.T.)

_cData:= MV_PAR01
u_RelFecx(_cData)

Return nil

