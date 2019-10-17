User Function MTA650I
LOCAL cMsg := ""

cMsg := "Pedido      : " + SC6->C6_NUM +chr(13)+chr(10)
cMsg += "Num OP C6   : " + SC6->C6_NUMOP + CHR(13)+CHR(10)
cMsg += "Item        : " + SC6->C6_ITEM + CHR(13)+chr(10)
cMsg += "SC6 PRODUTO : " + SC6->C6_PRODUTO + CHR(13)+chr(10)
cMsg += "SC2 ITEM    : " + SC2->C2_ITEM + CHR(13)+chr(10)

IW_MSGBOX(cMsg,"BZZZZZZ...   DEBUG ANTES ","INFO")

Replace C2_NUM With SC6->C6_NUM
Replace C2_ITEM With SUBST(SC6->C6_ITEMORI,3,2)
REPLACE C2_XNREDUZ WITH "GRAVOU"

IW_MSGBOX(cMsg,"BZZZZZZ...   DEBUG DEPOIS ","INFO")

Return