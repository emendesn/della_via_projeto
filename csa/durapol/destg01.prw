#include "rwmake.ch"

User Function DESTG01 (_cCampo)

Local _aArea        := GetArea()
Local _cRet         := ""

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilia("SB1")+_cCampo)

_cRet := SB1->B1_LOCPAD

RestArea (_aArea)

Return(_cRet)