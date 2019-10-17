#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � DELC007  � Autor � Paulo Benedet         � Data � 16/02/06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Rotina de consulta de placas de veiculos, em substituicao  ���
���          � a a tela convencional do SXB, pois o filtro executado na   ���
���          � consulta ocasionava grande demora no retorno da informacao.���
�������������������������������������������������������������������������Ĵ��
���Parametros� cCliente - Codigo do Cliente                               ���
���          � cLoja    - Loja do Cliente                                 ���
���          � cPlaca   - Placa do Veiculo                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �(.F.) se a consulta foi cancelada ou nao encontrou itens;   ���
���          �(.T.) se confirmada                                         ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �F3 da pesquisa de placas na Venda Assistida (PA7)           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������Ĵ��
���Analista  �  Data  � Bops � Manutencao Efetuada                        ���
�������������������������������������������������������������������������Ĵ��
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELC007(cCliente, cLoja, cPlaca)
Local aLista := {}
Local lRet   := .F.

Private oDlg
Private oLbx

//��������������������Ŀ
//� Pesquisa as placas �
//����������������������
ProcPlaca(cCliente, cLoja, cPlaca, @aLista)

//��������������������������������������������������Ŀ
//� Aborta rotina se n�o foram encontrados registros �
//����������������������������������������������������
If Len(aLista) == 0
	ApMsgAlert("N�o foram encontradas placas para este cliente", "Aten��o")
	Return(.F.)
EndIf

//�����������������Ŀ
//� Exibe interface �
//�������������������
Define msDialog oDlg Title "Placas do cliente " +;
AllTrim(GetAdvFVal("SA1", "A1_NOME", xFilial("SA1") + cCliente + cLoja, 1, ""));
from C(000),C(000) to C(300),C(313) Pixel

//�������������������������������������Ŀ
//� Cria Componentes Padroes do Sistema �
//���������������������������������������
@ C(007),C(007) Say "Selecione uma placa abaixo e confirme" Size C(098),C(008) Color CLR_BLACK Pixel of oDlg
@ C(131),C(079) Button OemtoAnsi("Confirma") Size C(037),C(012) Pixel of oDlg Action(SetPA7(aLista, @lRet))
@ C(131),C(119) Button OemtoAnsi("Cancela") Size C(037),C(012) Pixel of oDlg Action(oDlg:End())

//���������Ŀ
//� Listbox �
//�����������
@ C(16),C(4) Listbox oLbx Fields HEADER "Placa", "Cliente", "Loja";
Size C(153),C(110) of oDlg Pixel on dblClick(SetPA7(aLista, @lRet))

//��������������������Ŀ
//� Metodos da ListBox �
//����������������������
oLbx:SetArray(aLista)
oLbx:bLine := {|| {Transform(aLista[oLbx:nAt][1], "@R AAA-9999"),;
aLista[oLbx:nAt][2],;
aLista[oLbx:nAt][3]}}

Activate msDialog oDlg Centered

Return(lRet)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � SetPA7          �Autor � Paulo Benedet       �Data � 16/02/06 ���
����������������������������������������������������������������������������͹��
���Descricao � Posiciona a tabela de cliente vs veiculo                      ���
����������������������������������������������������������������������������͹��
���Parametros� aLista - Array com o conteudo da pesquisa                     ���
���          � lRet   - Retorno da funcao                                    ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao generica                                               ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                       ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function SetPA7(aLista, lRet)

//����������������Ŀ
//� Posiciona Area �
//������������������
dbSelectArea("PA7")
dbGoTo(aLista[oLbx:nAt][4])

//�����������������������������������������������Ŀ
//� Finaliza interface e atribui valor de retorno �
//�������������������������������������������������
oDlg:End()
lRet:= .T.

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � ProcPlaca       �Autor � Paulo Benedet       �Data � 16/02/06 ���
����������������������������������������������������������������������������͹��
���Descricao � Carrega array para pesquisa do usuario                        ���
����������������������������������������������������������������������������͹��
���Parametros� cCliente - Codigo do Cliente                                  ���
���          � cLoja    - Loja do Cliente                                    ���
���          � cPlaca   - Placa do veiculo                                   ���
���          � aLista   - Conteudo do array de pesquisa                      ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pela rotina DELC007                            ���
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
Static Function ProcPlaca(cCliente, cLoja, cPlaca, aLista)
Local aArea := GetArea() // Salva area corrente
Local cSQL  := "" // String com comando SQL

//��������������������������������������������������������Ŀ
//� A rotina foi desenvolvida exclusivamente para ambiente �
//� TOPCONNECT                                             �
//����������������������������������������������������������
#IFDEF TOP
	
	//���������������Ŀ
	//� Monta a query �
	//�����������������
	cSQL := "select PA7_CODCLI, PA7_LOJA, PA7_PLACA, R_E_C_N_O_ "
	cSQL += "from " + RetSQLName("PA7") + " "
	cSQL += "where D_E_L_E_T_ <> '*' "
	cSQL += "and PA7_PLACA <> '" + Space(TamSX3("PA7_PLACA")[1])  + "' "
	cSQL += "and PA7_ORCTRF = '" + Space(TamSX3("PA7_ORCTRF")[1]) + "' "
	If !Empty(cCliente + cLoja)
		cSQL += "and "
		cSQL += "PA7_CODCLI = '" + cCliente + "' and "
		cSQL += "PA7_LOJA = '" + cLoja + "' "
	EndIf
	cSQL += "order by PA7_PLACA"
	
	//�������������������������������������������Ŀ
	//� Prepara e executa query no banco de dados �
	//���������������������������������������������
	cSQL := ChangeQuery(cSQL)
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cSQL), "TMPPA7", .F., .T.)
	
	//���������������������������������������Ŀ
	//� Percorre retorno, alimentando o array �
	//�����������������������������������������
	While !EOF()
		
		aAdd(aLista,{;
		TMPPA7->PA7_PLACA	,;	//Placa
		TMPPA7->PA7_CODCLI	,;	//Codigo do cliente
		TMPPA7->PA7_LOJA	,;	//Loja do cliente
		TMPPA7->R_E_C_N_O_	})	//Numero do registro
		
		dbSkip()
		
	EndDo
	
	//���������������������������Ŀ
	//� Fecha ambiente temporario �
	//�����������������������������
	dbCloseArea()
	
#ELSE
	
	MsgAlert(OemtoAnsi("Func�o n�o permitida no ambiente off-line!"), "Aviso")
	
#ENDIF

RestArea(aArea)
Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function C(nTam)
Local nHRes	:=	GetScreenRes()[1]	//Resolucao horizontal do monitor

Do Case
Case nHRes == 640	//Resolucao 640x480
	nTam *= 0.8
Case nHRes == 800	//Resolucao 800x600
	nTam *= 1
OtherWise			//Resolucao 1024x768 e acima
	nTam *= 1.28
End Case

//�����������������������������Ŀ
//� Tratamento para tema "Flat" �
//�������������������������������
If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
	nTam *= 0.90
EndIf

Return Int(nTam)                                                                
