#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA017A �Autor  �Ricardo Mansano     � Data �  30/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Impede entrada de produtos de Venda Rapida em lojas        ���
���          � que nao tenham esta permissao.                             ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Continua digitacao)                            ���
���          �        .F. (Obriga correcao quanto ao Codigo do Produto)   ���
�������������������������������������������������������������������������͹��
���Aplicacao � ValidUser em D1_COD                                        ���
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
Project Function DELA017A()
Local cGrupo 		:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+M->D1_COD,1,"Erro")
Local cLojaPerm		:= GetAdvFVal("SLJ","LJ_SAIRAP",xFilial("SLJ")+SM0->M0_CODIGO+SM0->M0_CODFIL,3,"Erro")
Local lRet         	:= !(cGrupo == Alltrim(GetMv("FS_DEL002"))) // Parametro de Produto Generico

	// Informa que Loja nao permite Entrada de Genericos
	//--> 1 = Sim (Permite entrada de produtos Genericos)
	//--> 2 = Nao (Nao Permite)
	If cLojaPerm == "2"
		If !lRet 
			Aviso("Aten��o !!!","Loja n�o permite entrada de Produtos de Venda R�pida !!!",{" << Voltar"},2,"Entrada de Produtos !")
	    Endif
	Else           
		// Libera loja com permissao de entrada de produtos de Saida Rapida
		lRet := .T.
	Endif
	
Return(lRet)
