#Include "Fivewin.ch"
#Include "TopConn.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁRFINA98   ╨Autor  ЁJaime Wikanski      ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRotina de conciliacao de cartoes de credito                 ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё  C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function RFINA98()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cPerg		:= "RFNA98"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Exibe parametros da rotina	        												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return()
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define a operacao a ser processada 												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If MV_PAR01 == 1
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Operacao de Venda                    												Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	ConcVenda()
ElseIf MV_PAR01 == 2
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Operacao de Liquidacoes              												Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	U_RFINA98A()
ElseIf MV_PAR01 == 3
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Operacao de Ajuste                   												Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	U_RFINA98B()
Endif

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁConcVenda ╨Autor  ЁJaime Wikanski      ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRotina de conciliacao de cartoes de credito                 ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function ConcVenda()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea     		:= GetArea()
Local aPosObj   		:= {}
Local aObjects  		:= {}
Local aSize     		:= {}
Local aInfo     		:= {}
Local aTitles   		:= {OemToAnsi("Conciliadas"),OemToAnsi("Conciliadas Parcialmente"),OemToAnsi("Conciliadas Manualmente"),OemToAnsi("Nao Conciliadas"),OemToAnsi("Totais")}
Local nX        		:= 0
Local nOpcA     		:= 0
Local cCadastro 		:= OemToAnsi("Conciliacao de Cartao de Credito - Vendas")
Local aTitConc			:= {"","C.R.","Maquineta","Estabelecimento","Total Compra","Vl Operacao","NSU","Nr. Cartao","Vlr Liquido","Dt Emissao","Nr. Parcela","Qtd. Parcela","Cod.Adm.","Nome Adm.","Cupom Venda","Dt Credito","Desconto","Prefixo","No. Titulo","Tipo","Cliente","Loja","Nome Cliente","DT Emissao","Vencimento","Vencto real","Tp. Operacao","Tp. Cartao"}
Local aTitPConc		:= {"","C.R.","Maquineta","Estabelecimento","Total Compra","Vl Operacao","NSU","Nr. Cartao","Vlr Liquido","Dt Emissao","Nr. Parcela","Qtd. Parcela","Cod.Adm.","Nome Adm.","Cupom Venda","Dt Credito","Desconto","Prefixo","No. Titulo","Tipo","Cliente","Loja","Nome Cliente","DT Emissao","Vencimento","Vencto real","Tp. Operacao","Tp. Cartao"}
Local aTitMConc		:= {"","C.R.","Maquineta","Estabelecimento","Total Compra","Vl Operacao","NSU","Nr. Cartao","Vlr Liquido","Dt Emissao","Nr. Parcela","Qtd. Parcela","Cod.Adm.","Nome Adm.","Cupom Venda","Dt Credito","Desconto","Prefixo","No. Titulo","Tipo","Cliente","Loja","Nome Cliente","DT Emissao","Vencimento","Vencto real","Tp. Operacao","Tp. Cartao"}
Local aTitSitef		:= {"","Maquineta","Estabelecimento","Vlr. Compra","Nro. NSU","Nro. Cartao","Data Transacao","Total Parcelas","Cod.Adm.","Nome Adm.","Nro PDV","NSU Sitef","Estado Oper","Cod Transacao","Cod Resposta","Hr Transacao","Cod Autorizacao","Nro Cancelamento"}
Local aTitOper			:= {"","C.R.","Maquineta","Estabelecimento","Total Compra","Vl Operacao","NSU","Nr. Cartao","Vlr Liquido","Dt Emissao","Nr. Parcela","Qtd. Parcela","Cod.Adm.","Nome Adm.","Cupom Venda","Dt Credito","Desconto","Prefixo","No. Titulo","Tipo","Cliente","Loja","Nome Cliente","DT Emissao","Vencimento","Vencto real","Tp. Operacao","Tp. Cartao"}
Local aTitInd			:= {" ","Indicador","Operadora","Sitef"," ","Indicador","Operadora","Sitef"," ","Indicador","Operadora","Sitef"}
Local aTitTot			:= {"Dia","Conciliado","Conc. Parc.","Conc. Manual","Nao Conc. Operadora","Nao Conc. Sitef"}
Local oDlg                                                             
Local aButtons 		:= {{"",{||},""},{"S4WB011N",{|| PesqList()},"Pesquisar"},{"AUTOM",{|| FiltraList()},"Filtrar"},{"PRODUTO",{|| VisualSit(cAliasAtu)},OemtoAnsi("Visualizar Conciliacao")},{"",{||},""}}
Private oLBoxConc
Private oLBoxMConc
Private oLBoxPConc
Private oLBoxInd
Private oLBoxTot
Private oLBoxSitef
Private oLBoxOper  
Private oFolder 
Private oBtn1
Private oBtn2
Private oBtn3
Private oBtn4
Private oBtn5
Private oBtn6
Private oBtn7
Private oBtn8
Private aListInd  	:= {{.t.,OemtoAnsi("Nro. Cartao"),"","",.t.,"Valor",Transform(0.00,"@E 9,999,999.99"),Transform(0.00,"@E 9,999,999.99"),.t.,"Administradora","",""},{.t.,"Nro. Compr.","","",.t.,OemtoAnsi("Emissao"),"","",.t.,"Total Parcelas","",""}}
Private aListTot  	:= {}
Private oVerde   		:= LoadBitMap(GetResources(),"BR_VERDE")
Private oVermelho		:= LoadBitMap(GetResources(),"BR_VERMELHO")
Private oAmarelo 		:= LoadBitMap(GetResources(),"BR_AMARELO")
Private oAzul 			:= LoadBitMap(GetResources(),"BR_AZUL")
Private oOk      		:= LoadBitMap(GetResources(),"LBOK")
Private oNo      		:= LoadBitMap(GetResources(),"LBNO")
Private cArqConc		:= ""
Private cArqPConc		:= ""
Private cArqMConc		:= ""
Private cArqSitef		:= ""
Private cMovSitef		:= ""
Private cIndSit1		:= ""
Private cIndSit2		:= ""
Private cIndSit3		:= ""
Private cIndSit4		:= ""
Private cArqOper		:= ""
Private aIndSitef		:= {}
Private aIndOper		:= {}
Private aIndConc		:= {}
Private aIndPConc		:= {}
Private aIndMConc		:= {}
Private cListAtu		:= "oLBoxConc"
Private cAliasAtu		:= "cArqConc"
Private aTela[0][0]
Private aGets[0]

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria os arquivos temporarios utilizados nos ListBox  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
MsAguarde({||CriaTmp()},"Criando arquivos de trabalho...")


//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta arrays dos dadoss das conciliacoees            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
Processa({|| GeraArqTmp()},OemtoAnsi("Conciliacao"))
                         
//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Faz o calculo automatico de dimensoes de objetos     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
aSize 	:= U_MsAdvSize(,.F.,0,0)
AAdd( aObjects, { 100, 100, .T., .T. } )
aInfo 	:= {aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3}
aPosObj 	:= U_MsObjSize(aInfo, aObjects,.T.)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a janela de exibicao dos dados                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta os Folders                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
oFolder 					:= TFolder():New(aPosObj[1,1],aPosObj[1,2],aTitles,{"",""},oDlg,,,,.T.,.F.,aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1])
oFolder:bSetOption	:= {|nAtu| TrocaFolder(nAtu)}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o ListBox das Conciliacoes                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cArqConc")
@ aPosObj[1,1]-15,aPosObj[1,2] ;
	LISTBOX oLBoxConc VAR cLBoxConc ;
	Fields	Iif(cArqConc->MARCA == "S", oOk, oNo),;
				Iif(Empty(cArqConc->PBC_TITULO),oVerde,oAmarelo),;
				cArqConc->PBC_CODMAQ,;
				Tabela("P7",Posicione("PAB",2,xFilial("PAB")+cArqConc->PBC_CODADM+Space(1)+cArqConc->PBC_CODMAQ,"PAB_LOJA"),.f.),;
				Transform(cArqConc->PBC_TOTCOM,"@E 9,999,999.99"),;
				Transform(cArqConc->PBC_VLBRUT,"@E 9,999,999.99"),;
				cArqConc->PBC_NCV,;
				cArqConc->PBC_CARTAO,;                
				Transform(cArqConc->PBC_VLLIQ,"@E 9,999,999.99"),;
				cArqConc->PBC_EMISS,;
				cArqConc->PBC_PARCEL,;
				cArqConc->PBC_TOTPAR,;
				cArqConc->PBC_CODADM,;
				Posicione("SAE",1,xFilial("SAE")+cArqConc->PBC_CODADM,"AE_DESC"),;
				cArqConc->PBC_NRV,;
				cArqConc->PBC_CREDIT,;
				Transform(cArqConc->PBC_VLDESC,"@E 9,999,999.99"),;
				cArqConc->PBC_PREFIX,;
				cArqConc->PBC_TITULO,;
				cArqConc->PBC_TIPTIT,;
				cArqConc->PBC_CLIENT,;
				cArqConc->PBC_LOJA,;
				cArqConc->PBC_NOMCLI,;
				cArqConc->PBC_EMISSA,;
				cArqConc->PBC_VENORI,;
				cArqConc->PBC_VENCTO,;
				cArqConc->PBC_TPOPER,;
				cArqConc->PBC_TPCART ;
	HEADER aTitConc[01],aTitConc[02],aTitConc[03],aTitConc[04],;
	       aTitConc[05],aTitConc[06],aTitConc[07],aTitConc[08],;
	       aTitConc[09],aTitConc[10],aTitConc[11],aTitConc[12],;
	       aTitConc[13],aTitConc[14],aTitConc[15],aTitConc[16],;
	       aTitConc[17],aTitConc[18],aTitConc[19],aTitConc[20],;
	       aTitConc[21],aTitConc[22],aTitConc[23],aTitConc[24],;
	       aTitConc[25],aTitConc[26],aTitConc[27],aTitConc[28] ;
	 OF oFolder:aDialogs[1] PIXEL SIZE  aPosObj[1,4]-aPosObj[1,2]-10, aPosObj[1,3]-aPosObj[1,1]-34 ;
    ON DBLCLICK (cArqConc->(RecLock("cArqConc",.F.)),cArqConc->MARCA := Iif(cArqConc->MARCA == "S"," ","S"),cArqConc->(MsUnlock()),oLBoxConc:Refresh(.T.)) //NOSCROLL
@ aPosObj[1,3]-45,aPosObj[1,4]-90 	BUTTON  oBtn1	PROMPT "Descartar" 	SIZE 35,15 ACTION Descartar() 				When cArqConc->(RecCount()) > 0	OF oFolder:aDialogs[1] PIXEL
@ aPosObj[1,3]-45,aPosObj[1,4]-50 	BUTTON  oBtn2	PROMPT "Estornar" 	SIZE 35,15 ACTION EstMan("cArqConc") 		When cArqConc->(RecCount()) > 0	OF oFolder:aDialogs[1] PIXEL
oLBoxConc:bGotFocus := {|| (cListAtu := "oLBoxConc",cAliasAtu := "cArqConc")}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o ListBox das Conciliacoes Parciais            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cArqPConc")
@ aPosObj[1,1]-15,aPosObj[1,2] ;
	LISTBOX oLBoxPConc VAR cLBoxPConc ;
	Fields	Iif(cArqPConc->MARCA == "S", oOk, oNo),;
				Iif(Empty(cArqPConc->PBC_TITULO),oVerde,oAmarelo),;
				cArqPConc->PBC_CODMAQ,;
				Tabela("P7",Posicione("PAB",2,xFilial("PAB")+cArqPConc->PBC_CODADM+Space(1)+cArqPConc->PBC_CODMAQ,"PAB_LOJA"),.f.),;
				Transform(cArqPConc->PBC_TOTCOM,"@E 9,999,999.99"),;
				Transform(cArqPConc->PBC_VLBRUT,"@E 9,999,999.99"),;
				cArqPConc->PBC_NCV,;
				cArqPConc->PBC_CARTAO,;                
				Transform(cArqPConc->PBC_VLLIQ,"@E 9,999,999.99"),;
				cArqPConc->PBC_EMISS,;
				cArqPConc->PBC_PARCEL,;
				cArqPConc->PBC_TOTPAR,;
				cArqPConc->PBC_CODADM,;
				Posicione("SAE",1,xFilial("SAE")+cArqPConc->PBC_CODADM,"AE_DESC"),;
				cArqPConc->PBC_NRV,;
				cArqPConc->PBC_CREDIT,;
				Transform(cArqPConc->PBC_VLDESC,"@E 9,999,999.99"),;
				cArqPConc->PBC_PREFIX,;
				cArqPConc->PBC_TITULO,;
				cArqPConc->PBC_TIPTIT,;
				cArqPConc->PBC_CLIENT,;
				cArqPConc->PBC_LOJA,;
				cArqPConc->PBC_NOMCLI,;
				cArqPConc->PBC_EMISSA,;
				cArqPConc->PBC_VENORI,;
				cArqPConc->PBC_VENCTO,;
				cArqPConc->PBC_TPOPER,;
				cArqPConc->PBC_TPCART ;
	HEADER aTitPConc[01],aTitPConc[02],aTitPConc[03],aTitPConc[04],;
	       aTitPConc[05],aTitPConc[06],aTitPConc[07],aTitPConc[08],;
	       aTitPConc[09],aTitPConc[10],aTitPConc[11],aTitPConc[12],;
	       aTitPConc[13],aTitPConc[14],aTitPConc[15],aTitPConc[16],;
	       aTitPConc[17],aTitPConc[18],aTitPConc[19],aTitPConc[20],;
	       aTitPConc[21],aTitPConc[22],aTitPConc[23],aTitPConc[24],;
	       aTitPConc[25],aTitPConc[26],aTitPConc[27],aTitPConc[28] ;
	 OF oFolder:aDialogs[2] PIXEL SIZE  aPosObj[1,4]-aPosObj[1,2]-10, aPosObj[1,3]-aPosObj[1,1]-70 ;
    ON DBLCLICK (cArqPConc->(RecLock("cArqPConc",.F.)),cArqPConc->MARCA := Iif(cArqPConc->MARCA == "S"," ","S"),cArqPConc->(MsUnlock()),oLBoxPConc:Refresh(.T.)) //NOSCROLL
oLBoxPConc:bGotFocus 	:= {|| (cListAtu := "oLBoxPConc",cAliasAtu := "cArqPConc")}
oLBoxPConc:bChange 		:= {|| AtuInd()}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o ListBox dos indicadores da conc parcial      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
@ aPosObj[1,3]-80,aPosObj[1,2] ;
	LISTBOX oLBoxInd VAR cLBoxInd ;
	Fields ;                                                      
	HEADER aTitInd[01],aTitInd[02],aTitInd[03],aTitInd[04],;
	       aTitInd[05],aTitInd[06],aTitInd[07],aTitInd[08],;
	       aTitInd[09],aTitInd[10],aTitInd[11],aTitInd[12] ;
	 OF oFolder:aDialogs[2] PIXEL SIZE  aPosObj[1,4]-aPosObj[1,2]-10,30 NOSCROLL
oLBoxInd:SetArray(aListInd)
oLBoxInd:bLine := { || {	If(aListInd[oLBoxInd:nAt,1],oVerde,oVermelho),;
		   							aListInd[oLBoxInd:nAt,2],;
		   							aListInd[oLBoxInd:nAt,3],;
		   							aListInd[oLBoxInd:nAt,4],;
		   							If(aListInd[oLBoxInd:nAt,5],oVerde,oVermelho),;
		   							aListInd[oLBoxInd:nAt,6],;
		   							aListInd[oLBoxInd:nAt,7],;
		   							aListInd[oLBoxInd:nAt,8],;
		   							If(aListInd[oLBoxInd:nAt,9],oVerde,oVermelho),;
		   							aListInd[oLBoxInd:nAt,10],;
		   							aListInd[oLBoxInd:nAt,11],;
		   							aListInd[oLBoxInd:nAt,12]}}
olboxind:LHSCROLL := .F.
olboxind:LVSCROLL := .F.
@ aPosObj[1,3]-45,aPosObj[1,4]-90		BUTTON oBtn3	PROMPT "Descartar" 	SIZE 35,15 ACTION Descartar() 				When cArqPConc->(RecCount()) > 0 OF oFolder:aDialogs[2] PIXEL
@ aPosObj[1,3]-45,aPosObj[1,4]-50 		BUTTON oBtn4	PROMPT "Estornar" 	SIZE 35,15 ACTION EstMan("cArqPConc") 		When cArqPConc->(RecCount()) > 0 OF oFolder:aDialogs[2] PIXEL
	 
//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o ListBox das Conciliacoes Manuais             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cArqMConc")
@ aPosObj[1,1]-15,aPosObj[1,2] ;
	LISTBOX oLBoxMConc VAR cLBoxMConc ;
	Fields	Iif(cArqMConc->MARCA == "S", oOk, oNo),;
				Iif(Empty(cArqMConc->PBC_TITULO),oVerde,oAmarelo),;
				cArqMConc->PBC_CODMAQ,;
				Tabela("P7",Posicione("PAB",2,xFilial("PAB")+cArqMConc->PBC_CODADM+Space(1)+cArqMConc->PBC_CODMAQ,"PAB_LOJA"),.f.),;
				Transform(cArqMConc->PBC_TOTCOM,"@E 9,999,999.99"),;
				Transform(cArqMConc->PBC_VLBRUT,"@E 9,999,999.99"),;
				cArqMConc->PBC_NCV,;
				cArqMConc->PBC_CARTAO,;                
				Transform(cArqMConc->PBC_VLLIQ,"@E 9,999,999.99"),;
				cArqMConc->PBC_EMISS,;
				cArqMConc->PBC_PARCEL,;
				cArqMConc->PBC_TOTPAR,;
				cArqMConc->PBC_CODADM,;
				Posicione("SAE",1,xFilial("SAE")+cArqMConc->PBC_CODADM,"AE_DESC"),;
				cArqMConc->PBC_NRV,;
				cArqMConc->PBC_CREDIT,;
				Transform(cArqMConc->PBC_VLDESC,"@E 9,999,999.99"),;
				cArqMConc->PBC_PREFIX,;
				cArqMConc->PBC_TITULO,;
				cArqMConc->PBC_TIPTIT,;
				cArqMConc->PBC_CLIENT,;
				cArqMConc->PBC_LOJA,;
				cArqMConc->PBC_NOMCLI,;
				cArqMConc->PBC_EMISSA,;
				cArqMConc->PBC_VENORI,;
				cArqMConc->PBC_VENCTO,;
				cArqMConc->PBC_TPOPER,;
				cArqMConc->PBC_TPCART ;
	HEADER aTitMConc[01],aTitMConc[02],aTitMConc[03],aTitMConc[04],;
	       aTitMConc[05],aTitMConc[06],aTitMConc[07],aTitMConc[08],;
	       aTitMConc[09],aTitMConc[10],aTitMConc[11],aTitMConc[12],;
	       aTitMConc[13],aTitMConc[14],aTitMConc[15],aTitMConc[16],;
	       aTitMConc[17],aTitMConc[18],aTitMConc[19],aTitMConc[20],;
	       aTitMConc[21],aTitMConc[22],aTitMConc[23],aTitMConc[24],;
	       aTitMConc[25],aTitMConc[26],aTitMConc[27],aTitMConc[28] ;
	 OF oFolder:aDialogs[3] PIXEL SIZE  aPosObj[1,4]-aPosObj[1,2]-10, aPosObj[1,3]-aPosObj[1,1]-34 ;
    ON DBLCLICK (cArqMConc->(RecLock("cArqMConc",.F.)),cArqMConc->MARCA := Iif(cArqMConc->MARCA == "S"," ","S"),cArqMConc->(MsUnlock()),oLBoxMConc:Refresh(.T.)) //NOSCROLL
@ aPosObj[1,3]-45,aPosObj[1,4]-90 	BUTTON oBtn5	PROMPT "Descartar" 	SIZE 35,15 ACTION Descartar() 				When cArqMConc->(RecCount()) > 0 OF oFolder:aDialogs[3] PIXEL
@ aPosObj[1,3]-45,aPosObj[1,4]-50 	BUTTON oBtn6	PROMPT  "Estornar" 	SIZE 35,15 ACTION EstMan("cArqMConc") 		When cArqMConc->(RecCount()) > 0 OF oFolder:aDialogs[3] PIXEL
oLBoxMConc:bGotFocus := {|| (cListAtu := "oLBoxMConc",cAliasAtu := "cArqMConc")}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o ListBox das Ocorrencias do Sitef             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cArqSitef")
DbSetOrder(1)
@ aPosObj[1,1]-15,aPosObj[1,2] SAY OemtoAnsi(" Movimentos Sitef: ") OF oFolder:aDialogs[4] PIXEL
@ aPosObj[1,1]-7,aPosObj[1,2] ;
	LISTBOX oLBoxSitef VAR cLBoxSitef ;
	Fields 	Iif(cArqSitef->MARCA == "S", oOk, oNo),;
				cArqSitef->PBD_ESTAB,;
				Tabela("P7",Posicione("PAB",2,xFilial("PAB")+cArqSitef->PBD_ADM+cArqSitef->PBD_ESTAB,"PAB_LOJA"),.f.),;
				Transform(cArqSitef->PBD_VLCOM,"@E 9,999,999.99"),;
				cArqSitef->PBD_NSU,;     	
				cArqSitef->PBD_CARTAO,;
				cArqSitef->PBD_DTTRAN,;
				cArqSitef->PBD_TOTPAR,;
				cArqSitef->PBD_ADM,;
				Posicione("SAE",1,xFilial("SAE")+cArqSitef->PBD_ADM,"AE_DESC"),;
				cArqSitef->PBD_NSUSIT,;
				cArqSitef->PBD_PDV,;
				cArqSitef->PBD_ESTADO,;
				cArqSitef->PBD_CODTRA,;
				cArqSitef->PBD_CODRES,;
				cArqSitef->PBD_HRTRAN,;
				cArqSitef->PBD_CODAUT,;
				cArqSitef->PBD_NRCANC ;
	HEADER aTitSitef[01],aTitSitef[02],aTitSitef[03],aTitSitef[04],;
	       aTitSitef[05],aTitSitef[06],aTitSitef[07],aTitSitef[08],;
	       aTitSitef[09],aTitSitef[10],aTitSitef[11],aTitSitef[12],;
	       aTitSitef[13],aTitSitef[14],aTitSitef[15],aTitSitef[16],;
	       aTitSitef[17],aTitSitef[18] ;
	 OF oFolder:aDialogs[4] PIXEL SIZE  aPosObj[1,4]-aPosObj[1,2]-10, (aPosObj[1,3]-aPosObj[1,1]-40)/2 ;
    ON DBLCLICK (cArqSitef->(RecLock("cArqSitef",.F.)),cArqSitef->MARCA := Iif(cArqSitef->MARCA == "S"," ","S"),cArqSitef->(MsUnlock()),oLBoxSitef:Refresh(.T.)) //NOSCROLL
oLBoxSitef:bGotFocus := {|| (cListAtu := "oLBoxSitef",cAliasAtu := "cArqSitef")}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o ListBox das Ocorrencias da Operadora         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cArqOper")
DbSetOrder(1)
@ (aPosObj[1,3]-aPosObj[1,1]-10)/2,aPosObj[1,2] SAY OemtoAnsi(" Movimentos Operadora: ") OF oFolder:aDialogs[4] PIXEL
@ (aPosObj[1,3]-aPosObj[1,1]+5)/2,aPosObj[1,2] ;
	LISTBOX oLBoxOper VAR cLBoxOper ;
	Fields	Iif(cArqOper->MARCA == "S", oOk, oNo),;
				Iif(Empty(cArqOper->PBC_TITULO),oVerde,oAmarelo),;
				cArqOper->PBC_CODMAQ,;
				Tabela("P7",Posicione("PAB",2,xFilial("PAB")+cArqOper->PBC_CODADM+Space(1)+cArqOper->PBC_CODMAQ,"PAB_LOJA"),.f.),;
				Transform(cArqOper->PBC_TOTCOM,"@E 9,999,999.99"),;
				Transform(cArqOper->PBC_VLBRUT,"@E 9,999,999.99"),;
				cArqOper->PBC_NCV,;
				cArqOper->PBC_CARTAO,;                
				Transform(cArqOper->PBC_VLLIQ,"@E 9,999,999.99"),;
				cArqOper->PBC_EMISS,;
				cArqOper->PBC_PARCEL,;
				cArqOper->PBC_TOTPAR,;
				cArqOper->PBC_CODADM,;
				Posicione("SAE",1,xFilial("SAE")+cArqOper->PBC_CODADM,"AE_DESC"),;
				cArqOper->PBC_NRV,;
				cArqOper->PBC_CREDIT,;
				Transform(cArqOper->PBC_VLDESC,"@E 9,999,999.99"),;
				cArqOper->PBC_PREFIX,;
				cArqOper->PBC_TITULO,;
				cArqOper->PBC_TIPTIT,;
				cArqOper->PBC_CLIENT,;
				cArqOper->PBC_LOJA,;
				cArqOper->PBC_NOMCLI,;
				cArqOper->PBC_EMISSA,;
				cArqOper->PBC_VENORI,;
				cArqOper->PBC_VENCTO,;
				cArqOper->PBC_TPOPER,;
				cArqOper->PBC_TPCART ;
	HEADER aTitOper[01],aTitOper[02],aTitOper[03],aTitOper[04],;
	       aTitOper[05],aTitOper[06],aTitOper[07],aTitOper[08],;
	       aTitOper[09],aTitOper[10],aTitOper[11],aTitOper[12],;
	       aTitOper[13],aTitOper[14],aTitOper[15],aTitOper[16],;
	       aTitOper[17],aTitOper[18],aTitOper[19],aTitOper[20],;
	       aTitOper[21],aTitOper[22],aTitOper[23],aTitOper[24],;
	       aTitOper[25],aTitOper[26],aTitOper[27],aTitOper[28] ;
	 OF oFolder:aDialogs[4] PIXEL SIZE  aPosObj[1,4]-aPosObj[1,2]-10, (aPosObj[1,3]-aPosObj[1,1]-70)/2 ;
    ON DBLCLICK (cArqOper->(RecLock("cArqOper",.F.)),cArqOper->MARCA := Iif(cArqOper->MARCA == "S"," ","S"),cArqOper->(MsUnlock()),oLBoxOper:Refresh(.T.)) //NOSCROLL
oLBoxOper:bGotFocus := {|| (cListAtu := "oLBoxOper",cAliasAtu := "cArqOper")}
@ aPosObj[1,3]-45,aPosObj[1,4]-90 	BUTTON  oBtn7	PROMPT "Descartar" SIZE 35,15 ACTION Descartar() 	OF oFolder:aDialogs[4] PIXEL
@ aPosObj[1,3]-45,aPosObj[1,4]-50 	BUTTON  oBtn8	PROMPT "Conciliar" SIZE 35,15 ACTION ConcMan() 		OF oFolder:aDialogs[4] PIXEL

//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o Rodape de Resumos                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
@ aPosObj[1,1]-15,aPosObj[1,2] ;
	LISTBOX oLBoxTot VAR cLBoxTot ;
	Fields ;                                                      
	HEADER aTitTot[01],aTitTot[02],aTitTot[03],aTitTot[04],;
	       aTitTot[05],aTitTot[06],"" ;
	 OF oFolder:aDialogs[5] PIXEL SIZE aPosObj[1,4]-aPosObj[1,2]-10, aPosObj[1,3]-aPosObj[1,1]-17 ;
oLBoxTot:SetArray(aListTot)
oLBoxTot:bLine := { || {		aListTot[oLBoxTot:nAt,1],;
		   							Transform(aListTot[oLBoxTot:nAt,2],"@E 9,999,999.99"),;
		   							Transform(aListTot[oLBoxTot:nAt,3],"@E 9,999,999.99"),;
		   							Transform(aListTot[oLBoxTot:nAt,4],"@E 9,999,999.99"),;
		   							Transform(aListTot[oLBoxTot:nAt,5],"@E 9,999,999.99"),;
		   							Transform(aListTot[oLBoxTot:nAt,6],"@E 9,999,999.99"),;
		   							""}}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁPosiciona nos primeiros registros de cada arquivo             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cArqConc->(DbGoTop())
cArqPConc->(DbGoTop())
cArqMConc->(DbGoTop())
cArqSitef->(DbGoTop())
cMovSitef->(DbGoTop())

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpcA := 1,oDlg:End())},{||oDlg:End()},,aButtons)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁRotina de Gravacao da Tabela de preco                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nOpcA == 1
	//Begin Transaction      
		If U_Aviso(OemtoAnsi("Confirmacao"),"Deseja confirmar a conciliacao dos registros relacionados nas pastas de Conciliacao, Conciliacao Parcial e Conciliacao Manual e geracao do Contas a Receber das movimentacoes da operadora ?",{"Sim","Nao"},,OemtoAnsi("Atencao:")) == 1
			Processa({|| GravaCR()},OemtoAnsi("Conciliacao"))
		Endif
		If __lSx8
			ConfirmSx8()
		EndIf
		EvalTrigger()
	//End Transaction
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁRestaura a entrada da Rotina                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If __lSx8
	RollBackSx8()
EndIf
MsUnLockAll()
FreeUsedCode()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁFinaliza os arquivoas temporarios                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cArqConc")   
DbCloseArea()
Ferase(cArqConc+".DBF")
For nX := 1 to Len(aIndConc)
	Ferase(aIndConc[nX,1]+OrdBagExt())
Next nX
DbSelectArea("cArqPConc")   
DbCloseArea()
Ferase(cArqPConc+".DBF")
For nX := 1 to Len(aIndPConc)
	Ferase(aIndPConc[nX,1]+OrdBagExt())
Next nX
DbSelectArea("cArqMConc")   
DbCloseArea()
Ferase(cArqMConc+".DBF")
For nX := 1 to Len(aIndMConc)
	Ferase(aIndMConc[nX,1]+OrdBagExt())
Next nX
DbSelectArea("cArqSitef")  
DbCloseArea()
Ferase(cArqSitef+".DBF")
For nX := 1 to Len(aIndSitef)
	Ferase(aIndSitef[nX,1]+OrdBagExt())
Next nX
DbSelectArea("cMovSitef")   
DbCloseArea()
Ferase(cMovSitef+".DBF")
Ferase(cIndSit1+OrdBagExt())
Ferase(cIndSit2+OrdBagExt())
Ferase(cIndSit3+OrdBagExt())
Ferase(cIndSit4+OrdBagExt())
DbSelectArea("cArqOper")  
DbCloseArea()
Ferase(cArqOper+".DBF")
For nX := 1 to Len(aIndOper)
	Ferase(aIndOper[nX,1]+OrdBagExt())
Next nX

RestArea(aArea)
Return()

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁCriaTmp   ╨Autor  ЁJaime Wikanski      ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁCria os arquivos temporarios utilizados nos listbox         ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/                
Static Function CriaTmp()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aEstruPBC		:= PBC->(DbStruct())
Local aEstruPBD		:= PBD->(DbStruct())
Local aArea				:= GetArea()              
Local nX					:= 0                         
Local cTrab				:=	CriaTrab(,.F.)
Local cContTrab		:= "00"
cTrab	:=	'SC'+Substr(cTrab,5,4)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Pesquisa os indices no SINDEX                        						Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SIX")
DbSetOrder(1)
DbSeek("PBC")
While !EOF() .and. SIX->INDICE == "PBC"

	Aadd(aIndConc, 	{cTrab+(cContTrab	:=	Soma1(cContTrab)),SIX->CHAVE})
	Aadd(aIndPConc, 	{cTrab+(cContTrab	:=	Soma1(cContTrab)),SIX->CHAVE})
	Aadd(aIndMConc, 	{cTrab+(cContTrab	:=	Soma1(cContTrab)),SIX->CHAVE})
	DbSelectArea("SIX")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria o arquivo temporario do ListBox de Conciliacoes							Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Aadd(aEstruPBC, {"LED"		,"C",01,0})
Aadd(aEstruPBC, {"MARCA"	,"C",01,0})
Aadd(aEstruPBC, {"RECPBC"	,"C",20,0})
cArqConc 	:= CriaTrab(aEstruPBC,.T.)
dbUseArea( .T.,, cArqConc, "cArqConc", .F., .F. )
For nX := 1 to Len(aIndConc)
	IndRegua("cArqConc",aIndConc[nX,1],aIndConc[nX,2],,,OemToAnsi("Selecionando Registros..."))
Next nX
Aadd(aIndConc, 	{cTrab+(cContTrab	:=	Soma1(cContTrab)),"MARCA"})
IndRegua("cArqConc",aIndConc[Len(aIndConc),1],aIndConc[Len(aIndConc),2],,,OemToAnsi("Selecionando Registros..."))
DbCommit()
DbSelectArea("cArqConc")
DbClearIndex()
For nX := 1 to Len(aIndConc)
	DbSetIndex(aIndConc[nX,1]+OrdBagExt())
Next nX
DbSetOrder(1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria o arquivo temporario do ListBox de Conciliacoes Parciais				Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cArqPConc 	:= CriaTrab(aEstruPBC,.T.)
dbUseArea( .T.,, cArqPConc, "cArqPConc", .F., .F. )
For nX := 1 to Len(aIndPConc)
	IndRegua("cArqPConc",aIndPConc[nX,1],aIndPConc[nX,2],,,OemToAnsi("Selecionando Registros..."))
Next nX
Aadd(aIndPConc, {cTrab+(cContTrab	:=	Soma1(cContTrab)),"MARCA"})
IndRegua("cArqPConc",aIndPConc[Len(aIndPConc),1],aIndPConc[Len(aIndPConc),2],,,OemToAnsi("Selecionando Registros..."))
DbCommit()
DbSelectArea("cArqPConc")
DbClearIndex()
For nX := 1 to Len(aIndPConc)
	DbSetIndex(aIndPConc[nX,1]+OrdBagExt())
Next nX
DbSetOrder(1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria o arquivo temporario do ListBox de Conciliacoes Manuais				Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cArqMConc 	:= CriaTrab(aEstruPBC,.T.)
dbUseArea( .T.,, cArqMConc, "cArqMConc", .F., .F. )
For nX := 1 to Len(aIndMConc)
	IndRegua("cArqMConc",aIndMConc[nX,1],aIndMConc[nX,2],,,OemToAnsi("Selecionando Registros..."))
Next nX
Aadd(aIndMConc, {cTrab+(cContTrab	:=	Soma1(cContTrab)),"MARCA"})
IndRegua("cArqMConc",aIndMConc[Len(aIndMConc),1],aIndMConc[Len(aIndMConc),2],,,OemToAnsi("Selecionando Registros..."))
DbCommit()
DbSelectArea("cArqMConc")
DbClearIndex()
For nX := 1 to Len(aIndMConc)
	DbSetIndex(aIndMConc[nX,1]+OrdBagExt())
Next nX
DbSetOrder(1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria o arquivo temporario do ListBox de Movimentacoes do Sitef   		Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Aadd(aEstruPBD, {"MARCA"	,"C",01,0})
Aadd(aEstruPBD, {"RECPBD"	,"C",20,0})
Aadd(aEstruPBD, {"RECOPER"	,"C",20,0})
cArqSitef	:= CriaTrab(aEstruPBD,.T.)
dbUseArea( .T.,, cArqSitef, "cArqSitef", .F., .F. )
DbSelectArea("SIX")
DbSetOrder(1)
DbSeek("PBD")
While !EOF() .and. SIX->INDICE == "PBD"
	Aadd(aIndSitef, {cTrab+(cContTrab	:=	Soma1(cContTrab)),SIX->CHAVE})
	IndRegua("cArqSitef",aIndSitef[Len(aIndSitef),1],aIndSitef[Len(aIndSitef),2],,,OemToAnsi("Selecionando Registros..."))
	DbSelectArea("SIX")
	DbSkip()
Enddo                
Aadd(aIndSitef, {cTrab+(cContTrab	:=	Soma1(cContTrab)),"RECPBD"})
IndRegua("cArqSitef",aIndSitef[Len(aIndSitef),1],aIndSitef[Len(aIndSitef),2],,,OemToAnsi("Selecionando Registros..."))
Aadd(aIndSitef, {cTrab+(cContTrab	:=	Soma1(cContTrab)),"MARCA"})
IndRegua("cArqSitef",aIndSitef[Len(aIndSitef),1],aIndSitef[Len(aIndSitef),2],,,OemToAnsi("Selecionando Registros..."))
DbCommit()
DbSelectArea("cArqSitef")
DbClearIndex()
For nX := 1 to Len(aIndSitef)
	DbSetIndex(aIndSitef[nX,1]+OrdBagExt())
Next nX
DbSetOrder(1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria o arquivo temporario do ListBox de Movimentacoes do Sitef   		Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cMovSitef	:= CriaTrab(aEstruPBD,.T.)
cIndSit1		:= cTrab+(cContTrab	:=	Soma1(cContTrab))
cIndSit2		:= cTrab+(cContTrab	:=	Soma1(cContTrab))
cIndSit3		:= cTrab+(cContTrab	:=	Soma1(cContTrab))
cIndSit4		:= cTrab+(cContTrab	:=	Soma1(cContTrab))
dbUseArea( .T.,, cMovSitef, "cMovSitef", .F., .F. )
IndRegua("cMovSitef",cIndSit1,"RECOPER",,,OemToAnsi("Selecionando Registros..."))
IndRegua("cMovSitef",cIndSit2,"RECPBD",,,OemToAnsi("Selecionando Registros..."))
IndRegua("cMovSitef",cIndSit3,"PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO",,,OemToAnsi("Selecionando Registros..."))
IndRegua("cMovSitef",cIndSit4,"PBD_FILIAL+PBD_ADM+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO",,,OemToAnsi("Selecionando Registros..."))
DbCommit()          
DbSelectArea("cMovSitef")
DbClearIndex()
DbSetIndex(cIndSit1+OrdBagExt())
DbSetIndex(cIndSit2+OrdBagExt())
DbSetIndex(cIndSit3+OrdBagExt())
DbSetIndex(cIndSit4+OrdBagExt())
DbSetOrder(1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria o arquivo temporario do ListBox de Movimentacoes da Operadora		Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cArqOper	:= CriaTrab(aEstruPBC,.T.)
dbUseArea( .T.,, cArqOper, "cArqOper", .F., .F. )
DbSelectArea("SIX")
DbSetOrder(1)
DbSeek("PBC")
While !EOF() .and. SIX->INDICE == "PBC"
	Aadd(aIndOper, 	{cTrab+(cContTrab	:=	Soma1(cContTrab)),SIX->CHAVE})
	IndRegua("cArqOper",aIndOper[Len(aIndOper),1],aIndOper[Len(aIndOper),2],,,OemToAnsi("Selecionando Registros..."))
	DbSelectArea("SIX")
	DbSkip()
Enddo
Aadd(aIndOper, 	{cTrab+(cContTrab	:=	Soma1(cContTrab)),"MARCA"})
IndRegua("cArqOper",aIndOper[Len(aIndOper),1],aIndOper[Len(aIndOper),2],,,OemToAnsi("Selecionando Registros..."))
DbCommit()
DbSelectArea("cArqOper")
DbClearIndex()
For nX := 1 to Len(aIndOper)
	DbSetIndex(aIndOper[nX,1]+OrdBagExt())
Next nX
DbSetOrder(1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a area dos arquivos                                       		Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RestArea(aArea)

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммямммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁGeraArqTmp ╨Autor  ЁJaime Wikanski     ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьмммммммммммймммммммомммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁGera arrays com os dados das conciliacoes                   ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function GeraArqTmp()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cAliasPBC	:= ""
Local cAliasPBD	:= ""
Local nTotRegs		:= 0
Local cSelect		:= ""
Local cCount		:= ""
Local cQuery		:= ""
Local cOrder		:= ""
Local cArqTrab		:= ""
Local cArqTrab1	:= ""
Local cIndPBC		:= ""
Local cFiltroPBC	:= ""
Local cIndPBD		:= ""
Local cFiltroPBD	:= ""
Local nIndex		:= 0  
Local nNewRec		:= 0
Local aArea			:= GetArea()
Local cChaveConc	:= ""
Local aRecPBCConc	:= {}
Local lConc			:= .F.
Local lGravaPConc	:= .F.
Local nRecMovSit	:= 0
Local cCpoCart		:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define o alias do PBD de acordo com o tipo de base de dados				Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF TOP
	cAliasPBD	:= "PBDTMP"
	cCount		:= " SELECT COUNT(*) AS TOTREGS"
	cSelect		:= " SELECT PBD.R_E_C_N_O_ AS RECPBD"
	cQuery		:= " FROM "+RetSqlName("PBD")+" PBD (NOLOCK)"
	cQuery		+= " WHERE "+FiltroPBD()
	cOrder		:= " ORDER BY PBD.PBD_FILIAL,PBD.PBD_CONC,PBD.PBD_ADM,PBD.PBD_NSU,PBD.PBD_CARTAO,PBD.PBD_ESTADO,PBD.PBD_DTTRAN"

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Conta a quantidade de registros                            				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Select(cAliasPBD) > 0
		DbSelectArea(cAliasPBD)
		DbCloseArea()
	Endif
	TcQuery cCount+cQuery New Alias (cAliasPBD)
	nTotRegs := (cAliasPBD)->TOTREGS

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monta a query com os registros a serem processados         				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Select(cAliasPBD) > 0
		DbSelectArea(cAliasPBD)
		DbCloseArea()
	Endif
	TcQuery cSelect+cQuery+cOrder New Alias (cAliasPBD)
#ELSE	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Filtra os registros no arquivo PBD                         				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cAliasPBD	:= "PBD"
	DbSelectArea(cAliasPBD)
	DbSetOrder(2)
	cArqTrab1	:= CriaTrab(NIL,.F.)
	cIndPBD		:= IndexKey()
	cFiltroPBD	:= FiltroPBD()
	IndRegua(cAliasPBD,cArqTrab1,cIndPBD,,cFiltroPBD,OemToAnsi("Selecionando Registros..."))
	DbCommit()
	nIndex 	:= RetIndex(cAliasPBD)+1
	DbSelectArea(cAliasPBD)
	DbSetIndex(cArqTrab1+OrdBagExt())
	DbSetOrder(nIndex)
	nTotRegs	:= RecCount()
#ENDIF 					

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa o arquivo de movimentacoes do Sitef          						Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(cAliasPBD)
DbGoTop()        
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc(OemtoAnsi("Processando movimentacoes do Sitef..."))
   #IFDEF TOP
		DbSelectArea("PBD")
		DbGoTo((cAliasPBD)->RECPBD)
	#ELSE	
		DbSelectArea("PBD")
		DbGoTo((cAliasPBD)->(Recno()))
	#ENDIF 					


	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Alimenta o arquivo de movimentacoes do SITEF                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nNewRec := U_CopiaReg("PBD","cMovSitef")
	DbSelectArea("cMovSitef")
	DbGoTo(nNewRec)
	RecLock("cMovSitef",.F.)
	cMovSitef->RECPBD	:= Alltrim(Str(PBD->(Recno())))
	MsUnlock()

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Alimenta o arquivo de movimentacoes do SITEF - Nao Conciliados         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nNewRec := U_CopiaReg("PBD","cArqSitef")
	DbSelectArea("cArqSitef")
	DbGoTo(nNewRec)
	RecLock("cArqSitef",.F.)
	cArqSitef->RECPBD	:= Alltrim(Str(PBD->(Recno())))
	MsUnlock()

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza os totais                                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nPosArr 	:= Ascan(aListTot,{|x| x[1] == PBD->PBD_DTTRAN})
	If nPosArr == 0
		Aadd(aListTot,{	PBD->PBD_DTTRAN,;
							   0.00,;
							   0.00,;
							   0.00,;
							   0.00,;
								PBD->PBD_VLCOM})
	Else
		aListTot[nPosArr,6] += PBD->PBD_VLCOM
	Endif	
	DbSelectArea(cAliasPBD)
	DbSkip()
Enddo
DbSelectArea("cArqSitef")
DbGoTop()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define o alias de acordo com o tipo de base de dados							Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF TOP
	cAliasPBC	:= "PBCTMP"
	cCount		:= " SELECT COUNT(*) AS TOTREGS"
	cSelect		:= " SELECT PBC.R_E_C_N_O_ AS RECPBC"
	cQuery		:= " FROM "+RetSqlName("PBC")+" PBC (NOLOCK)"
	cQuery		+= " WHERE "+FiltroPBC()
	cOrder		:= " ORDER BY PBC.PBC_FILIAL, PBC.PBC_CONC, PBC.PBC_TPOPER, PBC.PBC_CODADM, PBC.PBC_EMISS, PBC.PBC_NCV, PBC.PBC_CARTAO, PBC.PBC_CHVLLQ"

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Conta a quantidade de registros                            				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Select(cAliasPBC) > 0
		DbSelectArea(cAliasPBC)
		DbCloseArea()
	Endif
	TcQuery cCount+cQuery New Alias (cAliasPBC)
	nTotRegs := (cAliasPBC)->TOTREGS

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monta a query com os registros a serem processados         				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Select(cAliasPBC) > 0
		DbSelectArea(cAliasPBC)
		DbCloseArea()
	Endif
	TcQuery cSelect+cQuery+cOrder New Alias (cAliasPBC)
#ELSE	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Filtra os registros no arquivo PBC                         				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cAliasPBC	:= "PBC"
	DbSelectArea(cAliasPBC)
	DbSetOrder(2)
	cArqTrab 	:= CriaTrab(NIL,.F.)
	cIndPBC		:= IndexKey()
	cFiltroPBC	:= FiltroPBC()
	IndRegua(cAliasPBC,cArqTrab,cIndPBC,,cFiltroPBC,OemToAnsi("Selecionando Registros..."))
	DbCommit()
	nIndex 	:= RetIndex(cAliasPBC)+1
	DbSelectArea(cAliasPBC)
	DbSetIndex(cArqTrab+OrdBagExt())
	DbSetOrder(nIndex)
	nTotRegs	:= RecCount()
#ENDIF 					

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa o arquivo de movimentacoes da operadora para conc. total		Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(cAliasPBC)
DbGoTop()        
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc(OemtoAnsi("Processando conciliacoes..."))
   #IFDEF TOP
		DbSelectArea("PBC")
		DbGoTo((cAliasPBC)->RECPBC)
	#ELSE	
		DbSelectArea("PBC")
		DbGoTo((cAliasPBC)->(Recno()))
	#ENDIF 					

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Alimenta o arquivo de conciliacoes                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+PBC->PBC_CARTAO+Substr(PBC->PBC_NCV,1,9)+DTOS(PBC->PBC_EMISS)+PBC->PBC_TOTPAR
	lConc			:= .F.
	DbSelectArea("cMovSitef")
	DbSetOrder(3)  //PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
	If !DbSeek(cChaveConc+"E",.F.)
		cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+PBC->PBC_CART1+Substr(PBC->PBC_NCV,1,9)+DTOS(PBC->PBC_EMISS)+PBC->PBC_TOTPAR
		lConc			:= .F.
		DbSelectArea("cMovSitef")
		DbSetOrder(3)  //PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
		DbSeek(cChaveConc+"E",.F.)
	Endif
	While !EOF() .and. cMovSitef->PBD_FILIAL+cMovSitef->PBD_ADM+cMovSitef->PBD_CARTAO+cMovSitef->PBD_NSU+DTOS(cMovSitef->PBD_DTTRAN)+cMovSitef->PBD_TOTPAR+"E" == cChaveConc+"E" .and. lConc == .F. .and. MV_PAR07 == 2
		If Abs(Abs(cMovSitef->PBD_VLCOM) - Abs(PBC->PBC_TOTCOM)) <= 1.00 .and. Empty(cMovSitef->RECOPER)
			lConc := .T.		                                                 
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta o arquivo de conciliacoes                                     Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nNewRec := U_CopiaReg("PBC","cArqConc")
			DbSelectArea("cArqConc")
			DbGoTo(nNewRec)
			RecLock("cArqConc",.F.)
			cArqConc->RECPBC	:= Alltrim(Str(PBC->(Recno())))
			MsUnlock()

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza o arquivo de movimentacoes do Sitef com o link                Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("cMovSitef")
			RecLock("cMovSitef",.F.)
			cMovSitef->RECOPER := Alltrim(Str(PBC->(Recno())))
			MsUnlock()                                  

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Posiciona no PBD                                                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("PBD")
			DbGoTo(Val(cMovSitef->RECPBD))
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Exclui do arquivo de ovimentacoes nao conciliadas do Sitef             Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("cArqSitef")       
			DbSetOrder(Len(aIndSitef)-1)
			If !DbSeek(cMovSitef->RECPBD,.f.)
				U_Aviso("Inconsistencia","Nao foi possМvel excluir os registros de movimentacoes do Sitef a conciliacao referente ao cartao "+PBC->PBC_CARTAO+" do comprovante "+PBC->PBC_NCV+" emitido em "+DTOC(PBC->PBC_EMISS)+" no valor de R$ "+Alltrim(Transform(PBC->PBC_TOTCOM,"@E 9,999,999.99")),{"Ok"},,OemtoAnsi("Atencao:"))
			Else
				RecLock("cArqSitef",.F.)
				DbDelete()
				MsUnlock()
			Endif                     
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza os totais                                                     Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == PBC->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	PBC->PBC_EMISS,;
									   PBC->PBC_TOTCOM,;
									   0.00,;
									   0.00,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,2] += PBC->PBC_TOTCOM
			Endif	
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == PBD->PBD_DTTRAN})
			If nPosArr == 0
				Aadd(aListTot,{	PBD->PBD_DTTRAN,;
									   0.00,;
									   0.00,;
									   0.00,;
									   0.00,;
										cMovSitef->PBD_VLCOM*-1})
			Else
				aListTot[nPosArr,6] -= cMovSitef->PBD_VLCOM
			Endif	
		Endif
		DbSelectArea("cMovSitef")
		DbSkip()
	Enddo

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Alimenta o arquivo de movimentacoes das operadoras                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lConc == .T.
		Aadd(aRecPBCConc, PBC->(Recno()))
	Endif	
	DbSelectArea(cAliasPBC)
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa o arquivo de movimentacoes da operadora para conc. parcial		Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(cAliasPBC)
DbGoTop()        
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc(OemtoAnsi("Processando conciliacoes parciais..."))
   #IFDEF TOP
		DbSelectArea("PBC")
		DbGoTo((cAliasPBC)->RECPBC)
	#ELSE	
		DbSelectArea("PBC")
		DbGoTo((cAliasPBC)->(Recno()))
	#ENDIF 					

	If MV_PAR07 == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifica se ja foi processada como conciliacao total                   Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If aScan(aRecPBCConc, PBC->(Recno())) > 0
			DbSelectArea(cAliasPBC)
		 	DbSkip()
		 	Loop
		Endif	
	
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Tenta conciliar parcialmente                                           Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+PBC->PBC_CARTAO+Substr(PBC->PBC_NCV,1,9)+DTOS(PBC->PBC_EMISS)+PBC->PBC_TOTPAR
		lConc			:= .F.
		lGravaPConc	:= .F.
		nRecMovSit	:= 0
		DbSelectArea("cMovSitef")
		DbSetOrder(3)  //PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
		If !DbSeek(cChaveConc+"E",.F.)
			cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+PBC->PBC_CART1+Substr(PBC->PBC_NCV,1,9)+DTOS(PBC->PBC_EMISS)+PBC->PBC_TOTPAR
			lConc			:= .F.
			lGravaPConc	:= .F.
			nRecMovSit	:= 0
			DbSelectArea("cMovSitef")
			DbSetOrder(3)  //PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
			DbSeek(cChaveConc+"E",.F.)
		Endif
		While !EOF() .and. cMovSitef->PBD_FILIAL+cMovSitef->PBD_ADM+cMovSitef->PBD_CARTAO+cMovSitef->PBD_NSU+DTOS(cMovSitef->PBD_DTTRAN)+cMovSitef->PBD_TOTPAR+"E" == cChaveConc+"E" .and. lConc == .F.
			If Abs(Abs(cMovSitef->PBD_VLCOM) - Abs(PBC->PBC_TOTCOM)) > 1.00 .and. Empty(cMovSitef->RECOPER)
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Conclia parcialmente pelo valor                                        Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				lConc 		:= .T.		
				lGravaPConc := .T.
				nRecMovSit	:= cMovSitef->(Recno())
				Exit
			Endif
			DbSelectArea("cMovSitef")
			DbSkip()
		Enddo
	
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Tenta conciliar parcialmente por Administradora + Cartao               Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+PBC->PBC_CARTAO
		DbSelectArea("cMovSitef")
		DbSetOrder(3)  //PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
		If !DbSeek(cChaveConc,.F.)
			cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+PBC->PBC_CART1
			DbSelectArea("cMovSitef")
			DbSetOrder(3)  //PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
			DbSeek(cChaveConc,.F.)
		Endif
		While !EOF() .and. cMovSitef->PBD_FILIAL+cMovSitef->PBD_ADM+cMovSitef->PBD_CARTAO == cChaveConc .and. lConc == .F.
			If cMovSitef->PBD_NSU == Substr(PBC->PBC_NCV,1,9) .and. Empty(cMovSitef->RECOPER)
				lConc 		:= .T.
				lGravaPConc := .T.
				nRecMovSit	:= cMovSitef->(Recno())
				Exit
			ElseIf Abs(Abs(cMovSitef->PBD_VLCOM) - Abs(PBC->PBC_TOTCOM)) <= 1.00 .and. Empty(cMovSitef->RECOPER)
				lConc 		:= .T.
				lGravaPConc := .T.
				nRecMovSit	:= cMovSitef->(Recno())
				Exit
			ElseIf DTOS(PBC->PBC_EMISS) == DTOS(cMovSitef->PBD_DTTRAN) .and. Empty(cMovSitef->RECOPER)
				lConc 		:= .T.
				lGravaPConc := .T.
				nRecMovSit	:= cMovSitef->(Recno())
				Exit
			Endif
			DbSelectArea("cMovSitef")
			DbSkip()
		Enddo

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Tenta conciliar parcialmente sem o numero do cartao - Caso TecBan      Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+Substr(PBC->PBC_NCV,1,9)+DTOS(PBC->PBC_EMISS)+PBC->PBC_TOTPAR	
		lConc			:= .F.
		lGravaPConc	:= .F.
		nRecMovSit	:= 0
		DbSelectArea("cMovSitef")
		DbSetOrder(4)  //PBD_FILIAL+PBD_ADM+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
		DbSeek(cChaveConc+"E",.F.)
		While !EOF() .and. cMovSitef->PBD_FILIAL+cMovSitef->PBD_ADM+cMovSitef->PBD_NSU+DTOS(cMovSitef->PBD_DTTRAN)+cMovSitef->PBD_TOTPAR+"E" == cChaveConc+"E" .and. lConc == .F.
			If Abs(Abs(cMovSitef->PBD_VLCOM) - Abs(PBC->PBC_TOTCOM)) <= 1.00 .and. Empty(cMovSitef->RECOPER)
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Conclia parcialmente pelo valor                                        Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				lConc 		:= .T.		
				lGravaPConc := .T.
				nRecMovSit	:= cMovSitef->(Recno())
				Exit
			Endif
			DbSelectArea("cMovSitef")
			DbSkip()
		Enddo

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Tenta conciliar parcialmente pela planilha POS                         Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cChaveConc	:= xFilial("PBD")+PBC->PBC_CODADM+Space(1)+PADR("POS",19)+Substr(PBC->PBC_NCV,1,9)
		DbSelectArea("cMovSitef")
		DbSetOrder(3)  //PBD_FILIAL+PBD_ADM+PBD_CARTAO+PBD_NSU+DTOS(PBD_DTTRAN)+PBD_TOTPAR+PBD_ESTADO
		DbSeek(cChaveConc,.F.)
		While !EOF() .and. cMovSitef->PBD_FILIAL+cMovSitef->PBD_ADM+cMovSitef->PBD_CARTAO+cMovSitef->PBD_NSU == cChaveConc .and. lConc == .F.
			If Abs(Abs(cMovSitef->PBD_VLCOM) - Abs(PBC->PBC_TOTCOM)) <= 1.00 .and. Empty(cMovSitef->RECOPER)
				lConc 		:= .T.
				lGravaPConc := .T.
				nRecMovSit	:= cMovSitef->(Recno())
				Exit
			ElseIf DTOS(PBC->PBC_EMISS) == DTOS(cMovSitef->PBD_DTTRAN) .and. Empty(cMovSitef->RECOPER)
				lConc 		:= .T.
				lGravaPConc := .T.
				nRecMovSit	:= cMovSitef->(Recno())
				Exit
			Endif
			DbSelectArea("cMovSitef")
			DbSkip()
		Enddo
	
		If lGravaPConc
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta o arquivo de conciliacoes Parciais                            Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nNewRec := U_CopiaReg("PBC","cArqPConc")
			DbSelectArea("cArqPConc")
			DbGoTo(nNewRec)
			RecLock("cArqPConc",.F.)
			cArqPConc->RECPBC	:= Alltrim(Str(PBC->(Recno())))
			MsUnlock()
	
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza o arquivo de movimentacoes do Sitef com o link                Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("cMovSitef")
			DbGoTo(nRecMovSit)
			RecLock("cMovSitef",.F.)
			cMovSitef->RECOPER := Alltrim(Str(PBC->(Recno())))
			MsUnlock()                                  

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Posiciona no PBD                                                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("PBD")
			DbGoTo(Val(cMovSitef->RECPBD))
	
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Exclui do arquivo de ovimentacoes nao conciliadas do Sitef             Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("cArqSitef")       
			DbSetOrder(Len(aIndSitef)-1)
			If !DbSeek(cMovSitef->RECPBD,.f.)
				U_Aviso("Inconsistencia","Nao foi possМvel excluir os registros de movimentacoes do Sitef a conciliacao referente ao cartao "+PBC->PBC_CARTAO+" do comprovante "+PBC->PBC_NCV+" emitido em "+DTOC(PBC->PBC_EMISS)+" no valor de R$ "+Alltrim(Transform(PBC->PBC_TOTCOM,"@E 9,999,999.99")),{"Ok"},,OemtoAnsi("Atencao:"))
			Else
				RecLock("cArqSitef",.F.)
				DbDelete()
				MsUnlock()
			Endif
			MsUnlock()                                  
	
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza os totais                                                     Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == PBC->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	PBC->PBC_EMISS,;
									   0.00,;
									   PBC->PBC_TOTCOM,;
									   0.00,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,3] += PBC->PBC_TOTCOM
			Endif	
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == PBD->PBD_DTTRAN})
			If nPosArr == 0
				Aadd(aListTot,{	PBD->PBD_DTTRAN,;
									   0.00,;
									   0.00,;
									   0.00,;
									   0.00,;
										cMovSitef->PBD_VLCOM*-1})
			Else
				aListTot[nPosArr,6] -= cMovSitef->PBD_VLCOM
			Endif	
		Endif
	Endif
		
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Alimenta o arquivo de movimentacoes das operadoras                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lConc == .F.
		nNewRec := U_CopiaReg("PBC","cArqOper")
		DbSelectArea("cArqOper")
		DbGoTo(nNewRec)
		RecLock("cArqOper",.F.)
		cArqOper->RECPBC	:= Alltrim(Str(PBC->(Recno())))
		MsUnlock()
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Atualiza os totais                                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		nPosArr 	:= Ascan(aListTot,{|x| x[1] == PBC->PBC_EMISS})
		If nPosArr == 0
			Aadd(aListTot,{	PBC->PBC_EMISS,;
								   0.00,;
								   0.00,;
								   0.00,;
								   PBC->PBC_TOTCOM,;
									0.00})
		Else
			aListTot[nPosArr,5] += PBC->PBC_TOTCOM
		Endif	
	Endif	
	DbSelectArea(cAliasPBC)
	DbSkip()
Enddo

DbSelectArea("cArqConc")
DbGoTop()
DbSelectArea("cArqOper")
DbGoTop()
      
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza o ListBox                                    						Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If oLBoxConc <> Nil
	oLBoxConc:Refresh()
Endif
If oLBoxMConc <> Nil
	oLBoxMConc:Refresh()
Endif
If oLBoxPConc <> Nil
	oLBoxPConc:Refresh()
Endif
If oLBoxOper <> Nil
	oLBoxOper:Refresh()
Endif
If oLBoxSitef <> Nil
	oLBoxSitef:Refresh()
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza o ListBox de totais                          						Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AtuLBxTot()
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Exclui os arquivos temporarios                        						Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF TOP
	If Select(cAliasPBC) > 0
		DbSelectArea(cAliasPBC)
		DbCloseArea()
	Endif
	If Select(cAliasPBD) > 0
		DbSelectArea(cAliasPBD)
		DbCloseArea()
	Endif
#ELSE	
	DbSelectArea(cAliasPBC)
	RetIndex(cAliasPBC)           
	DbSetOrder(1)
	Ferase(cArqTrab+OrdBagExt())
	DbSelectArea(cAliasPBD)
	RetIndex(cAliasPBD)           
	DbSetOrder(1)
	Ferase(cArqTrab1+OrdBagExt())
#ENDIF 					
RestArea(aArea)
	
Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммямммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁFiltroPBC  ╨Autor  ЁJaime Wikanski     ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьмммммммммммймммммммомммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRetorna a expressao de filtro do PBC                        ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function FiltroPBC()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cReturn		:= ""                         
Local cQuery		:= ""
Local cFiltroPBC	:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define o fitro de acordo com o tipo de base de dados							Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF TOP
	cQuery		:= " PBC.PBC_FILIAL = '"+xFilial("PBC")+"'"
	If MV_PAR07 == 2
		cQuery		+= " AND PBC.PBC_CONC IN(' ','N','')"
	Else
		cQuery		+= " AND PBC.PBC_CONC = 'N'"
	Endif	
	If MV_PAR02 == 1
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes VISA                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBC.PBC_CODADM = 'CX'"
	ElseIf MV_PAR02 == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes AMEX                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBC.PBC_CODADM = 'CA'"
	ElseIf MV_PAR02 == 3
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes REDECARD                                           				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBC.PBC_CODADM IN('CE','CC')"
	ElseIf MV_PAR02 == 4
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes TECBAN	                                           				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBC.PBC_CODADM = 'TB'"
	Endif
	If MV_PAR01 == 1
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Provisao (Venda)                                           				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBC.PBC_TPOPER = 'P'"
	ElseIf MV_PAR01 == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Liquidacao                                                 				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBC.PBC_TPOPER = 'L'"
	ElseIf MV_PAR01 == 3
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Ajuste                                                     				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBC.PBC_TPOPER = 'A'"
	Endif
	cQuery	+= " AND PBC_EMISS BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'"
	cQuery	+= " AND PBC.D_E_L_E_T_ <> '*'"
	cReturn	:= cQuery
#ELSE	
	If MV_PAR07 == 2
		cFiltroPBC	:= " PBC_CONC $ ' /N'"
	Else
		cFiltroPBC	:= " PBC_CONC == 'N'"
	Endif	
	If MV_PAR02 == 1
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes VISA                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBC	+= " .and. PBC_CODADM == 'CX'"
	ElseIf MV_PAR02 == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes AMEX                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBC	+= " .and. PBC_CODADM == 'CA'"
	ElseIf MV_PAR02 == 3
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes REDECARD                                           				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBC	+= " .and. (PBC_CODADM == 'CE' .OR. PBC_CODADM == 'CC')"
	ElseIf MV_PAR02 == 4
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes TECBAN                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBC	+= " .and. PBC_CODADM == 'TB'"
	Endif
	If MV_PAR01 == 1
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Provisao (Venda)                                           				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBC	+= " .and. PBC_TPOPER == 'P'"
	ElseIf MV_PAR01 == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Liquidacao                                                 				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBC	+= " .and. PBC_TPOPER == 'L'"
	ElseIf MV_PAR01 == 3
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Ajuste                                                     				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBC	+= " .and. PBC_TPOPER == 'A'"
	Endif
	cFiltroPBC	+= " .and. DTOS(PBC_EMISS) >= '"+Dtos(MV_PAR03)+"' .and. DTOS(PBC_EMISS) <= '"+Dtos(MV_PAR04)+"'"
	cReturn		:= cFiltroPBC
#ENDIF 					

Return(cReturn)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммямммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁFiltroPBD  ╨Autor  ЁJaime Wikanski     ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьмммммммммммймммммммомммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRetorna a expressao de filtro do PBD                        ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function FiltroPBD()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cReturn		:= ""                         
Local cQuery		:= ""
Local cFiltroPBD	:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define o fitro de acordo com o tipo de base de dados							Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
#IFDEF TOP
	cQuery		:= " PBD.PBD_FILIAL = '"+xFilial("PBD")+"'"
	cQuery		+= " AND PBD.PBD_CONC IN('N',' ','')"
	If MV_PAR02 == 1
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes VISA                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBD.PBD_ADM = 'CX'"
	ElseIf MV_PAR02 == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes AMEX                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBD.PBD_ADM = 'CA'"
	ElseIf MV_PAR02 == 3
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes REDECARD                                           				Ё
		//юдддддддддддддддд	дддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBD.PBD_ADM IN('CE','CC')"
	ElseIf MV_PAR02 == 4
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes TECBAN                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cQuery	+= " AND PBD.PBD_ADM = 'TB'"
	Endif
	cQuery	+= " AND PBD.PBD_DTTRAN BETWEEN '"+DTOS(MV_PAR03-MV_PAR08)+"' AND '"+DTOS(MV_PAR04+MV_PAR08)+"'"
	cQuery	+= " AND PBD.D_E_L_E_T_ <> '*'"
	cReturn	:= cQuery
#ELSE	
	cFiltroPBD	:= "PBD_CONC $ 'N/ '"
	If MV_PAR02 == 1
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes VISA                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBD	+= " .and.  Alltrim(PBD_ADM) == 'CX'"
	ElseIf MV_PAR02 == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes AMEX                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBD	+= " .and. Alltrim(PBD_ADM) == 'CA'"
	ElseIf MV_PAR02 == 3
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes REDECARD                                           				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBD	+= " .and. (Alltrim(PBD_ADM) == 'CE' .OR. Alltrim(PBD_ADM) == 'CC')"
	ElseIf MV_PAR02 == 4
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartoes TECBAN                                               				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cFiltroPBD	+= " .and. Alltrim(PBD_ADM) == 'TB'"
	Endif
	cFiltroPBD	+= " .and. DTOS(PBD_DTTRAN) >=	 '"+Dtos(MV_PAR03-MV_PAR08)+"' .and. DTOS(PBD_DTTRAN) <= '"+Dtos(MV_PAR04+MV_PAR08)+"'"
	cReturn		:= cFiltroPBD
#ENDIF 					

Return(cReturn)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммямммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁConcMan    ╨Autor  ЁJaime Wikanski     ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьмммммммммммймммммммомммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁProcessa a conciliacao manual                               ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ConcMan()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea			:= GetArea()
Local aAreaSit	   := cArqSitef->(GetArea())
Local aAreaOper	:= cArqOper->(GetArea())
Local lProc			:= .T.
Local nTotMarca	:= 0
Local nNewRec		:= 0
Local nRecAtu		:= 0
Local cRecOper		:= ""
Local nIndSitef	:= cArqSitef->(IndexOrd())
Local nIndOper 	:= cArqOper->(IndexOrd())

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se existem registros selecionados										Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cArqSitef")
DbSetOrder(Len(aIndSitef))
If !DbSeek("S",.F.) .and. lProc
	U_Aviso("Inconsistencia","Nao existem registros selecionados nas movimentacoes do Sitef.",{"Ok"},,OemtoAnsi("Atencao"))
	lProc := .F.
Else
	nTotMarca 	:= 0
	While !EOF() .and. cArqSitef->MARCA == "S"
		nTotMarca ++
		DbSelectArea("cArqSitef")
		DbSkip()
	Enddo
	If nTotMarca > 1
		U_Aviso("Inconsistencia","Selecione somente 1 registro nas movimentacoes do Sitef.",{"Ok"},,OemtoAnsi("Atencao"))
		lProc := .F.
	Endif
Endif

DbSelectArea("cArqOper")
DbSetOrder(Len(aIndOper))
If !DbSeek("S",.F.) .and. lProc
	U_Aviso("Inconsistencia","Nao existem registros selecionados nas movimentacoes da operadora.",{"Ok"},,OemtoAnsi("Atencao"))
	lProc := .F.                        
Else            
	nTotMarca 	:= 0
	While !EOF() .and. cArqOper->MARCA == "S"
		nTotMarca ++
		DbSelectArea("cArqOper")
		DbSkip()
	Enddo
	If nTotMarca > 1
		U_Aviso("Inconsistencia","Selecione somente 1 registro nas movimentacoes da Operadora.",{"Ok"},,OemtoAnsi("Atencao"))
		lProc := .F.
	Endif
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processam os registros marcados             									Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lProc
	CursorWait()
	DbSelectArea("cArqOper")
	DbSetOrder(Len(aIndOper))
	DbSeek("S",.F.)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Copia o registro para o folder de concilacoes manuais						Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cRecOper	:= cArqOper->RECPBC
	nRecAtu	:= cArqOper->(Recno())
	nNewRec 	:= U_CopiaReg("cArqOper", "cArqMConc")	
	DbSelectArea("cArqMConc")
	DbGoTo(nNewRec)
	RecLock("cArqMConc",.F.)
	cArqMConc->MARCA	:= Space(1)
	MsUnlock()
	DbSelectArea("cArqOper")
	DbGoTo(nRecAtu)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁExclui o registro do folder de movimentacoes nao conciliadas				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("cArqOper")
	DbSetOrder(nIndOper)
	RecLock("cArqOper",.F.)
	DbDelete()
	MsUnlock()       
	//Pack

	DbSelectArea("cArqSitef")
	DbSetOrder(Len(aIndSitef))
	DbSeek("S",.F.)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAtualiza o link entre PBC e PBD no arquivo de movimentacoes do Sitef		Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("cMovSitef")
	DbSetOrder(2)
	If !DbSeek(cArqSitef->RECPBD,.F.)
		U_Aviso("Inconsistencia","Nao foi possМvel efetuar o link entre o registro da Operadora e o Registro do Sitef. Estorne essa conciliacao",{"Ok"},,OemtoAnsi("Atencao:"))
	Else
		RecLock("cMovSitef",.F.)
		cMovSitef->RECOPER := cRecOper
		MsUnlock()                                  
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza os totais                                                     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nPosArr 	:= Ascan(aListTot,{|x| x[1] == cArqMConc->PBC_EMISS})
	If nPosArr == 0
		Aadd(aListTot,{	cArqMConc->PBC_EMISS,;
							   0.00,;
							   0.00,;
							   cArqMConc->PBC_TOTCOM,;
							   0.00,;
								0.00})
	Else
		aListTot[nPosArr,4] += cArqMConc->PBC_TOTCOM
		aListTot[nPosArr,5] -= cArqMConc->PBC_TOTCOM
	Endif	
	nPosArr 	:= Ascan(aListTot,{|x| x[1] == cArqSitef->PBD_DTTRAN})
	If nPosArr == 0
		Aadd(aListTot,{	cArqSitef->PBD_DTTRAN,;
							   0.00,;
							   0.00,;
								0.00,;
							   0.00,;
								cArqSitef->PBD_VLCOM*-1})
	Else
		aListTot[nPosArr,6] -= cArqSitef->PBD_VLCOM
	Endif	

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁExclui o registro do folder de movimentacoes nao conciliadas				Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("cArqSitef")
	DbSetOrder(nIndSitef)
	RecLock("cArqSitef",.F.)
	DbDelete()
	MsUnlock()
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAtualiza os objetos                                            			Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If oLBoxOper <> Nil
		//oLBoxOper:Refresh()
	Endif
	If oLBoxSitef <> Nil
		//oLBoxSitef:Refresh()             
	Endif
	If oLBoxMConc <> Nil
		oLBoxMConc:Refresh()
	Endif
	If oFolder <> Nil
		oFolder:Refresh()
	Endif
	CursorArrow()
Else
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Restaura a area        	          												Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	RestArea(aAreaOper)
	RestArea(aAreaSit)
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza o ListBox de totais                          						Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AtuLBxTot()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza os botoes                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AtuBtn()
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a area        	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RestArea(aArea)

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммямммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁEstMan     ╨Autor  ЁJaime Wikanski     ╨ Data Ё  09/07/04   ╨╠╠
╠╠лммммммммммьмммммммммммймммммммомммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁProcessa o estorno da conciliacao manual                    ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function EstMan(cAlias)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea			:= GetArea()
Local aAreaConc	:= cArqConc->(GetArea())
Local aAreaPConc	:= cArqPConc->(GetArea())
Local aAreaMConc	:= cArqMConc->(GetArea())
Local lProc			:= .T.
Local nNewRec		:= 0
Local nRecAtu		:= 0
Local cRecOper		:= 0
Local nIndSitef	:= cArqSitef->(IndexOrd())
Local nIndOper 	:= cArqOper->(IndexOrd())
Local nIndMarca	:= 0

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se existem registros selecionados										Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(cAlias)
If RecCount() == 0
	U_Aviso("Inconsistencia","Nao existem registros disponМveis para estorno da conciliacao.",{"Ok"},,OemtoAnsi("Atencao"))
	lProc := .F.
Else
	If U_Aviso(OemtoAnsi("Confirmacao"),"Confirma o estorno da conciliacao dos registros selecionados?",{"Sim","Nao"},,OemtoAnsi("Atencao")) == 2
		lProc := .F.
   Endif
Endif                              

If Alltrim(Upper(cAlias)) $ "CARQCONC"
	nIndMarca	:= Len(aIndConc)
ElseIf Alltrim(Upper(cAlias)) $ "CARQPCONC"
	nIndMarca	:= Len(aIndPConc)
ElseIf Alltrim(Upper(cAlias)) $ "CARQMCONC"
	nIndMarca	:= Len(aIndMConc)
Endif
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processam o registro atual                  									Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lProc            
	CursorWait()
	DbSelectArea(cAlias)
	DbSetOrder(nIndMarca)
	DbSeek("S",.F.)
	While !EOF() .and. (cAlias)->MARCA == "S"
		DbSelectArea("cMovSitef")
		DbSetOrder(1)
		If !DbSeek((cAlias)->RECPBC,.F.)
			U_Aviso("Inconsistencia","Nao foi possМvel localizar o link de conciliacao das movimentacoes do Sitef referente ao cartao "+(cAlias)->PBC_CARTAO+" do comprovante "+(cAlias)->PBC_NCV+" emitido em "+DTOC((cAlias)->PBC_EMISS)+" no valor de R$ "+Alltrim(Transform((cAlias)->PBC_TOTCOM,"@E 9,999,999.99")),{"Ok"},,OemtoAnsi("Atencao:"))
		Else
			RecLock("cMovSitef",.F.)
			cMovSitef->MARCA		:= " "
			cMovSitef->RECOPER 	:= ""
			MsUnlock()                                  
		Endif
				
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Copia o registro para o folder de nao conciliados     						Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		nNewRec 	:= U_CopiaReg("cMovSitef", "cArqSitef")	
		nRecAtu	:= (cAlias)->(Recno())
		nNewRec 	:= U_CopiaReg(cAlias, "cArqOper")	
		DbSelectArea("cArqOper")
		DbGoTo(nNewRec)
		RecLock("cArqOper",.F.)
		cArqOper->MARCA	:= Space(1)
		MsUnlock()

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Atualiza os totais                                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If Alltrim(Upper(cAlias)) $ "CARQMCONC"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBC_EMISS,;
									   0.00,;
									   0.00,;
									   (cAlias)->PBC_TOTCOM*-1,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,4] -= (cAlias)->PBC_TOTCOM
				aListTot[nPosArr,5] += (cAlias)->PBC_TOTCOM
			Endif	
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == cMovSitef->PBD_DTTRAN})
			If nPosArr == 0
				Aadd(aListTot,{	cMovSitef->PBD_DTTRAN,;
									   0.00,;
									   0.00,;
										0.00,;
									   0.00,;
										cMovSitef->PBD_VLCOM})
			Else
				aListTot[nPosArr,6] += cMovSitef->PBD_VLCOM
			Endif	
		ElseIf Alltrim(Upper(cAlias)) $ "CARQCONC"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBC_EMISS,;
									   (cAlias)->PBC_TOTCOM*-1,;
									   0.00,;
									   0.00,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,2] -= (cAlias)->PBC_TOTCOM
				aListTot[nPosArr,5] += (cAlias)->PBC_TOTCOM
			Endif	
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == cMovSitef->PBD_DTTRAN})
			If nPosArr == 0
				Aadd(aListTot,{	cMovSitef->PBD_DTTRAN,;
									   0.00,;
									   0.00,;
										0.00,;
									   0.00,;
										cMovSitef->PBD_VLCOM})
			Else
				aListTot[nPosArr,6] += cMovSitef->PBD_VLCOM
			Endif	
		ElseIf Alltrim(Upper(cAlias)) $ "CARQPCONC"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBC_EMISS,;
									   0.00,;
									   (cAlias)->PBC_TOTCOM*-1,;
									   0.00,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,3] -= (cAlias)->PBC_TOTCOM
				aListTot[nPosArr,5] += (cAlias)->PBC_TOTCOM
			Endif	
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == cMovSitef->PBD_DTTRAN})
			If nPosArr == 0
				Aadd(aListTot,{	cMovSitef->PBD_DTTRAN,;
									   0.00,;
									   0.00,;
										0.00,;
									   0.00,;
										cMovSitef->PBD_VLCOM})
			Else
				aListTot[nPosArr,6] += cMovSitef->PBD_VLCOM
			Endif	
		Endif
					
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁExclui o registro do folder de conciliacoes manuais         				Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectArea(cAlias)
		DbGoTo(nRecAtu)
		RecLock(cAlias,.F.)
		DbDelete()
		MsUnlock()       

		DbSelectArea(cAlias)
		DbSkip()
	Enddo
	DbSelectArea(cAlias)
	Pack
			
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAtualiza os objetos                                            			Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If oLBoxOper <> Nil
		oLBoxOper:Refresh()
	Endif
	If oLBoxSitef <> Nil
		oLBoxSitef:Refresh()             
	Endif
	If oLBoxConc <> Nil
		oLBoxConc:Refresh()
	Endif
	If oLBoxPConc <> Nil
		oLBoxPConc:Refresh()
	Endif
	If oLBoxMConc <> Nil
		oLBoxMConc:Refresh()
	Endif
	If oFolder <> Nil
		oFolder:Refresh()
	Endif
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza o ListBox de totais                          						Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	AtuLBxTot()

	CursorArrow()
Else
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Restaura a area        	          												Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	RestArea(aAreaConc)
	RestArea(aAreaPConc)
	RestArea(aAreaMConc)
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza os botoes                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AtuBtn()
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a area        	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RestArea(aArea)

Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁVisualSit Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Tela de visualizacao do link do PBC com PBD                 Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function VisualSit(cAlias)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cTitulo  		:= OemToAnsi("Movimentacao Sitef")
Local nOpc     		:= 0
Local oListBox
Local oSay
Local oDlg
Local cRecOper			:= ""
Private cCadastro		:= OemToAnsi("Movimentacao Sitef")
Private aRotina 		:= { { " "," ",0,1 } ,{ " "," ",0,2 },{ " "," ",0,3 } }
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se exibe                                                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Alltrim(Upper(cAlias)) $ "CARQSITEF/CARQOPER"
	U_Aviso("Conciliacao","Opcao somente disponМvel para as pastas Conciliacao, Conciliacao Parcial ou Conciliacao Manual.",{"Ok"},,OemtoAnsi("Atencao:"))
	Return
Endif
cRecOper			:= (cAlias)->RECPBC

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o array de exibicao                                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cMovSitef")
DbSetOrder(1)
If DbSeek(cRecOper) 
	DbSelectArea("PBD")
	DbGoTo(Val(cMovSitef->RECPBD))
	AxVisual("PBD",PBD->(Recno()),2)
Else
	U_Aviso("Inconsistencia","Nao foram localizadas movimentacoes Sitef relacionadas a essa movimentacao da operadora.",{"Ok"},,OemtoAnsi("Atencao:"))
Endif

Return()

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁTrocaFolderЁ Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддедддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Evento na troca dos folders                                 Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function TrocaFolder(nFolder)

nFolder := Iif(nFolder == Nil, 1, nFolder)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Seta o foco no listbox de acordo com o foder                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*
If nFolder == 1
	oLBoxConc:SetFocus(.T.)
	oLBoxConc:Refresh()
ElseIf nFolder == 2
	oLBoxPConc:SetFocus(.T.)
	oLBoxPConc:Refresh()
ElseIf nFolder == 3
	oLBoxMConc:SetFocus(.T.)
	oLBoxMConc:Refresh()
ElseIf nFolder == 4
	oLBoxSitef:SetFocus(.T.)
	oLBoxSitef:Refresh()
Endif
oFolder:Refresh()	
*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza o ListBox de totais                          						Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AtuLBxTot()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza os botoes                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AtuBtn()

Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁPesqList  Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Tela de pesquisa                                            Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function PesqList()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Realiza a pesquisa                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(cAliasAtu)
If Alltrim(Upper(cAliasAtu)) == "CARQSITEF"
	U_AxPesqui("PBD", cAliasAtu)
	oLBoxSitef:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQOPER"
	U_AxPesqui("PBC", cAliasAtu)
	oLBoxOper:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQPCONC"
	U_AxPesqui("PBC", cAliasAtu)
	oLBoxPConc:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQMCONC"
	U_AxPesqui("PBC", cAliasAtu)
	oLBoxMConc:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQCONC"
	U_AxPesqui("PBC", cAliasAtu)
	oLBoxConc:Refresh()
Endif

Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁFiltraListЁ Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Filtra a lista                                              Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function FiltraList()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cFiltro := ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Realiza a pesquisa                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(cAliasAtu)
If Alltrim(Upper(cAliasAtu)) == "CARQSITEF"
	cFiltro := BuildExpr("PBD",,(cAliasAtu)->(dbFilter()))
	If !Empty(cFiltro)
		DbSelectArea(cAliasAtu)
		SET FILTER TO &(cFiltro)
	Else
		DbSelectArea(cAliasAtu)
		SET FILTER TO
	Endif
	oLBoxSitef:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQOPER"
	cFiltro := BuildExpr("PBC",,(cAliasAtu)->(dbFilter()))
	If !Empty(cFiltro)
		DbSelectArea(cAliasAtu)
		SET FILTER TO &(cFiltro)
	Else
		DbSelectArea(cAliasAtu)
		SET FILTER TO
	Endif
	oLBoxOper:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQPCONC"
	cFiltro := BuildExpr("PBC",,(cAliasAtu)->(dbFilter()))
	If !Empty(cFiltro)
		DbSelectArea(cAliasAtu)
		SET FILTER TO &(cFiltro)
	Else
		DbSelectArea(cAliasAtu)
		SET FILTER TO
	Endif
	oLBoxPConc:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQMCONC"
	cFiltro := BuildExpr("PBC",,(cAliasAtu)->(dbFilter()))
	If !Empty(cFiltro)
		DbSelectArea(cAliasAtu)
		SET FILTER TO &(cFiltro)
	Else
		DbSelectArea(cAliasAtu)
		SET FILTER TO
	Endif
	oLBoxMConc:Refresh()
ElseIf Alltrim(Upper(cAliasAtu)) == "CARQCONC"
	cFiltro := BuildExpr("PBC",,(cAliasAtu)->(dbFilter()))
	If !Empty(cFiltro)
		DbSelectArea(cAliasAtu)
		SET FILTER TO &(cFiltro)
	Else
		DbSelectArea(cAliasAtu)
		SET FILTER TO
	Endif
	oLBoxConc:Refresh()
Endif

Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁAtuInd    Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Funcao de atualizacao dos indicadores                       Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function AtuInd()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cRecOper		:= cArqPConc->RECPBC

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Zera o Iindicador                                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aListInd  	:= {{.t.,OemtoAnsi("Nro. Cartao"),"","",.t.,"Valor",Transform(0.00,"@E 9,999,999.99"),Transform(0.00,"@E 9,999,999.99"),.t.,"Administradora","",""},{.t.,"Nro. Compr.","","",.t.,OemtoAnsi("Emissao"),"","",.t.,"Total Parcelas","",""}}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Pesquisa o link com a movimentacao do Sitef                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("cMovSitef")
DbSetOrder(1)
If !DbSeek(cRecOper) .and. !Empty(cRecOper)
	U_Aviso("Inconsistencia","Nao foi possМvel localizar o movimentacao do Sitef relacionada a essa movimentacao da Operadora para atualizar os indicadores.",{"Ok"},,OemtoAnsi("Atencao:"))
ElseIf !Empty(cRecOper)
	If (cArqPConc->PBC_CARTAO <> cMovSitef->PBD_CARTAO) .and. (cArqPConc->PBC_CART1 <> cMovSitef->PBD_CARTAO)
		aListInd[1,1]	:= .F.
	Endif
	aListInd[1,3]	:= cArqPConc->PBC_CARTAO
	aListInd[1,4]	:= cMovSitef->PBD_CARTAO
	If cArqPConc->PBC_TOTCOM <> cMovSitef->PBD_VLCOM
		aListInd[1,5]	:= .F.
	Endif
	aListInd[1,7]	:= Transform(cArqPConc->PBC_TOTCOM,"@E 9,999,999.99")
	aListInd[1,8]	:= Transform(cMovSitef->PBD_VLCOM,"@E 9,999,999.99")
	If cArqPConc->PBC_CODADM <> Substr(cMovSitef->PBD_ADM,1,2)
		aListInd[1,9]	:= .F.
	Endif
	aListInd[1,11]	:= cArqPConc->PBC_CODADM
	aListInd[1,12]	:= Substr(cMovSitef->PBD_ADM,1,2)
	If Substr(cArqPConc->PBC_NCV,1,9) <> cMovSitef->PBD_NSU
		aListInd[2,1]	:= .F.
	Endif
	aListInd[2,3]	:= Substr(cArqPConc->PBC_NCV,1,9)
	aListInd[2,4]	:= cMovSitef->PBD_NSU
	If cArqPConc->PBC_EMISS <> cMovSitef->PBD_DTTRAN
		aListInd[2,5]	:= .F.
	Endif
	aListInd[2,7]	:= cArqPConc->PBC_EMISS
	aListInd[2,8]	:= cMovSitef->PBD_DTTRAN
	If cArqPConc->PBC_TOTPAR <> cMovSitef->PBD_TOTPAR
		aListInd[2,9]	:= .F.
	Endif
	aListInd[2,11]	:= cArqPConc->PBC_TOTPAR
	aListInd[2,12]	:= cMovSitef->PBD_TOTPAR
Endif 
oLBoxInd:Refresh()
Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁGravaCR   Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Funcao de Gravacao da Conciliacao e do Contas a Receber     Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function GravaCR()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArquivos	:= {}         
Local nX				:= 0
Local nY				:= 0
Local nZ				:= 0
Local cAlias   	:= ""
Local lGeraSE1		:= .F.
Local cUltTit		:= ""
Local cQuery		:= ""
Local nTotParcs	:= 0
Local aParcelas	:= {} 
Local aParcPBC		:= {}
Local nValParc		:= 0.00
Local nValLiq 		:= 0.00
Local nDifSaldo 	:= 0.00
Local nDifParc  	:= 0.00
Local nPosArr		:= 0
Local cParcela		:= ""
Local dVencto		:= CTOD("")
Local nValForte	:= 0.00
Local lHeadProva 	:= .F.
Local lPadrao 		:= VerPadrao("500")
Local cPadrao		:= "500"
Local cLote			:= "9999"
Local cArquivo		:= ""
Local nHdlPrv		:= 0
Local nTotal		:= 0.00
Local lDigita 		:= .T.
Local lAglutina 	:= .T.
Local aIdent		:= {}
Local cOper			:= ""
Local aVenctos		:=	{}
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Arquivos que serao processados                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Aadd(aArquivos, {"cArqConc"	,"Conciliados"						,"C"})
Aadd(aArquivos, {"cArqPConc"	,"Conciliados Parcialmente"	,"P"})
Aadd(aArquivos, {"cArqMConc"	,"Conciliados Manualmente"		,"M"})
Aadd(aArquivos, {"cArqOper"	,OemtoAnsi("Nao Conciliados")	,"N"})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a gravacao de cada um dos arquivos                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nX := 1 to Len(aArquivos)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Define o alias a ser processado                                        Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cAlias := aArquivos[nX,1]

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Executa um while no arquivo inteiro                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea(cAlias)
	DbSetOrder(1)
	Set Filter to
	DbGoTop()
	ProcRegua((cAlias)->(RecCount()))
	While !EOF()
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Incrementa a regua de processamento                                    Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   IncProc(OemtoAnsi("Processando registros "+aArquivos[nX,2]+"..."))

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Reinicializa variaveis                                                 Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		lGeraSE1 := .T. 
                                 
		/*
		If aScan(aIdent, (cAlias)->PBC_IDENT) > 0
			DbSelectArea(cAlias)
			DbSkip()
			Loop
		Endif
		*/

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifica se gera o titulo a receber                                    Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If Empty((cAlias)->PBC_TITULO)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica nos demais registros do resumo de venda                       Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("PBC")               
			DbSetOrder(8)
			DbSeek(xFilial("PBC")+(cAlias)->PBC_IDENT,.F.)
			While !EOF() .and. PBC->PBC_FILIAL+PBC->PBC_IDENT == xFilial("PBC")+(cAlias)->PBC_IDENT
				If !Empty(PBC->PBC_TITULO)
					lGeraSE1	:= .F.
					Exit
				Endif
				DbSelectArea("PBC")
				DbSkip()
			Enddo     
		Else
			lGeraSE1 := .F.
		Endif
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Valida cada movimento do resumo de venda e valida as informacoes       Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lGeraSE1 == .T.
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Reinicializa as variaveis a serem utilizadas no processamento          Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			aParcelas	:= {}
			aParcPBC 	:= {}
			Aadd(aIdent, (cAlias)->PBC_IDENT)
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Processa todos os comprovantes de venda desse resumo                   Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("PBC")               
			DbSetOrder(8)
			DbSeek(xFilial("PBC")+(cAlias)->PBC_IDENT,.F.)
			While !EOF() .and. PBC->PBC_FILIAL+PBC->PBC_IDENT == xFilial("PBC")+(cAlias)->PBC_IDENT
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Posiciona no Resumo de Venda                                           Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectArea("PBB")
				DbSetOrder(5)			
				If !DbSeek(xFilial("PBB")+PBC->PBC_IDENT,.F.)
					U_Aviso("Inconsistencia","Nao foi possМvel gerar o TМtulo a Receber referente ao cartao "+PBC->PBC_CARTAO+" do comprovante "+PBC->PBC_NCV+" emitido em "+DTOC(PBC->PBC_EMISS)+" no valor de R$ "+Alltrim(Transform(PBC->PBC_TOTCOM,"@E 9,999,999.99"))+Chr(13)+Chr(10)+"Resumo de Venda nao localizado.",{"Ok"},,OemtoAnsi("Atencao:"))
					lGeraSE1 := .F.
				Else
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza o PBC de acordo com o PBD para cartoes VISA                   Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If Alltrim(PBC->PBC_CODADM) == "CX" .AND. Val(PBC->PBC_TOTPAR) > 1
						DbSelectArea("cMovSitef")
						DbSetOrder(1)
						If DbSeek(Alltrim(Str(PBC->(Recno()))))		
							DbSelectArea("PBD")
							DbGoTo(Val(cMovSitef->RECPBD))
							If Abs(PBD->PBD_VLCOM - PBC->PBC_TOTCOM) <= 1.00
								DbSelectArea("PBC")
								RecLock("PBC",.F.)
								PBC->PBC_TOTCOM	:= PBD->PBD_VLCOM
								PBC->PBC_VLBRUT	:= PBD->PBD_VLCOM / Val(PBC->PBC_TOTPAR)
								PBC->PBC_VLLIQ		:= PBC->PBC_VLBRUT - PBC->PBC_VLDESC
								PBC->PBC_CHVLLQ	:= StrZero(Abs((PBC->PBC_VLBRUT - PBC->PBC_VLDESC))*100,17)
								MsUnlock()                                                                    
							Endif
						Endif		
					Endif
			
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona no cadastro de Operadoras                                    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectArea("SAE")
					DbSetOrder(1)			
					DbSeek(xFilial("SAE")+Iif(PBC->PBC_CODADM == "CC","CE",PBC->PBC_CODADM),.F.)
	
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona no cadastro de Maquinetas                                    Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectArea("PAB")
					DbSetOrder(2)			
					If !DbSeek(xFilial("PAB")+Iif(PBC->PBC_CODADM == "CC","CE",PBC->PBC_CODADM)+Space(1)+PBC->PBC_CODMAQ,.F.)
						U_Aviso("Inconsistencia","Nao foi possМvel gerar o TМtulo a Receber referente ao cartao "+PBC->PBC_CARTAO+" do comprovante "+PBC->PBC_NCV+" emitido em "+DTOC(PBC->PBC_EMISS)+" no valor de R$ "+Alltrim(Transform(PBC->PBC_TOTCOM,"@E 9,999,999.99"))+Chr(13)+Chr(10)+"Maquineta nao localizada.",{"Ok"},,OemtoAnsi("Atencao:"))
						lGeraSE1 := .F.
					Else
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Verifica o total de parcelas                                           Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If PBC->PBC_TOTPAR == "00" .or. Empty(PBC->PBC_TOTPAR)
							nTotParcs := 1
						Else
							nTotParcs := Val(PBC->PBC_TOTPAR)
						Endif

						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Desmembra as parcelas                                                  Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
                  nTotLiq	:= PBC->PBC_TOTCOM-PBC->PBC_DESCTO
                  nTotParc	:= PBC->PBC_TOTCOM
                  
						For nY := 1 to nTotParcs
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Define o valor de cada parcela                                         Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If	PBC->PBC_CODADM=="CA" .OR. ( SAE->(FieldPos('AE_CCARTR')) > 0 .And.  SAE->AE_CCARTR == '2')
								nValParc 	:= Round(PBC->PBC_TOTCOM/nTotParcs,2)
								nValLiq		:=	nValParc-Round(PBC->PBC_DESCTO/nTotParcs,2)
							Else
								nValParc 	:= NoRound(PBC->PBC_TOTCOM/nTotParcs,2)
								nValLiq		:=	nValParc - NoRound(PBC->PBC_DESCTO/nTotParcs,2)
							Endif
							nTotLiq	-=	nValLiq
							nTotParc	-=	nValParc
							nPosArr 	:= Ascan(aParcelas,{|x| Alltrim(Str(x[1])) == Alltrim(Str(nY))})
							If nPosArr == 0
	 							Aadd(aParcelas, 	{nY,nValParc,nValLiq})
							Else
								aParcelas[nPosArr,2] 	+= nValParc
								aParcelas[nPosArr,3] 	+= nValLiq
							Endif
							Aadd(aParcPBC, {PBC->(Recno()),nY,nValParc})     
						Next nY   
														
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//ЁVerificar se a soma das parcelas bate com o total, se nao baterЁ
						//Ёjoga a diferenca na primeira ou na ultima parcela, de acordo   Ё
						//Ёcom a configuracao da Administradora                           Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If SAE->(FieldPos('AE_CCARRED')) > 0 .And.  SAE->AE_CCARRED== '2' //O CAMPO EXISTE E ESTA CONFIGURADO PARA ACERTAR NA ULTIMA PARCELA
							nPosArr	:=	Len(aParcelas)
						Else
							nPosArr	:=	1						
						Endif
						If nTotLiq <> 0 
							aParcelas[nPosArr][3] += nTotLiq
						Endif						
						If nTotParc <> 0 
							aParcelas[nPosArr][2]+= nTotParc
							aParcPBC[1][3]			+= nTotParc
						Endif						
					Endif	
				Endif
				DbSelectArea("PBC")
				DbSkip()
			Enddo		           
		Endif
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Posiciona no PAJ                                                       Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectArea("PBC")
		DbSetOrder(9)			
		DbSeek(xFilial("PBC")+(cAlias)->PBC_IDPBC,.F.)
		DbSelectArea("PBB")
		DbSetOrder(5)			
		DbSeek(xFilial("PBB")+(cAlias)->PBC_IDENT,.F.)
		If PBB->PBB_TPCART == "D"						
			cOper := "D"
		ElseIf PBB->PBB_TPCART == "C" .and. Val(PBB->PBB_TOTPAR) > 1
			cOper := "P"
		Else
			cOper := "C"
		Endif
		DbSelectArea("PAJ")
		DbSetOrder(4)
		If !DbSeek(xFilial("PAJ")+PBB->PBB_CODADM+Space(1)+cOper,.f.)
			U_Aviso("Inconsistencia","Nao foi possМvel gerar o TМtulo a Receber referente ao resumo "+PBB->PBB_NRV+" emitido em "+DTOC(PBB->PBB_EMISS)+" no valor de R$ "+Alltrim(Transform(PBB->PBB_VLBRUT,"@E 9,999,999.99"))+Chr(13)+Chr(10)+"Verifique o cadastro de Planos x Naturezas.",{"Ok"},,OemtoAnsi("Atencao:"))
			lGeraSE1	:= .F.
		Endif
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava o titulo no contas a receber                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lGeraSE1 .and. Len(aParcelas) > 0
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica o numero do ultimo titulo existente na base                   Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			#IFDEF TOP
				cQuery		:= " SELECT MAX(SE1.E1_NUM) AS E1_NUM"
				cQuery		+= " FROM "+RetSqlName("SE1")+" SE1 (INDEX="+RetSqlName("SE1")+"1 NOLOCK)"
				cQuery		+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
				cQuery		+= " AND SE1.E1_PREFIXO = '"+PAB->PAB_LOJA+"'"
				cQuery		+= " AND SE1.D_E_L_E_T_ <> '*'"

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Monta a query com o retorno                                				Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If Select("SE1TMP") > 0
					DbSelectArea("SE1TMP")
					DbCloseArea()
				Endif
				TcQuery cQuery New Alias "SE1TMP"
				DbSelectArea("SE1TMP")
				DbGoTop()
				If !EOF()
					cUltTit 	:= Soma1(SE1TMP->E1_NUM,6)
				Else
					cUltTit	:= "000001"
				Endif
				If Select("SE1TMP") > 0
					DbSelectArea("SE1TMP")
					DbCloseArea()
				Endif
			#ELSE	
				CursorWait()
				DbSelectArea("SE1")
				DbSetOrder(1)
				If !DbSeek(xFilial("SE1")+PAB->PAB_LOJA,.F.)
					cUltTit	:= "000001"
				Else
					DbSeek(xFilial("SE1")+PAB->PAB_LOJA+"Z",.T.)
					DbSkip(-1)				                                              	
					cUltTit := Soma1(SE1->E1_NUM,6)
					While DbSeek(xFilial("SE1")+PAB->PAB_LOJA+cUltTit,.F.)
						cUltTit 	:= Soma1(cUltTit,6)
					Enddo
				Endif
				CursorArrow()
			#ENDIF 					
			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se existira duplicacao                                        Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("SE1")
   		DbSetOrder(1)
   		While DbSeek(xFilial("SE1")+PAB->PAB_LOJA+cUltTit,.F.)
   			cUltTit := Soma1(cUltTit,6)
   		Enddo
                       
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Reinicializa variaveis                                                 Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cParcela := "0"            
			dVencto	:= PBB->PBB_CREDIT
				
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava o SE1                                                            Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			aSort(aParcelas,,,{|x,y| x[1] <= y[1]})
			If PBB->PBB_TPCART == "D" //Cartao de debito tem parcela unica e a data ja esta no PBB_CREDIT
				aVenctos	:=	{PBB->PBB_CREDIT}
			Else
				aVenctos	:=	DatasVenc(PBB->PBB_EMISS,Len(aParcelas),SAE->AE_VENCFIN,SAE->AE_TIPVENC)
			Endif
			For nY := 1 to Len(aParcelas)
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Define a Parcela                                                       Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cParcela := MaParcela(cParcela)
//				dVencto	:= PBB->PBB_CREDIT + (30*(nY-1))
//				dVencto	:= aVenctos[nY] Rodrigo 08/04/05
				dVencto	:= Iif(PBB->PBB_TPCART=="D",PBB->PBB_CREDIT,aVenctos[nY])
				DbSelectArea("SE1")
				DbSetOrder(1)
				RecLock("SE1",.T.)
				SE1->E1_FILIAL		:= xFilial("SE1")
				SE1->E1_PREFIXO	:= PAB->PAB_LOJA
				SE1->E1_NUM			:= cUltTit
				SE1->E1_PARCELA	:= cParcela
				SE1->E1_TIPO    	:= Iif(PBC->PBC_TPCART == "D","CD","CC")
				SE1->E1_CLIENTE	:= PAJ->PAJ_CLIENT
				SE1->E1_LOJA		:= PAJ->PAJ_LOJA
				SE1->E1_NOMCLI		:= Posicione("SA1",1,xFilial("SA1")+PAJ->PAJ_CLIENT+PAJ->PAJ_LOJA+"01","A1_NREDUZ")
				SE1->E1_EMISSAO	:= PBB->PBB_EMISS
				SE1->E1_EMIS1		:= PBB->PBB_EMISS
				SE1->E1_VENCTO		:= dVencto
				SE1->E1_VENCREA	:= DataValida(dVencto,.T.)
				SE1->E1_VENCORI	:= dVencto
				SE1->E1_VALOR		:= aParcelas[nY,2]
				SE1->E1_SALDO		:= aParcelas[nY,2]
				SE1->E1_VLCRUZ 	:= xMoeda (aParcelas[nY,2],1,1,PBB->PBB_EMISS)
				SE1->E1_MOEDA		:= 1
				SE1->E1_NATUREZ	:= PAJ->PAJ_NATURE
				SE1->E1_SITUACA	:= "0"
				SE1->E1_LA        := Iif(lPadrao .and. mv_par05==1,"S","")
				SE1->E1_ORIGEM		:= "FINA040"
				SE1->E1_FLUXO		:= "S"
				SE1->E1_STATUS		:= "A"
				SE1->E1_REGCART	:= PBB->PBB_NRV       
				SE1->E1_HIST		:= Iif(PBB->PBB_TPCART == "D",Iif(PBB->PBB_CODADM = "CX","VISA ELECTRON","VENDA DEBITO"),"VENDA CREDITO "+IIF(Val(PBB->PBB_TOTPAR) > 1,"PARCELADO","ROTATIVO"))
				SE1->E1_ADM     	:= PBB->PBB_CODADM    
				MsUnlock()

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza Acumulado de Clientes														Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
					If SE1->E1_TIPO != "RA " .And. !SE1->E1_TIPO $ MV_CRNEG
						DbSelectArea("SA1")
						Reclock("SA1",.F.)
						SA1->A1_VACUM	 	:= SA1->A1_VACUM + xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1,SE1->E1_EMISSAO)
						nValForte 			:= ConvMoeda(SE1->E1_EMISSAO,SE1->E1_VENCTO,Moeda(SE1->E1_VALOR,1,"R"),GetMv("MV_MCUSTO"))
						SA1->A1_SALDUP 	+= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1,SE1->E1_EMISSAO)
						SA1->A1_SALDUPM	+= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1,SE1->E1_EMISSAO)
						SA1->A1_MSALDO 	:=Iif(SA1->A1_SALDUPM>SA1->A1_MSALDO,SA1->A1_SALDUPM,SA1->A1_MSALDO)
						If (nValForte > A1_MAIDUPL)
							SA1->A1_MAIDUPL := nValForte
						EndIf
						MsUnlock()
					EndIf
				Endif   

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza a Tabela de relacionamento entre C.R. e Cartao						Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    			For nZ := 1 to Len(aParcPBC)
					If aParcPBC[nZ,2] <> nY
						Loop					
					Endif    			
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona no PBC                                         					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectArea("PBC")
					DbGoTo(aParcPBC[nZ,1])
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava o PBE                                              					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectArea("PBE")
					RecLock("PBE",.T.)
					PBE->PBE_FILIAL	:= xFilial("PBE")
					PBE->PBE_PREFIX	:= SE1->E1_PREFIXO
					PBE->PBE_TITULO	:= SE1->E1_NUM
					PBE->PBE_PARTIT	:= SE1->E1_PARCELA
					PBE->PBE_TIPTIT	:= SE1->E1_TIPO
					PBE->PBE_CLIENT	:= SE1->E1_CLIENTE
					PBE->PBE_LOJA  	:= SE1->E1_LOJA
					PBE->PBE_NOMCLI	:= SE1->E1_NOMCLI
					PBE->PBE_EMISSA	:= SE1->E1_EMISSAO
					PBE->PBE_VENORI	:= SE1->E1_VENCORI
//					PBE->PBE_VENCTO	:= SE1->E1_VENCTO
					PBE->PBE_VENCTO	:= SE1->E1_VENCREA
					PBE->PBE_IDPBC 	:= PBC->PBC_IDPBC
					PBE->PBE_IDENT 	:= PBC->PBC_IDENT
					PBE->PBE_PARCRT	:= StrZero(aParcPBC[nZ,2],2)
					PBE->PBE_VALOR 	:= aParcPBC[nZ,3]
					PBE->PBE_TPOPER	:= "P"
					PBE->PBE_USROPE	:= Substr(cUsuario,7,15)
					PBE->PBE_DTOPER	:= dDataBase
					MsUnlock()
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza o PBC                                           					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					RecLock("PBC",.F.)					
					If Empty(PBC->PBC_TITULO)
						PBC->PBC_PREFIX	:= SE1->E1_PREFIXO
						PBC->PBC_TITULO	:= SE1->E1_NUM
						PBC->PBC_TIPTIT	:= SE1->E1_TIPO
						PBC->PBC_CLIENT	:= SE1->E1_CLIENTE
						PBC->PBC_LOJA  	:= SE1->E1_LOJA
						PBC->PBC_NOMCLI	:= SE1->E1_NOMCLI
						PBC->PBC_EMISSA	:= SE1->E1_EMISSAO
						PBC->PBC_VENORI	:= SE1->E1_VENCORI
//						PBC->PBC_VENCTO	:= SE1->E1_VENCTO
						PBC->PBC_VENCTO	:= SE1->E1_VENCREA
					Endif 
					MsUnlock()
    			Next nZ
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Cria o titulo da taxa administrativa                     					Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If aParcelas[nY,2] > aParcelas[nY,3]
					DbSelectArea("SE1")
					DbSetOrder(1)
					RecLock("SE1",.T.)
					SE1->E1_FILIAL		:= xFilial("SE1")
					SE1->E1_PREFIXO	:= PAB->PAB_LOJA
					SE1->E1_NUM			:= cUltTit
					SE1->E1_PARCELA	:= cParcela
					SE1->E1_TIPO    	:= "CO-"
					SE1->E1_CLIENTE	:= PAJ->PAJ_CLIENT
					SE1->E1_LOJA		:= PAJ->PAJ_LOJA
					SE1->E1_NOMCLI		:= Posicione("SA1",1,xFilial("SA1")+PAJ->PAJ_CLIENT+PAJ->PAJ_LOJA+"01","A1_NREDUZ")
					SE1->E1_EMISSAO	:= PBC->PBC_EMISS
					SE1->E1_EMIS1		:= PBC->PBC_EMISS
					SE1->E1_VENCTO		:= dVencto
					SE1->E1_VENCREA	:= DataValida(dVencto,.T.)
					SE1->E1_VENCORI	:= dVencto
					SE1->E1_VALOR		:= aParcelas[nY,2]-aParcelas[nY,3]
					SE1->E1_SALDO		:= aParcelas[nY,2]-aParcelas[nY,3]
					SE1->E1_VLCRUZ 	:= xMoeda (aParcelas[nY,2],1,1,PBC->PBC_EMISS)
					SE1->E1_MOEDA		:= 1
					SE1->E1_NATUREZ	:= PAJ->PAJ_NATURE
					SE1->E1_SITUACA	:= "0"
					SE1->E1_LA        := Iif(lPadrao .and. mv_par05==1,"S","")
					SE1->E1_ORIGEM		:= "FINA040"
					SE1->E1_FLUXO		:= "S"
					SE1->E1_STATUS		:= "A"
					SE1->E1_REGCART	:= PBC->PBC_NRV       
					SE1->E1_HIST		:= Iif(PBC->PBC_TPCART == "D",Iif(PBC->PBC_CODADM = "CX","VISA ELECTRON","VENDA DEBITO"),"VENDA CREDITO "+IIF(Val(PBC->PBC_TOTPAR) > 1,"PARCELADO","ROTATIVO"))
					SE1->E1_ADM     	:= PBC->PBC_CODADM    
					MsUnlock()
				Endif

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica se contabiliza on-line														Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If MV_PAR05 == 1
					If !lHeadProva .and. lPadrao
						nHdlPrv		:= HeadProva(cLote,"FINA460",Substr(cUsuario,7,6),@cArquivo)
						lHeadProva 	:= .T.
					EndIf
					If lPadrao
						nTotal += DetProva(nHdlPrv,cPadrao,"FINA460",cLote)
					EndIf
				EndIf
			Next nY
		Endif

		DbSelectArea("PBC")               
		DbSetOrder(9)
		If DbSeek(xFilial("PBC")+(cAlias)->PBC_IDPBC,.F.)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza o PBC                                           					Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			RecLock("PBC",.F.)					
			PBC->PBC_CONC 		:= aArquivos[nX,3]
			MsUnlock()
		Endif
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Posiciona no Resumo de Venda                                           Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectArea("PBB")
		DbSetOrder(5)			
		DbSeek(xFilial("PBB")+(cAlias)->PBC_IDENT,.F.)
		RecLock("PBB",.F.)					
		PBB->PBB_CONC 		:= aArquivos[nX,3]
		MsUnlock()

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Pesquisa o relacionamento com o Sitef                                  Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectArea("cMovSitef")
		DbSetOrder(1)
		If DbSeek((cAlias)->RECPBC)		
			DbSelectArea("PBD")
			DbGoTo(Val(cMovSitef->RECPBD))
			RecLock("PBD",.F.)
			PBD->PBD_CONC	:= aArquivos[nX,3]
			PBD->PBD_IDPBC	:= (cAlias)->PBC_IDPBC
			MsUnlock()
		Endif		

		DbSelectArea(cAlias)
		DbSkip()                      	
	Enddo		
Next nX


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Gera Contabilizacao                												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
VALOR := 0
If nTotal > 0
	RodaProva(nHdlPrv,nTotal)
	lDigita		:= Iif(mv_par06 == 1,.T.,.F.)
	lAglutina	:= .F.
	CA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglutina)
EndIf

Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁDescartar Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Funcao de descarte das movimentacoes                        Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function Descartar()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea			:= GetArea()
Local aAreaConc	:= cArqConc->(GetArea())
Local aAreaPConc	:= cArqPConc->(GetArea())
Local aAreaMConc	:= cArqMConc->(GetArea())
Local lProc			:= .T.
Local nNewRec		:= 0
Local cRecOper		:= 0
Local nIndSitef	:= cArqSitef->(IndexOrd())
Local nIndOper 	:= cArqOper->(IndexOrd())
Local nIndMarca	:= 0                                        
Local cAlias		:= cAliasAtu

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se existem registros selecionados										Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea(cAlias)
If RecCount() == 0
	U_Aviso("Inconsistencia","Nao existem registros a serem descartados disponМveis.",{"Ok"},,OemtoAnsi("Atencao"))
	lProc := .F.
Else
	If U_Aviso(OemtoAnsi("Confirmacao"),"Confirma o descarte dos registros selecionados?",{"Sim","Nao"},,OemtoAnsi("Atencao")) == 2
		lProc := .F.
   Endif
Endif                              

If Alltrim(Upper(cAlias)) $ "CARQCONC"
	nIndMarca	:= Len(aIndConc)
ElseIf Alltrim(Upper(cAlias)) $ "CARQPCONC"
	nIndMarca	:= Len(aIndPConc)
ElseIf Alltrim(Upper(cAlias)) $ "CARQMCONC"
	nIndMarca	:= Len(aIndMConc)
ElseIf Alltrim(Upper(cAlias)) $ "CARQSITEF"
	nIndMarca	:= Len(aIndSitef)
Else
	nIndMarca	:= Len(aIndOper)
Endif
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processam o registro atual                  									Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lProc            
	CursorWait()
	DbSelectArea(cAlias)
	DbSetOrder(nIndMarca)
	DbSeek("S",.F.)
	While !EOF() .and. (cAlias)->MARCA == "S"
		If !Alltrim(Upper(cAlias)) $ "CARQSITEF/CARQOPER"
			DbSelectArea("cMovSitef")
			DbSetOrder(1)
			If !DbSeek((cAlias)->RECPBC,.F.)
				U_Aviso("Inconsistencia","Nao foi possМvel localizar o link de conciliacao das movimentacoes do Sitef referente ao cartao "+(cAlias)->PBC_CARTAO+" do comprovante "+(cAlias)->PBC_NCV+" emitido em "+DTOC((cAlias)->PBC_EMISS)+" no valor de R$ "+Alltrim(Transform((cAlias)->PBC_TOTCOM,"@E 9,999,999.99")),{"Ok"},,OemtoAnsi("Atencao:"))
			Else
				RecLock("cMovSitef",.F.)
				DbDelete()
				MsUnlock()                                  
			Endif
		Endif
						
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Atualiza o PBC                                        						Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !Alltrim(Upper(cAlias)) $ "CARQSITEF"
			DbSelectArea("PBC")               
			DbSetOrder(9)
			If DbSeek(xFilial("PBC")+(cAlias)->PBC_IDPBC,.F.)
				RecLock("PBC",.F.)
				PBC->PBC_CONC	:= "D"
				MsUnlock()
			Endif                   
			DbSelectArea("PBB")
			DbSetOrder(5)
			If DbSeek(xFilial("PBB")+(cAlias)->PBC_IDENT,.F.)
				RecLock("PBB",.F.)
				PBB->PBB_CONC := "D"
				MsUnlock()
			Endif
		Endif

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Atualiza os totais                                                     Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If Alltrim(Upper(cAlias)) $ "CARQMCONC"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBC_EMISS,;
									   0.00,;
									   0.00,;
									   (cAlias)->PBC_TOTCOM*-1,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,4] -= (cAlias)->PBC_TOTCOM
			Endif	
		ElseIf Alltrim(Upper(cAlias)) $ "CARQCONC"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBC_EMISS,;
									   (cAlias)->PBC_TOTCOM*-1,;
									   0.00,;
									   0.00,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,2] -= (cAlias)->PBC_TOTCOM
			Endif	
		ElseIf Alltrim(Upper(cAlias)) $ "CARQPCONC"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBC_EMISS,;
									   0.00,;
									   (cAlias)->PBC_TOTCOM*-1,;
									   0.00,;
									   0.00,;
										0.00})
			Else
				aListTot[nPosArr,3] -= (cAlias)->PBC_TOTCOM
			Endif	
		ElseIf Alltrim(Upper(cAlias)) $ "CARQOPER"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBC_EMISS})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBC_EMISS,;
									   0.00,;
									   0.00,;
									   0.00,;
									   (cAlias)->PBC_TOTCOM*-1,;
										0.00})
			Else
				aListTot[nPosArr,5] -= (cAlias)->PBC_TOTCOM
			Endif	
		ElseIf Alltrim(Upper(cAlias)) $ "CARQSITEF"
			nPosArr 	:= Ascan(aListTot,{|x| x[1] == (cAlias)->PBD_DTTRAN})
			If nPosArr == 0
				Aadd(aListTot,{	(cAlias)->PBD_DTTRAN,;
									   0.00,;
									   0.00,;
									   0.00,;
									   (cAlias)->PBD_VLCOM*-1,;
										0.00})
			Else
				aListTot[nPosArr,6] -= (cAlias)->PBD_VLCOM
			Endif	
		Endif
				
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Exclui o registro                                     						Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectArea(cAlias)
		RecLock(cAlias,.F.)
		DbDelete()
		MsUnlock()
	
		DbSelectArea(cAlias)
		DbSkip()
	Enddo
	DbSelectArea(cAlias)
	Pack		
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁAtualiza os objetos                                            			Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If oLBoxOper <> Nil
		oLBoxOper:Refresh()
	Endif
	If oLBoxSitef <> Nil
		DbSelectArea("cArqSitef")
		DbSetOrder(1)
		oLBoxSitef:nAt := 1
		//oLBoxSitef:Refresh()             
	Endif
	If oLBoxConc <> Nil
		oLBoxConc:Refresh()
	Endif
	If oLBoxPConc <> Nil
		oLBoxPConc:Refresh()
	Endif
	If oLBoxMConc <> Nil
		oLBoxMConc:Refresh()
	Endif
	If oFolder <> Nil
		oFolder:Refresh()
	Endif
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza o ListBox de totais                          						Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	AtuLBxTot()
	
	CursorArrow()
Else
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Restaura a area        	          												Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	RestArea(aAreaConc)
	RestArea(aAreaPConc)
	RestArea(aAreaMConc)
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza os botoes                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AtuBtn()
	
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a area        	          												Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RestArea(aArea)
Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁAtuBtn    ╨ Autor Ё                    ╨ Data Ё             ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Rotina de atualizacao dos botoes                           ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function AtuBtn()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Atualiza os botoes                                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If cArqConc->(RecCount()) == 0
	oBtn1:bWhen := {|| .F.}
	oBtn2:bWhen := {|| .F.}
Else
	oBtn1:bWhen := {|| .T.}
	oBtn2:bWhen := {|| .T.}
Endif
If cArqPConc->(RecCount()) == 0
	oBtn3:bWhen := {|| .F.}
	oBtn4:bWhen := {|| .F.}
Else
	oBtn3:bWhen := {|| .T.}
	oBtn4:bWhen := {|| .T.}
Endif   
If cArqMConc->(RecCount()) == 0
	oBtn5:bWhen := {|| .F.}
	oBtn6:bWhen := {|| .F.}
Else
	oBtn5:bWhen := {|| .T.}
	oBtn6:bWhen := {|| .T.}
Endif
If cArqSitef->(RecCount()) == 0 .or. cArqOper->(RecCount()) == 0
	oBtn8:bWhen := {|| .F.}
Else
	oBtn8:bWhen := {|| .T.}
Endif
If cArqSitef->(RecCount()) > 0 .or. cArqOper->(RecCount()) > 0
	oBtn7:bWhen := {|| .T.}
Else
	oBtn7:bWhen := {|| .F.}
Endif
oBtn1:Refresh()
oBtn2:Refresh()
oBtn3:Refresh()
oBtn4:Refresh()
oBtn5:Refresh()
oBtn6:Refresh()
oBtn7:Refresh()
oBtn8:Refresh()
Return()

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁAtuLBoxTot╨ Autor Ё                    ╨ Data Ё             ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Rotina de atualizacao do listbox de totais                 ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function AtuLBxTot()
aSort(aListTot,,,{|x,y| x[1] >= y[1]})
If Len(aListTot) == 0
	aListTot := {{"",0.00,0.00,0.00,0.00,0.00}}
Endif   
If oLBoxTot <> Nil
	oLBoxTot:SetArray(aListTot)
	oLBoxTot:bLine := { || {		aListTot[oLBoxTot:nAt,1],;
			   							Transform(aListTot[oLBoxTot:nAt,2],"@E 9,999,999.99"),;
			   							Transform(aListTot[oLBoxTot:nAt,3],"@E 9,999,999.99"),;
			   							Transform(aListTot[oLBoxTot:nAt,4],"@E 9,999,999.99"),;
			   							Transform(aListTot[oLBoxTot:nAt,5],"@E 9,999,999.99"),;
			   							Transform(aListTot[oLBoxTot:nAt,6],"@E 9,999,999.99"),;
			   							""}}
	oLBoxTot:Refresh()
Endif
Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁDatasvenct╨ Autor ЁBruno               ╨ Data Ё             ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Determina as datas de vencimento de cada parcela dependendo╨╠╠
╠╠╨          Ё da configuracao da administradora.                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function DatasVenc(dBase,nParcelas,nDias,cTipo)
//cTipo == 1 : Recalcula a data de base todos os meses (no mesmo dia da data base)
//			      e soma nDias a esta data de base
//cTipo == 2 : Calcula a data do primeiro vencimento ndias depois da base, os vencimentos
//					seguitnes serao no mesmo dia dos proximos meses.					
Local aDatas	:=	{}
Local dDataTmp	:=	dBase  
Local nMes	:=	0
Local nAno	:=	0
Local nDia	:=	0
Local nX		:=	0
nDias		:=	IIf(nDias==Nil,30,nDias)
nParcelas:=	IIf(nParcelas==Nil,1,nParcelas)

If cTipo <> '1'
	dBase	+=	nDias
//	dBase	:=	DataValida(dBase)
Endif
nMes	:=	Month(dBase)-1     
nAno	:=	Year(dBase)
nDia	:=	Day(dBase)
For nX:=1 To nParcelas   
	nMes ++
	nAno	:=	If(nMes == 13,nAno+1,nAno)
	nMes	:=	If(nMes == 13,01,nMes)
	dDataTmp	:=	Ctod(StrZero(nDia,2)+'/'+StrZero(nMes,2)+"/"+StrZero(nAno,4))
	While Empty(dDataTmp)                                         
		nDia--
		dDataTmp	:=	Ctod(StrZero(nDia,2)+'/'+StrZero(nMes,2)+"/"+StrZero(nAno,4))
	Enddo
	If cTipo == '1'
		AAdd(aDatas,dDataTmp+nDias)		
	Else
		AAdd(aDatas,dDataTmp)		
	Endif		
Next

Return aDatas
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁValidPerg ╨ Autor Ё                    ╨ Data Ё             ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Verifica a existencia das perguntas criando-as caso seja   ╨╠╠
╠╠╨          Ё necessario (caso nao existam).                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function ValidPerg(cPerg)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea  	:= GetArea()
Local aRegs 	:= {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

Aadd(aRegs,{cPerg,"01","Operacao             ?","mv_ch1","N",01,0,0,"C","","mv_par01","Venda" ,"","","Liquidacao","","","Ajuste","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Administradora       ?","mv_ch2","N",01,0,0,"C","","mv_par02","Visanet" ,"","","Amex","","","Redecard","","","TecBan","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Data Inicial         ?","mv_ch3","D",08,0,0,"G","","mv_par03","" ,"","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Data Final           ?","mv_ch4","D",08,0,0,"G","","mv_par04","" ,"","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Contabiliza On-Line  ?","mv_ch5","N",01,0,0,"C","","mv_par05","Sim" ,"","","Nao","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Mostra Lcto Contabil ?","mv_ch6","N",01,0,0,"C","","mv_par06","Sim" ,"","","Nao","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Somente Nao Conc.    ?","mv_ch7","N",01,0,0,"C","","mv_par07","Sim" ,"","","Nao","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Margem de dias        ","mv_ch8","N",01,0,0,"G","","mv_par08","" ,"","","","","","","","","","","","","","","","","","",""})

For i := 1 To Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
   EndIf
Next

RestArea(aArea)

Return
	
