#include "rwmake.ch"
#include "topconn.ch"

User Function F3SA1
	Private cNome   := Space(30)
	Private cResult := ""
	Private cSql    := ""
	Private cNomTmp := ""
	Private aCampos := {}
	Private aEstru  := {}
	Private aItens  := {"Codigo","Nome","CNPJ"}
	Private cCombo  := aItens[1]
	Private lRet    := .F.

	aCampos :={}
	aadd(aCampos,{"A1_COD" ,"Codigo"    ,"@!"})
	aadd(aCampos,{"A1_NOME","Nome"      ,"@!"})
	aadd(aCampos,{"A1_CGC" ,"Cnpj / Cpf","@!"})

	cSql := "SELECT A1_COD,A1_NOME,A1_CGC FROM "+RetSqlName("SA1")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND   A1_COD BETWEEN '' AND '000ZZZ'"
	cSql += " ORDER BY A1_COD"
	
	cSql := ChangeQuery(cSql)
	MsgRun("Consultando banco de dados...",,{ || dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"ARQ_SQL",.F.,.T.)})

	dbSelectArea("ARQ_SQL")
	aEstru := dbStruct()

	MsgRun("Criando temporário...",,{ || CriaTmp() })
	MsgRun("Montando consulta..." ,,{ || LoadTmp() })

	dbSelectArea("TMP")
	dbSetOrder(1)
	cResult := AllTrim(Str(LastRec()))+" Registros"
	dbGoTop()

	@ 000,000 TO 390,515 DIALOG oDlgF3 TITLE "Cliente"
	@ 003,003 ComboBox cCombo ITEMS aItens SIZE 210,30 OBJECT oCombo
	@ 017,003 Get cNome OBJECT oNome SIZE 210,30
	@ 003,215 BUTTON "_Pesquisar" SIZE 40,11 ACTION MsgRun("Montando consulta...",,{ || TstChg() })
	@ 030,003 Say cResult OBJECT oResult
	@ 042,000 TO 165,259 BROWSE "TMP" Object oBrw1 FIELDS aCampos
	@ 175,003 BMPBUTTON TYPE 1  ACTION Confirm()
	@ 175,033 BMPBUTTON TYPE 2  ACTION Close(oDlgF3)
	@ 175,063 BMPBUTTON TYPE 15 ACTION VerCli()

	oNome:bChange  := {|| MsgRun("Montando consulta...",,{|| TstChg()    }) }
	oCombo:bChange := {|| MsgRun("Montando consulta...",,{|| MudaChave() }) }
	ACTIVATE DIALOG oDlgF3 CENTERED

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtencion())
	fErase(cNomTmp+OrdBagExt())
Return lRet

Static Function TstChg
	cNome := Upper(AllTrim(cNome))

	If AllTrim(cCombo) <> "Nome"
		If AllTrim(cCombo) = "Codigo"
			dbSetOrder(1)
		Elseif AllTrim(cCombo) = "CNPJ"
			dbSetOrder(3)
		Endif
		dbGoTop()
		dbSeek(cNome,.T.)
	Else
		dbSelectArea("TMP")
		dbCloseArea()
		fErase(cNomTmp+GetDbExtencion())
		fErase(cNomTmp+OrdBagExt())

		CriaTmp()

		cSql := "SELECT A1_COD,A1_NOME,A1_CGC FROM "+RetSqlName("SA1")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += " AND   A1_COD BETWEEN '' AND '000ZZZ'"
		If Len(cNome) > 0
			cSql += " AND   A1_NOME LIKE '%"+cNome+"%'"
		Endif
		cSql += " ORDER BY A1_COD"

		cSql := ChangeQuery(cSql)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"ARQ_SQL",.F.,.T.)
		LoadTmp()
		dbSelectArea("TMP")
		cResult := AllTrim(Str(LastRec()))+" Registros"
		dbGoTop()

		oResult:cCaption := cResult
	Endif

	cNome := cNome + Space(30-Len(cNome))
	oBrw1:oBrowse:Refresh(.T.)
Return

Static Function LoadTmp()
	dbSelectArea("ARQ_SQL")
	dbGoTop()

	Do While !eof()
		dbSelectArea("TMP")
		If RecLock("TMP",.T.)
			For k=1 to Len(aEstru)
				FieldPut(k,ARQ_SQL->(FieldGet(k)))
			Next
			MsUnlock()
		Endif
		dbSelectArea("ARQ_SQL")
		dbSkip()
	Enddo

	dbSelectArea("ARQ_SQL")
	dbCloseArea()
Return

Static Function MudaChave()
	dbSelectArea("TMP")
	
	If AllTrim(cCombo) <> "Nome"
		dbSelectArea("TMP")
		dbCloseArea()
		fErase(cNomTmp+GetDbExtencion())
		fErase(cNomTmp+OrdBagExt())

		CriaTmp()

		cSql := "SELECT A1_COD,A1_NOME,A1_CGC FROM "+RetSqlName("SA1")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += " AND   A1_COD BETWEEN '' AND '000ZZZ'"
		cSql += " ORDER BY A1_COD"
	
		cSql := ChangeQuery(cSql)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"ARQ_SQL",.F.,.T.)
		LoadTmp()
		dbSelectArea("TMP")
		cResult := AllTrim(Str(LastRec()))+" Registros"
		dbGoTop()

		oResult:cCaption := cResult

		If AllTrim(cCombo) = "Codigo"
			dbSetOrder(1)
		Elseif AllTrim(cCombo) = "CNPJ"
			dbSetOrder(3)
		Endif
	Else
		dbSetOrder(2)
	Endif
	
	oBrw1:oBrowse:Refresh(.t.)
Return

Static Function VerCli
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+TMP->A1_COD)
	If Found()
		cCadastro := "Clientes - Visual"
		AxVisual("SA1",Recno(),2)
	Endif
	dbSelectArea("TMP")
Return

Static function Confirm()
	lRet := .T.
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+TMP->A1_COD)
	Close(oDlgF3)
Return

Static function CriaTmp()
	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	Index on A1_COD  TAG IND1 TO &cNomTmp
	Index on A1_NOME TAG IND2 TO &cNomTmp
	Index on A1_CGC  TAG IND3 TO &cNomTmp
Return