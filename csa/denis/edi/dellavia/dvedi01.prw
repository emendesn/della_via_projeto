#Include "Dellavia.ch"
#Include "tbiconn.ch"

User Function DVEDI01
	Private Titulo      := "EDI Mercador - Pedidos de Venda"
	Private aSays       := {}
	Private aButtons    := {}
	Private lAbortPrint := .F.
	Private aEnvLog     := {}
	Public  _DELA030CONDPG := "523"

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER "MERCADOR" PASSWORD "000748" MODULO "TMK"

	/*
	If SM0->M0_CODIGO <> "01"
		msgbox("Esta rotina só pode ser executada na DellaVia","EDI","STOP")
		Return  nil
	Endif

	aAdd(aSays,"Esta rotina importa pedidos de venda pelo padrão Mercador.")

	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Import() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
	*/
	conout("Inicio Importacao Mercador - Carrefour")
	Import()
	conout("Fim Importacao Mercador - Carrefour")
Return nil

Static Function Import()
	Local   aDir        := {}
	Local   aRelato     := {}
	Private cFile       := ""
	Private lMsErroAuto := .F.
	Private aEstru      := {}
	Private n           := 1
	Private cImpFilial  := ""

	//FechaBatch()

	aEstru := {}
	aAdd(aEstru,{"T_LINHA"  ,"C",305,0})
	cTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cTmp,"BUFFER",.F.,.F.)


	aDir := Directory("\mercador\entrada\*.TXT") 
	
	If Len(aDir) < 1
		conout("Nenhum arquivo encontrado no diretorio")
	Endif

	For jj=1 to Len(aDir)
		cFile := "\mercador\entrada\"+aDir[jj,1]
		nHdl := fOpen(cFile,0)
		If fError() != 0
			conout("Ocorreu um erro na abertura do arquivo "+aDir[jj,1])
			Loop
		Endif
		
		conout("Lendo o arquivo "+cFile)

		LoadBuffer()
		dbSelectArea("BUFFER")
		ProcRegua(LastRec())
		dbGoTop()

		Do While !eof()
			if Left(T_LINHA,2) = "01"
				cSql := "SELECT UA_FILIAL FROM "+RetSqlName("SUA")
				cSql += " WHERE D_E_L_E_T_ = ''"
				cSql += " AND   UA_FILIAL BETWEEN '' AND 'ZZ'"
				cSql += " AND   UA_PEDCLI = '"+Substr(T_LINHA,009,009)+"'"

				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"SQL_PED", .T., .T.)
				dbSelectArea("SQL_PED")
				lPedido := !EOF()
				dbCloseArea()

				dbSelectArea("BUFFER")
				If lPedido
					conout("Pedido ja cadastrado no sistema: "+Substr(T_LINHA,009,020))
					dbSkip()
					Do while !eof() .and. Left(T_LINHA,2) <> "01"
						dbSkip()
					Enddo
					Loop
				Endif

				// Monta Cabeçalho
				aCab := {}

				dbSelectArea("SA1")
				dbSetOrder(3)
				dbGoTop()

				cFilSystem := cFilAnt
				dbSeek(xFilial("SA1")+AllTrim(Substr(BUFFER->T_LINHA,167,014))) // CNPJ (166 / 179) (14)
				If Found()
					cFilAnt := A1_LOJA
				Endif

				dbGoTop()
				dbSeek(xFilial("SA1")+AllTrim(Substr(BUFFER->T_LINHA,181,014))) // CNPJ (180 / 193) (14)
				dbSelectArea("BUFFER")
			
				If SA1->(Found())
					cNumOrc := GetSx8Num("SUA","UA_NUM")
					aAdd(aCab,{"UA_FILIAL"      ,cFilAnt                         ,Nil})
					aAdd(aCab,{"UA_NUM"         ,cNumOrc                         ,Nil})
					aAdd(aCab,{"UA_CLIENTE"     ,SA1->A1_COD                     ,Nil})
					aAdd(aCab,{"UA_LOJA"        ,SA1->A1_LOJA                    ,Nil})
					aAdd(aCab,{"UA_TIPOVND"     ,AllTrim(GetMv("MV_EDIPAR1",,"")),Nil})
					aAdd(aCab,{"UA_OPER"        ,"2"                             ,Nil})
					aAdd(aCab,{"UA_CONDPG"      ,AllTrim(GetMv("MV_EDIPAR2",,"")),Nil}) // Parametro
					aAdd(aCab,{"UA_BCO1"        ,"341"                           ,Nil})
					aAdd(aCab,{"UA_VEND"        ,AllTrim(GetMv("MV_EDIPAR3",,"")),Nil}) // Parametro
					aAdd(aCab,{"UA_TMK"         ,"1"                             ,Nil})
					aAdd(aCab,{"UA_OPERADO"     ,AllTrim(GetMv("MV_EDIPAR4",,"")),Nil}) // Parametro
					aAdd(aCab,{"UA_TABELA"      ,AllTrim(GetMv("MV_EDIPAR5",,"")),Nil}) // Parametro
					aAdd(aCab,{"UA_EMISSAO"     ,STOD(Substr(T_LINHA,049,008))   ,Nil})
					aAdd(aCab,{"UA_DTLIM"       ,STOD(Substr(T_LINHA,073,008))   ,Nil})
					aAdd(aCab,{"UA_PEDCLI"      ,Trim(Substr(T_LINHA,009,020))   ,Nil})
					aItn := {}
				Endif
			Endif

			Do While Left(T_LINHA,2) = "04" .AND. !eof()
				// Monta Itens
				aTmp:={}
				cSql := "SELECT A7_PRODUTO FROM "+RetSqlName("SA7")
				cSql += " WHERE D_E_L_E_T_ = ''"
				cSql += " AND   A7_FILIAL = ''"
				cSql += " AND   A7_CLIENTE = '"+SA1->A1_COD+"'"
				cSql += " AND   A7_CODCLI = '"+AllTrim(Substr(T_LINHA,018,014))+"'"
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)
				dbSelectArea("ARQ_SQL")
				cCodPro := A7_PRODUTO
				dbCloseArea()
				dbSelectArea("BUFFER")
				
				aAdd(aTmp,{"UB_FILIAL" ,cFilAnt                          ,Nil})
				aAdd(aTmp,{"UB_NUM"    ,cNumOrc                          ,NIL})
				aAdd(aTmp,{"UB_ITEM"   ,Substr(T_LINHA,005,002)          ,NIL})
				aAdd(aTmp,{"UB_PRODUTO",cCodPro                          ,NIL})
				aAdd(aTmp,{"UB_QUANT"  ,Val(Substr(T_LINHA,100,015))/100 ,NIL})
				aAdd(aTmp,{"UB_VRUNIT" ,Val(Substr(T_LINHA,198,015))/100 ,NIL})
				aAdd(aTmp,{"UB_DESC"   ,0                                ,NIL})
				aAdd(aTmp,{"UB_VALDESC",0                                ,NIL})
				aAdd(aTmp,{"UB_OPER"   ,"01"                             ,NIL})
				aAdd(aItn,aClone(aTmp))

				// Carrega proxima linha
				dbSkip()
			Enddo

			if Left(T_LINHA,2) = "09"
				// Chama Rotina Auto
				MSExecAuto({|w,x,y,z| TMKA271(w,x,y,z)},aCab,aItn,3,"2")
				If lMsErroAuto
					MostraErro("\SYSTEM","MERCADOR.LOG")
					RollBackSx8()
					aAdd(aRelato,{" - ",Trim(Substr(BUFFER->T_LINHA,009,020)),"*** Erro ***",aDir[jj,1],"."})
					U_DVEDI06(,,.T.)
				Else
					ConfirmSx8()
					aAdd(aRelato,{cNumOrc,Trim(Substr(BUFFER->T_LINHA,009,020)),"Orçamento",aDir[jj,1],"."})
				Endif
			Endif

			dbSelectArea("BUFFER")
			dbSkip()
		Enddo

		// Tratar arquivo Lido
		fClose(nHdl)
		cDest := "\mercador\entrada\lidos\"+aDir[jj,1]
		Copy File &cFile TO &cDest
		fErase(cFile)
	Next

	dbSelectArea("BUFFER")
	dbCloseArea()
	fErase(cTmp+GetDBExtension())

	U_DVEDI06(aRelato,1)
Return nil

Static Function LoadBuffer()
	dbSelectArea("BUFFER")
	Zap
	Append From &cFile SDF
Return