#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA022A �Autor  �Ricardo Mansano     � Data �  03/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Impede que Operador utilize um Grupo de Tabela de Preco    ���
���          � que nao esteja confiogurada para o seu Grupo.              ���
�������������������������������������������������������������������������͹��
���Observacao�                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digitacao)                            ���
���          �        .F. (Obriga correcao quanto a Tab. de Preco)        ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em UA_TABELA                                     ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA022A()
Local lRet := GetAdvFVal("DA0","DA0_GRPATD",xFilial("DA0")+M->UA_TABELA,1,"Erro")==GetAdvFVal("SU7","U7_POSTO",xFilial("SU7")+M->UA_OPERADO,1,"Erro")
	If !lRet                             '
	   Aviso("Aten��o !","Tabela de Pre�o nao pertence ao grupo do Operador!!!",{ " << Voltar " },1,"Tabela de Pre�o")
	Endif
Return(lRet)