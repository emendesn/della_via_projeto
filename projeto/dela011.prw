#Include "TopConn.ch"
#Include "Protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DELA011   �Autor  �Paulo Benedet          � Data �  03/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao �AxCadastro para manutencao do cadastro de seguradoras          ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo menu SIGALOJA.XNU especifico.             ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA011()

axCadastro("PA9", "Seguradoras", ".T.", ".T.")

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �D11PESQ   �Autor  �Paulo Benedet          � Data �  10/05/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Tela de pesquisa cliente x veiculo                             ���
����������������������������������������������������������������������������͹��
���Parametros�cCodCli - Codigo do cliente                                    ���
���          �cLoja   - Loja do cliente                                      ���
����������������������������������������������������������������������������͹��
���Retorno   �cRet    - Placa do veiculo do cliente                          ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina utilizada para retornar a placa de acordo com o cliente.���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function D11Pesq(cCodCli, cLoja)  

Local aEstIni := GetArea()
Local aEstPA0 := PA0->(GetArea())
Local aEstPA1 := PA1->(GetArea())
Local aEstPA7 := PA7->(GetArea())  
Local cCliPad := Padr(GetMv("MV_CLIPAD"),TamSx3("A1_COD")[1])
#IFDEF TOP
	Local cPA0 := RetSQLName("PA0")
	Local cPA1 := RetSQLName("PA1")
	Local cPA7 := RetSQLName("PA7")
#ENDIF
Local cSQL := ""
Local aDados := {}
Local aCompl := {}
Local nOpc := 0
Local cRet := ""
Local cPlaca := ""
Local oDlg, oLbx, oButConf, oButCanc

//��������������Ŀ
//�Monta consulta�
//����������������
#IFDEF TOP
	cSQL := "SELECT PA7_PLACA, PA0_DESC, PA1_DESC, PA7_ANO, PA7_OBSERV, PA7_CODMAR, PA7_CODMOD "
	cSQL += "FROM " + cPA7 + " "
	cSQL += "INNER JOIN " + cPA0 + " ON PA7_CODMAR = PA0_COD "
	cSQL += "INNER JOIN " + cPA1 + " ON PA7_CODMOD = PA1_COD "
	cSQL += "WHERE "
	cSQL += cPA7 + ".D_E_L_E_T_ <> '*' AND "
	cSQL += cPA0 + ".D_E_L_E_T_ <> '*' AND "
	cSQL += cPA1 + ".D_E_L_E_T_ <> '*' AND "
	cSQL += "PA7_FILIAL = '" + xFilial("PA7") + "' AND "
	cSQL += "PA0_FILIAL = '" + xFilial("PA0") + "' AND "
	cSQL += "PA1_FILIAL = '" + xFilial("PA1") + "' AND "
	cSQL += "PA7_CODCLI = '" + cCodCli + "' AND "
	cSQL += "PA7_LOJA = '" + cLoja + "' AND "
	cSQL += "PA7_ORCTRF = '" + Space(TamSX3("PA7_ORCTRF")[1]) + "' "
	cSQL += "ORDER BY PA7_PLACA"
	
	cSQL := ChangeQuery(cSQL)
	msAguarde({|| dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "PA7TMP", .F., .T.)}, "Selecionando registros...")

	//����������������Ŀ
	//�Carrega list box�
	//������������������
	dbSelectArea("PA7TMP")
	dbGoTop()
	
	While !EOF()
		aAdd(aDados, {PA7TMP->PA7_PLACA, PA7TMP->PA0_DESC, PA7TMP->PA1_DESC, PA7TMP->PA7_ANO, PA7TMP->PA7_OBSERV})
		aAdd(aCompl, {PA7TMP->PA7_CODMAR, PA7TMP->PA7_CODMOD})
		dbSkip()
	EndDo

	//�������������Ŀ
	//�Fecha arquivo�
	//���������������
	dbSelectArea("PA7TMP")
	dbCloseArea()
#ELSE
	dbSelectArea("PA7")
	dbSetOrder(1)
	dbSeek(xFilial("PA7") + cCodCli + cLoja)
	
	While !EOF();
		.And. PA7_FILIAL == xFilial("PA7");
		.And. PA7_CODCLI == cCodCli;
		.And. PA7_LOJA == cLoja
		
		If !Empty(PA7->PA7_ORCTRF)
			dbSelectArea("PA7")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("PA0")
		dbSetOrder(1)
		dbSeek(xFilial("PA0") + PA7->PA7_CODMAR)
		
		dbSelectArea("PA1")
		dbSetOrder(1)
		dbSeek(xFilial("PA1") + PA7->PA7_CODMOD)
		
		aAdd(aDados, {PA7->PA7_PLACA, PA0->PA0_DESC, PA1->PA1_DESC, PA7->PA7_ANO, PA7->PA7_OBSERV})
		aAdd(aCompl, {PA7->PA7_CODMAR, PA7->PA7_CODMOD})
		
		dbSelectArea("PA7")
		dbSkip()
	EndDo
#ENDIF

//��������������Ŀ
//�Verifica dados�
//����������������
If Len(aDados) == 0
	
	//�������������������������������������������������Ŀ
	//�OBS: Nao mostra mensagem caso seja Cliente Padrao�
	//���������������������������������������������������
	If cCodCli <> cCliPad
		MsgAlert("Nao existem veiculos para este cliente!", "Aviso")
	Else
	
		//���������������������������������������Ŀ
		//�Codigo para limpar os campos do veiculo�
		//�����������������������������������������
		M->LQ_CODMAR  := Space(TamSx3("LQ_CODMAR")[1])
		M->LQ_DSCMAR  := Space(TamSx3("LQ_DSCMAR")[1])
		M->LQ_CODMOD  := Space(TamSx3("LQ_CODMOD")[1])
		M->LQ_DSCMOD  := Space(TamSx3("LQ_DSCMOD")[1])
		M->LQ_ANO     := Space(TamSx3("LQ_ANO")[1])
		M->LQ_OBSVEIC := Space(TamSx3("LQ_OBSVEIC")[1])
		cPlaca        := Space(TamSx3("LQ_PLACAV")[1])
	Endif
	
	//���������������������������������������Ŀ
	//�Codigo para limpar os campos do veiculo�
	//�����������������������������������������
	M->LQ_CODMAR  := IIf(Empty(M->LQ_CODMAR) , Space(TamSx3("LQ_CODMAR")[1]) , M->LQ_CODMAR )
	M->LQ_DSCMAR  := IIf(Empty(M->LQ_DSCMAR) , Space(TamSx3("LQ_DSCMAR")[1]) , M->LQ_DSCMAR )
	M->LQ_CODMOD  := IIf(Empty(M->LQ_CODMOD) , Space(TamSx3("LQ_CODMOD")[1]) , M->LQ_CODMOD )
	M->LQ_DSCMOD  := IIf(Empty(M->LQ_DSCMOD) , Space(TamSx3("LQ_DSCMOD")[1]) , M->LQ_DSCMOD )
	M->LQ_ANO     := IIf(Empty(M->LQ_ANO)    , Space(TamSx3("LQ_ANO")[1])    , M->LQ_ANO    )
	M->LQ_OBSVEIC := IIf(Empty(M->LQ_OBSVEIC), Space(TamSx3("LQ_OBSVEIC")[1]), M->LQ_OBSVEIC)
	cPlaca        := IIf(Empty(M->LQ_PLACAV) , Space(TamSx3("LQ_PLACAV")[1]) , M->LQ_PLACAV )

	RestArea(aEstPA0)
	RestArea(aEstPA1)
	RestArea(aEstPA7)
	RestArea(aEstIni)
	Return(cPlaca)
EndIf

//�������������Ŀ
//�Monta dialogo�
//���������������
Define msDialog oDlg Title "Cliente X Veiculos" From 65,0 to 234,518 of oMainWnd Pixel

@ 2,2 ListBox oLbx Fields Header "Placa", "Marca", "Modelo", "Ano", "Observacao" Size 215,79 of oDlg Pixel

oLbx:SetArray(aDados)
oLbx:bLine := {|| {aDados[oLbx:nAt][1], aDados[oLbx:nAt][2], aDados[oLbx:nAt][3], aDados[oLbx:nAt][4], aDados[oLbx:nAt][5]}}

@ 04,221 Button oButConf Prompt "Confirma" Size 36,16 of oDlg Pixel Action (nOpc := oLbx:nAt, oDlg:End())
@ 25,221 Button oButCanc Prompt "Cancela" Size 36,16 of oDlg Pixel Action oDlg:End()

oButConf:SetFocus()

Activate Dialog oDlg Centered

//��������������Ŀ
//�Trata resposta�
//����������������
If nOpc > 0
	cRet := aDados[nOpc][1]
	M->LQ_CODMAR  := aCompl[nOpc][1]
	M->LQ_DSCMAR  := aDados[nOpc][2]
	M->LQ_CODMOD  := aCompl[nOpc][2]
	M->LQ_DSCMOD  := aDados[nOpc][3]
	M->LQ_ANO     := aDados[nOpc][4]
	M->LQ_OBSVEIC := aDados[nOpc][5]
Else
	cRet := M->LQ_PLACAV
EndIf

//����������������Ŀ
//�Devolve ambiente�
//������������������
RestArea(aEstPA0)
RestArea(aEstPA1)
RestArea(aEstPA7)
RestArea(aEstIni)

Return(cRet)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �D11VldPlaca�Autor  �Paulo Benedet         � Data �  05/10/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Validacao da placa informada                                   ���
����������������������������������������������������������������������������͹��
���Parametros�cPlaca - Placa do veiculo                                      ���
����������������������������������������������������������������������������͹��
���Retorno   �cRet   - Placa do veiculo do cliente                           ���
����������������������������������������������������������������������������͹��
���Aplicacao �Valida se a placa informada eh valida e pertence ao cliente    ���
���          �correto.                                                       ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function D11VldPlaca(cPlaca)
Local aEstIni := GetArea()
Local aEstSA1 := SA1->(GetArea())
Local lConf  := .F.
Local lAchou := .F.

dbSelectArea("PA7")
dbSetOrder(2)
dbSeek(xFilial("PA7") + cPlaca)

While !EOF();
	.And. PA7_FILIAL == xFilial("PA7");
	.And. PA7_PLACA == cPlaca

	//����������������������������Ŀ
	//�Desconsidera placa em branco�
	//������������������������������
	If Empty(PA7_PLACA)
		dbSkip()
		Loop
	EndIf
	
	//��������������������������������������Ŀ
	//�Desconsidera placa transferida de dono�
	//����������������������������������������
	If !Empty(PA7_ORCTRF)
		dbSkip()
		Loop
	EndIf
	
	lAchou := .T.
	Exit
EndDo

If lAchou	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1") + PA7->(PA7_CODCLI + PA7_LOJA))
	
	If Aviso("A T E N � � O","Confirma o cliente '" + rTrim(SA1->A1_NREDUZ)+" Loja:"+SA1->A1_LOJA+Chr(10)+Chr(13)+Rtrim(SA1->A1_NOME)+Chr(10)+Chr(13)+"CNPJ/CPF:"+IIf(SA1->A1_PESSOA=="F",Transform(SA1->A1_CGC,"@R 999.999.999-99"),Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"))+" ?",{"Sim","Nao"}) = 1 
				
		M->LQ_CLIENTE := PA7->PA7_CODCLI
		M->LQ_LOJA    := PA7->PA7_LOJA
		M->LQ_NOMCLI  := SA1->A1_NOME
		lConf := .T.
		
		lj7ValCli()      
		
		//��������������������������������������������Ŀ
		//�Atualiza��o das tabelas do Modulo Financeiro�
		//����������������������������������������������
		// Posiciona arquivo de filiais
		dbSelectArea("SLJ")
		dbSetOrder(3) //LJ_FILIAL+LJ_RPCEMP+LJ_RPCFIL
		If dbSeek(xFilial("SLJ") + cEmpAnt + cFilAnt)
			cBanco := SLJ->LJ_BCO1
		Else
			cBanco := ""
		EndIf
		
		// Verifica banco
		cBanco := IIf(!Empty(M->LQ_BCO1), M->LQ_BCO1, cBanco)
		
	EndIf
	
	//�������������������������Ŀ
	//�Atualiza dados do veiculo�
	//���������������������������
	M->LQ_CODMAR  := PA7->PA7_CODMAR
	M->LQ_DSCMAR  := Posicione("PA0", 1, xFilial("PA0") + PA7->PA7_CODMAR, "PA0_DESC")
	M->LQ_CODMOD  := PA7->PA7_CODMOD
	M->LQ_DSCMOD  := Posicione("PA1", 1, xFilial("PA1") + PA7->PA7_CODMOD, "PA1_DESC")
	M->LQ_ANO     := PA7->PA7_ANO
	M->LQ_OBSVEIC := PA7->PA7_OBSERV
EndIf

If !lConf
	RestArea(aEstSA1)
EndIf
RestArea(aEstIni)

Return(.T.)