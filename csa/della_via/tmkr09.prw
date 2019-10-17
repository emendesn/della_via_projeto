#include "rwmake.ch"
#include "topconn.ch"

User Function TMKR09()
	Private cString        := "SUA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Posição diária de vendas por Operador / Midia"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 80
	Private tamanho        := "M"
	Private nomeprog       := "TMKR09"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "TMKR09"
	Private titulo         := "Pos. diária Operador / Midia"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "TMKR09"
	Private lImp           := .f.
	Private cSql           := ""

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"03","Do Operador        ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SU7","","","",""})
	AADD(aRegs,{cPerg,"04","Ate o Operador     ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SU7","","","",""})
	AADD(aRegs,{cPerg,"05","Da Midia           ?"," "," ","mv_ch5","C", 06,0,0,"G","","mv_par05",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SUH","","","",""})
	AADD(aRegs,{cPerg,"06","Ate a Midia        ?"," "," ","mv_ch6","C", 06,0,0,"G","","mv_par06",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SUH","","","",""})

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
	Cabec1:="               Data                    Orcado        Qtde Orcado              Faturado      Qtde Faturado     Ligações    % Aprov"
	        *               99/99/99     99.999.999.999,99     99.999.999.999     99.999.999.999,99     99.999.999.999   99,999,999     999.99
	        *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	cSql := ""
	cSql += "SELECT UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISSAO,Sum(UA_VALBRUT) AS ORCADO,Count(UA_FILIAL) AS QTDLIG"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISSAO"
	cSql += " ORDER BY UA_OPERADO,UA_EMISSAO"

	MsgRun("Consultando Banco de dados ... Orçados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_ORC", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Orçados",,{|| TcSetField("SQL_ORC","UA_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Orçados",,{|| TcSetField("SQL_ORC","ORCADO","N",14,2)})


	cSql := ""
	cSql += "SELECT DISTINCT UA_OPERADO,UA_EMISSAO,UA_FIM,U7_NOME,UA_MIDIA,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT"
	cSql += " ,(SELECT SUM(D2_QUANT) FROM "+RetSqlName("SD2")+" WHERE D_E_L_E_T_ = '' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE) AS QTDFAT
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SF2.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UA_PLACA <> ''"
	cSql += " AND   UA_VDALOJ <= 0"
	cSql += " AND   F2_PLACA = UA_PLACA"
	cSql += " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02+45)+"'"
	cSql += " AND   F2_EMISSAO >= UA_EMISSAO"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,UA_EMISSAO,UA_FIM"

	MsgRun("Consultando Banco de dados ... Faturados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_FAT", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","F2_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","F2_VALFAT","N",14,2)})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","QTDFAT","N",14,2)})

	cSql := ""
	cSql += "SELECT UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISNF,Sum(UA_VDALOJ) AS FATURADO,Count(UA_FILIAL) AS QTDLIG"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISNF BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UA_VDALOJ > 0"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISNF"
	cSql += " ORDER BY UA_OPERADO,UA_EMISNF"

	MsgRun("Consultando Banco de dados ... Loja",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LOJ", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","UA_EMISNF","D")})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","FATURADO","N",14,2)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","ORCADO","N",14,2)})


	cSql := "SELECT UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISSAO,SUM(UB_QUANT) AS QTDORC"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SUB")+" SUB , "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   SUB.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UB_FILIAL = UA_FILIAL"
	cSql += " AND   UB_NUM = UA_NUM"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISSAO"
	cSql += " ORDER BY UA_OPERADO,UA_EMISSAO"
	MsgRun("Consultando Banco de dados ... Loja",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_QORC", .T., .T.)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_QORC","UA_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_QORC","QTDORC","N",14,2)})


	cSql := "SELECT UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISNF,Sum(UB_QUANT) AS QTDFAT"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SUB")+" SUB , "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   SUB.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISNF BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UA_VDALOJ > 0"
	cSql += " AND   UB_FILIAL = UA_FILIAL"
	cSql += " AND   UB_NUM = UA_NUM"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_OPERADO,U7_NOME,UA_MIDIA,UA_EMISNF"
	cSql += " ORDER BY UA_OPERADO,UA_EMISNF"
	MsgRun("Consultando Banco de dados ... Loja",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_QFAT", .T., .T.)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_QFAT","UA_EMISNF","D")})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_QFAT","QTDFAT","N",14,2)})


	// Monta estrutura do temporario
	aEstru := {}
	aadd(aEstru,{"T_OPER"     ,"C",06,0})
	aadd(aEstru,{"T_NOME"     ,"C",30,0})
	aadd(aEstru,{"T_MIDIA"    ,"C",06,0})
	aadd(aEstru,{"T_DESC"     ,"C",30,0})
	aadd(aEstru,{"T_DATA"     ,"D",08,0})
	aadd(aEstru,{"T_ORCADO"   ,"N",14,2})
	aadd(aEstru,{"T_FAT"      ,"N",14,2})
	aadd(aEstru,{"T_QTDLIG"   ,"N",10,0})
	aadd(aEstru,{"T_QTDORC"   ,"N",14,2})
	aadd(aEstru,{"T_QTDFAT"   ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_OPER+T_MIDIA+DTOS(T_DATA)",,.t.,"Selecionando Registros...")

	MsgRun("Montando temporario ...",,{|| LoadTmp() })

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()
	aTotGeral := {0,0,0,0,0}

	Do while !eof()
		lImp := .T.
		cOper := T_OPER
		aTotOper  := {0,0,0,0,0}

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+2
		endif

		@ li,001 PSAY T_OPER + " - " + T_NOME
		Li++

		Do while !eof() .and. T_OPER = cOper
			cMidia    := T_MIDIA		
			aTotMidia := {0,0,0,0,0}

			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif

			@ li,005 PSAY T_MIDIA + " - " + T_DESC
			Li++

			Do While  !eof() .and. T_OPER = cOper .and. T_MIDIA = cMidia
				incProc("Imprimindo ...")
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

				@ LI,015 PSAY T_DATA
				@ LI,028 PSAY T_ORCADO PICTURE "@E 99,999,999,999.99"
				@ LI,050 PSAY T_QTDORC PICTURE "@E 99,999,999,999"
				@ LI,069 PSAY T_FAT    PICTURE "@E 99,999,999,999.99"
				@ LI,091 PSAY T_QTDFAT PICTURE "@E 99,999,999,999"
				@ LI,108 PSAY T_QTDLIG PICTURE "@E 99,999,999"
				@ LI,123 PSAY (T_QTDFAT/T_QTDORC)*100 PICTURE "@E 999.99"

				aTotMidia[1] += T_ORCADO
				aTotMidia[2] += T_QTDORC
				aTotMidia[3] += T_FAT
				aTotMidia[4] += T_QTDFAT
				aTotMidia[5] += T_QTDLIG

				aTotOper[1]  += T_ORCADO
				aTotOper[2]  += T_QTDORC
				aTotOper[3]  += T_FAT
				aTotOper[4]  += T_QTDFAT
				aTotOper[5]  += T_QTDLIG

				aTotGeral[1] += T_ORCADO
				aTotGeral[2] += T_QTDORC
				aTotGeral[3] += T_FAT
				aTotGeral[4] += T_QTDFAT
				aTotGeral[5] += T_QTDLIG
				Li:=Li+1
				dbSkip()
			Enddo
			@ LI,005 PSAY "Total da Midia:"
			@ LI,028 PSAY aTotMidia[1] PICTURE "@E 99,999,999,999.99"
			@ LI,050 PSAY aTotMidia[2] PICTURE "@E 99,999,999,999"
			@ LI,069 PSAY aTotMidia[3] PICTURE "@E 99,999,999,999.99"
			@ LI,091 PSAY aTotMidia[4] PICTURE "@E 99,999,999,999"
			@ LI,108 PSAY aTotMidia[5] PICTURE "@E 99,999,999"
			@ LI,123 PSAY (aTotMidia[4]/aTotMidia[2])*100 PICTURE "@E 999.99"
			Li:=Li+2
		Enddo
		@ LI,001 PSAY "Total do Operador:"
		@ LI,028 PSAY aTotOper[1] PICTURE "@E 99,999,999,999.99"
		@ LI,050 PSAY aTotOper[2] PICTURE "@E 99,999,999,999"
		@ LI,069 PSAY aTotOper[3] PICTURE "@E 99,999,999,999.99"
		@ LI,091 PSAY aTotOper[4] PICTURE "@E 99,999,999,999"
		@ LI,108 PSAY aTotOper[5] PICTURE "@E 99,999,999"
		@ LI,123 PSAY (aTotOper[4]/aTotOper[2])*100 PICTURE "@E 999.99"
		Li:=Li+2
	enddo
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	if lImp .AND. !lAbortPrint
		@ LI,001 PSAY "Total Geral:"
		@ LI,028 PSAY aTotGeral[1] PICTURE "@E 99,999,999,999.99"
		@ LI,050 PSAY aTotGeral[2] PICTURE "@E 99,999,999,999"
		@ LI,069 PSAY aTotGeral[3] PICTURE "@E 99,999,999,999.99"
		@ LI,091 PSAY aTotGeral[4] PICTURE "@E 99,999,999,999"
		@ LI,108 PSAY aTotGeral[5] PICTURE "@E 99,999,999"
		@ LI,123 PSAY (aTotGeral[4]/aTotGeral[2])*100 PICTURE "@E 999.99"
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
			TMP->T_OPER   := SQL_ORC->UA_OPERADO
			TMP->T_NOME   := SQL_ORC->U7_NOME
			TMP->T_MIDIA  := iif(Empty(SQL_ORC->UA_MIDIA),"000000",SQL_ORC->UA_MIDIA)
			TMP->T_DESC   := iif(Empty(SQL_ORC->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_ORC->UA_MIDIA,"SUH->UH_DESC"))
			TMP->T_DATA   := SQL_ORC->UA_EMISSAO
			TMP->T_ORCADO := SQL_ORC->ORCADO
			TMP->T_FAT    := 0
			TMP->T_QTDLIG := SQL_ORC->QTDLIG
			TMP->T_QTDORC := 0
			TMP->T_QTDFAT := 0
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
		dbSeek(SQL_FAT->UA_OPERADO+iif(Empty(SQL_FAT->UA_MIDIA),"000000",SQL_FAT->UA_MIDIA)+dtos(SQL_FAT->F2_EMISSAO))
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_FAT    += SQL_FAT->F2_VALBRUT
				TMP->T_QTDFAT += SQL_FAT->QTDFAT
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_OPER   := SQL_FAT->UA_OPERADO
				TMP->T_NOME   := SQL_FAT->U7_NOME
				TMP->T_MIDIA  := iif(Empty(SQL_FAT->UA_MIDIA),"000000",SQL_FAT->UA_MIDIA)
				TMP->T_DESC   := iif(Empty(SQL_FAT->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_FAT->UA_MIDIA,"SUH->UH_DESC"))
				TMP->T_DATA   := SQL_FAT->F2_EMISSAO
				TMP->T_ORCADO := 0
				TMP->T_FAT    := SQL_FAT->F2_VALBRUT
				TMP->T_QTDLIG := 0
				TMP->T_QTDFAT := SQL_FAT->QTDFAT
				TMP->T_QTDORC := 0
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SQL_FAT")
		cChave := F2_FILIAL+F2_SERIE+F2_DOC
		Do While !eof() .and. F2_FILIAL+F2_SERIE+F2_DOC = cChave
			dbSkip()
		Enddo
	Enddo
	dbSelectArea("SQL_FAT")
	dbCloseArea()

	dbSelectArea("SQL_LOJ")
	dbGoTop()
	Do While !eof()
		dbSelectArea("TMP")
		dbGoTop()
		dbSeek(SQL_LOJ->UA_OPERADO+iif(Empty(SQL_LOJ->UA_MIDIA),"000000",SQL_LOJ->UA_MIDIA)+dtos(SQL_LOJ->UA_EMISNF))
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_FAT    += SQL_LOJ->FATURADO
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_OPER   := SQL_LOJ->UA_OPERADO
				TMP->T_NOME   := SQL_LOJ->U7_NOME
				TMP->T_MIDIA  := iif(Empty(SQL_LOJ->UA_MIDIA),"000000",SQL_LOJ->UA_MIDIA)
				TMP->T_DESC   := iif(Empty(SQL_LOJ->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_LOJ->UA_MIDIA,"SUH->UH_DESC"))
				TMP->T_DATA   := SQL_LOJ->UA_EMISNF
				TMP->T_ORCADO := 0
				TMP->T_FAT    := SQL_LOJ->FATURADO
				TMP->T_QTDLIG := 0
				TMP->T_QTDORC := 0
				TMP->T_QTDFAT := 0
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SQL_LOJ")
		dbSkip()
	Enddo
	dbSelectArea("SQL_LOJ")
	dbCloseArea()


	dbSelectArea("SQL_QORC")
	dbGoTop()
	Do While !eof()
		dbSelectArea("TMP")
		dbGoTop()
		dbSeek(SQL_QORC->UA_OPERADO+iif(Empty(SQL_QORC->UA_MIDIA),"000000",SQL_QORC->UA_MIDIA)+dtos(SQL_QORC->UA_EMISSAO))
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_QTDORC += SQL_QORC->QTDORC
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_OPER   := SQL_QORC->UA_OPERADO
				TMP->T_NOME   := SQL_QORC->U7_NOME
				TMP->T_MIDIA  := iif(Empty(SQL_QORC->UA_MIDIA),"000000",SQL_QORC->UA_MIDIA)
				TMP->T_DESC   := iif(Empty(SQL_QORC->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_QORC->UA_MIDIA,"SUH->UH_DESC"))
				TMP->T_DATA   := SQL_QORC->UA_EMISSAO
				TMP->T_ORCADO := 0
				TMP->T_FAT    := 0
				TMP->T_QTDLIG := 0
				TMP->T_QTDORC := SQL_QORC->QTDORC
				TMP->T_QTDFAT := 0
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SQL_QORC")
		dbSkip()
	Enddo
	dbSelectArea("SQL_QORC")
	dbCloseArea()


	dbSelectArea("SQL_QFAT")
	dbGoTop()
	Do While !eof()
		dbSelectArea("TMP")
		dbGoTop()
		dbSeek(SQL_QFAT->UA_OPERADO+iif(Empty(SQL_QFAT->UA_MIDIA),"000000",SQL_QFAT->UA_MIDIA)+dtos(SQL_QFAT->UA_EMISNF))
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_QTDFAT += SQL_QFAT->QTDFAT
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_OPER   := SQL_QFAT->UA_OPERADO
				TMP->T_NOME   := SQL_QFAT->U7_NOME
				TMP->T_MIDIA  := iif(Empty(SQL_QFAT->UA_MIDIA),"000000",SQL_QFAT->UA_MIDIA)
				TMP->T_DESC   := iif(Empty(SQL_QFAT->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_QFAT->UA_MIDIA,"SUH->UH_DESC"))
				TMP->T_DATA   := SQL_QFAT->UA_EMISSAO
				TMP->T_ORCADO := 0
				TMP->T_FAT    := 0
				TMP->T_QTDLIG := 0
				TMP->T_QTDORC := 0
				TMP->T_QTDFAT := SQL_QFAT->QTDFAT
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SQL_QFAT")
		dbSkip()
	Enddo
	dbSelectArea("SQL_QFAT")
	dbCloseArea()
Return