/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA036         �Autor � Paulo Benedet       �Data � 05/07/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Importacao de CEPs                                            ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pelo menu                                      ���
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
Project Function DELA036()

If MsgYesNo(OemtoAnsi("Confirma importa��o do cadastro de CEPs?"), "Pergunta")
	Processa({|| Continua()}, "Importando dados...")
EndIf

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DELA036M        �Autor � Paulo Benedet       �Data � 05/07/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Manutencao CEPs X Enderecos                                   ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pelo menu                                      ���
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
Project Function DELA036M()

axCadastro("PAL", "CEPs X Enderecos", ".T.", ".T.")

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � Continua        �Autor � Paulo Benedet       �Data � 05/07/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Processamento de importacao                                   ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pelo programa DELA036                          ���
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
Static Function Continua()
Local cArq := "\CEPS" + GetDBExtension()	// Nome do arquivo com os dados para importacao
Local nImp := 0								// Numero de registros importados

// Verifica existencia do arquivo
If !File(cArq)
	MsgStop(OemtoAnsi("O arquivo com os CEPs (" + cArq + ") n�o foi encontrado!"), "Aviso")
	Return
EndIf

// Seleciona ordem do arquivo de ceps
dbSelectArea("PAL")
dbSetOrder(1)

// Abre arquivo com os ceps
dbUseArea(.T., __LocalDriver, cArq, "TMPCEP", .T., .F.)
ProcRegua(RecCount())
dbGoTop()

While !EOF()
	IncProc()
	
	// Importa dados
	If !(PAL->(dbSeek(xFilial("PAL") + TMPCEP->CEP8_LOG)))
		RecLock("PAL", .T.)
		PAL_FILIAL := xFilial("PAL")
		PAL_CEP    := TMPCEP->CEP8_LOG
		PAL_ABREV  := TMPCEP->ABREV_TIPO
		PAL_END    := TMPCEP->NOME_LOG
		PAL_MUN    := TMPCEP->NOME_LOCAL
		PAL_EST    := TMPCEP->UF_LOCAL
		PAL_ESTADO := TMPCEP->NOME_UF
		PAL_BAIRRO := TMPCEP->ABREV_BAI
		PAL_COMPLE := TMPCEP->COMPLE_LOG
		msUnlock()
		
		nImp += 1
	EndIf
	
	dbSelectArea("TMPCEP")
	dbSkip()
EndDo

// Mostra numero de registros importados
MsgInfo(OemtoAnsi(AllTrim(Str(nImp)) + " registros importados."), OemtoAnsi("Informa��o"))

// Fecha arquivo de importacao
dbSelectArea("TMPCEP")
dbCloseArea()

Return