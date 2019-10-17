#include "rwmake.ch"
#include "topconn.ch"

User Function TMKR06()
	Private cString        := "SUA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Ligações / Vendas por convenio"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 132
	Private tamanho        := "M"
	Private nomeprog       := "TMKR06"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "TMKR06"
	Private titulo         := "Ligações / Vendas por convenio"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "TMKR06"
	Private lImp           := .f.
	Private cSql           := ""

	aOrd := {"Descrição","Código"}

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"03","Do Convenio        ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","PA6","","","",""})
	AADD(aRegs,{cPerg,"04","Ate o Convenio     ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","PA6","","","",""})
	AADD(aRegs,{cPerg,"05","Ligacoes / Mes     ?"," "," ","mv_ch5","N", 06,0,0,"G","","mv_par05",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","","@e 999,999"})

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
	Cabec1:=" Convenio   Descrição                          Ligações       Vendas              Valor   Ligações / Mes      (%)         Valor Médio"
	        * XXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99.999.999   99.999.999  99.999.999.999,99          999.999  999.99%   99.999.999.999,99
	        *0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	cSql := ""
	cSql += "SELECT UA_CODCON,PA6_DESC,COUNT(UA_FILIAL) AS LIGA"
	cSql += " FROM "+RetSqlName("SUA")+" SUA"

	cSql += " LEFT JOIN "+RetSqlName("PA6")+" PA6"
	cSql += " ON  PA6_COD = UA_CODCON"
	cSql += " AND PA6_FILIAL = '"+xFilial("PA6")+"'"
	cSql += " AND PA6.D_E_L_E_T_ = ''"

	cSql += " JOIN SU7010 SU7"
	cSql += " ON    U7_COD = UA_OPERADO"
	cSql += " AND   U7_FILIAL = '  '"

	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_CODCON BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_CODCON,PA6_DESC"
	cSql += " ORDER BY UA_CODCON"

	MsgRun("Consultando Banco de dados ... Ligações",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Ligações",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_ORC", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Ligações",,{|| TcSetField("SQL_ORC","LIGA","N",14,2)})


	cSql := ""
	cSql += "SELECT DISTINCT UA_CODCON,PA6_DESC,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SU7")+" SU7, "+RetSqlName("PA6")+" PA6"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SF2.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   PA6.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_CODCON BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_PLACA <> ''"
	cSql += " AND   UA_VDALOJ <= 0"
	cSql += " AND   F2_PLACA = UA_PLACA"
	cSql += " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02+45)+"'"
	cSql += " AND   F2_EMISSAO >= UA_EMISSAO"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " AND   PA6_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   PA6_COD = UA_CODCON"
	cSql += " ORDER BY UA_CODCON"

	MsgRun("Consultando Banco de dados ... Faturados",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_FAT", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","F2_VALFAT","N",14,2)})

	cSql := ""
	cSql += "SELECT UA_CODCON,PA6_DESC,COUNT(UA_FILIAL) AS VEND,SUM(UA_VDALOJ) AS VALOR"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SU7")+" SU7, "+RetSqlName("PA6")+" PA6"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   PA6.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISNF BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_CODCON BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_VDALOJ > 0"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " AND   PA6_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   PA6_COD = UA_CODCON"
	cSql += " GROUP BY UA_CODCON,PA6_DESC"
	cSql += " ORDER BY UA_CODCON"

	MsgRun("Consultando Banco de dados ... Loja",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LOJ", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","VEND","N",14,2)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","VALOR","N",14,2)})


	// Monta estrutura do temporario
	aEstru := {}
	aadd(aEstru,{"T_CODCON"   ,"C",06,0})
	aadd(aEstru,{"T_DESC"     ,"C",30,0})
	aadd(aEstru,{"T_LIGA"     ,"N",08,0})
	aadd(aEstru,{"T_VEND"     ,"N",08,0})
	aadd(aEstru,{"T_VALOR"    ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_CODCON",,.t.,"Selecionando Registros...")

	MsgRun("Montando temporario ...",,{|| LoadTmp() })

	dbSelectArea("TMP")

	If aReturn[8] = 1
		IndRegua("TMP",cNomTmp,"T_DESC",,.t.,"Selecionando Registros...")
	Endif

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

		@ LI,001 PSAY T_CODCON
		@ LI,012 PSAY T_DESC
		@ LI,045 PSAY T_LIGA   PICTURE "@E 99,999,999"
		@ LI,058 PSAY T_VEND   PICTURE "@E 99,999,999"
		@ LI,070 PSAY T_VALOR  PICTURE "@E 99,999,999,999.99"
		@ LI,097 PSAY mv_par05 PICTURE "@E 999,999"
		@ LI,106 PSAY (T_LIGA/mv_par05)*100 PICTURE "@E 999.99"
		@ LI,112 PSAY "%"
		@ LI,116 PSAY (T_VALOR/T_VEND) PICTURE "@E 99,999,999,999.99"
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
		@ LI,001 PSAY "Total Geral:"
		@ LI,045 PSAY aTotGeral[1] PICTURE "@E 99,999,999"
		@ LI,058 PSAY aTotGeral[2] PICTURE "@E 99,999,999"
		@ LI,070 PSAY aTotGeral[3] PICTURE "@E 99,999,999,999.99"
		@ LI,097 PSAY mv_par05 PICTURE "@E 999,999"
		@ LI,106 PSAY (aTotGeral[1]/mv_par05)*100 PICTURE "@E 999.99"
		@ LI,112 PSAY "%"
		@ LI,116 PSAY (aTotGeral[3]/aTotGeral[2]) PICTURE "@E 99,999,999,999.99"
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
			TMP->T_CODCON := SQL_ORC->UA_CODCON
			If Len(AllTrim(SQL_ORC->UA_CODCON)) <= 0
				TMP->T_DESC   := "SEM CONVENIO"
			Else
				TMP->T_DESC   := iif(Len(Alltrim(SQL_ORC->PA6_DESC))<=0,"CONVENIO NÃO CADASTRADO",SQL_ORC->PA6_DESC)
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
		dbSeek(SQL_FAT->UA_CODCON)
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_VEND   += 1
				TMP->T_VALOR  += SQL_FAT->F2_VALBRUT
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_CODCON := SQL_FAT->UA_CODCON
				TMP->T_DESC   := SQL_FAT->PA6_DESC
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
		dbSeek(SQL_LOJ->UA_CODCON)
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_VEND   += SQL_LOJ->VEND
				TMP->T_VALOR  += SQL_LOJ->VALOR
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_CODCON := SQL_LOJ->UA_CODCON
				TMP->T_DESC   := SQL_LOJ->PA6_DESC
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