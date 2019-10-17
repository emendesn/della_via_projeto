#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FVldCond �Autor  � Alexandre Martim   � Data �  31/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua verificacao do que o usuario digitou nos campos     ���
���          � de Cond. de Pagamento C1_CONDPG, C3_COND, C7_COND, C8_COND ���
���          � CB_COND, F1_COND, AIA_CONDPAG.                             ���
���          � verificando se o que foi digitado esta em conforme com     ���
���          � o filtro implementado na consulta SE4 do SXB               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FVldCond()

//Variaveis Locais da Funcao
Local _lRetorno	:= .T.
// Verifican em qual campo o usuario esta para efetuar corretamente a validacao necessaria
Local _cQualCpo	:= ReadVar()

If Upper(Alltrim(_cQualCpo)) == "M->C1_CONDPAG"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->C1_CONDPAG)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
	    If !Empty(M->C1_CONDPAG)
			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "CCONDICAO" .and. funname() $ "MATA120/MATA121/MATA125/MATA103/MATA150" 

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + cCondicao)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
	    If !Empty(cCondicao)
			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->AIA_CONDPG"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->AIA_CONDPG)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
	    If !Empty(M->AIA_CONDPG)
			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
	EndIf	

ElseIf Upper(Alltrim(_cQualCpo)) == "M->A2_COND"

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4") + M->A2_COND)
		// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
		IF SE4->E4_TIPOCP=="1"
				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O e valida para compra, verifique !"), "Aviso") 
			_lRetorno	:= .F.
		EndIf
	Else // Nao achou condicao digitada
	    If !Empty(M->A2_COND)
			MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso") 
    		_lRetorno	:= .F.
        Endif
	EndIf	

Else

	_lRetorno	:= .T.

EndIf

Return(_lRetorno)
