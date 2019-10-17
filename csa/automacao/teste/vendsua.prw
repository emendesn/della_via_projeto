/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VendSUA  �Autor  �Marcelo Alcantara   � Data �  29/11/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho que retorna o vendedor do orcamento no televendas  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   � nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Aplicacao �Gatinho no campo de cliente da tabela SUA                   ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                           	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VendSUA()
Local cVend:= M->UA_VEND 
// Se Existir o vendedor na tabela SZK pega o vendedor 
If SZK->(DBSEEK(XFILIAL("SZK")+__cUserID)) .and. !Empty(SZK->ZK_VEND)  
	cVend:= SZK->ZK_VEND
ElseIf M->UA_CLIENTE == GETMV("MV_CLIPAD")	// Se nao encontrar e se for do telemarketing sonia pega o vendedor do cadastro do operador
	If SU7->(dbSeek(XFILIAL("SU7")+M->UA_OPERADO))
		cVend:= SU7->U7_CODVEN
	EndIf	
EndIf
Return cVend
