#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA025A �Autor  �Ricardo Mansano     � Data �  14/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta de estoque no Televendas/Venda Assistida          ���
�������������������������������������������������������������������������͹��
���Parametros� cOrcamento := Numero do Orcamento para pesquisar Reservas  ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atravez de um botao na tela de Venda Assistida     ���
���          � botao este que foi criado a partir do PE. LJ7016.          ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DELA025A(cOrcamento)
Local oDlg
Local nX			:= 0
// Salva Configuracoes da aCols e aHeader
Local _aCols		:= aClone(aCols)
Local _aHeader		:= aClone(aHeader)
Local _n			:= n

Private aCpoGDa		:= {"C0_PRODUTO","B1_DESC","C0_QUANT" }	
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

//������������������������������������������Ŀ
//� Alimenta aCols com Reservas cadastradas  � 
//��������������������������������������������
DelMonta() 
	
DEFINE MSDIALOG oDlg TITLE "Reservas do Or�amento: "+M->LQ_NUM From 268,168 to 433,776 of oMainWnd PIXEL
	//���������������������������������������������������������������Ŀ
	//� Retorna o valor da aCols para a 1 par evitar erros de Refresh � 
	//�����������������������������������������������������������������
    n := 1
    
	//��������������������������������Ŀ
	//� GetDados com Saldos em Estoque � 
	//����������������������������������
	@ 002,001 TO 083,262 MULTILINE
	@ 002,265 Button OemToAnsi("&Fechar") Size 36,16 of oDlg Pixel Action oDlg:End()
Activate MsDialog oDlg 

// Restaura Configuracoes da aCols e aHeader
aCols		:= aClone(_aCols)
aHeader		:= aClone(_aHeader)
n			:= _n
Return(.T.)    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DELMONTA  �Autor  �Ricardo Mansano     � Data �  14/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Static Function que monta aCols para visualizacao das      ���
���          � Reservas do Orcamento aberto.                              ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
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
Static Function DelMonta()
Local cDescr	:= ""
Local _aArea   	:= {}
Local _aAlias  	:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"SB1"}) // GetArea
                          
	//������������������������������������������������������������Ŀ
	//� Varre todas as Reservas do Orcamento aberto no momento.    � 
	//��������������������������������������������������������������
	aCols := {} // Limpa aCols
	DbSelectArea("SC0")
	SC0->(DbSetOrder(3)) // C0_FILIAL+C0_NUMORC+C0_PRODUTO 
	If SC0->(DbSeek(xFilial("SC0")+M->LQ_NUM))
		While !SC0->(Eof()) .and. xFilial("SC0")+M->LQ_NUM==SC0->(C0_FILIAL+C0_NUMORC)
				// Localiza Descricao do Produto
				cDescr := GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+SC0->C0_PRODUTO,1,"Erro")
	
				//������������������Ŀ
				//� Alimenta a aCols � 
				//��������������������
				AaDD(aCols,{SC0->C0_PRODUTO,cDescr,SC0->C0_QUANT,.F.})
		
		SC0->(DbSkip())
		EndDo
	Endif
		
P_CtrlArea(2,_aArea,_aAlias) // RestArea
	
Return Nil