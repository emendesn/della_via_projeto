/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELR008  �Autor  �Paulo Benedet          � Data �  17/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Imprimir mensagem de texto no cupom fiscal                    ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � cRet - Texto a ser impresso. Para ECF Daruma FS2000 v1.0 o    ���
���          �        espaco eh de 180 caracteres.                           ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao contida no parametro MV_LJFISMS e chamada no programa  ���
���          � LOJA701D na impressao da mensagem promocional.                ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Marcio Dom�28/08/06�      �Impressao de mensagem obrigatoria da NF-e      ���
���          �        �      �definida no parametro MV_DELLMS.               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
Regua
         1         2         3         4
123456789012345678901234567890123456789012345678

Lay-out
------------------------------------------------
Orcamento: 000001 Km:100000 Mat:123456789012345/     48
123456789012345/123456789012345/123456789012345/     48
123456789012345/								     16 

------------------------------------------------   

*/
Project Function DELR008()
Local aAreaIni := GetArea()
Local aAreaPA8 := PA8->(GetArea())
Local cRet := "" // variavel com retorno da funcao
Local cKm  := "" // kilometragem do veiculo
Local nTot := 0  // totalizador
Local aMat := {} // array com as matriculas
Local i

//Busca informacoes complementares de seguro
P_D05DadosSeg(2, SL1->L1_NUM)

// Busca numero das matriculas
dbSelectArea("PA8")
dbSetOrder(4) //PA8_FILIAL+PA8_LOJSG+PA8_ORCSG+PA8_ITEM
dbSeek(xFilial("PA8") + cFilAnt + SL1->L1_NUM)

While !EOF();
	.And. PA8_FILIAL == xFilial("PA8");
	.And. PA8_LOJSG == cFilAnt;
	.And. PA8_ORCSG == SL1->L1_NUM
	
	aAdd(aMat, PA8->PA8_MATRIC)
	cKm := StrZero(PA8->PA8_KMSG, 6)
	
	dbSelectArea("PA8")
	dbSkip()
EndDo

nTot := Len(aMat)

If nTot > 0
	//��������������������������������
	//� Impressao de dados de seguro �
	//��������������������������������
	// Ha espaco para somente 10 matriculas
	If nTot > 10
		nTot := 10
	EndIf
	
	// Imprime matriculas de seguro
	For i := 1 to nTot
		cRet += PadR(aMat[i], 15) + "/"
	Next i
	
	nTot := Len(cRet)
	
	// Retira ultima barra e adiciona cabecalho
	If nTot > 0
		cRet := Left(cRet, Len(cRet) - 1)
		cRet := "Km:" + cKm + " Mat:" + cRet
	EndIf
Else
	//�������������������������������
	//� Impressao de dados de venda �
	//�������������������������������
	cRet := "Km:" + AllTrim(SL1->L1_KM)
EndIf       

If !Empty(SA1->A1_CGC)
	cRet += iif(SA1->A1_PESSOA="F"," CPF:"," CNPJ:")+Rtrim(SA1->A1_CGC)
Endif
	    
//If !Empty(GetNewPar("MV_DELLMS",""))
If Upper(AllTrim(SM0->M0_CIDENT)) = "SAO PAULO" .AND. SL1->L1_VALISS > 0 .AND. !Empty(GetNewPar("MV_DELLMS",""))
	cRet += " "+Rtrim(GetNewPar("MV_DELLMS",""))
Endif	

cRet := Substr(cRet,1,180)

RestArea(aAreaPA8)
RestArea(aAreaIni)

Return(cRet)
