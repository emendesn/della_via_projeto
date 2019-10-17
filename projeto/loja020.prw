/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � LOJA020  �Autor  �Paulo Benedet             � Data � 22/08/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada apos a gravacao dos arquivos na devolucao.   ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �22/08/05�      �Registrar devolucao de seguros                 ���
����������������������������������������������������������������������������͹��
���Marcio Dom�17/03/06�Chamad�Tratamento da devolu��o de seminovos (produtos ���
���          �        �AANIUJ�vendidos com lote).                            ���
���          �        �      �Esta personalizacao foi desenvolvida para      ���
���          �        �      �corrigir o problema que ocorre na devolucao de ���
���          �        �      �produtos com lote atualmente (No LOJA020).     ���
���          �        �      �A solucao definitiva deste problema eh         ���
���          �        �      �atualizar o Top Connect. Como isso eh inviavel ���
���          �        �      �neste momento foi feito este paliativo.        ���
���          �        �      �IMPORTANTE : Apos a atualizacao do Top Connect ���
���          �        �      �basta mudar para MV_DEVLOTE = .F. para tirar   ���
���          �        �      �esta personalizacao de operacao.               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function LOJA020()
Local _n := 0

If cEmpAnt == "01" // Della Via
	P_DELA045(SF1->F1_DOC, SF1->F1_SERIE)
	
	//Remove dados do sinistro		Incluido 14/08/06 - Regiane
	P_DelA020E(SL1->L1_FILIAL,SL1->L1_NUM,SL1->L1_DOC,SL1->L1_SERIE)

/*
������������������������������������������������������������������������������Ŀ
�Tratamento nao conformidade na devolu��o de venda com lote. Chamado AANIUJ    �
�Ap�s atualiza��o da Build e TopConnect alterar parametro para MV_DEVLOTE = .F.�
��������������������������������������������������������������������������������
*/
	If GetMV("MV_DEVLOTE")  
	
		If Len(_aLote) > 0 // Matriz alimentada no p.e. Lj020ite do projeto do CSA
			DbSelectArea("SL2")
			_aAreaSL2	:= GetArea()
			DbSetOrder(1)  // L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO                                                                                                                             
			For _n:=1 to Len(_aLote)     
				// Matriz _aLote
				// ==============
				// 1-Filial
				// 2-Orcamento
				// 3-Item
				// 4-Produto
				// 5-Local
				// 6-Quantidade
				// 7-Lote CTL
				// 8-Localiza��o
				// 9-Lote
		
				If 	DbSeek(_aLote[_n][1]+_aLote[_n][2]+_aLote[_n][3]+_aLote[_n][4])  //Filial+Orcamento+Item+Produto
					RecLock("SL2",.F.)
					SL2->L2_LOTECTL	:= _aLote[_n][7]
					SL2->L2_LOCALIZ	:= _aLote[_n][8]
					SL2->L2_NLOTE	:= _aLote[_n][9]
					MsUnlock()                                                                                            
				Endif	           
			Next             
		
			DbSelectArea("SB8")
			_aAreaSB8	:= GetArea()	
			
			DbSelectArea("SD1")
			_aAreaSD1	:= GetArea()  
			DbSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
			DbGoTop()
			If DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE)   
				Do While 	SD1->D1_FILIAL	== 	xFilial("SD1")	.And.;
							SD1->D1_DOC		==	SF1->F1_DOC		.And.;
							SD1->D1_SERIE	==	SF1->F1_SERIE	.And. !Eof()         
							
					DbSelectArea("SL2")
					DbSetOrder(3) // L2_FILIAL+L2_SERIE+L2_DOC+L2_PRODUTO                                                                                                                            
					If DbSeek(xFilial("SL2")+SD1->D1_SERIORI+SD1->D1_NFORI+SD1->D1_COD)
						RecLock("SD1",.f.)
						SD1->D1_NUMLOTE	:= SL2->L2_NLOTE
						SD1->D1_LOTECTL	:= SL2->L2_LOTECTL			
						MsUnlock()
					Endif	
								
					DbSelectArea("SB8")
					DbSetOrder(3) // B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE                                                                                            
					If DbSeek(xFilial("SB8")+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_LOTECTL) //Filial+Produto+Local+Lote CTL
						RecLock("SB8",.F.)
						SB8->B8_SALDO	+= SD1->D1_QUANT			
						MsUnlock()
					Endif	
					DbSelectArea("SD1")
					DbSkip()
						
				Enddo	
			
				RestArea(_aAreaSB8)
				RestArea(_aAreaSD1)
				RestArea(_aAreaSL2)
				_aLote	:= {}

			Endif
		Endif
    Endif
EndIf                           

Return