#INCLUDE "FSEA070.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FSEA070  �Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para manutencao Cad. de Excecoes de Chave Unica     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FSEA070()
Local   _cFiltSX2 := ""
Local   _bFiltSX2 := NIL
Private cCadastro := STR0001 //"Cadastro de Exce��o de Chave Unica"
Private cDelFunc  := ".T."
Private aRotina   := {}

aAdd( aRotina, {STR0002 ,"AxPesqui", 0, 1} )  //"Pesquisar"
aAdd( aRotina, {STR0003 ,"AxVisual", 0, 2} )  //"Visualizar"
aAdd( aRotina, {STR0004 ,"AxInclui", 0, 3} )  //"Incluir"
aAdd( aRotina, {STR0005 ,"AxAltera", 0, 4} )  //"Alterar"
aAdd( aRotina, {STR0006 ,"AxDeleta", 0, 5} )  //"Excluir"

// Limpa Filtro SX2
dbSelectArea("SX2")
_cFiltSX2 := dbFilter()
_bFiltSX2 := IIF(!Empty(_cFiltSX2), &("{|| "+ALLTRIM(_cFiltSX2)+" }"), "")
dbClearFilter()
dbGoTop()

dbSelectArea("UA7")
dbSetOrder(1)
mBrowse( ,,,,"UA7")

// Restaura Filtro SX2
dbSelectArea("SX2")
If !Empty(_cFiltSX2)
	dbSetFilter(_bFiltSX2, _cFiltSX2)
EndIf

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FSEA070  �Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao do Campo Ordem nas   Excecoes de Chave Unica     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UA7OrdVld( cTabela, nOrdem )
Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaSIX := SIX->( GetArea() )
Local aLit     := '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

SIX->( dbSetOrder ( 1 ) )

If !SIX->( dbSeek( cTabela + SubStr( aLit, nOrdem, 1  ) ) )
	ApMsgStop( 'Ordem n�o existe para esta tabela', 'ATEN��O' )
	lRet := .F.
Else
	M->UA7_DESCCH := SIX->CHAVE
EndIf

RestArea( aAreaSIX )
RestArea( aArea )
Return lRet

/////////////////////////////////////////////////////////////////////////////