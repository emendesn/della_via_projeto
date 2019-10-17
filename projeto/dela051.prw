#Include "Protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA051  �Autor  �Anderson                  � Data � 14/09/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Tela para usuario entrar com as filiais que a analise de      ���
���          � credito devera ser efetuada, desprezando as filiais nao       ���
���          � digitadas.                                                    ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada via novo botao no Bloqueio de Credito / SIGACRD���
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
Project Function DELA051(cAlias, nRecno, nOpc)
Local aArea    := GetArea()
Local aAreaMA7 := MA7->(GetArea())
Local aAreaSA1 := SA1->(GetArea())

Local nTipo 	:= 3
Local cCliente	:= ""
Local cLoja   	:= ""
Local lRet		:= .F.						// Retorno Default
Local cMV_LibNiv:= SuperGetMv("MV_LIBNIV")
Local lErro		:= .F.						// Flag de controle de erro
Local nRecnoMAR := 0
Local _oDlg1

Static _cFiliais:= Space(200)

//��������������������������������������������������������������������������������Ŀ
//�Se o nivel do usuario logado for menor que a permissao de avalicao CONFIGURADA  �
//�pelo MV_LIBNIV para o analista de Credito nao permite avaliar a proxima venda   �
//����������������������������������������������������������������������������������
If cNivel < cMV_LibNiv
	Msgstop("Usuario sem permiss�o de liberar cr�dito para cliente", "Usu�rio sem Permiss�o de libera��o")
Else
	
	//������������������������������������������������������������������������������������������������������������������������������������������Ŀ
	//�Interface chamada somente se a variaval _cFiliais estiver vazia, a qual solicitara ao usuario o INPUT das filiais que deseja fazer analise�
	//��������������������������������������������������������������������������������������������������������������������������������������������
	If Empty(_cFiliais)
		Define msDialog _oDlg1 Title OemToAnsi("Informe as filiais separadas por barra") From 65,0 to 219,365 of oMainWnd Pixel
		@ 1,7 To 49,177 of _oDlg1 Pixel
		@ 21,17 Say OemToAnsi("Filiais:") Size 45,8 of _oDlg1 Pixel
		@ 19,72 Get _cFiliais Size 76,10 of oDlg1 Pixel
		Define sButton From 55,136 Type 1 Enable of oDlg1 Action (Close(_oDlg1))
	EndIf
	
	DbSelectArea("MA7")
	DbSetOrder(4)
	If MsSeek(xFilial( "MA7" ) + "1" )	// Procura pelo primeiro cadastro de credito bloqueado
		
		While !Eof() .AND. MA7->MA7_BLOQUE == "1"
			//Anderson 14/09/2005
			If MA7->MA7_FILCRE $ _cFiliais
				
				// Se for possivel fazer um lock no registro liberar para a analise de credito
				If CRDSEMABLO("CRDA080",Recno(),@nRecnoMAR)
					lErro := .F.
					Exit
				Else
					lErro := .T.
				Endif
				MA7->(DbSkip())
				
			Else
				
				MA7->(DbSkip())
				
			EndIf
			
		End
	Else
		MsgStop("N�o h� registros para serem liberados.","Aten��o !")
		RestArea(aAreaMA7)
		RestArea(aArea)
		Return(lRet)
	Endif
	
	If lErro
		MsgStop( "Todos os cr�ditos est�o sendo analisados ou n�o existem registros para libera��o.", "Aten��o" )
		RestArea(aAreaMA7)
		RestArea(aArea)
		Return(lRet)
	Endif
	
	//������������������������������������������������������������Ŀ
	//�Se o cadastro de credito nao estiver BLOQUEADO sai da funcao�
	//��������������������������������������������������������������
	If MA7->MA7_BLOQUE != "1"
		RestArea(aAreaMA7)
		RestArea(aArea)
		Return(lRet)
	Endif
	
	cCliente:= MA7_CODCLI
	cLoja   := MA7_LOJA
	RegToMemory("MA7",.F.)
	
	DbSelectArea("SA1")
	Dbsetorder(1)
	If MsSeek(xFilial("SA1")+cCliente+cLoja)
		
		//������������������������������������������������������������������������������������Ŀ
		//�Esse regtomemory garante a abertura do cadastro de clientes para a tela de avaliacao�
		//��������������������������������������������������������������������������������������
		RegToMemory("SA1",.F.)
		
		//Chamada da rotina de liberacao de credito ( nTipo possui valor 3 )
		CRM010_006(nTipo)
		
		lRet := .T.
	Endif
	
	// Liberar o bloqueio do registro (semaforo)
	dbSelectArea("MAR")

	//////////////////////////////////////////////////
	// 19/09/06 - Altera��o solicitada pelo Machima //  
	//////////////////////////////////////////////////
	If nRecnoMAR > 0
		DbGoto(nRecnoMAR)
		ConOut("4. CRDA080 - Exclui registro no MAR. Recno: " + MAR->MAR_REGIST + ;
				" Rotina: " + MAR->MAR_ROTINA + " Usuario MAR: " + MAR->MAR_USUARI + ;
				" Usuario: " + Substr(cUsuario,7,15) + ;
				" Cliente: " + cCliente+"/"+cLoja)     

		RecLock("MAR",.F.,.T.)
		dbDelete()
		MsUnlock()

		WriteSx2("MAR")
	EndIf
Endif

RestArea(aAreaMA7)
RestArea(aAreaSA1)
RestArea(aArea)

Return(lRet)
