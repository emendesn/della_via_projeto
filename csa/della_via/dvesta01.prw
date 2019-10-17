#include "rwmake.ch"
#include "topconn.ch"

User Function DVESTA01
	Private aRotina := {}
	Private nOpc    := 4
	Private aHeader := {}
	Private aCols   := {}
	Private aAlter  := {}
	Private aEstru  := {}

	aAdd(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	aAdd(aRotina,{"Visualizar","AxVisual",0,2})
	aAdd(aRotina,{"Incluir"   ,"AxInclui",0,3})
	aAdd(aRotina,{"Alterar"   ,"AxAltera",0,4})
	aAdd(aRotina,{"Excluir"   ,"AxExclui",0,5})

	// Monta estrutura do temporario
	aadd(aEstru,{"T_CURVA","C",01,0})
	aadd(aEstru,{"T_APERC" ,"N",06,2})
	aadd(aEstru,{"T_ADIAS" ,"N",03,0})
	aadd(aEstru,{"T_PPERC" ,"N",06,2})
	aadd(aEstru,{"T_PDIAS" ,"N",03,0})
	
	// Cria, abre, indexa temporario
	cNomTmp := CriaTrab(aEstru,.t.)
	dbUseArea(.T.,,cNomTmp,"TMP",.F.,.F.)
	IndRegua("TMP",cNomTmp,"T_CURVA",,.t.,"Selecionando Registros...")

	Do while .T.
		cSql := "SELECT X5_CHAVE,X5_DESCRI FROM "+RetSqlName("SX5")
		cSql += " WHERE D_E_L_E_T_ = ''"
		cSql += " AND   X5_FILIAL = '"+xFilial("SX5")+"'"
		cSql += " AND   X5_TABELA = 'X0'"
		cSql += " ORDER BY X5_CHAVE"

		MsgRun("Consultando Banco de dados ... ",,{|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),"ARQ_SQL", .T., .T.)})

		dbSelectArea("ARQ_SQL")
		dbGoTop()
		Do While !eof()
			nIni := 1
			nTmh := Len(AllTrim(ARQ_SQL->X5_DESCRI))
			nPos := AT(";",AllTrim(ARQ_SQL->X5_DESCRI))
			If RecLock("TMP",.T.)
				TMP->T_CURVA := AllTrim(ARQ_SQL->X5_CHAVE)
				TMP->T_APERC  := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

				nIni += nPos
				nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
				TMP->T_ADIAS  := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

				nIni += nPos
				nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
				TMP->T_PPERC  := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nPos-1))

				nIni += nPos
				nPos := AT(";",Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh))
				TMP->T_PDIAS  := Val(Substr(ARQ_SQL->X5_DESCRI,nIni,nTmh-(nIni-1)))
				MsUnLock()
			Endif
			dbSelectArea("ARQ_SQL")
			aAdd(aCols,{TMP->T_CURVA,TMP->T_APERC,TMP->T_ADIAS,TMP->T_PPERC,TMP->T_PDIAS,"",.F.})
			dbSkip()
		Enddo
		dbCloseArea()
		dbSelectArea("TMP")

		If Len(aCols) = 0
			dbSelectArea("SX5")
			For k=1 to 3
				If RecLock("SX5",.T.)
					SX5->X5_FILIAL  := Space(2)
					SX5->X5_TABELA  := "X0"
					SX5->X5_CHAVE   := Chr(k+64)
					SX5->X5_DESCRI  := "0;0;0;0"
					SX5->X5_DESCSPA := "0;0;0;0"
					SX5->X5_DESCENG := "0;0;0;0"
					MsUnlock()
				Endif
			Next k
			Loop
		Else
			Exit
		Endif
	Enddo

	aAdd(aHeader,{"Curva"      ,"T_CURVA" ,"!"        ,1,0,                                        ,,"C",,})
	aAdd(aHeader,{"Acess. Perc","T_APERC" ,"@e 999.99",6,2,"M->T_APERC > 0 .AND. M->T_APERC <= 100",,"N",,})
	aAdd(aHeader,{"Acess. Dias","T_ADIAS" ,"@e 999"   ,3,0,"M->T_ADIAS > 0"                        ,,"N",,})
	aAdd(aHeader,{"Pneus Perc" ,"T_PPERC" ,"@e 999.99",6,2,"M->T_PPERC > 0 .AND. M->T_PPERC <= 100",,"N",,})
	aAdd(aHeader,{"Pneus Dias" ,"T_PDIAS" ,"@e 999"   ,3,0,"M->T_PDIAS > 0"                        ,,"N",,})

	aAdd(aAlter,"T_APERC")
	aAdd(aAlter,"T_ADIAS")
	aAdd(aAlter,"T_PPERC")
	aAdd(aAlter,"T_PDIAS")

	DEFINE MSDIALOG oDlg FROM 000,000 TO 170,400 TITLE "Curva ABC / Ponto de pedido" Of oMainWnd PIXEL
    oGetDados := MSGetDados():New(5,3,65,200,nOpc,,,,.F.,aAlter,,,3)
	DEFINE SBUTTON FROM 070,140 TYPE 1 ACTION Gravar() ENABLE
	DEFINE SBUTTON FROM 070,170 TYPE 2 ACTION Close(oDlg) ENABLE
	ACTIVATE MSDIALOG oDlg CENTERED

	dbSelectArea("TMP")
	dbCloseArea()
	fErase(cNomTmp+GetDBExtension())
	fErase(cNomTmp+OrdBagExt())
Return nil

Static Function Gravar()
	nTot := 0
	For k=1 to Len(aCols)
		nTot += aCols[k,2] + aCols[k,4]
	Next k
	If nTot <> 200
		Help(" ",1,"TotPerc",,"A somatoria dos percentuais deve ser igual a 100",4,1)
		Return nil
	Endif


	For k=1 To Len(aCols)
		dbSelectArea("SX5")
		dbSeek(xFilial("SX5")+"X0"+aCols[k,1])
		If Found()
			If RecLock("SX5",.F.)
				SX5->X5_DESCRI  := AllTrim(Str(aCols[k,2]))+";"+AllTrim(Str(aCols[k,3]))+";"+AllTrim(Str(aCols[k,4]))+";"+AllTrim(Str(aCols[k,5]))
				SX5->X5_DESCSPA := AllTrim(Str(aCols[k,2]))+";"+AllTrim(Str(aCols[k,3]))+";"+AllTrim(Str(aCols[k,4]))+";"+AllTrim(Str(aCols[k,5]))
				SX5->X5_DESCENG := AllTrim(Str(aCols[k,2]))+";"+AllTrim(Str(aCols[k,3]))+";"+AllTrim(Str(aCols[k,4]))+";"+AllTrim(Str(aCols[k,5]))
				MsUnlock()
			Endif
		Endif
		dbSelectArea("TMP")
		dbSkip()
	Next k

	Close(oDlg)
Return nil