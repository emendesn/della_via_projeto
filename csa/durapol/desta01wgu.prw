#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DESTA01  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de Producao.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Durapol                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function DESTA01()

Private aCores      := {}
Private cCadastro	:= 'Producao'
Private cIndex      := ''
Private cChave      := ''
Private cFiltro     := ''
//Usuario responsavel para realizar a inspecao Inicial(Exame)
cUserLog            := Upper(Trim(SuperGetMv("MV_USERINS",.F.,"")))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa               ³
//³ ----------- Elementos contidos por dimensao ------------              ³
//³ 1. Nome a aparecer no cabecalho                                       ³
//³ 2. Nome da Rotina associada                                           ³
//³ 3. Usado pela rotina                                                  ³
//³ 4. Tipo de Transa‡„o a ser efetuada                                   ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados                      ³
//³    2 - Simplesmente Mostra os Campos                                  ³
//³    3 - Inclui registros no Bancos de Dados                            ³
//³    4 - Altera o registro corrente                                     ³
//³    5 - Remove o registro corrente do Banco de Dados                   ³
//³    6 - Alteracao sem inclusao de registro                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aRotina:= {	{ OemToAnsi('Pesquisar')    ,'AxPesqui'    , 0, 1 },;
{ OemToAnsi('Visualizar')   ,'U_DESTA01a'  , 0, 2 },;
{ OemToAnsi('Exame Inicial'),'U_DESTA01t'  , 0, 4 },;
{ OemToAnsi('Autoclave')    ,'U_DESTA01i'  , 0, 4 },;
{ OemToAnsi('Filtrar')      ,'U_DESTA01h'  , 0, 4 },;
{ OemToAnsi('Manutencao')   ,'U_DESTA01a'  , 0, 4 },;
{ OemToAnsi('Estornar')     ,'U_DESTA01b'  , 0, 5 },;
{ OemToAnsi('Legenda')      ,'U_DESTA01c'  , 0, 2 },;
{ OemToAnsi('Gerar Pedido') ,'U_DESTA01d'  , 0, 4 } }


Aadd( aCores, { "Empty( C2_X_STATU ) .Or. C2_X_STATU == '1'", "BR_VERDE"    } )
Aadd( aCores, { "C2_X_STATU == '6'"                         , "BR_VERMELHO" } )
Aadd( aCores, { "C2_X_STATU == '4'"                         , "BR_AZUL"     } )
Aadd( aCores, { "C2_X_STATU == '5'"                         , "BR_AMARELO"  } )
Aadd( aCores, { "C2_X_STATU == '9'"                         , "BR_PRETO"    } )

//-- Endereca a funcao de BROWSE
dbSelectArea("SC2")
dbSetOrder(13)

IF Upper(Trim(Substr(cUsuario,7,15))) $ cUserLog
	If Aviso( "Pergunta", "Deseja visualizar somente OP's que foram programadas?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
		cFiltro := "( Empty( C2_X_STATU ) .Or. C2_X_STATU == '1' ) .And. C2_QUJE == 0 .And. !Empty(C2_XPRELOT) "
	Else
		cFiltro := "( Empty( C2_X_STATU ) .Or. C2_X_STATU == '1' ) .And. C2_QUJE == 0 "
	EndIf	
EndIF

Set Filter To &(cFiltro)

MBrowse( 6,1,22,75,'SC2',,,,,, aCores )

IF Upper(Trim(Substr(cUsuario,7,15))) $ cUserLog
	RetIndex("SC2")
	dbSetOrder(13) //AJUSTAR
EndIF

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01a  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Manutencao - Producao                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Opcao selecionada                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function DESTA01a( cAlias, nReg, nOpcx )

//-- Controle de dimensoes de objetos
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
//-- EnchoiceBar
Local aButtons		:= {}
Local nOpca			:= 0
//-- Enchoice
Local aVisual		:= {}
Local aAltera	    := {}
//-- Controles Gerais
Local nA            := 0
Local cCpoShow      := 'D3_TM|D3_COD|D3_UM|D3_QUANT|D3_LOCAL|D3_EMISSAO'
Local lApont      :=  .F.
Private l240        := .T.
//-- Enchoice
Private aTela[0][0]
Private aGets[0]
Private oEnch
//-- GetDados
Private aHeader	:= {}
Private aCols		:= {}
Private oGetD

//-- Define os campos que irao aparecer na tela.
Aadd( aVisual, 'C2_NUM'     )
Aadd( aVisual, 'C2_DATPRF'  )
Aadd( aVisual, 'C2_PRODUTO' )
Aadd( aVisual, 'C2_QUANT'   )
Aadd( aVisual, 'C2_DATPRI'  )
Aadd( aVisual, 'C2_OBS'     )
Aadd( aVisual, 'C2_EMISSAO' )
Aadd( aVisual, 'C2_TPOP'    )
Aadd( aVisual, 'C2_SERIEPN' )
Aadd( aVisual, 'C2_PRODUTO' )
Aadd( aVisual, 'C2_NUMFOGO' )
Aadd( aVisual, 'C2_MARCAPN' )
Aadd( aVisual, 'C2_CARCACA' )
Aadd( aVisual, 'C2_X_DESEN' )
Aadd( aVisual, 'C2_UM'      )

RegToMemory( cAlias, .F. )

SX3->( dbSetOrder( 2 ) )
SX3->( MsSeek( "D3_QUANT" ) )

Aadd(	aHeader, { "Tipo"      , "D3_TM"      , "@!"                         , 20                      , 0                    , ".T.", SX3->X3_USADO, "C", "SD3", SX3->X3_CONTEXT } )
Aadd(	aHeader, { "Produto"   , "D3_COD"     , "@!"                         , TamSX3("D3_COD")[1]     , 0                    , ".T.", SX3->X3_USADO, "N", "SD3", SX3->X3_CONTEXT } )
Aadd(	aHeader, { "Descricao"   , "D3_XDESC" , "@!"                         , TamSX3("D3_XDESC")[1]     , 0                    , ".T.", SX3->X3_USADO, "C", "SD3", SX3->X3_CONTEXT } )
Aadd(	aHeader, { "Quantidade", "D3_QUANT"   , PesqPict( "SD3", "D3_QUANT" ), TamSX3("D3_QUANT")[1]   , TamSX3("D3_QUANT")[2], ".T.", SX3->X3_USADO, "C", "SD3", SX3->X3_CONTEXT } )
Aadd(	aHeader, { "Usuario"   , "D3_USUARIO" , "@!"                         , TamSX3("D3_USUARIO")[1] , 0                    , ".T.", SX3->X3_USADO, "C", "SD3", SX3->X3_CONTEXT } )
Aadd(	aHeader, { "Data"      , "D3_EMISSAO" , "@!"                         , TamSX3("D3_EMISSAO")[1], 0                    , ".T.", SX3->X3_USADO, "D", "SD3", SX3->X3_CONTEXT } )

//-- Apenas para inibir o inicializador do campo.
M->D3_COD := ""

SD3->( dbSetOrder( 1 ) )
SD3->( MsSeek( xFilial("SD3") + M->( C2_NUM + C2_ITEM ) ) )
While SD3->( !Eof() .And. D3_FILIAL + Left( D3_OP, 8 )  ==  xFilial("SD3") + M->C2_NUM + M->C2_ITEM )
		
		//-- Desconsidero os apontamentos de Producao.
		If SD3->D3_CF == 'PR0'
			SD3->( dbSkip() )
			Loop
		EndIf
		lApont := .T.
		//-- Considero somente os produtos do grupo SC/CI - JC 20/08/05
		SB1->( dbSetOrder(1) )
		SB1->( MsSeek( xFilial("SB1") + SD3->D3_X_PROD ) ) // Reinaldo SD3->D3_COD
		
		IF ! ( Alltrim(SB1->B1_GRUPO) $ Alltrim(GetMv("MV_X_GRPRO")) )
			SD3->( dbSkip() )
			Loop
		EndIf
		
		Aadd( aCols, Array( Len( aHeader ) + 1 ) )
		
		aCols[Len( aCols ), 1 ] := SD3->D3_TM + " - " + AllTrim( Posicione( "SF5", 1, xFilial("SF5") + SD3->D3_TM, "F5_TEXTO" ) )
		aCols[Len( aCols ), 2 ] := SD3->D3_COD
		aCols[Len( aCols ), 3 ] := SD3->D3_XDESC
		aCols[Len( aCols ), 4 ] := SD3->D3_QUANT
		aCols[Len( aCols ), 5 ] := SD3->D3_USUARIO
		aCols[Len( aCols ), 6 ] := SD3->D3_EMISSAO
		
		aCols[Len( aCols ),Len( aHeader ) + 1] := .F.
		
	SD3->( dbSkip() )
EndDo

IF !lApont	
	SZF->( dbSetOrder( 1 ) )
	SZF->(MsSeek( xFilial("SZF") + M->( C2_NUM + C2_ITEM +'001' ) ) )
	
	While SZF->( !Eof() .And. SZF->ZF_FILIAL + Left(SZF->ZF_NUMOP, 8 )  ==  xFilial("SZF") + M->C2_NUM + M->C2_ITEM )
		
		//-- Considero somente os produtos do grupo SC/CI - JC 20/08/05
		SB1->( dbSetOrder(1) )
		SB1->( MsSeek( xFilial("SB1") + SZF->ZF_PRODSRV ) ) 
		
		IF !  Empty(SB1->B1_PRODUTO) 
			SZF->( dbSkip() )
			Loop
		EndIf
		
		Aadd( aCols, Array( Len( aHeader ) + 1 ) )
		
		aCols[Len( aCols ), 1 ] := "MAN" + " - " + "SERV.TERCEIRO"
		aCols[Len( aCols ), 2 ] := SZF->ZF_PRODSRV
		aCols[Len( aCols ), 3 ] := SZF->ZF_DESCRI
		aCols[Len( aCols ), 4 ] := SZF->ZF_QUANT	
		aCols[Len( aCols ), 5 ] := SZF->ZF_USUARIO
		aCols[Len( aCols ), 6 ] := SZF->ZF_DATA
		
		aCols[Len( aCols ),Len( aHeader ) + 1] := .F.
		
		SZF->( dbSkip() )
	EndDo
	
EndIF	

If	Empty( aCols )
	Aadd( aCols, Array( Len( aHeader ) + 1 ) )
	For nA := 1 To Len( aHeader )
		aCols[1,nA] := CriaVar( aHeader[nA,2] )
	Next nA
	aCols[1,Len(aHeader)+1] := .F.
EndIf

//-- Calcula as dimensoes dos objetos
aSize  := MsAdvSize(.T.)

AAdd( aObjects, { 100,40,.T.,.T. } )
AAdd( aObjects, { 100,60,.T.,.T. } )

aInfo  := { aSize[1],aSize[2],aSize[3],aSize[4], 0, 0 }
aPosObj:= MsObjSize( aInfo, aObjects, .T. )

/*
// DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] PIXEL
//	oEnch := MsMGet():New( cAlias, nReg,2,,,,aVisual,aPosObj[1],aAltera, 3, , , , , ,.T. )
//	oGetD := MSGetDados():New(aPosObj[ 2, 1 ], aPosObj[ 2, 2 ],aPosObj[ 2, 3 ]-10, aPosObj[ 2, 4 ], 2, 'AllWaysTrue','AllWaysTrue',, .T. )
//
//	If nOpcx <> 2
//		@aPosObj[ 2, 3 ]-5, aPosObj[ 2, 4 ]-100 BUTTON oLiberar PROMPT '&Liberar' SIZE 42,12 PIXEL ACTION U_DESTA01b()
//		@aPosObj[ 2, 3 ]-5, aPosObj[ 2, 4 ]-50  BUTTON oRejeitar PROMPT '&Rejeitar' SIZE 42,12 PIXEL ACTION U_DESTA01e()
//	EndIf
*/
_aPos := {}
AAdd(_aPos,aPosObj[1,1]-12)
AAdd(_aPos,aPosObj[1,2])
AAdd(_aPos,aPosObj[1,3]-1)
AAdd(_aPos,aPosObj[1,4]-22.5)
DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7]+20,00 TO aSize[6]-20,aSize[5]-50 PIXEL
oEnch := MsMGet():New( cAlias, nReg,2,,,,aVisual,_aPos,aAltera, 3, , , , , ,.T. )
/////////oEnch := MsMGet():New( cAlias, nReg,2,,,,aVisual,_aPos,aAltera, 3, , , , , ,.T., , , , ,aCampos )
oGetD := MSGetDados():New(aPosObj[ 2, 1 ], aPosObj[ 2, 2 ],aPosObj[ 2, 3 ]-40, aPosObj[ 2, 4 ]-23, 2, 'AllWaysTrue','AllWaysTrue',, .T. )

If nOpcx <> 2
	@aPosObj[ 2, 3 ]-35, aPosObj[ 2, 4 ]-130 BUTTON oLiberar PROMPT '&Liberar' SIZE 42,12 PIXEL ACTION U_DESTA01b()
	@aPosObj[ 2, 3 ]-35, aPosObj[ 2, 4 ]-80  BUTTON oRejeitar PROMPT '&Rejeitar' SIZE 42,12 PIXEL ACTION U_DESTA01e()
EndIf
ACTIVATE MSDIALOG oDlgEsp

RetFilter(SC2->(RECNO()))

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01b  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Manutencao de Movimentacoes Internas.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01b( cAlias, nReg, nOpcx )

Local aRegSD3 := {}
Local lOk     := .T.
Private lMsHelpAuto   := .F.
Private lMsErroAuto   := .F.

If nOpcx <> Nil
	nOpcx := aRotina[ nOpcx, 4 ]
EndIf

//-- Estorno.
If nOpcx == 5
	
	If SC2->C2_X_STATU <> '6' .and. SC2->C2_QUJE == 0
		MsgStop( 'Esta OP ainda nao foi produzida.' )
		RetFilter(SC2->(RECNO()))
		Return Nil
	EndIf 
	
	aSaveArea:=getarea()
	dbSelectArea("SC6")
	dbSetOrder(7)                                      
	dbSeek(xFilial("SC6") + SC2->C2_NUM+SC2->C2_ITEM )
	restArea(aSaveArea)  
	IF !Empty(SC6->C6_NOTA)    
 		MsgStop( 'Esta OP Já foi faturada ...' )
		RetFilter(SC2->(RECNO()))
		Return Nil
	endif
	
	lOk := MsgYesNo( 'Confirma o Estorno da OP ?' )
	
	SD3->( dbSetOrder( 1 ) )
	If SD3->( MsSeek( xFilial("SD3") + SC2->( C2_NUM + C2_ITEM + C2_SEQUEN ) ) ) .And. lOk
		Aadd( aRegSD3, { 'D3_FILIAL' , xFilial("SD3")  , NIL } )
		Aadd( aRegSD3, { 'D3_TM'     , SD3->D3_TM      , NIL } )
		Aadd( aRegSD3, { 'D3_COD'    , SD3->D3_COD     , NIL } )
		Aadd( aRegSD3, { 'D3_UM'     , SD3->D3_UM      , NIL } )
		Aadd( aRegSD3, { 'D3_QUANT'  , SD3->D3_QUANT   , NIL } )
		Aadd( aRegSD3, { 'D3_OP'     , SD3->D3_OP      , NIL } )
		Aadd( aRegSD3, { 'D3_CF'     , SD3->D3_CF      , NIL } )
		Aadd( aRegSD3, { 'D3_LOCAL'  , SD3->D3_LOCAL   , NIL } )
		Aadd( aRegSD3, { 'D3_DOC'    , SD3->D3_DOC     , NIL } )
		Aadd( aRegSD3, { 'D3_EMISSAO', SD3->D3_EMISSAO , NIL } )
		Aadd( aRegSD3, { 'D3_GRUPO'  , SD3->D3_GRUPO   , NIL } )
		Aadd( aRegSD3, { 'D3_SEGUM'  , SD3->D3_SEGUM   , NIL } )
		Aadd( aRegSD3, { 'D3_QTSEGUM', SD3->D3_QTSEGUM , NIL } )
		Aadd( aRegSD3, { 'D3_USUARIO', SD3->D3_USUARIO , NIL } )
		
		MsExecAuto( { |x, y| Mata250( x, y ) }, aRegSD3, 5 )
		
		//-- Verifica se houve algum erro.
		If lMsErroAuto
			If Aviso( "Pergunta", "Producao nao gerada. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
				MostraErro()
			EndIf
		Else
			IF SC2->C2_QUJE == 0 
				RecLock( 'SC2', .F. )
				SC2->C2_X_STATU := '1'
				SC2->( MsUnLock() )
			EndIF	
		EndIf
	EndIf
Else
	//-- Inclusao.
	// Alterado por Reinaldo 12/08 para contemplar status de montagem
	// Jader 19/08 - acrescentado 5-autoclave
	If !Empty( SC2->C2_X_STATU ) .And. !SC2->C2_X_STATU $ '1/4/5'
		*If ! SC2->C2_X_STATU $ '7'
			MsgStop( 'Esta OP nao esta com status para Liberacao.' )
			RetFilter(SC2->(RECNO()))
			Return Nil
		*ElseIf !MsgYesNo( 'Esta OP esta com status de Terceiro. Realiza a producao?' )
		*	RetFilter(SC2->(RECNO()))
		*	Return Nil
		*EndIF	
	EndIf
	
	If MsgYesNo( 'Confirma a Liberacao da OP ?' )
		//--Tratamento para a liberacao somente quendo houve banda e o produto nao pertencr a um grupo de so conserto
		
		*IF VldLib(SC2->C2_NUM,SC2->C2_ITEM,SC2->C2_X_STATU)
						
			Aadd( aRegSD3, { 'D3_FILIAL' , xFilial("SD3")                       , NIL } )
			Aadd( aRegSD3, { 'D3_TM'     , '001'                                , NIL } )
			Aadd( aRegSD3, { 'D3_COD'    , SC2->C2_PRODUTO                      , NIL } )
			Aadd( aRegSD3, { 'D3_UM'     , SC2->C2_UM                           , NIL } )
			Aadd( aRegSD3, { 'D3_QUANT'  , SC2->C2_QUANT                        , NIL } )
			Aadd( aRegSD3, { 'D3_OP'     , SC2->( C2_NUM + C2_ITEM + C2_SEQUEN ), NIL } )
			Aadd( aRegSD3, { 'D3_CF'     , "PR0"                                , NIL } )
			Aadd( aRegSD3, { 'D3_LOCAL'  , SC2->C2_LOCAL                        , NIL } )
			Aadd( aRegSD3, { 'D3_DOC'    , SC2->C2_NUM                          , NIL } )
			Aadd( aRegSD3, { 'D3_EMISSAO', dDataBase                            , NIL } )
			Aadd( aRegSD3, { 'D3_GRUPO'  , SC2->C2_GRUPO                        , NIL } )
			Aadd( aRegSD3, { 'D3_SEGUM'  , SC2->C2_SEGUM                        , NIL } )
			Aadd( aRegSD3, { 'D3_QTSEGUM', SC2->C2_QTSEGUM                      , NIL } )
			Aadd( aRegSD3, { 'D3_USUARIO', SubStr( cUsuario, 7, 15 )            , NIL } )
			
			MsExecAuto( { |x, y| Mata250( x, y ) }, aRegSD3, 3 )
			
			//-- Verifica se houve algum erro.
			If lMsErroAuto
				If Aviso( "Pergunta", "Producao nao gerada. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
					MostraErro()
				EndIf
			Else
				RecLock( 'SC2', .F. )
				SC2->C2_X_STATU := '6'
				SC2->( MsUnLock() )
			EndIf
		*Else
		*	MsgAlert("A OP nao podera ser liberada, pois a banda nao informada","Atencao!!")
		*EndIF	
		
	EndIf
	
EndIf

//-- Verifica se houve algum erro.
If lMsErroAuto
	If Aviso( "Pergunta", "Ordem de Producao nao gerada. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
		MostraErro()
	EndIf
EndIf

If nOpcx == Nil
	oDlgEsp:End()
EndIf

RetFilter(SC2->(RECNO()))

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01e  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rejeita a OP.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01e()

Local aRegSD3 := {}
Local oDlgMot,oGetMot,oGetDes
Local cMotivo := Space(2)
Local cDescMot:= Space(40)
Private lMsHelpAuto   := .F.
Private lMsErroAuto   := .F.

If !Empty( SC2->C2_X_STATU ) .And. SC2->C2_X_STATU <> '1'
	MsgStop( 'Esta OP nao esta com status para Rejeicao.' )
	Return Nil
EndIf

If MsgYesNo( 'Confirma a Rejeicao da OP ?' )
	
	// tela do motivo da rejeicao - JC
	
	DEFINE MSDIALOG oDlgMot TITLE OemToAnsi("Motivo da Rejeicao") From 12,10 To 17,70 OF oMainWnd
	
	@ 5,08 SAY "Motivo da Rejeicao" PIXEL OF oDlgMot SIZE 70,7
	@ 5,60 MSGET oGetMot VAR cMotivo  PICTURE "@!" VALID VldMot(cMotivo,@cDescMot,@oGetDes) F3 "43" PIXEL OF oDlgMot SIZE 20,7
	@ 5,91 MSGET oGetDes VAR cDescMot PICTURE "@!" WHEN .F. PIXEL OF oDlgMot SIZE 138,7
	
	DEFINE SBUTTON FROM 22,106 TYPE 1 ACTION oDlgMot:End() ENABLE OF oDlgMot
	
	ACTIVATE MSDIALOG oDlgMot CENTERED
	
	//-- Inclusao.
	Aadd( aRegSD3, { 'D3_FILIAL' , xFilial("SD3")                       , NIL } )
	Aadd( aRegSD3, { 'D3_TM'     , '001'                                , NIL } )
	Aadd( aRegSD3, { 'D3_COD'    , SC2->C2_PRODUTO                      , NIL } )
	Aadd( aRegSD3, { 'D3_UM'     , SC2->C2_UM                           , NIL } )
	Aadd( aRegSD3, { 'D3_QUANT'  , SC2->C2_QUANT                        , NIL } )
	Aadd( aRegSD3, { 'D3_PERDA'  , SC2->C2_QUANT                        , NIL } )
	Aadd( aRegSD3, { 'D3_OP'     , SC2->( C2_NUM + C2_ITEM + C2_SEQUEN ), NIL } )
	Aadd( aRegSD3, { 'D3_CF'     , "PR0"                                , NIL } )
	Aadd( aRegSD3, { 'D3_LOCAL'  , SC2->C2_LOCAL                        , NIL } )
	Aadd( aRegSD3, { 'D3_DOC'    , SC2->C2_NUM                          , NIL } )
	Aadd( aRegSD3, { 'D3_EMISSAO', dDataBase                            , NIL } )
	Aadd( aRegSD3, { 'D3_GRUPO'  , SC2->C2_GRUPO                        , NIL } )
	Aadd( aRegSD3, { 'D3_SEGUM'  , SC2->C2_SEGUM                        , NIL } )
	Aadd( aRegSD3, { 'D3_QTSEGUM', SC2->C2_QTSEGUM                      , NIL } )
	Aadd( aRegSD3, { 'D3_USUARIO', SubStr( cUsuario, 7, 15 )            , NIL } )
	
	MsExecAuto( { |x, y| Mata250( x, y ) }, aRegSD3, 3 )
	
	//-- Verifica se houve algum erro.
	If lMsErroAuto
		If Aviso( "Pergunta", "Producao nao gerada. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
			MostraErro()
		EndIf
	Else
		RecLock( 'SC2', .F. )
		SC2->C2_X_STATU := '9'
		SC2->C2_PERDA   := SC2->C2_QUANT
		SC2->C2_MOTREJE := cMotivo     /// JC
		SC2->( MsUnLock() )
	EndIf
EndIf

oDlgEsp:End()

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01d  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Prepara para Geracao do Pedido de Venda.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01d()

Local cPerg := "ESTA01"

PutSX1( cPerg, "01", "NFE Coleta ?", "", "", "mv_ch1", "C", 6, 0, 1, "G", "", "", "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )

If Pergunte( cPerg, .T. )
	//MsgRun( 'Aguarde...Selecionando registros.',, { || CursorWait(), U_DESTA01f(), CursorArrow() } )
	U_DESTA01f(mv_par01)
EndIf

RetFilter(SC2->(RECNO()))

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01f  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Processa a Geracao do Pedido de Venda.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01f(cColeta)

Local aArea    := GetArea()
Local cQuery   := ""
Local cAlias1  := GetNextAlias()
Local lInverte := .F.
Local cArqTR1  := ""
Local nOpca    := 0
Local aStruct  := { { "TR1_OK"     , "C", 2                      , 0                     },;
{ "TR1_STATUS" , "C", 10                     , 0                     },;
{ "TR1_CLIENT" , "C", 30                     , 0                     },;
{ "TR1_MOTORI" , "C", 30                     , 0                     },;
{ "TR1_NUM"    , "C", TamSX3('C2_NUM')[1]    , 0                     },;
{ "TR1_ITEM"   , "C", TamSX3('C2_ITEM')[1]   , 0                     },;
{ "TR1_SEQUEN" , "C", TamSX3('C2_SEQUEN')[1] , 0                     },;
{ "TR1_PRODUT" , "C", TamSX3('C2_PRODUTO')[1], 0                     },;
{ "TR1_SERV"   , "C", TamSX3('D1_SERVICO')[1], 0                     },;
{ "TR1_QUANT"  , "N", TamSX3('C2_QUANT')[1]  , TamSX3('C2_QUANT')[2] },;
{ "TR1_QUJE"   , "N", TamSX3('C2_QUJE')[1]   , TamSX3('C2_QUJE')[2]  },;
{ "TR1_PERDA"  , "N", TamSX3('C2_PERDA')[1]  , TamSX3('C2_PERDA')[2] },;
{ "TR1_CARCAC" , "C", TamSX3('C2_CARCACA')[1], 0                     },;
{ "TR1_NUMFOG" , "C", TamSX3('C2_NUMFOGO')[1], 0                     },;
{ "TR1_SERIEP" , "C", TamSX3('C2_SERIEPN')[1], 0                     },;
{ "TR1_DESEN"  , "C", TamSX3('C2_X_DESEN')[1], 0                     },;
{ "TR1_EMISSA" , "D", TamSX3('C2_EMISSAO')[1], 0                     },;
{ "TR1_DATRF"  , "D", TamSX3('C2_DATRF')[1]  , 0                     },;
{ "TR1_NUMD1"  , "C", TamSX3('C2_NUMD1')[1]  , 0                     },;
{ "TR1_SERD1"  , "C", TamSX3('C2_SERIED1')[1], 0                     },;
{ "TR1_ITEMD1" , "C", TamSX3('C2_ITEMD1')[1] , 0                     },;
{ "TR1_FORNEC" , "C", TamSX3('C2_FORNECE')[1], 0                     },;
{ "TR1_LOJA"   , "C", TamSX3('C2_LOJA')[1]   , 0                     } }


Local aCpoShow := { { "TR1_OK"    ,, ""           , "@!" },;
{ "TR1_STATUS",, "Status"     , "@!" },;
{ "TR1_CLIENT",, "Cliente"    , "@!" },;
{ "TR1_NUM"   ,, "Coleta"     , "@!" },;
{ "TR1_ITEM"  ,, "Item"       , "@!" },;
{ "TR1_SERV"  ,, "Servico"    , "@!" },;
{ "TR1_PRODUT",, "Produto"    , "@!" },;
{ "TR1_CARCAC",, "Carcaca"    , "@!" },;
{ "TR1_NUMFOG",, "Numero Fogo", "@!" },;
{ "TR1_SERIEP",, "Serie Pneu" , "@!" },;
{ "TR1_DESEN" ,, "Desenho"    , "@!" },;
{ "TR1_EMISSA",, "Entrada"    , "99/99/99" },;
{ "TR1_DATRF" ,, "Liberacao"  , "99/99/99" },;
{ "TR1_MOTORI",, "Motorista"  , "@!" } }

/*
Status    Cliente              Motorista          Coleta It Produto       Carcaca N.Fogo Serie Desenho Entrada  Liberacao
x  Liberado  VIACAO SANTA BRIGIDA ZE MANUEL DA SILVA 070000 01 255x698/R.255 xxxxxxx 21548        BDY     99/99/99 99/99/99
x  Rejeitado                                         070000 02 311x698/R.255 xxxxxxx 23dsr        BDT     99/99/99 99/99/99
*/

Private cMarca := GetMark()

cArqTR1 := CriaTrab( aStruct, .T. )

dbUseArea( .T.,, cArqTR1, "TR1", .F. )

cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_QUANT, C2_QUJE, C2_PERDA,"
cQuery += " C2_X_DESEN, C2_PRODUTO, C2_CARCACA, C2_NUMFOGO, C2_SERIEPN, C2_EMISSAO, C2_DATRF, D1_SERVICO "
cQuery += " ,C2_NUMD1, C2_SERIED1, C2_ITEMD1, C2_FORNECE, C2_LOJA "
cQuery += " FROM " + RetSqlName("SC2") + " SC2, " + RetSqlName("SD1") + " SD1 "
cQuery += " WHERE C2_FILIAL = '" + xFilial('SC2') + "' AND D1_FILIAL = '" + xFilial('SD1') + "' AND"
//cQuery += " C2_NUM = '" + cColeta + "' AND C2_NUM = D1_DOC AND C2_ITEM = SUBSTRING(D1_ITEM,3,2) AND"
cQuery += " C2_NUM = '" + cColeta + "' AND C2_NUMD1 = D1_DOC AND C2_ITEMD1 = D1_ITEM AND C2_SERIED1 = D1_SERIE AND"
cQuery += " C2_FORNECE = D1_FORNECE AND C2_LOJA = D1_LOJA AND "
//cQuery += " C2_QUANT = C2_QUJE AND"
cQuery += " C2_QUJE > 0 AND"
cQuery += " SC2.D_E_L_E_T_ = ' ' AND"
cQuery += " SD1.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN"

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias1, .F., .F. )

TCSetField( cAlias1, "C2_EMISSAO", "D", 8 )
TCSetField( cAlias1, "C2_DATRF"  , "D", 8 )

If (cAlias1)->( Eof() )
	TR1->( dbCloseArea() )
	MsgStop( "Nao existem dados para Coleta informada" )
	Return Nil
EndIf

While (cAlias1)->( !Eof() )
	
	//-- Posiciona NFE Coleta pra identificar cliente
	SF1->(dbSetOrder(1))
	//SF1->(dbSeek(xFilial("SF1")+(cAlias1)->C2_NUM,.F.))
	SF1->(dbSeek(xFilial("SF1")+(cAlias1)->(C2_NUMD1+C2_SERIED1+C2_FORNECE+C2_LOJA),.F.))
	
	//-- Posiciona Cliente para trazer nome reduzido
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.))
	
	//-- Posiciona Vendedor para buscar nome do motorista "a1_vend3"
	SA3->(dbSetOrder(1))
	SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND3,.F.))
	
	RecLock( "TR1", .T. )
	
	TR1->TR1_OK      := cMarca
	TR1->TR1_CLIENT  := SA1->A1_NREDUZ
	TR1->TR1_MOTORI  := SA3->A3_NOME
	TR1->TR1_STATUS  := Iif((cAlias1)->C2_QUANT == (cAlias1)->C2_PERDA, "Recusado", "Liberado")
	TR1->TR1_NUM     := (cAlias1)->C2_NUM
	TR1->TR1_ITEM    := (cAlias1)->C2_ITEM
	TR1->TR1_SEQUEN  := (cAlias1)->C2_SEQUEN
	TR1->TR1_SERV    := (cAlias1)->D1_SERVICO
	TR1->TR1_PRODUT  := (cAlias1)->C2_PRODUTO
	TR1->TR1_QUANT   := (cAlias1)->C2_QUANT
	TR1->TR1_QUJE    := (cAlias1)->C2_QUJE
	TR1->TR1_PERDA   := (cAlias1)->C2_PERDA
	TR1->TR1_CARCAC  := (cAlias1)->C2_CARCACA
	TR1->TR1_NUMFOG  := (cAlias1)->C2_NUMFOGO
	TR1->TR1_SERIEP  := (cAlias1)->C2_SERIEPN
	TR1->TR1_DESEN   := (cAlias1)->C2_X_DESEN
	TR1->TR1_EMISSA  := (cAlias1)->C2_EMISSAO
	TR1->TR1_DATRF   := (cAlias1)->C2_DATRF

	TR1->TR1_NUMD1   := (cAlias1)->C2_NUMD1
	TR1->TR1_SERD1   := (cAlias1)->C2_SERIED1
	TR1->TR1_ITEMD1  := (cAlias1)->C2_ITEMD1
	TR1->TR1_FORNEC  := (cAlias1)->C2_FORNECE
	TR1->TR1_LOJA    := (cAlias1)->C2_LOJA

	
	MsUnLock()
	
	(cAlias1)->( dbSkip() )
EndDo

TR1->( dbGotop() )
If TR1->( !Eof() )
	DEFINE MSDIALOG oDlg FROM 60, 1 TO 365, 685 TITLE "Geracao Automatica - Selecione as OP's para " PIXEL
	oMark := MsSelect():New( "TR1", "TR1_OK",,aCpoShow, @lInverte, @cMarca, { 20, 1, 153, 343 } )
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || nOpca := 1, oDlg:End() }, { || nOpca := 0, oDlg:End() } ) CENTERED
	
	If nOpca == 1
		U_DESTA01g(cColeta)
	EndIf
EndIf

(cAlias1)->( dbCloseArea() )

TR1->( dbCloseArea() )

Ferase( cArqTR1 + GetDbExtension() )

RestArea( aArea )

Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01g  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava pedido de venda.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01g(cColeta)

Local cTsServ       := GetMV( "MV_X_TSVED" )
Local aArea         := GetArea()
Local _aAreaSD1     := SD1->(GetArea())
Local _aAreaSF4     := SF4->(GetArea())
Local _aAreaSA1     := SA1->(GetArea())
Local _aAreaSA2     := SA2->(GetArea())
Local _aAreaSE4     := SE4->(GetArea())
Local _aAreaSB2     := SB2->(GetArea())
Local _aSC5         := {}
Local _aSC6         := {}
Local aAux          := {}
Local _nValor       := 0
Local aStruSD1      := {}
Local nA            := 0
Local lProduziu     := .T.
Local lSoConcerto   := .F.
Local cDescPro      := ""
Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.

SF1->( dbSetOrder( 1 ) )
SA1->( dbSetOrder( 1 ) )
SE4->( dbSetOrder( 1 ) )
SF4->( dbSetOrder( 1 ) )
SB1->( dbSetOrder( 1 ) )

TR1->( dbGotop() )
While TR1->( !Eof() )
	If TR1->TR1_OK == cMarca
		
		//Pergunte( "ESTA01", .F. )
		
		cItem    := StrZero( Val( TR1->TR1_ITEM ), Len( SD1->D1_ITEM ) )
		cAlias2  := GetNextAlias()
		
		//-- Busco o item da nota.
		cQuery := "SELECT * FROM " + RetSqlName("SD1")
		cQuery += " WHERE D1_DOC = '" + TR1->TR1_NUMD1 + "' AND"
		cQuery += " D1_ITEM = '" + TR1->TR1_ITEMD1 + "' AND"
		cQuery += " D1_SERIE = '" + TR1->TR1_SERD1 + "' AND"
		cQuery += " D1_FORNECE = '" + TR1->TR1_FORNEC + "' AND"
		cQuery += " D1_LOJA = '" + TR1->TR1_LOJA + "' AND"
		cQuery += " D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery( cQuery )
		
		aStruSD1 := SD1->( dbStruct() )
		
		dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias2, .F., .F. )
		
		For nA := 1 To Len( aStruSD1 )
			If aStruSD1[nA, 2] <> "C" .And. aStruSD1[nA, 2] <> "M" .And. FieldPos( aStruSD1[nA, 2] ) != 0
				TCSetField( cAlias2, aStruSD1[nA, 1], aStruSD1[nA, 2], aStruSD1[nA, 3], aStruSD1[nA, 4] )
			EndIf
		Next nA
		
		If SF1->( MsSeek( xFilial("SF1") + (cAlias2)->( D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_TIPO ) ) ) .And.;
			SF1->F1_TIPO = "B" .And. SM0->M0_CODIGO == "03"
			
			SA1->( MsSeek( xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA ) )
			SE4->( MsSeek( xFilial("SE4") + SF1->F1_COND ) )
			
			//-- Adiciono o Cabecalho do Pedido Venda.
			_aSC5 := 	{ {'C5_FILIAL' , xFilial("SC5") , NIL },;
			; //{  'C5_NUM'    , SF1->F1_DOC    , NIL },;
			{  'C5_NUM'    , (cAlias2)->D1_NUMC2, NIL },;
			{  'C5_TIPO'   , 'N'                , NIL },;
			{  'C5_CLIENTE', SF1->F1_FORNECE    , NIL },;
			{  'C5_LOJACLI', SF1->F1_LOJA       , NIL },;
			{  'C5_TABELA' , "   "              , NIL },;
			{  'C5_VEND3'  , SA1->A1_VEND3      , NIL },;
			{  'C5_COMIS3' , SA1->A1_COMIS3     , NIL },;
			{  'C5_VEND4'  , SA1->A1_VEND4      , NIL },;
			{  'C5_COMIS4' , SA1->A1_COMIS4     , NIL },;
			{  'C5_VEND5'  , SA1->A1_VEND5      , NIL },;
			{  'C5_COMIS5' , SA1->A1_COMIS5     , NIL },;
			{  'C5_LIBEROK', 'S'                , NIL },;
			{  'C5_CONDPAG', Iif(Empty(SF1->F1_COND), SA1->A1_COND, SF1->F1_COND), NIL } }
			
			For nA := 1 To (cAlias2)->D1_QUANT
				
				aAux    := {}
				_nValor := (cAlias2)->D1_TOTAL / (cAlias2)->D1_QUANT
				
				SB1->( MsSeek( xFilial("SB1") + (cAlias2)->D1_SERVICO ) )
				lSoConcerto := Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
				
				SF4->( MsSeek( xFilial("SF4") + (cAlias2)->D1_TES ) ) //-- Busca TES Nota Fiscal Entrada para descobrir qual TES sera utilizado na Saida para devolucao do produto carcaca
				SF4->( MsSeek( xFilial("SF4") + SF4->F4_TESDV ) )     //-- Posiciona SF4 com o TES que sera utilizado para a saida (devolucao do produto recebido na nota fiscal entrada)
				SB1->( MsSeek( xFilial("SB1") + (cAlias2)->D1_COD ) )
				
				If SB1->B1_TIPO == "MO"
					Loop
				EndIf
				
				//lProduziu := TR1->TR1_QUANT == TR1->TR1_QUJE .And. Empty( TR1->TR1_PERDA )
				lProduziu := TR1->TR1_QUJE > 0 .And. Empty( TR1->TR1_PERDA )
				
				//-- tratamento diferenciado para descricao da carcaca quando for servico SO CONSERTO
				//-- descricao da carcaca SC B1_DESC MEDIDA N.FOGO
				//-- descricao do so concerto SC EXT
				cDescPro  := ''
				If lSoConcerto
					//Reinaldo - Aguardando procedimento para cadastro dos produtos so conserto
					// JC 22/08/05 - quando recusar um so' conserto
					////cDescPro := "SC " + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Iif( !Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP )  )
					cDescPro := If(lProduziu,"","RECUSADO ")+"SC " + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Iif( !Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP )  )
				Else
					cDescPro := Alltrim ( (cAlias2)->D1_COD )
				EndIf
				
				//-- Adiciono o Item do Pedido referente ao produto.
				Aadd( aAux , { 'C6_FILIAL' , xFilial("SC6")            , NIL } )
				//Aadd( aAux , { 'C6_NUM'    , (cAlias2)->D1_DOC         , NIL } )
				Aadd( aAux , { 'C6_NUM'    , (cAlias2)->D1_NUMC2       , NIL } )
				Aadd( aAux , { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0) , NIL } )
				Aadd( aAux , { 'C6_PRODUTO', (cAlias2)->D1_COD         , NIL } )
				Aadd( aAux , { 'C6_DESCRI' , cDescPro                  , NIL } )
				Aadd( aAux , { 'C6_QTDVEN' , 1                         , NIL } )
				Aadd( aAux , { 'C6_QTDLIB' , 1                         , NIL } )
				Aadd( aAux , { 'C6_PRCVEN' , (cAlias2)->D1_VUNIT       , NIL } )
				Aadd( aAux , { 'C6_PRUNIT' , (cAlias2)->D1_VUNIT       , NIL } )
				Aadd( aAux , { 'C6_VALOR'  , _nValor                   , NIL } )
				Aadd( aAux , { 'C6_LOCAL'  , (cAlias2)->D1_LOCAL       , NIL } )
				Aadd( aAux , { 'C6_NFORI'  , (cAlias2)->D1_DOC         , NIL } )
				Aadd( aAux , { 'C6_SERIORI', (cAlias2)->D1_SERIE       , NIL } )
				Aadd( aAux , { 'C6_ITEMORI', (cAlias2)->D1_ITEM        , NIL } )
				Aadd( aAux , { 'C6_IDENTB6', (cAlias2)->D1_IDENTB6     , NIL } )
				Aadd( aAux , { 'C6_ENTREG' , (cAlias2)->D1_DTENTRE     , NIL } )
				Aadd( aAux , { 'C6_TES'    , SF4->F4_CODIGO            , NIL } )
				//Aadd( aAux , { 'C6_NUMOP'  , (cAlias2)->D1_DOC         , NIL } )
				Aadd( aAux , { 'C6_NUMOP'  , (cAlias2)->D1_NUMC2       , NIL } )
				Aadd( aAux , { 'C6_ITEMOP' , Substr((cAlias2)->D1_ITEM,3,2), NIL } )
				Aadd( aAux , { 'C6_CF'     , SF4->F4_CF                , NIL } )
				Aadd( aAux , { 'C6_ITPVSRV', StrZero(Len(_aSC6)+2,2,0) , NIL } )
				
				Aadd( _aSC6, aAux )
				
				cItOrig := Substr( (cAlias2)->D1_ITEM, 3, 2 )
				
				SF4->( MsSeek( xFilial("SF4") + cTsServ ) )
				SB1->( MsSeek( xFilial("SB1") + (cAlias2)->D1_SERVICO ) )
				
				//--  Grupo de produtos de servicos que nao conterao valor agragado.
				//				If !Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
				_nValor  := U_BuscaPrcVenda( (cAlias2)->D1_SERVICO, SF1->F1_FORNECE, SF1->F1_LOJA )
				//				EndIF
				
				If _nValor == 0
					MsgInfo( "O valor do serviço " + (cAlias2)->D1_SERVICO + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Atençao!" )
					Return Nil
				EndIf
				
				//-- Zero array para adicionar novo item ao pedido.
				aAux  := {}
				
				////lProduziu := TR1->TR1_QUANT == TR1->TR1_QUJE .And. Empty( TR1->TR1_PERDA )
				cTes      := Iif( lProduziu, cTsServ, '903' )
				cDescPro  := ''
				
				If lProduziu
					//cDescPro := Alltrim( TR1->TR1_DESEN ) + " " + AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP )  )
					// Reinaldo Alterarado 03/09
					cDescPro := AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " BANDA " + Alltrim( TR1->TR1_DESEN ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( !Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP ) )
				Else
					cDescPro := AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP )  )
				EndIf
				/*
				If lSoConcerto
				cDescPro := "SC " + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP ) )
				Else
				cDescPro := Alltrim ( (cAlias2)->D1_COD )
				EndIf
				*/
				//-- Desconsidero o grupo.
				If !Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
					//-- Adiciono Servico (D1_SERVICO) no Pedido de Venda.
					Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")           , NIL } )
					//Aadd( aAux, { 'C6_NUM'    , (cAlias2)->D1_DOC        , NIL } )
					Aadd( aAux, { 'C6_NUM'    , (cAlias2)->D1_NUMC2      , NIL } )
					Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0), NIL } )
					Aadd( aAux, { 'C6_PRODUTO', (cAlias2)->D1_SERVICO    , NIL } )
					Aadd( aAux, { 'C6_DESCRI' , cDescPro                 , NIL } )
					Aadd( aAux, { 'C6_QTDVEN' , 1                        , NIL } )
					Aadd( aAux, { 'C6_QTDLIB' , 1                        , NIL } )
					Aadd( aAux, { 'C6_PRCVEN' , _nValor                  , NIL } )
					Aadd( aAux, { 'C6_PRUNIT' , _nValor                  , NIL } )
					Aadd( aAux, { 'C6_VALOR'  , _nValor                  , NIL } )
					Aadd( aAux, { 'C6_LOCAL'  , (cAlias2)->D1_LOCAL      , NIL } )
					Aadd( aAux, { 'C6_NFORI'  , ""                       , NIL } )
					Aadd( aAux, { 'C6_SERIORI', ""                       , NIL } )
					Aadd( aAux, { 'C6_ITEMORI', ""                       , NIL } )
					Aadd( aAux, { 'C6_IDENTB6', ""                       , NIL } )
					//Aadd( aAux, { 'C6_NUMOP'  , (cAlias2)->D1_DOC        , NIL } )
					Aadd( aAux, { 'C6_NUMOP'  , (cAlias2)->D1_NUMC2      , NIL } )
					Aadd( aAux, { 'C6_ITEMOP' , cItOrig                  , NIL } )
					Aadd( aAux, { 'C6_TES'    , cTes                     , NIL } )
					Aadd( aAux, { 'C6_CF'     , SF4->F4_CF               , NIL } )
					
					Aadd( _aSC6, aAux )
				EndIf
				
			Next nA
			
			//(cAlias2)->(dbCloseArea() )
			
			//-- Verifico se foi executado mais algum servico.
			
			cOrdemP := cColeta + TR1->TR1_ITEM
			
			cAlias3 := GetNextAlias()
			
		    dbSelectArea("SZF")
		    dbSetorder(1)
		 	IF dbSeek(xFilial("SZF")+cOrdemP+"001  ")
			
				cQuery := "SELECT * FROM " + RetSqlName("SZF")
				cQuery += " WHERE ZF_FILIAL = '" + xFilial("SZF") + "' AND"
				cQuery += " SUBSTRING( ZF_NUMOP, 1, 8 ) = '" + cOrdemP + "' AND"
				cQuery += " D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery( cQuery )
				
				aStruSZF := SZF->( dbStruct() )
				                               
				dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias3, .F., .F. )	
						
				For nA := 1 To Len( aStruSZF )
					If aStruSZF[nA, 2] <> "C" .And. aStruSZF[nA, 2] <> "M" .And. FieldPos( aStruSZF[nA, 2] ) != 0
						TCSetField( cAlias3, aStruSZF[nA, 1], aStruSZF[nA, 2], aStruSZF[nA, 3], aStruSZF[nA, 4] )
					EndIf
				Next nA
					
					
				SA1->( dbSetOrder( 1 ) )
				
				While (cAlias3)->( !Eof() )
					
					If ! ( SB1->( MsSeek( xFilial("SB1") + (cAlias3)->ZF_PRODSRV, .F. ) ) )
						(cAlias3)->( dbSkip() )
						Loop
					EndIf
					
					_nValor := U_BuscaPrcVenda( (cAlias3)->ZF_PRODSRV, SF1->F1_FORNECE, SF1->F1_LOJA )
					
					If _nValor == 0
						MsgInfo( "O valor do serviço " + (cAlias3)->ZF_PRODSRV + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Atençao!" )
						Exit
					EndIf
						
					SA1->( MsSeek( xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA ) )
					
					//lProduziu := TR1->TR1_QUANT == TR1->TR1_QUJE .And. Empty( TR1->TR1_PERDA )
					lProduziu := TR1->TR1_QUJE > 0 .And. Empty( TR1->TR1_PERDA )
					
					cTes      := Iif( lProduziu, Iif( SA1->A1_CALCCON == 'S', GetMV("MV_X_TSVED"),Iif(Alltrim( SB1->B1_GRUPO ) == "SC",GetMV("MV_X_TSVED"), '902' ) ) , '903' )
					
					SF4->( MsSeek( xFilial("SF4") + cTes ) )
					
					//-- Zero array para adicionar novo item ao pedido.
					aAux  := {}
					
					//-- Troca a Descricao para OP's que foram recusadas.
					If Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
						//					cDescPro := AllTrim( SB1->B1_DESC ) + " " + (cAlias2)->D1_COD + " " + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), TR1->TR1_SERIEP, "NF-" + TR1->TR1_NUMFOG )
						// 					cDescPro := "SC EXT" // EDMAR EM 08/8/2005
						cDescPro := AllTrim( SB1->B1_DESC ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP ) )
						//					Reinaldo - Observar a alteracao do cadastro de produtos só conserto
					Else
						cDescPro := SB1->B1_DESC
						//Reinaldo - Alteracao na descricao dos produtos
					EndIf
					
					//-- Adiciono o Conserto no Pedido de Venda.
					Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")                , NIL } )
					Aadd( aAux, { 'C6_NUM'    , Left( (cAlias3)->ZF_NUMOP, 6 )   , NIL } )
					Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0)     , NIL } )
					Aadd( aAux, { 'C6_PRODUTO', (cAlias3)->ZF_PRODSRV          , NIL } )
					Aadd( aAux, { 'C6_DESCRI' , cDescPro                      , NIL } )
					Aadd( aAux, { 'C6_QTDVEN' , (cAlias3)->ZF_QUANT           , NIL } )
					Aadd( aAux, { 'C6_QTDLIB' , (cAlias3)->ZF_QUANT           , NIL } )
					Aadd( aAux, { 'C6_PRCVEN' , _nValor                       , NIL } )
					Aadd( aAux, { 'C6_PRUNIT' , _nValor                       , NIL } )
					Aadd( aAux, { 'C6_VALOR'  , (cAlias3)->ZF_QUANT * _nValor , NIL } )
					Aadd( aAux, { 'C6_LOCAL'  , '01'				          , NIL } )
					Aadd( aAux, { 'C6_NFORI'  , ""                            , NIL } )
					Aadd( aAux, { 'C6_SERIORI', ""                            , NIL } )
					Aadd( aAux, { 'C6_ITEMORI', ""                            , NIL } )
					Aadd( aAux, { 'C6_IDENTB6', ""                            , NIL } )
					Aadd( aAux, { 'C6_NUMOP'  , (cAlias3)->ZF_NUMOP           , NIL } )
					Aadd( aAux, { 'C6_ITEMOP' , Subs( (cAlias3)->ZF_NUMOP, 7, 2 ), NIL } )
					Aadd( aAux, { 'C6_TES'    , cTes                          , NIL } )
					Aadd( aAux, { 'C6_CF'     , SF4->F4_CF                    , NIL } )
					
					Aadd( _aSC6, aAux )
					
					(cAlias3)->( dbSkip() )
				EndDo
				
				(cAlias3)->( dbCloseArea() )
			
			Else
										
				cQuery := "SELECT * FROM " + RetSqlName("SD3")
				cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "' AND"
				cQuery += " SUBSTRING( D3_OP, 1, 8 ) = '" + cOrdemP + "' AND"
				cQuery += " D3_GRUPO = 'MANC' AND"
				cQuery += " D3_X_PROD <> ''  AND"
				cQuery += " D3_ESTORNO = ' ' AND"
				cQuery += " D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery( cQuery )
				
				aStruSD3 := SD3->( dbStruct() )
				
				dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAlias3, .F., .F. )
				
				
				
				For nA := 1 To Len( aStruSD3 )
					If aStruSD3[nA, 2] <> "C" .And. aStruSD3[nA, 2] <> "M" .And. FieldPos( aStruSD3[nA, 2] ) != 0
						TCSetField( cAlias3, aStruSD3[nA, 1], aStruSD3[nA, 2], aStruSD3[nA, 3], aStruSD3[nA, 4] )
					EndIf
				Next nA
				
				SA1->( dbSetOrder( 1 ) )
				
				While (cAlias3)->( !Eof() )
					
					If ! ( SB1->( MsSeek( xFilial("SB1") + (cAlias3)->D3_X_PROD, .F. ) ) )
						(cAlias3)->( dbSkip() )
						Loop
					EndIf
					
					_nValor := U_BuscaPrcVenda( (cAlias3)->D3_X_PROD, SF1->F1_FORNECE, SF1->F1_LOJA )
					
					If _nValor == 0
						MsgInfo( "O valor do serviço " + (cAlias3)->D3_X_PROD + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Atençao!" )
						Exit
					EndIf
					
					SA1->( MsSeek( xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA ) )
					
					//lProduziu := TR1->TR1_QUANT == TR1->TR1_QUJE .And. Empty( TR1->TR1_PERDA )
					lProduziu := TR1->TR1_QUJE > 0 .And. Empty( TR1->TR1_PERDA )
					cTes      := Iif( lProduziu, Iif( SA1->A1_CALCCON == 'S', GetMV("MV_X_TSVED"),Iif(Alltrim( SB1->B1_GRUPO ) == "SC",GetMV("MV_X_TSVED"), '902' ) ) , '903' )
					
					SF4->( MsSeek( xFilial("SF4") + cTes ) )
					
					//-- Zero array para adicionar novo item ao pedido.
					aAux  := {}
					
					//-- Troca a Descricao para OP's que foram recusadas.
					If Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
						//					cDescPro := AllTrim( SB1->B1_DESC ) + " " + (cAlias2)->D1_COD + " " + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), TR1->TR1_SERIEP, "NF-" + TR1->TR1_NUMFOG )
						// 					cDescPro := "SC EXT" // EDMAR EM 08/8/2005
						cDescPro := AllTrim( SB1->B1_DESC ) + " " + Iif( ! Empty( TR1->TR1_NUMFOG ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) + " " + Alltrim( TR1->TR1_SERIEP ),Alltrim( TR1->TR1_SERIEP ) )
						//					Reinaldo - Observar a alteracao do cadastro de produtos só conserto
					Else
						cDescPro := SB1->B1_DESC
						//Reinaldo - Alteracao na descricao dos produtos
					EndIf
					
					//-- Adiciono o Conserto no Pedido de Venda.
					Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")                , NIL } )
					Aadd( aAux, { 'C6_NUM'    , Left( (cAlias3)->D3_OP, 6 )   , NIL } )
					Aadd( aAux, { 'C6_ITEM'   , StrZero(Len(_aSC6)+1,2,0)     , NIL } )
					Aadd( aAux, { 'C6_PRODUTO', (cAlias3)->D3_X_PROD          , NIL } )
					Aadd( aAux, { 'C6_DESCRI' , cDescPro                      , NIL } )
					Aadd( aAux, { 'C6_QTDVEN' , (cAlias3)->D3_QUANT           , NIL } )
					Aadd( aAux, { 'C6_QTDLIB' , (cAlias3)->D3_QUANT           , NIL } )
					Aadd( aAux, { 'C6_PRCVEN' , _nValor                       , NIL } )
					Aadd( aAux, { 'C6_PRUNIT' , _nValor                       , NIL } )
					Aadd( aAux, { 'C6_VALOR'  , (cAlias3)->D3_QUANT * _nValor , NIL } )
					Aadd( aAux, { 'C6_LOCAL'  , (cAlias3)->D3_X_ARMZ          , NIL } )
					Aadd( aAux, { 'C6_NFORI'  , ""                            , NIL } )
					Aadd( aAux, { 'C6_SERIORI', ""                            , NIL } )
					Aadd( aAux, { 'C6_ITEMORI', ""                            , NIL } )
					Aadd( aAux, { 'C6_IDENTB6', ""                            , NIL } )
					Aadd( aAux, { 'C6_NUMOP'  , (cAlias3)->D3_OP              , NIL } )
					Aadd( aAux, { 'C6_ITEMOP' , Subs( (cAlias3)->D3_OP, 7, 2 ), NIL } )
					Aadd( aAux, { 'C6_TES'    , cTes                          , NIL } )
					Aadd( aAux, { 'C6_CF'     , SF4->F4_CF                    , NIL } )
					
					Aadd( _aSC6, aAux )
					
					(cAlias3)->( dbSkip() )
				EndDo
				
				(cAlias3)->( dbCloseArea() )
			EndIf
			
			(cAlias2)->(dbCloseArea() )
		EndIF
	EndIF
	TR1->( dbSkip() )
EndDo

_ASC6AUX := {}
NOPCPED   := 3

//-- Inclusao dos Pedidos de Venda.
If !Empty( _aSC5 ) .And. !Empty( _aSC6 )¨
	
	_cNumPed := _ASC5[2][2]
	
	//-- Ely em 17.08 - Caso o Pedido Nao Exista, inclue um novo
	SC5->(dBSetOrder(1))
	IF ! ( SC5->(DBSEEK(XFILIAL("SC5")+_cNumPed,.F.)) )
		NOPCPED := 3 // INCLUI
	ELSE
		FOR I := 1 TO LEN(_ASC6)
			_lOk := .T.
			
			_nPos := AScan(_aSC6[I],{|x| Alltrim(Upper(x[1]))=="C6_IDENTB6"})
			If _nPos == 0
				_cIdentB6 := ""
			Else
				_cIdentB6 := _aSC6[I,_nPos,2]
			Endif
			
			_nPos := AScan(_aSC6[I],{|x| Alltrim(Upper(x[1]))=="C6_NUMOP"})
			If _nPos == 0
				_cNumOP := ""
			Else
				_cNumOP := Substr(_aSC6[I,_nPos,2],1,6)
			Endif
			
			_nPos := AScan(_aSC6[I],{|x| Alltrim(Upper(x[1]))=="C6_ITEMOP"})
			If _nPos == 0
				_cItemOP := ""
			Else
				_cItemOP := _aSC6[I,_nPos,2]
			Endif
			
			DBSELECTAREA("SC6")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SC6")+_cNumPed,.F.)
			WHILE !EOF() .AND. XFILIAL("SC6") == SC6->C6_FILIAL .AND. SC6->C6_NUM  == _cNumPed
				NITEM := SC6->C6_ITEM
				If ! Empty(_cNumOP+_cItemOP)
					IF SC6->C6_NUMOP+SC6->C6_ITEMOP == _cNumOP+_cItemOP // OP PELA OP
						_lOk := .F.
					ENDIF
				Endif
				If ! Empty(_cIdentB6)
					IF SC6->C6_IDENTB6 == _cIdentB6
						_lOk := .F.
					ENDIF
				Endif
				/*
				IF ALLTRIM(UPPER(_ASC6[I][15][1])) == "C6_IDENTB6" // PRODUTO ORIGINAL PELO IDENTB6
				IF Alltrim(SC6->C6_IDENTB6) == Alltrim(_ASC6[I][15][2])
				DBSKIP()
				LOOP
				ENDIF
				_lOk := .T.
				ELSE
				IF Alltrim(SC6->C6_NUMOP)+Alltrim(SC6->C6_ITEMOP) == Alltrim(_ASC6[I][16][2])+Alltrim(_ASC6[I][17][2]) // OP PELA OP
				DBSKIP()
				LOOP
				ENDIF
				_lOk := .T.
				ENDIF
				*/
				SC6->(DBSKIP())
			ENDDO
			If _lOk
				AADD(_ASC6AUX,_ASC6[I])
			Endif
		NEXT
		FOR I := 1 TO LEN(_ASC6AUX)
			NITEM := SOMA1(NITEM,2)
			_ASC6AUX[I][3][2] := NITEM
		NEXT
		_ASC6   := _ASC6AUX
		NOPCPED := 4
	ENDIF
	
	//-- Ely em 17.08 - Caso o Pedido Exista, inclue apenas os itens novos
	If Empty(_aSC6) .And. nOpcPed == 4
		MsgStop("Não há itens para geracao do pedido. Pedido já gerado. Verifique.","Atencao")
	Else
		MsExecAuto( { |x, y, z| Mata410( x, y, z ) }, _aSC5, _aSC6, NOPCPED )
	Endif
	
	//-- Verifico se houve algum erro.
	If lMsErroAuto
		If Aviso( "Pergunta", "Pedido de venda nao gerado. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
			MostraErro()
		EndIf
	EndIf
ELSE
	Alert( "VAZIO" )
EndIf

SD1->( RestArea( _aAreaSD1 ) )
SB2->( RestArea( _aAreaSB2 ) )
SF4->( RestArea( _aAreaSF4 ) )
SA1->( RestArea( _aAreaSA1 ) )
SA2->( RestArea( _aAreaSA2 ) )
SE4->( RestArea( _aAreaSE4 ) )
RestArea( aArea)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01c  ³ Autor ³ Robson Alves          ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Legenda                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01c()

BrwLegenda( 'Legenda', cCadastro, { { 'BR_VERDE'   , 'Inspecao' },;
{ 'BR_AZUL'    , 'Montagem' },;
{ 'BR_AMARELO' , 'Autoclave'},;
{ 'BR_VERMELHO', 'Producao' },;
{ 'BR_PRETO'   , 'Rejeitado'} } )

RetFilter(SC2->(RECNO()))

Return Nil



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldMot   ³ Autor ³ Jader                 ³ Data ³04.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de validacao do codigo do motivo de rejeicao        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

Static Function VldMot(cMotivo,cDescMot,oGetDes)

Local lRet := .T.

If Empty(cMotivo)
	MsgStop( 'Motivo da rejeicao deve ser informado.' )
	lRet := .F.
Else
	lRet := ExistCpo("SX5",'43'+cMotivo)
	cDescMot := Tabela('43',cMotivo,.F.)
	oGetDes:Refresh()
Endif

Return(lRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01h  ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Filtro da autoclave                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01h()

Local cPerg   := 'ESTA1A'
Local aRegs   := {}
Local nIndex

//-- cria grupo de perguntas no SX1
///////AAdd(aRegs,{cPerg,"01","Filtrar?"      ,"Filtrar?"      ,"Filtrar?"      ,"mv_ch1","B", 1,0,0,"C","","mv_par01","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"01","Producao De?"  ,"Producao De?"  ,"Producao De?"  ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AAdd(aRegs,{cPerg,"02","Producao Ate?" ,"Producao Ate?" ,"Producao Ate?" ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"03","Autoclave De?" ,"Autoclave De?" ,"Autoclave De?" ,"mv_ch3","D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AAdd(aRegs,{cPerg,"04","Autoclave Ate?","Autoclave Ate?","Autoclave Ate?","mv_ch4","D", 8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"05","Rodada?"       ,"Rodada?"       ,"Rodada?"       ,"mv_ch5","C", 2,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AAdd(aRegs,{cPerg,"06","Hora Rodada?"  ,"Hora Rodada?"  ,"Hora Rodada?"  ,"mv_ch6","C", 5,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AAdd(aRegs,{cPerg,"07","Autoclave?"    ,"Autoclave?"    ,"Autoclave?"    ,"mv_ch7","C", 2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AAdd(aRegs,{cPerg,"08","Trilho?"       ,"Trilho?"       ,"Trilho?"       ,"mv_ch8","C", 1,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,cPerg)

dbSelectArea("SC2")
dbSetOrder(1)

If Empty(cIndex)
	cIndex := CriaTrab(NIL,.F.)
	cChave := IndexKey()
Endif

//-- faz pergunta
If Pergunte(cPerg,.T.)
	
	//-- monta filtro do SC2
	cFiltro := "DTOS(C2_DATPRI) >= '"+DtoS(mv_par01)+"' "
	cFiltro += ".AND. DTOS(C2_DATPRI) <= '"+DtoS(mv_par02)+"' "
	cFiltro += ".AND. DTOS(C2_XDTCLAV) >= '"+DtoS(mv_par03)+"' "
	cFiltro += ".AND. DTOS(C2_XDTCLAV) <= '"+DtoS(mv_par04)+"' "
	
	If ! Empty(mv_par05)
		cFiltro += ".AND. C2_XNUMROD == '"+mv_par05+"' "
	Endif
	
	If ! Empty(mv_par06) .And. mv_par06<>"00:00" .And. mv_par06<>"  :  "
		cFiltro += ".AND. C2_XRODADA == '"+mv_par06+"' "
	Endif
	
	If ! Empty(mv_par07)
		cFiltro += ".AND. C2_XACLAVE == '"+mv_par07+"' "
	Endif
	
	If ! Empty(mv_par08)
		cFiltro += ".AND. C2_XTRILHO == '"+mv_par08+"' "
	Endif
	
	///////Set Filter To &(cFiltro)
	
	// Selecionando Registros...
	IndRegua("SC2",cIndex,cChave,,cFiltro,"Selecionando registros...")
	
	dbSetOrder(1)
	
Else
	
	FErase(cIndex+OrdBagExt())
	cIndex  := ''
	cChave  := ''
	cFiltro := ''
	
	Set Filter To
	
	RetIndex("SC2")
	dbSetOrder(1)
	
Endif

dbGoTop()

Return(NIL)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DESTA01i  ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chama funcao de autoclave                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function DESTA01i()

U_DESTA02()

RetFilter(SC2->(RECNO()))

Return(NIL)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RetFilter ³ Autor ³ Jader                 ³ Data ³18.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna Filtro                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

Static Function RetFilter(nRecno)

If ! Empty(cFiltro)
	IndRegua("SC2",cIndex,cChave,,cFiltro,"Selecionando registros...")
	If nRecno <> NIL
		dbGoTo(nRecno)
	Endif
	dbSetOrder(1)
Endif

Return(NIL)

User Function DESTA01t

MATA650(,4)

Return

Static Function VldLib(cNumOP,cItemOP,cStatuOP)

Local _aArea  := GetArea()
Local cOP     := cNumOP + cItemOP + '001'
Local lRet    := .F.
Local cAliasP := GetNextAlias()

cQuery := "SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_SERVICO, D1_COD "
cQuery += " FROM " + RetSqlName("SC2") + " SC2, " + RetSqlName("SD1") + " SD1 "
cQuery += " WHERE SC2.D_E_L_E_T_ = ''"
cQuery += " AND   SD1.D_E_L_E_T_ = ' '"
cQuery += " AND   C2_FILIAL = '" + xFilial('SC2') + "'"
cQuery += " AND   C2_NUM    = '" + cNumOP + "'"
cQuery += " AND   C2_ITEM   = '" + cItemOP + "'"
cQuery += " AND   D1_FILIAL = '" + xFilial('SD1') + "'"
cQuery += " AND   D1_DOC  = C2_NUMD1"
cQuery += " AND   D1_ITEM = C2_ITEMD1"
cQuery += " AND   D1_SERIE = C2_SERIED1"
cQuery += " AND   D1_FORNECE = C2_FORNECE"
cQuery += " AND   D1_LOJA = C2_LOJA"
cQuery += " And   D1_TIPO = 'B'"

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), cAliasP, .F., .F. )

SB1->( dbSetOrder(1) )
SB1->( dbSeek(xFilial("SB1")+(cAliasP)->D1_SERVICO) )


If Alltrim(SB1->B1_GRUPO) != "SC"
	dbSelectarea("SD3")
	dbSetOrder(1)
	IF dbSeek(xFilial("SD3") + cOP )		
		While !Eof() .And. cOP == Alltrim(SD3->D3_OP)
			IF SD3->D3_ESTORNO == "S"
				SD3->(dbSkip())
				Loop
			EndIF
			If Alltrim(SD3->D3_GRUPO) == "BAND"
				lRet := .T.
			EndIf
			dbSkip()
		EndDo
	EndIF	
Else
	lRet := .T.
EndIf
If cStatuOP == '7'
	lRet := .T.
EndIF
RestArea(_aArea)

Return(lRet)
