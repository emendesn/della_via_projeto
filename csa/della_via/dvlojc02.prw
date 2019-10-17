#include "rwmake.ch"
#include "font.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DVLOJC02
	Local   cPerg    := "DVLJ02"
	Private cNomTmp  := ""
	Private cNome    := ""
	Private nFundoCx := 0
	Private nLimCom  := 0
	Private nLimMes  := 0
	Private nDespDia := 0
	Private nDespMes := 0
	Private nLastKey := 0
	Private aRegs    := {}
	Private aCampos  := {}

	aAdd(aRegs,{cPerg,"01","Data               ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""     ,"","","","",""          ,"","","","","","","","","","","","","","","","","","","   ","","","",""})
	aAdd(aRegs,{cPerg,"02","Mostra             ?"," "," ","mv_ch2","N", 01,0,0,"C","","mv_par02","Todas","","","","","Abt. Saldo","","","","","","","","","","","","","","","","","","","   ","","","",""})
	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	
	If !Pergunte(cPerg,.T.)
		Return nil
	Endif

	PrcDados()

	dbSelectArea("TMP")
	aadd(aCampos,{"E5_DATA"   ,"Data"     ,})
	aadd(aCampos,{"ED_DESCRIC","Descrição","@!"})
	aadd(aCampos,{"E5_VALOR"  ,"Valor"    ,"@e 99,999,999,999.99"})
	aadd(aCampos,{"E5_HISTOR" ,"Histórico","@!"})

	Define Font oFontBold Name "Arial" Size 0, -11 Bold

	@ 000,000 TO 430,640 DIALOG oDlg1 TITLE "Saldos de Caixa"

	@ 005,005 TO 020,315 //Loja
	@ 010,010 SAY "Loja "+SM0->M0_CODFIL+" - "+cNome Object oLblLoja

	@ 025,005 TO 040,315 //Limites
	@ 030,010 SAY "Fundo de Abertura:" Object oLbl01
	@ 030,065 SAY " R$ "+Transform(nFundoCx,"@e 99,999.99") Object oVal01
	@ 030,130 SAY "Limite Diário:" Object oLbl02
	@ 030,170 SAY " R$ "+Transform(nLimCom,"@e 99,999.99") Object oVal02
	@ 030,235 SAY "Limite Mensal:" Object oLbl03
	@ 030,280 SAY " R$ "+Transform(nLimMes,"@e 99,999.99") Object oVal03

	@ 050,005 TO 185,315 //Despesas
	@ 055,010 SAY "Despesas em "+dtoc(mv_par01)+":" Object oLbl04
	@ 055,075 SAY " R$ "+Transform(nDespDia,"@e 99,999.99") Object oVal04
	@ 055,190 SAY "Despesas do Mes até "+dtoc(mv_par01)+":" Object oLbl05
	@ 055,280 SAY " R$ "+Transform(nDespMes,"@e 99,999.99") Object oVal05
	@ 065,010 TO 180,310 BROWSE "TMP" Object oBrw FIELDS aCampos

	/*
	@ 190,005 TO 205,315 //Saldos
	@ 195,010 SAY "Saldo do Dia "+dtoc(mv_par01)+":" Object oLbl06
	@ 195,075 SAY " R$ "+Transform(nLimCom-nDespDia,"@e 99,999.99") Color iif((nLimCom-nDespDia)<=0,255,16711680)  Object oVal06
	@ 195,200 SAY "Saldo do Mes até "+dtoc(mv_par01)+":" Object oLbl07
	@ 195,280 SAY " R$ "+Transform(nLimMes-nDespMes,"@e 99,999.99") Color iif((nLimMes-nDespMes)<=0,255,16711680)  Object oVal07
	*/

	@ 190,005 TO 210,315 //Botões
	@ 197,010 SAY "Saldo do Mes até "+dtoc(mv_par01)+":" Object oLbl07
	@ 197,085 SAY " R$ "+Transform(nLimMes-nDespMes,"@e 99,999.99") Color iif((nLimMes-nDespMes)<=0,255,16711680)  Object oVal07
	@ 195,220 BMPBUTTON TYPE  1 ACTION Close(oDlg1)
	@ 195,250 BMPBUTTON TYPE  5 ACTION AtuTela(cPerg)
	@ 195,280 BMPBUTTON TYPE  6 ACTION Imprime()

	oLblLoja:oFont := oFontBold
	oLbl01:oFont := oFontBold
	oLbl02:oFont := oFontBold
	oLbl03:oFont := oFontBold
	oLbl04:oFont := oFontBold
	oLbl05:oFont := oFontBold
	//oLbl06:oFont := oFontBold
	oLbl07:oFont := oFontBold

	ACTIVATE DIALOG oDlg1 CENTERED
	
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
Return nil

Static Function Imprime()
	Private cString        := ""
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Despesas de Caixa"
	Private tamanho        := "P"
	Private nomeprog       := "DVLOJC02"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private titulo         := "Despesas de Caixa"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DVLOJC02"

	wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
	   Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
	   Return
	Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return nil

Static Function RunReport()
	Cabec1:=" Data       Descrição                          Valor   Histórico"
	        * 99/99/99   XXXXXXXXXXXXXXXXXXXX   99,999,999,999.99   XXXXXXXXXXXXXXXXXXXX
    	    *012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8

	nRec := Recno()
	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()

	if li>55
		LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
		LI++
	endif
	
	@ LI,000 PSAY "Loja "+SM0->M0_CODFIL+" - "+cNome
	LI+=2
	@ LI,000 PSAY "Fundo de Abertura: R$ "+Transform(nFundoCx,"@e 99,999.99")
	LI++
	@ LI,000 PSAY "Limite Diário: R$ "+Transform(nLimCom,"@e 99,999.99")
	@ LI,038 PSAY "Limite Mensal: R$ "+Transform(nLimMes,"@e 99,999.99")
	LI+=2

	@ LI,000 PSAY "Despesas em "+dtoc(mv_par01)+": R$ "+Transform(nDespDia,"@e 99,999.99")
	@ LI,038 PSAY "Despesas do Mes até "+dtoc(mv_par01)+": R$ "+Transform(nDespMes,"@e 99,999.99")
	LI++
	@ LI,000 PSAY IniFatLine+FimFatLine
	LI+=2

	Do While !eof()
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			exit
		Endif

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif

		@ LI,001 PSAY E5_DATA
		@ LI,012 PSAY Substr(ED_DESCRIC,1,20)
		@ LI,035 PSAY E5_VALOR PICTURE "@e 99,999,999,999.99"
		@ LI,055 PSAY Substr(E5_HISTOR,1,20)
		LI++
		dbSkip()
	Enddo

	
	@ LI,000 PSAY IniFatLine+FimFatLine
	LI++
	//@ LI,000 PSAY "Saldo do Dia "+dtoc(mv_par01)+": R$ "+Transform(nLimCom-nDespDia,"@e 99,999.99")
	@ LI,000 PSAY "Saldo do Mes até "+dtoc(mv_par01)+": R$ "+Transform(nLimMes-nDespMes,"@e 99,999.99")
	LI++
	@ LI,000 PSAY IniFatLine+FimFatLine

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
	dbGoTo(nRec)
Return nil

Static Function AtuTela(xPerg)
	If !Pergunte(xPerg,.T.)
		Return nil
	Endif

	dbSelectArea("TMP")
	dbCloseArea()

	PrcDados()
	
	oLbl04:cCaption := "Despesas em "+dtoc(mv_par01)+":"
	oLbl05:cCaption := "Despesas do Mes até "+dtoc(mv_par01)+":"
	//oLbl06:cCaption := "Saldo do Dia "+dtoc(mv_par01)+":"
	oLbl07:cCaption := "Saldo do Mes até "+dtoc(mv_par01)+":"
	oVal01:cCaption := " R$ "+Transform(nFundoCx,"@e 99,999.99")
	oVal02:cCaption := " R$ "+Transform(nLimCom,"@e 99,999.99")
	oVal03:cCaption := " R$ "+Transform(nLimMes,"@e 99,999.99")
	oVal04:cCaption := " R$ "+Transform(nDespDia,"@e 99,999.99")
	oVal05:cCaption := " R$ "+Transform(nDespMes,"@e 99,999.99")
	//oVal06:cCaption := " R$ "+Transform(nLimCom-nDespDia,"@e 99,999.99")
	//oVal06:nClrText := iif((nLimCom-nDespDia)<=0,255,16711680)
	oVal07:cCaption := " R$ "+Transform(nLimMes-nDespMes,"@e 99,999.99")
	oVal07:nClrText := iif((nLimMes-nDespMes)<=0,255,16711680)
	oDlg1:Refresh()
Return nil

Static Function PrcDados()
	Local cSql := ""
	// Limites
	cSql := "SELECT LJ_NOME,LJ_FUNDOCX,LJ_LIMCOM,LJ_LIMMES"
	cSql += " FROM "+RetSqlName("SLJ")+" SLJ"
	cSql += " WHERE SLJ.D_E_L_E_T_ = ''"
	cSql += " AND   LJ_FILIAL = '"+xFilial("SLJ")+"'"
	cSql += " AND   LJ_RPCFIL = '"+SM0->M0_CODFIL+"'"

	MsgRun("Limites ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Limites ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","LJ_FUNDOCX","N",14,2)
	TcSetField("ARQ_SQL","LJ_LIMCOM" ,"N",14,2)
	TcSetField("ARQ_SQL","LJ_LIMMES" ,"N",14,2)

	dbSelectArea("ARQ_SQL")
	cNome    := LJ_NOME
	nFundoCx := LJ_FUNDOCX
	nLimCom  := LJ_LIMCOM
	nLimMes  := LJ_LIMMES
	dbCloseArea()

	// Despesas Dia
	cSql := "SELECT SUM(E5_VALOR) AS DIA"
	cSql += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SED")+" SED"
	cSql += " WHERE SE5.D_E_L_E_T_ = ''"
	cSql += " AND   E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += " AND   E5_MSFIL = '"+SM0->M0_CODFIL+"'"
	cSql += " AND   E5_RECPAG = 'P'"
	cSql += " AND   E5_DATA = '"+dtos(mv_par01)+"'"
	cSql += " AND   ED_FILIAL = '"+xFilial("SED")+"'"
	cSql += " AND   ED_CODIGO = E5_NATUREZ"
	cSql += " AND   ED_ABSALDO = 'S'"

	MsgRun("Despesas do dia ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Despesas do dia ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","DIA","N",14,2)

	dbSelectArea("ARQ_SQL")
	nDespDia := DIA
	dbCloseArea()

	// Despesas Mes
	cSql := "SELECT SUM(E5_VALOR) AS MES"
	cSql += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SED")+" SED"
	cSql += " WHERE SE5.D_E_L_E_T_ = ''"
	cSql += " AND   SED.D_E_L_E_T_ = ''"
	cSql += " AND   E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += " AND   E5_MSFIL = '"+SM0->M0_CODFIL+"'"
	cSql += " AND   E5_RECPAG = 'P'"
	cSql += " AND   E5_DATA BETWEEN '"+Substr(dtos(mv_par01),1,4)+Substr(dtos(mv_par01),5,2)+"01' AND '"+dtos(mv_par01)+"'"
	cSql += " AND   ED_FILIAL = '"+xFilial("SED")+"'"
	cSql += " AND   ED_CODIGO = E5_NATUREZ"
	cSql += " AND   ED_ABSALDO = 'S'"

	MsgRun("Despesas do mês ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Despesas do mês ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","MES","N",14,2)

	dbSelectArea("ARQ_SQL")
	nDespMes := MES
	dbCloseArea()

	// Despesas Lista
	cSql := "SELECT E5_DATA,ED_DESCRIC,E5_VALOR,E5_HISTOR"
	cSql += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SED")+" SED"
	cSql += " WHERE SE5.D_E_L_E_T_ = ''"
	cSql += " AND   SED.D_E_L_E_T_ = ''"
	cSql += " AND   E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql += " AND   E5_MSFIL = '"+SM0->M0_CODFIL+"'"
	cSql += " AND   E5_RECPAG = 'P'"
	cSql += " AND   E5_DATA BETWEEN '"+Substr(dtos(mv_par01),1,4)+Substr(dtos(mv_par01),5,2)+"01' AND '"+dtos(mv_par01)+"'"
	cSql += " AND   ED_FILIAL = '"+xFilial("SED")+"'"
	cSql += " AND   ED_CODIGO = E5_NATUREZ"
	if mv_par02 = 2
		cSql += " AND   ED_ABSALDO = 'S'"
	Endif
	cSql += " ORDER BY E5_DATA"

	MsgRun("Montando consulta ...",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Montando consulta ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})
	TcSetField("ARQ_SQL","E5_DATA"   ,"D",08,0)
	TcSetField("ARQ_SQL","ED_DESCRIC","C",30,0)
	TcSetField("ARQ_SQL","E5_VALOR"  ,"N",14,2)
	TcSetField("ARQ_SQL","E5_HISTOR" ,"C",50,0)

	dbSelectArea("ARQ_SQL")
	cNomTmp := CriaTrab(NIL,.F.)
	Copy To &cNomTmp
	dbCloseArea()
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
Return nil