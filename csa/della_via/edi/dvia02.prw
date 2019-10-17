#include "protheus.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DVIA02    � Autor � Marcos Augusto Dias� Data �  20/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Browse Importa��o NFE Status.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function DVIA02()

SetPrvt("")

nOpc := 0

aCores    := { 	{'UA9_STATUS=="0"', 'BR_VERMELHO'},;
				{'UA9_STATUS=="1"' , 'BR_VERDE'}}

aRotina := {	{OemToAnsi("Pesquisar")	, "axPesqui"	, 0, 1},;    	// Pesquisar
				{OemToAnsi("Visualizar"), "axVisual"	, 0, 2},;       // Visualizar
				{OemToAnsi("Excluir")	, "axDeleta"	, 0, 5},;       // Visualizar
				{OemToAnsi("Legenda")	, "U_DVIA03"	, 0, 6},;  	    // Legenda
				{OemToAnsi("Logs")		, "U_DVIA06(UA9->UA9_PROCES)"	, 0, 7} }    	// Logs
//				{OemToAnsi("Impress�o")	, "U_DVIA04()"	, 0, 5}}    	// Impress�o

cAlias    := "UA9"
cCadastro := "Importa��o NFE" 

dbSelectArea("UA9")
dbSetOrder(1)
dbGotop()

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(06,01,22,75,cAlias,,,,,,aCores)

Return

/*
�����������������������������������������������������������������������������
LEGENDAS DO Z1
�����������������������������������������������������������������������������*/
User Function DVIA03()
Local aLegenda := {	{"BR_VERMELHO"	,"NFE Importada com sucesso."},;
					{"BR_VERDE"	,"NFE com dados inconsistentes."} }

BrwLegenda(cCadastro,"Legenda",aLegenda) // Legenda

Return .T.

