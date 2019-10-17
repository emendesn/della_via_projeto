#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ARQRECEP  �Autor  �Microsiga           � Data �  05/09/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta funcao realiza a importacao de arquivos atraves da    ���
���          � funcao MsExecAuto ou gravando diretamente nas tabelas do   ���
���          � Protheus podendo ser utilizada tambem como workflow.       ���
�������������������������������������������������������������������������͹��
���Uso       � Acelerador de Implantacao                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ArqRecep(aParams) 

Local lMenu := (aParams == NIL)

If lMenu
	Processa({|| Importa(aParams)},"Importando Arquivos")
Else
	Importa(aParams)
Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Importa   �Autor  �Microsiga           � Data �  05/09/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta funcao realiza a importacao de arquivos atraves da    ���
���          � funcao MsExecAuto ou gravando diretamente nas tabelas do   ���
���          � Protheus podendo ser utilizada tambem como workflow.       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Importa(aParams)

Local cPath			:= Alltrim( GetMv("MV_ARQREC") )
Local aDiret		:= Directory( cPath+"*.TXT")
Local cLinha		:= cChave	:= ""
Local cMsg			:= cTipo		:= ""
Local cOcorrencia	:= ""
Local nPosCpo		:= nVal	:= 0
Local lProcessado   := .F.
Local cAliasBusca,nOrdAlias,cIdTran
Local nProc         := 0
Local nProc2        := 0
Private lMenu			:= (aParams == NIL)
Private cLayCab		:= ""
Private nTamLin		:= 0
Private lAuto			:= .F.
Private aAutoItens	:= {}
Private aLayout,aConsiste,nItem,nHandle
Private aAutoCab,nOpc
Private cCampo,cConteudo,cTipo
             
cMsg := "Arquivos encontrados no diretorio (MV_ARQREC) "+cPath+": " + Chr(13) + Chr(10)
For i:=1 To Len(aDiret)
	cMsg += aDiret[i,1] + Chr(13) + Chr(10)
Next	

If lMenu
	cMsg += "Prosseguir a importacao?"
	If ! MsgYesNo(cMsg,"Confirma")
	    MsgAlert("Importacao nao realizada.")
		Return
	Endif
Else
	ConOut(cMsg)
Endif

//����������������������������������������������������Ŀ
//� Processos iniciais...                              �
//������������������������������������������������������
For nItem	:= 1 To Len(aDiret)

	If lMenu
		ProcRegua(1000)
	Endif
	
	nProc  := 0
	nProc2 := 0
	
	nHandle	:= FT_FUSE(cPath+aDiret[nItem,1])
	
	While ! FT_FEOF()
	
		If lMenu
			IncProc("Registros processados: "+Alltrim(Str(nProc2)))
			nProc ++
			nProc2 ++
			If nProc > 1000
				ProcRegua(1000)
				nProc := 0
			Endif
		Endif
		
		cLinha	:= FT_FREADLN()
		cLinha	:= StrTran(Alltrim(cLinha),"|")
		
		cIdTran	:= Substr(cLinha,1,4)     // Identificador do Tipo de Transacao
		
		dbSelectArea("FXF")
		dbSetOrder(1)
		If !dbSeek(xFilial("FXF")+cIdTran,.F.)
			cMsg	:= "Transacao " + cIdTran + " nao encontrada na tabela de parametros do sincronizador (FXF). Verifique!!!"
			If lMenu
				MsgAlert(cMsg)
			Else
				ConOut(cMsg)
			EndIf
			FT_FSKIP(1)
			Loop
		Endif
		
		cLayCab		:= IIf(!Empty(FXF->FXF_IDLAYC),FXF->FXF_IDLAYC,cLayCab)