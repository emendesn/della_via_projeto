#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DEVSEG   บAutor  ณMarcelo Alcantara   บ Data ณ  22/12/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ CSA              ณContato ณ marcelo.alcantara@microsiga... บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Efetua gravacao do No e Serie da Nota fiscal de entrada    บฑฑ
ฑฑบ          ณ para o seguros que foram devolvidos.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamado Via Menu.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Della Via Pneus                                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DEVSEG()

Local _cPerg:= "DEVSEG"
Local dIni
Local dFin

Pergunte(_cPerg,.T.)
dIni:= MV_PAR01
dFim:= MV_PAR02

If MsgNoYes(OemtoAnsi("Confirma processamento?"), "Pergunta")
	Processa({|| Continua(dIni, dFim)}, "Processando...")
EndIf

Return

Static Function Continua(dIni, dFim)
Local cSQL := ""

cSQL := "SELECT PA8_LOJSG, PA8_NFSG, PA8_SRSG, PA8_DTSG, PA8_ITREF, PA8_NFDEV, PA8_SRDEV, PA8_CODCLI, PA8_LOJCLI, PA8_CPROSG,"
cSQL += " PA8_FILIAL, PA8_ORCSG, PA8_ITEM,"
cSQL += " (SELECT Count(*) FROM " + RetSQLName("PA8") + " WHERE PA8_DTSG BETWEEN '" + DtoS(dIni) + "' and '" + DtoS(dFim) + "') as TotRec"
cSQL += " FROM " + RetSQLName("PA8")
cSQL += " WHERE PA8_DTSG BETWEEN '" + DtoS(dIni) + "' and '" + DtoS(dFim) + "'"
cSQL += " AND PA8_NFSG <> ''"
cSQL += " ORDER BY PA8_LOJSG, PA8_NFSG, PA8_SRSG"

cSQL := ChangeQuery(cSQL)

MemoWrite("DEVSEG.SQL", cSQL)
dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "PA8TMP", .F., .T.)

tcSetField("PA8TMP", "PA8_DTSG", "D")

dbSelectArea("PA8TMP")
ProcRegua(PA8TMP->TotRec)
dbGoTop()

While !EOF()
	IncProc()
	SD2->(dbSetOrder(3))
	If SD2->(dbSeek(PA8TMP->(PA8_LOJSG + PA8_NFSG + PA8_SRSG + PA8_CODCLI + PA8_LOJCLI + PA8_CPROSG + PA8_ITREF ))) 
		If SD2->D2_VALDEV > 0
			SD1->(dbSetOrder(11))
			If SD1->(dbSeek(PA8TMP->(PA8_LOJSG + PA8_NFSG + PA8_SRSG + PA8_ITREF)))
				dbSelectArea("PA8")
				dbSetOrder(4)
				If dbSeek(XFILIAL("PA8")+PA8TMP->(PA8_LOJSG + PA8_ORCSG + PA8_ITEM))
					RecLock("PA8", .F.)
					PA8->PA8_NFDEV:= SD1->D1_DOC
					PA8->PA8_SRDEV:= SD1->D1_SERIE
					msUnlock()
				EndIf	
				dbSelectArea("PA8TMP")
			EndIf   
		EndIF
    Else
		If PA8TMP->PA8_DTSG >= CTOD("01/10/05")
			dbSelectArea("PA8")
			dbSetOrder(4)
			If dbSeek(XFILIAL("PA8")+PA8TMP->(PA8_LOJSG + PA8_ORCSG + PA8_ITEM))
				RecLock("PA8", .F.)
				PA8->PA8_NFDEV:= "CANCEL"
				msUnlock()
			EndIf
			dbSelectArea("PA8TMP")
		EndIF
	EndIf
	dbSkip()
EndDo

dbSelectArea("PA8TMP")
dbCloseArea()

Return
