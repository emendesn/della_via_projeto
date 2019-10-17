User Function Robson()

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
Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.

SF1->( dbSetOrder( 1 ) )
SA1->( dbSetOrder( 1 ) )
SE4->( dbSetOrder( 1 ) )
SF4->( dbSetOrder( 1 ) )
SB1->( dbSetOrder( 1 ) )

//-- Adiciono o Cabecalho do Pedido Venda.
_aSC5 := 	{ {'C5_FILIAL' , xFilial("SC5") , NIL },;
{  'C5_NUM'    , '444444'    , NIL } }

//-- Adiciono o Item do Pedido referente ao produto.
Aadd( aAux , { 'C6_FILIAL' , xFilial("SC6")            , NIL } )
Aadd( aAux , { 'C6_NUM'    , '444444'         , NIL } )
Aadd( aAux , { 'C6_ITEM'   , '01', NIL } )
Aadd( aAux , { 'C6_PRODUTO', '1'         , NIL } )

Aadd( _aSC6, aAux )

/*
//-- Zero array para adicionar novo item ao pedido.
aAux  := {}

Aadd( aAux , { 'C6_FILIAL' , xFilial("SC6")            , NIL } )
Aadd( aAux , { 'C6_NUM'    , '444444'         , NIL } )
Aadd( aAux , { 'C6_ITEM'   , '02', NIL } )
Aadd( aAux , { 'C6_PRODUTO', '1'         , NIL } )

Aadd( _aSC6, aAux )
*/

MsgStop( 'Antes' )

//-- Inclusao dos Pedidos de Venda.
MsExecAuto({|x,y,z|Mata410(x,y,z)},_aSC5,_aSC6,3)

MsgStop( 'Depois ExecAuto' )

//-- Verifico se houve algum erro.
If lMsErroAuto
	If Aviso( "Pergunta", "Pedido de venda nao gerado. Deseja visualizar o log?", { "Sim", "Nao" }, 1, "Atencao" ) == 1
		MostraErro()
	EndIf
EndIf


SD1->( RestArea( _aAreaSD1 ) )
SB2->( RestArea( _aAreaSB2 ) )
SF4->( RestArea( _aAreaSF4 ) )
SA1->( RestArea( _aAreaSA1 ) )
SA2->( RestArea( _aAreaSA2 ) )
SE4->( RestArea( _aAreaSE4 ) )
RestArea( aArea)

Return Nil