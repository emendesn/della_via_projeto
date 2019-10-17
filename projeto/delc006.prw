#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �DELC006   � Autor � Norbert Waage Junior  � Data �28/08/2005���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Fab. Express     �Contato � norbert@microsiga.com.br       ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Rotina de consulta de apolices do cliente, em substituicao ���
���          � a a tela convencional do SXB, pois o filtro executado na   ���
���          � consulta ocasionava grande demora no retorno da informacao.���
�������������������������������������������������������������������������Ĵ��
���Parametros�cCliente - Codigo do Cliente Atual                          ���
���          �cLoja    - Loja do Cliente Atual                            ���
���          �cProduto - Produto da linha Atual                           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �(.F.) se a consulta foi cancelada ou nao encontrou itens;   ���
���          �(.T.) se confirmada                                         ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �F3 da pesquisa de sinistros na Venda Assistida              ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
���              �  /  /  �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Project Function DELC006(cCliente,cLoja,cProduto)

Local aApol	:= {}
Local lRet	:= .F.

Private _oDlg
Private _oLbx

//���������������������������������������Ŀ
//�Faz pesquisa das apolices com query SQL�
//�����������������������������������������
ProcApol(cCliente,cLoja,cProduto,@aApol)	

//������������������������������������������������Ŀ
//�Aborta rotina se n�o foram encontrados registros�
//��������������������������������������������������
If Len(aApol) == 0
	ApMsgAlert("N�o foram encontradas ap�lices para este cliente","Aten��o")
	Return .F.
EndIf

//���������������Ŀ
//�Exibe interface�
//�����������������
DEFINE MSDIALOG _oDlg TITLE "Ap�lices v�lidas para o cliente " +;
	AllTrim( GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+cCliente+cLoja,1,"") );
	FROM C(224),C(241) TO C(521),C(756) PIXEL
	
	//�����������������������������������Ŀ
	//�Cria Componentes Padroes do Sistema�
	//�������������������������������������
	@ C(007),C(007) Say "Selecione uma ap�lice abaixo e confirme" Size C(098),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(131),C(179) Button OemtoAnsi("Confirma") Size C(037),C(012) PIXEL OF _oDlg Action(SetPA8(aApol,@lRet))
	@ C(131),C(219) Button OemtoAnsi("Cancela") Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())

	//�������Ŀ
	//�Listbox�
	//���������
	@ C(16),C(4) LISTBOX _oLbx FIELDS HEADER ;
	"Produto","Ap�lice","Matr�cula","KM Seg.","C�d. Segur.","Item","Item Ref.","Item Orcs.";
	SIZE C(253),C(110) OF _oDlg;                 
	PIXEL ON dblClick(SetPA8(aApol,@lRet))  
		
	//������������������Ŀ
	//�Metodos da ListBox�
	//��������������������
	_oLbx:SetArray(aApol)
	_oLbx:bLine 	:= {|| {aApol[_oLbx:nAt,1],;
						aApol[_oLbx:nAt,2],;
						aApol[_oLbx:nAt,3],;
						aApol[_oLbx:nAt,4],;
						aApol[_oLbx:nAt,5],;
						aApol[_oLbx:nAt,6],;
						aApol[_oLbx:nAt,7],;
						aApol[_oLbx:nAt,8]}}

ACTIVATE MSDIALOG _oDlg CENTERED 

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � SetPA8          �Autor �Norbert Waage Junior �Data � 28/08/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Posiciona a tabela de seguros                                 ���
����������������������������������������������������������������������������͹��
���Parametros� aApol   - Array que contel as apolices do cliente             ���
���          � lRet    - Retorno da funcao a ser tratado                     ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao se apliaca                                                ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao generica                                               ���
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
Static Function SetPA8(aApol,lRet)

//��������������Ŀ
//�Posiciona Area�
//����������������
DbSelectArea("PA8")
DbGoTo(aApol[_oLbx:nAt,9])

//���������������������������������������������Ŀ
//�Finaliza interface e atribui valor de retorno�
//�����������������������������������������������
_oDlg:End()
lRet:= .T.

Return Nil
                
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � ProcApol        �Autor �Norbert Waage Junior �Data � 28/08/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Execucao de query para ambiente TopConnect                    ���
����������������������������������������������������������������������������͹��
���Parametros�cCliente - Codigo do Cliente Atual                             ��� 
���          �cLoja    - Loja do Cliente Atual                               ��� 
���          �cProduto - Produto da linha Atual                              ��� 
���          �aApol    - Array contendo as apolices de cliente               ��� 
����������������������������������������������������������������������������͹��
���Retorno   � Nao se apliaca                                                ���
����������������������������������������������������������������������������͹��
���Aplicacao � Geracao da lista de apolices do cliente                       ���
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
Static Function ProcApol(cCliente,cLoja,cProduto,aApol)

Local aArea		:=	GetArea()
Local nDiasSeg	:=	GetMv("FS_DEL010") * 30	//Quantidade de dias cobertos pela garantia
Local cQuery

//������������������������������������������������������Ŀ
//�A rotina foi desenvolvida exclusivamente para ambiente�
//�TOPCONNECT                                            �
//��������������������������������������������������������
#IFDEF TOP
    
	//������������������������������������������������Ŀ
	//�Encerra area temporaria caso ja estivesse em uso�
	//��������������������������������������������������
	If Select("TMP") != 0
		TMP->(DbCloseArea())
	EndIf
	
	//�������������Ŀ
	//�Monta a query�
	//���������������
	cQuery	:= "SELECT PA8_CPROSG,PA8_APOLIC,PA8_MATRIC,PA8_KMSG,PA8_CODSEG,PA8_ITEM,PA8_ITREF,PA8_ITORCS,R_E_C_N_O_ "
	cQuery	+= " FROM " +RetSqlName("PA8")
	cQuery	+= " WHERE PA8_FILIAL = '" + xFilial("PA8") + "' AND PA8_CODCLI = '" + cCliente + "'"
	cQuery	+= " AND PA8_LOJCLI = '" + cLoja + "' AND PA8_DTSN = '' AND PA8_NFSG != ''"
	cQuery	+= " AND PA8_DTSG > '" + DtoS(dDataBase - nDiasSeg)  + "'"
	//cQuery	+= " AND PA8_CPROSG = '" + cProduto + "'" //Ignorando produtos a partir de 02/09/2005
	cQuery	+= " AND D_E_L_E_T_ != '*'"
	cQuery	+= " ORDER BY PA8_CPROSG,PA8_APOLIC,PA8_CODCLI,PA8_LOJCLI,PA8_ITEM"
	
	//�����������������������������������������Ŀ
	//�Prepara e executa query no banco de dados�
	//�������������������������������������������
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

	//�����������������������������������������������������������Ŀ
	//�Percorre retorno, alimentando o array aApol com os dados da�
	//�apolice                                                    �
	//�������������������������������������������������������������
	DbSelectArea("TMP")
	DbGoTop()

	While !TMP->(Eof())

		AAdd(aApol,;
			{TMP->PA8_CPROSG	,;	//Produto segurado
			TMP->PA8_APOLIC		,;	//Numero da Apolice
			TMP->PA8_MATRIC		,;	//Matricula
			TMP->PA8_KMSG		,;	//Kilometragem do Seguro
			TMP->PA8_CODSEG		,;	//Codigo da seguradora
			TMP->PA8_ITEM		,;	//Item da apolice
			TMP->PA8_ITREF		,;	//Item de controle
			TMP->PA8_ITORCS		,;	//Item do orcamento
			TMP->R_E_C_N_O_		})	//Numero do registro
			
		TMP->(DbSkip())

	End
	
	//����������������������������Ŀ
	//�Finaliza ambiente temporario�
	//������������������������������
	TMP->(DbCloseArea())

#ELSE

	ApMsgAlert("Func�o n�o permitida em ambiente sem suporte a banco de dados")

#ENDIF

RestArea(aArea)

Return Nil


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
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
//���������������������������Ŀ                                                 
//�Tratamento para tema "Flat"�                                                 
//�����������������������������                                                 
If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                            
   	nTam *= 0.90                                                               
EndIf                                                                           
Return Int(nTam)                                                                