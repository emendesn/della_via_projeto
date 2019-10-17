#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FSES001  �Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na Rotina de Sincronia Sincronia ao final ���
���          � do arquivo                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FSES001()
Local aArea     := GetArea()
Local cPacote   := ParamIXB[1]
Local cTabela   := ParamIXB[2]
Local lDelecao  := ParamIXB[3]
Local cArqTrab  := ParamIXB[4]
Local aAreaTRAB := (cArqTrab)->( GetArea() )
Local nPrxSeq   := ''
Local cCampo    := ''

//���������������������������������Ŀ
//� Numero Sequencial de movimentos �
//�����������������������������������
If !lDelecao .AND. cTabela $ 'SD1/SD2/SD3'
	
	If     cTabela == 'SD1'
		cCampo   := 'D1_NUMSEQ'
		
	ElseIf cTabela == 'SD2'
		cCampo   := 'D2_NUMSEQ'
		
	ElseIf cTabela == 'SD3'
		cCampo   := 'D3_NUMSEQ'
		
	EndIf
	
	(cArqTrab)->( dbGoTop() )
	
	While !(cArqTrab)->( Eof() )
		
		
		dbSelectArea( cArqTrab )
		RecLock( cArqTrab, .F. )
		(cArqTrab)->( & ( cCampo ) ) := ProxNum()
		MsUnlock()
		
		(cArqTrab)->( dbSkip() )
	End
	
EndIf

//���������������������������������Ŀ
//� Fim do tratamento do numero     �
//� sequencial                      �
//�����������������������������������

RestArea( aAreaTRAB )
RestArea( aArea )
Return .T.