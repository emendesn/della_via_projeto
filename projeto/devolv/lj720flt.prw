/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � LJ720FLT �Autor  � Microsiga                � Data � 13/08/08 ���
����������������������������������������������������������������������������͹��
���Descricao � Filtrar as notas que podem ser devolvidas                     ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � cRet - String com a expressao do filtro                       ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada do programa de trocas/devolucoes LOJA720     ���
����������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                               ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function LJ720FLT()
Local dDatDe  := ParamIxb[1] // Data de recebida no parametro
Local dDatAte := ParamIxb[2] // Data ate recebida no parametro
Local cCodCli := ParamIxb[3] // Codigo do cliente recebido no parametro
Local cLojCli := ParamIxb[4] // Loja do cliente recebida no parametro
Local cRet := "" // Retorno do ponto de entrada

// Monta string com o filtro do indregua
cRet := ".AND. D2_CLIENTE == '" + cCodCli + "'"
cRet += ".AND. D2_LOJA == '" + cLojCli + "'"
cRet += ".AND. DtoS(D2_EMISSAO) >= '" + DtoS(dDatDe) + "'"
cRet += ".AND. DtoS(D2_EMISSAO) <= '" + DtoS(dDatAte) + "'"
cRet += ".AND. !(RetField('SB1', 1, xFilial('SB1') + SD2->D2_COD, 'B1_GRTRIB') $ '" + GetMV("MV_GRTRIBV") + "')"

Return(cRet)
