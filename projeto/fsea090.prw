#INCLUDE 'FSEA090.CH'
#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FSEA090  �Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para manutencao Cad. de Excecoes Validacao e campos ���
���          � nas  Importacoes                                           ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FSEA090()
Private cCadastro := STR0001 //'Cadastro de Exce��es de Valida��o'
Private cDelFunc  := '.T.'
Private aRotina   := {}

aAdd( aRotina, { STR0002, 'AxPesqui', 0, 1 } )  // 'Pesquisar'
aAdd( aRotina, { STR0003, 'AxVisual', 0, 2 } )  // 'Visualizar'
aAdd( aRotina, { STR0004, 'AxInclui', 0, 3 } )  // 'Incluir'
aAdd( aRotina, { STR0005, 'AxAltera', 0, 4 } )  // 'Alterar'
aAdd( aRotina, { STR0006, 'AxDeleta', 0, 5 } )  // 'Excluir'

dbSelectArea( 'UA4' )
dbSetOrder( 1 )
mBrowse( ,,,, 'UA4')

Return NIL

/////////////////////////////////////////////////////////////////////////////