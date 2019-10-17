#include "Dellavia.ch"

User Function DVLOJA06
	Private cTabela   := "ZX9"
	Private cCadastro := ""
	Private aRotina   := {}

	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(cTabela)
	cCadastro := Capital(AllTrim(X2_NOME))
	dbSelectArea(cTabela)
	
	AADD(aRotina,{"Pesquisar" ,"AxPesqui"  ,0,1})
	AADD(aRotina,{"Visualizar","AxVisual"  ,0,2})
	AADD(aRotina,{"Incluir"   ,"AxInclui"  ,0,3})
	AADD(aRotina,{"Alterar"   ,"AxAltera"  ,0,4})
	AADD(aRotina,{"Excluir"   ,"AxDeleta"  ,0,5})
	AADD(aRotina,{"Gerar"     ,"U_DVLJA06X",0,3})

	MBrowse(,,,,cTabela)
Return nil

User Function DVLJA06X()
	Local   cVar     := Nil
	Local   oDlg     := Nil
	Local   cTitulo  := "Dias Uteis"

	Private oOk      := LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
	Private oNo      := LoadBitmap( GetResources(), "LBNO" )   //UNCHECKED  //LBNO
	Private oVerde   := LoadBitmap( GetResources(), "ENABLE")
	Private oVermelho:= LoadBitmap( GetResources(), "DISABLE")

	Private lUtil    := .F.
	Private lMark    := .F.
	Private oLbx     := Nil
	Private aSemana  := {"Domingo","Segunda-feria","Terça-feria","Quarta-Feira","Quinta-feira","Sexta-feira","Sábado"}
	Private aVetor   := {}
	Private cVarFil  := Space(2)
	Private cVarArea := Space(1)
	Private cVarAno  := Space(6)

	aAdd(aVetor,{.T.,.F.,CTOD("//"),""})

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 250,500 PIXEL
		@ 003,010 Say "Filial:" Pixel
		@ 002,030 Get cVarFil SIZE 10,7 Pixel Valid !Empty(cVarFil)

		@ 003,070 Say "Area Neg.:" Pixel
		@ 002,100 Get cVarArea SIZE 10,7 Pixel Valid !Empty(cVarArea)

		@ 003,140 Say "Ano/Mes (AAAAMM):" Pixel
		@ 002,200 Get cVarAno SIZE 20,7 Pixel Picture "999999" Valid Len(AllTrim(cVarAno)) = 6 .AND. MontaVetor("200702")

		@ 15,10 LISTBOX oLbx VAR cVar FIELDS HEADER " "," ","Data","Dia da semana" SIZE 230,095 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,2] := !aVetor[oLbx:nAt,2],oLbx:Refresh())
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oVerde,oVermelho),Iif(aVetor[oLbx:nAt,2],oOk,oNo),aVetor[oLbx:nAt,3],aVetor[oLbx:nAt,4]}}
		DEFINE SBUTTON FROM 112,183 TYPE 1 ACTION MsgRun("Gravando ...",,{|| Gravar() }) ENABLE OF oDlg
		DEFINE SBUTTON FROM 112,213 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
Return

Static Function MontaVetor(cAno_Mes)
	Local dDataIni := STOD(cAno_Mes+"01")

	aVetor := {}

	While Month(dDataIni) = Month(STOD(cAno_Mes+"01"))
		lMark := lUtil := (DOW(dDataIni) <> 1)

		aAdd(aVetor,{ lUtil, lMark, dDataIni, aSemana[DOW(dDataIni)] })
		dDataIni := dDataIni + 1
	End

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oVerde,oVermelho),Iif(aVetor[oLbx:nAt,2],oOk,oNo),aVetor[oLbx:nAt,3],aVetor[oLbx:nAt,4]}}

	oLbx:Refresh()
Return .T.

Static Function Gravar()
	For k=1 to Len(aVetor)
		If aVetor[k,2]
			dbSelectArea("ZX9")
			dbSetOrder(1)
			dbSeek(cVarFil+cVarArea+DTOS(aVetor[k,3]))

			If !Found()
				If RecLock("ZX9",.T.)
					ZX9->ZX9_FILIAL := cVarFil
					ZX9->ZX9_AREANE := cVarArea
					ZX9->ZX9_ANOMES := Substr(DTOS(aVetor[k,3]),1,6)
					ZX9->ZX9_DIA    := Substr(DTOS(aVetor[k,3]),7,2)
					MsUnLock()
				Endif
			Endif
		Endif
	Next k
Return nil