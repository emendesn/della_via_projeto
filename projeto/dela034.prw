#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PAKCPOVAL�Autor  � Ernani Forastieri  � Data �  30/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Manutencao do cadastro de Permissoes de Campos PAK         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelA034()
Private cCadastro := 'Cadastro de Permiss�es de Campos'
Private cDelFunc  := '.T.'
Private aRotina   := {}

aAdd( aRotina, { "Pesquisar" , "AxPesqui", 0, 1} )
aAdd( aRotina, { "Visualizar", "AxVisual", 0, 2} )
aAdd( aRotina, { "Incluir"   , "AxInclui( 'PAK', RecNo(), 3,,,, 'P_PAKValDad()')", 0, 3} )
aAdd( aRotina, { "Alterar"   , "AxAltera( 'PAK', RecNo(), 4,,,,,'P_PAKValDad()')", 0, 4} )
aAdd( aRotina, { "Excluir"   , "AxDeleta", 0, 5} )

dbSelectArea( 'PAK' )
dbSetOrder( 1 )
mBrowse( ,,,, 'PAK' )

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PAKCPOVAL�Autor  � Ernani Forastieri  � Data �  30/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para validacao do campos do PAK                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function PAKCpoVal( cCampo )
Local lRet     := .F.
Local aArea    := GetArea()
Local aAreaSX3 := SX3->( GetArea() )

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek(cCampo)
	lRet     := .T.
Else
	Help( " ", 1, "EXISTCPO")
EndIf

RestArea(aAreaSX3)
RestArea(aArea   )

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PAKVALDAD�Autor  � Ernani Forastieri  � Data �  30/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para validacao do campos do PAK ( TudoOK )          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function PAKValDad( cArq , nReg, nOpc )
Local lRet     := .T.
Local cMsg     := ''
Local aArea    := GetArea()
Local aAreaPAK := PAK->( GetArea() )

If  (  Empty( M->PAK_CAMPO ) .AND. M->PAK_PERMIS <> 'T' ) .OR.;
	( !Empty( M->PAK_CAMPO ) .AND. M->PAK_PERMIS == 'T' )
	
	lRet := .F.
	cMsg := 'Tipo de permiss�o incompat�vel com o campo.' + Chr( 13 )
	cMsg += 'Apenas Para permiss�es do Tipo "T" o campo deve' + Chr( 13 )
	cMsg += 'estar em branco.'
	
	ApMsgStop( cMsg, 'ATEN��O' )
	
EndIf

If lRet .AND. nOpc == 3
	If PAK->( dbSeek( xFilial( 'PAK' ) + M->PAK_USUARI + M->PAK_CAMPO ) )
		lRet := .F.
		Help( " ", 1, "JAGRAVADO" )
	EndIf
EndIf

RestArea( aAreaPAK )
RestArea( aArea )
Return lRet

/////////////////////////////////////////////////////////////////////////////