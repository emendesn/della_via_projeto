#include "protheus.ch"

/*
--------------------------------------
MANUTENÇÕES EFETUADAS POR ROBSON LUIZ.
--------------------------------------
---> Atribuído modal frame na dialog principal.
---> Setado para não sair com ESC da dialog principal.
---> Criado o botão de sair do programa.
---> Ao clicar no botão "Abrir" é criticado caso não haja arquivos ou o diretório \fontesbx\.
---> Ao clicar no botão "Novo" a rotina verifica a existência do diretório \fontesbx\, se não houver será criado.
---> Criado a opção objeto "Check".
---> Criado a opção objeto "Radio button", para isto foi necessário criar o campo (PARAM9 - C - 100) com as devidas opções.
---> Tirado a independência da variável lOk na cláusula When na opção "Sobre".
---> Alteração na tela de "Sobre" para que seja incluido o nome dos programadores.
---> Criado a opção de listbox, e este têm mais três opções sendo uma lista comum, uma lista com semáforo e uma lista com mark.


---> INICIO DO CRIADOR DE TELAS PROTHEUS - EDSON
*/
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
	Local   oFontB    := TFont():New( "MS Sans Serif", 6, 15 )  
	Local   nUsado    := 0
	Local   bHotArea 
	Local   nCols     := 0
	Local   bSair     := {|| iif(MsgNoYes("Deseja sair?",cTitulo),oDlgW:End(),NIL)}
	Local   oMnu
	Local   oBtn

	Private cTitulo   := "DialogIDE ADVPL 1.1"
	Private aCombo	  := {"Combo 1","Combo 2","Combo 3"},oCombo,cCombo:=""
	Private cGet      := SPACE(100)
	PRIVATE aRotina   := {{"PES","AxPesqui", 0 , 2},{"PES","AxPesqui", 0 , 2},{"PES","AxPesqui", 0 , 4},{"PES","AxPesqui", 0 , 4},{"PES","AxPesqui", 0 , 4}}
	PRIVATE aHeader   := {}
	PRIVATE aCOLS     := {}
	PRIVATE oGetDados
	PRIVATE n         := 1
	PRIVATE lOk	      := .F.
	PRIVATE cCombo1   := "Normal" 
	PRIVATE cAliasG   := "SC6"
	PRIVATE cAliasE   := "SC5"
	PRIVATE cOldG     := "ZZ6"
	PRIVATE cOldE     := "ZZ5"

	Private nRadio    := 1
	Private aDADOS1   := {}
	Private aDADOS2   := {}
	Private aDADOS3   := {}
	Private aCabec    := {}
	Private aCpos     := {}
	Private oLbx1, oLbx2, oLbx3
	Private oVerde    := LoadBitmap(GetResources(),"BR_VERDE")
	Private oVermelho := LoadBitmap(GetResources(),"BR_VERMELHO")
	Private oCheck    := LoadBitmap(GetResources(),"CHECKED")
	Private oUnCheck  := LoadBitmap(GetResources(),"UNCHECKED")

	Private aCampos   := {}

	AADD(aCampos,{ "SEQ"   ,"C",  3,0 } )
	AADD(aCampos,{ "OBJECT","C", 15,0 } )
	AADD(aCampos,{ "PARAM1","C", 60,0 } ) // Nome do objeto
	AADD(aCampos,{ "PARAM2","C",  3,0 } )
	AADD(aCampos,{ "PARAM3","C",  3,0 } )
	AADD(aCampos,{ "PARAM4","C",  3,0 } )
	AADD(aCampos,{ "PARAM5","C",  3,0 } )
	AADD(aCampos,{ "PARAM6","C",  3,0 } )
	AADD(aCampos,{ "PARAM7","C",  3,0 } )
	AADD(aCampos,{ "PARAM8","C",  3,0 } )
	AADD(aCampos,{ "PARAM9","C",100,0 } )


	bHotArea := {||HotAreas(iif(lIntegracao,11,10),4,iif(lIntegracao,18,17),75,nUsado)}

	IniaCols()

	MENU oMnu POPUP
		MENUITEM "Comum"    ACTION MkListbox("C")
		MENUITEM "Semáforo" ACTION MkListbox("S")
		MENUITEM "Mark"     ACTION MkListbox("M")
	ENDMENU

	DEFINE MSDIALOG oDlgW FROM 100,002 TO 430,110 TITLE cTitulo Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
		oDlgW:lMaximized := .T.
		oDlgW:lEscClose := .F.

		@ 2 ,1   TO 40 ,52  LABEL 'Arquivo' OF oDlgW PIXEL
		@ 10,6   BUTTON 'Novo'        SIZE 20,11  FONT oDlgW:oFont ACTION (NewWnd())          OF oDlgW PIXEL 
		@ 10,28  BUTTON 'Abrir'       SIZE 20,11  FONT oDlgW:oFont ACTION (MkOpe())           OF oDlgW PIXEL 
		@ 24,6   BUTTON "Gerar ADVPL" SIZE 42,11  FONT oDlgW:oFont ACTION (Script()) When lOk OF oDlgW PIXEL 

		@ 43,1   TO 124,52  LABEL 'Objetos' OF oDlgW PIXEL
		@ 51,5   BUTTON 'Label'   SIZE 21,8 FONT oDlgW:oFont ACTION (Label())      When lOk OF oDlgW PIXEL 
		@ 51,27  BUTTON 'Say'     SIZE 21,8 FONT oDlgW:oFont ACTION (MkSay())      When lOk OF oDlgW PIXEL 
		@ 61,5   BUTTON 'MsGet'   SIZE 21,8 FONT oDlgW:oFont ACTION (Mkget())      When lOk OF oDlgW PIXEL 
		@ 61,27  BUTTON 'MsButt'  SIZE 21,8 FONT oDlgW:oFont ACTION (MkBut())      When lOk OF oDlgW PIXEL 
		@ 71,5   BUTTON 'Button'  SIZE 21,8 FONT oDlgW:oFont ACTION (MkBut1())     When lOk OF oDlgW PIXEL 
		@ 71,27  BUTTON 'Combo'   SIZE 21,8 FONT oDlgW:oFont ACTION (MkCom())      When lOk OF oDlgW PIXEL 
		@ 81,5   BUTTON 'GetDad'  SIZE 21,8 FONT oDlgW:oFont ACTION (MkGetDados()) When lOk OF oDlgW PIXEL 
		@ 81,27  BUTTON 'MsMGet'  SIZE 21,8 FONT oDlgW:oFont ACTION (MkEnch())     When lOk OF oDlgW PIXEL 
		@ 91,5   BUTTON 'Check'   SIZE 21,8 FONT oDlgW:oFont ACTION (MkCheck())    When lOk OF oDlgW PIXEL 
		@ 91,27  BUTTON 'Radio'   SIZE 21,8 FONT oDlgW:oFont ACTION (MkRadio())    When lOk OF oDlgW PIXEL     
		oBtn := TButton():New(101,5,"Listbox",oDlgW,{||oMnu:Activate(25,9,oBtn)},21,8,,oDlgW:oFont,.F.,.T.,.F.,,.F.,{||lOk},,.F.)
		@ 101,27 BUTTON 'Folder'  SIZE 21,8 FONT oDlgW:oFont ACTION (MkFolder())   When lOk OF oDlgW PIXEL 
		@ 111,5  BUTTON 'Sobre'   SIZE 21,8 FONT oDlgW:oFont ACTION (Info())                OF oDlgW PIXEL 

		@ 126,1  TO 164,52  LABEL 'Ações' OF oDlgW PIXEL
		@ 134,5  BUTTON 'Editar'  SIZE 20,11 FONT oDlgW:oFont ACTION (EditObjs())  When lOk OF oDlgW PIXEL 
		@ 134,27 BUTTON 'Preview' SIZE 20,11 FONT oDlgW:oFont ACTION (Preview())   When lOk OF oDlgW PIXEL 
		@ 148,5  BUTTON 'Sair'    SIZE 42,11 FONT oDlgW:oFont ACTION Eval(bSair)            OF oDlgW PIXEL

	ACTIVATE MSDIALOG oDlgW
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ NewWnd() ³ Autor ³ Edson Maricate    	  ³ Data ³04.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa a nova area de trabalho.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MsMaker()  												  ³±±
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
	Local cFile	    := "NomeArq"
	Local cIndex    := CriaTrab(nil,.f.)
	Local cText	    := "Titulo da Dialog                    "
	Local aCombo    := {"Normal","Advanced","Maximizada","MDI"}

	If !File("\FONTESBX")
		MsgInfo("Não existe o diretório \FONTESBX\, o mesmo será criado abaixo do \Protheus_Data\",cTitulo)   
		MaKeDIR(GetSrvProfString("Rootpath","")+"\FONTESBX\")
	Endif

	DEFINE MSDIALOG oDlgPrw FROM 80 ,145 TO 245,350 TITLE 'Nova Dialog' Of oMainWnd PIXEL
		@ 5  ,4   TO 58 ,101 LABEL '' OF oDlgPrw PIXEL
		@ 40 ,11  MSCOMBOBOX oCombo VAR cCombo1 ITEMS aCombo SIZE 82 ,50 OF oDlgPrw PIXEL 
		@ 13,11 MSGET cFile VALID !Empty(cFile)  SIZE 82,9 Of oDlgPrw PIXEL
		@ 27,11 MSGET cText VALID .T.  SIZE 82,9 Of oDlgPrw PIXEL
 
		DEFINE SBUTTON FROM 65 ,38  TYPE 1   ACTION {|| lConfirma := .T.,oDlgPrw:End()}  ENABLE OF oDlgPrw
		DEFINE SBUTTON FROM 65 ,71  TYPE 2   ACTION {|| oDlgPrw:End() }  ENABLE OF oDlgPrw
	ACTIVATE MSDIALOG oDlgPrw

	If lConfirma 
		If Select("WND") > 0
			dbSelectArea("WND")
			dbClearFilter()
			dbCloseArea()
		EndIf

		MakeDIR("\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\")
		cFile	:= "\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\"+AllTrim(cFile) + ".MKM"

		If File(cFile)
			MsgAlert("O Arquivo selecionado já existe no diretório. Verifique o nome do arquivo!")
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
±±³ Uso		 ³ MsMaker() 												  ³±±
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
	oPanel := TPanel():New(0,0,'',oDlgPrw, oDlgPrw:oFont, .T., .T.,, ,1245,23,.T.,.T. )
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
		@ 1.5,2 to 29,61 Label "" OF oDlgPrw PIXEL
		@ 12,6 MSGET cText VALID oDlgPrw:End() SIZE 50,10 Of oDlgPrw PIXEL

		DEFINE SBUTTON FROM 10025 ,118  TYPE 1   ACTION {|| oDlgPrw:End()}  ENABLE OF oDlgPrw
	ACTIVATE MSDIALOG oDlgPrw

	aTmp  := EnterPoint()
	nCol1 := Int(aTmp[1]/2)
	nRow1 := Int(aTmp[2]/2)

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
	Local nRetRow	:= 0
	Local nRetCol	:= 0
	Local oDlgP
	Local oPanel
	Local cType

	dbSelectArea("WND")
	dbGotop()
	cType := WND->PARAM6

	DEFINE MSDIALOG oDlgP FROM VAL(WND->PARAM2),VAL(WND->PARAM3) TO VAL(WND->PARAM4),VAL(WND->PARAM5) TITLE AllTrim(WND->PARAM1)+" - Marque o ponto ( Use o botão direito do mouse )" Of oMainWnd PIXEL
		oPanel := TPanel():New(0,0,'',oDlgP, oDlgP:oFont, .T., .T.,, ,1245,23,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT

		oPanel:bRClicked	:= {|o,x,y| (nRetCol:=x,nRetRow:=y,oDlgP:End()) }

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
Return({nRetCol,nRetRow})

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

	DEFINE DIALOG oDlg FROM 0,0 TO 600,800 TITLE "oMainWnd - 800 x 600 - Marque o 1o e 2o ponto. ( Use o botão direito do mouse )" of oMainWnd PIXEL
		oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,1245,23,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT
		oPanel:bRClicked	:= {|o,x,y| (nRetCol:=x,nRetRow:=y,oDlg:End()) }
	ACTIVATE MSDIALOG oDlg CENTERED
Return({nRetCol,nRetRow})

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
	Local cText	:= SPACE(60)
	Local lConfirma	:= .F.
	aRotina[1][4] := 4

	DEFINE MSDIALOG oDlgPrw FROM 112,145 TO 178,271 TITLE "Objeto Say" Of oMainWnd PIXEL
		@ 1.5,2 to 29,61 Label "" OF oDlgPrw PIXEL
		@ 12,6 MSGET cText VALID .T.  SIZE 50,10 Of oDlgPrw PIXEL

		DEFINE SBUTTON FROM 10025 ,118  TYPE 1   ACTION {|| oDlgPrw:End()}  ENABLE OF oDlgPrw
	ACTIVATE MSDIALOG oDlgPrw

	aTmp  := EnterPoint()
	nCol1 := Int(aTmp[1]/2)
	nRow1 := Int(aTmp[2]/2)
	
	aTmp  := EnterPoint()
	nCol2 :=Int( aTmp[1]/2)
	nRow2 :=Int( aTmp[2]/2)
	
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
		@ 1.5,2 to 29,61 Label "Variavel" OF oDlgPrw PIXEL
		@ 12,6 MSGET cText VALID .T.  SIZE 50,10 Of oDlgPrw PIXEL

		DEFINE SBUTTON FROM 10025 ,118  TYPE 1   ACTION {|| oDlgPrw:End()}  ENABLE OF oDlgPrw
	ACTIVATE MSDIALOG oDlgPrw

	If lOk
		GrvGet(cText)
	EndIf
Return

Static Function GrvGet(cText)
	aTmp  := EnterPoint()
	nCol1 := Int(aTmp[1]/2)
	nRow1 := Int(aTmp[2]/2)
	aTmp  := EnterPoint()
	nCol2 := Int(aTmp[1]/2)
	nRow2 := Int(aTmp[2]/2)

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
Static Function NewObject(cObject,cParam1,cParam2,cParam3,cParam4,cParam5,cParam6,cParam7,cParam8,cParam9)
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
		WND->PARAM9	 := Alltrim(cParam9)
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
	Local cParam := ""
	cRet	:= ""

	Do Case
		Case WND->OBJECT = "Label"
			If lScript
				cRet := '   @ '+WND->PARAM2+","+WND->PARAM3+" TO "+WND->PARAM4+","+WND->PARAM5+" LABEL '"+Alltrim(WND->PARAM1)+"' OF oPanel PIXEL"
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
				cRet := '   oEnch := MsMGet():New("SA3",SA3->(RecNo()),1,,,,,{'+Alltrim(WND->PARAM2)+','+Alltrim(WND->PARAM3)+','+AllTrim(WND->PARAM4)+','+AllTrim(WND->PARAM5)+'},,3,,,,oPanel,,,,,,.T.)'
			Else
				oEnch := MsMGet():New("SA3",SA3->(RecNo()),1,,,,,{VAL(WND->PARAM2),VAL(WND->PARAM3),VAL(WND->PARAM4),VAL(WND->PARAM5)},,3,,,,oDlg,,,,,,.T.)
			EndIf
		Case WND->OBJECT = "Check-box"
			If lScript
				cRet := "   @ "+RTrim(WND->PARAM2)+","+RTrim(WND->PARAM3)+" CHECKBOX oChk VAR lChk PROMPT '"+RTrim(WND->PARAM1)+"' SIZE "+RTrim(WND->PARAM4)+",9 PIXEL OF oPanel ON CLICK(MsgInfo('Coloque aqui algum evento','Título'))"
			Else
				@ VAL(WND->PARAM2),VAL(WND->PARAM3) CHECKBOX oChk VAR .T. PROMPT WND->PARAM1 SIZE VAL(WND->PARAM4),9 PIXEL OF oDlg ON CLICK(MsgInfo("Coloque aqui algum evento",cTitulo))
			Endif
		Case WND->OBJECT = "Radio-button"
			cBlkGet := '{ | u | Iif(PCount()==0,nRadio,nRadio:=u)}'
			nPos := 0
			aRadio := {}
			cOpc := RTrim(WND->PARAM9)
			While !Empty(cOpc)
				nPos := At("|",cOpc)
				aAdd(aRadio,SubStr(cOpc,1,nPos-1))
				cOpc := SubStr(cOpc,nPos+1)
			End
			If lScript
				cRet := "   oRadio := TRadMenu():New("+WND->PARAM2+","+WND->PARAM3+",aRadio,"+cBlkGet+",oPanel,,,,,,,,"+WND->PARAM4+",9,,,,.T.)"
			Else
				oRadio := TRadMenu():New(VAL(WND->PARAM2),VAL(WND->PARAM3),aRadio,&cBlkGet,oDlg,,,,,,,,VAL(WND->PARAM4),9,,,,.T.)
			Endif
		Case WND->OBJECT = "Listbox"
			cParam := RTrim(WND->PARAM1)
			If cParam=="COMUM"
				If lScript
					cRet := "   oLbx1 := TWBrowse():New("+WND->PARAM3+","+WND->PARAM2+","+WND->PARAM4+","+WND->PARAM5+",,aCabec,,oPanel,,,,,,,,,,,,.F.,,.T.,,.F.,,,)"+Chr(13)+Chr(10)
					cRet += "   oLbx1:SetArray(aDADOS1)"+Chr(13)+Chr(10)
					cRet += "   oLbx1:bLine := {|| aEval(aDADOS1[oLbx1:nAt],{|z,w| aDADOS1[oLbx1:nAt,w] } ) }"
				Else
					oLbx1 := TWBrowse():New(VAL(WND->PARAM3),VAL(WND->PARAM2),VAL(WND->PARAM4),VAL(WND->PARAM5),,aCabec,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oLbx1:SetArray(aDADOS1)
					oLbx1:bLine := {|| aEval(aDADOS1[oLbx1:nAt],{|z,w| aDADOS1[oLbx1:nAt,w] } ) }
				Endif
			Elseif cParam=="SEMAFORO"
				If lScript
					cRet := "   oLbx2 := TWBrowse():New("+WND->PARAM3+","+WND->PARAM2+","+WND->PARAM4+","+WND->PARAM5+",,aCabec,,oPanel,,,,,,,,,,,,.F.,,.T.,,.F.,,,)"+Chr(13)+Chr(10)
					cRet += "   oLbx2:SetArray(aDADOS2)"+Chr(13)+Chr(10)
					cRet += "   cLine2 := '{IIf(aDADOS2[oLbx2:nAt,1],oVerde,oVermelho)'"+Chr(13)+Chr(10)
					cRet += "   aEval( aCpos, {|x,y| cLine += ',aDADOS2[oLbx2:nAt,'+LTrim(Str(y))+']' },2)"+Chr(13)+Chr(10)
					cRet += "   cLine += '}'"+Chr(13)+Chr(10)
					cRet += "   bMyLine := &('{|| '+cLine+'}')"+Chr(13)+Chr(10)
					cRet += "   oLbx2:bLine := bMyLine"
				Else
					oLbx2 := TWBrowse():New(VAL(WND->PARAM3),VAL(WND->PARAM2),VAL(WND->PARAM4),VAL(WND->PARAM5),,aCabec,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oLbx2:SetArray(aDADOS2)
					cLine := "{IIf(aDADOS2[oLbx2:nAt,1],oVerde,oVermelho)"
					aEval( aCpos, {|x,y| cLine += ",aDADOS2[oLbx2:nAt,"+LTrim(Str(y))+"]" }, 2 )
					cLine += "}"
					bMyLine := &("{|| "+cLine+"}")   
					oLbx2:bLine := bMyLine
				Endif
			Elseif cParam=="MARK"
				If lScript
					cRet := "   oLbx3 := TWBrowse():New("+WND->PARAM3+","+WND->PARAM2+","+WND->PARAM4+","+WND->PARAM5+",,aCabec,,oPanel,,,,,,,,,,,,.F.,,.T.,,.F.,,,)"+Chr(13)+Chr(10)
					cRet += "   oLbx3:SetArray(aDADOS3)"+Chr(13)+Chr(10)
					cRet += "   oLbx3:bLDblClick := {|| aDADOS3[oLbx3:nAt,1] :=! aDADOS3[oLbx3:nAt,1] }"+Chr(13)+Chr(10)
					cRet += "   cLine := '{IIf(aDADOS3[oLbx3:nAt,1],oCheck,oUnCheck)'"+Chr(13)+Chr(10)
					cRet += "   aEval(aCpos,{|x,y| cLine += ',aDADOS3[oLbx3:nAt,'+LTrim(Str(y))+']' }, 2 )"+Chr(13)+Chr(10)
					cRet += "   cLine += '}'"+Chr(13)+Chr(10)
					cRet += "   bMyLine := &('{|| '+cLine+'}')"+Chr(13)+Chr(10)
					cRet += "   oLbx3:bLine := bMyLine"
				Else
					oLbx3 := TWBrowse():New(VAL(WND->PARAM3),VAL(WND->PARAM2),VAL(WND->PARAM4),VAL(WND->PARAM5),,aCabec,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oLbx3:SetArray(aDADOS3)
					oLbx3:bLDblClick := {|| aDADOS3[oLbx3:nAt,1] :=! aDADOS3[oLbx3:nAt,1] }
					cLine := "{IIf(aDADOS3[oLbx3:nAt,1],oCheck,oUnCheck)"
					aEval(aCpos,{|x,y| cLine += ",aDADOS3[oLbx3:nAt,"+LTrim(Str(y))+"]" }, 2 )
					cLine += "}"
					bMyLine := &("{|| "+cLine+"}")   
					oLbx3:bLine := bMyLine
				Endif
			Endif
		Case RTrim(WND->OBJECT)=="Folder"
			aFolder := {}
			nPos := 0
			cOpc := RTrim(WND->PARAM9)
			While !Empty(cOpc)
				nPos := At("|",cOpc)
				aAdd(aFolder,SubStr(cOpc,1,nPos-1))
				cOpc := SubStr(cOpc,nPos+1)
			End
			If lScript
				cRet := "   aFolder := {}"+Chr(13)+Chr(10)
				aEval(aFolder,{|x,y| cRet += "   aAdd(aFolder,'"+aFolder[y]+"')"+Chr(13)+Chr(10)})
				cRet += "   oFolder := TFolder():New("+WND->PARAM3+","+WND->PARAM2+",aFolder,,oPanel,"+WND->PARAM6+",,,.T.,.F.,"+WND->PARAM4+","+WND->PARAM5+")"+Chr(13)+chr(10)
			Else
				oFolder := TFolder():New(VAL(WND->PARAM3),VAL(WND->PARAM2),aFolder,,oDlg,VAL(WND->PARAM6),,,.T.,.F.,VAL(WND->PARAM4),VAL(WND->PARAM5))
			Endif
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
	Local nHandle	:= 1
	Local cWrite	
	Local cFile	:= "NomeArq "

	dbSelectArea("WND")
	dbGoTop()

	cWrite := "Local oDlg"+Chr(13)+Chr(10)
	cWrite += ""+Chr(13)+Chr(10)
	cType	:= WND->PARAM6
	cWrite += "DEFINE MSDIALOG oDlg FROM "+ WND->PARAM2 +","+WND->PARAM3+" TO "+WND->PARAM4+","+WND->PARAM5+" TITLE '"+AllTrim(WND->PARAM1)+"' Of oMainWnd PIXEL"+Chr(13)+Chr(10)
	cWrite += Chr(13)+Chr(10)
	cWrite += "   oPanel := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,1245,23,.T.,.T. )"+Chr(13)+Chr(10)
	cWrite += "   oPanel:Align := CONTROL_ALIGN_ALLCLIENT"+Chr(13)+Chr(10)
	cWrite += Chr(13)+Chr(10)

	While !Eof()
		cWrite	+= LoadObj(,.T.)+Chr(13)+Chr(10)
		dbSelectArea("WND")
		dbSkip()
	End

	If "nRadio" $ cWrite
		cWrite := StrTran(cWrite,"Local oDlg","Local oDlg, nRadio:=1")
	Endif

	If "oVerde" $ cWrite
		cWrite := StrTran(cWrite,"Local oDlg","Local oDlg, oVerde:=LoadBitmap(GetResources(),'BR_VERDE'), oVermelho:=LoadBitmap(GetResources(),'BR_VERMELHO')")
	Endif

	If "oCheck" $ cWrite
		cWrite := StrTran(cWrite,"Local oDlg","Local oDlg, oCheck:=LoadBitmap(GetResources(),'CHECKED'), oUnCheck:=LoadBitmap(GetResources(),'UNCHECKED')")
	Endif

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

		DEFINE SBUTTON  FROM 253,275 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
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
		@ 6.5,3.5 TO 49,79 LABEL "Button" OF oDlg PIXEL
		@ 18,7.5 MSGET cText  Picture "@" OF oDlg PIXEL SIZE 68,9
		@ 33,7.0 MSCOMBOBOX oSize VAR cSize ITEMS aSize SIZE 68,50 OF oDlg PIXEL
		DEFINE SBUTTON FROM 10025 ,118  TYPE 1   ACTION {|| oDlg:End()}  ENABLE OF oDlg
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
	Local aParam := { {6,"Abrir",SPACE(254),,"FILE(mv_par01)","", 55 ,.F.,"Arquivo Dialog .MKM |*.MKM", "SERVIDOR\FONTESBX\"},{3,"Minhas Telas",0,{},60,,.F.} }

	If Len(aDir)==0
		MsgInfo("Não há arquivo(s) para abrir",cTitulo)
		Return
	Endif

	For ni := 1 To Len(aDir)
		aAdd(aParam[2,4],aDir[ni][1])
		aAdd(aFiles,aDir[ni][1])
	Next

	MakeDIR("\FONTESBX\"+UPPER(AllTrim(Substr(cUsuario,7,15)))+"\")

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
			aStrVer := dbStruct()
			if Len(aStrVer) <> Len(aCampos)
				cTmpFile := "TMP" + dtos(Date()) + Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
				Copy to &cTmpFile
				dbCloseArea()
				dbCreate(cFile,aCampos)
				dbUseArea( .T.,, cFile,"WND",.T.,.F.)
				Append From &cTmpFile
				fErase(cTmpFile)
			Endif
			IndRegua("WND",cIndex,"SEQ")
			lOk := .T.
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
				AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context } )
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
	Local nP := 0

	Local aHeadTMP	:= {}
	Local nAux
	Local aBack		
	Local nx

	PRIVATE nOpcAnt := aRotina[1][4]
	PRIVATE nSavN		:= n
	PRIVATE aSavHeader	:= aHeader
	PRIVATE aSavCols 		:= aCols

	PRIVATE aHeader 	:= {}
	PRIVATE aCols 	:= {}
	aRotina[1][4] := 4

	aHeadTMP := { {"","SEQ"   ,"No."     ,.F.,".T.","@!"  ,  3,0,"C"},;
				  {"","OBJECT","Objeto"  ,.F.,".T.","@"   , 15,0,"C"},;
				  {"","NAME"  ,"Nome"    ,.F.,".T.","@"   , 20,0,"C"},;
				  {"","AXX"   ,"Param  1",.F.,".T.","@"   ,  3,0,"C"},;
				  {"","BXX"   ,"Param  2",.T.,".T.","@"   ,  3,0,"C"},;
				  {"","CXX"   ,"Param  3",.T.,".T.","@"   ,  3,0,"C"},;
				  {"","DXX"   ,"Param  4",.T.,".T.","@"   ,  3,0,"C"},;
				  {"","EXX"   ,"Param  5",.T.,".T.","@"   ,  3,0,"C"},;
				  {"","FXX"   ,"Param  6",.T.,".T.","@"   ,  3,0,"C"},;
				  {"","GXX"   ,"Param  7",.T.,".T.","@"   ,  3,0,"C"},;
				  {"","HXX"   ,"Param  8",.T.,".T.","@S30",100,0,"C"}}

	SX3->(dbSetOrder(2))
	SX3->(dbSeek("A1_COD"))
	For nx := 1 to Len(aHeadTmp)
		AADD(aHeader,{ TRIM(aHeadTmp[nx][3]),aHeadTmp[nx][2], aHeadTmp[nx][6],aHeadTmp[nx][7], aHeadTmp[nx][8], aHeadTmp[nx][5],SX3->X3_USADO, aHeadTmp[nx][9], "", "" } )
		dbSkip()
	Next

	dbSelectArea("WND")
	dbGotop()
	While !Eof()
		aAdd(aCols,{WND->SEQ,;
					WND->OBJECT,;
					WND->PARAM1,;
					WND->PARAM2,;
					WND->PARAM3,;
					WND->PARAM4,;
					WND->PARAM5,;
					WND->PARAM6,;
					WND->PARAM7,;
					WND->PARAM8,;
					WND->PARAM9,;
					.F.})
		dbSkip()
	End	
	aBack	:= aClone(aCols)

	If (nP:=aScan(aCOLS,{|x| RTrim(x[2])=="Listbox"}))>0
		IniArray(SubStr(RTrim(aCOLS[nP,3]),1,1))
	Endif

	DEFINE MSDIALOG oDlg FROM 67 ,71  TO 320,589 TITLE 'Edição de Objetos' Of oMainWnd PIXEL
		@ 6  ,4   TO 103,255 LABEL 'Objetos' OF oDlg PIXEL
		oGet := 	MsGetDados():New(16,10,97,249,1,,,,.T.,,,,300,,,,,oDlg)
		DEFINE SBUTTON FROM 112,209 TYPE 1   ACTION (EditGrv(),oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 112,174 TYPE 2   ACTION (Cancela(aBack),oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 112,140 TYPE 15   ACTION (ObjPrev()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg

	aCols := aClone(aSavCols)
	aHeader := aClone(aSavHeader)
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
	Local cParam9 := ""

	dbSelectArea("WND")
	For ny := 1 to Len(aCols)
		cParam9 := RTrim(aCOLS[nY,11])
		If RTrim(aCOLS[nY,2])=="Radio-button"
			If Right(cParam9,1)<>"|"
				cParam9 := cParam9+"|"
			Endif
		Endif

		If dbSeek(aCols[ny][1])
			If !aCols[ny][12]
				IF Reclock("WND",.F.)
					WND->PARAM1	:= aCols[ny][3]
					WND->PARAM2	:= aCols[ny][4]
					WND->PARAM3	:= aCols[ny][5]
					WND->PARAM4	:= aCols[ny][6]
					WND->PARAM5	:= aCols[ny][7]
					WND->PARAM6	:= aCols[ny][8]
					WND->PARAM7	:= aCols[ny][9]
					WND->PARAM8	:= aCols[ny][10]
					WND->PARAM9	:= cParam9
					MsUnlock()
				Endif
			Else
				RecLock("WND",.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
		Else
			If !aCols[ny][12]
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
					WND->PARAM9	:= cParam9
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

	DEFINE MSDIALOG oDlg FROM 84 ,44  TO 240,480 TITLE 'Selecione o tipo do Ms-Button' Of oMainWnd PIXEL
		@ 2  ,2   TO 73,215 LABEL ' Tipos do Ms-Button ' OF oDlg PIXEL
		DEFINE SBUTTON FROM 14 ,8   TYPE 1    ACTION (nType:=1,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 14 ,43  TYPE 2    ACTION (nType:=2,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 14 ,76  TYPE 3    ACTION (nType:=3,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 14 ,111 TYPE 4    ACTION (nType:=4,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 14 ,144 TYPE 5    ACTION (nType:=5,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 14 ,178 TYPE 6    ACTION (nType:=6,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 32 ,8   TYPE 7    ACTION (nType:=7,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 32 ,43  TYPE 8    ACTION (nType:=8,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 32 ,76  TYPE 9    ACTION (nType:=9,oDlg:End())  ENABLE OF oDlg
		DEFINE SBUTTON FROM 32 ,111 TYPE 10   ACTION (nType:=10,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 32 ,144 TYPE 11   ACTION (nType:=11,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 32 ,178 TYPE 12   ACTION (nType:=12,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50 ,8   TYPE 13   ACTION (nType:=13,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50 ,43  TYPE 14   ACTION (nType:=14,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50 ,76  TYPE 15   ACTION (nType:=15,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50 ,111 TYPE 16   ACTION (nType:=16,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50 ,144 TYPE 17   ACTION (nType:=17,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 50 ,178 TYPE 18   ACTION (nType:=18,oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
Return nType

//+-------------------------------------------------------------+
//| Função    | MkCheck | Autor | Robson Luiz | Data | 27.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Monta o objeto checkbox                         |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function MkCheck()
	Local aTmp := {}
	Local nCol1 := 0
	Local nRow1 := 0
	Local nCol2 := 0
	Local nRow2 := 0
	Local cText := SeleCheck()

	If Empty(cText)
		Return
	Endif

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	aTmp := EnterPoint()
	nCol2:=Int( aTmp[1]/2)
	nRow2:=Int( aTmp[2]/2)

	NewObject("Check-box",cText,STR(nRow1),STR(nCol1),STR(nCol2-nCol1))

	Preview()
Return

//+-------------------------------------------------------------+
//| Função    |SeleCheck| Autor | Robson Luiz | Data | 27.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Seleciona dados para montar o objeto checkbox   |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function SeleCheck()
	Local cRet := ""
	Local aPar := {}
	Local aRet := {}

	aAdd(aPar,{1,"Título",Space(20),"","",""   ,"",50,.T.})
	If ParamBox(aPar,"Check-box",@aRet)
		cRet := aRet[1]
	Endif
Return(cRet)

//+-------------------------------------------------------------+
//| Função    | MkRadio | Autor | Robson Luiz | Data | 28.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Monta o objeto radio                            |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function MkRadio()
	Local aTmp := {}
	Local nCol1 := 0
	Local nRow1 := 0
	Local nCol2 := 0
	Local nRow2 := 0
	Local aRet := {} 
	Local nIni := 1
	Local cParam9 := ""

	aRet := SeleRadio()

	If Len(aRet)==0
		Return
	Endif

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	aTmp := EnterPoint()
	nCol2:=Int( aTmp[1]/2)
	nRow2:=Int( aTmp[2]/2)

	If aRet[1]==1
		NewObject("Label",aRet[2,1],STR(nRow1),STR(nCol1),STR(nRow2),STR(nCol2))
		nIni := 2
	Endif

	For i:=nIni To Len(aRet[2])
		cParam9 += RTrim(aRet[2,i])+"|"
	Next i

	NewObject("Radio-button","",STR(nRow1+6),STR(nCol1+3),STR((nCol2-nCol1)-6),,,,,cParam9)
	
	Preview()
Return

//+-------------------------------------------------------------+
//| Função    |SeleRadio| Autor | Robson Luiz | Data | 28.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Seleciona dados para montar o objeto radio      |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function SeleRadio()
	Local i := 0
	Local aPar := {}
	Local aRet1 := {}
	Local aRet2 := {}

	aAdd(aPar,{3,"Utiliza moldura",0,{"Sim","Não"},50,"",.T.})
	aAdd(aPar,{1,"Qtas. opções de radio",0,"99","","","",0,.T.})
	If !ParamBox(aPar,"Radio button",@aRet1)
		Return
	Endif

	aPar := {}
	For i:=1 To aRet1[2]
		If aRet1[1]==1.And.i==1
			aAdd(aPar,{1,"Descr. da moldura",Space(15),"","","","",0,.T.})
		Endif
		aAdd(aPar,{1,"Opção "+LTrim(Str(i)),Space(15),"","","","",0,.T.})
	Next i

	If !ParamBox(aPar,"Opção(ões) para radio button",@aRet2)
		Return
	Endif
Return({aRet1[1],aRet2})

//+-------------------------------------------------------------+
//| Função    | Info    | Autor | Robson Luiz | Data | 28.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Dados sobre a rotina.                           |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function Info()
	Local i := 0
	Local oDlg
	Local oScroll
	Local oBmp
	Local oFnt
	Local bGet
	Local aPgm := {}
	Local nTop := 3

	DEFINE FONT oFnt NAME "Monoas" SIZE 0,-12 BOLD
		aAdd(aPgm,"Edson Maricate")
		aAdd(aPgm,"Robson Luiz Estefani Gonçalves")

	DEFINE MSDIALOG oDlg FROM 0,0 TO 232,275 TITLE "Sobre..." OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
		@ 0,0 BITMAP oBmp RESNAME "APLOGO" OF oDlg SIZE 1200,50 NOBORDER PIXEL

		@  3,65 SAY cTitulo                 OF oDlg FONT oFnt COLOR CLR_BLUE PIXEL SIZE 85,9
		@ 18,65 SAY "Inteligência Protheus" OF oDlg FONT oFnt COLOR CLR_BLUE PIXEL SIZE 85,9
		@ 25,65 SAY "www.microsiga.com.br"  OF oDlg FONT oFnt COLOR CLR_BLUE PIXEL SIZE 85,9

		@ 40,5 TO 102,136 LABEL " Créditos " OF oDlg PIXEL  
		@ 46,8 SCROLLBOX oScroll VERTICAL SIZE 51,124 OF oDlg BORDER      

		For i:=1 To Len(aPgm)
			bGet := &("{|| '"+aPgm[i]+"'}")
			TSay():New(nTop,4,bGet,oScroll,,,.F.,.F.,.F.,.T.,CLR_BLUE,,GetTextWidth(0,Trim(aPgm[i])),15,.F.,.F.,.F.,.F.,.F.)
			nTop+=7
		Next i

		@ 104,100 BUTTON "&Ok" SIZE 35,10 PIXEL ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//+-------------------------------------------------------------+
//| Função    |MkListbox| Autor | Robson Luiz | Data | 29.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Monta o objeto listbox.                         |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function MkListbox(cTp)
	Local aTmp := {}
	Local nCol1 := 0
	Local nRow1 := 0
	Local nCol2 := 0
	Local nRow2 := 0
	Local cParam2 := Iif(cTp=="C","COMUM",Iif(cTp=="S","SEMAFORO","MARK"))

	IniArray(cTp)

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	aTmp := EnterPoint()
	nCol2:=Int( aTmp[1]/2)
	nRow2:=Int( aTmp[2]/2)

	NewObject("Listbox",cParam2,Str(nCol1),Str(nRow1),Str(nCol2),Str(nRow2))

	Preview()
Return

//+-------------------------------------------------------------+
//| Função    | IniArray| Autor | Robson Luiz | Data | 29.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Monta os vetores para o objeto listbox.         |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function IniArray(cTp)
	Local i := 0

	If Len(aCabec)>0 .And. Len(aCpos)>0 .And. (Len(aDADOS1)>0 .Or. Len(aDADOS2)>0 .Or. Len(aDADOS3)>0)
		aCabec := {}
		aCpos := {}
		aDADOS1 := {}
		aDADOS2 := {}
		aDADOS3 := {}
	Endif

	If cTp $ "S|M"
		nIni := 2
		aAdd(aCabec," ")
		aAdd(aCpos," "," ")
	Endif

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SA6")
	While !Eof() .And. X3_ARQUIVO=="SA6"
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
			aAdd(aCabec,X3Titulo())
			aAdd(aCpos,{RTrim(X3_CAMPO),X3_CONTEXT})
		Endif
		dbSkip()
	End

	aAdd(aDADOS1,Array(Len(aCpos)))
	aAdd(aDADOS2,Array(Len(aCpos)))
	aAdd(aDADOS3,Array(Len(aCpos)))

	For i:=1 To Len(aCpos)
		If i==1
			aDADOS2[1,1] := .T.
			aDADOS3[1,1] := .T.
			Loop
		Endif
		If aCpos[i,2] <> "V"
			aDADOS2[1,i] := CriaVar(aCpos[i,1],.F.)
			aDADOS3[1,i] := CriaVar(aCpos[i,1],.F.)
		Endif
	Next i
Return

//+-------------------------------------------------------------+
//| Função    | MkFolder| Autor | Robson Luiz | Data | 30.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Montar o objeto folder.                         |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function MkFolder()
	Local nFolder := 0
	Local cFolder := ""
	Local aTmp := {}
	Local nCol1 := nRow1 := 0
	Local nCol2 := nRow2 := 0
	Local i := 0
	Local aRet := SelFolder()

	nFolder := aRet[1]

	If nFolder==0
		Return
	Endif

	For i:=1 To Len(aRet[2])
		cFolder += RTrim(aRet[2,i])+"|"
	Next i

	aTmp := EnterPoint()
	nCol1:= Int(aTmp[1]/2)
	nRow1:= Int(aTmp[2]/2)

	aTmp := EnterPoint()
	nCol2:=Int( aTmp[1]/2)
	nRow2:=Int( aTmp[2]/2)

	NewObject("Folder","",Str(nCol1),Str(nRow1),Str(nCol2),Str(nRow2),Str(nFolder),,,cFolder)

	Preview()
Return

//+-------------------------------------------------------------+
//| Função    |SelFolder| Autor | Robson Luiz | Data | 30.03.06 |
//+-------------------------------------------------------------+
//| Descrição | Seleciona dados para montar o objeto folder.    |
//+-------------------------------------------------------------+
//| Uso       | DialogIDE                                       |
//+-------------------------------------------------------------+
Static Function SelFolder()
	Local aPar := {}
	Local aRet1 := {}
	Local aRet2 := {}
	Local i := 0

	aAdd(aPar,{1,"Quantas pastas",0,"9","","","",0,.T.})
	If !ParamBox(aPar,"Folder",@aRet1)
		Return({0,{}})
	Endif

	aPar := {}
	For i:=1 To aRet1[1]
		aAdd(aPar,{1,"Nome da "+LTrim(Str(i))+"ª pasta",Space(10),"","","","",0,.T.})
	Next i

	If !ParamBox(aPar,"Nome(s) da(s) pasta(s)",@aRet2)
		Return({0,{}})
	Endif
Return({aRet1[1],aRet2})