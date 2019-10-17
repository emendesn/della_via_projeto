#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCFGA03  �Autor  �Bruno Daniel Borges � Data �  16/09/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa de manutencao nas tabelas do SX5 via menu do usu-  ���
���          �ario. E replica de conteudo entre filiais                   ���
�������������������������������������������������������������������������͹��
���Uso       � Parmalat                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCFGA03()
Local oDlgSele	:= Nil
Local oGetDad1	:= Nil
Local cOpcList	:= Nil  
Local nOpcSele	:= 0 
Local cCposSX3 := ""
Local aHedDad1	:= {}
Local aColDad1	:= {}
Local lNovaTab	:= .F.  
Local aPosObj 	:= {} 
Local aObjects := {}                        
Local aSize    := MsAdvSize() 

//��������������������������������������������������������������Ŀ
//� Verifica se deve utilizar a rotina                           �
//����������������������������������������������������������������
//If !U_IsAtiva("RCFGA03",.T.)
//	Return
//Endif

//�������������������������������������Ŀ
//�Monta o aHeader e o aCols do GetDados�
//���������������������������������������
cCposSX3 := "PA3_TABELA|PA3_DESC|PA3_MODO"

dbSelectArea("SX3") 
SX3->(dbSetOrder(1))
SX3->(dbSeek("PA3"))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "PA3"
	If AllTrim(SX3->X3_CAMPO) $ cCposSX3
		Aadd(aHedDad1,{	AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO			,;
								SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3		,;
								SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN,SX3->X3_VISUAL	,;
								SX3->X3_VLDUSER,SX3->X3_PICTVAR,SX3->X3_OBRIGAT})
	EndIf
	
	SX3->(dbSkip())
EndDo            

//����������������������������Ŀ
//�Monta itens com dados do SX5�
//������������������������������
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5")+"00"))
While SX5->(!Eof()) .And. SX5->X5_FILIAL == xFilial("SX5") .And. SX5->X5_TABELA == "00"
	Aadd(aColDad1,Array(Len(aHedDad1) + 1))
	aColDad1[Len(aColDad1)][AScan(aHedDad1,{|x| AllTrim(x[2]) == "PA3_TABELA"})]	:= SX5->X5_CHAVE
	aColDad1[Len(aColDad1)][AScan(aHedDad1,{|x| AllTrim(x[2]) == "PA3_DESC"})] 	:= SX5->X5_DESCRI

	//�������������������������������������������������������������Ŀ
	//�Verifica na tabela de amarracao se a tabela ja foi cadastrada�
	//���������������������������������������������������������������
	dbSelectArea("PA3")
	PA3->(dbSetOrder(1))
	If PA3->(dbSeek(xFilial("PA3")+SX5->X5_CHAVE))
		aColDad1[Len(aColDad1)][AScan(aHedDad1,{|x| AllTrim(x[2]) == "PA3_MODO"})] 		:= PA3->PA3_MODO
	Else
		aColDad1[Len(aColDad1)][AScan(aHedDad1,{|x| AllTrim(x[2]) == "PA3_MODO"})] 		:= "E"
	EndIf
	
	aColDad1[Len(aColDad1)][Len(aHedDad1) + 1] := .F.
	
	SX5->(dbSkip())
EndDo	
//������������������������������������������������������Ŀ
//�Define a area dos objetos                             �
//��������������������������������������������������������
aObjects := {} 
AAdd( aObjects, { 020, 500, .f., .f. } )
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

//�������������������������������������������������������Ŀ
//�Desenha a tela de definicao de Modo de Compartilhamento�
//���������������������������������������������������������
//oDlgSele := TDialog():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1],aPosObj[1,4]-aPosObj[1,2],OemToAnsi("Manuten��o de Tabelas"),,,,,,,,oMainWnd,.T.)
oDlgSele := MsDialog():New(15,3,500,800,OemToAnsi("Manuten��o de Tabelas"),,,,,,,,oMainWnd,.T.)
//oGetDad1 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],14,,,"",,,9999,,,,oDlgSele,aHedDad1,aColDad1)
oGetDad1 := MsNewGetDados():New(19,3,400,700,14,,,"",,,9999,,,,oDlgSele,aHedDad1,aColDad1)
oDlgSele:Activate(,,,,,,{|| EnchoiceBar(oDlgSele,{|| nOpcSele := 1 , oDlgSele:End()},{|| oDlgSele:End()})})       

//�����������������������������Ŀ
//�Gravacao dos dados informados�
//�������������������������������  
If nOpcSele == 1
	dbSelectArea("PA3")
	PA3->(dbSetOrder(1))
	For nCntItem := 1 To Len(oGetDad1:aCols)
		If !oGetDad1:aCols[nCntItem][Len(oGetDad1:aHeader)+1]    
			lNovaTab := .F.
			If PA3->(dbSeek(xFilial("PA3")+AllTrim(oGetDad1:aCols[nCntItem][AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "PA3_TABELA"})])))
				PA3->(RecLock("PA3",.F.))
			Else
				PA3->(RecLock("PA3",.T.))
				lNovaTab := .T.
			EndIf
			
			For nCntHead := 1 To Len(oGetDad1:aHeader)
				//���������������������������������������Ŀ
				//�Mudanca de Exclusivo para Compartilhado�
				//�����������������������������������������
				If !lNovaTab .And. AllTrim(oGetDad1:aHeader[nCntHead][2]) == "PA3_MODO" .And. PA3->PA3_MODO == "E" .And. oGetDad1:aCols[nCntItem][nCntHead] == "C"
					lNovaTab := .T.
				EndIf
				PA3->&(AllTrim(oGetDad1:aHeader[nCntHead][2]))	:= oGetDad1:aCols[nCntItem][nCntHead]
			Next nCntHead
			
			PA3->(MsUnlock())
	
			//�������������������������������������������������������������������������������Ŀ
			//�Se for nova inclusao e for compartilhada replica cadastro para todos as filiais�
			//���������������������������������������������������������������������������������
			If lNovaTab .And. PA3->PA3_MODO == "C"
				U_AltSX5(oGetDad1:aCols[nCntItem][AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "PA3_TABELA"})])
			EndIf		
		EndIf
	Next nCntItem
EndIf

Return Nil