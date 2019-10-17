#include "rwmake.ch"
#include "topconn.ch"

User Function TMKR08()
	Private cString        := "SUA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Sintético por loja"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 80
	Private tamanho        := "P"
	Private nomeprog       := "TMKR08"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "TMKR08"
	Private titulo         := "Sintético por loja"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "TMKR08"
	Private lImp           := .f.
	Private cSql           := ""

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"03","Da Loja            ?"," "," ","mv_ch3","C", 02,0,0,"G","","mv_par03",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SM0","","","",""})
	AADD(aRegs,{cPerg,"04","Ate a Loja         ?"," "," ","mv_ch4","C", 02,0,0,"G","","mv_par04",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SM0","","","",""})

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
	Pergunte(cPerg,.F.)

	// Monta inferface com usuário	
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
	Cabec1:="Loja                                  Ligações       Vendas              Valor"
	        *XX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99.999.999   99.999.999  99.999.999.999,99
	        *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	cSql := ""
	cSql += "SELECT UA_LOJASL1,COUNT(UA_FILIAL) AS LIGA"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_LOJASL1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_LOJASL1"
	cSql += " ORDER BY UA_LOJASL1"

	MsgRun("Consultando Banco de dados ... Ligações",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Ligações",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_ORC", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Ligações",,{|| TcSetField("SQL_ORC","LIGA","N",14,2)})

	cSql := ""
	cSql += "SELECT DISTINCT F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT"
	cSql += " FROM "+RetSqlName("SUA")+" SUA , "+RetSqlName("SF2")+" SF2 , "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND SF2.D_E_L_E_T_ = ''"
	cSql += " AND SU7.D_E_L_E_T_ = ''"
	cSql += " AND UA_FILIAL = '01'"
	cSql += " AND UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND UA_LOJASL1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND UA_PLACA <> ' '"
	cSql += " AND UA_VDALOJ <= 0"
	cSql += " AND F2_FILIAL  BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND F2_PLACA = UA_PLACA"
	cSql += " AND F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND F2_EMISSAO >= UA_EMISSAO"
	cSql += " AND U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND U7_COD = UA_OPERADO"
	cSql += " AND U7_POSTO = '07'"
	cSql += " ORDER BY F2_FILIAL"

	MsgRun("Consultando Banco de dados ... Faturados",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_FAT", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","F2_VALFAT","N",14,2)})


	cSql := ""
	cSql += "SELECT UA_LOJASL1,COUNT(UA_FILIAL) AS VEND,SUM(UA_VDALOJ) AS VALOR"
	cSql += " FROM "+RetSqlName("SUA")+" SUA , "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND SU7.D_E_L_E_T_ = ''"
	cSql += " AND UA_FILIAL = '01'"
	cSql += " AND UA_EMISNF  BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND UA_LOJASL1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND UA_VDALOJ > 0"
	cSql += " AND U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND U7_COD = UA_OPERADO"
	cSql += " AND U7_POSTO = '07'"
	cSql += " GROUP BY UA_LOJASL1
	cSql += " ORDER BY UA_LOJASL1"

	MsgRun("Consultando Banco de dados ... Loja",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LOJ", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","VEND","N",14,2)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","VALOR","N",14,2)})


	// Monta estrutura do temporario
	aEstru := {}
	aadd(aEstru,{"T_LOJA"     ,"C",02,0})
	aadd(aEstru,{"T_NOME"     ,"C",30,0})
	aadd(aEstru,{"T_LIGA"     ,"N",08,0})
	aadd(aEstru,{"T_VEND"     ,"N",08,0})
	aadd(aEstru,{"T_VALOR"    ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_LOJA",,.t.,"Selecionando Registros...")

	MsgRun("Montando temporario ...",,{|| LoadTmp() })

	dbSelectArea("TMP")

	ProcRegua(LastRec())
	dbGoTop()
	aTotGeral := {0,0,0}

	Do while !eof()
		lImp := .T.

		if lAbortPrint
			If lImp
				li+=2
				@ LI,001 PSAY "*** Cancelado pelo operador ***"
				Exit
			Endif
		Endif

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+2
		endif

		@ LI,000 PSAY T_NOME
		@ LI,036 PSAY T_LIGA   PICTURE "@E 99,999,999"
		@ LI,049 PSAY T_VEND   PICTURE "@E 99,999,999"
		@ LI,061 PSAY T_VALOR  PICTURE "@E 99,999,999,999.99"
		aTotGeral[1] += T_LIGA
		aTotGeral[2] += T_VEND
		aTotGeral[3] += T_VALOR
		Li:=Li+1
		dbSkip()
	enddo
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	if lImp .AND. !lAbortPrint
		Li:=Li+1
		@ LI,000 PSAY "Total Geral:"
		@ LI,036 PSAY aTotGeral[1] PICTURE "@E 99,999,999"
		@ LI,049 PSAY aTotGeral[2] PICTURE "@E 99,999,999"
		@ LI,061 PSAY aTotGeral[3] PICTURE "@E 99,999,999,999.99"
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

Static Function LoadTmp()
	dbSelectArea("SQL_ORC")
	dbGoTop()
	Do while !eof()
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			TMP->T_LOJA   := SQL_ORC->UA_LOJASL1
			If Len(AllTrim(SQL_ORC->UA_LOJASL1)) <= 0
				TMP->T_NOME   := "SEM LOJA"
			Else
				TMP->T_NOME   := Posicione("SM0",1,SM0->M0_CODIGO+SQL_ORC->UA_LOJASL1,"M0_NOME")
			Endif
			TMP->T_LIGA   := SQL_ORC->LIGA
			TMP->T_VEND   := 0
			TMP->T_VALOR  := 0
			MsUnlock()
		Endif
		dbSelectArea("SQL_ORC")
		dbSkip()
	Enddo
	dbSelectArea("SQL_ORC")
	dbCloseArea()

	dbSelectArea("SQL_FAT")
	dbGoTop()
	Do While !eof()
		dbSelectArea("TMP")
		dbGoTop()
		dbSeek(SQL_FAT->F2_FILIAL)
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_VEND   += 1
				TMP->T_VALOR  += SQL_FAT->F2_VALBRUT
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_LOJA   := SQL_FAT->F2_FILIAL
				TMP->T_NOME   := Posicione("SM0",1,SM0->M0_CODIGO+SQL_ORC->F2_FILIAL,"M0_NOME")
				TMP->T_LIGA   := 0
				TMP->T_VEND   := 1
				TMP->T_VALOR  := SQL_FAT->F2_VALBRUT
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SQL_FAT")
		dbSkip()
	Enddo
	dbSelectArea("SQL_FAT")
	dbCloseArea()


	dbSelectArea("SQL_LOJ")
	dbGoTop()
	Do While !eof()
		dbSelectArea("TMP")
		dbGoTop()
		dbSeek(SQL_LOJ->UA_LOJASL1)
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_VEND   += SQL_LOJ->VEND
				TMP->T_VALOR  += SQL_LOJ->VALOR
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_LOJA   := SQL_LOJ->UA_LOJASL1
				If Len(AllTrim(SQL_ORC->UA_LOJASL1)) <= 0
					TMP->T_NOME   := "SEM LOJA"
				Else
					TMP->T_NOME   := Posicione("SM0",1,SM0->M0_CODIGO+SQL_ORC->UA_LOJASL1,"M0_NOME")
				Endif
				TMP->T_LIGA   := 0
				TMP->T_VEND   := SQL_LOJ->VEND
				TMP->T_VALOR  := SQL_LOJ->VALOR
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SQL_LOJ")
		dbSkip()
	Enddo
	dbSelectArea("SQL_LOJ")
	dbCloseArea()
Return