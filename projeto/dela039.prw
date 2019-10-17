#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA039   � Autor �Norbert Waage Junior� Data �  05/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina responsavel pelo controle de TES inteligente na roti-���
���          �na de saida de materiais                                    ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada apos a alteracao do cliente ou por gatilhos. ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelA039(lGatilho)

Local aArea			:= GetArea()
Local nNatu 		:= N
Local nPosTES		:= AScan(aHeader,{|x| AllTrim(x[2]) == "D2_TES" })
Local nPosProduto   := AScan(aHeader,{|x| AllTrim(x[2]) == "D2_COD" })
Local nPosTpOp		:= AScan(aHeader,{|x| AllTrim(x[2]) == "D2_TPOPER" })
Local cCliFor 		:= Iif((AllTrim(Upper(cTipo)) $ "N/C/I/P"),"C","F")
Local lAlterou		:= .F.
Local cTpOper
Local nX

Default lGatilho	:= .T.

//�������������������������������������������������������������Ŀ
//�A chamada da rotina ValidTes() retornava erro no array       �
//�aPosicoes, pois os elementos 20 a 22 nao existiam.           �
//�Portanto, reinicio o vetor e chamo a rotina copiada do padrao�
//���������������������������������������������������������������
aposicoes := {}
lj920Pos()


If lGatilho
	
	//��������������������������������������������������Ŀ
	//�Tratamento do gatilho na troca de Tipo de Operacao�
	//����������������������������������������������������

	//Altera Tes
	aCols[N][nPosTes] := U_MaTesVia(2,cTpOper,CA920CLI,cLoja,cCliFor,aCols[N][nPosProduto])

	//Valida TES e faz tratamento dos impostos
	ValidTES(aCols[N][nPosTes])	

Else
	
	//�����������������������������������������������������������Ŀ
	//�Tratamento da alteracao de cliente, trocando todos os tipos�
	//�de operacao                                                �
	//�������������������������������������������������������������
	For nX := 1 to Len(aCols)
	
		N := nX	             
		
		//Somente para linhas preenchidas e validas
		If !Empty(aCols[N][nPosProduto]) .And. !(aTail(aCols[N]))
			
			//Atualiza Tipo da operacao	
			//cTpOper := P_RetTpOp(CA920CLI,cLoja,aCols[N,nPosProduto],cCliFor)
			//aCols[N][nPosTpOp]:= cTpOper
			cTpOper := aCols[N][nPosTpOp]
			
			//Altera TES e trata impostos
			aCols[N][nPosTes] := U_MaTesVia(2,cTpOper,CA920CLI,cLoja,cCliFor,aCols[N][nPosProduto])
			ValidTES(aCols[N][nPosTes])
			
			//Flag de alteracao
			lAlterou := .T.
		
		EndIf
		
	Next nX
	
	//Notificacao do usuario
	If lAlterou
		ApMsgInfo("O TES de cada produto foi recalculado devido � troca de cliente."+;
		" Verifique os novos valores antes de prosseguir.", "TES Inteligente")
	EndIf

EndIF

N := nNatu

RestArea(aArea)

Return .T.            

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELA039A  � Autor �Norbert Waage Junior� Data �  05/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina responsavel pela troca de tes apos a troca de cliente���
���          �na tela de saida de materiais                               ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelas validacoes LinhaOk e TudOk da GetDados ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA039a()

Local lRet := .T.
//�������������������������������������������������������������Ŀ
//�A variavel _c920Cli armazena o codigo do cliente utilizado na�
//�sa�da de materiais                                           �
//���������������������������������������������������������������
Static _c920Cli	:= ""
//��������������������������������������������������������������

If AllTrim(Upper(CA920CLI)) $ AllTrim(Upper(GetMv("FS_DEL032"))) //Parametrizar
	ApMsgAlert("Cliente n�o permitido","Par�metro FS_DEL032")
	lRet := .F.
EndIf

If (_c920Cli != CA920CLI + cLoja) //Troca de cliente
	lRet := .F.
	P_DelA039(.F.)
EndIF

_c920Cli := CA920CLI + cLoja

Return lRet   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �lj920Pos  � Autor � Fabio Rog�rio Pereira � Data � 18/12/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica posicao das colunas.                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SigaLoja                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function lj920Pos()

AADD(aPosicoes,{"D2_PRCVEN"  ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_PRCVEN"})})   //  1
AADD(aPosicoes,{"D2_TOTAL"   ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_TOTAL"})})    //  2
AADD(aPosicoes,{"D2_DESCON"  ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_DESCON"})})   //  3
AADD(aPosicoes,{"D2_DESC"    ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_DESC"})})  //  4
AADD(aPosicoes,{"D2_TES"     ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_TES"})})      //  5
AADD(aPosicoes,{"D2_VALICM"  ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_VALICM"})})   //  6
AADD(aPosicoes,{"D2_VALIPI"  ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_VALIPI"})})   //  7
AADD(aPosicoes,{"D2_VALISS"  ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_VALISS"})})   //  8
AADD(aPosicoes,{"D2_COD"     ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_COD"})})      //  9
AADD(aPosicoes,{"D2_QUANT"   ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_QUANT"})})    // 10
AADD(aPosicoes,{"D2_BASEICM" ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_BASEICM"})})  // 11
AADD(aPosicoes,{"D2_LOCAL"   ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_LOCAL"})})   // 12
AADD(aPosicoes,{"D2_UM"      ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_UM"})})      // 13
AADD(aPosicoes,{"D2_CF"      ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_CF"})})      // 14
AADD(aPosicoes,{"D2_PRUNIT"  ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_PRUNIT"})})  // 15
AADD(aPosicoes,{"D2_PICM"    ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_PICM"})})    // 16
AADD(aPosicoes,{"D2_CLASFIS" ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_CLASFIS"})}) // 17
AADD(aPosicoes,{"D2_BRICMS"  ,aScan(aHeader, {|x| rTrim(x[2]) == "D2_BRICMS"})})  // 18
AADD(aPosicoes,{"D2_ICMSRET" ,aScan(aHeader, {|x| rTrim(x[2]) == "D2_ICMSRET"})}) // 19
AADD(aPosicoes,{"D2_NFORI"   ,Ascan(aHeader, {|x| rTrim(x[2]) == "D2_NFORI"})})   // 20			//Adiciona campos da NF Original no aPosicoes
AADD(aPosicoes,{"D2_SERIORI" ,aScan(aHeader, {|x| rTrim(x[2]) == "D2_SERIORI"})}) // 21
AADD(aPosicoes,{"D2_ITEMORI" ,aScan(aHeader, {|x| rTrim(x[2]) == "D2_ITEMORI"})}) // 22

Return( Nil )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ValidTes � Autor � F�bio Rog�rio Pereira � Data � 18/12/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gatilhos do Campo de TES (D2_TES)                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidTes(cValor) 

Local nPCf		:= aPosicoes[14][2]
Local nVlrItem	:= aPosicoes[2][2]
Local nPQtd		:= aPosicoes[10][2]
Local nPVrUnit	:= aPosicoes[1][2]
Local nPNfOri	:= aPosicoes[20][2]			//Posicao do numero da NF de Origem
Local nPSerieOri:= aPosicoes[21][2]			//Posicao da serie da NF de Origem
Local nPItemOri	:= aPosicoes[22][2]			//Posicao do item da NF de Origem
Local nPCodPrd	:= aPosicoes[09][2]			//Posicao do produto da NF de Origem

//Nao eh necessario o recalculo de valores para o tipo de Complemento de ICMS
If cTipo == "I"
	Return .T.
EndIf

DbSelectarea("SF4")
DbSetorder(1)
If DbSeek(xFilial("SF4")+cValor)
	aCols[n][nPCf] 	 :=SF4->F4_CF
	aCols[n][nVlrItem] :=(aCols[n][nPQtd]*aCols[n][nPVrUnit])

	//����������������������������������������������Ŀ
	//�Chama a funcao para posicionar na NF de Origem�
	//������������������������������������������������	
	If !Empty( aCols[n][nPNfOri] )
		nRecOri := Lj920RecOri( aCols[n][nPNfOri],aCols[n][nPSerieOri],aCols[n][nPItemOri], aCols[n][nPCodPrd] )
	Else 
		nRecOri := 0	
	Endif

	A100_IniCF(cValor)
	Lj920Ipi(,,,,,n)
	Lj920Iss(n)
	Lj920Icms(n)
	
Endif
oGet:Refresh()
Return .T.