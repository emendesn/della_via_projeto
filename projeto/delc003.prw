#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELC003A �Autor  �Ricardo Mansano     � Data �  10/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Define Campos de pesquisa, levando em conta se a rotina    ���
���          � foi acionada pela Venda Assistida ou Televendas.           ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atraves de um botao na tela de Venda Assistida     ���
���          �    botao este que foi criado a partir do PE. LJ7016.       ���
���          � Chamada atraves de um botao na tela do TeleVendas          ���
���          �    botao este que foi criado a partir do PE. TMKBARLA.     ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                            ���
���Gaspar    �08/07/05�      �Tratamento da chamado do Call Center pela   ���
���          �        �      �funcao TMKUSER2                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELC003A()
Local nPosProduto 	:= 0
Local nPosLocal	 	:= 0
Local cProduto 		:= ""
Local cLocal     	:= ""

// Salva Configuracoes da aCols e aHeader
Local _aCols 		:= aClone(aCols)
Local _aHeader 		:= aClone(aHeader)
Local _n 			:= n


	//����������������������������������������������������������Ŀ
	//� Monta os dados de acordo com o Programa Executado.       � 
	//� TMKA271 --> CallCenter.                                  � 
	//� LOJA701 --> Venda Assistida.                             � 
	//������������������������������������������������������������
	If Alltrim(Upper(FunName())) == "TMKA271" .Or. Alltrim(Upper(FunName())) $ "TMKUSER2" 
		nPosProduto	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "UB_PRODUTO"})
		nPosLocal 	:= aScan(aHeader,{ |x| AllTrim(x[2]) == "UB_LOCAL"  })
	Endif
	If Alltrim(Upper(FunName())) == "LOJA701"
		nPosProduto	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO"})
		nPosLocal 	:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_LOCAL"  })
	Endif

	//���������������������������Ŀ
	//� Carrega dados do Produto. � 
	//�����������������������������
	cProduto := aCols[n,nPosProduto]
		
	//����������������������������������������������������������Ŀ
	//� Executa Chamada da Rotina de Estoque para rodas as Lojas � 
	//������������������������������������������������������������
    If (!Empty(cProduto)) .and. (nPosLocal <> 0)
        If Alltrim(Upper(FunName())) == "TMKA271" .Or. Alltrim(Upper(FunName())) $ "TMKUSER2" 
        	cLocal := aCols[n,nPosLocal]
        Endif
        If Alltrim(Upper(FunName())) == "LOJA701"
        	cLocal := aColsDet[n,nPosLocal]
        Endif
        
	    P_DELC003B(cProduto,cLocal)
	Else
		Aviso("Aten��o !","Preencha o campo de C�digo de Produto "+cProduto+" !!!",{ " << Voltar " },1,"Consulta Estoque")
	Endif


// Restaura Configuracoes da aCols e aHeader
aCols		:= aClone(_aCols)
aHeader		:= aClone(_aHeader)
n			:= _n 

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELC003B �Autor  �Ricardo Mansano     � Data �  10/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta de estoque no Televendas/Venda Assistida          ���
�������������������������������������������������������������������������͹��
���Parametros� cProduto --> Codigo do Produto                             ���
���          � cLocal   --> Armazem                                       ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atraves de um botao na tela de Venda Assistida     ���
���          �    botao este que foi criado a partir do PE. LJ7016.       ���
���          � Chamada atraves de um botao na tela do TeleVendas          ���
���          �    botao este que foi criado a partir do PE. TMKBARLA.     ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELC003B(cProduto,cLocal)
Local oDlg
Local nX			:= 0

Private aCpoGDa		:= { "B1_FILIAL","B1_DESC","B2_QATU","B2_QATU" }	
Private nUsado		:= 0 
Private aHeader 	:= {}
Private aCols   	:= {}

// Carrega aHeader
dbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
for nX := 1 to Len(aCpoGDa)
	If DbSeek(aCpoGDa[nX])
		nUsado++
		Aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO	,;
			SX3->X3_PICTURE	,;
			SX3->X3_TAMANHO	,;
			SX3->X3_DECIMAL	,;
			SX3->X3_VALID	,;
			SX3->X3_USADO	,;
			SX3->X3_TIPO	,;
			SX3->X3_F3 		,;
			SX3->X3_CONTEXT	,;
			SX3->X3_CBOX	,;
			SX3->X3_RELACAO} )
	Endif
Next nX
aHeader[1,1] := "Loja"
aHeader[2,1] := "Nome"
aHeader[3,1] := "Saldo Atual"
aHeader[4,1] := "Dispon�vel"

//������������������������������������������Ŀ
//� Alimenta aCols com Estoques cadastrados  � 
//��������������������������������������������
DelMonta(cProduto,cLocal) 
	
DEFINE MSDIALOG oDlg TITLE "Saldos em Estoque" From 268,168 to 433,776 of oMainWnd PIXEL
	//�������������������������Ŀ
	//� Mostra nome do Produto  � 
	//���������������������������
    @ 001,002 Say Alltrim(cProduto) + " - " + GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+cProduto,1,"Erro")
    @ 001,200 Say "Armazem: " + cLocal
    
	//���������������������������������������������������������������Ŀ
	//� Retorna o valor da aCols para a 1 par evitar erros de Refresh � 
	//�����������������������������������������������������������������
    n := 1
    
	//��������������������������������Ŀ
	//� GetDados com Saldos em Estoque � 
	//����������������������������������
	@ 010,001 TO 083,262 MULTILINE
	@ 010,265 Button OemToAnsi("&Confirmar") Size 36,16 of oDlg Pixel Action oDlg:End()
Activate MsDialog oDlg 

Return(.T.)    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELMONTA  �Autor  �Ricardo Mansano     � Data �  08/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Static Function que monta aCols para visualizacao dos      ���
���          � Estoques em todas as Filiais.                              ���
�������������������������������������������������������������������������͹��
���Parametros� cProduto --> Codigo do Produto                             ���
���          � cLocal   --> Armazem                                       ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DelMonta(cProduto,cLocal)
Local nAtual     		:= 0
Local nDisponivel		:= 0
Local _aArea   			:= {}
Local _aAlias  			:= {}
Local cEmpresaCorrente	:= SM0->M0_CODIGO // Seleciona empresa corrente para levantar Estoque

P_CtrlArea(1,@_aArea,@_aAlias,{"PA5","SM0","SB2"}) // GetArea
                          
	//������������������������������������������������������������Ŀ
	//� Varre todas as Lojas selecionando seus estoque por Armazem � 
	//��������������������������������������������������������������
	aCols := {} // Limpa aCols
	DbSelectArea("SM0")
	SM0->(DbGotop())
	While !SM0->(Eof())
	        
			// Verifica o Saldo em Estoque 
			DbSelectArea("SB2")
			SB2->(DbSetOrder(1)) // B2_FILIAL + B2_COD + B2_LOCAL
			
			//������������������������������������������������������������Ŀ
			//� Filtra o estoque de todas as Filiais da Empresa Corrente   � 
			//��������������������������������������������������������������
			If (SM0->M0_CODIGO==cEmpresaCorrente) .and. (SB2->( DbSeek(SM0->M0_CODFIL+cProduto+cLocal) ))
				// Verifica Estoque Atual e Disponivel
			    nAtual		:= SB2->B2_QATU
			    nDisponivel := P_DCalcEst(SM0->M0_CODFIL,cProduto,cLocal)
			
				//������������������Ŀ
				//� Alimenta a aCols � 
				//��������������������    
				AaDD(aCols,{SM0->M0_CODFIL,SM0->M0_NOME,nAtual,nDisponivel,.F.})
			Endif 
	
	SM0->(DbSkip())
	EndDo

P_CtrlArea(2,_aArea,_aAlias) // RestArea
	
Return Nil