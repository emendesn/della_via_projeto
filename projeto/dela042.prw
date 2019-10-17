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
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Project Function DELA042()

//Variaveis Locais da Funcao
Local _lRetorno	:= .T.
// Verifican em qual campo o usuario esta para efetuar corretamente a validacao necessaria
Local _cQualCpo	:= ReadVar()

If Upper(Alltrim(_cQualCpo)) == "M->LQ_CONDPG"

	If Empty(M->LQ_TIPOVND)
	
		MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso") 
		_lRetorno	:= .F.
	
	Else

		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + M->LQ_CONDPG)

			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->LQ_TIPOVND) $ Alltrim(SE4->E4_TIPOVND))

				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O se enquadra no Tipo de Venda informado, verifique !"), "Aviso") 
				_lRetorno	:= .F.
				
			EndIf
		
		Else // Nao achou condicao digitada

			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		
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
