#include "rwmake.ch"
#include "topconn.ch"
#Define IniFatLine  Chr(27)+Chr(06)+Chr(01)
#Define FimFatLine  Chr(27)+Chr(06)+Chr(02)

User Function DFATR00
	Private cString        := "SD2"
	Private aOrd           := {}
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Consolidado Gerencial"
	Private tamanho        := "M"
	Private nomeprog       := "DFATR00"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "DFTR00"
	Private titulo         := "Consolidado Gerencial"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DFATR00"
	Private lImp           := .F.

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	AADD(aRegs,{cPerg,"01","Da Data            ?"," "," ","mv_ch1","D", 08,0,0,"G","","mv_par01",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"02","Ate a Data         ?"," "," ","mv_ch2","D", 08,0,0,"G","","mv_par02",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","",""          })
	AADD(aRegs,{cPerg,"03","Coeficiente Liq.   ?"," "," ","mv_ch3","N", 06,4,0,"G","","mv_par03",""       ,"","","","",""       ,"","","","",""       ,"","","","","","","","","","","","","","   ","","","","@e 9.9999" })

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
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27; Return; Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27; Return; Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return nil


Static Function RunReport()
	// Declara Variaveis
	lFatura := lRecapa := lRecauc := lServic := lAssTec := lNovo := lOutros := lConsert := lSoCon := .F.
	aFatura:={}; aBaixas:={}; aVencer:={}; aVencidos:={}; aDesc:={}; aRecapa:={}
	aCstRecauc:={}; aRecauc:={}; aCstRecapa:={}; aServic:={}; aAssTec:={}; aNovo:={}
	aOutros:={}; aRecLiq:={}; aPneus:={}; aColetas:={}; aRecauCon:={}; aRejeitado:={}
	aAnalise:={}; aCredito:={}; aCliente:={}; aKgConsumo:={}; aKgEstoque:={}; aItColet:={}
	aRejeiFat:={}; aProdFat:={}; aMontag:={}; aTerceiro:={}; aAutoCla:={}; aConsert:={}; aSoCon:={}; aEmpenho := {}

	Titulo := AllTrim(Titulo) + " - De " + dtoc(mv_par01) + " a " + dtoc(mv_par02)
	Cabec1:="                                  "
	        * XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99   99,999,999,999.99
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

	// Busca Filiais do Usuário
	PswOrder(1)
	PswSeek(__cUserId,.T.)
	aUsuario := PswRet()
	cFil_User := ""
	cFil_Sql  := ""
	aFil_User := {}
	For k=1 to Len(aUsuario[2,6])
		cFil_User += "'"+Substr(aUsuario[2,6,k],3,2)+"',"
	Next
	cFil_User := Substr(cFil_User,1,Len(cFil_User)-1)

	// Busca Filiais do Sistema
	dbselectarea("SM0")
	nRec    := Recno()
	cEmpAtu := M0_CODIGO
	dbGoTop()
	dbSetOrder(1)
	dbSeek(cEmpAtu)
	Do while !eof() .AND. M0_CODIGO = cEmpAtu .AND. Len(aFil_User) <= 8
		If M0_CODFIL $ cFil_User .OR. cFil_User = "'@@'"
			cFil_Sql += "'"+M0_CODFIL+"',"
			aAdd(aFil_User,M0_CODFIL)
		Endif
		dbSkip()
	Enddo
	cFil_Sql := Substr(cFil_Sql,1,Len(cFil_Sql)-1)
	dbGoTo(nRec)

	If Len(aFil_User) = 1
		tamanho := "P"
	Elseif Len(aFil_User) > 1 .AND. Len(aFil_User) <= 4
		tamanho := "M"
	Else
		tamanho := "G"
	Endif

	// Monta Cabec com os nomes das filiais, cadastrados no SX5, tabela ZZ
	for k=1 to Len(aFil_User)
		cNomeFil := aFil_User[k] + " - " + Tabela("ZZ",aFil_User[k],.F.)
		Cabec1 := Cabec1 + Right(Space(17)+cNomeFil,17)+Space(3)
	Next k
	Cabec1 := Cabec1 + Right(Space(17)+"TOTAL",17)+Space(3)


	aEstru := {}
	aadd(aEstru,{"T_ORDEM"  ,"C",02,0})
	aadd(aEstru,{"T_DESC"   ,"C",30,0})

	For k = 1 to Len(aFil_User)
		aadd(aEstru,{"T_FILIAL"+aFil_User[K],"N",14,2})
		aadd(aEstru,{"T_PICT"  +aFil_User[K],"C",20,0})
	Next k

	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_ORDEM",,.t.,"Selecionando Registros...")

	cSql := ""
	cSql := cSql + "SELECT D2_FILIAL,D2_TOTAL,D2_DESCON,D2_TES,D2_QUANT"
	cSql := cSql + " ,     F4_DUPLIC,F4_ESTOQUE"
	cSql := cSql + " ,     B1_GRUPO,B1_X_ESPEC,B1_X_GRUPO,B1_X_DEPTO"
	cSql := cSql + " ,     C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO"
	cSql := cSql + " ,     C7_TOTAL"
	cSql := cSql + " FROM "+RetSqlName("SD2")+" SD2"

	cSql := cSql + " JOIN "+RetSqlName("SF4")+" SF4"
	cSql := cSql + " ON   SF4.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  F4_FILIAL = '"+xFilial("SF4")+"'"
	cSql := cSql + " AND  F4_CODIGO = D2_TES"

	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_FILIAL = '"+xFilial("SB1")+"'"
	cSql := cSql + " AND  B1_COD = D2_COD"

	cSql := cSql + " JOIN "+RetSqlName("SC6")+" SC6"
	cSql := cSql + " ON   SC6.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C6_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  C6_NUM = D2_PEDIDO"
	cSql := cSql + " AND  C6_ITEM = D2_ITEMPV"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SC2")+" SC2"
	cSql := cSql + " ON   SC2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C2_FILIAL = D2_FILIAL"
	cSql := cSql + " AND  C2_NUM = C6_NUMOP"
	cSql := cSql + " AND  C2_ITEM = C6_ITEMOP"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SC1")+" SC1"
	cSql := cSql + " ON   SC1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C1_FILIAL = C2_FILIAL"
	cSql := cSql + " AND  C1_OP = C2_NUM || C2_ITEM || C2_SEQUEN"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SC7")+" SC7"
	cSql := cSql + " ON   SC7.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C7_FILIAL = C1_FILIAL"
	cSql := cSql + " AND  C7_NUM = C1_PEDIDO"
	cSql := cSql + " AND  C7_ITEM = C1_ITEMPED"

	cSql := cSql + " WHERE SD2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   D2_FILIAL IN("+cFil_Sql+")"
	cSql := cSql + " AND   D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   D2_TIPO = 'N'"
	cSql := cSql + " AND   D2_TES NOT IN('903','902')"
	cSql := cSql + " ORDER BY D2_FILIAL"

	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

	TcSetField("ARQ_SQL","D2_TOTAL" ,"N",14,2)
	TcSetField("ARQ_SQL","D2_DESCON","N",14,2)
	TcSetField("ARQ_SQL","C7_TOTAL" ,"N",14,2)
	
	dbSelectArea("ARQ_SQL")
	ProcRegua(0)
	dbgoTop()

	// Dimensiona Arrays
	for k=1 To Len(aFil_User)
		aadd(aFatura   ,{aFil_User[k],0}); aadd(aBaixas   ,{aFil_User[k],0}); aadd(aVencer   ,{aFil_User[k],0})
		aadd(aVencidos ,{aFil_User[k],0}); aadd(aDesc     ,{aFil_User[k],0}); aadd(aRecapa   ,{aFil_User[k],0})
		aadd(aCstRecauc,{aFil_User[k],0}); aadd(aRecauc   ,{aFil_User[k],0}); aadd(aCstRecapa,{aFil_User[k],0})
		aadd(aServic   ,{aFil_User[k],0}); aadd(aAssTec   ,{aFil_User[k],0}); aadd(aNovo     ,{aFil_User[k],0})
		aadd(aOutros   ,{aFil_User[k],0}); aadd(aRecLiq   ,{aFil_User[k],0}); aadd(aPneus    ,{aFil_User[k],0})
		aadd(aColetas  ,{aFil_User[k],0}); aadd(aRecauCon ,{aFil_User[k],0}); aadd(aRejeitado,{aFil_User[k],0})
		aadd(aAnalise  ,{aFil_User[k],0}); aadd(aCredito  ,{aFil_User[k],0}); aadd(aCliente  ,{aFil_User[k],0})
		aadd(aKgConsumo,{aFil_User[k],0}); aadd(aKgEstoque,{aFil_User[k],0}); aadd(aItColet  ,{aFil_User[k],0})
		aadd(aRejeiFat ,{aFil_User[k],0}); aadd(aProdFat  ,{aFil_User[k],0}); aadd(aMontag   ,{aFil_User[k],0})
		aadd(aTerceiro ,{aFil_User[k],0}); aadd(aAutoCla  ,{aFil_User[k],0}); aadd(aConsert  ,{aFil_User[k],0})
		aadd(aSoCon    ,{aFil_User[k],0}); aadd(aEmpenho  ,{aFil_User[k],0})
	Next k

	Do While !eof()
		lFatura  := ( !(Upper(AllTrim(B1_GRUPO)) = "CARC") .AND. F4_DUPLIC = "S")
		lRecapa  := (Upper(AllTrim(B1_GRUPO)) = "SERV" .AND. F4_ESTOQUE = "N"  .AND. B1_X_GRUPO = "R" .AND. F4_DUPLIC = "S")
		lRecauc  := (Upper(AllTrim(B1_GRUPO)) $ "SERV" .AND. F4_ESTOQUE = "N"  .AND. B1_X_GRUPO = "T" .AND. F4_DUPLIC = "S")
		lConsert := (Upper(AllTrim(B1_GRUPO)) $ "CI" .AND. F4_ESTOQUE = "N" .AND. F4_DUPLIC = "S")
		lSoCon   := (Upper(AllTrim(B1_GRUPO)) $ "SC" .AND. F4_ESTOQUE = "N" .AND. F4_DUPLIC = "S")
		lServic  := (Upper(AllTrim(B1_GRUPO)) $ GetMv("MV_X_GRPRO",.F.,"CI  /SC  ") .AND. F4_ESTOQUE = "N" .AND. F4_DUPLIC = "S")
		lAssTec  := (Upper(AllTrim(B1_GRUPO)) $ "ATEC" .AND. F4_DUPLIC = "S")
		lNovo    := ((Upper(AllTrim(B1_GRUPO)) $ "0001/0002/0003/BAND" .or. SD2->D2_TES $ "503*506") .AND. F4_DUPLIC = "S")
		lOutros  := (!lRecapa .AND. !lRecauc .AND. !lServic .AND. !lAssTec .AND. !lNovo .AND. F4_DUPLIC = "S")

		If lFatura
			ValVetor(@aFatura,D2_FILIAL,D2_TOTAL+D2_DESCON)
		Endif

		if lFatura .OR. lRecapa .OR. lRecauc .OR. lServic .OR. lAsstec .OR. lNovo .OR. lOutros
			ValVetor(@aDesc,D2_FILIAL,D2_DESCON)
		Endif

		If lRecapa
			ValVetor(@aRecapa,D2_FILIAL,D2_TOTAL+D2_DESCON)
			ValVetor(@aRecLiq,D2_FILIAL,D2_TOTAL)
			ValVetor(@aPneus,D2_FILIAL,D2_QUANT)

			cSql := ""
			cSql := cSql + "SELECT D3_GRUPO,G1_XCSBI,B1_CUSTD,D3_QUANT"
			cSql := cSql + " FROM "+RetSqlName("SD3")+" SD3"

			cSql := cSql + " LEFT JOIN "+RetSqlName("SG1")+" SG1"
			cSql := cSql + " ON   SG1.D_E_L_E_T_ = ''"
			cSql := cSql + " AND  G1_COD = '"+ARQ_SQL->C2_PRODUTO+"'"
			cSql := cSql + " AND  G1_COMP = D3_COD"
			cSql := cSql + " AND  G1_INI >= D3_EMISSAO"
            cSql := cSql + " AND  G1_FIM <= D3_EMISSAO"
            
			cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
			cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
			cSql := cSql + " AND  B1_COD = D3_COD"

			cSql := cSql + " WHERE SD3.D_E_L_E_T_ = ''"
			cSql := cSql + " AND   D3_OP = '"+ARQ_SQL->C2_NUM+C2_ITEM+C2_SEQUEN+"'"
			cSql := cSql + " AND   D3_ESTORNO <> 'S'"
			cSql := cSql + " AND   D3_GRUPO IN('BAND','MANC')"

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_CST", .T., .T.)
			TcSetField("ARQ_CST","G1_XCSBI"  ,"N",14,2)
			TcSetField("ARQ_CST","D3_QTSEGUM","N",14,2)
			dbSelectArea("ARQ_CST")
			Do While !eof()
				incProc("Mapa Diário ...")
				ValVetor(@aCstRecapa,ARQ_SQL->D2_FILIAL,iif(D3_GRUPO="BAND",G1_XCSBI,0))
				ValVetor(@aKgConsumo,ARQ_SQL->D2_FILIAL,iif(D3_GRUPO="BAND",D3_QUANT,0))
				dbSkip()
			Enddo
			dbCloseArea()
			dbSelectArea("ARQ_SQL")
		Endif

		If lRecauc
			ValVetor(@aRecauc,D2_FILIAL,D2_TOTAL+D2_DESCON)
			ValVetor(@aCstRecauc,D2_FILIAL,C7_TOTAL)
		Endif

		If lRecauc
			ValVetor(@aRecauCon,D2_FILIAL,D2_QUANT)
		Endif

		If lConsert
			ValVetor(@aConsert,D2_FILIAL,D2_QUANT)
		Endif

		If lSoCon
			ValVetor(@aSoCon,D2_FILIAL,D2_QUANT)
		Endif

		If lServic
			ValVetor(@aServic,D2_FILIAL,D2_TOTAL+D2_DESCON)
		Endif

		If lAssTec
			ValVetor(@aAssTec,D2_FILIAL,D2_TOTAL+D2_DESCON)
		Endif

		If lNovo
			ValVetor(@aNovo,D2_FILIAL,D2_TOTAL+D2_DESCON)
		Endif

		If lOutros
			ValVetor(@aOutros,D2_FILIAL,D2_TOTAL+D2_DESCON)
		Endif
		dbSkip()
	Enddo
	dbCloseArea()

	// Baixas no Periodo
	incProc("Baixas no periodo ...")
	cSql := ""
	cSql := cSql + "SELECT E1_MSFIL,Sum(E5_VALOR) AS VALOR"
	cSql := cSql + " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName(+"SE1")+" SE1"
	cSql := cSql + " WHERE SE5.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   SE1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   E5_FILIAL = '"+xFilial("SE5")+"'"
	cSql := cSql + " AND   E5_RECPAG ='R'"
	cSql := cSql + " AND   E5_TIPODOC IN('BA','VL','V2')"
	cSql := cSql + " AND   E5_TIPO = 'NF'"
	cSql := cSql + " AND   E5_SITUACA <> 'C'"
	cSql := cSql + " AND   E5_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   E1_FILIAL = E5_FILIAL"
	cSql := cSql + " AND   E1_PREFIXO = E5_PREFIXO"
	cSql := cSql + " AND   E1_NUM = E5_NUMERO"
	cSql := cSql + " AND   E1_PARCELA = E5_PARCELA"
	cSql := cSql + " AND   E1_MSFIL IN("+cFil_Sql+")"
	cSql := cSql + " GROUP BY E1_MSFIL"
	cSql := cSql + " ORDER BY E1_MSFIL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","VALOR","N",14,2)
	Do While !eof()
		incProc("Baixas no periodo ...")
		ValVetor(@aBaixas,E1_MSFIL,VALOR)
		dbSkip()
	Enddo
	dbCloseArea()


	// Titulos a Vencer
	incProc("Titulos a Vencer ...")
	cSql := ""
	cSql := cSql + "SELECT E1_MSFIL,SUM(E1_SALDO) AS VALOR"
	cSql := cSql + " FROM "+RetSqlName("SE1")+" SE1"
	cSql := cSql + " WHERE SE1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql := cSql + " AND   E1_MSFIL IN("+cFil_Sql+")"
	cSql := cSql + " AND   E1_SALDO > 0"
	cSql := cSql + " AND   E1_VENCREA >= '"+dtos(dDataBase)+"'"
	cSql := cSql + " GROUP BY E1_MSFIL"
	cSql := cSql + " ORDER BY E1_MSFIL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","VALOR","N",14,2)
	Do While !eof()
		incProc("Titulos a Vencer ...")
		ValVetor(@aVencer,E1_MSFIL,VALOR)
		dbSkip()
	Enddo
	dbCloseArea()


	// Titulos Vencidos
	incProc("Titulos Vencidos ...")
	cSql := ""
	cSql := cSql + "SELECT E1_MSFIL,SUM(E1_SALDO) AS VALOR"
	cSql := cSql + " FROM "+RetSqlName("SE1")+" SE1"
	cSql := cSql + " WHERE SE1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql := cSql + " AND   E1_MSFIL IN("+cFil_Sql+")"
	cSql := cSql + " AND   E1_SALDO > 0"
	cSql := cSql + " AND   E1_VENCREA < '"+dtos(dDataBase)+"'"
	cSql := cSql + " GROUP BY E1_MSFIL"
	cSql := cSql + " ORDER BY E1_MSFIL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","VALOR","N",14,2)
	Do While !eof()
		incProc("Titulos Vencidos ...")
		ValVetor(@aVencidos,E1_MSFIL,VALOR)
		dbskip()
	Enddo
	dbCloseArea()
	

	// Total de Coletas (NF)
	incProc("Total de coletas (NF)...")
	cSql := ""
	cSql := cSql + "SELECT F1_FILIAL,COUNT(F1_FILIAL) AS NUM FROM "+RetSqlName("SF1")
	cSql := cSql + " WHERE D_E_L_E_T_ = ''"
	cSql := cSql + " AND   F1_FILIAL IN("+cFil_Sql+")"
	cSql := cSql + " AND   F1_TIPO = 'B'"
	cSql := cSql + " AND   F1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " GROUP BY F1_FILIAL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","NUM","N",10,0)
	Do While !eof()
		incProc("Total de coletas (NF)...")
		ValVetor(@aColetas,F1_FILIAL,NUM)
		dbskip()
	Enddo
	dbCloseArea()


	// Total de Coletas (Pneus)
	incProc("Total de coletas (Pneus)...")
	cSql := ""
	cSql := cSql + "SELECT D1_FILIAL,SUM(D1_QUANT) AS NUM FROM "+RetSqlName("SD1")
	cSql := cSql + " WHERE D_E_L_E_T_ = ''"
	cSql := cSql + " AND   D1_FILIAL IN("+cFil_Sql+")"
	cSql := cSql + " AND   D1_TIPO = 'B'"
	cSql := cSql + " AND   D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " GROUP BY D1_FILIAL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","NUM","N",10,0)
	Do While !eof()
		incProc("Total de coletas (Pneus)...")
		ValVetor(@aItColet,D1_FILIAL,NUM)
		dbskip()
	Enddo
	dbCloseArea()


	// Total Rejeitados,Analise,Credito,Cliente
	incProc("Rejeitados,Analise,Credito,Cliente ...")
	cSql := ""
	cSql := cSql + "SELECT C2_FILIAL,C2_X_STATU,C6_NOTA,COUNT(C2_X_STATU) AS NUM FROM "+RetSqlName("SC2")+" SC2"

	cSql := cSql + " LEFT JOIN "+RetSqlName("SC6")+" SC6"
	cSql := cSql + " ON   SC6.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  C6_FILIAL IN("+cFil_Sql+")"
	cSql := cSql + " AND  C6_NUMOP = C2_NUM"
	cSql := cSql + " AND  C6_ITEMOP = C2_ITEM"

	cSql := cSql + " WHERE SC2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   C2_FILIAL IN("+cFil_Sql+")"
	//cSql := cSql + " AND   C2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   C2_EMISSAO <= '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   C2_X_STATU IN('1','6','9','A','B')"
	cSql := cSql + " GROUP BY C2_FILIAL,C2_X_STATU,C6_NOTA"
	cSql := cSql + " ORDER BY C2_FILIAL,C2_X_STATU"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","NUM","N",10,0)
	Do While !eof()
		incProc("Rejeitados,Analise,Credito,Cliente ...")

		IF C2_X_STATU == "1"
			ValVetor(@aAnalise,C2_FILIAL,NUM)
		ElseIF C2_X_STATU == "4"
			ValVetor(@aMontag,C2_FILIAL,NUM)
		ElseIF C2_X_STATU == "5"
			ValVetor(@aAutoCla,C2_FILIAL,NUM)
		ElseIF C2_X_STATU == "6"
			If Empty(C6_NOTA)
				ValVetor(@aProdFat,C2_FILIAL,NUM)
			Endif
		ElseIF C2_X_STATU == "7"
			ValVetor(@aTerceiro,C2_FILIAL,NUM)
		ElseIF C2_X_STATU == "9"
			If Empty(C6_NOTA)
				ValVetor(@aRejeiFat,C2_FILIAL,NUM)
			Endif
	    ElseIF C2_X_STATU == "A"
			ValVetor(@aCliente,C2_FILIAL,NUM)
	    ElseIF C2_X_STATU == "B"
			ValVetor(@aCredito,C2_FILIAL,NUM)
		Endif
		dbskip()
	Enddo
	dbCloseArea()

	// Total Rejeitados,Analise,Credito,Cliente
	incProc("Rejeitados,Analise,Credito,Cliente ...")
	cSql := ""
	cSql := cSql + "SELECT C2_FILIAL,COUNT(C2_X_STATU) AS NUM FROM "+RetSqlName("SC2")+" SC2"
	cSql := cSql + " WHERE SC2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   C2_FILIAL IN("+cFil_Sql+")"
	cSql := cSql + " AND   C2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   C2_X_STATU = '9'"
	cSql := cSql + " GROUP BY C2_FILIAL"
	cSql := cSql + " ORDER BY C2_FILIAL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","NUM","N",10,0)
	Do While !eof()
		ValVetor(@aRejeitado,C2_FILIAL,NUM)
		dbskip()
	Enddo
	dbCloseArea()


	// KG Banda em estoque
	incProc("Banda em estoque (Kg)...")
	cSql := ""
	cSql := cSql + "SELECT B2_FILIAL,SUM(B2_QATU) NUM"
	cSql := cSql + " FROM "+RetSqlName("SB2")+" SB2"

	cSql := cSql + " JOIN "+RetSqlName("SB1")+" SB1"
	cSql := cSql + " ON   SB1.D_E_L_E_T_ = ''"
	cSql := cSql + " AND  B1_FILIAL = ''"
	cSql := cSql + " AND  B1_COD = B2_COD"
	cSql := cSql + " AND  B1_GRUPO = 'BAND'"

	cSql := cSql + " WHERE SB2.D_E_L_E_T_ = ''"
	cSql := cSql + " AND   B2_FILIAL IN("+cFil_Sql+")"
	cSql := cSql + " GROUP BY B2_FILIAL"

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","NUM","N",10,0)
	Do While !eof()
		incProc("Banda em estoque (Kg)...")
		ValVetor(@aKgEstoque,B2_FILIAL,NUM)
		dbskip()
	Enddo
	dbCloseArea()


	cSql := ""
	cSql := cSql + "SELECT D3_FILIAL,COUNT(D3_OP) AS EMPENHO"
	cSql := cSql + " FROM (SELECT DISTINCT D3_FILIAL,D3_OP FROM SD3030"
	cSql := cSql + " WHERE D_E_L_E_T_ = ''"
	cSql := cSql + " AND   D3_FILIAL IN("+cFil_Sql+")"
	cSql := cSql + " AND   D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"'"
	cSql := cSql + " AND   D3_GRUPO = 'BAND'"
	cSql := cSql + " AND   D3_OP <> ''"
	cSql := cSql + " AND   D3_CF = 'RE0'"
	cSql := cSql + " AND   D3_ESTORNO <> 'S') AS TAB"
	cSql := cSql + " GROUP BY D3_FILIAL"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
	TcSetField("ARQ_SQL","EMPENHO","N",10,0)
	Do While !eof()
		incProc("Pneus com empenho...")
		ValVetor(@aEmpenho,D3_FILIAL,EMPENHO)
		dbskip()
	Enddo
	dbCloseArea()



	incProc("Montando temporário ...")
	GravaTmp("01","Faturamento Bruto"             ,{|x| aFatura[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("02","Descontos"                     ,{|x| aDesc[x,2] }                                  ,"@e 99,999,999,999.99")
	GravaTmp("03","Faturamento Liquido"           ,{|x| aFatura[x,2]-aDesc[x,2] }                     ,"@e 99,999,999,999.99")

	GravaTmp("04","Valores Baixados"              ,{|x| aBaixas[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("05","Titulos a Vencer"              ,{|x| aVencer[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("06","Titulos Vencidos"              ,{|x| aVencidos[x,2] }                              ,"@e 99,999,999,999.99")

	GravaTmp("07","Recapagem"                     ,{|x| aRecapa[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("08","Custo Recapagem"               ,{|x| aCstRecapa[x,2] }                             ,"@e 99,999,999,999.99")
	GravaTmp("09","Recauchutagem"                 ,{|x| aRecauc[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("10","Custo Recauchutagem"           ,{|x| aCstRecauc[x,2] }                             ,"@e 99,999,999,999.99")
	GravaTmp("11","Serviços"                      ,{|x| aServic[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("12","Assist. Técnica"               ,{|x| aAssTec[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("13","Mercantil"                     ,{|x| aNovo[x,2] }                                  ,"@e 99,999,999,999.99")
	GravaTmp("14","Outros"                        ,{|x| aOutros[x,2] }                                ,"@e 99,999,999,999.99")
	GravaTmp("15","(%) Margem Financeira"         ,{|x| (aRecLiq[x,2] * mv_par03) / aCstRecapa[x,2] } ,"@e 99,999,999,999.99")
	GravaTmp("16","MC Financeira"                 ,{|x| (aRecLiq[x,2] * mv_par03) - aCstRecapa[x,2] } ,"@e 99,999,999,999.99")
	GravaTmp("17","(%) Margem Comercial"          ,{|x| (aRecapa[x,2] * mv_par03) / aCstRecapa[x,2] } ,"@e 99,999,999,999.99")
	GravaTmp("18","MC Comercial"                  ,{|x| (aRecapa[x,2] * mv_par03) - aCstRecapa[x,2] } ,"@e 99,999,999,999.99")
	//GravaTmp("17","Pneus"                         ,{|x| aPneus[x,2] }                                 ,"@e 9,999,999,999,999")

	GravaTmp("19","Total de Coletas (NF)"         ,{|x| aColetas[x,2] }                               ,"@e 9,999,999,999,999")
	GravaTmp("20","Total de Coletas (Pneus)"      ,{|x| aItColet[x,2] }                               ,"@e 9,999,999,999,999")
	GravaTmp("21","Total de Rejeitados"           ,{|x| aRejeitado[x,2] }                             ,"@e 9,999,999,999,999")
	GravaTmp("22","Total de Recapados"            ,{|x| aPneus[x,2] }                                 ,"@e 9,999,999,999,999")
	GravaTmp("23","Total de Recauchutados"        ,{|x| aRecauCon[x,2] }                              ,"@e 9,999,999,999,999")
	GravaTmp("24","Total de Manchões"             ,{|x| aConsert[x,2] }                               ,"@e 9,999,999,999,999")
	GravaTmp("25","Total de Só Consertos"         ,{|x| aSoCon[x,2] }                                 ,"@e 9,999,999,999,999")
	GravaTmp("26","Total de Empenhos"             ,{|x| aEmpenho[x,2] }                               ,"@e 9,999,999,999,999")

	/*
	GravaTmp("24","Pneus em analise"              ,{|x| aAnalise[x,2] }                               ,"@e 9,999,999,999,999")
	GravaTmp("25","Pneus p/ Faturar"              ,{|x| aProdFat[x,2] }                               ,"@e 9,999,999,999,999")
	GravaTmp("26","Pneus Rejeitados p/ Faturar"   ,{|x| aRejeiFat[x,2] }                              ,"@e 9,999,999,999,999")
	GravaTmp("27","Pneus aguardando Credito"      ,{|x| aCredito[x,2] }                               ,"@e 9,999,999,999,999")
	GravaTmp("28","Pneus aguardando Cliente"      ,{|x| aCliente[x,2] }                               ,"@e 9,999,999,999,999")
	*/

	cSql := "SELECT X5_CHAVE,X5_DESCRI FROM "+RetSqlName("SX5")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   X5_FILIAL = ''"
	cSql += " AND   X5_TABELA = 'Z1'"
	cSql += " ORDER BY X5_CHAVE"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SX5_SQL", .T., .T.)
	dbSelectArea("SX5_SQL")
	GravaTmp("27",Capital(X5_DESCRI),{|x| aAnalise[x,2] },"@e 9,999,999,999,999")

	dbSelectArea("SX5_SQL")
	dbSkip()
	GravaTmp("28",Capital(X5_DESCRI),{|x| aMontag[x,2] },"@e 9,999,999,999,999")

	dbSelectArea("SX5_SQL")
	dbSkip()
	GravaTmp("29",Capital(X5_DESCRI),{|x| aAutoCla[x,2] },"@e 9,999,999,999,999")

	dbSelectArea("SX5_SQL")
	dbSkip()
	GravaTmp("30",Capital(X5_DESCRI),{|x| aProdFat[x,2] },"@e 9,999,999,999,999")

	dbSelectArea("SX5_SQL")
	dbSkip()
	GravaTmp("31",Capital(X5_DESCRI),{|x| aTerceiro[x,2] },"@e 9,999,999,999,999")

	dbSelectArea("SX5_SQL")
	dbSkip()
	GravaTmp("32",Capital(X5_DESCRI),{|x| aRejeiFat[x,2] },"@e 9,999,999,999,999")

	dbSelectArea("SX5_SQL")
	dbSkip()
	GravaTmp("33",Capital(X5_DESCRI),{|x| aCliente[x,2] },"@e 9,999,999,999,999")

	dbSelectArea("SX5_SQL")
	dbSkip()
	GravaTmp("34",Capital(X5_DESCRI),{|x| aCredito[x,2] },"@e 9,999,999,999,999")
	dbSelectArea("SX5_SQL")
	dbCloseArea()


	GravaTmp("35","Kilo de Banda consumida"       ,{|x| aKgConsumo[x,2] }                             ,"@e 99,999,999,999.99")
	GravaTmp("36","Kilo de Banda em estoque"      ,{|x| aKgEstoque[x,2] }                             ,"@e 99,999,999,999.99")

	/* Ocultar Temporariamente
	GravaTmp("31","Total de exames atendidos"     ,{|x| 0 }                                           ,"@e 9,999,999,999,999")
	GravaTmp("32","Total de exames recusados"     ,{|x| 0 }                                           ,"@e 9,999,999,999,999")
	GravaTmp("33","Total de exames aceitos"       ,{|x| 0 }                                           ,"@e 9,999,999,999,999")
	*/
	incProc("Montando temporário ...")

	ProcRegua(LastRec())
	dbGoTop()
	Do While !eof()
		IncProc("Imprimindo ...")
		If lAbortPrint
			LI+=3
			@ LI,001 PSAY "*** Cancelado pelo Operador ***"
			lImp := .F.
			exit
		Endif

		lImp:=.t.
		if li>60
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI++
			@ LI,000 PSAY " Coeficiente...: " + Transform(mv_par03,"@e 9.9999")
			LI++
			@ LI,000 PSAY " Data Base.....: " + dtoc(dDataBase)
			LI++
			@ LI,000 PSAY IniFatLine+FimFatLine
			LI++
		endif

		// Grupos
		if T_ORDEM = "01"
			@ LI,001 PSAY "F I N A N C E I R O"
			LI+=2
		Elseif T_ORDEM = "07"
			@ LI,001 PSAY "C O M E R C I A L"
			LI+=2
		Elseif T_ORDEM = "27"
			@ LI,001 PSAY "P R O D U C A O"
			LI+=2
		Endif

		// Pular linha
		if T_ORDEM $ "04*19*35"
			LI++
		Endif

		@ LI,001 PSAY T_DESC
		nCol := 034
		nTotal := 0
		For k=1 to Len(aFil_User)
			@ LI,nCol PSAY FieldGet(FieldPos("T_FILIAL"+aFil_User[k])) PICTURE FieldGet(FieldPos("T_PICT"+aFil_User[k]))
			nTotal += FieldGet(FieldPos("T_FILIAL"+aFil_User[k]))
			nCol := nCol + 20
		Next k
		@ LI,nCol PSAY nTotal PICTURE FieldGet(FieldPos("T_PICT"+aFil_User[1]))
		LI++

		// Traço
		if T_ORDEM $ "06*26"
			@ LI,000 PSAY IniFatLine+FimFatLine
			LI++
		Endif

		dbSkip()
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()

	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())

	if lImp .and. !lAbortPrint
		roda(0,"",Tamanho)
	endif

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil

Static Function GravaTmp(cOrd,cDesc,bValor,cPicture)
	Local aArea := GetArea()

	dbSelectArea("TMP")
	If RecLock("TMP",.T.)
		TMP->T_ORDEM := cOrd
		TMP->T_DESC  := cDesc
		For k=1 to Len(aFil_User)
			FieldPut(FieldPos("T_FILIAL"+aFil_User[k]), Eval(bValor,k) )
			FieldPut(FieldPos("T_PICT"  +aFil_User[k]), cPicture       )
		Next
		MsUnlock()
	Endif

	RestArea(aArea)
Return nil

Static Function ValVetor(aVetor,cFil,nValor)
	aVetor[aScan(aVetor,{|x| x[1] == cFil }),2] += nValor
Return aVetor