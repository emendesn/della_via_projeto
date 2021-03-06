#Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � XXXXXXX  � Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Producao.                                        ���
�������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � DuraPol                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function DESTA01()
Local aCores        := {}
Private cCadastro	:= 'Producao'

//�����������������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa               �
//� ----------- Elementos contidos por dimensao ------------              �
//� 1. Nome a aparecer no cabecalho                                       �
//� 2. Nome da Rotina associada                                           �
//� 3. Usado pela rotina                                                  �
//� 4. Tipo de Transa��o a ser efetuada                                   �
//�    1 - Pesquisa e Posiciona em um Banco de Dados                      �
//�    2 - Simplesmente Mostra os Campos                                  �
//�    3 - Inclui registros no Bancos de Dados                            �
//�    4 - Altera o registro corrente                                     �
//�    5 - Remove o registro corrente do Banco de Dados                   �
//�    6 - Alteracao sem inclusao de registro                             �
//�������������������������������������������������������������������������
Private aRotina:= {	{ OemToAnsi('Pesquisar')    ,'AxPesqui'  , 0, 1 },;  
					{ OemToAnsi('Visualizar')   ,'U_DESTA01a', 0, 2 },;  
					{ OemToAnsi('Manutencao')   ,'U_DESTA01a', 0, 4 },;
					{ OemToAnsi('Estornar')     ,'U_DESTA01b', 0, 5 },;
					{ OemToAnsi('Legenda')      ,'U_DESTA01c', 0, 2 },;
					{ OemToAnsi('Gerar Pedido') ,'U_DESTA01d'  , 0, 4 } }  

Aadd( aCores, { "Empty( C2_X_STATU ) .Or. C2_X_STATU == '1'", "BR_VERDE"    } )
Aadd( aCores, { "C2_X_STATU == '6'"                         , "BR_VERMELHO" } )
Aadd( aCores, { "C2_X_STATU == '9'"                         , "BR_PRETO"    } )

//-- Endereca a funcao de BROWSE
MBrowse( 6,1,22,75,'SC2',,,,,, aCores )

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TSTXXXMnt� Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manutencao - Producao                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Opcao selecionada                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function DESTA01a( cAlias, nReg, nOpcx ) //TSTXXXMnt
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
	
	Aadd( aCols, Array( Len( aHeader ) + 1 ) )
	
	aCols[Len( aCols ), 1 ] := SD3->D3_TM + " - " + AllTrim( Posicione( "SF5", 1, xFilial("SF5") + SD3->D3_TM, "F5_TEXTO" ) )
	aCols[Len( aCols ), 2 ] := SD3->D3_COD
	aCols[Len( aCols ), 3 ] := SD3->D3_QUANT
	aCols[Len( aCols ), 4 ] := SD3->D3_USUARIO
	aCols[Len( aCols ), 5 ] := SD3->D3_EMISSAO

	aCols[Len( aCols ),Len( aHeader ) + 1] := .F.
	
	SD3->( dbSkip() )
EndDo	

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

DEFINE MSDIALOG oDlgEsp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] PIXEL
	oEnch := MsMGet():New( cAlias, nReg,2,,,,aVisual,aPosObj[1],aAltera, 3, , , , , ,.T. )
	oGetD := MSGetDados():New(aPosObj[ 2, 1 ], aPosObj[ 2, 2 ],aPosObj[ 2, 3 ]-10, aPosObj[ 2, 4 ], 2, 'AllWaysTrue','AllWaysTrue',, .T. )
	
	If nOpcx <> 2
		@aPosObj[ 2, 3 ]-5, aPosObj[ 2, 4 ]-100 BUTTON oLiberar PROMPT '&Liberar' SIZE 42,12 PIXEL ACTION U_DESTA01b()
		@aPosObj[ 2, 3 ]-5, aPosObj[ 2, 4 ]-50  BUTTON oRejeitar PROMPT '&Rejeitar' SIZE 42,12 PIXEL ACTION U_TstRejei()
	EndIf
ACTIVATE MSDIALOG oDlgEsp

Return Nil
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DESTA01b  � Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manutencao de Movimentacoes Internas.                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function DESTA01b( cAlias, nReg, nOpcx ) //TstManD3
Local aRegSD3 := {}
Local lOk     := .T.
Private lMsHelpAuto   := .F.
Private lMsErroAuto   := .F.

If nOpcx <> Nil
	nOpcx := aRotina[ nOpcx, 4 ]
EndIf

//-- Estorno.
If nOpcx == 5

	If SC2->C2_X_STATU <> '6'
		MsgStop( 'Esta OP ainda nao foi produziada.' )
		Return Nil
	EndIf
	
	lOk := MsgYesNo( 'Confirma o Estorno da OP ?' )
	
	SD3->( dbSetOrder( 14 ) )
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
			RecLock( 'SC2', .F. )
			SC2->C2_X_STATU := '1'
			SC2->( MsUnLock() )
		EndIf
	EndIf
Else
	//-- Inclusao.
	
	If !Empty( SC2->C2_X_STATU ) .And. SC2->C2_X_STATU <> '1'
		MsgStop( 'Esta OP nao esta com status para Liberacao.' )
		Return Nil
	EndIf
	
 	If MsgYesNo( 'Confirma a Liberacao da OP ?' )
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

Return Nil
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TstRejei  � Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rejeita a OP.                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function TstRejei()
Local aRegSD3 := {}
Private lMsHelpAuto   := .F.
Private lMsErroAuto   := .F.

If !Empty( SC2->C2_X_STATU ) .And. SC2->C2_X_STATU <> '1'
	MsgStop( 'Esta OP nao esta com status para Rejeicao.' )
	Return Nil
EndIf

If MsgYesNo( 'Confirma a Rejeicao da OP ?' )
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
		SC2->( MsUnLock() )
	EndIf
EndIf

oDlgEsp:End()

Return Nil
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TstPed    � Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Prepara para Geracao do Pedido de Venda.                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function DESTA01d()
Local cPerg := "TST999"

PutSX1( cPerg, "01", "NFE Coleta ?", "", "", "mv_ch1", "C", 6, 0, 1, "G", "", "", "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )

If Pergunte( cPerg, .T. )
	//MsgRun( 'Aguarde...Selecionando registros.',, { || CursorWait(), U_TstProc(), CursorArrow() } )
	U_TstProc()
EndIf
Return Nil
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TstProc   � Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa a Geracao do Pedido de Venda.                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function TstProc()
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
                    { "TR1_QUANT"  , "N", TamSX3('C2_QUANT')[1]  , TamSX3('C2_QUANT')[2] },;
                    { "TR1_QUJE"   , "N", TamSX3('C2_QUJE')[1]   , TamSX3('C2_QUJE')[2]  },;
                    { "TR1_PERDA"  , "N", TamSX3('C2_PERDA')[1]  , TamSX3('C2_PERDA')[2] },;
                    { "TR1_CARCAC" , "C", TamSX3('C2_CARCACA')[1], 0                     },;
                    { "TR1_NUMFOG" , "C", TamSX3('C2_NUMFOGO')[1], 0                     },;
                    { "TR1_SERIEP" , "C", TamSX3('C2_SERIEPN')[1], 0                     },;
                    { "TR1_DESEN"  , "C", TamSX3('C2_X_DESEN')[1], 0                     },; 
                    { "TR1_EMISSA" , "D", TamSX3('C2_EMISSAO')[1], 0                     },;
                    { "TR1_DATRF"  , "D", TamSX3('C2_DATRF')[1]  , 0                     } }                                        

                    
Local aCpoShow := { { "TR1_OK"    ,, ""           , "@!" },;
                    { "TR1_STATUS",, "Status"     , "@!" },;
                    { "TR1_CLIENT",, "Cliente"    , "@!" },;                    
                    { "TR1_NUM"   ,, "Coleta"     , "@!" },;
                    { "TR1_ITEM"  ,, "Item"       , "@!" },;
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
cQuery += " C2_X_DESEN, C2_PRODUTO, C2_CARCACA, C2_NUMFOGO, C2_SERIEPN, C2_EMISSAO, C2_DATRF FROM " + RetSqlName("SC2")
cQuery += " WHERE C2_FILIAL = '" + xFilial('SC2') + "' AND"
cQuery += " C2_NUM = '" + mv_par01 + "' AND"
cQuery += " C2_QUANT = C2_QUJE AND"
cQuery += " D_E_L_E_T_ = ' '"
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
    SF1->(dbSeek(xFilial("SF1")+(cAlias1)->C2_NUM,.F.))

    //-- Posiciona Cliente para trazer nome reduzido
    SA1->(dbSetOrder(1))
    SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.))

    //-- Posiciona Vendedor para buscar nome do motorista "a1_vend3"
    SA3->(dbSetOrder(1))
    SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND3,.F.))
    
	RecLock( "TR1", .T. )
	
    TR1->TR1_CLIENT  := SA1->A1_NREDUZ
    TR1->TR1_MOTORI  := SA3->A3_NOME
    TR1->TR1_STATUS  := Iif((cAlias1)->C2_QUANT == (cAlias1)->C2_PERDA, "Recusado", "Liberado")
	TR1->TR1_NUM     := (cAlias1)->C2_NUM
	TR1->TR1_ITEM    := (cAlias1)->C2_ITEM
	TR1->TR1_SEQUEN  := (cAlias1)->C2_SEQUEN
	TR1->TR1_PRODUT  := (cAlias1)->C2_PRODUTO
	TR1->TR1_QUANT   := (cAlias1)->C2_QUANT
	TR1->TR1_QUJE    := (cAlias1)->C2_QUJE
	TR1->TR1_PERDA   := (cAlias1)->C2_PERDA
	// TR1->TR1_PRODUT  := (cAlias1)->C2_PRODUTO // GRAVACAO DUPLICADA
	TR1->TR1_CARCAC  := (cAlias1)->C2_CARCACA
	TR1->TR1_NUMFOG  := (cAlias1)->C2_NUMFOGO
	TR1->TR1_SERIEP  := (cAlias1)->C2_SERIEPN
	TR1->TR1_DESEN   := (cAlias1)->C2_X_DESEN
	TR1->TR1_EMISSA  := (cAlias1)->C2_EMISSAO
	TR1->TR1_DATRF   := (cAlias1)->C2_DATRF

	MsUnLock()
	
	(cAlias1)->( dbSkip() )
EndDo

TR1->( dbGotop() )
If TR1->( !Eof() )
	DEFINE MSDIALOG oDlg FROM 60, 1 TO 365, 685 TITLE "Geracao Automatica - Selecione as OP's para " PIXEL
		oMark := MsSelect():New( "TR1", "TR1_OK",,aCpoShow, @lInverte, @cMarca, { 20, 1, 153, 343 } )
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || nOpca := 1, oDlg:End() }, { || nOpca := 0, oDlg:End() } ) CENTERED
	
	If nOpca == 1
		U_TstGrava()
	EndIf
EndIf

(cAlias1)->( dbCloseArea() )

TR1->( dbCloseArea() )

Ferase( cArqTR1 + GetDbExtension() )

RestArea( aArea )

Return Nil

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TstGrava  � Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava pedido de venda.                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function TstGrava()
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
	
		Pergunte( "TST999", .F. )

		cItem    := StrZero( Val( TR1->TR1_ITEM ), Len( SD1->D1_ITEM ) )
		cAlias2  := GetNextAlias()
		
		//-- Busco o item da nota.
		cQuery := "SELECT * FROM " + RetSqlName("SD1")
		cQuery += " WHERE D1_DOC = '" + TR1->TR1_NUM + "' AND"
		cQuery += " D1_ITEM = '" + cItem + "' AND"
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
						{  'C5_NUM'    , SF1->F1_DOC    , NIL },;
						{  'C5_TIPO'   , 'N'            , NIL },;
						{  'C5_CLIENTE', SF1->F1_FORNECE, NIL },;
						{  'C5_LOJACLI', SF1->F1_LOJA   , NIL },;
						{  'C5_TABELA' , "   "          , NIL },;
						{  'C5_VEND3'  , SA1->A1_VEND3  , NIL },;
						{  'C5_COMIS3' , SA1->A1_COMIS3 , NIL },;
						{  'C5_VEND4'  , SA1->A1_VEND4  , NIL },; 
						{  'C5_COMIS4' , SA1->A1_COMIS4 , NIL },;
						{  'C5_VEND5'  , SA1->A1_VEND5  , NIL },;
						{  'C5_COMIS5' , SA1->A1_COMIS5 , NIL },;
						{  'C5_LIBEROK', 'S'            , NIL },;
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

				//-- tratamento diferenciado para descricao da carcaca quando for servico SO CONSERTO
				//-- descricao da carcaca SC B1_DESC MEDIDA N.FOGO
				//-- descricao do so concerto SC EXT
				cDescPro  := ''
				If lSoConcerto
				   cDescPro := "SC " + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), Alltrim( TR1->TR1_SERIEP ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) )
				Else
				   cDescPro := Alltrim ( (cAlias2)->D1_COD )
				EndIf
				                                               
				//-- Adiciono o Item do Pedido referente ao produto.
				Aadd( aAux , { 'C6_FILIAL' , xFilial("SC6")            , NIL } )
				Aadd( aAux , { 'C6_NUM'    , (cAlias2)->D1_DOC         , NIL } )
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
					MsgInfo( "O valor do servi�o " + (cAlias2)->D1_SERVICO + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Aten�ao!" )
					Return Nil
				EndIf

			 	//-- Zero array para adicionar novo item ao pedido.
			 	aAux  := {}
					 	
				lProduziu := TR1->TR1_QUANT == TR1->TR1_QUJE .And. Empty( TR1->TR1_PERDA )
				cTes      := Iif( lProduziu, cTsServ, '903' )
				cDescPro  := ''
				

				If lProduziu
					cDescPro := Alltrim( TR1->TR1_DESEN ) + " " + AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), Alltrim( TR1->TR1_SERIEP ) , "NF-" + Alltrim( TR1->TR1_NUMFOG ) )
					// cDescPro := AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), Alltrim( TR1->TR1_SERIEP ) , "NF-" + Alltrim( TR1->TR1_NUMFOG ) )
				Else
                    cDescPro := AllTrim( SB1->B1_DESC ) + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), Alltrim( TR1->TR1_SERIEP ) , "NF-" + Alltrim( TR1->TR1_NUMFOG ) )
				EndIf
/*

				If lSoConcerto
				   cDescPro := "SC " + " " + Alltrim( (cAlias2)->D1_COD ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), Alltrim( TR1->TR1_SERIEP ), "NF-" + Alltrim( TR1->TR1_NUMFOG ) )
				Else
				   cDescPro := Alltrim ( (cAlias2)->D1_COD )
				EndIf

*/
				//-- Desconsidero o grupo.
				If !Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
					//-- Adiciono Servico (D1_SERVICO) no Pedido de Venda.
					Aadd( aAux, { 'C6_FILIAL' , xFilial("SC6")           , NIL } )
					Aadd( aAux, { 'C6_NUM'    , (cAlias2)->D1_DOC        , NIL } )
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
					Aadd( aAux, { 'C6_NUMOP'  , (cAlias2)->D1_DOC        , NIL } )
					Aadd( aAux, { 'C6_ITEMOP' , cItOrig                  , NIL } )
					Aadd( aAux, { 'C6_TES'    , cTes                     , NIL } )
					Aadd( aAux, { 'C6_CF'     , SF4->F4_CF               , NIL } )
			
					Aadd( _aSC6, aAux )
				EndIf
						
			Next nA
            
            //(cAlias2)->(dbCloseArea() )
            
			//-- Verifico se foi executado mais algum servico.

			cAlias3 := GetNextAlias()
			
			cOrdemP := mv_par01 + TR1->TR1_ITEM
			cQuery := "SELECT * FROM " + RetSqlName("SD3")
			cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "' AND"
			cQuery += " SUBSTRING( D3_OP, 1, 8 ) = '" + cOrdemP + "' AND"
			cQuery += " D3_GRUPO = 'BAND' AND"
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
				SB1->( MsSeek( xFilial("SB1") + (cAlias3)->D3_X_PROD ) )
				
				If SB1->B1_GRUPO $ "BAND"
					(cAlias3)->( dbSkip() )
					Loop
				EndIf
				
				_nValor := U_BuscaPrcVenda( (cAlias3)->D3_X_PROD, SF1->F1_FORNECE, SF1->F1_LOJA )
				
				If _nValor == 0
					MsgInfo( "O valor do servi�o " + (cAlias3)->D3_X_PROD + " esta sem o preenchimento, o item nao sera gravado no Pedido Venda", "Aten�ao!" )
					Exit
				EndIf

				SA1->( MsSeek( xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA ) )

				lProduziu := TR1->TR1_QUANT == TR1->TR1_QUJE .And. Empty( TR1->TR1_PERDA )
				cTes      := Iif( lProduziu, Iif( SA1->A1_CALCCON == 'S', GetMV("MV_X_TSVED"), '902' ), '903' )
				
				SF4->( MsSeek( xFilial("SF4") + cTes ) )
			
				//-- Zero array para adicionar novo item ao pedido.
				aAux  := {}
				
				//-- Troca a Descricao para OP's que foram recusadas.
				If Alltrim( SB1->B1_GRUPO ) $ Alltrim( GetMV("MV_X_GRPSC") )
//					cDescPro := AllTrim( SB1->B1_DESC ) + " " + (cAlias2)->D1_COD + " " + " " + Alltrim( TR1->TR1_CARCAC ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), TR1->TR1_SERIEP, "NF-" + TR1->TR1_NUMFOG )
// 					cDescPro := "SC EXT" // EDMAR EM 08/8/2005
					cDescPro := AllTrim( SB1->B1_DESC ) + " " + Iif( Empty( TR1->TR1_NUMFOG ), TR1->TR1_SERIEP, "NF-" + TR1->TR1_NUMFOG )
				Else
					cDescPro := SB1->B1_DESC
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
		
		//If Select( cAlias2 ) > 0
			(cAlias2)->(dbCloseArea() )
		//EndIf
	EndIf

	TR1->( dbSkip() )
EndDo

//-- Inclusao dos Pedidos de Venda.
If !Empty( _aSC5 ) .And. !Empty( _aSC6 )
	MsExecAuto( { |x, y, z| Mata410( x, y, z ) }, _aSC5, _aSC6, 3 )
		
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
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TstLeg    � Autor � Robson Alves          � Data �04.03.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Legenda                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������*/
User Function DESTA01c() //TstLeg

BrwLegenda( 'Legenda', cCadastro, { { 'BR_VERDE'   , 'Inspecao' },;
                                    { 'BR_VERMELHO', 'Producao' },;
                                    { 'BR_PRETO'   , 'Rejeitado' } } ) 
Return Nil