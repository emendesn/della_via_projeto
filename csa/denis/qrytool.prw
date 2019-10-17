#include "Qrytool.ch"

/*
Programa...: QRYTOOL()
Autor......: Denis Francisco Tofoli
Descrição..: Este programa tem como utilidade excutar consultar no formato de query's
             podendo gerar relatorio, salvar em DBF ou TXT.
Data.......: 
*/

User Function QryTool()
	Local   oFontMemo := TFont():New( "Courier New", 7, 15 )  
	Local   cDriver := ""
	Private oDlg1
	Private oBrw
	Private oResult
	Private lErro   := .F.
	Private cQuery  := ""
	Private cAlias  := ""
	Private cResult := ""
	Private aCampos := {}
	Private aEstru  := {}
	Private cNomTmp := ""
	Private cNomArq := ""

	RddSetDefault("DBFCDX")
	cDriver := dbSetDriver("DBFCDX")

	SetKey(116,{|| ExecQry() })
	SetKey(117,{|| Imprime() })
	SetKey(121,{|| Salvar()  })

	@ 000,000 TO 600,805 DIALOG oDlg1 TITLE "Query Tools"
	@ 005,005 TO 095,320
	//@ 010,010 Get cQuery Size 305,080 MEMO Object oMemo1
	@ 010,010 MEMO cQuery Object oMemo1 Size 305,080 Pixel Font oFontMemo
	@ 005,325 TO 095,400
	@ 015,350 BMPBUTTON TYPE 15 ACTION ExecQry()
	@ 030,350 BMPBUTTON TYPE  2 ACTION Close(oDlg1)
	@ 045,350 BMPBUTTON TYPE  6 ACTION Imprime()
	@ 060,350 BMPBUTTON TYPE 13 ACTION Salvar()
	@ 280,005 TO 295,400
	@ 285,010 SAY "" OBJECT oResult
	@ 285,280 SAY "F5 = Executar      F6 = Imprimir      F10 = Salvar"
	ACTIVATE DIALOG oDlg1 CENTERED

	If Len(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()
	Endif

	RddSetDefault(cDriver)
	dbSetDriver(cDriver)
Return nil

Static Function ExecQry()
	If Len(AllTrim(cQuery)) <= 0
		Return nil
	Endif
	lErro := .F.
	CursorWait()
	if Len(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()
		fErase(cNomTmp+GetDbExtencion())
		oBrw:oBrowse:Hide()
	Else
		cAlias := "TMP_SQL"
	Endif
	bErrorSql := {|oErrQry| ErroQry(oErrQry)}	
	bLastHandler := ERRORBLOCK(bErrorSql)
	MsgRun("Consultando Banco de dados ...",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)})
	ERRORBLOCK(bLastHandler)

	dbSelectArea(cAlias)
	aCampos   := {}
	aEstru    := dbStruct()
	dbSelectArea("SX3")
	dbSetOrder(2)
	For k=1 to Len(aEstru)
		If !(allTrim(aEstru[k,1]) $ "R_E_C_N_O_//D_E_L_E_T_//R_E_C_D_E_L_")
			if dbSeek(allTrim(aEstru[k,1]),.F.)
				aadd(aCampos,{aEstru[k,1],X3_TITULO,X3_PICTURE})
			Else
				aadd(aCampos,{aEstru[k,1],aEstru[k,1],""})
			Endif
		Endif
	Next
	dbSelectArea(cAlias)

	If !lErro
		dbSelectArea(cAlias)
		MsgRun("Criando consulta ...",,{|| Campos()})

		aNewEstru := {}
		aOldEstru := dbStruct()

		For k=1 to Len(aOldEstru)
			If !(allTrim(aOldEstru[k,1]) $ "R_E_C_N_O_//D_E_L_E_T_//R_E_C_D_E_L_")
				aadd(aNewEstru,{aOldEstru[k,1],aOldEstru[k,2],aOldEstru[k,3],aOldEstru[k,4]})
			Endif
		Next

		MsgRun("Criando consulta ...",,{|| Copiar()})
	Endif

	dbSelectArea(cAlias)
	cResult := AllTrim(Str(LastRec())) + iif(LastRec()=1," registro"," registros")
	dbGoTop()
	@ 100,005 TO 275,400 BROWSE cAlias FIELDS aCampos OBJECT oBrw
	oResult:Hide()
	@ 285,010 SAY cResult OBJECT oResult
	CursorArrow()
	oBrw:oBrowse:SetFocus()
	oDlg1:Refresh()
Return nil


Static Function Copiar()
	cNomArq := CriaTrab(NIL,.F.)
	cNomTmp := CriaTrab(aNewEstru,.T.)

	Copy To &cNomArq
	dbCloseArea()

	dbUseArea(.T.,,cNomTmp,cAlias,.F.,.F.)
	Append From &cNomArq

	fErase(cNomArq+GetDbExtencion())
Return nil


Static Function Imprime()
	If Len(cAlias) <= 0
		msgbox("Voce deve primeiro realizar a consulta","Query Tool","INFO")
		Return nil
	Endif
	Private cString        := cAlias
	Private aOrd           := {}
	Private CbTxt          := ""
	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := "Relatorio de saldos em estoque sintetico"
	Private cPict          := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 220
	Private tamanho        := "G"
	Private nomeprog       := "QRYTOOL"
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "QRYTOOL"
	Private titulo         := "Listagem - Query Tools"
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private cbtxt          := Space(10)
	Private cbcont         := 00
	Private CONTFL         := 01
	Private m_pag          := 01
	Private imprime        := .T.
	Private wnrel          := "QRYTOOL"
	Private lImp           := .f.

	wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	If nLastKey == 27
	   Return
	Endif
	SetDefault(aReturn,cString)
	Processa({|| ImpRel() },Titulo,,.t.)
Return nil

Static Function ImpRel()
	Cabec1 := ""
	dbSelectArea(cAlias)
	nRec := Recno()
	ProcRegua(LastRec())
	dbGoTop()
	If !eof()
		For k=1 to Len(aCampos)
			Cabec1 := Cabec1 + aCampos[k,2]
			nLen := aEstru[k,3]
			If nLen > Len(aCampos[k,2])
				Cabec1 := Cabec1 + Space((nLen-Len(aCampos[k,2]))+3)
			Else
				Cabec1 := Cabec1 + Space(3)
			Endif
		Next
		Tamanho := "G"
		If Len(Cabec1) < 80
			Tamanho := "P"
		Elseif Len(Cabec1) < 132
			Tamanho := "M"
		Endif
		AllTrim(Cabec1)
	Endif
	Do While !Eof()
		lImp:=.t.
		incProc("Imprimindo ...")
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI:=LI+1
		endif
		nCol := 0
		For k=1 to len(aCampos)
			If nCol < 220
				@ LI,nCol PSAY FieldGet(FieldPos(aCampos[k,1])) Picture aCampos[k,3]
				nLen := aEstru[k,3]
				If nLen > Len(aCampos[k,2])
					nCol := nCol + nLen + 3
				Else
					nCol := nCol + Len(aCampos[k,2]) + 3
				Endif
			Endif
		Next
		Li++
		dbSkip()
	Enddo

	if lImp
		li++
		@ li,000 PSAY AllTrim(Str(Lastrec())) + " Registros impresso"
		roda(0,"",Tamanho)
	endif
	If aReturn[5]==1
	   dbCommitAll()
	   OurSpool(wnrel)
	Endif
	MS_FLUSH()
	Go nRec
Return nil

Static Function Salvar()
	Local cItem   := ""
	Local aItens  := {"Data Base File","Arquivo texto"}
	Local lCriar  := .F.
	Private cArq  := ""
	Private nOpc  := 0

	If Len(cAlias) <= 0
		msgbox("Voce deve primeiro realizar a consulta","Query Tool","INFO")
		Return nil
	Endif

	@ 000,000 TO 070,200 DIALOG oDlg2 TITLE "Salvar"
	@ 010,005 COMBOBOX cItem ITEMS aItens SIZE 50,10
	@ 010,070 BMPBUTTON TYPE 1 ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTERED
	
	If Substr(cItem,1,1) = "D"
		nOpc := 1
	Else
		nOpc := 2
	Endif

	cArq := cGetFile(iif(nOpc=1,"Data Base File|*.DBF","Arquivos Texto|*.TXT|Todos os Arquivos|*.*"),"Salvar Arquivo Como...",,,.T.,0)
	If !Empty(cArq)
		If File(cArq)
			lCriar := msgbox("Deseja substituir o arquivo "+cArq,"Salvar Como","YESNO")
		Else
			lCriar := .T.
		Endif
	Endif
	if lCriar
		dbSelectArea(cAlias)
		MsgRun("Salvando consulta ...",,{|| Gravar()})
		dbGoTop()
	Endif
Return nil

Static Function Gravar()
	If nOpc = 1
		Copy to &cArq
	Else
		Copy to &cArq SDF
	Endif
Return nil

Static Function ErroQry(oErrQry)
	aEstru  :=  {}
	aadd(aEstru,{"ERRO","C",50,0})
	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,cAlias,.F.,.F.)
	dbSelectArea(cAlias)
	cGravaErro:= ""
	nCont:=0
	For k=1 To Len(oErrQry:Description) + 1
		If Asc(Substr(oErrQry:Description,k,1)) = 13 .OR. nCont = 50 .OR. k = Len(oErrQry:Description) + 1
			RecLock(cAlias,.T.)
			(cAlias)->ERRO := cGravaErro
			MsUnlock()
			nCont:=0
			cGravaErro := ""
			If asc(Substr(oErrQry:Description,k,1))<>13 .AND. asc(Substr(oErrQry:Description,k,1))<>10 .AND. asc(Substr(oErrQry:Description,k,1))<>32
				cGravaErro := Substr(oErrQry:Description,k,1)
				nCont++
			Endif
		Else
			If asc(Substr(oErrQry:Description,k,1))<>10 .AND. asc(Substr(oErrQry:Description,k,1))<>32
				cGravaErro := cGravaErro + Substr(oErrQry:Description,k,1)
				nCont++
			Endif
			nCont++
		Endif
	Next
	lErro := .F.
Return nil

Static function Campos()
	dbSelectArea(cAlias)
	For i=1 to len(aEstru)
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek(aEstru[i,1])
		if Found()
			TcSetField(cAlias,X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL)
		Endif
	Next
	dbSelectArea(cAlias)
Return nil