#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA038  �Autor  �Norbert Waage Junior   � Data �  22/07/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina substituta para visualizar detalhes do item, pois o a-  ���
���          �tual nao contempla a atualizacao dos valores da venda apos al- ���
���          �guma atualizacao do aColsDet                                   ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Acionada pelos botao detalhes do item, ou pela tecla F8 em al-���
���          �gum item da venda.                                             ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/	
Project Function DELA038()

//��������������������������������Ŀ
//�Somente para itens nao deletados�
//����������������������������������
If !aTail(aCols[N]) .And. MaFisFound("IT",N)

	//��������������������������Ŀ
	//�Remove valor do item atual�
	//����������������������������
	//Lj7T_SubTotal( 2, ( Lj7T_SubTotal(2) - MaFisRet(N, "IT_TOTAL") ))
	
	//����������������������������������������Ŀ
	//�Aguarda a edicao dos detalhes do produto�
	//������������������������������������������
	Lj7DetItem(nRotina)
	
	//��������������������������������������Ŀ
	//�Totaliza o valor do produto atualizado�
	//����������������������������������������
	//Lj7T_SubTotal( 2, ( Lj7T_SubTotal(2) + MaFisRet(N, "IT_TOTAL") ))
	//Lj7T_Total( 2, Lj7T_SubTotal(2) - Lj7T_DescV(2) )    
	Lj7ZeraPgtos()
	
	//���������������������������Ŀ
	//�Atualiza mensagem do Rodape�
	//�����������������������������
	P_LjRodape()

Else 

	MsgStop("Selecione um produto v�lido!")

EndIf

Return Nil