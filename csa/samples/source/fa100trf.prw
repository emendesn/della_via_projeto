#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fa100Trf  �Autor  �Andre Veiga         � Data �  23/01/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. na Transferencia da Movimentacao Bancaria              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Registrar a Sangria no ECF e abrir a gaveta.                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Fa100Trf

//���������������������������Ŀ
//�Parametros recebidos       �
//�====================       �
//�[1] Banco Origem           �
//�[2] Agencia Origem         �
//�[3] Conta Origem           �
//�[4] Banco Destino          �
//�[5] Agencia Destino        �
//�[6] Conta Destino          �
//�[7] Tipo Transerencia      �
//�[8] Tipo Documento         �
//�[9] Valor Transferencia    �
//�[10] Historico             �
//�[11] Beneficiario          �
//�[12] Natureza origem       �
//�[13] Natureza Destino      �
//�����������������������������
Local cBcoOrig 	:= ParamIxb[1]
Local cAgenOrig	:= ParamIxb[2]
Local cCtaOrig	:= ParamIxb[3]
Local cBcoDest	:= ParamIxb[4]
Local cAgenDest	:= ParamIxb[5]
Local cCtaDest	:= ParamIxb[6]
Local cTipoTran	:= ParamIxb[7]
Local cDocTran	:= ParamIxb[8]
Local nValorTran:= ParamIxb[9]
Local cHist100	:= ParamIxb[10]
Local cBenef100	:= ParamIxb[11]
Local cNaturOri	:= ParamIxb[12]
Local cNaturDes	:= ParamIxb[13]
Local iRet		:= -1
Local cPortaGav	:= LJGetStation("PORTGAV")
Local ccaixa    := xNumCaixa()

If lFiscal
	If cBcoOrig == cCaixa
		// Faz a sangria
		iRet := IFSupr( nHdlECF, 3, Str(nValorTran,14,2), '', '' )
	ElseIf cBcoDest == cCaixa
		// Faz o troco
		iRet := IFSupr( nHdlECF, 2, Str(nValorTran,14,2), '', '' )
	Endif
Endif

If iRet = 0 
	//����������������������������������������������Ŀ
	//�Verifica se ha gaveta configurada na porta COM�
	//�Caso nao tenha envia o comando pelo ECF       �
	//������������������������������������������������
	If lGaveta
		iRet := GavetaAci( nHdlGaveta, cPortaGav )
	Else
		iRet := IFGaveta( nHdlECF )
	Endif
Endif	

Return .T.