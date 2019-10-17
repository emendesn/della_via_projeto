#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2520E   �Autor  �Marcelo Alcantara   � Data �  14/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para tratar a exclusao de Nota da Distrib.���
���          � Mercadoria para apagar o arquivo magnetico gerado.         ���
�������������������������������������������������������������������������͹��
���Parametros�  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Retorno   �  Nao se aplica                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado Antes da exclusao da nota fiscal���
���          � entrada (MATA521).                                         ���
���          � Posicionado no registro do SF2.                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                          	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SF2520E
Local _aArea		:= GetArea()
Local _cDirGrv   	:= AllTrim(GetNewPar("MV_LJDIRGR",GetClientDir()))  	// Diretorio onde serao armazenados os arquivos magneticos
Local _cFilial		:= cFilAnt
Local _cFile		:= ""

If SF2->F2_CLIENTE <> "15LQFY"				//Se Nao for Della Via nao faz nada
	RestArea(_aArea)
	Return
EndIf

_cFile	:= _cFilial+F2_LOJA+F2_DOC+".NFT"	//Arquivo de Transferencia

If File(_cDirGrv + _cFile)					//Se o Arquivo existir Apaga o arquivo
	If fErase(_cDirGrv + _cFile) < 0 
		MsgBox(" Nao foi possivel excluir o arquivo " + _cDirGrv + _cFile)
	Endif	
EndIf

RestArea(_aArea)
Return


