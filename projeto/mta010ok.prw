/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � MTA010OK �Autor  �Paulo Benedet          � Data �  23/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - Permite a exclusao                               ���
���          �        .F. - Nao permite a exclusao                           ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada do programa MATA010 (Cadastro de Produtos)   ���
���          � para validar a exclusao de registros.                         ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �23/06/05�      �Validar se registro possui amarracao no        ���
���          �        �      �cadastro de pecas x veiculos.                  ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function MTA010OK
Local aArea    := GetArea()
Local aAreaPA2 := {}
Local lRet     := .T.

If cEmpAnt == "01"  
   aAreaPA2 := PA2->(GetArea())
	// ������������������������������������������������������Ŀ
	// � Verifica se existe amarracao com o produto x veiculo �
	// ��������������������������������������������������������
	dbSelectArea("PA2")
	dbSetOrder(1) //PA2_FILIAL+PA2_CODPRO+PA2_ITEM
	If dbSeek(xFilial("PA2") + SB1->B1_COD)
		msgAlert(OemtoAnsi("Este produto n�o pode ser deletado, porque possui amarra��o com ve�culos!"), "Aviso")
		lRet := .F.
	EndIf
	
	RestArea(aAreaPA2)
EndIf

RestArea(aArea)

Return(lRet)
