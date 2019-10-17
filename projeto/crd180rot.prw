/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRD180ROT �Autor  �Paulo Benedet       � Data �  05/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Criacao de bot�o no aRotina da tela de Fila Crediario.      ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Array com opcoes do aRotina.                                ���
�������������������������������������������������������������������������͹��
���Aplicacao �Ponto de entrada executado na criacao do aRotina da tela    ���
���          �de Fila de Crediario (CRDA180).                             ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���Marcio    �30/08/06�      �- Mensagem de log no console do Servidor  s ���
���Domingos  �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CRD180ROT()

//���������������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                          �
//�����������������������������������������������������������������������
Local aRotEspec := {}             

AAdd(aRotEspec,{"Pesquisar Cliente","AxPesqui",0,1})
AAdd(aRotEspec,{"Analisa atual" , "P_CRD180Atu", 0 , 4})

Return aRotEspec

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao   �CRA180Aval   �Autor�Viviane M. Fernandes� Data �  05/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.    �Avaliacao do credito na fila do Crediario                    ���
�������������������������������������������������������������������������͹��
���Parametro�                                                             ���
�������������������������������������������������������������������������͹��
���Uso      � SIGACRD 													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function CRD180Atu(cAlias, nRecno, nOpc )

//���������������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                          �
//�����������������������������������������������������������������������
Local aArea     := GetArea()
Local aAreaSA1  := SA1->(GetArea())

Local cCliente  := ""
Local cLoja     := ""                                        
Local cMV_LibNiv:= SuperGetMv("MV_LIBNIV")
Local nTipo     := 3
Local lRet		:= .T.						// Retorno Default
Local nRecnoMAR := 0

//��������������������������������������������������������������������������������Ŀ
//�Se o nivel do usuario logado for menor que a permissao de avalicao CONFIGURADA  �
//�pelo MV_LIBNIV para o analista de Credito nao permite avaliar a proxima venda   �
//����������������������������������������������������������������������������������
If cNivel < cMV_LibNiv
	MsgStop("Usu�rio sem permiss�o de liberar cr�dito para cliente", "Usu�rio sem Permiss�o de libera��o")
	lRet  := .F.
Else

	dbSelectArea( "MA7" )

	// Se for possivel dar um lock no registro liberar para a analise de credito
	If !CRDSEMABLO("CRDA180",Recno(),@nRecnoMAR)
		MsgStop("Este cliente ja est� sendo analisado por outro atendente.")
		lRet  := .F.
	EndIf
	
	If lRet .AND. MA7->MA7_BLOQUE <> "4"
		MsgStop("Este cliente n�o pode ser liberado.")
		lRet  := .F.
	Endif
	
	If lRet
		If MA7->MA7_BLOQUE != "4"
			lRet  := .F.
			MsgStop( "Todos os cr�ditos est�o sendo analisados ou n�o existem registros para libera��o.", "Aten��o" )
		EndIf
		If lRet
			cCliente := MA7->MA7_CODCLI
			cLoja    := MA7->MA7_LOJA
			
			RegToMemory("MA7",.F.)
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek(xFilial("SA1")+cCliente+cLoja)
				RegToMemory("SA1",.F.)
				//Chamada da rotina de libera��o de cr�dito ( nTipo possui valor 3 )
				CRM010_006(nTipo,cCliente,cLoja,nRecnoMAR)
				
				lRet := .T.
			Endif
		Endif
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
	Endif
EndIf

MsUnlockAll()

RestArea(aAreaSA1)
RestArea(aArea)

Return (lRet)
