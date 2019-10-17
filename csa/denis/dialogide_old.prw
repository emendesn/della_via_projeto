#include "protheus.ch"
//---> INICIO DO CRIADOR DE TELAS PROTHEUS - EDSON

User Function DialogIDE()
	DIDE(oMainWnd)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MsMaker()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Construtor de Janelas Windows.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DIDE(oMainWnd)
	Local   oDlgW
	Local   oFontB  := TFont():New("MS Sans Serif",06,15)
	Local   nUsado  := 0
	Local   nCols   := 0
	Local   bHotArea
	Private	aCombo  := {"Combo 1","Combo 2","Combo 3"}
	Private oCombo
	Private cCombo  := ""
	Private cGet    := Space(100)
	Private aRotina := {{"PES","AxPesqui", 0 , 2},{"PES","AxPesqui", 0 , 2},{"PES","AxPesqui", 0 , 4},{"PES","AxPesqui", 0 , 4},{"PES","AxPesqui", 0 , 4}}
	Private aHeader := {}
	Private aCols   := {}
	Private oGetDados
	Private n       := 1
	Private lOk     := .F.
	Private cCombo1 := "Normal" 
	Private cAliasG	:= "SC6"
	Private cAliasE	:= "SC5"
	Private cOldG	:= "ZZ6"
	Private cOldE	:= "ZZ5"

	bHotArea := {|| HotAreas(if(lIntegracao,11,10),4,if(lIntegracao,18,17),75,nUsado) }

	IniaCols()

	DEFINE MSDIALOG oDlgW FROM 100,002 TO 400,110  TITLE "DialogIDE ADVPL 1.1" Of oMainWnd PIXEL
	oDlgW:lMaximized := .T.

    @ 002,001 TO 040,052 LABEL "Arquivo" OF oDlgW PIXEL
    @ 043,001 TO 120,052 LABEL "Objetos" OF oDlgW PIXEL
    @ 010,006 BUTTON "Novo"        SIZE 020,011 FONT oDlgW:oFont ACTION (NewWnd()) OF oDlgW PIXEL
    @ 010,028 BUTTON "Abrir"       SIZE 020,011 FONT oDlgW:oFont ACTION (MkOpe())  OF oDlgW PIXEL
    @ 024,006 BUTTON "Gerar ADVPL" SIZE 042,011 FONT oDlgW:oFont ACTION (Script())     When lOk OF oDlgW PIXEL
    @ 051,005 BUTTON "Label"       SIZE 021,008 FONT oDlgW:oFont ACTION (Label())      When lOk OF oDlgW PIXEL
    @ 051,027 BUTTON "Say"         SIZE 021,008 FONT oDlgW:oFont ACTION (MkSay())      When lOk OF oDlgW PIXEL
    @ 061,005 BUTTON "MsGet"       SIZE 021,008 FONT oDlgW:oFont ACTION (Mkget())      When lOk OF oDlgW PIXEL
    @ 061,027 BUTTON "MsButt"      SIZE 021,008 FONT oDlgW:oFont ACTION (MkBut())      When lOk OF oDlgW PIXEL
    @ 071,005 BUTTON "Button"      SIZE 021,008 FONT oDlgW:oFont ACTION (MkBut1())     When lOk OF oDlgW PIXEL
    @ 071,027 BUTTON "Combo"       SIZE 021,008 FONT oDlgW:oFont ACTION (MkCom())      When lOk OF oDlgW PIXEL
    @ 081,005 BUTTON "GetDad"      SIZE 021,008 FONT oDlgW:oFont ACTION (MkGetDados()) When lOk OF oDlgW PIXEL
    @ 081,027 BUTTON "MsMGet"      SIZE 021,008 FONT oDlgW:oFont ACTION (MkEnch())     When lOk OF oDlgW PIXEL
    @ 091,005 BUTTON "Sobre"       SIZE 021,008 FONT oDlgW:oFont ACTION (Info())       When lOk OF oDlgW PIXEL
    @ 121,001 TO 148,052 LABEL ""        OF oDlgW PIXEL
    @ 131,005 BUTTON "Editar"      SIZE 021,011 FONT oDlgW:oFont ACTION (EditObjs())   When lOk OF oDlgW PIXEL
    @ 131,027 BUTTON "Preview"     SIZE 021,011 FONT oDlgW:oFont ACTION (Preview())    When lOk OF oDlgW PIXEL

	ACTIVATE MSDIALOG oDlgW //ON INIT  oMainWnd:CoorsUpdate()
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ NewWnd() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa a nova area de trabalho.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NewWnd()
	Local nRow1
	Local nRow2
	Local nCol1
	Local nCol2
	Local aTmp
	Local cDriver   := __LocalDriver
	Local cArqWnd
	Local lConfirma := .F.
	Local aCampos	:= {}
	Local cFile	    := "NomeArq"
	Local cIndex    := CriaTrab(nil,.f.)
	Local cText	    := "Titulo da Dialog                    "
	Local aCombo    := {"Normal","Advanced","Maximizada","MDI"}

	DEFINE MSDIALOG oDlgPrw FROM 080,145 TO 245,350 TITLE "Nova Dialog" Of oMainWnd PIXEL

	@ 005,004 TO 058,101 LABEL "" OF oDlgPrw PIXEL
	@ 040,011 MSCOMBOBOX oCombo VAR cCombo1 ITEMS aCombo SIZE 082,050 OF oDlgPrw PIXEL
	@ 013,011 MSGET cFile VALID !Empty(cFile) SIZE 082,009 Of oDlgPrw PIXEL
	@ 027,011 MSGET cText VALID .T.           SIZE 082,009 Of oDlgPrw PIXEL

	DEFINE SBUTTON FROM 065,038 TYPE 1 ACTION {|| lConfirma := .T.,oDlgPrw:End()}  ENABLE OF oDlgPrw
	DEFINE SBUTTON FROM 065,071 TYPE 2 ACTION {|| oDlgPrw:End()}                   ENABLE OF oDlgPrw

	ACTIVATE MSDIALOG oDlgPrw

	If lConfirma 
		AADD(aCampos,{ "SEQ","C",3,0 } )
		AADD(aCampos,{ "OBJECT","C",15,0 } )
		AADD(aCampos,{ "PARAM1","C",60,0 } ) // Nome do objeto
		AADD(aCampos,{ "PARAM2","C",03,0 } )
		AADD(aCampos,{ "PARAM3","C",03,0 } )
		AADD(aCampos,{ "PARAM4","C",03,0 } )
		AADD(aCampos,{ "PARAM5","C",03,0 } )
		AADD(aCampos,{ "PARAM6","C",03,0 } )
		AADD(aCampos,{ "PARAM7","C",03,0 } )
		AADD(aCampos,{ "PARAM8","C",03,0 } )

		If Select("WND") > 0
			dbSelectArea("WND")
			dbClearFilter()
			dbCloseArea()
		EndIf

		MaKeDIR("\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\")

		cFile := "\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\"+AllTrim(cFile) + ".MKM"

		If File(cFile)
			MsgAlert("O Arquivo selecionado ja existe no diretorio. Verifique o nome do arquivo !")
			Return
		EndIf

		dbCreate(cFile,aCampos,cDriver)
		dbUseArea( .T.,, cFile,"WND",.T.,.F.)
		IndRegua("WND",cIndex,"SEQ")

		lOk	:= .T.

		aTmp := EnterNew()
		nCol1:= aTmp[1]
		nRow1:= aTmp[2]

		aTmp := EnterNew()
		nCol2:= aTmp[1]
		nRow2:= aTmp[2]

		NewObject("MsDialog",cText,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2),cCombo1,"SC5","SC6")

		Preview()
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Preview() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta um preview do projeto atual.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Preview()
	Local oDlgPrw
	Local cType

	dbSelectArea("WND")
	dbGotop()
	cType	:= WND->PARAM6
	cAliasG := AllTrim(WND->PARAM7)
	cAliasE := AllTrim(WND->PARAM8)


	IniaCols(.T.)
	DEFINE MSDIALOG oDlgPrw FROM VAL(WND->PARAM2),VAL(WND->PARAM3) TO VAL(WND->PARAM4),VAL(WND->PARAM5) TITLE AllTrim(WND->PARAM1) Of oMainWnd PIXEL

	oPanel := TPanel():New(0,0,"",oDlgPrw, oDlgPrw:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	While !Eof()
		LoadObj(@oPanel,.F.)
		dbSelectArea("WND")
		dbSkip()
	End

	Do Case
		Case cType == "Nor"
			oDlgPrw:lMaximized := .F.
			ACTIVATE MSDIALOG oDlgPrw	
		Case cType == "Adv"
			oDlgPrw:lMaximized := .F.
			ACTIVATE MSDIALOG oDlgPrw ON INIT EnchoiceBar(oDlgPrw,{||oDlgPrw:End()},{||oDlgPrw:End()})	
		Case cType == "Max"
			oDlgPrw:lMaximized := .T.
			ACTIVATE MSDIALOG oDlgPrw
		Case cType == "Mdi"
			oDlgPrw:lMaximized := .T.
			ACTIVATE MSDIALOG oDlgPrw ON INIT EnchoiceBar(oDlgPrw,{||oDlgPrw:End()},{||oDlgPrw:End()})	
	EndCase
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Label()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta um label no projeto atual.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Label()
	Local oDlgPrw
	Local nRow1
	Local nRow2
	Local nCol1
	Local nCol2
	Local aTmp
	Local cText	:= SPACE(30)

	DEFINE MSDIALOG oDlgPrw FROM 112,145 TO 178,271 TITLE "Titulo do Label" Of oMainWnd PIXEL

	@ 1.5,002 to 029,061 Label "" OF oDlgPrw PIXEL
	@ 012,006 MSGET cText VALID oDlgPrw:End() SIZE 050,010 Of oDlgPrw PIXEL
	DEFINE SBUTTON FROM 10025,00118 TYPE 1 ACTION {|| oDlgPrw:End()}  ENABLE OF oDlgPrw

	ACTIVATE MSDIALOG oDlgPrw

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	aTmp := EnterPoint()
	nCol2:= Int(aTmp[1]/2)
	nRow2:= Int(aTmp[2]/2)

	NewObject("Label",cText,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2))

	Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³EnterPoint³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a leitura de um ponto no projeto atual.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnterPoint()
	Local nRetRow := 0
	Local nRetCol := 0
	Local oDlgP
	Local oPanel
	Local cType

	dbSelectArea("WND")
	dbGotop()
	cType := WND->PARAM6

	DEFINE MSDIALOG oDlgP FROM VAL(WND->PARAM2),VAL(WND->PARAM3) TO VAL(WND->PARAM4),VAL(WND->PARAM5) TITLE AllTrim(WND->PARAM1)+" - Marque o ponto ( Use o botão direito do mouse )" Of oMainWnd PIXEL

	oPanel       := TPanel():New(0,0,"",oDlgP, oDlgP:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	oPanel:bRClicked := {|o,x,y| (nRetCol:=x,nRetRow:=y,oDlgP:End()) }

	While !Eof()
		LoadObj(@oPanel,.F.)
		dbSelectArea("WND")
		dbSkip()
	End

	Do Case
		Case cType == "Nor"
			oDlgP:lMaximized := .F.
			ACTIVATE MSDIALOG oDlgP
		Case cType == "Adv"
			oDlgP:lMaximized := .F.
			ACTIVATE MSDIALOG oDlgP ON INIT EnchoiceBar(oDlgP,{||oDlgP:End()},{||oDlgP:End()})	
		Case cType == "Max"
			oDlgP:lMaximized := .T.
			ACTIVATE MSDIALOG oDlgP
		Case cType == "Mdi"
			oDlgP:lMaximized := .T.
			ACTIVATE MSDIALOG oDlgP ON INIT EnchoiceBar(oDlgP,{||oDlgP:End()},{||oDlgP:End()})	
	EndCase

	If Empty(nRetCol)  .OR. Empty(nRetRow)
		Return EnterPoint()	
	EndIf      
Return {nRetCol,nRetRow}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EnterNew ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a leitura de um ponto na Tela principal.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnterNew()
	Local nRetRow	:= 0
	Local nRetCol	:= 0
	Local oDlg

	DEFINE DIALOG oDlg FROM 000,000 TO 600,800 TITLE "oMainWnd - 800 x 600 - Marque o 1o e 2o ponto. ( Use o botão direito do mouse )" of oMainWnd PIXEL

	oPanel := TPanel():New(0,0,"",oDlg, oDlg:oFont, .T., .T.,, ,1245,0023,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	oPanel:bRClicked	:= {|o,x,y| (nRetCol:=x,nRetRow:=y,oDlg:End()) }

	ACTIVATE MSDIALOG oDlg CENTERED
Return	{nRetCol,nRetRow}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkSay()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto Say no projeto atual.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkSay()
	Local oDlgPrw
	Local nRow1
	Local nCol1
	Local nRow2
	Local nCol2
	Local aTmp
	Local cText	    := SPACE(60)
	Local lConfirma	:= .F.
	aRotina[1][4]   := 4

	DEFINE MSDIALOG oDlgPrw FROM 112,145 TO 178,271 TITLE "Objeto Say" Of oMainWnd PIXEL
	@ 1.5,002 to 029,061 Label "" OF oDlgPrw PIXEL
	@ 012,006 MSGET cText VALID .T. SIZE 050,010 Of oDlgPrw PIXEL
	DEFINE SBUTTON FROM 10025,00118  TYPE 1 ACTION {|| oDlgPrw:End()}  ENABLE OF oDlgPrw
	ACTIVATE MSDIALOG oDlgPrw

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)
	
	aTmp := EnterPoint()
	nCol2:=Int( aTmp[1]/2)
	nRow2:=Int( aTmp[2]/2)
	
	NewObject("Say",cText,STR(nRow1),STR(nCol1),STR(nCol2-nCol1),"9")
	
	Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkGet()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto MsGet no projeto atual.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkGet()
	Local oDlgPrw
	Local nRow1
	Local nCol1
	Local nRow2
	Local nCol2
	Local aTmp
	Local cText	:= "cVariavel"
	Local lOk := .T.
	aRotina[1][4] := 4

	DEFINE MSDIALOG oDlgPrw FROM 112,145 TO 178,271 TITLE "Objeto Get" Of oMainWnd PIXEL
	@ 1.5,002 to 029,061 Label "Variavel" OF oDlgPrw PIXEL
	@ 012,006 MSGET cText VALID .T. SIZE 050,010 Of oDlgPrw PIXEL
	DEFINE SBUTTON FROM 10025,00118  TYPE 1 ACTION {|| oDlgPrw:End()}  ENABLE OF oDlgPrw
	ACTIVATE MSDIALOG oDlgPrw

	If lOk
		GrvGet(cText)
	EndIf
Return

Static Function GrvGet(cText)
	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)
	aTmp := EnterPoint()
	nCol2:= Int(aTmp[1]/2)
	nRow2:= Int(aTmp[2]/2)

	NewObject("MsGet",AllTrim(cText),STR(nRow1),STR(nCol1),STR(nCol2-nCol1),"SA1")

	MsUnlock()
	Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³NewObject³ Autor ³ Edson Maricate        ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a gravacao do objeto no projeto atual.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    														    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NewObject(cObject,cParam1,cParam2,cParam3,cParam4,cParam5,cParam6,cParam7,cParam8)
	Local cSeqAtu

	dbSelectArea("WND")
	dbSeek("ZZZ")
	dbSkip(-1)
	cSeqAtu	:= WND->SEQ

	If Empty(cSeqAtu)
		cSeqAtu	:= "000"
	EndIf
	if RecLock("WND",.T.)
		WND->SEQ	:= SomaIt(cSeqAtu)
		WND->OBJECT	 := AllTrim(cObject)
		WND->PARAM1	 := Alltrim(cParam1)
		WND->PARAM2	 := Alltrim(cParam2)
		WND->PARAM3	 := Alltrim(cParam3)
		WND->PARAM4	 := Alltrim(cParam4)
		WND->PARAM5	 := Alltrim(cParam5)
		WND->PARAM6	 := Alltrim(cParam6)
		WND->PARAM7	 := Alltrim(cParam7)
		WND->PARAM8	 := Alltrim(cParam8)
		MsUnlock()
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ LoadObj ³ Autor ³ Edson Maricate        ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a leitura do objeto no arquivo posicionado.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    														    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LoadObj(oDlg,lScript)  
	cRet := ""

	Do Case
		Case WND->OBJECT = "Label"
			If lScript
				cRet := "   @ "+WND->PARAM2+","+WND->PARAM3+" TO "+WND->PARAM4+","+WND->PARAM5+" LABEL '"+Alltrim(WND->PARAM1)+"' OF oPanel PIXEL"
			Else
				@ VAL(WND->PARAM2),VAL(WND->PARAM3) TO VAL(WND->PARAM4),VAL(WND->PARAM5) Label Alltrim(WND->PARAM1) Of oDlg PIXEL
			EndIf
		Case WND->OBJECT = "Say"
			If lScript
				cRet	:= "   @ "+WND->PARAM2+","+WND->PARAM3+" SAY '"+AllTrim(WND->PARAM1)+"' Of oPanel PIXEL SIZE "+WND->PARAM4+","+WND->PARAM5
			Else
	         cTextSay:= "{||' "+AllTrim(WND->PARAM1)+" '}"
				oSay := TSay():New( VAL(WND->PARAM2),VAL(WND->PARAM3), MontaBlock(cTextSay) , oDlg , ,,,,,.T.,,,VAL(WND->PARAM4),VAL(WND->PARAM5))
			EndIf			
		Case WND->OBJECT = "MsGet"
			If lScript
				If !Empty(WND->PARAM5)
					cRet	:= "   @ "+WND->PARAM2+","+WND->PARAM3+" MSGET "+Alltrim(WND->PARAM1)+"  Picture PesqPicture('SA1','A1_CAMPO') F3 CpoRetF3('CAMPO');"+CHR(13)+CHR(10)+"               When VisualSX3('CAMPO') Valid CheckSX3('A1_CAMPO') ;"+chr(13)+chr(10)+"             .And. MontaF3('') OF oPanel PIXEL HASBUTTON SIZE "+ WND->PARAM4+ ",9"+CHR(13)+CHR(10)
				Else
					cRet	:= "   @ "+WND->PARAM2+","+WND->PARAM3+" MSGET "+Alltrim(WND->PARAM1)+"  Picture PesqPicture('SA1','A1_CAMPO') ;"+CHR(13)+CHR(10)+"                  When VisualSX3('CAMPO') Valid CheckSX3('A1_CAMPO') ;"+chr(13)+chr(10)+"             .And. MontaF3('') OF oPanel PIXEL SIZE "+ WND->PARAM4+ ",9"+CHR(13)+CHR(10)
				EndIf
			Else
				If !Empty(WND->PARAM5)
					@ VAL(WND->PARAM2),VAL(WND->PARAM3) MSGET cGet Picture "@"  Of oDlg PIXEL SIZE VAL(WND->PARAM4),9  F3 WND->PARAM5 HASBUTTON
				Else
					@ VAL(WND->PARAM2),VAL(WND->PARAM3) MSGET cGet Picture "@"  Of oDlg PIXEL SIZE VAL(WND->PARAM4),9 
				EndIf
			EndIf
		Case WND->OBJECT = "MsButton"
			If lScript
				cRet	:= "   DEFINE SBUTTON FROM "+WND->PARAM2+","+WND->PARAM3+" TYPE "+WND->PARAM4+" ACTION  ENABLE OF oPanel"
			Else
				DEFINE SBUTTON FROM VAL(WND->PARAM2),VAL(WND->PARAM3) TYPE VAL(WND->PARAM4) ACTION (MsgAlert("")) ENABLE OF oDlg
			EndIf		
		Case WND->OBJECT = "Button"
			If lScript
				cRet	:= "    @"+WND->PARAM2+","+WND->PARAM3+" BUTTON '"+Alltrim(WND->PARAM1)+"' SIZE "+WND->PARAM4+","+WND->PARAM5+" FONT oPanel:oFont ACTION (MsgAlert(''))  OF oPanel PIXEL "
			Else
				@ VAL(WND->PARAM2),VAL(WND->PARAM3) BUTTON Alltrim(WND->PARAM1) SIZE VAL(WND->PARAM4),VAL(WND->PARAM5) FONT oDlg:oFont ACTION (MsgAlert(""))  OF oDlg PIXEL 	
			EndIf
		Case WND->OBJECT = "MsComboBox"
			If lScript
				cRet	:= "    @"+	WND->PARAM2+","+WND->PARAM3+" MSCOMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE "+ WND->PARAM4+",50 OF oPanel PIXEL "
			Else
				@	VAL(WND->PARAM2),VAL(WND->PARAM3) MSCOMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE VAL(WND->PARAM4),50 OF oDlg PIXEL 
			EndIf		
		Case WND->OBJECT = "Ms-Getdados"
			If lScript
				cRet		:= "    oGetDados := MSGetDados():New("+AllTrim(WND->PARAM2)+","+AllTrim(WND->PARAM3)+","+AllTrim(WND->PARAM4)+","+AllTrim(WND->PARAM5)+",nOpc,'funcLinOk','funcTudok','+ITEM',.T.,,,,nMaxItens)"
			Else
				oGetDados := MSGetDados():New(VAL(WND->PARAM2),VAL(WND->PARAM3),VAL(WND->PARAM4),VAL(WND->PARAM5),2,".T.",".T.","",.F.)
			EndIf		
		Case WND->OBJECT = "Enchoice"
			If lScript
				cRet := "   oEnch := MsMGet():New('SA3',SA3->(RecNo()),1,,,,,{"+Alltrim(WND->PARAM2)+","+Alltrim(WND->PARAM3)+","+AllTrim(WND->PARAM4)+","+AllTrim(WND->PARAM5)+"},,3,,,,oPanel,,,,,,.T.)"
			Else
				oEnch := MsMGet():New("SA3",SA3->(RecNo()),1,,,,,{VAL(WND->PARAM2),VAL(WND->PARAM3),VAL(WND->PARAM4),VAL(WND->PARAM5)},,3,,,,oDlg,,,,,,.T.)
			EndIf
	EndCase
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkBut()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto Button no projeto.  .                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkBut()
	Local nRow1
	Local nCol1
	Local aTmp
	Local nType 

	nType := SeleBut()

	If nType > 0
		aTmp := EnterPoint()
		nCol1:= Int(aTmp[1]/2)
		nRow1:= Int(aTmp[2]/2)

		NewObject("MsButton","Type "+STR(nType),STR(nRow1),STR(nCol1),STR(nType))

		Preview()
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Script() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria um script com os comandos da tela.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Script()
	Local nHandle := 1
	Local cWrite  := ""
	Local cFile	  := "NomeArq "


	dbSelectArea("WND")
	dbGoTop()

	cWrite := "Local oDlg"+Chr(13)+Chr(10)
	cWrite += ""+Chr(13)+Chr(10)
	cType	:= WND->PARAM6
	cWrite += "DEFINE MSDIALOG oDlg FROM "+ WND->PARAM2 +","+WND->PARAM3+" TO "+WND->PARAM4+","+WND->PARAM5+" TITLE '"+AllTrim(WND->PARAM1)+"' Of oMainWnd PIXEL"+Chr(13)+Chr(10)
	cWrite += Chr(13)+Chr(10)
	cWrite += "oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,1245,0023,.T.,.T. )"+Chr(13)+Chr(10)
	cWrite += "oPanel:Align := CONTROL_ALIGN_ALLCLIENT"+Chr(13)+Chr(10)
	cWrite += Chr(13)+Chr(10)

	While !Eof()
		cWrite	+= LoadObj(,.T.)+Chr(13)+Chr(10)
		dbSelectArea("WND")
		dbSkip()
	End

	Do Case
		Case cType == "Nor"
			cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .F."
			cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg"
		Case cType == "Adv"
			cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .F."
			cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})	"

		Case cType == "Max"
			cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .T."
			cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg"
		Case cType == "Mdi"
			cWrite	+= CHR(13)+CHR(10) +"oDlg:lMaximized := .T."
			cWrite	+= CHR(13)+CHR(10) +"ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})	"
	EndCase

	cTexto := cWrite
	DEFINE FONT oFont NAME "Courier New" SIZE 6,13   //6,15
	DEFINE MSDIALOG oDlg TITLE "DialogIDE - Código ADVPL" From 3,0 to 540,617 PIXEL
	@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 300,245 OF oDlg PIXEL 
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	DEFINE SBUTTON  FROM 253,275 TYPE 1  ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	DEFINE SBUTTON  FROM 253,245 TYPE 13 ACTION (cFile:=cGetFile("Arquivos .PRT (*.PRT) |*.PRT|",""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."

	ACTIVATE MSDIALOG oDlg CENTER
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkBut1() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto Button no projeto.  .                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MkBut1()
	Local oDlg
	Local nRow1
	Local nCol1
	Local cText	:= SPACE(60)
	Local aSize := {" 5 x  5","15 x 10","20 x 10","25 x 11","35 x 11","50 x 11","70 x 11","90 x 15"}
	Local cSize	:= aSize[5]
	Local oSize
	Local nSize,nSize1,nSize2

	DEFINE MSDIALOG oDlg FROM 98 ,95  TO 207,262 TITLE "Button" Of oMainWnd PIXEL
	@ 6.5,3.5 TO 049,079 LABEL "Button" OF oDlg PIXEL
	@ 018,7.5 MSGET cText Picture "@" OF oDlg PIXEL SIZE 068,009
	@ 033,7.0 MSCOMBOBOX oSize VAR cSize ITEMS aSize SIZE 068,050 OF oDlg PIXEL
	DEFINE SBUTTON FROM 10025,0118 TYPE 1 ACTION {|| oDlg:End()}  ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg 

	nSize1 := Val(Substr(cSize,1,2))
	nSize2 := Val(Substr(cSize,6,2))

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	NewObject("Button",cText,STR(nRow1),STR(nCol1),STR(nSize1),STR(nSize2))

	Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³  MkOpe()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abre uma janela do disco.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MkOpe()
	Local cFile
	Local cIndex := CriaTrab(nil,.f.)
	Local aRet := {}
	Local ni
	Local aFiles := {}
	Local aDir := Directory("\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\"+"*.MKM")
	Local aParam := {{6,"Abrir",SPACE(254),,"FILE(mv_par01)","", 55 ,.F.,"Arquivo Dialog .MKM |*.MKM", "SERVIDOR\FONTESBX\"},{3,"Minhas Telas",0,{},60,,.F.}}

	For ni := 1 To Len(aDir)
		aAdd(aParam[2,4],aDir[ni][1])
		aAdd(aFiles,aDir[ni][1])
	Next

	MaKeDIR("\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\")

	If ParamBox(aParam,"Abrir Dialog",@aRet) 
		If !Empty(aRet[1])
			cFile := aRet[1]
		ElseIf !Empty(aRet[2])
			cFile := "\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\"+aFiles[aRet[2]]
		EndIf                         
	
		If !Empty(cFile)
			If Select("WND") > 0
				dbSelectArea("WND")
				dbClearFilter()
				dbCloseArea()
			EndIf
			dbUseArea( .T.,, cFile,"WND",.T.,.F.)
			IndRegua("WND",cIndex,"SEQ")
			lOk	:= .T.
			EditObjs()
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MkCom()  ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um objeto MsComboBox no projeto atual.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MkCom()
	Local nRow1
	Local nCol1
	Local nRow2
	Local nCol2
	Local aTmp

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)
	aTmp := EnterPoint()
	nCol2:= Int(aTmp[1]/2)
	nRow2:= Int(aTmp[2]/2)

	NewObject("MsComboBox",,STR(nRow1),STR(nCol1),STR(nCol2-nCol1))

	MsUnlock()
	Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³GetDados()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta uma getdados no projeto atual.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MkGetDados()
	Local nRow1
	Local nRow2
	Local nCol1
	Local nCol2
	Local aTmp

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	aTmp := EnterPoint()
	nCol2:= Int(aTmp[1]/2)
	nRow2:= Int(aTmp[2]/2)

	IniaCols()

	NewObject("Ms-Getdados",,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2))
	Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³GetDados()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta uma getdados no projeto atual.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MkEnch()
	Local nRow1
	Local nRow2
	Local nCol1
	Local nCol2
	Local aTmp

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	aTmp := EnterPoint()
	nCol2:= Int(aTmp[1]/2)
	nRow2:= Int(aTmp[2]/2)

	IniaCols()

	NewObject("Enchoice",,STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2))

	Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³IniaCols()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa o aCols utilizado na getdados.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IniaCols(lForce)
	Local ny
	Local ncols

	Local nUsado	:= 0            
	DEFAULT lForce := .F.

	If Empty(aCols) .Or. cOldE <> cAliasE .Or. cOldG <> cAliasG
		cOldE := cAliasE
		cOldG := cAliasG
		cAliasE := If(Empty(cAliasE),"SC6",cAliasE)
		cAliasG := If(Empty(cAliasG),"SC5",cAliasG)
		dbSelectArea(cAliasE)
		RegToMemory(cAliasE,.F.,,.F.)
	
		aCols := {}
		aHeader := {}
		dbSelectArea("SX3")
		dbSetOrder(1)
		If dbSeek(cAliasG)
			cAlias	:= cAliasG
		Else 
			cAlias := "SA1"
			cAliasG := "SA1"
		EndIf

		While !EOF() .And. (x3_arquivo == cAliasG)
			IF X3USO(x3_usado) .And. cNivel >= x3_nivel 
			   nUsado++
		 	   AADD(aHeader, {TRIM(x3_titulo),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
			Endif
			dbSkip()
		End

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a montagem de uma linha em branco no aCols.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ncols	:= 1 to 40
			aadd(aCols,Array(nUsado+1))
			For ny := 1 to Len(aHeader)
				If ( aHeader[ny][10] != "V")
					aCols[Len(aCols)][ny] := CriaVar(aHeader[ny][2],.F.)
				EndIf
				aCols[Len(aCols)][nUsado+1] := .F.
			Next ny
		Next
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³EditObjs()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EditObjs()
	Local oDlg
	Local oGet
	Local aHeadTMP	:= {}
	Local nAux
	Local aBack		
	Local nx

	Private nOpcAnt     := aRotina[1][4]
	Private nSavN       := n
	Private aSavHeader  := aHeader
	Private aSavCols    := aCols
	Private aHeader     := {}
	Private aCols       := {}

	aRotina[1][4] := 4

	aHeadTMP := {;
		{"","SEQ"   ,"No."     ,.F.,".T.","@!",03,0,"C"},;
		{"","OBJECT","Objeto"  ,.F.,".T.","@" ,10,0,"C"},;
		{"","NAME"  ,"Nome"    ,.F.,".T.","@" ,20,0,"C"},;
		{"","AXX"   ,"Param  1",.F.,".T.","@" ,03,0,"C"},;
		{"","BXX"   ,"Param  2",.T.,".T.","@" ,03,0,"C"},;
		{"","CXX"   ,"Param  3",.T.,".T.","@" ,03,0,"C"},;
		{"","DXX"   ,"Param  4",.T.,".T.","@" ,03,0,"C"},;
		{"","EXX"   ,"Param  5",.T.,".T.","@" ,03,0,"C"},;
		{"","FXX"   ,"Param  6",.T.,".T.","@" ,03,0,"C"},;
		{"","GXX"   ,"Param  7",.T.,".T.","@" ,03,0,"C"};
	}

	SX3->(dbSetOrder(2))
	SX3->(dbSeek("A1_COD"))

	For nx := 1 to Len(aHeadTmp)
		AADD(aHeader,{ TRIM(aHeadTmp[nx][3]),aHeadTmp[nx][2], aHeadTmp[nx][6],aHeadTmp[nx][7], aHeadTmp[nx][8], aHeadTmp[nx][5],SX3->X3_USADO, aHeadTmp[nx][9], "", "" } )
		dbSkip()
	Next

	dbSelectArea("WND")
	dbGotop()
	While !Eof()
		aadd(aCols,{WND->SEQ,WND->OBJECT,WND->PARAM1,WND->PARAM2,WND->PARAM3,WND->PARAM4,WND->PARAM5,WND->PARAM6,WND->PARAM7,WND->PARAM8,.F.})
		dbSkip()
	End	
	aBack := aClone(aCols)

	DEFINE MSDIALOG oDlg FROM 067,071  TO 320,589 TITLE "Edição de Objetos" Of oMainWnd PIXEL
	@ 006,004 TO 103,255 LABEL "Objetos" OF oDlg PIXEL
	oGet := MsGetDados():New(16,10,97,249,1,,,,.T.,,,,300,,,,,oDlg)
	DEFINE SBUTTON FROM 112,209 TYPE 1  ACTION (EditGrv(),oDlg:End())      ENABLE OF oDlg
	DEFINE SBUTTON FROM 112,174 TYPE 2  ACTION (Cancela(aBack),oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 112,140 TYPE 15 ACTION (ObjPrev())                 ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg

	aCols         := aClone(aSavCols)
	aHeader       := aClone(aSavHeader)
	aRotina[1][4] := nOpcAnt

	n := nsavN
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³EditGrv() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EditGrv()
	Local ny

	dbSelectArea("WND")
	For ny	:= 1 to Len(aCols)
		If dbSeek(aCols[ny][1])
			If !aCols[ny][11]
				if Reclock("WND",.F.)
					WND->PARAM1	:= aCols[ny][3]
					WND->PARAM2	:= aCols[ny][4]
					WND->PARAM3	:= aCols[ny][5]
					WND->PARAM4	:= aCols[ny][6]
					WND->PARAM5	:= aCols[ny][7]
					WND->PARAM6	:= aCols[ny][8]
					WND->PARAM7	:= aCols[ny][9]
					WND->PARAM8	:= aCols[ny][10]
					MsUnlock()
				Endif
			Else
				if RecLock("WND",.F.,.T.)
					dbDelete()
					MsUnlock()
				Endif
			EndIf
		Else
			If !aCols[ny][11]
				if Reclock("WND",.T.)
					WND->SEQ		:= aCols[ny][1]
					WND->OBJECT	:= aCols[ny][2]
					WND->PARAM1	:= aCols[ny][3]
					WND->PARAM2	:= aCols[ny][4]
					WND->PARAM3	:= aCols[ny][5]
					WND->PARAM4	:= aCols[ny][6]
					WND->PARAM5	:= aCols[ny][7]
					WND->PARAM6	:= aCols[ny][8]
					WND->PARAM7	:= aCols[ny][9]
					WND->PARAM8	:= aCols[ny][10]
					MsUnlock()
				Endif
			EndIf
		EndIf	
	Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ ObjPre() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ObjPrev()
	Local aPreCols	:= aClone(aCols)
	Local aPreHead	:= aClone(aHeader)
	Local nSav		:= n
	Local nSavRot	:=aRotina[1][4] 

	EditGrv()

	aCols         := aClone(aSavCols)
	aHeader       := aClone(aSavHeader)
	n             := nSavN
	aRotina[1][4] := nOpcAnt

	Preview()

	n             := nSav
	aCols         := aClone(aPreCols)
	aHeader       := aClone(aPreHead)
	aRotina[1][4] := nSavRot
Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Cancela()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a edicao dos objetos da tela.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cancela(aBack)
	aCols	:= aClone(aBack)
	EditGrv()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ SeleBut()³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona um botao Ms Button .                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()    															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SeleBut()
	Local nType	:= 0
	Local oDlg

	DEFINE MSDIALOG oDlg FROM 84 ,44  TO 240,480 TITLE "Selecione o tipo do Ms-Button" Of oMainWnd PIXEL
	@ 002,002 TO 73,215 LABEL " Tipos do Ms-Button " OF oDlg PIXEL
	DEFINE SBUTTON FROM 014,008 TYPE 1  ACTION (nType:=1 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 014,043 TYPE 2  ACTION (nType:=2 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 014,076 TYPE 3  ACTION (nType:=3 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 014,111 TYPE 4  ACTION (nType:=4 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 014,144 TYPE 5  ACTION (nType:=5 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 014,178 TYPE 6  ACTION (nType:=6 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 032,008 TYPE 7  ACTION (nType:=7 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 032,043 TYPE 8  ACTION (nType:=8 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 032,076 TYPE 9  ACTION (nType:=9 ,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 032,111 TYPE 10 ACTION (nType:=10,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 032,144 TYPE 11 ACTION (nType:=11,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 032,178 TYPE 12 ACTION (nType:=12,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 050,008 TYPE 13 ACTION (nType:=13,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 050,043 TYPE 14 ACTION (nType:=14,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 050,076 TYPE 15 ACTION (nType:=15,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 050,111 TYPE 16 ACTION (nType:=16,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 050,144 TYPE 17 ACTION (nType:=17,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 050,178 TYPE 18 ACTION (nType:=18,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
Return nType


Static Function Info()
	Local oDlg

	DEFINE MSDIALOG oDlg FROM 139,170 TO 242,435 TITLE "DialogIDE ADVPL 1.1" Of oMainWnd PIXEL
	@ 003,006 TO 46 ,127 LABEL "" OF oDlg PIXEL
	@ 011,012 SAY "DialogIDE ADVPL 1.1" Of oDlg PIXEL SIZE 039,009
	@ 025,012 SAY "Inteligencia Protheus - Uso Interno" Of oDlg PIXEL SIZE 085,009
	@ 033,012 SAY "www.microsiga.com.br" Of oDlg PIXEL SIZE 110,009
	ACTIVATE MSDIALOG oDlg
Return