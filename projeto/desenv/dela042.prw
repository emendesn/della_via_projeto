#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA042  �Autor  �Anderson Kurtinaitis� Data �  09/08/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � andkurt@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua verificacao do que o usuario digitou nos campos     ���
���          � de Cond. de Pagamento LQ_CONDPG, C5_CONDPAG e UA_CONDPG    ���
���          � verificando se o que foi digitado esta em conforme com     ���
���          � o filtro implementado na consulta SE4 do SXB, ja que as    ���
���          � condicoes apresentadas sao filtradas de acordo com o       ���
���          � conteudo do campo XX_TIPOVND, onde XX pode ser LQ,C5 ou UA ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atravez do X3_VLDUSER do Campo LQ_CONDPG,C5_CONDPAG���
���          � e UA_CONDPG.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                            ���
���Fernando F�26.12.07�      �Retirada a chamada da Rotina como           ���
���          �        �      �validacao do SX3(VLDUSER) do campo LQ_CONDPG���
���          �        �      �para ser chamada somente na Validacao da    ���
���          �        �      �Venda (Ponto de Entrada LJ7001).            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA042()
Local _lRetorno	:= .T.
// Verifican em qual campo o usuario esta para efetuar corretamente a validacao necessaria
Local _cQualCpo	:= ReadVar()
Local _nX		:= 0
Local _lTemServ	:= .F.

//�������������������������������������������������������������H�
//� Se for recebimento, a condicao de pagamento sempre sera CN �
//�������������������������������������������������������������H�
If lRecebe .And. rTrim(M->LQ_CONDPG) == "CN"
	Return(.T.)
EndIf

//����������������������������������������������Ŀ
//�Alterado por: Fernando Data: 26.12.2007       �
//�Tratamento para quando o campo for  LQ_CONDPG.�
//������������������������������������������������
If Empty(_cQualCpo)
	_cQualCpo	:= "M->LQ_CONDPG"
EndIf


If Upper(Alltrim(_cQualCpo)) == "M->LQ_CONDPG"

	If Empty(M->LQ_TIPOVND)
	
		MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	
	Else                         

		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + M->LQ_CONDPG)

			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			If !(Alltrim(M->LQ_TIPOVND) $ Alltrim(SE4->E4_TIPOVND))

				//������������������������������������������������������������Ŀ
				//�Verifica se tem ser servico nas condicoes de pagamento para �
				//�deixar gravar como Condicao Negociada                       �
				//��������������������������������������������������������������
				For _nX := 1 To Len(aPgtos)
					If aPgtos[_nX][3] == "CT" .OR. aPgtos[_nX][3] == "SG"
						_lTemServ := .T.
						Exit
					Endif
				Next       
			                                                               
				If !_lTemServ
			  		MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O se enquadra no Tipo de Venda informado, verifique !"), "Aviso") 
					_lRetorno	:= .F.
				Endif
			EndIf

		//�������������������������������������������������Ŀ
		//� Comentado por Fernando F.                       �
		//� Data: 26.12.2007                                �
		//� Motivo:                                         R		�
		//�        Conforme conversado com a Analista de 	�
		//� Suporte Renata, pode-se Finalizar uma Venda 	�
		//� sem colocar nenhuma Condicao de Pagamento.      �
		//���������������������������������������������������
				
	   /* Else // Nao achou condicao digitada

			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
			_lRetorno	:= .F. 	*/		
			
		EndIf	
	
	EndIf

ElseIf Upper(Alltrim(_cQualCpo)) == "M->C5_CONDPAG"

	If Empty(M->C5_TPVEND)
	
		MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	
	Else

		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + M->C5_CONDPAG)

			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->C5_TPVEND) $ Alltrim(SE4->E4_TIPOVND))

				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O se enquadra no Tipo de Venda informado, verifique !"), "Aviso") 
				_lRetorno	:= .F.
				
			EndIf
		
		Else // Nao achou condicao digitada

			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		
		EndIf	
	
	EndIf


ElseIf Upper(Alltrim(_cQualCpo)) == "M->UA_CONDPG"

	If Empty(M->UA_TIPOVND)
	
		MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	
	Else

		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + M->UA_CONDPG)

			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->UA_TIPOVND) $ Alltrim(SE4->E4_TIPOVND))

				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O se enquadra no Tipo de Venda informado, verifique !"), "Aviso") 
				_lRetorno	:= .F.
				
			EndIf
		
		Else // Nao achou condicao digitada

			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		
		EndIf	
	
	EndIf

Else

	_lRetorno	:= .T.

EndIf

Return(_lRetorno)
