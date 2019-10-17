#Include "Protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � LJ7021   �Autor  �Paulo Benedet          � Data �  09/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada do programa LOJA701C                         ���
����������������������������������������������������������������������������͹��
���Parametros� ParamIxb[1] - .T. - Adm/Chq invalido                          ���
���          �               .F. - Adm/Chq valido                            ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - Volta para a tela de venda sem gravar            ���
���          �        .F. - Continua o processo de gravacao                  ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada apos a confirmacao do numero / administradora  ���
���          � da tela de dados complementares da venda.                     ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �09/06/05�      �Validar numero de sepu qdo condicao for        ���
���          �        �      �igual a FS_DEL021.                             ���
���          �        �      �                                               ���
���Norbert   �10/06/05�      �Valida a administradora selecionada quando se  ���
���          �        �      �utilizar sinistro de seguros.                  ���
���          �        �      �                                               ���
���Norbert   �13/06/05�      �Valida a administradora para a utilizacao da   ���
���          �        �      �cond. de pagamento referente a doacoes.        ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function LJ7021()
Local aArea := GetArea()
Local aAreaPA4 := PA4->(GetArea())
Local aAreaSL1 := SL1->(GetArea())
Local aAreaSL4 := SL4->(GetArea())

Local nPosApo, nTamAdm, nX, cTpAdm, nOpc
Local nVlrSeg := 0
Local cRet := ""
Local cAdm := ""
Local lRet := .F.
Local oDlg

Static cNumSEPU

//��������������������������������������������Ŀ
//�Se a rotina foi cancelada, aborta a execucao�
//����������������������������������������������
If ParamIXB[1]
	Return .T.
EndIf

If cEmpAnt == "01"  // DELLA VIA
	//����������������������Ŀ
	//� Inicializa variaveis �
	//������������������������
	aAreaPA4 := PA4->(GetArea())
	nPosApo  := aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
	nTamAdm  := TamSx3("AE_COD")[1]
	cNumSEPU := IIf(Empty(cNumSEPU), Space(TamSX3("PA4_SEPU")[1]), cNumSEPU)
	nX       := 0
	nOpc     := 0
	lRet     := .F.
	cAdm     := ""
	cTpAdm   := ""
	
	// Grava numero do sepu no campo numero do cartao
	If M->LQ_CONDPG == GetMV("FS_DEL021") // condicao venda antecipada sobre sepu
		Define msDialog oDlg Title OemToAnsi("Informe o n�mero do SEPU") From 65,0 to 219,365 of oMainWnd Pixel
		@ 1,7 To 49,177 of oDlg Pixel
		@ 21,17 Say OemToAnsi("N�mero do SEPU:") Size 45,8 of oDlg Pixel
		@ 19,72 Get cNumSEPU Size 76,10 of oDlg Pixel
		Define sButton From 55,136 Type 1 Enable of oDlg Action IIf(ValidaSEPU(cNumSEPU), (nOpc := 1, oDlg:End()), nOpc := 0)
		Activate msDialog oDlg Centered
		
		If nOpc == 1
			aPgtos[1][4][4] := cNumSEPU
		Else
			lRet := .T.
		EndIf
	EndIf
	
	//������������������������������������������������Ŀ
	//�Verifica se foi executado o calculo das parcelas�
	//��������������������������������������������������
	If !lRet
        
		nX := 1

		While (nX <= Len(aCols)) .And. Empty(cRet)

			If !aTail(aCols[nX]) .And. !Empty(aCols[nX][nPosApo])
				cRet	:=	P_DELA020K()
			EndIf
			nX++

		End
		
		If !Empty(cRet)
			lRet := .T.
			ApMsgAlert(cRet,"Parcelas inv�lidas")
		EndIf
		
	EndIf
		
	//�������������������������������������������������������Ŀ
	//�Trata utilizacao de administradoras para acionamento de�
	//�sinstro - Norbert                                      �
	//���������������������������������������������������������
	If !lRet
		
		//Varre parcelas
		For nX := 1 to Len(aPgtos)
			
			//Se houverem parcelas geradas pelo sinistro
			If aPgtos[nX][3] == "CT" .Or. aPgtos[nX][3] == "SG"
				
				cAdm    := aPgtos[nX][4][5]
				nVlrSeg += aPgtos[nX][2]
				
				// Acerta aPgtos
				aPgtos[nX][3]    := "FI"
				aPgtos[nX][4][5] := cAdm
				
				/*
				cAdm 	:= IIf(Empty(aPgtos[nX][4]), "   ", SubStr(aPgtos[nX][4][5],1,3))
				cTpAdm	:= GetAdvFVal("SAE","AE_TIPOFIN",xFilial("SAE")+cAdm,1,"")
				
				If (AllTrim(aPgtos[nX][5]) != AllTrim(cTpAdm))
					
					
					lRet := !lRet
					ApMsgAlert("A administradora financeira cadastrada para a parcela " + StrZero(nX,2) +;
					" deve ser do tipo " + X3Combo("AE_TIPOFIN",AllTrim(aPgtos[nX][5]))+ "." + CRLF+;
					 "Se estiver gerando t�tulos para seguradora e corretora simultaneamente, "+;
					 "certifique-se que a op��o 'Utiliza nas pr�ximas parcelas' est� desmarcada."+;
					 CRLF + "Calcule o sinistro novamente.","Adm. Financeira")
					Exit
					
				EndIf
				*/
				
			EndIf
			
		Next nX
		
		If !Empty(cAdm)
			
			// Acerta condicoes negociadas
			dbSelectArea("SL4")
			dbSetOrder(1) //L4_FILIAL+L4_NUM+L4_ORIGEM
			dbSeek(xFilial("SL4") + M->LQ_NUM)
			
			While !EOF() .And. SL4->(L4_FILIAL + L4_NUM) == xFilial("SL4") + M->LQ_NUM
				If Empty(SL4->L4_ORIGEM)
					If AllTrim(SL4->L4_FORMA) == "CT"
						RecLock("SL4", .F.)
						SL4->L4_FORMA   := "FI"
						SL4->L4_ADMINIS := cAdm
						msUnlock()
						
					ElseIf AllTrim(SL4->L4_FORMA) == "SG"
						RecLock("SL4", .F.)
						SL4->L4_FORMA   := "FI"
						SL4->L4_ADMINIS := cAdm
						msUnlock()
					EndIf
				EndIf
				dbSkip()
			End
			
			// Acerta cabecalho de orcamento
			RecLock("SL1", .F.)
			SL1->L1_FINANC  += nVlrSeg
			SL1->L1_OUTROS  -= nVlrSeg
			SL1->L1_ENTRADA -= nVlrSeg
			msUnlock()
		EndIf
		
	EndIf
	
	//�������������������������������������������������������Ŀ
	//�Trata utilizacao da administradora para casos de doacao�
	//�Norbert - 13/07/2005                                   �
	//���������������������������������������������������������
	If !lRet .And. (AllTrim(Upper(_cD020CPG)) == Alltrim(Upper(GetMv("FS_DEL012"))))
    	
    	lRet	:= .T.									//Pre-define como retorno invalido
    	nX		:= 1   									//Prepara contador
    	cTpAdm	:= Alltrim(Upper(GetMv("FS_DEL035")))	//Administradoras do tipo Doacao
	
		//Varre as parcelas
		While (nX <= Len(aCols)) .And. lRet
			
			cAdm := SubStr(aPgtos[nX][4][5],1,3)			
			lRet := !(cAdm $ cTpAdm)
			nX++

		End
		
		If lRet
			ApMsgAlert("Selecione a administradora doa��o","Valida��o")
		EndIf
				
	EndIf
	
	// Restaura ambiente
	RestArea(aAreaPA4)
	
EndIf

RestArea(aAreaPA4)
RestArea(aAreaSL1)
RestArea(aAreaSL4)
RestArea(aArea)

Return(lRet)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � ValidaSEPU      �Autor � Paulo Benedet       �Data � 04/07/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Validar numero de SEPU                                        ���
����������������������������������������������������������������������������͹��
���Parametros� cNumSEPU - Numero do SEPU                                     ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - T - Numero correto                                     ���
���          �        F - Numero incorreto                                   ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pelo ponto de entrada LJ7021                   ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function ValidaSEPU(cNumSEPU)
Local aArea    := GetArea()
Local aAreaPA4 := PA4->(GetArea())
Local lRet := .T.

// Valida numero de SEPU
dbSelectArea("PA4")
dbSetOrder(1) //PA4_FILIAL+PA4_SEPU
If !dbSeek(xFilial("PA4") + AllTrim(cNumSEPU))
	lRet := .F.
	MsgAlert(OemtoAnsi("N�mero de SEPU inexistente!"), "Aviso")
/*
ElseIf Empty(cNumSEPU)
	lRet := .F.
	MsgAlert(OemtoAnsi("N�mero de SEPU inexistente!"), "Aviso")
ElseIf M->(LQ_CLIENTE + LQ_LOJA) <> PA4->(PA4_CODCLI + PA4_LOJA) // valida cliente
	lRet := .F.
	MsgAlert(OemtoAnsi("N�mero de SEPU inexistente para este cliente!"), "Aviso")
*/
EndIf

// retorna ambiente
RestArea(aAreaPA4)
RestArea(aArea)

Return(lRet)
