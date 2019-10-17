/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRD080ROT �Autor  �Paulo Benedet       � Data �  05/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Criacao de bot�o no aRotina da tela de Bloqueio de Credito. ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Array com opcoes do aRotina.                                ���
�������������������������������������������������������������������������͹��
���Aplicacao �Ponto de entrada executado na criacao do aRotina da tela    ���
���          �de Bloqueio de Credito (CRDA080).                           ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���Marcio    �30/08/06�      �- Mensagem de log no console do Servidor    ���
���Domingos  �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CRD080ROT()

//���������������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                          �
//�����������������������������������������������������������������������
Local aRotEspec := {}             

AAdd(aRotEspec,{"Pesquisar Cliente","AxPesqui",0,1})
AAdd(aRotEspec,{"Analisa atual" , "U_CRD080Atu", 0 , 4})

Return aRotEspec                        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao   � CRD080Atu   �Autor�Paulo Benedet       � Data �  05/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.    �Avaliacao do credito                                         ���
�������������������������������������������������������������������������͹��
���Parametro�                                                             ���
�������������������������������������������������������������������������͹��
���Uso      �SIGACRD												      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CRD080Atu(cAlias, nRecno, nOpc )

//���������������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                          �
//�����������������������������������������������������������������������
Local aArea     := GetArea()
Local aAreaMAR  := MAR->(GetArea())
Local aAreaSA1  := SA1->(GetArea())

Local nTipo 	:= 3
Local cCliente	:= ""
Local cLoja   	:= ""
Local lRet		:= .F.						// Retorno Default
Local cMV_LibNiv:= SuperGetMv("MV_LIBNIV")
Local nNumReg   := MA7->(RecNo()) //Numero do registro
Local cNomRot   := "CRDA080" + Space(TamSX3("MAR_ROTINA")[1] - 7) //Nome da rotina
Local nRecnoMAR := 0


//��������������������������������������������������������������������������������Ŀ
//�Se o nivel do usuario logado for menor que a permissao de avalicao CONFIGURADA  �
//�pelo MV_LIBNIV para o analista de Credito nao permite avaliar a proxima venda   �
//����������������������������������������������������������������������������������
If cNivel < cMV_LibNiv

	Msgstop("Usuario sem permiss�o de liberar cr�dito para cliente", "Usu�rio sem Permiss�o de libera��o")
Else

	// Verifica se existem registros a serem liberados
	If MA7->MA7_BLOQUE != "1"
		MsgStop("N�o h� registros para serem liberados.","Aten��o !")
		Return(lRet)
	Endif
	
	// Se for possivel fazer um lock no registro liberar para a analise de credito
	If !CRDSEMABLO("CRDA080", nNumReg,@nRecnoMAR)
		// Registro bloqueado
		dbSelectArea("MAR")
		dbSetOrder(1) //MAR_FILIAL+MAR_ROTINA+MAR_REGIST
		If dbSeek(xFilial("MAR") + cNomRot + StrZero(nNumReg, TamSx3("MAR_REGIST")[1]))
			// Mostra usuario
			MsgAlert(OemtoAnsi("O registro est� sendo utilizado pelo usu�rio: " + rTrim(MAR->MAR_USUARI)), "Aviso")
		Else
			// Mostra mensagem de aviso
			MsgAlert(OemtoAnsi("N�o conformidade na Tabela MAR. Por favor, avise o departamento de tecnologia." ), "Aviso")
		EndIf	
		RestArea(aAreaMAR)
		RestArea(aArea)
		Return(lRet)
	EndIf
	
	cCliente := MA7->MA7_CODCLI
	cLoja    := MA7->MA7_LOJA
	RegToMemory("MA7",.F.)
	
	DbSelectArea("SA1")
	Dbsetorder(1)
	If dbSeek(xFilial("SA1")+cCliente+cLoja)
		
		//������������������������������������������������������������������������������������Ŀ
		//�Esse regtomemory garante a abertura do cadastro de clientes para a tela de avaliacao�
		//��������������������������������������������������������������������������������������
		RegToMemory("SA1",.F.)
	
		//Chamada da rotina de liberacao de credito ( nTipo possui valor 3 )
		CRM010_006(nTipo,cCliente,cLoja,nRecnoMAR)
		
		lRet := .T.
	Endif
	
	// Liberar o bloqueio do registro (semaforo)
	DbSelectArea("MAR")                   

	//////////////////////////////////////////////////
	// 30/08/06 - Altera��o solicitada pelo Machima //  
	//////////////////////////////////////////////////
	If nRecnoMAR > 0
		DbGoto(nRecnoMAR)
		ConOut("4. CRDA080 - Exclui registro no MAR. Recno: " + MAR->MAR_REGIST + ;
				" Rotina: " + MAR->MAR_ROTINA + " Usuario MAR: " + MAR->MAR_USUARI + ;
				" Usuario: " + Substr(cUsuario,7,15) + ;
				" Cliente: " + cCliente+"/"+cLoja)     
	Endif

	RecLock("MAR",.F.,.T.)
	DbDelete()
	Msunlock()

	WriteSx2("MAR")

Endif

RestArea(aAreaSA1)
RestArea(aAreaMAR)
RestArea(aArea)

Return(lRet)
