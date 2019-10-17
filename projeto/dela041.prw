#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA041  �Autor  �Anderson Kurtinaitis� Data �  09/08/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � andkurt@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua validacao do campo E4_TIPOVND no Cadastro de Cond.  ���
���          � de Pagamento, verificando se os caracteres informandos     ���
���          � equivalem aos registros da Tabela PAG (Tipos de Venda)     ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �lRet - Resultado da validacao                               ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atravez do X3_VLDUSER do Campo E4_TIPOVND          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Project Function DELA041()

//Variaveis Locais da Funcao
Local _cTipoVnd	:= Alltrim(M->E4_TIPOVND)
Local _cChave	:= ""
Local _lRetorno	:= .T.
Local _i		:= 1

If !Empty(_cTipoVnd) // So faz se campo estiver preenchido
	
	For _i := 1 To Len(_cTipoVnd)
		
		_cChave	:= Substr(_cTipoVnd,_i,1)
		
		// Verifica na Tabela de Tipo de Venda se um dos caracteres informados NAO EXISTE impedindo o preenchimento do campo pelo usuario
		DbSelectArea("PAG")
		DbSetOrder(1)
		If !DbSeek(xFilial("PAG")+_cChave)
			
			MsgAlert(OemtoAnsi("O Tipo de Venda '" + Substr(_cTipoVnd,_i,1) + "' N�O EXISTE no Cadastro de Tipo de Vendas, verifique !"), "Aviso")
			_lRetorno	:= .F.
			
		EndIf
		
	Next
	
Else
	
	MsgAlert(OemtoAnsi("Campo vazio, verifique !"), "Aviso") 
	_lRetorno	:= .F.
	
EndIf

Return(_lRetorno)
