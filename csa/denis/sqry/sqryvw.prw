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
User Function SQryVw()
Private cQryArq			:= Space(15)
Private cArqView		:= Space(15)
Private cQryName		:= ""
Private cQryDesc		:= Space(60)
Private cQryAlias		:= ""
Private cQryPerg		:= ""
Private cQryTabPri	:= Space(40)
Private nQryOpc		:= 0
Private nListDis		:= 0
Private aVarSav		:= {	'cQryArq', 'cQryName', 'cQryDesc', 'cQryAlias', 'cQryPerg','cQryTabPri',;
									'aQryTabSel', 'aQryTabRel', 'aQryFields','aQryGroup','aQryOrder','aQryQuebras','aQryFilters','aQryPergs' }
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
WzStep1()
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

oDlg1 := MSDIALOG():Create()
oDlg1:cName := "oDlg1"
oDlg1:cCaption := "Assistente de Visualiza็ใo de Consulta (1/2) - Escolha sua Op็ใo"
oDlg1:nLeft := 0
oDlg1:nTop := 0
oDlg1:nWidth := 784
oDlg1:nHeight := 464
oDlg1:lShowHint := .F.
oDlg1:lCentered := .T.

oSay := TSAY():Create(oDlg1)
oSay:cName := "oSay"
oSay:cCaption := "Escolha uma das Op็๕es e clique em avan็ar!"
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
oRadio:aItems := { "Abrir Consulta Existente"}

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
oSBtnAvc:bAction := {|| If( sQryOpc(nQryOpc), ( If(oRadio:nOption==1, (oDlg1:End(), WzStep2()), .F. ) ), .F.)   } //oDlg1:End() }

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
oSBtnVoltar:bAction := {|| oDlg1:End() }

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
oSBtnCanc:bAction := {|| oDlg1:End() }

oDlg1:Activate()

Return


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
If nOpc <> 0
	cQryArq := cGetFile(cTipo,"Abrir Consulta Existente.")
	If !Empty( cQryArq )
		cArqView := cQryArq
		aEval( aVarSav, {|x| &( If(Upper(Substr(x,1,1))=='A', x+' := {}', '') ) } )
		U_TxtToArry( cQryArq )
	Else
		cQryArq := Space(15)
		Aviso("Opera็ใo Abortada","Nenhum Arquivo foi Selecionado !",{"Ok"})
		lRetOpc := .F.
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

oDlg2 := MSDIALOG():Create()
oDlg2:cName := "oDlg2"
oDlg2:cCaption := "Assistente Visualiza็ใo de Consulta (2/2) - Informa็๕es da Consulta."
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
oSBtnCanc:bAction := {|| oDlg2:End() }

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
oSBtnVoltar:bAction := {|| oDlg2:End(), WzStep1() }

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
oSBtnAvancar:bAction := {|| lEnd:=U_WzConvQry(), If(lEnd, Gravar(), .F.), If(lEnd, oDlg2:End(), .F.) }

oSayMsg := TSAY():Create(oDlg2)
oSayMsg:cName := "oSayMsg"
oSayMsg:cCaption := "Estas sใo as informa็๒es de detalhe da consulta... Para executar clique em avan็ar !"
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
oQryArq:lReadOnly := .T.
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
oSay8:lReadOnly := .T.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .F.

oGet8 := TGET():Create(oDlg2)
oGet8:cName := "oGet8"
oGet8:cCaption := "Descri็ใo do Arquivo"
oGet8:nLeft := 230
oGet8:nTop := 195
oGet8:nWidth := 306
oGet8:nHeight := 21
oGet8:lShowHint := .F.
oGet8:lReadOnly := .T.
oGet8:Align := 0
oGet8:cVariable := "cQryDesc"
oGet8:bSetGet := {|u| If(PCount()>0,cQryDesc:=u,cQryDesc) }
oGet8:lVisibleControl := .T.
oGet8:Picture := "@!"
oGet8:lPassword := .F.
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
Return

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
If !Empty( cArqView )
	cTxtSav := ""                                            	
	aEval( aVarSav, {|x| cTxtSav += U_ArrayToTxt( x ) } )    	
	If !( ".SCA" $ Upper( cArqView ) ) 
		cArqView += '.SCA'
	EndIf
	MemoWrit( AllTrim(cArqView), cTxtSav )               
EndIf
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
