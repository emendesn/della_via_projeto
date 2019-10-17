#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ConsEst  �Autor  �Marcelo Alcantara   � Data �  26/11/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta de estoque no Televendas/Venda Assistida Por meio ���
���          � de digitacao do produto e local                            ���
�������������������������������������������������������������������������͹��
���Parametros� nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   � nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                           	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user Function ConsEst()
Local oDlg
Local nX			:= 0
Local _cFilial		:= Space(2)							//Codigo da Filial
Local cProduto		:= CriaVar("SB2->B2_COD")			//Codigo do produto
Local cLocal		:= CriaVar("SB2->B2_LOCAL")			//Codigo do armazem onde esta o produto
Local oProduto
Local oButton
Local oGrid
Private oDescProd
Private cDescProd	:= Space(20)						// Descricao do produto
Private aCpoGDa		:= { "B1_FILIAL","B1_DESC","B2_QATU","B2_QATU" }	//Campos que irao no aHeaders
Private nUsado		:= 0 
Private aHeader 	:= {}
Private aCols   	:= {}

// Carrega aHeader com valores do SX3
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
//Defini os Titulos
aHeader[1,1] := "Loja"
aHeader[2,1] := "Nome"
aHeader[3,1] := "Saldo Atual"
aHeader[4,1] := "Dispon�vel"

cLocal		:= "01"

DEFINE MSDIALOG oDlg TITLE "Saldos em Estoque" From 200,168 to 455,800 of oDlg PIXEL
	If lastkey() == 27
		oDlg:End()
	Endif
	//�������������������������Ŀ
	//� Monta Tela de Produto   � 
	//���������������������������
    @ 005,005 Say "Produto:"	PIXEL 
    @ 005,193 Say "Local  :"	PIXEL 
    @ 005,230 Say "Filial :"	PIXEL
    @ 003,028 MSGET cProduto F3 "SB1" Picture "@S6" valid VerProd(cProduto) OF oDlg PIXEL
    @ 003,068 MSGET oDescProd var cDescProd Picture "@S20" When .F. Pixel
    @ 003,212 MSGET cLocal 	Picture "@!" OF oDlg PIXEL When .F.
    @ 003,245 MSGET _cFilial F3 "SM0" Picture "@!"  Valid iif(!Empty(_cFilial),iif(ExistCpo("SM0",cEmpAnt + _cFilial),oButton:SetFocus(),.F.),(.T.,oButton:SetFocus())) Of oDlg Pixel
	//���������������������������������������������������������������Ŀ
	//� Retorna o valor da aCols para a 1 par evitar erros de Refresh � 
	//�����������������������������������������������������������������
    n := 1
    
	//��������������������������������Ŀ
	//� GetDados com Saldos em Estoque � 
	//����������������������������������
	@ 020,001 TO 110,315 MULTILINE object oGrid

	@ 002,275 Button OemToAnsi("&Confirma") Size 36,16  Action ( DelMonta(_cFilial,cProduto,cLocal), oDlg:Refresh(), oGrid:Refresh()) Object oButton //of oDlg Pixel
	@ 111,275 Button OemToAnsi("&Sair")	Size 36,16 of oDlg Pixel Action (oDlg:End())
Activate MsDialog oDlg CENTER

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
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���MAlcantara�28/11/05�      �Acrescentado traramento por filial    	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DelMonta(_cFilial,cProduto,cLocal)
Local nAtual     		:= 0
Local nDisponivel		:= 0
Local _aArea   			:= {}
Local _aAlias  			:= {}
Local cEmpresaCorrente	:= SM0->M0_CODIGO // Seleciona empresa corrente para levantar Estoque

If Empty(cProduto) .or. Empty(cLocal)
	Aviso("Erro Produto","Produto e Local nao pode ser em branco",{"OK"})
	Return Nil
EndIF

P_CtrlArea(1,@_aArea,@_aAlias,{"PA5","SM0","SB2"}) // GetArea

	//������������������������������������������������������������Ŀ
	//� Varre todas as Lojas selecionando seus estoque por Armazem � 
	//��������������������������������������������������������������
	aCols := {} // Limpa aCols
	DbSelectArea("SM0")
	SM0->(DbGotop())
	While !SM0->(Eof())
			If !Empty(_cFilial) .AND. SM0->M0_CODFIL <> _cFilial
				SM0->(DbSkip())
				Loop
			Endif
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VerProd  �Autor  �Marcelo Alcantara   � Data �  26/11/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Static Function para verificar se o produto existe e atuali���
���          � zae descricao do produto na tela                           ���
�������������������������������������������������������������������������͹��
���Parametros� nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   � nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Manutencao Efetuada                           	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function VerProd(cProduto)
Local lRet:= .T.

_aArea		:= GetArea()
_aAreaSB1	:= GetArea("SB1")

dbSelectArea("SB1")
dbSetOrder(1)	//B1_FILIAL + B1_COD

If dbSeek(xFilial("SB1") + cProduto)		//Se o Produto existir na tabela SB1 Atualiza descricao 
	lRet:= .T.
	cDescProd:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
    oDescProd:Refresh()	
else
	if !Empty(cProduto)
		Aviso("Erro Produto","Produto nao localizado",{"OK"})	
		lRet:= .F.
	endif
Endif

RestArea( _aArea )
RestArea( _aAreaSB1 )
Return lRet