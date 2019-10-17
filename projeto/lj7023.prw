#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LJ7023   � Autor �Norbert Waage Junior� Data �  14/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada utilizado para esconder botoes na venda   ���
���          � assistida                                                  ���
�������������������������������������������������������������������������͹��
���Parametros� ParamIxb[1] = 1 -> Nome do botao                           ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Oculta o botao)                                ���
���          �        .F. (Permite a exibicao do botao)                   ���
�������������������������������������������������������������������������͹��
���Aplicacao � Permite ocultar botoes a serem exibidos no pagamento da    ���
���          � venda assistida                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Lj7023()

Local lRet		:= .F.
Local cBotoes	:= "COND.NEGOCIADA/DINHEIRO/CHEQUE/CARTAO DE CREDITO/CARTAO DE DEBITO/DUPLICATA/FINANCIADO/CORRETORA/SEGURADORA"

If Upper(Alltrim(ParamIxb[1])) == "COND.NEGOCIADA"
	
	//�����������������������������������������Ŀ
	//�Bloqueia o bot�o de nome "Cond.Negociada"�
	//�������������������������������������������	
	lRet := .T.
	
Else
	
	//����������������������������������������������������������Ŀ
	//�Bloqueia botoes das condicoes negociadas para usuarios sem�
	//�acesso                                                    �
	//������������������������������������������������������������
	If (SubStr(cUsuario,56,1) == "N") .And. (Upper(Alltrim(ParamIxb[1])) $ cBotoes)
		lRet := .T.
	EndIf

EndIf

Return lRet