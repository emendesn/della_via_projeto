#Include 'rwmake.ch'
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � TMKVEX   �Autor  �Marcio Domingos        � Data �  31/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � .T. Permite cancelar / .F. Nao permite cancelar               ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada que valida o cancelamento do atendimento no  ���
���          � Televendas.                                                   ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Marcio Dom�17/11/06�Validar o cancelamento de orcamentos enviados para a  ���
���          �        �Loja. Se o orcamento estiver finalizado no venda Assis���
���          �        �tida, nao permite cancelar o atendimento.             ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

User Function TMKVEX()    
Local _lRet := .T.
Local _aArea	:= GetArea()

If !Empty(SUA->UA_LOJASL1)
		
	DbSelectArea("SL1")
	DbSetOrder(1)
	If DbSeek(SUA->UA_LOJASL1+SUA->UA_ORCSL1)
		If !Empty(SL1->L1_DOC )
			MsgBox("Este atendimento n�o pode ser cancelado, orcamento j� finalizado na loja !")
			_lRet := .F.
		Endif	  
	Endif
		
Endif		

RestArea(_aArea)
Return _lRet