#include "rwmake.ch"
#include "topconn.ch"

User Function TMKR05()
	Private cString        := "SUA"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Posição diária de vendas por operador"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 80
	Private tamanho        := "M"
	Private nomeprog       := "TMKR05"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "TMKR05"
	Private titulo         := "Posição diária de vendas por operador"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "TMKR05"
	Private lImp           := .f.
	Private cSql           := ""

	// Carrega / Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","   ","","","",""})
	AADD(aRegs,{cPerg,"03","Do Operador        ?"," "," ","mv_ch3","C", 06,0,0,"G","","mv_par03",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SU7","","","",""})
	AADD(aRegs,{cPerg,"04","Ate o Operador     ?"," "," ","mv_ch4","C", 06,0,0,"G","","mv_par04",""       ,""  ,""   ,"","",""            ,""  ,""  ,"","",""            ,"","","","",""          ,"","","","",""     ,"","","","SU7","","","",""})

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
	Cabec1:="          Data                    Orcado              Faturado     Qtd Orcamentos      Qtd Faturados   Aproveitamento"
	        *          99/99/99     99.999.999.999,99     99.999.999.999,99     99.999.999.999     99.999.999.999           999,99%
	        *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	cSql := ""
	cSql += "SELECT UA_OPERADO,U7_NOME,UA_EMISSAO,Sum(UA_VALBRUT) AS ORCADO,COUNT(UA_FILIAL) AS NUM_ORCS"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_OPERADO,U7_NOME,UA_EMISSAO"
	cSql += " ORDER BY UA_OPERADO,UA_EMISSAO"

	MsgRun("Consultando Banco de dados ... Orçados",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Orçados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_ORC", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Orçados",,{|| TcSetField("SQL_ORC","UA_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Orçados",,{|| TcSetField("SQL_ORC","ORCADO"  ,"N",14,2)})
	MsgRun("Consultando Banco de dados ... Orçados",,{|| TcSetField("SQL_ORC","NUM_ORCS","N",10,0)})


	cSql := ""
	cSql += "SELECT DISTINCT UA_OPERADO,UA_EMISSAO,UA_FIM,U7_NOME,F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SF2.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_PLACA <> ''"
	cSql += " AND   UA_VDALOJ <= 0"
	cSql += " AND   F2_PLACA = UA_PLACA"
	cSql += " AND   F2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02+45)+"'"
	cSql += " AND   F2_EMISSAO >= UA_EMISSAO"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " ORDER BY F2_FILIAL,F2_SERIE,F2_DOC,UA_EMISSAO,UA_FIM"

	MsgRun("Consultando Banco de dados ... Faturados",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_FAT", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","F2_EMISSAO","D")})
	MsgRun("Consultando Banco de dados ... Faturados",,{|| TcSetField("SQL_FAT","F2_VALFAT","N",14,2)})

	cSql := ""
	cSql += "SELECT UA_OPERADO,U7_NOME,UA_EMISNF,Sum(UA_VDALOJ) AS FATURADO,COUNT(UA_FILIAL) AS NUM_LOJA"
	cSql += " FROM "+RetSqlName("SUA")+" SUA, "+RetSqlName("SU7")+" SU7"
	cSql += " WHERE SUA.D_E_L_E_T_ = ''"
	cSql += " AND   SU7.D_E_L_E_T_ = ''"
	cSql += " AND   UA_FILIAL = '01'"
	cSql += " AND   UA_EMISNF BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql += " AND   UA_OPERADO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
	cSql += " AND   UA_VDALOJ > 0"
	cSql += " AND   U7_FILIAL = '"+xFilial("SU7")+"'"
	cSql += " AND   U7_COD = UA_OPERADO"
	cSql += " AND   U7_POSTO = '07'"
	cSql += " GROUP BY UA_OPERADO,U7_NOME,UA_EMISNF"
	cSql += " ORDER BY UA_OPERADO,UA_EMISNF"

	MsgRun("Consultando Banco de dados ... Loja",,{|| cSql := ChangeQuery(cSql)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_LOJ", .T., .T.)})

	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","UA_EMISNF","D")})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","FATURADO","N",14,2)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","ORCADO","N",14,2)})
	MsgRun("Consultando Banco de dados ... Loja",,{|| TcSetField("SQL_LOJ","NUM_LOJA","N",10,0)})

	// Monta estrutura do temporario
	aEstru := {}
	aadd(aEstru,{"T_OPER"     ,"C",06,0})
	aadd(aEstru,{"T_NOME"     ,"C",30,0})
	aadd(aEstru,{"T_DATA"     ,"D",08,0})
	aadd(aEstru,{"T_ORCADO"   ,"N",14,2})
	aadd(aEstru,{"T_FAT"      ,"N",14,2})
	aadd(aEstru,{"T_NUM_ORC"  ,"N",10,0})
	aadd(aEstru,{"T_NUM_FAT"  ,"N",10,0})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_OPER+DTOS(T_DATA)",,.t.,"Selecionando Registros...")

	MsgRun("Montando temporario ...",,{|| LoadTmp() })

	dbSelectArea("TMP")
	ProcRegua(LastRec())
	dbGoTop()
	aTotGeral := {0,0,0,0}

	Do while !eof()
		lImp := .T.
		cOper := T_OPER
		aTotOper  := {0,0,0,0}

		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+2
		endif

		@ li,001 PSAY T_OPER + " - " + T_NOME
		Li++

		Do while !eof() .and. T_OPER = cOper
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

			@ LI,010 PSAY T_DATA
			@ LI,023 PSAY T_ORCADO  PICTURE "@E 99,999,999,999.99"
			@ LI,045 PSAY T_FAT     PICTURE "@E 99,999,999,999.99"

			@ LI,067 PSAY T_NUM_ORC PICTURE "@E 99,999,999,999"
			@ LI,086 PSAY T_NUM_FAT PICTURE "@E 99,999,999,999"
			@ LI,111 PSAY (T_NUM_FAT/T_NUM_ORC)*100 PICTURE "@E 999.99"
			@ LI,117 PSAY "%"

			aTotOper[1] += T_ORCADO
			aTotOper[2] += T_FAT
			aTotOper[3] += T_NUM_ORC
			aTotOper[4] += T_NUM_FAT

			aTotGeral[1] += T_ORCADO
			aTotGeral[2] += T_FAT
			aTotGeral[3] += T_NUM_ORC
			aTotGeral[4] += T_NUM_FAT

			Li:=Li+1
			dbSkip()
		Enddo
		@ LI,001 PSAY "Total do Operador:"
		@ LI,023 PSAY aTotOper[1] PICTURE "@E 99,999,999,999.99"
		@ LI,045 PSAY aTotOper[2] PICTURE "@E 99,999,999,999.99"
		@ LI,067 PSAY aTotOper[3] PICTURE "@E 99,999,999,999"
		@ LI,086 PSAY aTotOper[4] PICTURE "@E 99,999,999,999"
		@ LI,111 PSAY (aTotOper[4]/aTotOper[3])*100 PICTURE "@E 999.99"
		@ LI,117 PSAY "%"
		Li:=Li+2
	enddo
	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	if lImp .AND. !lAbortPrint
		@ LI,001 PSAY "Total Geral:"
		@ LI,023 PSAY aTotGeral[1] PICTURE "@E 99,999,999,999.99"
		@ LI,045 PSAY aTotGeral[2] PICTURE "@E 99,999,999,999.99"
		@ LI,067 PSAY aTotGeral[3] PICTURE "@E 99,999,999,999"
		@ LI,086 PSAY aTotGeral[4] PICTURE "@E 99,999,999,999"
		@ LI,111 PSAY (aTotGeral[4]/aTotGeral[3])*100 PICTURE "@E 999.99"
		@ LI,117 PSAY "%"
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
			TMP->T_DATA    := SQL_ORC->UA_EMISSAO
			TMP->T_ORCADO  := SQL_ORC->ORCADO
			TMP->T_FAT     := 0
			TMP->T_NUM_ORC := SQL_ORC->NUM_ORCS
			TMP->T_NUM_FAT := 0
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
		dbSeek(SQL_FAT->UA_OPERADO+dtos(SQL_FAT->F2_EMISSAO))
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_FAT     += SQL_FAT->F2_VALBRUT
				TMP->T_NUM_FAT += 1
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_OPER    := SQL_FAT->UA_OPERADO
				TMP->T_NOME    := SQL_FAT->U7_NOME
				TMP->T_DATA    := SQL_FAT->F2_EMISSAO
				TMP->T_ORCADO  := 0
				TMP->T_FAT     := SQL_FAT->F2_VALBRUT
				TMP->T_NUM_ORC := 0
				TMP->T_NUM_FAT := 1
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
		dbSeek(SQL_LOJ->UA_OPERADO+dtos(SQL_LOJ->UA_EMISNF))
		If Found()
			If RecLock("TMP",.F.)
				TMP->T_FAT     += SQL_LOJ->FATURADO
				TMP->T_NUM_FAT += SQL_LOJ->NUM_LOJA
				MsUnlock()
			Endif
		Else
			If RecLock("TMP",.T.)
				TMP->T_OPER    := SQL_LOJ->UA_OPERADO
				TMP->T_NOME    := SQL_LOJ->U7_NOME
				TMP->T_DATA    := SQL_LOJ->UA_EMISNF
				TMP->T_ORCADO  := 0
				TMP->T_FAT     := SQL_LOJ->FATURADO
				TMP->T_NUM_ORC := 0
				TMP->T_NUM_FAT := SQL_LOJ->NUM_LOJA
				MsUnlock()
			Endif
		Endif
		dbSelectArea("SQL_LOJ")
		dbSkip()
	Enddo
	dbSelectArea("SQL_LOJ")
	dbCloseArea()
Return