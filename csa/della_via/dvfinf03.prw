#include "Dellavia.ch"

User Function DVFINF03(lPar)
	Private Titulo      := "Atualiza Premio ZX1"
	Private aSays       := {}
	Private aButtons    := {}
	Private lAuto       := .F.	
	Default lPar        := .F.

	lAuto := lPar

	if !lAuto
		aAdd(aSays,"Esta rotina faz a leitura de um arquivo TXT e faz a atualização do premio")
		aAdd(aSays,"na tabela ZX1.")

		aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Import() },Titulo,,.t.)  }})
		aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

		FormBatch(Titulo,aSays,aButtons)
	Else
		Import()
	Endif
Return nil

Static Function Import
	Local aEstru := {}
	Local nConta := 0

	If !lAuto
		FechaBatch()
	Endif

	aAdd(aEstru,{"T_LOJA"  ,"C",02,0})
	aAdd(aEstru,{"T_MES"   ,"C",06,0})
	aAdd(aEstru,{"T_AREANE","C",01,0})
	aAdd(aEstru,{"T_PREMIO","N",05,2})
	cNomTmp := CriaTrab(aEstru,.T.)
	dbUseArea(.T.,,cNomTmp,"ARQ_TXT",.F.,.F.)

	Append From \ZX1\ZX1PREMIO.TXT SDF

	If !lAuto
		ProcRegua(LastRec())
	Endif
	dbGotop()

	Do While !eof()
		If !lAuto
			incProc()
		Endif
		
		cSql := "UPDATE "+RetSqlName("ZX1")
		cSql += " SET  ZX1_PREMIO = "+AllTrim(Str(T_PREMIO))
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   ZX1_FILIAL = '"+xFilial("ZX1")+"'"
		cSql += " AND   ZX1_LOJA   = '"+T_LOJA+"'"
		cSql += " AND   ZX1_AREANE = '"+T_AREANE+"'"
		cSql += " AND   ZX1_MES    = '"+T_MES+"'"

		nUpdt := 0
		nUpdt := TcSqlExec(cSql)

		If nUpdt < 0
			if !lAuto
				MsgBox(TcSqlError(),"ZX1","STOP")
			Endif
		Else
			nConta++
		Endif
		
		dbSkip()
	Enddo
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())

	if !lAuto
		msgbox(AllTrim(Str(nConta))+" registro(s) atualizado(s)","ZX1","INFO")
	Endif
Return nil