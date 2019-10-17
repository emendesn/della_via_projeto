/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SQLDemo   ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Demostra o uso do RDMake com SQL                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

USER Function TesteSQL1

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" MODULO "loja" // Prepara Ambiente para teste

dbSelectArea("SX5")
if RDDName() <> "TOPCONN"
   MsgStop("Este Rotina só pode ser com TopConnectrodadaEste ")
   Return nil
endif

@ 0,0 TO 400,600 DIALOG oDlg7 TITLE "Transferencia Automatica"

cQuery := "SELECT cr.E1_Tipo, X.X5_DESCRI DESC, Sum(cr.E1_valor) Valor From SE1010 cr, sx5010 X"
cQuery += " WHERE cr.E1_FILIAL = '03' AND cr.E1_EMISSAO='"+DtoS(dDataBase)+"' AND"
CQuery += " cr.E1_TIPO<>'R$' AND (cr.E1_TIPO<>'CH' OR (cr.E1_TIPO='CH' AND cr.E1_EMISSAO<>cr.E1_VENCTO)) AND"
cQuery += " cr.E1_FILIAL = X.X5_FILIAL AND X.X5_TABELA='24' AND CR.E1_TIPO = X.X5_CHAVE"
cQuery += " GROUP BY E1_TIPO, X.X5_DESCRI"

//cQuery := cQuery + " X.X5_TABELA = '12' AND"
//cQuery := cQuery + " A.A1_EST = X.X5_CHAVE"
//TCQuery Abre uma workarea com o resultado da query

TCQUERY cQuery NEW ALIAS "QRY"

//cria arquivo temporario e abre workarea
aCampos:= dbStruct()
cArqTrb:= criaTrab(aCampos,.t.)
dbUseArea(.T.,, cArqTrb, "TMP", .f.,.f.)
msErase("TMP")
msCopyTo("QRY","TMP")
dbselectArea("TMP")
dbGoTop()

aCampos := {}
AADD(aCampos,{"E1_TIPO","TIPO",""})
AADD(aCampos,{"DESC","DESCRICAO",""})
AADD(aCampos,{"Valor","Valor","@E 999,999.99"})

//AADD(aCampos,{"X5_DESCRI","Estado"})

@ 6,5 TO 180,300 BROWSE "TMP" FIELDS aCampos
@ 180,200 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg7)
ACTIVATE DIALOG oDlg7 CENTERED

dbSelectArea("QRY")
dbCloseArea() //Fecha Query
dbSelectArea("TMP")
dbCloseArea() //Fecha aarquivo temporario
fErase(cArqTrb+".*") //apaga arquivo temporario
Return nil
