#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LayoutCab � Autor � Indio Loco         � Data �  01/06/2005 ���
�������������������������������������������������������������������������͹��
���Descricao � mBrowse para manutencao da tabela dos arquivos para        ���
���          � er exportadas.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LayoutCab


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := "FXF"
Private cCadastro := "Tabelas para Importacao"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

aRotina := {{"Pesquisar"	,"AxPesqui",0,1} ,;
			{"Visualizar"	,"AxVisual",0,2} ,;
			{"Incluir"		,"AxInclui",0,3} ,;
			{"Alterar"		,"AxAltera",0,4} ,;
			{"Excluir"		,"AxDeleta",0,5}}

//���������������������������������������������������������������������Ŀ
//� Monta array com os campos para o Browse                             �
//�����������������������������������������������������������������������

Private aCampos := { {"ID.TRANSACAO","FXF_IDTRAN","@!"} ,;
					 {"TIPO TRANSAC","FXF_TPTRAN","@!"} ,;
					 {"DESCRICAO","FXF_TXTRAN","@S30"} ,;
					 {"ALIAS","FXF_ALIAS","@!"} ,;
					 {"ORDEM","FXF_ORDEM","99"} ,;
					 {"POS.INICIAL","FXF_CHPINI","999"} ,;
					 {"TAM.CHAVE","FXF_CHTAM","999"} ,;
					 {"ID.LAY OUT","FXF_IDLAY","@!"} ,;
					 {"ID.LAYOUT CB","FXF_IDLAYC","@!"},;
					 {"ROTINA AUTO","FXF_AUTO","@!"} }
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "FXF"
Private	cCampo	:= "FXF_IDLAY"
dbSelectArea("FXF")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,aCampos,cCampo)

Return
