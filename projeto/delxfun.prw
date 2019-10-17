#include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CtrlArea �Autor  �Ricardo Mansano     � Data �  18/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Project Function auxiliar no GetArea e ResArea retornando  ���
���          � o ponteiro nos Aliases descritos na chamada da Funcao.     ���
���          � Exemplo:                                                   ���
���          � Local _aArea  := {} // Array que contera o GetArea         ���
���          � Local _aAlias := {} // Array que contera o                 ���
���          �                     // Alias(), IndexOrd(), Recno()        ���
���          �                                                            ���
���          � // Chama a Funcao como GetArea                             ���
���          � P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         ���
���          �                                                            ���
���          � // Chama a Funcao como RestArea                            ���
���          � P_CtrlArea(2,_aArea,_aAlias)                               ���
�������������������������������������������������������������������������͹��
���Parametros� nTipo   = 1=GetArea / 2=RestArea                           ���
���          � _aArea  = Array passado por referencia que contera GetArea ���
���          � _aAlias = Array passado por referencia que contera         ���
���          �           {Alias(), IndexOrd(), Recno()}                   ���
���          � _aArqs  = Array com Aliases que se deseja Salvar o GetArea ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���Marcio Dom�20/08/06�      �Adicionada funcao VldCupom               	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)
Local _nN

// Tipo 1 = GetArea()
// Tipo 2 = RestArea()
If _nTipo == 1
	//������������������������������   Salvando Area   - Inicio    ������������������������������������
	_aArea   := GetArea()
	For _nN  := 1 To Len(_aArqs)
		dbSelectArea(_aArqs[_nN])
		AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})
	Next
	//������������������������������   Salvando Area  - Fim        ������������������������������������
Else
	//������������������������������   Restaurando Area   - Inicio ������������������������������������
	For _nN := 1 To Len(_aAlias)
		dbSelectArea(_aAlias[_nN,1])
		dbSetOrder(_aAlias[_nN,2])
		dbGoto(_aAlias[_nN,3])
	Next
	RestArea(_aArea)
	//������������������������������   Restaurando Area   - Fim    ������������������������������������
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALVEIC  �Autor  �Carlos R. Abreu Jr  � Data �  24/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao � - Valida relacionamento entre Marca e Modelo do veiculo    ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Retorno   � lTEM = .T. (Aceita a digitacao do modelo)                  ���
���          �        .F. (Nao aceita a digitacao do modelo)              ���
�������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada na validacao de usuario dos campos:       ���
���          �  LQ_CODMOD                                                 ���
���          �                                                            ���
���          � Sintaxe:                                                   ���
���          �  X3_VLDUSER = P_VALVEIC()                                  ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Project Function ValVeic()

//���������������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                          �
//�����������������������������������������������������������������������
Local lTEM := .F.

DbSelectArea("PA1") // CADASTRO DE MODELOS
DbSetOrder(1) //PA1_FILIAL+PA1_COD

if !Empty(M->LQ_CODMOD)
	if DBSeek(xFilial("PA1")+M->LQ_CODMOD)
		if PA1->PA1_CODMAR==M->LQ_CODMAR
			lTEM := .T.
		else
			Aviso("Aten��o !!!","Selecione um veiculo da marca "+Alltrim(M->LQ_DSCMAR)+" !!!",{" << Voltar"},2,"Modelo do Ve�culo !")
		Endif
	else
		Aviso("Aten��o !!!","Nao existe esse veiculo !!!",{" << Voltar"},2,"Modelo do Ve�culo !")
	EndIf
else
	lTEM := .T.
Endif

Return(lTEM)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MargemMedia�Autor �Ricardo Mansano     � Data �  31/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Calcula Valor de Despesa e % Margem Media do produto.      ���
���          � As despesas estao cadastradas na tabela PAD.               ���
�������������������������������������������������������������������������͹��
���Parametros� cProduto   := Codigo do Produto							  ���
���          � cLocal 	  := Armazem									  ���
���          � nQuant	  := Quantidade									  ���
���          � cTipoVenda := L1_TIPOVND	--> A=Atacado ; T=Truck ;         ���
���          �                              V=Varejo  ; R=Rodas ; F=Frota ���
���          � nVlrItem   := Valor do Item (Unitario * Quant)			  ���
���          � cLoja      := Loja da Venda (pode ser Nil)    			  ���
�������������������������������������������������������������������������͹��
���Retorno   � aRet[1] := % Margem Media do produto.                      ���
���          � aRet[2] := Valor total de Despesas do produto              ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
�������������������������������������������������������������������������͹��
���Observacao� A regra para calculo da Margem Bruta �:					  ���
���          � Valor Margem Bruta = (Valor Unit�rio * Qtde) - 			  ���
���          � (Soma das despesas) - (Custo m�dio unit�rio * Qtde)		  ���
���          � 														  	  ���
���          � % Margem Bruta = Valor Margem Bruta						  ���
���          �                  -------------------------  *  100		  ���
���          �                  (Valor Unit�rio * Qtde)					  ���
���          � 															  ���
���          � O % Margem Bruta deve ser arredondado para cima			  ���
���          � 															  ���
���          � Valor total das despesas =								  ���
���          �    Soma(((Valor Unitario*Qtde)*%de cada despesa)/100 )     ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���Benedet   �27/09/05�      �Inclusao de regra de excecao Rini.       	  ���
���M Alcantar�25/11/05�      |Foi alterado a regra de calculo de despesas ���
���          �        �      |de MM para quando fot tipo de produto RODA  ���
���          �        �      |pegar a mesma regra da pasta(1) Acessorios, ���
���          �        �      |conf. solicitacao de Rodrigo e Marcos Paulo ���
���          �        �      |e autorizado por Marcos Dia 25/11/05  	  ���                              
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function MargemMedia(cProduto,cLocal,nQuant,cTipoVenda,nVlrItem,cLoja)
Local aArea    := GetArea()
Local aAreaPAD := PAD->(GetArea())

Local aRet 			:= {}
Local nDespesa 		:= 0
Local nVlrMargem	:= 0
Local nMM     		:= 0
Local nCM1    		:= 0
Local cTipoPrd		:= ""
Local cPasta		:= ""
Local _cLoja		:= iif(cLoja==Nil,SM0->M0_CODFIL,cLoja)

//���������������������������������������������������������������������Ŀ
//� Verifica a Pasta correta do produto na Tabela de Despesas           �
//�����������������������������������������������������������������������
//� cPasta	  := Pasta BM_TIPOPRD --> A=Acessorio --> Pasta 1 			�
//�        	  := Pasta BM_TIPOPRD --> P=Pneu      --> Pasta 2 			�
//�        	  := Pasta BM_TIPOPRD --> S=Servico   --> Pasta 3			�
//�        	  := Pasta BM_TIPOPRD --> R=Roda      --> Pasta 3			�
//�        	  := Pasta BM_TIPOPRD --> R=Roda      --> Pasta 1 (Foi Alte �
//�        	  rado para roda perag regra de acessorio segundo solicita  �
//�        	  citacao de Rodrigo e Marcos Paulo autorizado por Marcos P.�
//����������������������������������������������������������������������� 
cTipoPrd := RetField("SB1", 1, xFilial("SB1") + cProduto, "B1_GRUPO")
cTipoPrd := AllTrim(RetField("SBM", 1, xFilial("SBM") + cTipoPrd, "BM_TIPOPRD"))

//���������������������������Ŀ
//� Verifica regra de excecao �
//�����������������������������
If cEmpAnt == "01"; //Della Via
	.And. cFilAnt == "53"; //Rini
	.And. cTipoVenda == "R"; //Rodas
	.And. cTipoPrd == "R" //Produto tipo roda
	
	// Calcula Despesas
	PAD->(dbSetOrder(1)) //PAD_FILIAL+PAD_LOJDV+DTOS(PAD_DTEMI)+STR(PAD_PASTA,1)+PAD_CODDSP
	If PAD->(dbSeek(xFilial("PAD") + "53"))
		nDespesa := 0
		
		While (xFilial("PAD") + "53") == PAD->(PAD_FILIAL + PAD_LOJDV)
			If ("1" == Str(PAD->PAD_PASTA, 1)) .And. (dDataBase <= PAD->PAD_DTVAL) // Pasta 1
				// Verifica se despesa eh ICMS
				If Tabela("P0", PAD->PAD_CODDSP) $ "ICMS"
					If FunName() == "LOJA701" //Venda Assistida
						nDespesa += aColsDet[n][aScan(aHeaderDet, {|x| rTrim(x[2]) == "LR_VALICM"})]
					ElseIf FunName() == "TMKA271" //Call Center
						nDespesa += maFisRet(n, "IT_VALICM")
					EndIf
				Else
					nDespesa += (( nVlrItem * PAD->PAD_PATC ) / 100) + PAD->PAD_VLR
				EndIf
			EndIf
			
			PAD->(dbSkip())
		EndDo
	EndIf
	
	nDespesa += GetMV("FS_DEL046") * nQuant
	
Else
	
	// A=ACESSORIO, P=PNEU, S=SERVICO, R=RODA(Pega mesma Regra de Servico)
	// Alterado R=RODA para assumir a mesma reda de Acessorio
	cPasta := IIf(cTipoPrd == "A" .or. cTipoPrd == "R" , "1", IIf(cTipoPrd == "P", "2", "3"))

	// Calcula Despesas
	PAD->(DbSetOrder(1)) //PAD_FILIAL+PAD_LOJDV+DTOS(PAD_DTEMI)+STR(PAD_PASTA,1)+PAD_CODDSP
	If PAD->(DbSeek(xFilial("PAD")+_cLoja))
		nDespesa := 0
		While (xFilial("PAD")+_cLoja)==PAD->(PAD_FILIAL+PAD_LOJDV)
			If (cPasta==Str(PAD->PAD_PASTA,1)).and.(dDataBase<=PAD->PAD_DTVAL)
				//A=Atacado(PAD_PATC);T=Truck(PAD_PTRK);V=Varejo(PAD_PVRJ);R=Rodas(PAD_PATC);F=Frota(PAD_PATC)
				If  cTipoVenda $ "ARF"
					nDespesa += (( nVlrItem * PAD->PAD_PATC ) /100) + PAD->PAD_VLR
				Endif
				If cTipoVenda == "T"
					nDespesa += (( nVlrItem * PAD->PAD_PTRK ) /100) + PAD->PAD_VLR
				Endif
				If cTipoVenda == "V"
					nDespesa += (( nVlrItem * PAD->PAD_PVRJ ) /100) + PAD->PAD_VLR
				Endif
			Endif
			PAD->(DbSkip())
		EndDo
	Endif
	
EndIf

// Busca o Custo Medio
nCM1 := GetAdvFVal("SB2","B2_CM1",xFilial("SB2")+cProduto+cLocal,1,"Erro")

// Valor Margem
nVlrMargem	:= (nVlrItem - nDespesa) - ( nCM1 * nQuant )
// Perc Margem Arredondado
nMM :=  Round( (nVlrMargem / nVlrItem) * 100 ,2)

// Alimenta Retorno
AADD(aRet,nMM)
AADD(aRet,nDespesa)

RestArea(aAreaPAD)
RestArea(aArea)

Return(aRet)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � FiltMod  �Autor  �Paulo Benedet          � Data �  06/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Faz o filtro da consulta padrao marca x modelo                ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. - Item vai para consulta                           ���
���Retorno   �        .F. - Item nao vai para consulta                       ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada no item 6 do SXB da consulta FS7             ���
���          � Eg. P_FiltMod                                                 ���
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
Project Function FiltMod()
Local lRet := .T.

If FunName() == "P_DELA009"
	lRet := PA1->PA1_CODMAR == M->PA7_CODMAR
ElseIf FunName() == "P_DELA021"
	lRet := PA1->PA1_CODMAR == M->PA4_CODMAR
EndIf

Return(lRet)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �ApagaReser�Autor  �Paulo Benedet          � Data �  06/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Apaga reservas do orcamento sigaloja.                         ���
����������������������������������������������������������������������������͹��
���Parametros� cLojSL1 - Codigo da loja                                      ���
���          � cNumSL1 - Numero do orcamento sigaloja                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada no ponto de entrada TMKVDC.                  ���
���          � Eg. P_ApagaReser(SL1->L1_FILIAL, SL1->L1_NUM)                 ���
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
Project Function ApagaReser(cLojSL1, cNumSL1)
Local aAreaIni := GetArea()
Local aAreaSB2 := SB2->(GetArea())
Local aAreaSC0 := SC0->(GetArea())
Local aAreaSL1 := SL1->(GetArea())

// Posiciona arquivos
dbSelectArea("SB2")
dbSetOrder(1) // Filial + Codigo + Local

dbSelectArea("SC0")
dbSetOrder(3) // C0_FILIAL + C0_NUMORC + C0_PRODUTO
dbSeek(cLojSL1 + cNumSL1)

While !EOF();
	.And. C0_FILIAL == cLojSL1;
	.And. C0_NUMORC == cNumSL1
	
	//Estorna Reservas em SB2
	If SB2->(dbSeek(cLojSL1 + SC0->C0_PRODUTO + SC0->C0_LOCAL))
		RecLock("SB2", .F.)
		SB2->B2_RESERVA -= SC0->C0_QTDPED
		msUnlock()
	EndIf
	
	//Deleta Reserva em SC0
	RecLock("SC0", .F., .T.)
	dbDelete()
	msUnlock()
	
	dbSelectArea("SC0")
	dbSkip()
EndDo

// Apaga indicador de reserva no SL1
dbSelectArea("SL1")
dbSetOrder(1) // L1_FILIAL + L1_NUM
If dbSeek(cLojSL1 + cNumSL1)
	RecLock("SL1", .F.)
	SL1->L1_RESERVA := "" // Campo padrao utilizado na regra que define as cores do mBrowse (LOJA701)
	msUnlock()
EndIf

// Restaura ambiente
RestArea(aAreaSB2)
RestArea(aAreaSC0)
RestArea(aAreaSL1)
RestArea(aAreaIni)

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � AtualMM    �Autor  �Carlos R. Abreu      � Data �  07/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Atualizar margem media na Venda Assistida                     ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � nRet - Valor da margem media                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada pelos gatilhos: LR_DESC, LR_VALDESC          ���
���          � Eg: Dominio : LR_PRODUTO                                      ���
���          �     Cont Dom: LR_MM                                           ���
���          �     Tipo    : Primario                                        ���
���          �     Regra   : P_AtualMM()                                     ���
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
Project Function AtualMM()
Local aAreaIni := GetArea()
Local cTipoPrd := ""
//Local cPasta := ""
Local nRet := 0
Local aMM := {}
Local npProduto := aScan(aHeader, {|x| rTrim(x[2]) == "LR_PRODUTO"})
Local npLocal   := aScan(aHeaderDet, {|x| rTrim(x[2]) == "LR_LOCAL"})
Local npQuant   := aScan(aHeader, {|x| rTrim(x[2]) == "LR_QUANT"})
Local npVlrItem := aScan(aHeader, {|x| rTrim(x[2]) == "LR_VLRITEM"})
Local nPosMM	:= aScan(aHeader, {|x| AllTrim(x[2]) == "LR_MM"})

/*
// cPasta := 1=Acessorio / 2=Pneus / 3=Servicos
cTipoPrd := RetField("SB1", 1, xFilial("SB1") + aCols[n][npProduto], "B1_GRUPO")
cTipoPrd := AllTrim(RetField("SBM", 1, xFilial("SBM") + cTipoPrd, "BM_TIPOPRD"))
// A=ACESSORIO, P=PNEU, S=SERVICO, R=RODA(Pega mesma Regra de Servico)
cPasta := IIf(cTipoPrd == "A", "1", IIf(cTipoPrd == "P", "2", "3"))
*/

If nPosMM > 0
	// Executa funcao que Retornara Margem Media e Valor de Despesa do Orcamento
	aMM := P_MargemMedia(aCols[n,npProduto], aColsDet[n,npLocal],aCols[n,npQuant],M->LQ_TIPOVND,aCols[n,npVlrItem], M->LQ_LOJA)

	// Move margem media
	nRet := aMM[1]
EndIf

RestArea(aAreaIni)
Return(nRet)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �NCCSEPU   �Autor  �Marcelo Gaspar         � Data �  11/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Gerna Titulo de NCC para SEPU.                                ���
����������������������������������������������������������������������������͹��
���Parametros� _nFuncao  -> 3 = Inclusao                                     ���
���          �              4 = Alteracao                                    ���
���          � _cFilial  -> Filial                                           ���
���          � _cNumTit  -> No do Titulo                                     ���
���          � _cPref    -> Prefixo do Titulo                                ���
���          � _cTipoTit -> Tipo do Titulo                                   ���
���          � _nVlrSEPU -> Valor do Titulo                                  ���
����������������������������������������������������������������������������͹��
���Retorno   � lmsErroAuto -> .T. = Gerou o Titulo                           ���
���          � lmsErroAuto -> .F. = Nao Gerou o Titulo                       ���
����������������������������������������������������������������������������͹��
���Aplicacao �                                                               ���
���          �                                                               ���
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
Project Function NCCSEPU(_nFuncao,_cFilial,_cNumTit,_cPref,_cTipoTit,_nVlrSEPU)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local   aVetor    		:= {}        // Dad`os do Execauto
Local   _dDtVenc    	:= dDataBase // Data de Vencimento do Titulo
Local   _cFilAnt        := cFilAnt   // Salva conteudo da variavel padrao do sistema
Local   _lOK            := .T.
Local	cQuery			:= ""		// Query para reserva de numero no SE1
Local	cE1Num			:= ""		// Proximo numero disponivel no SE1

Private lmsErroAuto		:= .F.       // Variavel obrigatoria para uso do Execauto

//���������������������������������������������������������������������Ŀ
//� Troco o conteudo de cFilAnt para a filial corrente do titulo, por   �
//� causa da consistencia feita no FINA040 								�
//�����������������������������������������������������������������������
cFilAnt := IIf(Empty(_cFilial), cFilAnt, _cFilial)

If _nFuncao == 3	//Inclusao
	//����������������������������������������������Ŀ
	//�Reserva o proximo codigo livre para a insercao�
	//�de NCC's com o prefixo 'SEP'.                 �
	//������������������������������������������������
	cQuery	:= "SELECT MAX(E1_NUM) E1_NUM " + CRLF
	cQuery	+= "FROM " + RetSqlName("SE1") + " " + CRLF
	cQuery	+= "WHERE D_E_L_E_T_ = '' AND E1_PREFIXO = 'SEP' AND E1_NUM >= 'A00001' " + CRLF
	
	cQuery	:= ChangeQuery(cQuery)
	dbUseArea(.T., "TopConn", TCGenQry(NIL, NIL, cQuery), "TRB", .F., .F.)
	        
	If !Empty(TRB->E1_NUM)
		cE1Num	:= Soma1(TRB->E1_NUM)
	Else
		cE1Num := "A00001"
	EndIf
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf

	While !MayIUseCode(RetSqlName("SE1") + cE1Num)
		cE1Num := Soma1(cE1Num)
	End
	aAdd(aVetor, {"E1_NUM"    , cE1Num	                    , Nil})
EndIf

//���IMPORTANTE��������������������������������������������������������Ŀ
//� Na chamada desta funcao tem que estar posicionado no PA4            �
//�����������������������������������������������������������������������

// Monta array com as informacoes do titulo
aAdd(aVetor, {"E1_FILIAL" , _cFilial                    , Nil})
aAdd(aVetor, {"E1_PREFIXO", _cPref                      , Nil}) //"#"})
//aAdd(aVetor, {"E1_NUM"    , _cNumTit                  , Nil}) //"#"})
aAdd(aVetor, {"E1_PARCELA", AllTrim(GetMv("MV_1DUP"))   , Nil}) //"#"})
aAdd(aVetor, {"E1_TIPO"   , _cTipoTit                 	, Nil}) //"#"})
aAdd(aVetor, {"E1_NATUREZ", GetMV("FS_DEL015")       	, Nil})
aAdd(aVetor, {"E1_CLIENTE", PA4->PA4_CODCLI           	, Nil})
aAdd(aVetor, {"E1_LOJA"   , PA4->PA4_LOJA             	, Nil})
aAdd(aVetor, {"E1_NOMCLI" , PA4->PA4_NOMCLI				, Nil})
aAdd(aVetor, {"E1_EMISSAO", _dDtVenc					, Nil})
aAdd(aVetor, {"E1_VENCTO" , _dDtVenc    				, Nil})
aAdd(aVetor, {"E1_VENCREA", DataValida(_dDtVenc)    	, Nil})
aAdd(aVetor, {"E1_VALOR"  , _nVlrSEPU					, Nil})
aAdd(aVetor, {"E1_HIST"   , "SEPU: " + PA4->PA4_SEPU	, Nil})
aAdd(aVetor, {"E1_ORIGEM" , "FINA040"					, Nil})
aAdd(aVetor, {"E1_SEPU"   , PA4->PA4_SEPU				, Nil})
//aAdd(aVetor, {"INDEX"     , 1							, Nil})

If _nFuncao == 4 // Alteracao
	// Gera nota de credito
	dbSelectArea("SE1")
	//dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	dbOrderNickName("E1_SEPU")
	If dbSeek(_cFilial + _cPref + _cNumTit)
		//Passa o numero do titulo para alteracao
		aAdd(aVetor, {"E1_NUM"    , SE1->E1_NUM			, Nil})
		msExecAuto({|x,y| Fina040(x,y)}, aVetor, _nFuncao) //Alteracao
	EndIf
Else
	msExecAuto({|x,y| Fina040(x,y)}, aVetor, _nFuncao) //Inclusao
EndIf

If lmsErroAuto
	_lOK := .F.
	MostraErro()
EndIf

FreeUsedCode()

//���������������������������������������������������������������������Ŀ
//� Retorno o valor padrao de cFilAnt                                   �
//�����������������������������������������������������������������������
cFilAnt := _cFilAnt

Return(_lOK)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
��� Funcao   �FormataCgc� Autor � Ricardo Mansano       � Data �  14/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Formata o parametro como CNPJ ou CPF.                         ���
����������������������������������������������������������������������������͹��
���Parametros� cCgc -> Numero a ser formatado                                ���
����������������������������������������������������������������������������͹��
���Retorno   � Se Len(cCGC)=14 --> Formata como CNPJ                         ���
���          � Se Len(cCGC)#14 --> Formata como CPF                          ���
����������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                     ���
���          �                                                               ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Project Function FormatCgc(cCgc)
Local nTam   	:= Len(AllTrim(cCgc))
Local cResult 	:= ""
// Formata respeitando CNPJ(14 Chars) ou CPF(11 Chars)
If !Empty(cCgc)
	If nTam == 14
		cResult := Transform(cCGC,"@R 99.999.999/9999-99")
	Else
		cResult := Transform(cCGC,"@R 999.999.999-99")
	Endif
Endif
Return(cResult)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DCalcEst �Autor  �Ricardo Mansano     � Data �  21/06/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina faz chamada ao SaldoSB2() posicionando o B2 de      ���
���          � acordo com os parametros.                                  ���
�������������������������������������������������������������������������͹��
���Parametros� _cFilial = Filial                                          ���
���          � cProduto = Produto                                         ���
���          � cLocal   = Armazem                                         ���
���          � lMsg     = T = Mostra mensagem de erro                     ���
���          �            F = Nao mostra mensagem de erro                 ���
�������������������������������������������������������������������������͹��
���Retorno   � nRet := Saldo Disponivel em SB2                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
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
Project Function DCalcEst(_cFilial,cProduto,cLocal,lMsg)
Local nRet := 0
Local _aArea   		:= {}
Local _aAlias  		:= {}
Default lMsg := .T.

P_CtrlArea(1,@_aArea,@_aAlias,{"SB2"}) // GetArea

SB2->(DbSetOrder(1)) // B2_FILIAL + B2_COD + B2_LOCAL
If SB2->( DbSeek(_cFilial+cProduto+cLocal) )
	nRet := SaldoSb2() // Esta fun��o pega o B2 posicionado
Else
	If lMsg
		Aviso("Aten��o !!!","Produto: "+AllTrim(cProduto)+"/"+AllTrim(cLocal)+" n�o localizado na tabela de Saldos (SB2)!!!",{" << Voltar"},2,"Modelo do Ve�culo !")
	EndIf
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea
Return(nRet)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AtuSeqL4 �Autor  �Ricardo Mansano     � Data �  27/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza o campo L4_SEQ. Por que na atualizacao do Server  ���
���          � Loja para o Matriz se existir mais de um registro no SL4   ���
���          � com o mesmo L4_NUM, a rotina de atualizacao sobrepoe e so  ���
���          � fica gravado o ultimo registro, pois os registros tem a    ���
���          � mesma chave principal.                                     ���
���          � Agora a rotina de atualizacao enxerga apenas o Order 3 do  ���
���          � SL4, que eh: L4_FILIAL + L4_NUM + L4_ORIGEM + L4_SEQ       ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica.                                             ���
���          � cFilial := Filial da Vendas                                ���
���          � cNum    := Numero do Orcamento                             ���
���          � cOrigem := Origem TeleVendas->SIGATMK                      ���
���          �            VendaAssistida->Em Branco                       ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � - PE LJ7002  no Venda Assistida.                           ���
���          � - PE TMKVFIM no TeleVendas                                 ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Project Function AtuSeqL4(_cFilial,cNum,cOrigem)
Local _cL4Seq := "01"
Local _aArea  := {}
Local _aAlias := {}

P_CtrlArea(1,@_aArea,@_aAlias,{"SL4"}) // GetArea

dbSelectArea("SL4")
dbSetOrder(1) // L4_FILIAL+L4_NUM+L4_ORIGEM
If dbSeek(_cFilial+cNum)
	// Atualiza SL4
	While !SL4->(Eof()) .And. SL4->(L4_FILIAL+L4_NUM) == _cFilial+cNum
		
		// Verifica Origem do Pagamento
		If PadR(SL4->L4_ORIGEM,8)  == cOrigem
			RecLock("SL4",.F.)
			SL4->L4_SEQ  := _cL4Seq
			MsUnLock()
			// Incrementa Sequencia
			_cL4Seq      := Soma1(_cL4Seq)
		Endif
		
		SL4->(dbSkip())
	EndDo
EndIf

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return Nil



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � MontaCred       �Autor � Paulo Benedet       �Data � 28/06/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Grava limite credito / data                                   ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pelo ponto de entrada CRD010PG                 ���
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
Project Function MontaCred()
Local aArea    := GetArea()
Local aAreaPAH := PAH->(GetArea())
Local aAreaPAI := PAI->(GetArea())
Local aAreaMAI := MAI->(GetArea())

Local nTotPto := 0				// Numero total de ponto do questionario
Local cQuest  := ""				// Codigo do questionario
Local dVencLC := M->A1_VENCLC	// Data de vencimento do limite de credito
Local nLC     := M->A1_LC		// Valor do limite de credito

// Verifica o tipo de pessoa
If M->A1_PESSOA == "J"
	If INCLUI
		// Busca a regra da tabela de loja x credito
		dbSelectArea("PAH")
		dbSetOrder(1) //PAH_FILIAL+PAH_LOJADV+PAH_PESSOA
		If dbSeek(xFilial("PAH") + cFilAnt + M->A1_PESSOA)
			RecLock("SA1", .F.)
			A1_LC     := PAH->PAH_LC
			A1_VENCLC := dDataBase + (PAH->PAH_MESES * 30)
			msUnlock()
		EndIf
	EndIf
Else
	// Calcula numero de pontos do questionario
	nTotPto := CRC070_003(M->A1_COD, M->A1_LOJA)
	
	// Verifica a necessidade de calculo do limite
	If nTotPto <> M->A1_PONTOS .Or. INCLUI
		
		// Busca data limite da tabela de loja x credito
		dbSelectArea("PAH")
		dbSetOrder(1) //PAH_FILIAL+PAH_LOJADV+PAH_PESSOA
		If dbSeek(xFilial("PAH") + cFilAnt + M->A1_PESSOA)
			dVencLC := dDataBase + (PAH->PAH_MESES * 30)
		EndIf
		
		// Busca questionario
		dbSelectArea("MAI")
		dbSetOrder(1) //MAI_FILIAL+MAI_CODCLI+MAI_LOJA+MAI_QUEST
		If dbSeek(xFilial("MAI") + M->A1_COD + M->A1_LOJA)
			cQuest := MAI->MAI_QUEST
		EndIf
		
		// Busca limite segundo regra da tabela score x credito
		dbSelectArea("PAI")
		dbSetOrder(1) //PAI_FILIAL+PAI_QUEST+STR(PAI_PONTOI,5,2)
		dbSeek(xFilial("PAI") + cQuest)
		
		While !EOF();
			.And. PAI_FILIAL == xFilial("PAI");
			.And. PAI_QUEST == cQuest
			
			If nTotPto >= PAI->PAI_PONTOI .And. nTotPto <= PAI->PAI_PONTOF
				nLC := PAI->PAI_LC
				Exit
			EndIf
			
			dbSelectArea("PAI")
			dbSkip()
		EndDo
	EndIf
	
	// Grava informacoes
	RecLock("SA1", .F.)
	A1_LC     := nLC
	A1_VENCLC := dVencLC
	A1_PONTOS := nTotPto
	msUnlock()
EndIf

// Restaura ambiente
RestArea(aAreaPAH)
RestArea(aAreaPAI)
RestArea(aAreaMAI)
RestArea(aArea)

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �CNPJCPF          �Autor �Norbert Waage Junior �Data � 29/06/05 ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina para geracao do codigo/loja pelo CNPJ/CGC               ���
����������������������������������������������������������������������������͹��
���Parametros�cCGC  - CGC/CNPJ do cliente                                    ���
���          �cLoja - Loja do cliente, caso esta ja esteja preenchida        ���
����������������������������������������������������������������������������͹��
���Retorno   �cCodigo - Codigo do cliente quando nao informada a loja        ���
���          �aCodigo - Array com codigo e loja, quando informada a loja     ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada via gatilho no campo A1_CGC ou via rotina       ���
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
Project Function CNPJCPF(cCGC,cLoja)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aArea	   		:= GetArea()
Local aAreaSA1 		:= SA1->(GetArea())
Local nTamCod		:= TamSx3("A1_COD")[1]
Local numero   		:= Space(nTamCod)
Local resto			:= 0
Local lPassouLoja	:= !(cLoja == NIL)
Local retorno_conv	:= Space(nTamCod)
Local cPessoa,cBusca

Default	cCGC  := IIf((AllTrim(ReadVar()) == "M->A1_CGC"),M->A1_CGC,Nil)
Default	cLoja := IIf((AllTrim(ReadVar()) == "M->A1_CGC"),M->A1_LOJA,Nil)

If Len(alltrim(cCGC)) > 11
	//Pessoa Juridica
	div		:= Val(SubStr(cCGC,1,8))
	cLoja	:= "01"
	cPessoa	:= "J"
Else
	// Pessoa Fisica
	div    := Int(Val(AllTrim(cCGC))/100)
	cLoja := "99"
	cPessoa	:= "F"
EndIf

//Calcula codigo
While div >= 35
	resto := div % 35
	div   := int(div / 35)
	numero:= conv1(resto)+alltrim(numero)
End

numero       := Conv1(div)+AllTrim(numero)
retorno_conv := Replicate("0",nTamCod-Len(AllTrim(numero)))+AllTrim(numero)

//Calculo da loja para as filiais de uma mesma empresa
dbSelectArea("SA1")
dbSetOrder(1)

If cLoja <> "99"
	
	While .T.
		
		cBusca := retorno_conv + cLoja
		
		dbSeek(xFilial("SA1")+cBusca)
		
		If Eof()
			Exit
		Else
			cLoja := Soma1(cLoja)
		EndIf
		
	EndDo
	
EndIf

//Se foi acionada por gatilho na tela de clientes
If AllTrim(ReadVar()) == "M->A1_CGC"
	
	M->A1_LOJA		:= cLoja
	M->A1_PESSOA	:= cPessoa
	
	//Executa os gatilhos do campo pessoa
	If ExistTrigger("A1_PESSOA")
		RunTrigger(1,,,,"A1_PESSOA")
	EndIf
	
EndIf

RestArea(aAreaSA1)
RestArea(aArea)

If lPassouLoja
	Return({retorno_conv,cLoja})
Else
	Return(retorno_conv)
EndIf

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Conv1    �Autor  � Marcelo Gaspar     � Data �  01/10/01   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao que converte numeros em letras(base 35)             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Conv1(y)
Return AllTrim(IIf(y<10,Str(y),Chr(y+55)))



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � WHNVRUNI        �Autor � Paulo Benedet       �Data � 04/07/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Liberar acesso ao campo LR_VRUNIT                             ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � lRer - T - Permite a edicao do campo                          ���
���          �        F - Nao permite a edicao do campo                      ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada pelo X3_WHEN do campo LR_VRUNIT                ���
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
Project Function WhnVrUni()
Local lRet := .F.	//retorno da funcao
Local cGrupo := ""	//grupo do produto corrente

// busca grupo do produto
cGrupo := RetField("SB1", 1, xFilial("SB1") + gdFieldGet("LR_PRODUTO"), "B1_GRUPO")

// Verifica grupo
If cGrupo == GetMV("FS_DEL002") // produtos genericos
	lRet := .T.
Else
	lRet := .F.
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NaPilha   �Autor  �Norbert Waage Junior� Data �  15/07/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � norbert@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao �Varre a pilha de chamadas em busca do parametro recebido.   ���
�������������������������������������������������������������������������͹��
���Parametros�cFuncao - Nome da rotina a ser pesquisada                   ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet = .T. (Foi encontrada na pilha)                       ���
���          �        .F. (Nao foi encontrada)                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function NaPilha(cFuncao)

Local lRet	:=	.F.
Local cProc	:=	""
Local nX	:=	0

While !Empty(cProc := ProcName(nX++)) .And. !lRet
	lRet :=	(Alltrim(Upper(cProc)) == cFuncao)
End

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelReserva� Autor �Norbert Waage Junior� Data �  21/07/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de cancelamento de reservas                         ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica                                              ���
�������������������������������������������������������������������������͹��
���Aplicacao � Rotina acionada antes de gravar a venda, para que a reserva���
���          � seja liberada para a emissao da NF.                        ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Della Via Pneus                                    ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function DelReserva()

Local aArea 	:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSC0	:= SC0->(GetArea())
Local _cNum 	:= M->LQ_NUM

//������������������������������
//�Somente na grava��o da venda�
//������������������������������
If nRotina == 4
	
	// Estorna Reservas em SC0
	dbSelectArea("SB2")
	dbSetOrder(1) // Filial + Codigo + Local
	
	dbSelectArea("SC0")
	dbSetOrder(3) // C0_FILIAL + C0_NUMORC + C0_PRODUTO
	
	If dbSeek(xFilial("SC0")+_cNum)
		
		While !SC0->(Eof()) .And. xFilial("SC0")+_cNum == SC0->(C0_FILIAL + C0_NUMORC)
			
//			Begin Transaction
			
			// Estorna Reservas em SB2
			If SB2->( DbSeek(xFilial("SB2")+SC0->C0_PRODUTO+SC0->C0_LOCAL) )
				RecLock("SB2",.F.)
				SB2->B2_RESERVA -= SC0->C0_QTDPED
				MsUnLock()
			EndIf
			
			// Deleta Reserva em SC0
			RecLock("SC0",.F.)
			SC0->(dbDelete())
			MsUnLock()
			
//			End Transaction
			
			SC0->(dbSkip())
			
		EndDo
		
	EndIf
	
EndIf

RestArea(aAreaSB2)
RestArea(aAreaSC0)
RestArea(aArea)

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_CalcVSeg �Autor  �Norbert Waage Junior   � Data �  23/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Calcula totais a serem pagos pela corretora e seguradora       ���
����������������������������������������������������������������������������͹��
���Parametros�nTotCorr - Total pago pela corretora                           ���
���          �nTotSeg  - Total pago pela seguradora                          ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo bocao Condic.Pagamento                     ���
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
Project Function CalcVSeg(nTotCorr,nTotSeg)

Local aArea		:=	GetArea()
Local aAreaPA8  :=	PA8->(GetArea())
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
Local nPosVlrIt	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VLRITEM" })
Local nPerCli	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PERCLI"  })
Local nPosVlUni	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VRUNIT"  })
Local nX

//����������������������Ŀ
//�Abre tabela de seguros�
//������������������������
DbSelectArea("PA8")
DbSetOrder(6) //PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM

//�����������������������������������������������������������Ŀ
//�Percorre os itens da venda                                 �
//�Obs.: Ao inves de percorrer o SL2, percorro o aCols, pois o�
//�campo L2_VLRITEM pode ter seu valor alterado antes da      �
//�gravacao, quando usa-se uma NCC, por exemplo.              �
//�������������������������������������������������������������
For nX := 1 to Len(aCols)
	
	If !Empty(aCols[nX][nPosApo]) .And. !ATail(aCols[nX]) .And.;
		PA8->(DbSeek(xFilial("PA8")+aCols[nX][nPosApo]+ M->(LQ_CLIENTE+LQ_LOJA) + aCols[nX][nPosItApo]))
		
		//�������������������������������������������������������������Ŀ
		//�Calcula diferenca e percentuais a serem pagos pela seguradora�
		//�e pela corretora                                             �
		//���������������������������������������������������������������
		nDif 	:= aCols[nX][nPosVlUni] - PA8->PA8_VPROSG
		nPerc	:= (aCols[nX][nPerCli] / 100)
		
		If nDif > 0
			nTotCorr += nDif * nPerc
		EndIf
		
		If nDif >= 0
			nTotSeg +=	PA8->PA8_VPROSG * nPerc
		Else
			nTotSeg +=	aCols[nX][nPosVlUni] * nPerc
		EndIf
		
	EndIf
	
Next nX

//��������������������Ŀ
//�Trata arredondamento�
//����������������������
nTotCorr	:= Round(nTotCorr,nDecimais)
nTotSeg		:= Round(nTotSeg ,nDecimais)

RestArea(aAreaPA8)
RestArea(aArea)

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �LjRodape  �Autor  �Norbert Waage Junior   � Data �  27/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina para atualizacao da mensagem do rodape informativo dos  ���
���          �totais da venda.                                               ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada para atualizar o rodape, como gatilho ou codigo ���
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
Project Function LjRodape(cCondPg)

Local aArea		:= GetArea()
Local nTotCorr	:= 0
Local nTotSeg	:= 0
Local nParc		:= 0
Local cDescCP	:= ""
Local nValPago	:= 0

//���������������������������Ŀ
//�Obtem condicao de pagamento�
//�����������������������������
If Empty(cCondPg)
	If !Empty(_cD020CPG)
		cCondPg	:=	_cD020CPG
	Else
		cCondPg	:=	GetAdvFVal("PAF","PAF_CONDPG",xFilial("PAF")+cFilAnt+M->LQ_TIPOVND,1,Space(TamSX3("E4_CODIGO")[1]))
	EndIf
EndIf

cDescCP	:= Space(10) + cCondPg + " - " + AllTrim(Posicione("SE4",1,xFilial("SE4")+cCondPg,"E4_DESCRI"))

//����������������������������������������Ŀ
//�Calcula totais da corretora e seguradora�
//������������������������������������������
P_CalcVSeg(@nTotCorr,@nTotSeg)

nValPago := Lj7T_TOTAL( 2 ) - nNCCUsada - (nTotSeg+nTotCorr)
nValPago := IIf( nValPago > 0, nValPago, 0 )                               

//������������������������������Ŀ
//�Obtem a quantidade de parcelas�
//��������������������������������
nParc := Len(Condicao( nValPago, cCondPg ))//Len(P_Lj7CondPg( 2, cCondPg ))

//�����������������Ŀ
//�Atualiza o rodape�
//�������������������
Lj7R_Rodape(cDescCP + Space(10) + "TOTAL DA VENDA:  " + AllTrim(Str(nParc)) + "  X  " +;
Alltrim(Transform((nValPago/nParc),"@E 9,999,999.99")) +;
Iif((nTotSeg+nTotCorr)>0,;
Space(10) +	"BONIFICACAO DO CLIENTE: " + Alltrim(Transform((nTotSeg+nTotCorr),"@E 9,999,999.99")),""))

RestArea(aArea)

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �AltTes    �Autor  �Norbert Waage Junior   � Data �  01/08/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de troca inteligente de TES, a partir do tipo de opera- ���
���          �cao informado.                                                 ���
����������������������������������������������������������������������������͹��
���Parametros�lTodos - (.T.) Indica que todos os itens serao recalculados    ���
���          �         (.F.) Indica que apenas o item atual sera recalculado ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada a partir de gatilhos e funcoes internas         ���
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
Project Function AltTes(lTodos)

Local nPosTES		:= aScan(aHeaderDet,{ |x| AllTrim(x[2]) == "LR_TES"     })
Local nPosTpOp		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_TPOPER"  })
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local nNatu			:= N
Local nPosDel		:= Len(aHeader) + 1
Local nSubTot		:= 0
Local cCliente		:= M->LQ_CLIENTE
Local cLoja			:= M->LQ_LOJA
Local cCliFor		:= "C"
Local cProd,cTpOper
Local nInicial, nFinal, nX

//������������������������������������������Ŀ
//�O padrao de execucao eh para a linha atual�
//��������������������������������������������
Default lTodos := .F.

//��������������������������������������������������������Ŀ
//�Configura variaveis para execucao unica ou para todos os�
//�itens da venda                                          �
//����������������������������������������������������������
nInicial	:= Iif(lTodos,1,N)
nFinal		:= Iif(lTodos,Len(aCols),N)

//Sai da rotina na visualizacao
If !Altera .And. !Inclui
	Return Nil
EndIf

//�����������������������������������������������������������������������������Ŀ
//� Solucao paleativa para a nao alteracao do codigo do cliente no array fiscal �
//�������������������������������������������������������������������������������
If maFisFound("NF")
	If M->LQ_CLIENTE <> maFisRet(, "NF_CODCLIFOR")
		// Altera o codigo do cliente no array fiscal se este for diferente do get
		maFisAlt("NF_CODCLIFOR", M->LQ_CLIENTE)
	EndIf
	
	If M->LQ_LOJA <> maFisRet(, "NF_LOJA")
		// Altera a loja do cliente no array fiscal se esta for diferente do get
		maFisAlt("NF_LOJA", M->LQ_LOJA)
	EndIf
EndIf

//Percorre itens
For nX := nInicial to nFinal
	
	//Somente para linhas preenchidas
	If !Empty(aCols[nX,nPosProduto])
		
		//Ajusta N para a rotina MaTesVia
		N := nX
		
		//Le o produto da linha atual	
		cProd	:= aCols[nX,nPosProduto]
		cTpOper	:= Iif(lTodos,P_RetTpOp(M->LQ_CLIENTE,M->LQ_LOJA,aCols[nX,nPosProduto]),aCols[nX,nPosTpOp])
		
		//Atualiza aCols
		aCols[nX,nPosTpOp]	:= cTpOper
		
		//Atualiza aColsDet trazendo TES correto
		aColsDet[nX,nPosTES]	:= U_MaTesVia(2,cTpOper,cCliente,cLoja,cCliFor,cProd)
		
		//Altera o TES nas funcoes fiscais
		MaFisAlt("IT_TES", aColsDet[nX,nPosTES], nX)
		
		//Altera CFOP do aColsDet
		aColsDet[nX][aScan(aHeaderDet,{ |x| Alltrim( x[2] ) == "LR_CF" })] := MaFisRet(nX, "IT_CF")
		          
	EndIf
	
Next nX

//Recalcula totais
For nX := 1 to Len(aCols)

	//Somente para linhas validas
	If !aTail(aCols[nX]) .And. MaFisFound("IT",nX)
	
		//Acumula subtotal
		nSubTot += Iif(!aCols[nX][nPosDel],MaFisRet(nX, "IT_TOTAL"),0)
	
	EndIf

Next nX

//Atualiza totais
Lj7T_SubTotal( 2, nSubTot )
Lj7T_Total( 2, Lj7T_SubTotal(2) - Lj7T_DescV(2) )    

//Zera pagamentos
If Type("oPgtos") == "O" .AND. nRotina<>4  // Eder - nao zera caso seja finalizacao de vendas
	P_Lj7ZeraPgtos()
EndIf

//Restaura N
N := nNatu  

//Atualiza mensagem do Rodape e GetDados
P_LjRodape()
oGetVa:oBrowse:Refresh()

//Restaura N novamente pois o Refresh() pode alterar o valor de N
N := nNatu

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �RetTpOp   �Autor  �Norbert Waage Junior   � Data �  02/08/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Retorna o tipo de operacao do produto                          ���
����������������������������������������������������������������������������͹��
���Parametros�cCliente - Codigo do cliente                                   ���
���          �cLoja    - Loja do Cliente                                     ���
���          �cProduto - Codigo do produto                                   ���
���          �cTipoCli - Tipo da entidade: C= Cliente(Default); F= Fornecedor���
����������������������������������������������������������������������������͹��
���Retorno   �cTpOp - Tipo da operacao                                       ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada a partir de gatilhos e funcoes internas         ���
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
Project Function RetTpOp(cCliente,cLoja,cProduto,cTipoCli)

Local aArea		:= GetArea()
Local cTpOp 	:= "01"
Local cGrupo	:= "001"
Local lIsento	:= .F.
Local aCliente	:= {}
Local cGrTrib	:= AllTrim(Upper(GetAdvFVal("SB1","B1_GRTRIB",xFilial("SB1")+cProduto,1,"")))

Default cTipoCli := "C"
                     
If cTipoCli == "C"	//Cliente
	aCliente := GetAdvFVal("SA1",{"A1_INSCR","A1_EST"},xFilial("SA1")+cCliente+cLoja,1,{"",""})
Else				//Fornecedor
	aCliente := GetAdvFVal("SA2",{"A2_INSCR","A2_EST"},xFilial("SA2")+cCliente+cLoja,1,{"",""})
EndIf

lIsento := Empty(aCliente[1]) .Or. "ISENT" $ Upper(aCliente[1])

//Se o cliente nao for isento e o grupo tributario do produto for igual a 001
If !( lIsento ) .And. ( cGrTrib  == cGrupo ) .And.;
	(AllTrim(Upper(aCliente[2])) != AllTrim(Upper(GetMv("MV_ESTADO"))))
	cTpOp := "03"
EndIf

RestArea(aArea)

Return cTpOp

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �ChkTpOp   �Autor  �Norbert Waage Junior   � Data �  03/08/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de validacoes referentes aos tipos de operacao          ���
����������������������������������������������������������������������������͹��
���Parametros�lRet   - (.T.) Validacoes ok                                   ���
���          �         (.F.) Problemas em alguma validacao                   ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina executada na confirmacao da venda/orcamento no PE LJ7001���
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
Project Function ChkTpOp()

Local aArea			:= GetArea()
Local aGrupos		:= {}
Local aCliente		:= GetAdvFVal("SA1",{"A1_INSCR","A1_EST"},xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,1,{"",""})
Local cDoacao		:= GetMv("FS_DEL038") //Tipo de operacao de doacao
Local cGrTrib		:= ""
Local cEstado		:= AllTrim(Upper(GetMv("MV_ESTADO")))
Local nPosTpOp		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_TPOPER"  })
Local nPosProduto 	:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_PRODUTO" })
Local nPosQuant		:= aScan(aHeader   ,{ |x| AllTrim(x[2]) == "LR_QUANT"   })
Local nLenAC		:= Len(aCols)
Local nPos			:= 0
Local nPos2			:= 0
Local nGrp1			:= 0
Local nGrp2			:= 0
Local lTipo17		:= .F.
Local lRet			:= .T.
Local lIsento		:= .F.
Local cMsg
Local nX

//������������������������������Ŀ
//�Verificacao dos dados da venda�
//��������������������������������
For nX := 1 to nLenAC
	
	//Somente linhas nao deletadas
	If !ATail(aCols[nX])

		//Armazena grupo tributario
		cGrTrib := AllTrim(Upper(GetAdvFVal('SB1','B1_GRTRIB',xFilial('SB1')+aCols[nX][nPosProduto],1,"")))
		
		//Acumula as quantidades do grupo 001, tipo de operacao 03
		If ( cGrTrib == "001" ) .And. ( aCols[nX][nPosTpOp] == "03" )
			nGrp1 += aCols[nX][nPosQuant]
		EndIf      
		
		//Acumula as quantidades do grupo 016
		//If ( cGrTrib == "016" )
		If ( cGrTrib == GetMV("FS_DEL039") )
			nGrp2 += aCols[nX][nPosQuant]
		EndIf
		
		//Cria array com grupos - Cada array armazena os tipos de operacao utilizados no grupo
		//na segunda posicao do vetor.
		If ( nPos := AScan(aGrupos,{|x| x[1] == cGrTrib }) ) == 0
			AAdd(aGrupos,{cGrTrib,{aCols[nX][nPosTpOp]}})
		Else 
			If( nPos2 := AScan(aGrupos[nPos][2],{|x| x == aCols[nX][nPosTpOp] }) ) == 0
				AAdd(aGrupos[nPos][2],aCols[nX][nPosTpOp])
			EndIf
		EndIf

	EndIf			

Next nX

//�������������������������������������������Ŀ
//�Valida quantidades dos grupos de tributacao�
//���������������������������������������������
If  (nGrp1 > 0) .And. ( nGrp1 != nGrp2 )

	lRet :=  .F.

	cMsg := "A quantidade de itens do grupo tribut�rio 001 com tipo de opera��o 03 � diferente da quantidade " +;
			"de itens do grupo tribut�rio " + GetMV("FS_DEL039")
EndIf

//�������������������������������������������������������Ŀ
//�Valida se existem produtos do mesmo grupo de tributacao�
//�com tipos de opera��o diferentes                       �
//���������������������������������������������������������
If lRet
	
	//Percorre os grupos
	For nX := 1 to Len(aGrupos)
		
		//Se houver mais de um tipo de operacao por grupo
		If Len(aGrupos[nX][2]) > 1
			
			lRet := .F.
			cMsg := "N�o � permitida a venda de produto do mesmo Grupo de Tributa��o com Tipos de Opera��o "+;
					"diferentes"
			nX := Len(aGrupos) + 1
			
		EndIf
		
	Next nX

EndIf

//�������������������������������Ŀ
//�Verifica se o cliente eh isento�
//���������������������������������
lIsento := Empty(aCliente[1]) .Or. "ISENT" $ Upper(aCliente[1])

//��������������������������������������������������������Ŀ
//�Valida grupos de tributacao para clientes fora do estado�
//����������������������������������������������������������
If lRet .And. !( lIsento ) .And. ( AllTrim(Upper(aCliente[2])) != cEstado )
	
	//Verifica se existem itens do grupo 001
	If ( nPos := AScan(aGrupos,{|x| x[1] == "001"}) ) != 0 
		
		//Verifica se existem itens do grupo 001 com tipo de operacao 01
		If ( AScan(aGrupos[nPos][2],{|x| x = "01"}) != 0 )
			
			//Verifica se ha itens do grupo 016
			If !(lRet := ( AScan(aGrupos,{|x| x[1] == "016"}) ) == 0)
			
				cMsg := "N�o � permitida a venda de itens com grupo de tributa��o 016 para clientes de fora "+;
						"do estado quando j� foram adicionados itens do grupo de tributa��o 001, com tipo de"+;
						" opera��o 01."
									
			EndIf
			
		EndIf
		
	EndIf

EndIf

//���������������������������������Ŀ
//�Valida tipo de operacao de doacao�
//�����������������������������������
If lRet

	nX := 1

	//Se a condicao de pagamento e do tipo doacao, todos os itens devem ter tipo de operacao Doacao
	If ( AllTrim(Upper(_cD020CPG)) == AllTrim(Upper(GetMv("FS_DEL012"))) )
	
		//Varre aCols, verificando se ha itens com tipo de operacao diferente do tipo Doacao
		While (nX <= nLenAC) .And. ( lRet := (AllTrim(aCols[nX++][nPosTpOp]) == cDoacao) ) //Doacao
		EndDo	

		If !lRet
			cMsg := "Para utilizar a condi��o de pagamento do tipo Doa��o, todos os itens ser do tipo de opera��o"+;
			 		"Doa��o."
		EndIf
		
	Else      
	
	    //Verifica se exitem itens de doacao
		While (nX <= nLenAC) .And. !( lTipo17 := (AllTrim(aCols[nX++][nPosTpOp]) == cDoacao) ) //Doacao
		EndDo	
		
		If lTipo17 
			lRet := .F.
			cMsg := "Um ou mais itens desta venda � do tipo Doa��o. Para utilizar doa��es, todos os itens devem "+;
					"ser do tipo Doa��o, assim como a condi��o de pagamento."
		EndIf

	EndIf

EndIf

//�������������������������������Ŀ
//�Se houve erro, exibe a mensagem�
//���������������������������������
If !Empty(cMsg)
	ApMsgAlert(cMsg,"Tipo de Opera��o")
EndIf

Restarea(aArea)

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DISTRCLI        �Autor � Paulo Benedet       �Data � 05/08/05 ���
����������������������������������������������������������������������������͹��
���Descricao � Atualizar os tipos de saidas na troca de cliente.             ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � T - sempre                                                    ���
����������������������������������������������������������������������������͹��
���Aplicacao � Funcao chamada na validacao dos campos LM_CLIENTE, LM_LOJA    ���
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
Project Function DistrCli()
Local nLin := Len(aCols)
Local i

// Dispara gatilhos do tipo de operacao
For i := 1 to nLin
	RunTrigger(2, i,,, "LN_TPOPER ")
Next i

// Atualiza tela
oGet:oBrowse:Refresh()

Return(.T.)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �OrdParcs  �Autor  �Norbert Waage Junior   � Data �  31/08/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Ordena parcelas de pagamento do Venda Assistida                ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina utilizada para ordenar array de pagamentos, deixando o  ���
���          �pagamento em especie em primeiro, na tela do Venda Assistida.  ���
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
Project Function OrdParcs()

Local nPos
Local lVisuSint	:= If( SL4->(FieldPos("L4_FORMAID")) > 0, .T., .F. )

//������������Ŀ
//�Ordena vetor�
//��������������
If lVisuSint
	//aSort(aPgtos,,,{|x,y| x[3]+x[8]+Dtos(x[1]) < y[3]+y[8]+Dtos(y[1]) } ) //Condicao + Seq + Data
	aSort(aPgtos,,, {|x, y| DtoS(x[1]) + x[3] + x[8] < DtoS(y[1]) + y[3] + y[8]}) // Data + Form Pag + Seq
Else
	aSort(aPgtos,,,{|x,y|DtoS(x[1])+IIf(AllTrim(x[3]) $ MVCHEQUE,"Z","A") <;
						 DtoS(y[1])+IIf(AllTrim(y[3]) $ MVCHEQUE,"Z","A")}) //Data
EndIf

//��������������������������������������Ŀ
//� A Forma $ sempre sera a primeira!!!  �
//����������������������������������������
If (nPos:=AScan(aPgtos, {|x| AllTrim(x[3]) == AllTrim(GetMv("MV_SIMB"+Ltrim(Str(nMoedaCor)))) })) > 1
	AAdd(aPgtos, {})
	AIns(aPgtos, 1)
	nPos++
	aPgtos[1] := aPgtos[nPos]
	ADel(aPgtos, nPos)
	ASize(aPgtos, Len(aPgtos)-1)
EndIf   

Return Nil                           

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �NotifDP   �Autor  �Norbert Waage Junior   � Data �  12/09/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Notifica o usuario sobre o uso de duplicatas                   ���
����������������������������������������������������������������������������͹��
���Parametros�aParc - Array que contem as parcelas                           ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada a partir da alteracao das parcelas ou da condi-���
���          �cao de pagamento na venda assistida.                           ���
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
Project Function NotifDP(nTipo)

Local lAtiva	:= .T.	//Funcao ativa
Local lNotif	:= .F.
Local nX		:= 1

If lAtiva

	If nTipo == 1
		While !lNotif .And. nX <= Len(aPgtos)
			lNotif :=  "DP" $ aPgtos[nX++][3]
		End
	Else
		lNotif :=  AllTrim(Upper(PARAMIXB[2][3])) == "DUPLICATA"
	EndIf
	
	If lNotif
		ApMsgAlert("Para pagamentos do tipo DP � necess�rio emitir a Nota Fiscal sobre o cupom.", "Forma de Pagamento")
	EndIf
	
EndIf

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �RetStatFin�Autor  �Norbert Waage Junior   � Data �  15/09/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Status financeiro do cliente                                   ���
����������������������������������������������������������������������������͹��
���Parametros�cCliente - Codigo do Cliente                                   ���
���          �cLoja    - Loja do Cliente                                     ���
����������������������������������������������������������������������������͹��
���Retorno   �aRet     - Array com situacoes de bloqueio do cliente:         ���
���          �           1- Cheques Devolvidos                               ���
���          �           2- Lucros e Perdas                                  ���
���          �           3- Cobrancas de terceiros                           ���
���          �           4- Titulos Protestados                              ���
���          �           5- Pagamento em cartorio                            ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina de uso generico                                         ���
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
Project Function RetStatFin(cCliente,cLoja)

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSE1	:= SE1->(GetArea())
Local aAreaSZB	:= SZB->(GetArea())
Local cFilSE1	:= xFilial("SE1")
Local cFilSZB	:= xFilial("SZB")
Local cParChDev	:= AllTrim(Upper(GetMv("FS_DEL040")))
Local cParLeP	:= AllTrim(Upper(GetMv("FS_DEL041")))
Local cParTerc	:= AllTrim(Upper(GetMv("FS_DEL042")))
Local cParTitPr	:= AllTrim(Upper(GetMv("FS_DEL043")))
Local aRet		:= {}

AAdd(aRet,{0,0})	//Cheques Devolvidos
AAdd(aRet,{0,0})	//Lucros e Perdas
AAdd(aRet,{0,0})	//Cobranca de terceiros
AAdd(aRet,{0,0})	//Titulos Protestados
AAdd(aRet,{0,0})	//Pagamento em Cartorio

DbSelectArea("SA1")
DbSetOrder(1)

If !DbSeek(xFilial("SA1")+cCliente+cLoja)
	Return aRet
EndIf

DbSelectArea("SE1")
DbSetOrder(2)	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

//���������������������������������������������Ŀ
//�--Estrutura do array aRet--                  �
//�1 = Cheques devolvidos                       �
//�2 = Lucros / Perdas                          �
//�3 = Cobranca de terceiros                    �
//�4 = Titulos protestados                      �
//�5 = Pagamento em cartorio                    �
//�����������������������������������������������

If DbSeek(cFilSE1+cCliente+cLoja)

	While !Eof() 				.And.;
	SE1->E1_FILIAL == cFilSE1	.And.;
	SE1->E1_CLIENTE == cCliente	.And.;
	SE1->E1_LOJA == cLoja
		
		//�����������������������������Ŀ
		//�Analise de cheques devolvidos�
		//�������������������������������
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParChDev) .And. (SE1->E1_SALDO > 0)

			aRet[1][1]++
			aRet[1][2]+= SE1->E1_SALDO

		EndIf

		//�����������������������������Ŀ
		//�Analise de Lucros / Perdas   �
		//�������������������������������
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParLeP) .And. (SE1->E1_SALDO == 0)

			aRet[2][1]++
			aRet[2][2]+= SE1->E1_VALOR

		EndIf

		//�����������������������������Ŀ
		//�Analise de cobranca de 3os.  �
		//�������������������������������
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParTerc)

			aRet[3][1]++
			aRet[3][2]+= SE1->E1_SALDO

		EndIf

		//������������������������������Ŀ
		//�Analise de titulos protestados�
		//��������������������������������
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParTitPr)

			aRet[4][1]++
			aRet[4][2]+= SE1->E1_SALDO

		EndIf
		
		DbSkip()

	End

EndIf

//���������������������������������Ŀ
//�Analise de pagamentos em cartorio�
//�����������������������������������
DbSelectArea("SZB")
DbSetOrder(2)	//ZB_FILIAL+ZB_CLIENTE+ZB_LOJA+ZB_PREFIXO+ZB_NUM+ZB_PARCELA+ZB_TIPO

If DbSeek(cFilSZB + cCliente + cLoja)

	While !Eof() 				.And.;
	SZB->ZB_FILIAL	== cFilSZB	.And.;
	SZB->ZB_CLIENTE	== cCliente	.And.;
	SZB->ZB_LOJA	== cLoja
		
		aRet[5][1] += IIf("08" $ SZB->ZB_OCORR,1,0)
		
		DbSkip()
		
	End

EndIf

RestArea(aAreaSA1)
RestArea(aAreaSE1)
RestArea(aAreaSZB)
RestArea(aArea)

Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VldCupom �Autor  �Marcio Domingos     � Data �  11/08/06   ���
�������������������������������������������������������������������������͹��
���Descricao � User Function para validar:                                ���
���          � 1) Impressao de cupom no m�dulo Venda Assistida;           ���
���          � 2) Gera��o de pedidos no Call Center;                      ���
���          � 3) Gera��o de pedidos no Televendas;                       ���
�������������������������������������������������������������������������͹��
���Parametros� _nOpc   = 1=Cupom / 2= Nota Fiscal (Venda Assistida)       ���
���          �                   / 2= Pedido (Televendas e Pedido Vendas) ���
�������������������������������������������������������������������������͹��
���Retorno   � _lRet   = .T. / .F.                                        ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
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
User Function VldCupom(_nOpc,cCliente,cLoja)
Local _lRet 	:= .T.
Local _aArea	:= GetArea()             

If FunName() == "LOJA701"

	If _nOpc == 1
	
		// Cupom Fiscal
		// O sistema NAO deve permitir a emissao do cupom fiscal nas seguintes condicoes:
	
		// Condicao 1 : Cliente pessoa jur�dica e com inscricao estadual e fora do estado.
		If SA1->A1_PESSOA == "J" .And. !Empty(SA1->A1_INSCR) .And. Rtrim(SA1->A1_INSCR) <> "ISENTO" .And. SA1->A1_EST <> GetMv("MV_ESTADO")
			ApMsgAlert("N�o � permitido finalizar vendas com cupom para cliente pessoa Juridica / Fora do Estado !","Aten��o !")
			_lRet	:= .F.
		Endif
		
		If _lRet
			//Condicao 2 : Cliente pessos juridica e tipo revendedor
			If SA1->A1_PESSOA = "J" .And. SA1->A1_TIPO = "R"                                             
				ApMsgAlert("N�o � permitido finalizar vendas com cupom para cliente pessoa Juridica / Revendedor !","Aten��o !")
				_lRet	:= .F.
			Endif
		Endif	
		
	ElseIf _nOpc == 2	
			// Nota Fiscal
			// Cliente pessoa fisica e tipo consumidor final			                                
			If SA1->A1_PESSOA = "F" .And. SA1->A1_TIPO = "F"
				ApMsgAlert("N�o � permitido finalizar vendas com Nota Fiscal para cliente Pessoa Fisica / Consumidor !","Aten��o !")
				_lRet	:= .F.                              
			Endif
	Endif			     
	
ElseIf Rtrim(FunName()) $ "TMKA271&MATA410"	 // Call Center ou Pedido de Vendas
	
		If _nOpc == 2 // Faturamento                          
		
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+cCliente+cLoja)
			
				// O sistema NAO deve permitir a geracao de pedido de vendas quando:
				// Cliente pessoa juridica e tipo consumidor final
				If SA1->A1_PESSOA = "F" .And. SA1->A1_TIPO = "F"                  
					ApMsgAlert("N�o � permitido gerar pedidos para cliente pessoa f�sica e cosumidor final.","Aten��o !")
					If Rtrim(FunName()) $ "MATA410"
						M->C5_LOJACLI	:= Space(02)
					Endif	
					_lRet	:= .F.                              
				Endif                   
				
			Else
							
				_lRet := .F.
				
			Endif	
				
		Endif                   
		
Endif
RestArea(_aArea)
Return _lRet		



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Lj7ZeraPgtos �Autor � Paulo Benedet      � Data � 28/08/07 ���
�������������������������������������������������������������������������͹��
���Descricao � Limpar objetos da condicao negociada                       ���
�������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                     ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                     ���
�������������������������������������������������������������������������͹��
���Aplicacao � Somente dentro da venda assistida                          ���
���          � Esta funcao eh uma componentizacao da funcao padrao de     ���
���          � mesmo nome                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                            ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���          �        �      �                                         	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Project Function Lj7ZeraPgtos()

Local nPosValItem := aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VLRITEM"})][2]
Local nPosValUnit := aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_VRUNIT"})][2] 
Local nTamLQ_CON  := TamSx3("LQ_CONDPG")[1]  	// Tamanho do campo LQ_CONDPG
Local nTamE4_DES  := TamSX3("E4_DESCRI")[1]		// Tamanho do campo E4_DESCRI

aPgtos := { {Ctod(Space(8)),0,Space(2),{},NIL,If(cPaisLoc<>"BRA",nMoedaCor,NIL),If(cPaisLoc<>"BRA",Ctod(Space(8)),NIL),;
              If(lVisuSint,Space(TamSX3("L4_FORMAID")[1]),Space(01))} }
              
LJ7T_Total( 2, Lj7T_Subtotal(2) - Lj7T_DescV(2) )
oPgtos:SetArray( aPgtos )
oPgtos:Refresh()

//���������������������������������������������������������������������Ŀ
//�Zera as variaveis da condicao de pagamento                           �
//�����������������������������������������������������������������������
M->LQ_CONDPG := Space(nTamLQ_CON)
cDescCondPg	:= Space(nTamE4_DES)
cCondSE4 := ""
oCondPg:Refresh()
oDescCondPg:Refresh()

//���������������������������������������������������������������������Ŀ
//� Zera o desconto no total apenas se foi informado depois da condicao �
//� de pagamento                                                        �
//���������������������������������������������������������������������ĳ
//� Identifica em que momento foi dado o desconto no total              �
//� aDesconto[1] := 0	// Nao tem desconto                             �
//� aDesconto[1] := 1	// Antes da condicao de pagamento               �
//� aDesconto[1] := 2	// Depois da condicao de pagamento              �
//�����������������������������������������������������������������������
If aDesconto[1] == 2
	LJ7T_Total( 2, Lj7T_Subtotal(2) - Lj7T_DescV(2) )
	Lj7T_DescV( 2, 0 )
	Lj7T_DescP( 2, 0 )
	Lj7T_Total( 2, Lj7T_Subtotal(2) )
Endif

//���������������������������������������������������������������������Ŀ
//�Ajusta o Valor das Parcelas e o Valor do Troco                       �
//�����������������������������������������������������������������������
Lj7AjustaTroco()		

//���������������������������������������������������������������������Ŀ
//� Ajusta os valores de PIS/COFINS caso Haja                           �
//�����������������������������������������������������������������������
If maFisFound(, "NF_VALISS")
	Lj7PisCof()
EndIf

If lVisuSint 
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray( aPgtosSint )
	oPgtosSint:Refresh()
EndIf	

Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � vldsep   �Autor  � Eder Oliveira      � Data �  06/30/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � validacoes do SEPU                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VLDSEP
Local _aArea 	:= GetArea()
Local _lRet 	:= .t.
Local _cVar 	:= ReadVar()

If ALTERA

	// VALIDA CAMPOS PIRELLI
    If _cVar=="M->PA4_ACTFA"  .AND. M->PA4_ACTFA=="N"
    	_lRet := PA4->PA4_ACTFA<>"S"
        If _lRet
	    	M->PA4_VBONFA 	:= 0
	    	M->PA4_PBONFA 	:= 0
    		M->PA4_CANMFA	:= SPACE(LEN(PA4->PA4_CANMFA))
    		M->PA4_DANMFA	:= SPACE(LEN(PA4->PA4_DANMFA))
    	Else
    		MsgAlert("SEPU ja usado nao pode ser alterado!")
    	Endif
    Endif
    If _cVar=="M->PA4_RESFA" 
    	If M->PA4_ACTFA=="S"
	    	_lRet := !Empty(Alltrim(M->PA4_RESFA))
    	ElseIf M->PA4_ACTFA$" N"
	    	_lRet := Empty(Alltrim(M->PA4_RESFA))
	    ElseIf M->PA4_VBONFA>0
	    	_lRet := !Empty(Alltrim(M->PA4_RESFA))
	    Endif
	Endif
    If _cVar=="M->PA4_VBONFA" 
    	If M->PA4_ACTFA=="S"
	    	_lRet := M->PA4_VBONFA>0 
    	Else // If M->PA4_ACTFA=="N"
	    	_lRet := M->PA4_VBONFA==0
	    Endif
	Endif
    If _cVar=="M->PA4_PBONFA" 
    	If M->PA4_ACTFA=="S"
	    	_lRet := M->PA4_PBONFA>0 
    	Else // If M->PA4_ACTFA=="N"
	    	_lRet := M->PA4_PBONFA==0
	    Endif
	Endif
    If _cVar=="M->PA4_CANMFA" 
    	If M->PA4_ACTFA=="S"
	    	_lRet := !Empty(Alltrim(M->PA4_CANMFA))
    	ElseIf M->PA4_ACTFA$"N "
	    	_lRet := Empty(Alltrim(M->PA4_CANMFA))
	    ElseIf M->PA4_VBONFA>0
	    	_lRet := !Empty(Alltrim(M->PA4_CANMFA))
	    Endif
	Endif
    If _cVar=="M->PA4_MLDOFA" 
    	If M->PA4_ACTFA=="S"
	    	_lRet := !Empty(Alltrim(M->PA4_MLDOFA))
    	ElseIf M->PA4_ACTFA$" N"
	    	_lRet := Empty(Alltrim(M->PA4_MLDOFA))
	    ElseIf M->PA4_VBONFA>0
	    	_lRet := !Empty(Alltrim(M->PA4_MLDOFA))
	    Endif
	Endif
    If _cVar=="M->PA4_DESGAS" 
    	If M->PA4_ACTFA=="S"
	    	_lRet := M->PA4_DESGAS>0
    	ElseIf M->PA4_ACTFA$" N"
	    	_lRet := M->PA4_DESGAS==0
	    ElseIf M->PA4_VBONFA>0
	    	_lRet := M->PA4_DESGAS>0
	    Endif
	Endif


	// VALIDA CAMPOS DELLA VIA
    If _cVar=="M->PA4_ACTDV" .AND. M->PA4_ACTDV=="N"
    	_lRet := PA4->PA4_ACTDV<>"S"
        If _lRet
    		M->PA4_VBONDV := 0
	    	M->PA4_PBONDV := 0
    		M->PA4_PRCDV  := 0
    		M->PA4_CANMDV	:= SPACE(LEN(PA4->PA4_CANMDV))
	    	M->PA4_DANMDV	:= SPACE(LEN(PA4->PA4_DANMDV))
    	Else
	    	MsgAlert("SEPU ja usado n�o pode ser alterado!")
    	Endif
    Endif
    If _cVar=="M->PA4_RESDV" 
    	If M->PA4_ACTDV=="S"
	    	_lRet := !Empty(Alltrim(M->PA4_RESDV))
    	ElseIf M->PA4_ACTDV$" N"
	    	_lRet := Empty(Alltrim(M->PA4_RESDV))
	    ElseIf M->PA4_VBONDV>0
	    	_lRet := !Empty(Alltrim(M->PA4_RESDV))
	    Endif
	Endif
    If _cVar=="M->PA4_VBONDV" 
    	If M->PA4_ACTDV=="S"
	    	_lRet := M->PA4_VBONDV>0 
    	Else // If M->PA4_ACTDV=="N"
	    	_lRet := M->PA4_VBONDV==0
	    Endif
	Endif
    If _cVar=="M->PA4_PBONDV" 
    	If M->PA4_ACTDV=="S"
	    	_lRet := M->PA4_PBONDV>0 
    	Else // If M->PA4_ACTDV=="N"
	    	_lRet := M->PA4_PBONDV==0
	    Endif
	Endif
    If _cVar=="M->PA4_CANMDV" 
    	If M->PA4_ACTDV=="S"
	    	_lRet := !Empty(Alltrim(M->PA4_CANMDV))
    	ElseIf M->PA4_ACTDV$" N"
	    	_lRet := Empty(Alltrim(M->PA4_CANMDV))
	    ElseIf M->PA4_VBONDV>0
	    	_lRet := !Empty(Alltrim(M->PA4_CANMDV))
	    Endif
	Endif
    If _cVar=="M->PA4_MLDODV" 
    	If M->PA4_ACTDV=="S"
	    	_lRet := !Empty(Alltrim(M->PA4_MLDODV))
    	ElseIf M->PA4_ACTDV$" N"
	    	_lRet := Empty(Alltrim(M->PA4_MLDODV))
	    ElseIf M->PA4_VBONDV>0
	    	_lRet := !Empty(Alltrim(M->PA4_MLDODV))
	    Endif
	Endif

	// VALIDACAO DE NCC DA SEPU - VERIFICAR NECESSIADE
	/*
	dbSelectArea("SE1")
	dbOrderNickName("E1_SEPU")	//E1_FILIAL + E1_PREFIXO + E1_SEPU + E1_PARCELA + E1_TIPO
	If dbSeek(xFilial("SE1") + "SEP" + PA4->PA4_SEPU)
		_lRet := .f.
	Endif
	*/
	
Endif

RestArea(_aArea)
Return(_lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RETFORMULA�Autor  �Microsiga           � Data �  07/21/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �RETORNA FORMULA DE ACORDO COM A ROTINA                      ���
�������������������������������������������������������������������������͹��
���Uso       � DELLAVIA                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RETFORMULA
Local _cRet

If FunName()=="MATR930"
	_cRet := Substr(SF3->F3_OBSERV,10,6)
Else
	_cRet := SF2->F2_DOC
Endif                   

Return(_cRet)