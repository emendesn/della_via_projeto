/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSQryAut   บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerador de Consultas Automaticas                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function SQryAut()
Private cProg			:= "WzStep1()"
Private cQryArq			:= Space(15)
Private cQryName		:= ""
Private cQryDesc		:= Space(60)
Private cQryAlias		:= ""
Private cQryPerg		:= ""
Private cQryTabPri	:= Space(40)
Private nQryOpc		:= 0
Private nListDis		:= 0
Private cQryExec		:= ''
Private aVarSav		:= {	'cQryArq', 'cQryName', 'cQryDesc', 'cQryAlias', 'cQryPerg','cQryTabPri',;
									'aQryTabSel', 'aQryTabRel', 'aQryFields','aQryGroup','aQryOrder','aQryQuebras','aQryFilters','aQryPergs' } //,'cQryExec' }
Private aQryTabDis	:= {}
Private aQryTabSel	:= {}
Private aQryTabRel	:= {}
Private aQryFields	:= {}
Private aQryGroup	:= {}
Private aQryOrder	:= {}
Private aQryQuebras	:= {}
Private aQryFilters	:= {}
Private aQryPergs	:= {}
Private aCpoDis		:= {}
Private cDirPad		:= GetSrvProfString("ROOTPATH","")
Private nOpc			:= 1
Private aRotina 		:= {	{"Pesquisar", 		"AxPesqui", 	0, 1},;
								{"Visualizar", 		"U_CvDesInc", 	0, 2},;
								{"Incluir", 		"U_CvDesInc", 	0, 3},;
								{"Cancelar", 		"U_CvDesInc", 	0, 5},;
								{"Legenda", 		"U_CvLegenda", 	0, 4} }


//Gerenciador de Telas para a Versao MP8
// 0 = Cancelar
// 1 = Voltar 
// 2 = Avancar

While !Empty( cProg ) 
	cProg := &(cProg)
EndDo
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ                     '
ฑฑบPrograma  ณWzStep1   บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerador de Consultas Automaticas                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzStep1()
Local oDlg1,oGrp,oRadio,oSBtnCanc,oSBtnVoltar,oSBtnAvc,oSay  //Objetos
Local cReturn := ""

oDlg1:= MSDIALOG():Create()
oDlg1:cName := "oDlg1"
oDlg1:cCaption := "Assistente de Consulta (1/7) - Escolha sua Op็ใo"
oDlg1:nLeft := 0
oDlg1:nTop := 0
oDlg1:nWidth := 784
oDlg1:nHeight := 464
oDlg1:lShowHint := .F.
oDlg1:lCentered := .T.

oSay:= TSAY():Create(oDlg1)
oSay:cName := "oSay"
oSay:cCaption := "Escolha uma das Op็๕es:"
oSay:nLeft := 9
oSay:nTop := 7
oSay:nWidth := 755
oSay:nHeight := 34
oSay:lShowHint := .F.
oSay:lReadOnly := .F.
oSay:Align := 0
oSay:lVisibleControl := .T.
oSay:lWordWrap := .T.
oSay:lTransparent := .F.

oGrp := TGROUP():Create(oDlg1)
oGrp:cName := "oGrp"
oGrp:nLeft := 1
oGrp:nTop := 44
oGrp:nWidth := 774
oGrp:nHeight := 341
oGrp:lShowHint := .F.
oGrp:lReadOnly := .F.
oGrp:Align := 0
oGrp:lVisibleControl := .T.

oRadio := TRADMENU():Create(oDlg1)
oRadio:cName := "oRadio"
oRadio:cCaption := "Op็๕es"
oRadio:nLeft := 283
oRadio:nTop := 104
oRadio:nWidth := 223
oRadio:nHeight := 206
oRadio:lShowHint := .F.
oRadio:lReadOnly := .F.
oRadio:Align := 0
oRadio:cVariable := "nQryOpc"
oRadio:bSetGet := {|u| If(PCount()>0,nQryOpc:=u,nQryOpc) }
oRadio:lVisibleControl := .T.
oRadio:nOption := 0
oRadio:aItems := { "Nova Consulta","Abrir / Alterar Consulta","Excluir Consulta Existente"}

oSBtnAvc := SBUTTON():Create(oDlg1)
oSBtnAvc:cName := "oSBtnAvc"
oSBtnAvc:cCaption := "Avan็ar"
oSBtnAvc:nLeft := 700
oSBtnAvc:nTop := 400
oSBtnAvc:nWidth := 52
oSBtnAvc:nHeight := 22
oSBtnAvc:lShowHint := .T.
oSBtnAvc:lReadOnly := .F.
oSBtnAvc:Align := 0
oSBtnAvc:lVisibleControl := .T.
oSBtnAvc:nType := 21
oSBtnAvc:bWhen := {|| .T. }
oSBtnAvc:bAction := {|| If( sQryOpc(oRadio:nOption), ( If(oRadio:nOption==1 .or. oRadio:nOption==2, (cReturn := "WzStep2()", oDlg1:End()), .F. ) ), .F.)   }

oSBtnVoltar := SBUTTON():Create(oDlg1)
oSBtnVoltar:cName := "oSBtnVoltar"
oSBtnVoltar:cCaption := "Voltar"
oSBtnVoltar:nLeft := 640
oSBtnVoltar:nTop := 400
oSBtnVoltar:nWidth := 52
oSBtnVoltar:nHeight := 22
oSBtnVoltar:lShowHint := .T.
oSBtnVoltar:lReadOnly := .F.
oSBtnVoltar:Align := 0
oSBtnVoltar:lVisibleControl := .T.
oSBtnVoltar:nType := 22
oSBtnVoltar:bWhen := {|| .F. }
oSBtnVoltar:bAction := {|| cReturn := "WzStep1()", oDlg1:End() }

oSBtnCanc := SBUTTON():Create(oDlg1)
oSBtnCanc:cName := "oSBtnCanc"
oSBtnCanc:cCaption := "Cancelar"
oSBtnCanc:nLeft := 580
oSBtnCanc:nTop := 400
oSBtnCanc:nWidth := 52
oSBtnCanc:nHeight := 22
oSBtnCanc:lShowHint := .T.
oSBtnCanc:lReadOnly := .F.
oSBtnCanc:Align := 0
oSBtnCanc:lVisibleControl := .T.
oSBtnCanc:nType := 2
oSBtnCanc:bAction := {|| cReturn:="", oDlg1:End() }

oDlg1:Activate()
Return(cReturn)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณsQryOpc   บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa a Opcao do Usuario                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function sQryOpc(nOpc)                                 
Local lRetOpc	:= .T.
Local cTxtSav	:= ""
Private cTipo :=  "Consultas (*.SCA)        | *.SCA | "
If nQryOpc > 0
	If nQryOpc == 1
		// Segundo Dialogo
		cQryArq		:= Space(15)
		cQryName		:= ""
		cQryDesc		:= Space(60)
		cQryTabpri	:= Space(40)
		cQryAlias	:= ""
		cQryPerg		:= ""
		aQryTabDis	:= {}
		aQryTabSel	:= {}
		aQryTabRel	:= {}
		aQryFields	:= {}
		aQryGroup	:= {}
		aQryOrder	:= {}
		aQryQuebras	:= {}
		aQryFilters	:= {}
		aQryPergs	:= {}
	ElseIf nQryOpc == 2
		cQryArq := cGetFile(cTipo,"Abrir Consulta Existente.")
		If !Empty( cQryArq )
			aEval( aVarSav, {|x| &( If(Upper(Substr(x,1,1))=='A', x+' := {}', '') ) } )
			U_TxtToArry( cQryArq )
		Else
			cQryArq := Space(15)
			Aviso("Opera็ใo Abortada","Nenhum Arquivo foi Selecionado !",{"Ok"})
			lRetOpc := .F.
		EndIf
	ElseIf nQryOpc == 3
		cQryArq := cGetFile(cTipo,"Excluir Consulta Existente.")
		If !Empty( cQryArq )
			If !File( cQryArq )
				If File( StrTran( cDirPad + '\'+ cQryArq, '\\', '\' ) )
					cQryArq := StrTran( cDirPad + '\'+ cQryArq, '\\', '\' )
				EndIf
			EndIf
			If File( cQryArq )
				fErase( cQryArq )
			EndIf
		Else
			cQryArq := Space(15)
			Aviso("Opera็ใo Abortada","Nenhum Arquivo foi Selecionado !",{"Ok"})
			lRetOpc := .F.
		EndIf
	EndIf
Else
	MsgAlert( "Selecione uma op็ใo para proseguir !" )
	lRetOpc := .F.
EndIf

Return( lRetOpc )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzStep2   บAutor  ณEvaldo V. Batista   บ Data ณ  03/03/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Segundo passo do Assistente                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzStep2()
Local oDlg2,oGrp1,oSBtnCanc,oSBtnVoltar,oSBtnAvancar,oSayMsg,oQryArq,oSay8,oGet8,oSay9
Local cReturn := ""

oDlg2 := MSDIALOG():Create()
oDlg2:cName := "oDlg2"
oDlg2:cCaption := "Assistente de Consulta (2/7) - Nome da Consulta."
oDlg2:nLeft := 0
oDlg2:nTop := 0
oDlg2:nWidth := 784
oDlg2:nHeight := 464
oDlg2:lShowHint := .F.
oDlg2:lCentered := .T.

oGrp1 := TGROUP():Create(oDlg2)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 2
oGrp1:nTop := 44
oGrp1:nWidth := 772
oGrp1:nHeight := 341
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtnCanc := SBUTTON():Create(oDlg2)
oSBtnCanc:cName := "oSBtnCanc"
oSBtnCanc:cCaption := "Cancelar"
oSBtnCanc:nLeft := 580
oSBtnCanc:nTop := 400
oSBtnCanc:nWidth := 52
oSBtnCanc:nHeight := 22
oSBtnCanc:lShowHint := .T.
oSBtnCanc:lReadOnly := .F.
oSBtnCanc:Align := 0
oSBtnCanc:lVisibleControl := .T.
oSBtnCanc:nType := 2
oSBtnCanc:bAction := {|| cReturn:="", oDlg2:End() }

oSBtnVoltar := SBUTTON():Create(oDlg2)
oSBtnVoltar:cName := "oSBtnVoltar"
oSBtnVoltar:cCaption := "Voltar"
oSBtnVoltar:nLeft := 640
oSBtnVoltar:nTop := 400
oSBtnVoltar:nWidth := 52
oSBtnVoltar:nHeight := 22
oSBtnVoltar:lShowHint := .T.
oSBtnVoltar:lReadOnly := .F.
oSBtnVoltar:Align := 0
oSBtnVoltar:lVisibleControl := .T.
oSBtnVoltar:nType := 22
oSBtnVoltar:bWhen := {|| .T. }
oSBtnVoltar:bAction := {|| cReturn:="WzStep1()", oDlg2:End() }

oSBtnAvancar := SBUTTON():Create(oDlg2)
oSBtnAvancar:cName := "oSBtnAvancar"
oSBtnAvancar:cCaption := "Avan็ar"
oSBtnAvancar:nLeft := 700
oSBtnAvancar:nTop := 400
oSBtnAvancar:nWidth := 52
oSBtnAvancar:nHeight := 22
oSBtnAvancar:lShowHint := .T.
oSBtnAvancar:lReadOnly := .F.
oSBtnAvancar:Align := 0
oSBtnAvancar:lVisibleControl := .T.
oSBtnAvancar:nType := 21
oSBtnAvancar:bWhen := {|| !Empty(cQryArq) }
oSBtnAvancar:bAction := {|| If(Len( aQryTabDis ) == 0,MsgRun( "Obtendo tabelas do Sistema","Aguarde...", {|| Wz3GetTab(@aQryTabDis) }),.f.), cReturn:="WzStep3()", oDlg2:End() }

oSayMsg := TSAY():Create(oDlg2)
oSayMsg:cName := "oSayMsg"
oSayMsg:cCaption := "Defina o nome da consulta, nใo inclua caracteres especiais e nem a extensใo para o nome do arquivo."
oSayMsg:nLeft := 9
oSayMsg:nTop := 7
oSayMsg:nWidth := 755
oSayMsg:nHeight := 34
oSayMsg:lShowHint := .F.
oSayMsg:lReadOnly := .F.
oSayMsg:Align := 0
oSayMsg:lVisibleControl := .T.
oSayMsg:lWordWrap := .T.
oSayMsg:lTransparent := .F.

oQryArq := TGET():Create(oDlg2)
oQryArq:cName := "oQryArq"
oQryArq:nLeft := 230
oQryArq:nTop := 133
oQryArq:nWidth := 306
oQryArq:nHeight := 21
oQryArq:lShowHint := .F.
oQryArq:lReadOnly := .F.
oQryArq:Align := 0
oQryArq:cVariable := "cQryArq"
oQryArq:bSetGet := {|u| If(PCount()>0,cQryArq:=u,cQryArq) }
oQryArq:lVisibleControl := .T.
oQryArq:lPassword := .F.
oQryArq:Picture := "@!"
oQryArq:lHasButton := .F.
oQryArq:bChange := {|| If( !Empty( cQryArq ), oSBtnAvancar:bWhen := {||.T.},oSBtnAvancar:bWhen := {||.F.}) }

oSay8 := TSAY():Create(oDlg2)
oSay8:cName := "oSay8"
oSay8:cCaption := "Nome da consulta:"
oSay8:cMsg := "Nome da consulta:"
oSay8:nLeft := 233
oSay8:nTop := 114
oSay8:nWidth := 95
oSay8:nHeight := 17
oSay8:lShowHint := .F.
oSay8:lReadOnly := .F.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .F.

oGet8:= TGET():Create(oDlg2)
oGet8:cName := "oGet8"
oGet8:cCaption := "Descri็ใo do Arquivo"
oGet8:nLeft := 230
oGet8:nTop := 195
oGet8:nWidth := 306
oGet8:nHeight := 21
oGet8:lShowHint := .F.
oGet8:lReadOnly := .F.
oGet8:Align := 0
oGet8:cVariable := "cQryDesc"
oGet8:bSetGet := {|u| If(PCount()>0,cQryDesc:=u,cQryDesc) }
oGet8:lVisibleControl := .T.
oGet8:lPassword := .F.
oGet8:Picture := "@!"
oGet8:lHasButton := .F.

oSay9 := TSAY():Create(oDlg2)
oSay9:cName := "oSay9"
oSay9:cCaption := "Descri็ใo:"
oSay9:nLeft := 233
oSay9:nTop := 174
oSay9:nWidth := 65
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .F.

oDlg2:Activate()
Return(cReturn)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzStep3   บAutor  ณEvaldo V. Batista   บ Data ณ  03/03/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Selecao da tabela principal                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzStep3()
Local oDlg3,oGrp1,oSBtnCanc,oSBtnVoltar,oSBtnAvancar,oSayMsg,oListDis,oSay14,oGet13,oSay16,oGet19,oSay20
Local cTxtPsq 	:= Space(25)
Local aListDis	:= {}
Local cReturn 	:= ""

If Len( aQryTabDis ) == 0
	MsgRun( "Obtendo tabelas do Sistema","Aguarde...", {|| Wz3GetTab(@aQryTabDis) })
EndIf
aEval( aQryTabDis, {|x| Aadd( aListDis, "("+x[1]+") - "+ x[3] ) })

oDlg3 := MSDIALOG():Create()
oDlg3:cName := "oDlg3"
oDlg3:cCaption := "Assistente de Consulta (3/7) - Sele็ใo da Tabela Principal."
oDlg3:nLeft := 0
oDlg3:nTop := 0
oDlg3:nWidth := 784
oDlg3:nHeight := 464
oDlg3:lShowHint := .F.
oDlg3:lCentered := .T.

oGrp1 := TGROUP():Create(oDlg3)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 2
oGrp1:nTop := 44
oGrp1:nWidth := 772
oGrp1:nHeight := 341
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtnCanc := SBUTTON():Create(oDlg3)
oSBtnCanc:cName := "oSBtnCanc"
oSBtnCanc:cCaption := "Cancelar"
oSBtnCanc:nLeft := 580
oSBtnCanc:nTop := 400
oSBtnCanc:nWidth := 52
oSBtnCanc:nHeight := 22
oSBtnCanc:lShowHint := .T.
oSBtnCanc:lReadOnly := .F.
oSBtnCanc:Align := 0
oSBtnCanc:lVisibleControl := .T.
oSBtnCanc:nType := 2
oSBtnCanc:bAction := {|| cReturn:= "", oDlg3:End() }

oSBtnVoltar := SBUTTON():Create(oDlg3)
oSBtnVoltar:cName := "oSBtnVoltar"
oSBtnVoltar:cCaption := "Voltar"
oSBtnVoltar:nLeft := 640
oSBtnVoltar:nTop := 400
oSBtnVoltar:nWidth := 52
oSBtnVoltar:nHeight := 22
oSBtnVoltar:lShowHint := .T.
oSBtnVoltar:lReadOnly := .F.
oSBtnVoltar:Align := 0
oSBtnVoltar:lVisibleControl := .T.
oSBtnVoltar:nType := 22
oSBtnVoltar:bWhen := {|| .T. }
oSBtnVoltar:bAction := {|| cReturn:= "WzStep2()", oDlg3:End() }

oSBtnAvancar := SBUTTON():Create(oDlg3)
oSBtnAvancar:cName := "oSBtnAvancar"
oSBtnAvancar:cCaption := "Avan็ar"
oSBtnAvancar:nLeft := 700
oSBtnAvancar:nTop := 400
oSBtnAvancar:nWidth := 52
oSBtnAvancar:nHeight := 22
oSBtnAvancar:lShowHint := .T.
oSBtnAvancar:lReadOnly := .F.
oSBtnAvancar:Align := 0
oSBtnAvancar:lVisibleControl := .T.
oSBtnAvancar:nType := 21
oSBtnAvancar:bWhen := {|| !Empty(cQryTabPri) }
oSBtnAvancar:bAction := {|| cReturn:= "WzStep4()", oDlg3:End() }

oSayMsg := TSAY():Create(oDlg3)
oSayMsg:cName := "oSayMsg"
oSayMsg:cCaption := "Selecione a tabela principal da Consulta."
oSayMsg:nLeft := 9
oSayMsg:nTop := 7
oSayMsg:nWidth := 755
oSayMsg:nHeight := 34
oSayMsg:lShowHint := .F.
oSayMsg:lReadOnly := .F.
oSayMsg:Align := 0
oSayMsg:lVisibleControl := .T.
oSayMsg:lWordWrap := .T.
oSayMsg:lTransparent := .F.

oListDis := TLISTBOX():Create(oDlg3)
oListDis:cName := "oListDis"
oListDis:cCaption := "Tabelas Disponํveis"
oListDis:nLeft := 10
oListDis:nTop := 71
oListDis:nWidth := 330
oListDis:nHeight := 277
oListDis:lShowHint := .F.
oListDis:lReadOnly := .F.
oListDis:Align := 0
oListDis:cVariable := "nListDis"
oListDis:bSetGet := {|u| If(PCount()>0,nListDis:=u,nListDis) }
oListDis:lVisibleControl := .T.
oListDis:nAt := aScan( aListDis, cQryTabPri )
oListDis:aItems := aListDis
oListDis:bLClicked := {|| SelTabPri(@oListDis,@oGet19) }
oListDis:bChange := {|| SelTabPri(@oListDis,@oGet19) }

oSay14 := TSAY():Create(oDlg3)
oSay14:cName := "oSay14"
oSay14:cCaption := "Tabelas Disponํveis:"
oSay14:nLeft := 10
oSay14:nTop := 49
oSay14:nWidth := 324
oSay14:nHeight := 17
oSay14:lShowHint := .F.
oSay14:lReadOnly := .F.
oSay14:Align := 0
oSay14:lVisibleControl := .T.
oSay14:lWordWrap := .F.
oSay14:lTransparent := .F.

oGet13 := TGET():Create(oDlg3)
oGet13:cName := "oGet13"
oGet13:nLeft := 73
oGet13:nTop := 355
oGet13:nWidth := 266
oGet13:nHeight := 21
oGet13:lShowHint := .F.
oGet13:lReadOnly := .F.
oGet13:Align := 0
oGet13:cVariable := "cTxtPsq"
oGet13:bSetGet := {|u| If(PCount()>0,cTxtPsq:=u,cTxtPsq) }
oGet13:lVisibleControl := .T.
oGet13:lPassword := .F.
oGet13:Picture := "@!"
oGet13:lHasButton := .F.
oGet13:bValid := {|| U_WzPesqList(@oListDis, @cTxtPsq) }

oSay16 := TSAY():Create(oDlg3)
oSay16:cName := "oSay16"
oSay16:cCaption := "Pesquisar:"
oSay16:nLeft := 10
oSay16:nTop := 358
oSay16:nWidth := 65
oSay16:nHeight := 17
oSay16:lShowHint := .F.
oSay16:lReadOnly := .F.
oSay16:Align := 0
oSay16:lVisibleControl := .T.
oSay16:lWordWrap := .F.
oSay16:lTransparent := .F.

oGet19 := TGET():Create(oDlg3)
oGet19:cName := "oGet19"
oGet19:nLeft := 412
oGet19:nTop := 193
oGet19:nWidth := 330
oGet19:nHeight := 21
oGet19:lShowHint := .F.
oGet19:lReadOnly := .T.
oGet19:Align := 0
oGet19:cVariable := "cQryTabPri"
oGet19:bSetGet := {|u| If(PCount()>0,cQryTabPri:=u,cQryTabPri) }
oGet19:lVisibleControl := .T.
oGet19:lPassword := .F.
oGet19:lHasButton := .F.

oSay20 := TSAY():Create(oDlg3)
oSay20:cName := "oSay20"
oSay20:cCaption := "Tabela Principal:"
oSay20:nLeft := 412
oSay20:nTop := 173
oSay20:nWidth := 92
oSay20:nHeight := 17
oSay20:lShowHint := .F.
oSay20:lReadOnly := .F.
oSay20:Align := 0
oSay20:lVisibleControl := .T.
oSay20:lWordWrap := .F.
oSay20:lTransparent := .F.

If !Empty( cQryTabPri ) .and. Len( aListDis ) > 0
	oListDis:nAt := aScan( aListDis, cQryTabPri )
EndIf
oDlg3:Activate()

Return(cReturn)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetTables บAutor  ณEvaldo V. Batista   บ Data ณ  02/26/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta as tabelas disponiveis no SX2                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Wz3GetTab(aListDis)
Local cAliasAnt	:= Alias()
Local cFilter	:= SX2->( dbFilter() )

SX2->( dbClearFilter() )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
While !SX2->( Eof() )
	If !Empty( cQryTabPri ) .and. Substr( cQryTabPri, 2, 3 ) == SX2->X2_CHAVE 
		Aadd( aQryTabDis, {SX2->X2_CHAVE, SX2->X2_ARQUIVO, SX2->X2_NOME, SX2->X2_MODO, .T.} )
		If aScan( aQryTabSel, {|x| x[1] == SX2->X2_CHAVE .and. x[5] } ) == 0
			aQryTabSel 	:= {}
			aQryTabRel	:= {}
			Aadd( aQryTabSel, {SX2->X2_CHAVE, SX2->X2_ARQUIVO, SX2->X2_NOME, SX2->X2_MODO, .T.} )
		EndIf
	Else
		Aadd( aQryTabDis, {SX2->X2_CHAVE, SX2->X2_ARQUIVO, SX2->X2_NOME, SX2->X2_MODO, .F.} )
	EndIf
	SX2->( dbSkip() )
EndDo
dbSelectArea( "SX2" )
Set Filter To &cFilter
dbSelectArea( cAliasAnt )
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelTabPri บAutor  ณEvaldo V. Batista   บ Data ณ  02/26/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Demonstra a Tabela Selecionada  (tabela Principal)         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function SelTabPri(oList,oRefresh)
Local nPos := oList:nAt
Local aItens := oList:aItems
cQryTabPri := aItens[nPos]
aEval( aQryTabDis, {|x| x[5] := .F. } )
aQryTabDis[nPos, 5] := .T.

If aScan( aQryTabSel, {|x| x[1] == aQryTabDis[nPos, 1] .and. x[5] } ) == 0
	aQryTabSel 	:= {}
	aQryTabRel	:= {}
	aQryFields	:= {}
	aQryGroup	:= {}
	aQryOrder	:= {}
	aQryQuebras	:= {}
	aQryFilters	:= {}
	aQryPergs	:= {}
	Aadd( aQryTabSel, aClone( aQryTabDis[nPos] ) ) 
EndIf
oRefresh:Refresh()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar    บAutor  ณEvaldo V. Batista   บ Data ณ  02/26/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava a Selecao do usuario em disco                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Gravar()
Local cTipo 	:= 'Arquivo de Consulta (*.SCA) |*.SCA|'
Local cQryArq	:= ''

If MsgYesNo( 'Deseja Gravar o Arquivo de Configura็ใo da Consulta ?', 'Gravar...' )
	cQryArq 	:= cGetFile(cTipo,"Gravar configura็ใo")
	If !Empty( cQryArq )
		cTxtSav := ""                                            	
		aEval( aVarSav, {|x| cTxtSav += U_ArrayToTxt( x ) } )    	
		If !( ".SCA" $ Upper( cQryArq ) ) 
			cQryArq += '.SCA'
		EndIf
		MemoWrit( AllTrim(cQryArq), cTxtSav )               
		If File( cQryArq ) 
			MsgInfo( 'Arquivo ' + cQryArq + ' Gravado com Sucesso!', 'Confirma็ใo de Opera็ใo...' )
		Else 
			MsgAlert( 'Foram encontrados problemas na gravacao do arquivo ' + cQryArq, 'Erro Detectado...' )
		EndIf
	EndIf
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzStep4   บAutor  ณEvaldo V. Batista   บ Data ณ  03/03/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Selecionando novas tabelas e seus relacionamentos          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzStep4()
Local oDlg4,oGrp1,oSBtnCanc,oSBtnVoltar,oSBtnAvancar,oSayMsg,oGrp6,oSBtnInc,oSBtnExc,oSBtnEdt
Local nCount	:= 0
Local cReturn	:= ""
Private aHeader	:= {}
Private aCols	:= {}

oDlg4 := MSDIALOG():Create()
oDlg4:cName := "oDlg4"
oDlg4:cCaption := "Assistente de Consulta (4/7) - Editar Relacionamentos."
oDlg4:nLeft := 0
oDlg4:nTop := 0
oDlg4:nWidth := 784
oDlg4:nHeight := 465
oDlg4:lShowHint := .F.
oDlg4:lCentered := .T.

oGrp1 := TGROUP():Create(oDlg4)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 2
oGrp1:nTop := 44
oGrp1:nWidth := 772
oGrp1:nHeight := 341
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtnCanc := SBUTTON():Create(oDlg4)
oSBtnCanc:cName := "oSBtnCanc"
oSBtnCanc:cCaption := "Cancelar"
oSBtnCanc:nLeft := 580
oSBtnCanc:nTop := 400
oSBtnCanc:nWidth := 52
oSBtnCanc:nHeight := 22
oSBtnCanc:lShowHint := .T.
oSBtnCanc:lReadOnly := .F.
oSBtnCanc:Align := 0
oSBtnCanc:lVisibleControl := .T.
oSBtnCanc:nType := 2
oSBtnCanc:bAction := {|| cReturn:= "", oDlg4:End() }

oSBtnVoltar := SBUTTON():Create(oDlg4)
oSBtnVoltar:cName := "oSBtnVoltar"
oSBtnVoltar:cCaption := "Voltar"
oSBtnVoltar:nLeft := 640
oSBtnVoltar:nTop := 400
oSBtnVoltar:nWidth := 52
oSBtnVoltar:nHeight := 22
oSBtnVoltar:lShowHint := .T.
oSBtnVoltar:lReadOnly := .F.                  
oSBtnVoltar:Align := 0
oSBtnVoltar:lVisibleControl := .T.
oSBtnVoltar:nType := 22
oSBtnVoltar:bWhen := {|| .T. }
oSBtnVoltar:bAction := {|| cReturn:= "WzStep3()", oDlg4:End() }

oSBtnAvancar := SBUTTON():Create(oDlg4)
oSBtnAvancar:cName := "oSBtnAvancar"
oSBtnAvancar:cCaption := "Avan็ar"
oSBtnAvancar:nLeft := 700
oSBtnAvancar:nTop := 400
oSBtnAvancar:nWidth := 52
oSBtnAvancar:nHeight := 22
oSBtnAvancar:lShowHint := .T.
oSBtnAvancar:lReadOnly := .F.
oSBtnAvancar:Align := 0
oSBtnAvancar:lVisibleControl := .T.
oSBtnAvancar:nType := 21
oSBtnAvancar:bWhen := {|| .T. }
oSBtnAvancar:bAction := {|| MsgRun( "Calculando os Campos", "Aguarde...", {|| WzGetCpos(.T.)} ), cReturn:= "WzStep5()", oDlg4:End() }

oSayMsg := TSAY():Create(oDlg4)
oSayMsg:cName := "oSayMsg"
oSayMsg:cCaption := "Selecione outras tabelas para a consulta e defina os relacionamentos entre as tabelas"
oSayMsg:nLeft := 9
oSayMsg:nTop := 7
oSayMsg:nWidth := 755
oSayMsg:nHeight := 34
oSayMsg:lShowHint := .F.
oSayMsg:lReadOnly := .F.
oSayMsg:Align := 0
oSayMsg:lVisibleControl := .T.
oSayMsg:lWordWrap := .T.
oSayMsg:lTransparent := .F.

oGrp6 := TGROUP():Create(oDlg4)
oGrp6:cName := "oGrp6"
oGrp6:cCaption := "Relacionamentos"
oGrp6:nLeft := 68
oGrp6:nTop := 60
oGrp6:nWidth := 652
oGrp6:nHeight := 282
oGrp6:lShowHint := .F.
oGrp6:lReadOnly := .F.
oGrp6:Align := 0
oGrp6:lVisibleControl := .T.

oSBtnInc := SBUTTON():Create(oDlg4)
oSBtnInc:cName := "oSBtnInc"
oSBtnInc:cCaption := "Incluir Relacionamento"
oSBtnInc:nLeft := 68
oSBtnInc:nTop := 350
oSBtnInc:nWidth := 52
oSBtnInc:nHeight := 22
oSBtnInc:lShowHint := .T.
oSBtnInc:lReadOnly := .F.
oSBtnInc:Align := 0
oSBtnInc:lVisibleControl := .T.
oSBtnInc:nType := 16
oSBtnInc:bAction := {|| WzEdtRel(1) }

oSBtnExc := SBUTTON():Create(oDlg4)
oSBtnExc:cName := "oSBtnExc"
oSBtnExc:cCaption := "Excluir Relacionamento"
oSBtnExc:cToolTip := "Excluir Relacionamento"
oSBtnExc:nLeft := 128
oSBtnExc:nTop := 350
oSBtnExc:nWidth := 52
oSBtnExc:nHeight := 22
oSBtnExc:lShowHint := .T.
oSBtnExc:lReadOnly := .F.
oSBtnExc:Align := 0
oSBtnExc:lVisibleControl := .T.
oSBtnExc:nType := 2
oSBtnExc:bWhen := {|| Len(aCols)>0 .and. !Empty( aCols[1,1] ) }
oSBtnExc:bAction := {|| WzEdtRel(2) }
/*
oSBtnEdt := SBUTTON():Create(oDlg4)
oSBtnEdt:cName := "oSBtnEdt"
oSBtnEdt:cCaption := "Editar Relacionamento"
oSBtnEdt:cToolTip := "Editar Relacionamento"
oSBtnEdt:nLeft := 188
oSBtnEdt:nTop := 350
oSBtnEdt:nWidth := 52
oSBtnEdt:nHeight := 22
oSBtnEdt:lShowHint := .F.
oSBtnEdt:lReadOnly := .F.
oSBtnEdt:Align := 0
oSBtnEdt:lVisibleControl := .T.
oSBtnEdt:nType := 11
oSBtnEdt:bWhen := {|| Len(aCols)>0 .and. !Empty( aCols[1,1] ) }
oSBtnEdt:bAction := {|| WzEdtRel(3) }
*/

Aadd(aHeader, { "Tabela",;			//Titulo
					"X2_CHAVE",;	//Campo
					"@!",;			//Mascara (Picture)
					10,;			//Tamanho
					0,;				//Decimal
					"",;			//Valid
					"ว",;			//Usado
					"C",;			//Tipo
					"SX2",;			//ARQUIVO
					"" } )			//Contexto

Aadd(aHeader, { "Relaciona com",;	//Titulo
					"X2_CHAVE",;	//Campo
					"@!",;			//Mascara (Picture)
					10,;			//Tamanho
					0,;				//Decimal
					"",;			//Valid
					"ว",;			//Usado
					"C",;			//Tipo
					"SX2",;			//ARQUIVO
					"" } )			//Contexto

Aadd(aHeader, { "Expressao Tabela 1",;//Titulo
					"X2_NOME",;		//Campo
					"@S45",;		//Mascara (Picture)
					200,;			//Tamanho
					0,;				//Decimal
					"",;			//Valid
					"ว",;			//Usado
					"C",;			//Tipo
					"SX2",;			//ARQUIVO
					"" } )			//Contexto

Aadd(aHeader, { "Expressao Tabela 2",;//Titulo
					"X2_NOME",;		//Campo
					"@S45",;		//Mascara (Picture)
					200,;			//Tamanho
					0,;				//Decimal
					"",;			//Valid
					"ว",;			//Usado
					"C",;			//Tipo
					"SX2",;			//ARQUIVO
					"" } )			//Contexto

If Len( aQryTabRel ) > 0
	aEval( aQryTabRel, {|x| Aadd( aCols, { x[1], x[2], PadR( x[3], 200 ), PadR( x[4], 200 ), .F.} ) } )
Else
	Aadd( aCols, {Space(10), Space(10), Space(200), Space(200), .F.} )
EndIf
oGetd:=MsGetDados():New(38,40,165,355,nOpc,".T.",".T.",,.T.,,1,,)
oDlg4:Activate()
Return(cReturn)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzEdtRel  บAutor  ณEvaldo V. Batista   บ Data ณ  03/03/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Configura os Relacionamentos                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzEdtRel(nOpcRel)
Local oDlgRel,oCboPai,oListRel,oSay3,oSay4,oGet5,oGet6,oSBtn7,oSBtnGrv,oSBtn9,oSBtn10,oSay11,oSay12,oGrp13,oSay14,oGet15
Local cTxtPai	:= "Tabela Pai ()"
Local cTxtFilho	:= "Tabela Filho ()"
Local cPesq		:= Space(20)
Local aCombo 	:= {}
Local aListDis	:= {}
Local nPos		:= 0
Local nListDis	:= 0
Local cCombo	:= ""

Private cExpPai 	:= Space(200)
Private cExpFilho 	:= Space(200)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณnOpcRel == 1 - Incluir Relacionamentoณ
//ณnOpcRel == 2 - Excluir Relacionamentoณ
//ณnOpcRel == 3 - Editar Relacionamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nOpcRel <> 1
	If n > 0
		cExpPai 	:= PadR( aCols[n,3], 200 )
		cExpFilho 	:= PadR( aCols[n,4], 200 )
	Else
		MsgAlert( "Selecione um relacionamento para exclusao !", "" )
		Return
	EndIf
EndIf

aEval( aQryTabSel, {|x| Aadd( aCombo, "("+x[1]+") - " +x[3] )	} )

For _nA := 1 To Len( aQryTabDis )
	nPos := aScan( aQryTabSel, {|x| x[1] == aQryTabDis[_nA, 1] } )
	If nPos == 0
		Aadd( aListDis, "("+aQryTabDis[_nA,1]+") - " +aQryTabDis[_nA,3])
	EndIf
Next _nA

oDlgRel := MSDIALOG():Create()
oDlgRel:cName := "oDlgRel"
oDlgRel:cCaption := "Sele็ใo de Relacionamentos"
oDlgRel:nLeft := 0
oDlgRel:nTop := 0
oDlgRel:nWidth := 475
oDlgRel:nHeight := 380
oDlgRel:lShowHint := .F.
oDlgRel:lCentered := .T.
//oDlgRel:bInit := {||  }

oSay3 := TSAY():Create(oDlgRel)
oSay3:cName := "oSay3"
oSay3:cCaption := "Tabela Pai:"
oSay3:nLeft := 8
oSay3:nTop := 8
oSay3:nWidth := 446
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oSay4 := TSAY():Create(oDlgRel)
oSay4:cName := "oSay4"
oSay4:cCaption := "Tabela a Ser Relacionada:"
oSay4:nLeft := 8
oSay4:nTop := 58
oSay4:nWidth := 448
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oSay11 := TSAY():Create(oDlgRel)
oSay11:cName := "oSay11"
oSay11:cCaption := "Expressใo Tabela Pai:"
oSay11:cMsg := "Expressใo Tabela Pai:"
oSay11:nLeft := 8
oSay11:nTop := 214
oSay11:nWidth := 389
oSay11:nHeight := 17
oSay11:lShowHint := .F.
oSay11:lReadOnly := .F.
oSay11:Align := 0
oSay11:cVariable := "cTxtPai"
oSay11:bSetGet := {|u| If(PCount()>0,cTxtPai:=u,cTxtPai) }
oSay11:lVisibleControl := .T.
oSay11:lWordWrap := .F.
oSay11:lTransparent := .F.

oSay12 := TSAY():Create(oDlgRel)
oSay12:cName := "oSay12"
oSay12:cCaption := "Expressใo da Tabela Selecionada:"
oSay12:nLeft := 8
oSay12:nTop := 256
oSay12:nWidth := 391
oSay12:nHeight := 17
oSay12:lShowHint := .F.
oSay12:lReadOnly := .F.
oSay12:Align := 0
oSay12:cVariable := "cTxtFilho"
oSay12:bSetGet := {|u| If(PCount()>0,cTxtFilho:=u,cTxtFilho) }
oSay12:lVisibleControl := .T.
oSay12:lWordWrap := .F.
oSay12:lTransparent := .F.

oCboPai := TCOMBOBOX():Create(oDlgRel)
oCboPai:cName := "oCboPai"
//oCboPai:cCaption := "Tabelas Pai"
oCboPai:nLeft := 8
oCboPai:nTop := 27
oCboPai:nWidth := 447
oCboPai:nHeight := 21
oCboPai:lShowHint := .F.
oCboPai:lReadOnly := .F.
oCboPai:cVariable := "cCombo"
oCboPai:bSetGet := {|u| If(PCount()>0,cCombo:=u,cCombo) }
oCboPai:Align := 0
oCboPai:lVisibleControl := .T.
oCboPai:aItems := aCombo
If nOpcRel == 1
	oCboPai:nAt := If( Len( aCombo ) > 0, 1, 0 )
Else
	oCboPai:nAt := aScan( aCombo, {|x| Substr(x,2,3) == AllTrim(aCols[n,2]) } )
EndIf
oCboPai:bWhen := {|| nOpcRel == 1 .or. nOpcRel == 3 }
oCboPai:bChange := {|| If(oCboPai:nAt>0, oSay11:cCaption := "Expressใo Tabela Pai ("+Substr(cCombo,2,3)+"):",.F.) }

oListRel := TLISTBOX():Create(oDlgRel)
oListRel:cName := "oListRel"
oListRel:cCaption := "Lista de Tabelas para Relacionamento"
oListRel:nLeft := 8
oListRel:nTop := 76
oListRel:nWidth := 447
oListRel:nHeight := 95
oListRel:lShowHint := .F.
oListRel:lReadOnly := .F.
oListRel:Align := 0
oListRel:lVisibleControl := .T.
oListRel:aItems := aListDis
oListRel:bSetGet := {|u| If(PCount()>0,nListDis:=u,nListDis) }
If nOpcRel == 1
	oListRel:nAt := 0
Else
	oListRel:nAt := aScan( aListDis, {|x| Substr(x,2,3) == AllTrim(aCols[n,1])} )
EndIf
oListRel:bWhen := {|| nOpcRel==1 .or. nOpcRel == 3 }
oListRel:bChange := {|| oSay12:cCaption := "Expressใo da Tabela Selecionada ("+Substr(aListDis[oListRel:nAt],2,3)+"):", iF(oListRel:nAt>0,AtuRel( Substr(aListDis[oListRel:nAt],2,3) + Substr(cCombo,2,3), @oGet5, @oGet6 ) , .f.) }
oListRel:cVariable := "nListDis"

oGet5 := TGET():Create(oDlgRel)
oGet5:cName := "oGet5"
oGet5:cCaption := "Expressใo da Tabela Pai:"
oGet5:nLeft := 8
oGet5:nTop := 231
oGet5:nWidth := 390
oGet5:nHeight := 21
oGet5:lShowHint := .F.
oGet5:lReadOnly := .F.
oGet5:Align := 0
oGet5:cVariable := "cExpPai"
oGet5:Picture := "@S45"
oGet5:bWhen := {|| nOpcRel==1 .or. nOpcRel == 3 }
oGet5:bSetGet := {|u| If(PCount()>0,cExpPai:=u,cExpPai) }
oGet5:lVisibleControl := .T.
oGet5:lPassword := .F.
oGet5:lHasButton := .F.
//oGet5:bChange := {|| ValTexto() }

oGet6 := TGET():Create(oDlgRel)
oGet6:cName := "oGet6"
oGet6:cCaption := "Expressใo da Tabela Filho"
oGet6:nLeft := 9
oGet6:nTop := 275
oGet6:nWidth := 389
oGet6:nHeight := 21
oGet6:lShowHint := .F.
oGet6:lReadOnly := .F.
oGet6:Align := 0
oGet6:cVariable := "cExpFilho"
oGet6:Picture := "@S45"
oGet6:bWhen := {|| nOpcRel==1 .or. nOpcRel == 3 }
oGet6:bSetGet := {|u| If(PCount()>0,cExpFilho:=u,cExpFilho) }
oGet6:lVisibleControl := .T.
oGet6:lPassword := .F.
oGet6:lHasButton := .F.
//oGet6:bChange := {|| ValTexto() }

oSBtn7 := SBUTTON():Create(oDlgRel)
oSBtn7:cName := "oSBtn7"
oSBtn7:cCaption := "Cancelar"
oSBtn7:cMsg := "Cancelar"
oSBtn7:cToolTip := "Cancelar"
oSBtn7:nLeft := 320
oSBtn7:nTop := 314
oSBtn7:nWidth := 52
oSBtn7:nHeight := 22
oSBtn7:lShowHint := .T.
oSBtn7:lReadOnly := .F.
oSBtn7:Align := 0                          
oSBtn7:lVisibleControl := .T.
oSBtn7:nType := 2
oSBtn7:bAction := {|| oDlgRel:End() }

oSBtnGrv := SBUTTON():Create(oDlgRel)
oSBtnGrv:cName := "oSBtnGrv"
oSBtnGrv:cCaption := "Gravar"
oSBtnGrv:cMsg := "Gravar"
oSBtnGrv:cToolTip := "Gravar"
oSBtnGrv:nLeft := 380
oSBtnGrv:nTop := 314
oSBtnGrv:nWidth := 55
oSBtnGrv:nHeight := 25
oSBtnGrv:lShowHint := .T.
oSBtnGrv:lReadOnly := .F.
oSBtnGrv:Align := 0
oSBtnGrv:lVisibleControl := .T.
oSBtnGrv:nType := 1
oSBtnGrv:bWhen := {|| (!Empty(cExpPai) .and. !Empty(cExpFilho) .and. oListRel:nAt <> 0 .and. !Empty(cCombo)) .or. nOpcRel<>1 }
oSBtnGrv:bAction := {|| lCont:=WzGrvRel(nOpcRel,If(oListRel:nAt<>0, Substr(aListDis[oListRel:nAt],2,3), Space(3) ), Substr( cCombo, 2, 3), cExpFilho, cExpPai ), If(lCont, oDlgRel:End(), .F.)}

oSBtn9 := SBUTTON():Create(oDlgRel)
oSBtn9:cName := "oSBtn9"
oSBtn9:cCaption := "Campos:"
oSBtn9:cMsg := "Campos"
oSBtn9:cToolTip := "Campos"
oSBtn9:nLeft := 395
oSBtn9:nTop := 229
oSBtn9:nWidth := 52
oSBtn9:nHeight := 22
oSBtn9:lShowHint := .T.
oSBtn9:lReadOnly := .F.
oSBtn9:Align := 0
oSBtn9:lVisibleControl := .T.
oSBtn9:nType := 14
oSBtn9:bWhen := {|| nOpcRel==1 .or. nOpcRel == 3 }
oSBtn9:bAction := {|| If( !Empty(cCombo), ( WzSelCpo(Substr(cCombo,2,3), @cExpPai), oGet5:Refresh() ), .F.) }

oSBtn10 := SBUTTON():Create(oDlgRel)
oSBtn10:cName := "oSBtn10"
oSBtn10:cCaption := "Campos"
oSBtn10:cMsg := "Campos"
oSBtn10:cToolTip := "Campos"
oSBtn10:nLeft := 395
oSBtn10:nTop := 272
oSBtn10:nWidth := 52
oSBtn10:nHeight := 22
oSBtn10:lShowHint := .T.
oSBtn10:lReadOnly := .F.
oSBtn10:Align := 0
oSBtn10:lVisibleControl := .T.
oSBtn10:nType := 14
oSBtn10:bWhen := {|| nOpcRel==1 .or. nOpcRel == 3 }
oSBtn10:bAction := {|| If(oListRel:nAt > 0,( WzSelCpo(Substr(aListDis[oListRel:nAt],2,3), @cExpFilho), oGet6:Refresh() ), .F.) }

oGrp13 := TGROUP():Create(oDlgRel)
oGrp13:cName := "oGrp13"
oGrp13:nLeft := 3
oGrp13:nTop := 3
oGrp13:nWidth := 459
oGrp13:nHeight := 304
oGrp13:lShowHint := .F.
oGrp13:lReadOnly := .F.
oGrp13:Align := 0
oGrp13:lVisibleControl := .T.

oSay14 := TSAY():Create(oDlgRel)
oSay14:cName := "oSay14"
oSay14:cCaption := "Pesquisar:"
oSay14:nLeft := 8
oSay14:nTop := 180
oSay14:nWidth := 56
oSay14:nHeight := 17
oSay14:lShowHint := .F.
oSay14:lReadOnly := .F.
oSay14:Align := 0
oSay14:lVisibleControl := .T.
oSay14:lWordWrap := .F.
oSay14:lTransparent := .F.

oGet15 := TGET():Create(oDlgRel)
oGet15:cName := "oGet15"
oGet15:cCaption := "Pesquisar"
oGet15:nLeft := 71
oGet15:nTop := 177
oGet15:nWidth := 384
oGet15:nHeight := 21
oGet15:lShowHint := .F.
oGet15:lReadOnly := .F.
oGet15:Align := 0
oGet15:cVariable := "cPesq"
oGet15:Picture := "@!"
oGet15:bWhen := {|| nOpcRel==1 .or. nOpcRel == 3 }
oGet15:bSetGet := {|u| If(PCount()>0,cPesq:=u,cPesq) }
oGet15:lVisibleControl := .T.
oGet15:lPassword := .F.
oGet15:lHasButton := .F.
oGet15:bValid := {|| U_WzPesqList(@oListRel, @cPesq) }

oDlgRel:Activate()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuRel    บAutor  ณEvaldo V. Batista   บ Data ณ  03/03/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe os relacionamentos padrao provenientes do Microsiga  บฑฑ
ฑฑบ          ณ tabela SX9                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AtuRel(cChave,oObj1, oObj2)
Local lRet := .T.
SX9->( dbSetOrder( 2 ) ) 
If SX9->( dbSeek( cChave ) ) 
	cExpFilho 	:= SX9->X9_EXPCDOM
	cExpPai		:= SX9->X9_EXPDOM
Else
	lRet := .F.
	cExpFilho 	:= Space(200)
	cExpPai		:= Space(200)
EndIf
If ValType( oObj1 ) == 'O'; oObj1:Refresh(); EndIf
If ValType( oObj2 ) == 'O'; oObj2:Refresh(); EndIf
Return( lRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzSelCpo  บAutor  ณEvaldo V. Batista   บ Data ณ  03/03/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe os campos da Tabela cNomTab e grava na Variavel      บฑฑ
ฑฑบ          ณ cVarAdd                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzSelCpo( cNomTab, cVarAdd )
Local oDlgCpo,oListCpo,oSBtn2,oSBtn3,oSay4,oGetPesq,oSay6
Local aListCpo	:= {}
Local cPesq		:= Space(15)
Local nPosSel	:= 0

SX3->( dbSetOrder( 1 ) ) 
If SX3->( dbSeek( cNomTab ) ) 
	While !SX3->( Eof() ) .and. SX3->X3_ARQUIVO == cNomTab
		Aadd( aListCpo, SX3->X3_CAMPO + "(" + Upper(AllTrim(SX3->X3_TITULO)) + ")" )
		SX3->( dbSkip() ) 
    EndDo
EndIf

oDlgCpo := MSDIALOG():Create()
oDlgCpo:cName := "oDlgCpo"
oDlgCpo:cCaption := "Selecionar Campos"
oDlgCpo:nLeft := 0
oDlgCpo:nTop := 0
oDlgCpo:nWidth := 271
oDlgCpo:nHeight := 247
oDlgCpo:lShowHint := .F.
oDlgCpo:lCentered := .T.

oListCpo := TLISTBOX():Create(oDlgCpo)
oListCpo:cName := "oListCpo"
oListCpo:cCaption := "Campos da Tabela (" + cNomTab + "):"
oListCpo:cMsg := "Campos da Tabela (" + cNomTab + "):"
oListCpo:cToolTip := "Campos da Tabela (" + cNomTab + "):"
oListCpo:nLeft := 4
oListCpo:nTop := 26
oListCpo:nWidth := 251
oListCpo:nHeight := 130
oListCpo:lShowHint := .F.
oListCpo:lReadOnly := .F.
oListCpo:Align := 0
oListCpo:cVariable := "nPosSel"
oListCpo:bSetGet := {|u| If(PCount()>0,nPosSel:=u,nPosSel) }
oListCpo:lVisibleControl := .T.
oListCpo:nAt := 0
oListCpo:aItems := aListCpo
oListCpo:bChange := {|| oSBtn2:bWhen := {|| .T. }, oSBtn2:Refresh() }

oSBtn2 := SBUTTON():Create(oDlgCpo)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "oSBtn2"
oSBtn2:nLeft := 200
oSBtn2:nTop := 191
oSBtn2:nWidth := 55
oSBtn2:nHeight := 25
oSBtn2:lShowHint := .F.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 1
oSBtn2:bWhen := {|| oListCpo:nAt > 0 }
oSBtn2:bAction := {|| cVarAdd:=PadR( If(!Empty(cVarAdd), AllTrim(cVarAdd) + " + ", "" ) + Substr(aListCpo[oListCpo:nAt],1,10), 200 ), oDlgCpo:End() }

oSBtn3 := SBUTTON():Create(oDlgCpo)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "oSBtn3"
oSBtn3:nLeft := 140
oSBtn3:nTop := 191
oSBtn3:nWidth := 52
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 2
oSBtn3:bAction := {|| oDlgCpo:End() }

oSay4 := TSAY():Create(oDlgCpo)
oSay4:cName := "oSay4"
oSay4:cCaption := "Pesquisar:"
oSay4:nLeft := 6
oSay4:nTop := 160
oSay4:nWidth := 51
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oGetPesq := TGET():Create(oDlgCpo)
oGetPesq:cName := "oGetPesq"
oGetPesq:cCaption := "Pesquisar"
oGetPesq:nLeft := 62
oGetPesq:nTop := 158
oGetPesq:nWidth := 194
oGetPesq:nHeight := 21
oGetPesq:lShowHint := .F.
oGetPesq:lReadOnly := .F.
oGetPesq:Align := 0
oGetPesq:cVariable := "cPesq"
oGetPesq:bSetGet := {|u| If(PCount()>0,cPesq:=u,cPesq) }
oGetPesq:lVisibleControl := .T.
oGetPesq:lPassword := .F.
oGetPesq:Picture := "@!"
oGetPesq:lHasButton := .F.
oGetPesq:bValid := {|| U_WzPesqList( @oListCpo, @cPesq) }

oSay6 := TSAY():Create(oDlgCpo)
oSay6:cName := "oSay6"
oSay6:cCaption := "Campos da Tabela:"
oSay6:nLeft := 4
oSay6:nTop := 5
oSay6:nWidth := 251
oSay6:nHeight := 17
oSay6:lShowHint := .F.
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .F.

oDlgCpo:Activate()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzGrvRel  บAutor  ณEvaldo V. Batista   บ Data ณ  03/03/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava os relacionamentos                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzGrvRel(nOpc, cTabNew, cTabPai, cExp1, cExp2)
Local nPosSel 	:= aScan( aQryTabDis, {|x| x[1]==cTabNew} )
Local nTam		:= 0
Local lCont		:= .T.
Local x			
ErrorBlock({|e| lCont := .F. })
If nOpc == 1
	//Valida a Expressใo Pai
	ChkFile( cTabPai )
	(cTabPai)->( x:=&(AllTrim(cExp2)) )
	If !lCont 
		MsgAlert( 'Existe um erro na Expressใo da tabela PAI: ' + AllTrim(cExp2) + Chr(13) +;
					'Verifique a ortografia dos nomes de campos ou utilize a ferramenta de sele็ใo de campos para evitar erros!', 'Erro na Expressใo PAI...')
	EndIf
	
	//Valida a Expressao Filho
	If lCont
		ChkFile( cTabNew )
		(cTabNew)->( x:=&(AllTrim(cExp1)) )
		If !lCont 
			MsgAlert( 'Existe um erro na Expressใo da tabela FILHO: ' + AllTrim( cExp1 ) + Chr(13) +;
						'Verifique a ortografia dos nomes de campos ou utilize a ferramenta de sele็ใo de campos para evitar erros!', 'Erro na Expressใo FILHO...')
		EndIf
	EndIf

	SX9->( dbSetOrder( 2 ) ) 
	If !SX9->( dbSeek( cTabNew + cTabPai ) ) 
		If MsgYesNo( 'O relacionado definido nใo estแ cadastrado, deseja cadastrแ-lo para pesquisas futuras ?', 'Gravar o Relacionamento...' )
			RecLock( 'SX9', .T. )
			SX9->X9_IDENT 	:= '01'
			SX9->X9_DOM 	:= cTabPai
			SX9->X9_CDOM 	:= cTabNew
			SX9->X9_EXPDOM	:= cExp2
			SX9->X9_EXPCDOM	:= cExp1
			SX9->X9_USO		:= 'U'
			SX9->X9_LIGDOM	:= '1'
			SX9->X9_LIGCDOM	:= 'N'
			SX9->( MsUnLock() ) 
		EndIf
	EndIf
EndIf
If nOpc == 1 .AND. lCont
	Aadd( aQryTabSel, aClone(aQryTabDis[nPosSel]) )
	
	aDel( aQryTabDis, nPosSel )
	nTam := Len( aQryTabDis ) - 1
	aSize( aQryTabDis, nTam )
	
	Aadd( aQryTabRel, {cTabNew, cTabPai, AllTrim(cExp1), AllTrim(cExp2), .F.} )
ElseIf nOpc == 2 .AND. lCont
	If MsgYesNo("Deseja realmente excluir o relacionamento ?","Confirma็ใo de Exclusใo")
		nPosSel := aScan( aQryTabDis, {|x| x[1] == aCols[n,1] } )
		If nPosSel == 0
			nPosSel := aScan( aQryTabSel, {|x| x[1] == aCols[n,1] } )
			Aadd( aQryTabDis, aClone( aQryTabSel[nPosSel] ) )
			aSort( aQryTabDis,,, {|x,y| x[1] < y[1] } )
		EndIf
		
		nPosSel := aScan( aQryTabSel, {|x| x[1] == aCols[n,1] } )
		aDel( aQryTabSel, nPosSel )
		nTam := Len( aQryTabSel ) - 1
		aSize( aQryTabSel, nTam )
		
		nPosSel := aScan( aQryTabRel, {|x| x[1] == aCols[n,1] } )
		aDel( aQryTabRel, nPosSel )
		nTam := Len( aQryTabRel ) - 1
		aSize( aQryTabRel, nTam )
	EndIf
EndIf
If lCont
aCols := {}
aEval( aQryTabRel, {|x| Aadd( aCols, { x[1], x[2], PadR( x[3], 200 ), PadR( x[4], 200 ), .F.} ) } )
EndIf
Return(lCont)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ                     '
ฑฑบPrograma  ณWzStep5   บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Selecionador de Campos                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzStep5()
Local oDlg5,oGrp1,oSBtn3,oSBtn2,oSBtn1,oSay1,oListCpoDis,oListCpoSel,oGetPsqDis,oSBtnAdd,oSBtnAddAll,oSBtnRemAll,oSBtnRem,oGetPsqSel,oSay20,oSay21,oChkTot,oGetFor,oSay24,oGetTit,oSay26,oBtn27,oBtn28,oSay29,oSay30,oGrp31,oChkAgrp,oGetTipo,oSay34
Local nPosDis	:= 0
Local nPosSel	:= 0
Local cPesqDis	:= Space(20)
Local cPesqSel 	:= Space(20)
Local lChkTot	:= .F.
Local lChkAgrp	:= .F.
Local cFormato	:= Space(20)
Local cTitulo 	:= Space(20)
Local cGetTipo	:= Space(20)
Local aListDis	:= {}
Local aListSel	:= {}
Local cReturn	:= ""

aEval( aCpoDis, {|x| Aadd(aListDis, x[1] + '.' + x[3] + Space(8) + '(' + AllTrim(x[7]) + ')' ) } )

aEval( aQryFields, {|x| Aadd(aListSel, x[1] + '.' + x[3] + Space(8) + '(' + AllTrim(x[7]) + ')' ) } )

oDlg5 := MSDIALOG():Create()
oDlg5:cName := "oDlg5"
oDlg5:cCaption := "Assistente de Consulta (5/7) - Sele็ใo dos Campos"
oDlg5:nLeft := 0
oDlg5:nTop := 0
oDlg5:nWidth := 784
oDlg5:nHeight := 461
oDlg5:lShowHint := .F.
oDlg5:lCentered := .T.
//oDlg5:bInit := {|| WzGetCpoTab() }

oGrp1 := TGROUP():Create(oDlg5)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 1
oGrp1:nTop := 44
oGrp1:nWidth := 773
oGrp1:nHeight := 341
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtn3 := SBUTTON():Create(oDlg5)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "Cancelar"
oSBtn3:cMsg := "Cancelar"
oSBtn3:cToolTip := "Cancelar"
oSBtn3:nLeft := 580
oSBtn3:nTop := 400
oSBtn3:nWidth := 52
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .T.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 2
oSBtn3:bAction := {|| cReturn:= "", oDlg5:End() }

oSBtn2 := SBUTTON():Create(oDlg5)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "Voltar"
oSBtn2:nLeft := 640
oSBtn2:nTop := 400
oSBtn2:nWidth := 52
oSBtn2:nHeight := 22
oSBtn2:lShowHint := .T.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 22
oSBtn2:bWhen := {|| .T. }
oSBtn2:bAction := {|| cReturn:= "WzStep4()", oDlg5:End() }

oSBtn1 := SBUTTON():Create(oDlg5)
oSBtn1:cName := "oSBtn1"
oSBtn1:cCaption := "Avan็ar"
oSBtn1:nLeft := 700
oSBtn1:nTop := 400
oSBtn1:nWidth := 52
oSBtn1:nHeight := 22
oSBtn1:lShowHint := .T.
oSBtn1:lReadOnly := .F.
oSBtn1:Align := 0
oSBtn1:lVisibleControl := .T.
oSBtn1:nType := 21
oSBtn1:bWhen := {|| Len( oListCpoSel:aItems ) > 0 }
oSBtn1:bAction := {|| MsgRun( "Calculando os Campos", "Aguarde...", {|| WzGetCpos(.F.)} ), cReturn:= "WzStep6()", oDlg5:End() }

oSay1 := TSAY():Create(oDlg5)
oSay1:cName := "oSay1"
oSay1:cCaption := "Selecionar os Campos que serใo utilizados na Consulta e as propriedades de cada um. "
oSay1:nLeft := 9
oSay1:nTop := 7
oSay1:nWidth := 755
oSay1:nHeight := 34
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .T.
oSay1:lTransparent := .F.

oListCpoDis := TLISTBOX():Create(oDlg5)
oListCpoDis:cName := "oListCpoDis"
oListCpoDis:cCaption := "Campos Disponํveis"
oListCpoDis:cMsg := "Campos Disponํveis"
oListCpoDis:cToolTip := "Campos Disponํveis"
oListCpoDis:nLeft := 10
oListCpoDis:nTop := 77
oListCpoDis:nWidth := 240
oListCpoDis:nHeight := 268
oListCpoDis:lShowHint := .F.
oListCpoDis:lReadOnly := .F.
oListCpoDis:Align := 0
oListCpoDis:cVariable := "nPosDis"
oListCpoDis:bSetGet := {|u| If(PCount()>0,nPosDis:=u,nPosDis) }
oListCpoDis:lVisibleControl := .T.
oListCpoDis:nAt := 0
oListCpoDis:aItems := aListDis
oListCpoDis:bLClicked := {|| .T. }
oListCpoDis:bRClicked := {|| .T. }
oListCpoDis:bLDblClick := {|| .T. }
oListCpoDis:bChange := {|| .T. }

oListCpoSel := TLISTBOX():Create(oDlg5)
oListCpoSel:cName := "oListCpoSel"
oListCpoSel:cCaption := "Campos Selecionados"
oListCpoSel:cMsg := "Campos Selecionados"
oListCpoSel:cToolTip := "Campos Selecionados"
oListCpoSel:nLeft := 312
oListCpoSel:nTop := 77
oListCpoSel:nWidth := 240
oListCpoSel:nHeight := 268
oListCpoSel:lShowHint := .F.
oListCpoSel:lReadOnly := .F.
oListCpoSel:Align := 0
oListCpoSel:cVariable := "nPosSel"
oListCpoSel:bSetGet := {|u| If(PCount()>0,nPosSel:=u,nPosSel) }
oListCpoSel:lVisibleControl := .T.
oListCpoSel:nAt := 0
oListCpoSel:aItems := aListSel
oListCpoSel:bWhen := {|| .T. }
oListCpoSel:bLClicked := {|| .T. }
oListCpoSel:bRClicked := {|| .T. }
oListCpoSel:bLDblClick := {|| .T. }
oListCpoSel:bChange := {|| IF( oListCpoSel:nAt > 0 .and. oListCpoSel:nAt<=len(aQryFields), (nPos := oListCpoSel:nAt, cFormato:=aQryFields[nPos,8], cTitulo:=aQryFields[nPos,7], cGetTipo:=WzRetTipo(aQryFields[nPos,4]), lChkTot:=aQryFields[nPos,9], lChkAgrp:=aQryFields[nPos,10]), .F.) }

oGetPsqDis := TGET():Create(oDlg5)
oGetPsqDis:cName := "oGetPsqDis"
oGetPsqDis:cCaption := "Pesquisar Disponํvel"
oGetPsqDis:cMsg := "Pesquisar Disponํvel"
oGetPsqDis:cToolTip := "Pesquisar Disponํvel"
oGetPsqDis:nLeft := 70
oGetPsqDis:nTop := 353
oGetPsqDis:nWidth := 180
oGetPsqDis:nHeight := 21
oGetPsqDis:lShowHint := .F.
oGetPsqDis:lReadOnly := .F.
oGetPsqDis:Align := 0
oGetPsqDis:cVariable := "cPesqDis"
oGetPsqDis:bWhen := {|| Len( oListCpoDis:aItems ) > 0 }
oGetPsqDis:bSetGet := {|u| If(PCount()>0,cPesqDis:=u,cPesqDis) }
oGetPsqDis:lVisibleControl := .T.
oGetPsqDis:lPassword := .F.
oGetPsqDis:lHasButton := .F.
oGetPsqDis:bValid := {|| U_WzPesqList( @oListCpoDis, @cPesqDis ) }

oSBtnAdd := SBUTTON():Create(oDlg5)
oSBtnAdd:cName := "oSBtnAdd"
oSBtnAdd:cCaption := "Adicionar Um"
oSBtnAdd:cMsg := "Adicionar Um"
oSBtnAdd:cToolTip := "Adicionar Um"
oSBtnAdd:nLeft := 253
oSBtnAdd:nTop := 133
oSBtnAdd:nWidth := 52
oSBtnAdd:nHeight := 22
oSBtnAdd:lShowHint := .F.
oSBtnAdd:lReadOnly := .F.
oSBtnAdd:Align := 0
oSBtnAdd:lVisibleControl := .T.
oSBtnAdd:nType := 19
oSBtnAdd:bWhen := {|| Len( oListCpoDis:aItems ) > 0 .and. oListCpoDis:nAt > 0 }
oSBtnAdd:bAction := {|| U_ListToList(@oListCpoDis, @aCpoDis, @oListCpoSel, @aQryFields, oListCpoDis:nAt, {|x,y| x[1]+x[2] < y[1]+y[2] }, NIL,"aVar[1] + '.' + aVar[3] + Space(8) + '(' + AllTrim(aVar[7]) + ')'", .F.) }

oSBtnAddAll := SBUTTON():Create(oDlg5)
oSBtnAddAll:cName := "oSBtnAddAll"
oSBtnAddAll:cCaption := "Adicionar Tudo"
oSBtnAddAll:cMsg := "Adicionar Tudo"
oSBtnAddAll:cToolTip := "Adicionar Tudo"
oSBtnAddAll:nLeft := 253
oSBtnAddAll:nTop := 163
oSBtnAddAll:nWidth := 52
oSBtnAddAll:nHeight := 22
oSBtnAddAll:lShowHint := .F.
oSBtnAddAll:lReadOnly := .F.
oSBtnAddAll:Align := 0
oSBtnAddAll:lVisibleControl := .T.
oSBtnAddAll:nType := 21
oSBtnAddAll:bWhen := {|| Len( oListCpoDis:aItems ) > 0 .and. oListCpoDis:nAt > 0 }
oSBtnAddAll:bAction := {|| U_ListToList(@oListCpoDis, @aCpoDis, @oListCpoSel, @aQryFields, oListCpoDis:nAt, {|x,y| x[1]+x[2] < y[1]+y[2] }, NIL,"aVar[1] + '.' + aVar[3] + Space(8) + '(' + AllTrim(aVar[7]) + ')'", .T.) }

oSBtnRemAll := SBUTTON():Create(oDlg5)
oSBtnRemAll:cName := "oSBtnRemAll"
oSBtnRemAll:cCaption := "Remover Todos"
oSBtnRemAll:cMsg := "Remover Todos"
oSBtnRemAll:cToolTip := "Remover Todos"
oSBtnRemAll:nLeft := 253
oSBtnRemAll:nTop := 222
oSBtnRemAll:nWidth := 52
oSBtnRemAll:nHeight := 22
oSBtnRemAll:lShowHint := .F.
oSBtnRemAll:lReadOnly := .F.
oSBtnRemAll:Align := 0
oSBtnRemAll:lVisibleControl := .T.
oSBtnRemAll:nType := 22
oSBtnRemAll:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 }
oSBtnRemAll:bAction := {|| U_ListToList(@oListCpoSel, @aQryFields, @oListCpoDis, @aCpoDis, oListCpoSel:nAt, NIL, {|x,y| x[1]+x[2] < y[1]+y[2] }, "aVar[1] + '.' + aVar[3] + Space(8) + '(' + AllTrim(aVar[7]) + ')'", .T.) }

oSBtnRem := SBUTTON():Create(oDlg5)
oSBtnRem:cName := "oSBtnRem"
oSBtnRem:cCaption := "Remover Um"
oSBtnRem:cMsg := "Remover Um"
oSBtnRem:cToolTip := "Remover Um"
oSBtnRem:nLeft := 253
oSBtnRem:nTop := 252
oSBtnRem:nWidth := 52
oSBtnRem:nHeight := 22
oSBtnRem:lShowHint := .F.
oSBtnRem:lReadOnly := .F.
oSBtnRem:Align := 0
oSBtnRem:lVisibleControl := .T.
oSBtnRem:nType := 20
oSBtnRem:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 }
oSBtnRem:bAction := {|| U_ListToList(@oListCpoSel, @aQryFields, @oListCpoDis, @aCpoDis, oListCpoSel:nAt, NIL, {|x,y| x[1]+x[2] < y[1]+y[2] }, "aVar[1] + '.' + aVar[3] + Space(8) + '(' + AllTrim(aVar[7]) + ')'", .F.) }

oGetPsqSel := TGET():Create(oDlg5)
oGetPsqSel:cName := "oGetPsqSel"
oGetPsqSel:cCaption := "Pesquisar Selecionado"
oGetPsqSel:cMsg := "Pesquisar Selecionado"
oGetPsqSel:cToolTip := "Pesquisar Selecionado"
oGetPsqSel:nLeft := 369
oGetPsqSel:nTop := 353
oGetPsqSel:nWidth := 180
oGetPsqSel:nHeight := 21
oGetPsqSel:lShowHint := .F.
oGetPsqSel:lReadOnly := .F.
oGetPsqSel:Align := 0
oGetPsqSel:cVariable := "cPesqSel"
oGetPsqSel:bWhen := {|| Len( oListCpoSel:aItems ) > 0 }
oGetPsqSel:bSetGet := {|u| If(PCount()>0,cPesqSel:=u,cPesqSel) }
oGetPsqSel:lVisibleControl := .T.
oGetPsqSel:lPassword := .F.
oGetPsqSel:lHasButton := .F.
oGetPsqSel:bValid := {|| U_WzPesqList( @oListCpoSel, @cPesqSel ) }

oSay20 := TSAY():Create(oDlg5)
oSay20:cName := "oSay20"
oSay20:cCaption := "Pesquisar:"
oSay20:nLeft := 12
oSay20:nTop := 353
oSay20:nWidth := 55
oSay20:nHeight := 17
oSay20:lShowHint := .F.
oSay20:lReadOnly := .F.
oSay20:Align := 0
oSay20:lVisibleControl := .T.
oSay20:lWordWrap := .F.
oSay20:lTransparent := .F.

oSay21 := TSAY():Create(oDlg5)
oSay21:cName := "oSay21"
oSay21:cCaption := "Pesquisar:"
oSay21:nLeft := 312
oSay21:nTop := 353
oSay21:nWidth := 53
oSay21:nHeight := 17
oSay21:lShowHint := .F.
oSay21:lReadOnly := .F.
oSay21:Align := 0
oSay21:lVisibleControl := .T.
oSay21:lWordWrap := .F.
oSay21:lTransparent := .F.

oChkTot := TCHECKBOX():Create(oDlg5)
oChkTot:cName := "oChkTot"
oChkTot:cCaption := "Totalizar"
oChkTot:cMsg := "Totalizar"
oChkTot:cToolTip := "Totalizar"
oChkTot:nLeft := 566
oChkTot:nTop := 291
oChkTot:nWidth := 70
oChkTot:nHeight := 17
oChkTot:lShowHint := .F.
oChkTot:lReadOnly := .F.
oChkTot:Align := 0
oChkTot:cVariable := "lChkTot"
oChkTot:bSetGet := {|u| If(PCount()>0,lChkTot:=u,lChkTot) }
oChkTot:lVisibleControl := .T.
oChkTot:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 .and. aQryFields[oListCpoSel:nAt,4]=="N" }
oChkTot:bValid := {|| aQryFields[oListCpoSel:nAt,4]=="N" }
oChkTot:bChange := {|| aEval( aQryFields, {|x| x[9] := If( x[4]=='N', lChkTot, x[9] ) } ) }

oGetFor := TGET():Create(oDlg5)
oGetFor:cName := "oGetFor"
oGetFor:cCaption := "Formato do Campo"
oGetFor:cMsg := "Formato do Campo"
oGetFor:cToolTip := "Formato do Campo"
oGetFor:nLeft := 566
oGetFor:nTop := 265
oGetFor:nWidth := 192
oGetFor:nHeight := 21
oGetFor:lShowHint := .F.
oGetFor:lReadOnly := .F.
oGetFor:Align := 0
oGetFor:cVariable := "cFormato"
oGetFor:bSetGet := {|u| If(PCount()>0,cFormato:=u,cFormato) }
oGetFor:lVisibleControl := .T.
oGetFor:lPassword := .F.
oGetFor:Picture := "@!"
oGetFor:lHasButton := .F.
oGetFor:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 }
oGetFor:bValid := {|| If(oListCpoSel:nAt<>0 .and. oListCpoSel:nAt<=len(aQryFields),(aQryFields[oListCpoSel:nAt,8]:=cFormato),.F.) }

oSay24 := TSAY():Create(oDlg5)
oSay24:cName := "oSay24"
oSay24:cCaption := "Formato:"
oSay24:nLeft := 566
oSay24:nTop := 245
oSay24:nWidth := 56
oSay24:nHeight := 17
oSay24:lShowHint := .F.
oSay24:lReadOnly := .F.
oSay24:Align := 0
oSay24:lVisibleControl := .T.
oSay24:lWordWrap := .F.
oSay24:lTransparent := .F.

oGetTit := TGET():Create(oDlg5)
oGetTit:cName := "oGetTit"
oGetTit:cCaption := "Tํtulo do Campo"
oGetTit:cMsg := "Tํtulo do Campo"
oGetTit:cToolTip := "Tํtulo do Campo"
oGetTit:nLeft := 566
oGetTit:nTop := 213
oGetTit:nWidth := 194
oGetTit:nHeight := 21
oGetTit:lShowHint := .F.
oGetTit:lReadOnly := .F.
oGetTit:Align := 0
oGetTit:cVariable := "cTitulo"
oGetTit:bSetGet := {|u| If(PCount()>0,cTitulo:=u,cTitulo) }
oGetTit:lVisibleControl := .T.
oGetTit:lPassword := .F.
oGetTit:lHasButton := .F.
oGetTit:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 }
oGetTit:bValid := {|| If(oListCpoSel:nAt>0 .and. oListCpoSel:nAt<=len(aQryFields),(aQryFields[oListCpoSel:nAt,7]:=cTitulo),.F.) }

oSay26 := TSAY():Create(oDlg5)
oSay26:cName := "oSay26"
oSay26:cCaption := "Tํtulo:"
oSay26:nLeft := 566
oSay26:nTop := 196
oSay26:nWidth := 70
oSay26:nHeight := 17
oSay26:lShowHint := .F.
oSay26:lReadOnly := .F.
oSay26:Align := 0
oSay26:lVisibleControl := .T.
oSay26:lWordWrap := .F.
oSay26:lTransparent := .F.


oBtn27 := TBUTTON():Create(oDlg5)
oBtn27:cName := "oBtn27"
oBtn27:cCaption := "Mover Para Cima"
oBtn27:cMsg := "Mover Para Cima"
oBtn27:cToolTip := "Mover Para Cima"
oBtn27:nLeft := 556
oBtn27:nTop := 75
oBtn27:nWidth := 130
oBtn27:nHeight := 22
oBtn27:lShowHint := .F.
oBtn27:lReadOnly := .F.
oBtn27:Align := 0
oBtn27:lVisibleControl := .F.
oBtn27:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 }
oBtn27:bAction := {|| .T. }

oBtn28 := TBUTTON():Create(oDlg5)
oBtn28:cName := "oBtn28"
oBtn28:cCaption := "Mover Para Baixo"
oBtn28:cMsg := "Mover Para Baixo"
oBtn28:cToolTip := "Mover Para Baixo"
oBtn28:nLeft := 556
oBtn28:nTop := 95
oBtn28:nWidth := 130
oBtn28:nHeight := 22
oBtn28:lShowHint := .F.
oBtn28:lReadOnly := .F.
oBtn28:Align := 0
oBtn28:lVisibleControl := .F.
oBtn28:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 }
oBtn28:bAction := {|| .T. }

oSay29 := TSAY():Create(oDlg5)
oSay29:cName := "oSay29"
oSay29:cCaption := "Campos Disponํveis"
oSay29:nLeft := 13
oSay29:nTop := 54
oSay29:nWidth := 105
oSay29:nHeight := 17
oSay29:lShowHint := .F.
oSay29:lReadOnly := .F.
oSay29:Align := 0
oSay29:lVisibleControl := .T.
oSay29:lWordWrap := .F.
oSay29:lTransparent := .F.

oSay30 := TSAY():Create(oDlg5)
oSay30:cName := "oSay30"
oSay30:cCaption := "Campos Selecionados"
oSay30:nLeft := 312
oSay30:nTop := 54
oSay30:nWidth := 115
oSay30:nHeight := 17
oSay30:lShowHint := .F.
oSay30:lReadOnly := .F.
oSay30:Align := 0
oSay30:lVisibleControl := .T.
oSay30:lWordWrap := .F.
oSay30:lTransparent := .F.

oGrp31 := TGROUP():Create(oDlg5)
oGrp31:cName := "oGrp31"
oGrp31:cCaption := "Propriedades do Campo:"
oGrp31:nLeft := 559
oGrp31:nTop := 127
oGrp31:nWidth := 208
oGrp31:nHeight := 217
oGrp31:lShowHint := .F.
oGrp31:lReadOnly := .F.
oGrp31:Align := 0
oGrp31:lVisibleControl := .T.

oChkAgrp := TCHECKBOX():Create(oDlg5)
oChkAgrp:cName := "oChkAgrp"
oChkAgrp:cCaption := "Agrupar"
oChkAgrp:cMsg := "Agrupar"
oChkAgrp:cToolTip := "Agrupar"
oChkAgrp:nLeft := 566
oChkAgrp:nTop := 315
oChkAgrp:nWidth := 70
oChkAgrp:nHeight := 17
oChkAgrp:lShowHint := .F.
oChkAgrp:lReadOnly := .F.
oChkAgrp:Align := 0
oChkAgrp:cVariable := "lChkAgrp"
oChkAgrp:bSetGet := {|u| If(PCount()>0,lChkAgrp:=u,lChkAgrp) }
oChkAgrp:lVisibleControl := .T.
oChkAgrp:bWhen := {|| Len( oListCpoSel:aItems ) > 0 .and. oListCpoSel:nAt > 0 .and. aQryFields[oListCpoSel:nAt,4]<>"N"  }
oChkAgrp:bValid := {|| aQryFields[oListCpoSel:nAt,4]<>"N" }
oChkAgrp:bChange := {|| aEval( aQryFields, {|x| x[10] := If(x[4] <> 'N', lChkAgrp, x[10] ) } ) }

oGetTipo := TGET():Create(oDlg5)
oGetTipo:cName := "oGetTipo"
oGetTipo:cCaption := "Tipo do Campo"
oGetTipo:cMsg := "Tipo do Campo"
oGetTipo:cToolTip := "Tipo do Campo"
oGetTipo:nLeft := 566
oGetTipo:nTop := 166
oGetTipo:nWidth := 194
oGetTipo:nHeight := 21
oGetTipo:lShowHint := .F.
oGetTipo:lReadOnly := .F.
oGetTipo:Align := 0
oGetTipo:cVariable := "cGetTipo"
oGetTipo:bSetGet := {|u| If(PCount()>0,cGetTipo:=u,cGetTipo) }
oGetTipo:lVisibleControl := .T.
oGetTipo:lPassword := .F.
oGetTipo:lHasButton := .F.
oGetTipo:bWhen := {|| .F. }

oSay34 := TSAY():Create(oDlg5)
oSay34:cName := "oSay34"
oSay34:cCaption := "Tipo do Campo:"
oSay34:nLeft := 566
oSay34:nTop := 146
oSay34:nWidth := 84
oSay34:nHeight := 17
oSay34:lShowHint := .F.
oSay34:lReadOnly := .F.
oSay34:Align := 0
oSay34:lVisibleControl := .T.
oSay34:lWordWrap := .F.
oSay34:lTransparent := .F.

oDlg5:Activate()

Return(cReturn)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ                     '
ฑฑบPrograma  ณWzRetTipo บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna em String o tipo do campo                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzRetTipo(cTipo)
Local cRet := ""
If cTipo == 'C' 
	cRet := 'Caractere'
ElseIf cTipo == 'D'
	cRet := 'Data'
ElseIf cTipo == 'L'
	cRet := 'L๓gico'
ElseIf cTipo == 'M'
	cRet := 'Memo'
ElseIf cTipo == 'N'
	cRet := 'Num้rico'
EndIf
Return(cRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ                     '
ฑฑบPrograma  ณWzGetCpos บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obtem os campos disponiveis para a consulta                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzGetCpos(lChkSel)
Local _nA
Local aTables := {}

aCpoDis := {}
aEval( aQryTabSel, {|x| Aadd( aTables, x[1] ) } )
For _nA := 1 To Len( aTables ) 
	SX3->( dbSetOrder( 1 ) )
	If SX3->( dbSeek( aTables[_nA] ) )
		While !SX3->( Eof() ) .and. SX3->X3_ARQUIVO == aTables[_nA]
			If lChkSel
				If SX3->X3_CONTEXT <> 'V' .AND. aScan( aQryFields, {|x| x[3] == SX3->X3_CAMPO } ) == 0
					Aadd( aCpoDis, {SX3->X3_ARQUIVO, SX3->X3_ORDEM, SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_TITULO, SX3->X3_PICTURE, .F., .F. } )
				EndIf
			Else 
				If SX3->X3_CONTEXT <> 'V'
					Aadd( aCpoDis, {SX3->X3_ARQUIVO, SX3->X3_ORDEM, SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_TITULO, SX3->X3_PICTURE, .F., .F. } )
				EndIf
			EndIf
			SX3->( dbSkip() ) 
	    EndDo
	EndIf
Next _nA
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ                     '
ฑฑบPrograma  ณWzStep6   บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Definir os Filtros ou parametros para a rotina             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzStep6()
Local oDlg6,oGrp1,oSBtnCanc,oSBtnVoltar,oSBtnAvancar,oSayMsg,oGrp6,oSBtnInc,oSBtnExc,oSBtnEdt
Local nCount	:= 0
Local cCampo	:= ''
Local cOperador:= Space(30)
Local cNomePerg:= Space(30)
Local aOperador:= {}
Local aCampos	:= {}
Local lEnd		:= .T.
Local cReturn	:= ""

Private aHeader	:= {}
Private aCols	:= {}

aAdd(aOperador,"( Igual )")
aAdd(aOperador,"( Diferente )")
aAdd(aOperador,"( Maior Que ) ")
aAdd(aOperador,"( Maior ou Igual a )")
aAdd(aOperador,"( Menor Que ) ")
aAdd(aOperador,"( Menor ou Igual a ) ")
aAdd(aOperador,"( Esta Contido em )")
aAdd(aOperador,"( Contem a Expressao )")

nOpc := 1

//MsgRun( "Calculando os Campos", "Aguarde...", {|| WzGetCpos(.F.)} )
aEval( aCpoDis, {|x| Aadd(aCampos, x[1] + '.' + x[3] + Space(8) + '(' + AllTrim(x[7]) + ')' ) } )

oDlg6 := MSDIALOG():Create()
oDlg6:cName := "oDlg6"
oDlg6:cCaption := "Assistente de Consulta (6/7) - Editar Parametros."
oDlg6:nLeft := 0
oDlg6:nTop := 0
oDlg6:nWidth := 784
oDlg6:nHeight := 465
oDlg6:lShowHint := .F.
oDlg6:lCentered := .T.

oGrp1 := TGROUP():Create(oDlg6)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 2
oGrp1:nTop := 44
oGrp1:nWidth := 772
oGrp1:nHeight := 341
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtnCanc := SBUTTON():Create(oDlg6)
oSBtnCanc:cName := "oSBtnCanc"
oSBtnCanc:cCaption := "Cancelar"
oSBtnCanc:nLeft := 580
oSBtnCanc:nTop := 400
oSBtnCanc:nWidth := 52
oSBtnCanc:nHeight := 22
oSBtnCanc:lShowHint := .T.
oSBtnCanc:lReadOnly := .F.
oSBtnCanc:Align := 0
oSBtnCanc:lVisibleControl := .T.
oSBtnCanc:nType := 2
oSBtnCanc:bAction := {|| cReturn:= "", oDlg6:End() }

oSBtnVoltar := SBUTTON():Create(oDlg6)
oSBtnVoltar:cName := "oSBtnVoltar"
oSBtnVoltar:cCaption := "Voltar"
oSBtnVoltar:nLeft := 640
oSBtnVoltar:nTop := 400
oSBtnVoltar:nWidth := 52
oSBtnVoltar:nHeight := 22
oSBtnVoltar:lShowHint := .T.
oSBtnVoltar:lReadOnly := .F.                  
oSBtnVoltar:Align := 0
oSBtnVoltar:lVisibleControl := .T.
oSBtnVoltar:nType := 22
oSBtnVoltar:bWhen := {|| .T. }
oSBtnVoltar:bAction := {|| MsgRun( "Calculando os Campos", "Aguarde...", {|| WzGetCpos(.T.)} ), cReturn:= "WzStep5()", oDlg6:End() }

oSBtnAvancar := SBUTTON():Create(oDlg6)
oSBtnAvancar:cName := "oSBtnAvancar"
oSBtnAvancar:cCaption := "Avan็ar"
oSBtnAvancar:nLeft := 700
oSBtnAvancar:nTop := 400
oSBtnAvancar:nWidth := 52
oSBtnAvancar:nHeight := 22
oSBtnAvancar:lShowHint := .T.
oSBtnAvancar:lReadOnly := .F.
oSBtnAvancar:Align := 0
oSBtnAvancar:lVisibleControl := .T.
oSBtnAvancar:nType := 21
oSBtnAvancar:bWhen := {|| .T. }
oSBtnAvancar:bAction := {|| lEnd:=U_WzConvQry(), If(lEnd, Gravar(), .F.), If(lEnd, {|| cReturn:= "", oDlg6:End()}, .F.)}

oSayMsg := TSAY():Create(oDlg6)
oSayMsg:cName := "oSayMsg"
oSayMsg:cCaption := "Defina os parโmetros para a consulta, os parโmetros sใo questionados antes de executar a consulta permitindo ao usuario definir seus valores."
oSayMsg:nLeft := 9
oSayMsg:nTop := 7
oSayMsg:nWidth := 755
oSayMsg:nHeight := 34
oSayMsg:lShowHint := .F.
oSayMsg:lReadOnly := .F.
oSayMsg:Align := 0
oSayMsg:lVisibleControl := .T.
oSayMsg:lWordWrap := .T.
oSayMsg:lTransparent := .F.

oGrp6 := TGROUP():Create(oDlg6)
oGrp6:cName := "oGrp6"
oGrp6:cCaption := "Parametros"
oGrp6:nLeft := 68
oGrp6:nTop := 60
oGrp6:nWidth := 652
oGrp6:nHeight := 282
oGrp6:lShowHint := .F.
oGrp6:lReadOnly := .F.
oGrp6:Align := 0
oGrp6:lVisibleControl := .T.

oSBtnInc := SBUTTON():Create(oDlg6)
oSBtnInc:cName := "oSBtnInc"
oSBtnInc:cCaption := "Incluir"
oSBtnInc:nLeft := 68
oSBtnInc:nTop := 350
oSBtnInc:nWidth := 52
oSBtnInc:nHeight := 22
oSBtnInc:lShowHint := .T.
oSBtnInc:lReadOnly := .F.
oSBtnInc:Align := 0
oSBtnInc:lVisibleControl := .T.
oSBtnInc:nType := 16
oSBtnInc:bWhen := {|| .T. }
oSBtnInc:bLClicked := {|| .T. }
oSBtnInc:bAction := {|| WzGravaPerg(cCampo, cOperador, cNomePerg) }

oSBtnExc := SBUTTON():Create(oDlg6)
oSBtnExc:cName := "oSBtnExc"
oSBtnExc:cCaption := "Excluir"
oSBtnExc:cToolTip := "Excluir"
oSBtnExc:nLeft := 128
oSBtnExc:nTop := 350
oSBtnExc:nWidth := 52
oSBtnExc:nHeight := 22
oSBtnExc:lShowHint := .T.
oSBtnExc:lReadOnly := .F.
oSBtnExc:Align := 0
oSBtnExc:lVisibleControl := .T.
oSBtnExc:nType := 3
oSBtnExc:bWhen := {|| .T. }
oSBtnExc:bLClicked := {|| .T. }
oSBtnExc:bAction := {|| WzDelPar( n ) }

oCboCpo := TCOMBOBOX():Create(oDlg6)
oCboCpo:cName := "oCboCpo"
oCboCpo:cCaption := "Campos:"
oCboCpo:cMsg := "Campos:"
oCboCpo:cToolTip := "Campos"
oCboCpo:nLeft := 78
oCboCpo:nTop := 93
oCboCpo:nWidth := 224
oCboCpo:nHeight := 21
oCboCpo:lShowHint := .F.
oCboCpo:lReadOnly := .F.                  
oCboCpo:Align := 0
oCboCpo:cVariable := "cCampo"
oCboCpo:bSetGet := {|u| If(PCount()>0,cCampo:=u,cCampo) }
oCboCpo:lVisibleControl := .T.
oCboCpo:aItems := aCampos
oCboCpo:nAt := 1
oCboCpo:bWhen := {|| .T. }
oCboCpo:bLClicked := {|| .T. }
oCboCpo:bChange := {|| .T. }

oCboOper := TCOMBOBOX():Create(oDlg6)
oCboOper:cName := "oCboOper"
oCboOper:cCaption := "Operador"
oCboOper:cMsg := "Operador"
oCboOper:cToolTip := "Operador"
oCboOper:nLeft := 307
oCboOper:nTop := 93
oCboOper:nWidth := 145
oCboOper:nHeight := 21
oCboOper:lShowHint := .F.
oCboOper:lReadOnly := .F.
oCboOper:Align := 0
oCboOper:cVariable := "cOperador"
oCboOper:bSetGet := {|u| If(PCount()>0,cOperador:=u,cOperador) }
oCboOper:lVisibleControl := .T.
oCboOper:aItems := aOperador
oCboOper:nAt := 0
oCboOper:bWhen := {|| .T. }
oCboOper:bLClicked := {|| .T. }
oCboOper:bChange := {|| .T. }

oSayCpo := TSAY():Create(oDlg6)
oSayCpo:cName := "oSayCpo"
oSayCpo:cCaption := "Campos:"
oSayCpo:nLeft := 78
oSayCpo:nTop := 75
oSayCpo:nWidth := 65
oSayCpo:nHeight := 17
oSayCpo:lShowHint := .F.
oSayCpo:lReadOnly := .F.
oSayCpo:Align := 0
oSayCpo:lVisibleControl := .T.
oSayCpo:lWordWrap := .F.
oSayCpo:lTransparent := .F.

oSayOpe := TSAY():Create(oDlg6)
oSayOpe:cName := "oSayOpe"
oSayOpe:cCaption := "Operadores"
oSayOpe:nLeft := 307
oSayOpe:nTop := 75
oSayOpe:nWidth := 65
oSayOpe:nHeight := 17
oSayOpe:lShowHint := .F.
oSayOpe:lReadOnly := .F.
oSayOpe:Align := 0
oSayOpe:lVisibleControl := .T.
oSayOpe:lWordWrap := .F.
oSayOpe:lTransparent := .F.

oGetPar := TGET():Create(oDlg6)
oGetPar:cName := "oGetPar"
oGetPar:cCaption := "Pergunta"
oGetPar:cMsg := "Pergunta"
oGetPar:cToolTip := "Pergunta"
oGetPar:nLeft := 460
oGetPar:nTop := 93
oGetPar:nWidth := 131
oGetPar:nHeight := 21
oGetPar:lShowHint := .F.
oGetPar:lReadOnly := .F.
oGetPar:Align := 0
oGetPar:cVariable := "cNomePerg"
oGetPar:bSetGet := {|u| If(PCount()>0,cNomePerg:=u,cNomePerg) }
oGetPar:lVisibleControl := .T.
oGetPar:lPassword := .F.
oGetPar:Picture := "@!"
oGetPar:lHasButton := .F.
oGetPar:bWhen := {|| .T. }

oSayPar := TSAY():Create(oDlg6)
oSayPar:cName := "oSayPar"
oSayPar:cCaption := "Pergunta ?"
oSayPar:nLeft := 460
oSayPar:nTop := 75
oSayPar:nWidth := 65
oSayPar:nHeight := 17
oSayPar:lShowHint := .F.
oSayPar:lReadOnly := .F.
oSayPar:Align := 0
oSayPar:lVisibleControl := .T.
oSayPar:lWordWrap := .F.
oSayPar:lTransparent := .F.

Aadd(aHeader, { "Campo",;			//Titulo
					"X3_CAMPO",;	//Campo
					"@!",;			//Mascara (Picture)
					10,;			//Tamanho
					0,;				//Decimal
					"",;			//Valid
					"ว",;			//Usado
					"C",;			//Tipo
					"SX3",;			//ARQUIVO
					"" } )			//Contexto

Aadd(aHeader, { "Operador",;	//Titulo
					" ",;	//Campo
					"@!",;			//Mascara (Picture)
					10,;			//Tamanho
					0,;				//Decimal
					"",;			//Valid
					"ว",;			//Usado
					"C",;			//Tipo
					"",;			//ARQUIVO
					"" } )			//Contexto

Aadd(aHeader, { "Pergunta",;//Titulo
					"X1_PERGUNT",;		//Campo
					"",;		//Mascara (Picture)
					30,;			//Tamanho
					0,;				//Decimal
					"",;			//Valid
					"ว",;			//Usado
					"C",;			//Tipo
					"SX1",;			//ARQUIVO
					"" } )			//Contexto

If Len( aQryPergs ) > 0
	aCols:={}
	aEval( aQryPergs, {|x| Aadd( aCols, {x[1], x[3], x[4], .F. } ) } )
Else
	Aadd( aCols, {Space(10), Space(10), Space(30), .F.} )
EndIf
oGetd:=MsGetDados():New(68,40,165,355,nOpc,"AllWaysTrue()","AllWaysTrue()",,.T.,,1,,)
oDlg6:Activate()
Return(cReturn)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzGravaPergAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava as perguntas no acols de selecao                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzGravaPerg(cCampo, cOperador, cPergunta)
Local nPosCpo 	:= aScan( aCpoDis, {|x| x[3] == Substr( cCampo, 5, 10 )} )
Local aIncCH	:= {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',;
					'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z'}
Local cDesOper  := cOperador

cOperador := Upper( AllTrim( cOperador ) ) 
cOperador := StrTran( cOperador, "( ", "" )
cOperador := StrTran( cOperador, " )", "" )

If cOperador == "IGUAL"
	cOperador := '='
ElseIf cOperador == "DIFERENTE"
	cOperador := '<>'
ElseIf cOperador == "MAIOR QUE"
	cOperador := '>'
ElseIf cOperador == "MAIOR OU IGUAL A"
	cOperador := '>='
ElseIf cOperador == "MENOR QUE"
	cOperador := '<'
ElseIf cOperador == "MENOR OU IGUAL A"
	cOperador := '<='
ElseIf cOperador == "ESTA CONTIDO EM"
	cOperador := '$'
ElseIf cOperador == "CONTEM A EXPRESSAO"
	cOperador := '&'
EndIf

If nPosCpo > 0 .and. nPosCpo <= Len( aCpoDis  ) 
	Aadd( aQryPergs, {	AllTrim( aCpoDis[nPosCpo, 3] ),;
						StrZero(Len( aQryPergs )+1,2),;
						cOperador,;
						cPergunta,;
						'MV_CH' + aIncCh[If(Len( aQryPergs )+1<=Len(aIncCh),	Len( aQryPergs )+1, 1)],;
						aCpoDis[nPosCpo, 4],;
						aCpoDis[nPosCpo, 5],; 
						aCpoDis[nPosCpo, 6],;
						"G",;
						'MV_PAR' + StrZero(Len( aQryPergs )+1,2),;
						AllTrim( aCpoDis[nPosCpo, 1] ),;
						" " } )
							
//	aQryPergs := aSort( aQryPergs,,,{|x,y| x[1]+x[2] < y[1]+y[2] } )
EndIf
aCols:={}
aEval( aQryPergs, {|x| Aadd( aCols, {x[1], x[3], x[4], .F. } ) } )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzView    บAutor  ณEvaldo V. Batista   บ Data ณ  28/02/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Demonstra o resultado da Query Solicitada                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7.10                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function WzView(cAlias)
Local oDlgView,oGrp1,oSBtnTxt,oSBtnOk
Local cCarga 		:= '{'
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private aHeader 	:= {}
Private aCols		:= {}

//Para Dimencionar o Tamanho da Tela
aSize := MsAdvSize()
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )


SX3->( dbSetOrder( 2 ) ) 
aEval( aQryFields, {|x| SX3->( dbSeek(x[3]) ), Aadd( aHeader, {x[7], x[3], x[8], x[5], x[6], SX3->X3_VALID, "ว", x[4], x[1], SX3->X3_CONTEXT}, cCarga += cAlias+'->'+x[3]+', ' ) } )
cCarga += '.F. }'

MsgRun('Carregando a Tabela para visualiza็ใo !', 'Aguarde', {|| ProcCarga(cAlias, cCarga)})
oDlgView := MSDIALOG():Create()
oDlgView:cName := "oDlgView"
oDlgView:cCaption := "Visualiza็ใo da Consulta"
oDlgView:nLeft := 0
oDlgView:nTop := aSize[7]
oDlgView:nWidth := aSize[5]
oDlgView:nHeight := aSize[6]-80
oDlgView:lShowHint := .F.
oDlgView:lCentered := .T.

oGrp1 := TGROUP():Create(oDlgView)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 345
oGrp1:nTop := 111
oGrp1:nWidth := 185
oGrp1:nHeight := 41
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtnTxt := SBUTTON():Create(oDlgView)
oSBtnTxt:cName := "oSBtnTxt"
oSBtnTxt:cCaption := "Gerar Arquivo Texto"
oSBtnTxt:cMsg := "Gerar Arquivo Texto"
oSBtnTxt:cToolTip := "Gerar Arquivo Texto"
oSBtnTxt:nLeft := aSize[5]-140
oSBtnTxt:nTop := aSize[6]-140
oSBtnTxt:nWidth := 57
oSBtnTxt:nHeight := 27
oSBtnTxt:lShowHint := .F.
oSBtnTxt:lReadOnly := .F.
oSBtnTxt:Align := 0
oSBtnTxt:lVisibleControl := .T.
oSBtnTxt:nType := 13
oSBtnTxt:bLClicked := {|| .T. }
oSBtnTxt:bAction := {|| GravaTxt(cAlias) }

oSBtnOk := SBUTTON():Create(oDlgView)
oSBtnOk:cName := "oSBtnOk"
oSBtnOk:cCaption := "Finaliza"
oSBtnOk:nLeft := aSize[5]-75
oSBtnOk:nTop := aSize[6]-140
oSBtnOk:nWidth := 57
oSBtnOk:nHeight := 27
oSBtnOk:lShowHint := .F.
oSBtnOk:lReadOnly := .F.
oSBtnOk:Align := 0
oSBtnOk:lVisibleControl := .T.
oSBtnOk:nType := 1
oSBtnOk:bAction := {|| oDlgView:End() }


oGetd:=MsGetDados():New(3,3,aPosObj[2,3],aPosObj[2,4]-3,nOpc,"AllWaysTrue()","AllWaysTrue()",,.T.,,1,,)
oDlgView:Activate()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSQRYAUT   บAutor  ณMicrosiga           บ Data ณ  06/27/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcCarga(cAlias, cCarga)
(cAlias)->( dbGoTop() ) 
While !(cAlias)->( Eof() ) 
	Aadd( aCols, &(cCarga) )
	(cAlias)->( dbSkip() ) 
EndDo
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSQRYAUT   บAutor  ณMicrosiga           บ Data ณ  06/27/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GravaTxt(cAlias)
Local cTipo 	:= 'Arquivo Texto (*.TXT) |*.TXT|'
Local cQryArq 	:= "" //cGetFile(cTipo,"Informe o Nome do Arquivo a ser Gerado!")
Local aRegs		:= {{"SQRYTP","01","Tipo do Arquivo        ?","Tipo do Arquivo        ?","Tipo do Arquivo         ?","mv_ch1","N",1,0,0,"C","","MV_PAR01","TXT Largura Fixa","TXT Largura Fixa","TXT Largura Fixa","","","TXT Delimitado","TXT Delimitado","TXT Delimitado","","","Excel","Excel","Excel","","","","","","","","","","","","","","",""}}
Local lOk		:= .T.
ErrorBlock({|e| lOk := .F., MsgAlert(e:description) })

ValidPerg( aRegs, aRegs[1,1])
Pergunte( aRegs[1,1], .F. )
If Pergunte( aRegs[1,1], .T. )
	If Mv_Par01 <= 2
		cQryArq := cGetFile(cTipo,"Informe o Nome do Arquivo a ser Gerado!")
		If !Empty( cQryArq )
			If !( '.TXT' $ cQryArq ) 
				cQryArq += '.TXT'
			EndIf
			MsgRun('Aguarde enquanto o arquivo ' + cQryArq + ' ้ gravado...', 'Gravando o Arquivo TXT', {|| ProcTxt(cAlias, Mv_Par01, cQryArq)})
			If File( cQryArq ) .and. lOk
				MsgAlert( 'Arquivo ' + cQryArq + ' Gravado com Sucesso', 'Confirma็ใo de Opera็ใo...' )
			Else
				MsgAlert( 'Problemas na Grava็ใo do Arquivo, o arquivo nใo foi criado !', 'Erro!' )
			EndIf
		EndIf
	Else
		MsgRun('Aguarde enquanto o arquivo Excel ้ gerado...', 'Gravando a planilha Excel', {|| ProcExcel(cAlias)})
	EndIf
Else
	MsgAlert( 'Nenhum arquivo foi definido para ser salvo', 'Opera็ใo Cancelada' )
EndIF
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcTxt   บAutor  ณEvaldo V. Batista   บ Data ณ  06/27/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Arquivo Texto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcTxt(cAlias, nOpcTxt, cDestino)
Local cArqTmp	:= CriaTrab( Nil,.F.)
dbSelectArea( cAlias )
If nOpcTxt == 1 //Largura Fixa
	Copy To &(cArqTmp)
	dbUseArea( .T.,, cArqTmp, cArqTmp, .F., .F. )
	dbSelectArea( cArqTmp  ) 
	Copy To &(cDestino) SDF
	(cArqtmp)->( dbCloseArea() ) 
	fErase( cArqTmp + '.DBF' ) 
Else //Delimitado
	Copy To &(cDestino) DELIMITED
EndIf
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWzDelPar  บAutor  ณMicrosiga           บ Data ณ  06/27/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Remove parametros informados                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function WzDelPar(nPos)
Local nTam := 0
If nPos > 0 .and. nPos <= Len( aQryPergs ) 
	If MsgYesNo( 'Confirma a exclusao do Parametro ?', 'Confirma็ใo de Opera็ใo...' )
		aDel( aQryPergs, nPos)
		nTam := Len( aQryPergs ) - 1 
		aSize( aQryPergs, nTam )
	EndIf
EndIF
aCols:={}
aEval( aQryPergs, {|x| Aadd( aCols, {x[1], x[3], x[4], .F. } ) } )
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcExcel บAutor  ณEvaldo V. Batista   บ Data ณ  01/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Arquivo Excel                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ProcExcel(cAlias)
Local oExcelApp
Local cArqTmp		:= CriaTrab( Nil,.F.)
Local cNomArqDes 	:= ""
LOCAL cDirDocs   	:= MsDocPath() 
Local cPath			:= AllTrim(GetTempPath())

dbSelectArea( cAlias )

Copy To &(cDirDocs+"\"+cArqTmp+".XLS")

CpyS2T( cDirDocs+"\"+cArqTmp+".XLS" , cPath, .T. )

Ferase(cDirDocs+"\"+cArqTmp+".XLS")
//Copy To &(cDestino)

If ApOleClient( 'MsExcel' )
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArqTmp+".XLS" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgStop( "Microsoft Excel Nใo Instalado" ) 
EndIf

Return
