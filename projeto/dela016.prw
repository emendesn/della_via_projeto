#Include "Protheus.Ch"  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA016A �Autor  �Ricardo Mansano     � Data �  24/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � ValidUser para perminitir apena condicoes de pagamento     ���
���          � com E4_TIPOCP=="1" na Venda Assistida.                     ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �.T. se a condicao de pagamento for valida, .F. no contrario ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em LQ_CONDPG                                     ���
�������������������������������������������������������������������������͹��
���Uso       � 039243 - Dellavia Pneus                                    ���
�������������������������������������������������������������������������͹��
���ProjLogico� 039243_PL37.doc                                            ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA016A()
Local cCondPg 	:= GetAdvFVal("SE4","E4_TIPOCP",xFilial("SE4")+M->LQ_CONDPG,1,"Erro")
Local lRet 		:= .T.
	// N�o permite uso de Condicoes de Pagamento que n�o sejam de Vendas
	If cCondPg <> "1"
		Aviso("Aten��o !!!","Cond��o de Pagamento n�o � de Venda !!!",{" << Voltar"},2,"Condi��o de Pagamento !")
        lRet := .F.
	Endif
Return(lRet)