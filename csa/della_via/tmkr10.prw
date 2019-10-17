#include "rwmake.ch"
#include "topconn.ch"

User Function TMKR10()
	Private cString        := "SUA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Posição diária de vendas por Operador / Midia"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 80
	Private tamanho        := "G"
	Private nomeprog       := "TMKR10"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "TMKR10"
	Private titulo         := "Pos. Diária Operador / Midia"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "TMKR10"
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
	Cabec1:="               Atendimento   Cliente                                 Complemento                      Placa      Emissao            Orçado   Nota     Filial         Faturado"
	        *               XXXXXX        XXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXX-9999   DD/MM/AA   999,999,999.99   XXXXXX   XX       999,999,999.99
	        *012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16

	cSql := ""
	cSql += "SELECT UA_OPERADO,U7_NOME"
	cSql += " ,UA_MIDIA"
	cSql += " ,UA_NUM,UA_CLIENTE,A1_NOME,UA_COMPL,UA_PLACA,UA_EMISSAO,UA_VALBRUT"

	cSql += " FROM "+RetSqlName("SUA")+" SUA"

	cSql += " JOIN "+RetSqlName("SU7")+" SU7"
	cSql += " ON    SU7.D_E_L_E_T_ = ''"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"

	cSql += " JOIN  "+RetSqlName("SA1")+" SA1"
	cSql += " ON    SA1.D_E_L_E_T_ = ''"
	cSql += " AND   A1_FILIAL = ''"
	cSql += " AND   A1_COD = UA_CLIENTE"

	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UA_PLACA = ''"
	cSql += " AND   UA_VDALOJ <= 0"

	MsgRun("Consultando Banco de dados ... Orçados",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Orçados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_ORC", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Orçados",,{|| TcSetField("SQL_ORC","UA_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Orçados",,{|| TcSetField("SQL_ORC","UA_VALBRUT","N",14,2)})


	cSql := ""
	cSql += "SELECT UA_OPERADO,U7_NOME"
	cSql += " ,UA_MIDIA"
	cSql += " ,UA_NUM,UA_CLIENTE,A1_NOME,UA_COMPL,UA_PLACA,UA_EMISSAO,UA_VALBRUT"
	cSql += " ,F2_FILIAL,F2_DOC,F2_SERIE,UA_FIM,F2_VALBRUT"

	cSql += " FROM "+RetSqlName("SUA")+" SUA"

	cSql += " JOIN "+RetSqlName("SU7")+" SU7"
	cSql += " ON    SU7.D_E_L_E_T_ = ''"
	cSql += " AND   U7_FILIAL = ''"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"

	cSql += " LEFT JOIN "+RetSqlName("SF2")+" SF2"
	cSql += " ON    SF2.D_E_L_E_T_ = ''"
	cSql += " AND   F2_PLACA = UA_PLACA"
	cSql += " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   F2_EMISSAO >= UA_EMISSAO"

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON    SA1.D_E_L_E_T_ = ''"
	cSql += " AND   A1_FILIAL = ''"
	cSql += " AND   A1_COD = UA_CLIENTE"

	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UA_PLACA <> ''"
	cSql += " AND   UA_VDALOJ <= 0"
	cSql += " ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,UA_EMISSAO,UA_FIM

	MsgRun("Consultando Banco de dados ... Faturados",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_FAT", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","UA_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","UA_VALBRUT","N",14,2)})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","F2_VALBRUT","N",14,2)})

	cSql := ""
	cSql += "SELECT UA_OPERADO,U7_NOME"
	cSql += " ,UA_MIDIA"
	cSql += " ,UA_NUM,UA_CLIENTE,A1_NOME,UA_COMPL,UA_PLACA,UA_EMISNF,UA_VALBRUT,UA_EMISSAO"
	cSql += " ,UA_DOC,UA_VDALOJ,UA_LOJASL1"

	cSql += " FROM "+RetSqlName("SUA")+" SUA"

	cSql += " JOIN "+RetSqlName("SU7")+" SU7"
	cSql += " ON    SU7.D_E_L_E_T_ = ''"
	cSql += " AND   U7_FILIAL = '  '"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"

	cSql += " JOIN "+RetSqlName("SA1")+" SA1"
	cSql += " ON    SA1.D_E_L_E_T_ = ''"
	cSql += " AND   A1_FILIAL = ''"
	cSql += " AND   A1_COD = UA_CLIENTE"

	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISNF BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_MIDIA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cSql += " AND   UA_VDALOJ > 0"

	MsgRun("Consultando Banco de dados ... Loja",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LOJ", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","UA_EMISNF","D")})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","UA_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","UA_VALBRUT","N",14,2)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","UA_VDALOJ","N",14,2)})

	// Monta estrutura do temporario
	aEstru := {}
	aadd(aEstru,{"T_OPER"     ,"C",06,0})
	aadd(aEstru,{"T_NOME"     ,"C",30,0})
	aadd(aEstru,{"T_COMPL"    ,"C",30,0})
	aadd(aEstru,{"T_MIDIA"    ,"C",06,0})
	aadd(aEstru,{"T_DESC"     ,"C",30,0})
	aadd(aEstru,{"T_NUM"      ,"C",06,0})
	aadd(aEstru,{"T_CLIENTE"  ,"C",06,0})
	aadd(aEstru,{"T_NOMCLI"   ,"C",30,0})
	aadd(aEstru,{"T_PLACA"    ,"C",07,0})
	aadd(aEstru,{"T_DATA"     ,"D",08,0})
	aadd(aEstru,{"T_ORCADO"   ,"N",14,2})
	aadd(aEstru,{"T_NOTA"     ,"C",06,0})
	aadd(aEstru,{"T_LOJA"     ,"C",02,0})
	aadd(aEstru,{"T_FAT"      ,"N",14,2})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_OPER+T_MIDIA+T_NUM",,.t.,"Selecionando Registros...")

	MsgRun("Montando temporario ...",,{|| LoadTmp() })

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()

	aTotGer := {0,0}

	Do while !eof()
		lImp := .T.
		cOper := T_OPER

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+2
		endif

		@ li,001 PSAY T_OPER + " - " + T_NOME
		Li++
		aTotOper := {0,0}

		Do while !eof() .and. T_OPER = cOper
			cMidia    := T_MIDIA		

			if li>55
				LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
				LI:=LI+2
			endif

			@ li,005 PSAY T_MIDIA + " - " + T_DESC
			Li++
			aTotMidia := {0,0}

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

				@ LI,015 PSAY T_NUM
				@ LI,029 PSAY T_CLIENTE+"-"+T_NOMCLI
				@ LI,069 PSAY T_COMPL
				@ LI,102 PSAY Substr(T_PLACA,1,3)+"-"+Substr(T_PLACA,4,4)
				@ LI,113 PSAY T_DATA
				@ LI,124 PSAY T_ORCADO PICTURE "@E 999,999,999.99"
				@ LI,141 PSAY T_NOTA
				@ LI,150 PSAY T_LOJA
				@ LI,159 PSAY T_FAT    PICTURE "@E 999,999,999.99"
				Li:=Li+1
				aTotMidia[1] += T_ORCADO
				aTotMidia[2] += T_FAT
				aTotOper[1]  += T_ORCADO
				aTotOper[2]  += T_FAT
				aTotGer[1]   += T_ORCADO
				aTotGer[2]   += T_FAT
				dbSkip()
			Enddo
			@ LI,005 PSAY "Total da Midia"
			@ LI,124 PSAY aTotMidia[1] PICTURE "@E 999,999,999.99"
			@ LI,159 PSAY aTotMidia[2] PICTURE "@E 999,999,999.99"
			LI+=2
		Enddo
		@ LI,001 PSAY "Total do Operador"
		@ LI,124 PSAY aTotOper[1] PICTURE "@E 999,999,999.99"
		@ LI,159 PSAY aTotOper[2] PICTURE "@E 999,999,999.99"
		LI+=2
	enddo
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	if lImp .AND. !lAbortPrint
		LI+=2
		@ LI,001 PSAY "Total Geral"
		@ LI,124 PSAY aTotGer[1] PICTURE "@E 999,999,999.99"
		@ LI,159 PSAY aTotGer[2] PICTURE "@E 999,999,999.99"
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
			TMP->T_OPER    := SQL_ORC->UA_OPERADO
			TMP->T_NOME    := SQL_ORC->U7_NOME
			TMP->T_COMPL   := SQL_ORC->UA_COMPL
			TMP->T_MIDIA   := iif(Empty(SQL_ORC->UA_MIDIA),"000000",SQL_ORC->UA_MIDIA)
			TMP->T_DESC    := iif(Empty(SQL_ORC->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_ORC->UA_MIDIA,"SUH->UH_DESC"))
			TMP->T_NUM     := SQL_ORC->UA_NUM
			TMP->T_CLIENTE := SQL_ORC->UA_CLIENTE
			TMP->T_NOMCLI  := SQL_ORC->A1_NOME
			TMP->T_PLACA   := SQL_ORC->UA_PLACA
			TMP->T_DATA    := SQL_ORC->UA_EMISSAO
			TMP->T_ORCADO  := SQL_ORC->UA_VALBRUT
			TMP->T_NOTA    := ""
			TMP->T_LOJA    := ""
			TMP->T_FAT     := 0
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
		If RecLock("TMP",.T.)
			TMP->T_OPER    := SQL_FAT->UA_OPERADO
			TMP->T_NOME    := SQL_FAT->U7_NOME
			TMP->T_COMPL   := SQL_FAT->UA_COMPL
			TMP->T_MIDIA   := iif(Empty(SQL_FAT->UA_MIDIA),"000000",SQL_FAT->UA_MIDIA)
			TMP->T_DESC    := iif(Empty(SQL_FAT->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_FAT->UA_MIDIA,"SUH->UH_DESC"))
			TMP->T_NUM     := SQL_FAT->UA_NUM
			TMP->T_CLIENTE := SQL_FAT->UA_CLIENTE
			TMP->T_NOMCLI  := SQL_FAT->A1_NOME
			TMP->T_PLACA   := SQL_FAT->UA_PLACA
			TMP->T_DATA    := SQL_FAT->UA_EMISSAO
			TMP->T_ORCADO  := SQL_FAT->UA_VALBRUT
			TMP->T_NOTA    := SQL_FAT->F2_DOC
			TMP->T_LOJA    := SQL_FAT->F2_FILIAL
			TMP->T_FAT     := SQL_FAT->F2_VALBRUT
			MsUnlock()
		Endif
		dbSelectArea("SQL_FAT")
		cChave := F2_FILIAL+F2_SERIE+F2_DOC
		lSair  := .F.
		Do While !eof() .and. F2_FILIAL+F2_SERIE+F2_DOC = cChave .and. !lSair
			If Empty(F2_FILIAL+F2_SERIE+F2_DOC)
				lSair := .T.
			Endif
			dbSkip()
		Enddo
	Enddo
	dbSelectArea("SQL_FAT")
	dbCloseArea()

	dbSelectArea("SQL_LOJ")
	dbGoTop()
	Do While !eof()
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			TMP->T_OPER    := SQL_LOJ->UA_OPERADO
			TMP->T_NOME    := SQL_LOJ->U7_NOME
			TMP->T_COMPL   := SQL_LOJ->UA_COMPL
			TMP->T_MIDIA   := iif(Empty(SQL_LOJ->UA_MIDIA),"000000",SQL_LOJ->UA_MIDIA)
			TMP->T_DESC    := iif(Empty(SQL_LOJ->UA_MIDIA),"SEM MIDIA",Posicione("SUH",1,xFilial("SUH")+SQL_LOJ->UA_MIDIA,"SUH->UH_DESC"))
			TMP->T_NUM     := SQL_LOJ->UA_NUM
			TMP->T_CLIENTE := SQL_LOJ->UA_CLIENTE
			TMP->T_NOMCLI  := SQL_LOJ->A1_NOME
			TMP->T_PLACA   := SQL_LOJ->UA_PLACA
			TMP->T_DATA    := SQL_LOJ->UA_EMISNF
			TMP->T_ORCADO  := SQL_LOJ->UA_VALBRUT // iif(SQL_LOJ->UA_EMISSAO >= mv_par01 .AND. SQL_LOJ->UA_EMISSAO <= mv_par02,SQL_LOJ->UA_VALBRUT,0)
			TMP->T_NOTA    := SQL_LOJ->UA_DOC
			TMP->T_LOJA    := SQL_LOJ->UA_LOJASL1
			TMP->T_FAT     := SQL_LOJ->UA_VDALOJ
			MsUnlock()
		Endif
		dbSelectArea("SQL_LOJ")
		dbSkip()
	Enddo
	dbSelectArea("SQL_LOJ")
	dbCloseArea()
Return