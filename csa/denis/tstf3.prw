#include "rwmake.ch"
#include "topconn.ch"

User Function F3SA1
	Private cNome   := Space(30)
	Private cResult := ""
	Private cDesc   := Space(30)
	Private cSql    := ""
	Private cNomTmp := ""
	Private aCampos := {}
	Private aEstru  := {}
	Private aItens  := {"Codigo","Nome"}
	Private cCombo  := aItens[1]

	aCampos :={}
	aadd(aCampos,{"A1_COD" ,"Codigo"  ,"@!"})
	aadd(aCampos,{"A1_NOME","Nome"    ,"@!"})

	cSql := "SELECT A1_COD,A1_NOME FROM "+RetSqlName("SA1")
	cSql += " WHERE D_E_L_E_T_ = ''"
	cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
	cSql += " AND   A1_COD BETWEEN '' AND '000ZZZ'"
	cSql += " ORDER BY A1_COD"
	
	cSql := ChangeQuery(cSql)
	MsgRun("Consultando banco de dados...",,{ || dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"ARQ_SQL",.F.,.T.)})

	dbSelectArea("ARQ_SQL")
	aEstru := dbStruct()

	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	Index on A1_COD  TAG IND1 TO &cNomTmp
	Index on A1_NOME TAG IND2 TO &cNomTmp
	MsgRun("Montando consulta...",,{ || LoadTmp() })

	dbSelectArea("TMP")
	dbSetOrder(1)
	cResult := AllTrim(Str(LastRec()))+" Registros"
	dbGoTop()

	@ 000,000 TO 390,515 DIALOG oDlgF3 TITLE "Cliente"
	@ 003,003 ComboBox cCombo ITEMS aItens SIZE 210,30 OBJECT oCombo
	@ 017,003 Get cNome OBJECT oNome SIZE 210,30
	@ 003,215 BUTTON "_Pesquisar" SIZE 40,11 ACTION TstChg()
	@ 030,003 Say cResult OBJECT oResult
	@ 042,000 TO 165,259 BROWSE "TMP" Object oBrw1 FIELDS aCampos
	@ 175,003 BMPBUTTON TYPE 1  ACTION Confirm()
	@ 175,033 BMPBUTTON TYPE 2  ACTION Close(oDlgF3)
	@ 175,063 BMPBUTTON TYPE 15 ACTION VerCli()

	oNome:bChange := {|| TstChg() }
	oCombo:bChange := {|| MudaChave() }
	ACTIVATE DIALOG oDlgF3 CENTERED

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDbExtencion())
	fErase(cNomTmp+OrdBagExt())
Return

Static Function TstChg
	cNome := Upper(AllTrim(cNome))

	If AllTrim(cCombo) = "Codigo"
		dbSetOrder(1)
		dbGoTop()
		dbSeek(cNome,.T.)
	Else
		dbSelectArea("TMP")
		dbCloseArea()
		fErase(cNomTmp+GetDbExtencion())
		fErase(cNomTmp+OrdBagExt())

		cNomTmp := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
		Index on A1_COD  TAG IND1 TO &cNomTmp
		Index on A1_NOME TAG IND2 TO &cNomTmp

		cSql := "SELECT A1_COD,A1_NOME FROM "+RetSqlName("SA1")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += " AND   A1_COD BETWEEN '' AND '000ZZZ'"
		If Len(cNome) > 0 .AND. AllTrim(cCombo) = "Nome"
			cSql += " AND   A1_NOME LIKE '%"+cNome+"%'"
		Endif
		cSql += " ORDER BY A1_COD"

		cSql := ChangeQuery(cSql)
		MsgRun("Consultando banco de dados...",,{ || dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"ARQ_SQL",.F.,.T.)})
		MsgRun("Montando consulta...",,{ || LoadTmp() })
		dbSelectArea("TMP")
		cResult := AllTrim(Str(LastRec()))+" Registros"
		dbGoTop()

		oResult:Hide()
		@ 030,003 Say cResult OBJECT oResult
	Endif

	cNome := cNome + Space(30-Len(cNome))
	oBrw1:oBrowse:Refresh(.t.)
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
	
	If AllTrim(cCombo) = "Codigo"
		dbSelectArea("TMP")
		dbCloseArea()
		fErase(cNomTmp+GetDbExtencion())
		fErase(cNomTmp+OrdBagExt())

		cNomTmp := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
		Index on A1_COD  TAG IND1 TO &cNomTmp
		Index on A1_NOME TAG IND2 TO &cNomTmp

		cSql := "SELECT A1_COD,A1_NOME FROM "+RetSqlName("SA1")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   A1_FILIAL = '"+xFilial("SA1")+"'"
		cSql += " AND   A1_COD BETWEEN '' AND '000ZZZ'"
		cSql += " ORDER BY A1_COD"
	
		cSql := ChangeQuery(cSql)
		MsgRun("Consultando banco de dados...",,{ || dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"ARQ_SQL",.F.,.T.)})
		MsgRun("Montando consulta...",,{ || LoadTmp() })
		dbSelectArea("TMP")
		cResult := AllTrim(Str(LastRec()))+" Registros"
		dbGoTop()

		oResult:Hide()
		@ 030,003 Say cResult OBJECT oResult

		dbSetOrder(1)
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
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+TMP->A1_COD)
	Close(oDlgF3)
Return