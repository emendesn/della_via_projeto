#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TMKVLDE4 �Autor  �Anderson Kurtinaitis� Data �  10/08/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � andkurt@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada que estara verificando se a condicao de   ���
���          � Pagamento informada via Botao de Pagamento pode ser usada  ���
���          � e eh compativel com o Tipo de Venda informando.            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Verificar se Tipo de Venda e Condicao de Pagto. estao OK   ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TMKVLDE4(nOpc,cCodPagto)
Local aArea     := GetArea()
Local aAreaSE4  := SE4->(GetArea())
Local _lRetorno	:= .T.

If nOpc == 3 .or. nOPc == 4
	
	If Empty(M->UA_TIPOVND)
		
		If !lTk271Auto
			MsgAlert(OemtoAnsi("O Campo TIPO DE VENDA esta vazio, verifique !"), "Aviso")
		EndIf
		_lRetorno	:= .F.
		
	Else
		
		DbSelectArea("SE4")
		DbSetOrder(1)
		If DbSeek(xFilial("SE4") + cCodPagto)
			
			// Verificando se o campo E4_TIPOVND eh compativel com o Tipo de Venda em questao
			IF !(Alltrim(M->UA_TIPOVND) $ Alltrim(SE4->E4_TIPOVND))
				
				If !lTk271Auto
					MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O se enquadra no Tipo de Venda informado, verifique !"), "Aviso")
				EndIf
				_lRetorno	:= .F.
				
			EndIf
			
		Else // Nao achou condicao digitada
			
			If !lTk271Auto
				MsgAlert(OemtoAnsi("A Condi��o de pagamento informada N�O existe, verifique !"), "Aviso")
			EndIf
			_lRetorno	:= .F.
			
		EndIf
		
	EndIf
	
EndIf

RestArea(aAreaSE4)
RestArea(aArea)

Return(_lRetorno)
