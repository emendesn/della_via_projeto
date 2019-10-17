#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � Crd010PG        �Autor � Paulo Benedet       �Data � 28/06/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada                                              ���
����������������������������������������������������������������������������͹��
���Parametros� ParamIxb[1] - 2 - visualizacao                                ���
���          �               3 - inclusao                                    ���
���          �               4 - alteracao                                   ���
���          �               5 - exclusao                                    ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada do programa CRDA010 apos a gravacao dos      ���
���          � arquivos.                                                     ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Benedet   �28/06/05�      �Gravar informacoes de credito segundo PL26.    ���
���          �        �      �                                               ���
���Norbert   �13/07/05�      �Gravacao dos dados de referencia do cliente    ���
���          �        �      �                                               ���
���Benedet   �17/09/05�      �Verificacao do programa que esta chamando o    ���
���          �        �      �ponto de entrada.                              ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function CRD010PG()

If FunName() == "P_DELA037" .Or. FunName() == "CRDA010"
	//����������������������������������������������������������������������������Ŀ
	//�Benedet - Gravacao dos dados de credito do cliente. (Valor e Dt de Validade)�
	//������������������������������������������������������������������������������
	If ParamIxb[1] == 3 .Or. ParamIxb[1] == 4
		P_MontaCred()
	EndIf
EndIf

If FunName() == "P_DELA037"
	//�������������������������������������������������������Ŀ
	//�Norbert - Gravacao dos dados das referencias do cliente�
	//���������������������������������������������������������
	SAOGrava()
EndIf

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � SAOGrava        �Autor �Norbert Waage Junior �Data � 13/07/05 ���
����������������������������������������������������������������������������͹��
���Descricao �Gravacao das referencias do cliente                            ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada pelo ponto de entrada CRD010PG para gravar as���
���          � informacoes digitadas pelo usuario na tela de referencias.    ���
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
Static Function SAOGrava()

Local aArea		:=	GetArea()
Local aCposCh	:=	{}
Local lInclui	:=	(ParamIxb[1] == 3)
Local lAltera	:=	(ParamIxb[1] == 4)
Local lExclui	:=	(ParamIxb[1] == 5)

If lAltera .Or. lInclui
	
	//���������������������Ŀ
	//�Dados de Instituicoes�
	//�����������������������
	aCposCh	:=	{}
	
	AAdd(aCposCh,{"AO_FILIAL"	, xFilial("SAO")})
	AAdd(aCposCh,{"AO_TIPO"		, "1"			})
	AAdd(aCposCh,{"AO_CLIENTE"	, SA1->A1_COD	})
	AAdd(aCposCh,{"AO_LOJA"		, SA1->A1_LOJA	})
	
	P_GetToFile("SAO",1,_aHead037[1],_aCols037[1],_aRecn037[1],aCposCh)
	
	//�����������������Ŀ
	//�Dados de Empresas�
	//�������������������
	aCposCh	:= {}
	
	AAdd(aCposCh,{"AO_FILIAL"	, xFilial("SAO")})
	AAdd(aCposCh,{"AO_TIPO"		, "2"			})
	AAdd(aCposCh,{"AO_CLIENTE"	, SA1->A1_COD	})
	AAdd(aCposCh,{"AO_LOJA"		, SA1->A1_LOJA	})
	
	P_GetToFile("SAO",1,_aHead037[2],_aCols037[2],_aRecn037[2],aCposCh)
	
	//���������������Ŀ
	//�Dados de Bancos�
	//�����������������
	aCposCh	:= {}
	
	AAdd(aCposCh,{"AO_FILIAL"	, xFilial("SAO")})
	AAdd(aCposCh,{"AO_TIPO"		, "3"			})
	AAdd(aCposCh,{"AO_CLIENTE"	, SA1->A1_COD	})
	AAdd(aCposCh,{"AO_LOJA"		, SA1->A1_LOJA	})
	
	P_GetToFile("SAO",1,_aHead037[3],_aCols037[3],_aRecn037[3],aCposCh)
	
ElseIf lExclui
	
	DbSelectArea("SAO")
	DbSetOrder(1)//AO_FILIAL+AO_CLIENTE+AO_LOJA+AO_TIPO
	DbSeek(xFilial("SAO") + M->A1_COD + M->A1_LOJA)
	
	While !Eof() .And. (SAO->(AO_FILIAL+AO_CLIENTE+AO_LOJA) == xFilial("SAO") + M->A1_COD + M->A1_LOJA)
		
		RecLock("SAO",.F.)
		DbDelete()
		MsUnLock()
		DbSkip()
		
	End
	
EndIf

RestArea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetToFile �Autor  �Norbert Waage Junior� Data �  07/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Descarrega o conteudo da GetDados em uma area de trabalho   ���
���          �Parametros:                                                 ���
���          �cAlias   - Area de trabalho que recebera os campos          ���
���          �nIndice  - Numero do indice a ser considerado               ���
���          �aH       - aHeader da GetDados relacionada                  ���
���          �aC       - aCols da GetDados relacionada                    ���
���          �aRecnos  - Recnos dos itens da getdados                     ���
���          �aCposChv --Campos a serem gravados alem dos campos do aCols ���
���          �         �-Estrutura aCposChv:  {{CAMPO,VALOR},...}         ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function GetToFile(cAlias,nIndice,aH,aC,aRecnos,aCposChv)

Local aArea		:=	GetArea()
Local nPosDel	:=	Len(aH) + 1
Local nRegs		:=	Len(aRecnos)
Local nPos,nCampo

//���������������������Ŀ
//�Abre area de trabalho�
//�����������������������
DbSelectArea(cAlias)
DbSetOrder(nIndice)

//���������������������������Ŀ
//�Percorre os campos do aCols�
//�����������������������������
For nPos := 1 to Len(aC)
	
	//���������������������������������������������������Ŀ
	//�Se o item nao estiver deletado e estiver preenchido�
	//�����������������������������������������������������
	If !aC[nPos][nPosDel] .And. EmptyCols(nPos,aC)
		
		//��������������������������������������������������Ŀ
		//�Verifica se o item atual ja se encontrava no banco�
		//����������������������������������������������������
		If nPos > nRegs
			RecLock(cAlias,.T.)
		Else
			DbGoTo(aRecnos[nPos])
			RecLock(cAlias,.F.)
		EndIf
		
		//����������������������Ŀ
		//�Atualizacao dos campos�
		//������������������������
		(cAlias)->(&(cAlias+"_FILIAL")) := xFilial(cAlias)
		
		//�������������������������������������Ŀ
		//�Grava campos que nao estao no aHeader�
		//���������������������������������������
		For nCampo := 1 to Len(aCposChv)
			(cAlias)->(&(aCposChv[nCampo][1]))	:= aCposChv[nCampo][2]
		Next nCampo
		
		//�����������������������������Ŀ
		//�Percorre os campos do aHeader�
		//�������������������������������
		For nCampo := 1 to Len(aH)
			
			//����������������������������������
			//�Grava os campos de contexto real�
			//����������������������������������
			If (cAlias)->(FieldPos(aH[nCampo][2])) > 0
				(cAlias)->(&(aH[nCampo][2]))	:=	aC[nPos][nCampo]
			EndIf
			
		Next nCampo
		
		MsUnLock()
		
	Else
		
		//�����������������
		//�Trata a Delecao�
		//�����������������
		If nPos <= nRegs
			
			DbGoTo(aRecnos[nPos])
			RecLock(cAlias,.F.)
			DbDelete()
			MsUnLock()
			
		EndIf
		
	EndIf
	
Next nPos

RestArea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EmptyCols �Autor  �Norbert Waage Junior� Data �  07/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para verificar se o aCols foi preenchido             ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EmptyCols(n,aCols)

Local lRet:=.T.,lVazio:=.T.

If n==Len(aCols)
	Aeval(aCols[n],{|x|If(lVazio,lVazio:=Empty(x),lVazio)})
	If lVazio
		lRet:=.F.
	EndIf
EndIf

Return (lRet)
