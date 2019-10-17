#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJD1TEST  � Autor �Norbert Waage Junior� Data �  27/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Caculo do TES que sera utilizado na Nota fiscal de entrada ���
���          � nas operacoes de Troca e Devolucao do Sigaloja.            ���
�������������������������������������������������������������������������͹��
���Parametros� PARAMIXB[1] - TES configurado no MV_TESTROC                ���
���          � PARAMIXB[2] - Codigo do produto avaliado                   ���
���          � PARAMIXB[3] - Numero do item na operacao avaliada          ���
�������������������������������������������������������������������������͹��	
���Retorno   � Array com o TES utilizado na Nota fiscal de Entrada.       ���
�������������������������������������������������������������������������͹��
���Aplicacao � Ponto de Entrada executado apos a confirmacao da Troca ou  ���
���          � Devolucao da Loja, antes de criar o SD1 e antes de calcular���
���          � os impostos.                                               ���
���          � Executado para cada item da Nota de entrada.               ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LJD1TEST()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aArea		:=	GetArea()
Local cTpOpDev	:=	AllTrim(Upper(GetMv("FS_DEL047")))//AllTrim(Upper(GetMv("FS_DEL046")))
Local cTesDev	:=	""
Local _aRet     := {}

//������������������������������������Ŀ
//�Aborta execu��o na exclus�o da venda�
//��������������������������������������
If P_NaPilha("LOJA140") //Cancelamento de venda
	Return {ParamIxb[1]}
EndIf

//���������������������Ŀ
//�Busca TES inteligente�
//�����������������������
cTesDev := U_MaTesVia(1,cTpOpDev,cCliente,cLoja,"C",ParamIxb[2])

//����������������Ŀ
//�Preenche retorno�
//������������������
If (!Empty(cTesDev))
	_aRet := {cTesDev}		// Tes Inteligente
Else
	_aRet := {ParamIxb[1]}	// {ParamIxb[1]}	// TES configurado no MV_TESTROC
EndIf

RestArea(aArea)

Return(_aRet)