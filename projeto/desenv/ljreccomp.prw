/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LjRecComp �Autor  �Microsiga           � Data �  06/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada do lojxrec na impress�o do cumpom fiscal  ���
���          � Utilizado para gerar outro titulo a receber caso o         ���
���          � seja feito em Cheque ou cart�o                             ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LjRecComp()
Local cMsgComprovante := ParamIxb[1] // texto do comprovante
Local nTotComprovante := ParamIxb[2] // valor total do comprovante
Local cTotRecNFis     := ParamIxb[3] // valor do recebimento
Local nRet            := 0 // retorno do ecf
Local nRecVias        := SuperGetMV("MV_RECVIAS",, 2) // numero de vias

//�������������������������������Ŀ
//� Efetua liquidacao dos titulos �
//���������������������������������
P_d20RecTit(ParamIxb[04])

//��������������������������������Ŀ
//� Emite comprovante de pagamento �
//����������������������������������
nRet := IFAbrCNFis(nHdlECF, &(SuperGetMV("MV_NATRECE", NIL, '"RECEBIMENTO"')), AllTrim(Str(nTotComprovante, 14, 2)), cTotRecNFis)

If !L010AskImp(.F., nRet)
	// Imprime o numero do cupom (aqui o texto eh livre e nao emite a leitura X
	nRet := IFTxtNFis(nHdlECF, cMsgComprovante, nRecVias)
	If !L010AskImp(.F., nRet)
		// Fecha o cupom nao fiscal vinculado
		nRet := IFFchCNFis(nHdlECF)
		If L010AskImp(.F., nRet)
			Return
		EndIf
	EndIf
EndIf

Return
