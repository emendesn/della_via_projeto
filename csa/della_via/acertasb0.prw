#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPSZ     �Autor  �Microsiga           � Data �  08/06/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importacao do cadastro de agregados, categoria de DBF/TOP   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dellavia                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AcertaSb0()

Local aSay		:=	{}
Local aButton	:=	{}
Local lOk		:=	.F.
                           
//���������������������������Ŀ
//�Texto explicativo da rotina�
//�����������������������������
aAdd( aSay, "Esta rotina tem por objetivo efetuar a manuten��o na tabela de pre�os, iniciali-" )
aAdd( aSay, "zando os pre�os dos produtos ainda n�o cadastrados nesta tabela.                " )
aAdd( aSay, "Dependendo da quantidade de produtos cadastrados, a execu��o desta rotina pode  " )
aAdd( aSay, "demorar alguns minutos.                                                         " )

//������������������������Ŀ
//�Botoes da tela principal�
//��������������������������
//Confirma
aAdd( aButton, { 1,.T.,	{|| (lOk := .T.,FechaBatch())}} )
//Cancela
aAdd( aButton, { 2,.T.,	{|| FechaBatch()}} )

//�����������Ŀ
//�Abre a tela�
//�������������
FormBatch( "Atualiza��o de pre�os", aSay, aButton )

//���������������������������������������������Ŀ
//�Acao executada caso o usuario confirme a tela�
//�����������������������������������������������
If lOk
	Processa({|lEnd| ProcSb0(@lEnd)},"Atualizando do SB0 - Aguarde","Atualizando pre�os...",.T.)
Endif

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcSb0   �Autor  �Microsiga           � Data �  05/09/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Execucao da rotina                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �DellaVia Pneus                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcSb0(lEnd)

Local _aArea := GetArea()

dbSelectArea("SB0")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

ProcRegua(RecCount())
dbGotop()

nProc  := 0
nProc2 := 0

While !SB1->(Eof())
	
	If lEnd .And. (lEnd := ApMsgNoYes("Confirma o cancelamento da rotina?","Bot�o Cancela"))
		Return Nil
	EndIf

	IncProc("Processando produto " + SB1->B1_COD )

	nProc ++
	nProc2 ++

	IF SB0->(dbSeek(xFilial("SB0")+SB1->B1_COD)) //+SB1->B1_LOJA) marcelo
		RecLock("SB0",.F.)
			SB0->B0_COD    := SB1->B1_COD
			If SB1->B1_GRUPO== "0081" //Gprupo dos produtos de Saida Rapida - Marcelo
				SB0->B0_PRV1   := 0.00	
			else
				SB0->B0_PRV1   := 0.01	
			endif
	Else		
		RecLock("SB0",.T.)
			SB0->B0_FILIAL := xFilial("SB1")
			SB0->B0_COD    := SB1->B1_COD
			If SB1->B1_GRUPO== "0081" //Gprupo dos produtos de Saida Rapida - Marcelo
				SB0->B0_PRV1   := 0.00	
			else
				SB0->B0_PRV1   := 0.01	
			endif
	EndIF
	
	MsUnlock()

	SB1->(dbSkip())
	
EndDo	

RestArea(_aArea)    

ApMsgInfo("Atualiza��o conclu�da","Atualiza��o SB0")

Return 