#INCLUDE "protheus.ch"    
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA029   �Autor  �Norbert Waage Junior   � Data �  23/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �AxCadastro para manutencao da tabela de tipos de pagamento     ���
����������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo menu SIGALOJA.XNU especifico.             ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA029()

Local cVldAlt := ".T." // Validacao para permitir a alteracao
Local cVldExc := ".T." // Validacao para permitir a exclusao

dbSelectArea("PAF")
dbSetOrder(1)
AxCadastro("PAF","Cond. Pagamento X Tipo de venda",cVldExc,cVldAlt)

Return Nil