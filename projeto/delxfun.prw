#include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CtrlArea บAutor  ณRicardo Mansano     บ Data ณ  18/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Project Function auxiliar no GetArea e ResArea retornando  บฑฑ
ฑฑบ          ณ o ponteiro nos Aliases descritos na chamada da Funcao.     บฑฑ
ฑฑบ          ณ Exemplo:                                                   บฑฑ
ฑฑบ          ณ Local _aArea  := {} // Array que contera o GetArea         บฑฑ
ฑฑบ          ณ Local _aAlias := {} // Array que contera o                 บฑฑ
ฑฑบ          ณ                     // Alias(), IndexOrd(), Recno()        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ // Chama a Funcao como GetArea                             บฑฑ
ฑฑบ          ณ P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ // Chama a Funcao como RestArea                            บฑฑ
ฑฑบ          ณ P_CtrlArea(2,_aArea,_aAlias)                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nTipo   = 1=GetArea / 2=RestArea                           บฑฑ
ฑฑบ          ณ _aArea  = Array passado por referencia que contera GetArea บฑฑ
ฑฑบ          ณ _aAlias = Array passado por referencia que contera         บฑฑ
ฑฑบ          ณ           {Alias(), IndexOrd(), Recno()}                   บฑฑ
ฑฑบ          ณ _aArqs  = Array com Aliases que se deseja Salvar o GetArea บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Generica.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบMarcio Domณ20/08/06ณ      ณAdicionada funcao VldCupom               	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)
Local _nN

// Tipo 1 = GetArea()
// Tipo 2 = RestArea()
If _nTipo == 1
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ   Salvando Area   - Inicio    ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	_aArea   := GetArea()
	For _nN  := 1 To Len(_aArqs)
		dbSelectArea(_aArqs[_nN])
		AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})
	Next
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ   Salvando Area  - Fim        ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
Else
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ   Restaurando Area   - Inicio ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	For _nN := 1 To Len(_aAlias)
		dbSelectArea(_aAlias[_nN,1])
		dbSetOrder(_aAlias[_nN,2])
		dbGoto(_aAlias[_nN,3])
	Next
	RestArea(_aArea)
	//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ   Restaurando Area   - Fim    ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VALVEIC  บAutor  ณCarlos R. Abreu Jr  บ Data ณ  24/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ - Valida relacionamento entre Marca e Modelo do veiculo    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lTEM = .T. (Aceita a digitacao do modelo)                  บฑฑ
ฑฑบ          ณ        .F. (Nao aceita a digitacao do modelo)              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada na validacao de usuario dos campos:       บฑฑ
ฑฑบ          ณ  LQ_CODMOD                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Sintaxe:                                                   บฑฑ
ฑฑบ          ณ  X3_VLDUSER = P_VALVEIC()                                  บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Project Function ValVeic()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializacao de Variaveis                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lTEM := .F.

DbSelectArea("PA1") // CADASTRO DE MODELOS
DbSetOrder(1) //PA1_FILIAL+PA1_COD

if !Empty(M->LQ_CODMOD)
	if DBSeek(xFilial("PA1")+M->LQ_CODMOD)
		if PA1->PA1_CODMAR==M->LQ_CODMAR
			lTEM := .T.
		else
			Aviso("Aten็ใo !!!","Selecione um veiculo da marca "+Alltrim(M->LQ_DSCMAR)+" !!!",{" << Voltar"},2,"Modelo do Veํculo !")
		Endif
	else
		Aviso("Aten็ใo !!!","Nao existe esse veiculo !!!",{" << Voltar"},2,"Modelo do Veํculo !")
	EndIf
else
	lTEM := .T.
Endif

Return(lTEM)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMargemMediaบAutor ณRicardo Mansano     บ Data ณ  31/05/05   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Calcula Valor de Despesa e % Margem Media do produto.      บฑฑ
ฑฑบ          ณ As despesas estao cadastradas na tabela PAD.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cProduto   := Codigo do Produto							  บฑฑ
ฑฑบ          ณ cLocal 	  := Armazem									  บฑฑ
ฑฑบ          ณ nQuant	  := Quantidade									  บฑฑ
ฑฑบ          ณ cTipoVenda := L1_TIPOVND	--> A=Atacado ; T=Truck ;         บฑฑ
ฑฑบ          ณ                              V=Varejo  ; R=Rodas ; F=Frota บฑฑ
ฑฑบ          ณ nVlrItem   := Valor do Item (Unitario * Quant)			  บฑฑ
ฑฑบ          ณ cLoja      := Loja da Venda (pode ser Nil)    			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ aRet[1] := % Margem Media do produto.                      บฑฑ
ฑฑบ          ณ aRet[2] := Valor total de Despesas do produto              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Generica.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ A regra para calculo da Margem Bruta ้:					  บฑฑ
ฑฑบ          ณ Valor Margem Bruta = (Valor Unitแrio * Qtde) - 			  บฑฑ
ฑฑบ          ณ (Soma das despesas) - (Custo m้dio unitแrio * Qtde)		  บฑฑ
ฑฑบ          ณ 														  	  บฑฑ
ฑฑบ          ณ % Margem Bruta = Valor Margem Bruta						  บฑฑ
ฑฑบ          ณ                  -------------------------  *  100		  บฑฑ
ฑฑบ          ณ                  (Valor Unitแrio * Qtde)					  บฑฑ
ฑฑบ          ณ 															  บฑฑ
ฑฑบ          ณ O % Margem Bruta deve ser arredondado para cima			  บฑฑ
ฑฑบ          ณ 															  บฑฑ
ฑฑบ          ณ Valor total das despesas =								  บฑฑ
ฑฑบ          ณ    Soma(((Valor Unitario*Qtde)*%de cada despesa)/100 )     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบBenedet   ณ27/09/05ณ      ณInclusao de regra de excecao Rini.       	  บฑฑ
ฑฑบM Alcantarณ25/11/05ณ      |Foi alterado a regra de calculo de despesas บฑฑ
ฑฑบ          ณ        ณ      |de MM para quando fot tipo de produto RODA  บฑฑ
ฑฑบ          ณ        ณ      |pegar a mesma regra da pasta(1) Acessorios, บฑฑ
ฑฑบ          ณ        ณ      |conf. solicitacao de Rodrigo e Marcos Paulo บฑฑ
ฑฑบ          ณ        ณ      |e autorizado por Marcos Dia 25/11/05  	  บฑฑ                              
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica a Pasta correta do produto na Tabela de Despesas           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ณ cPasta	  := Pasta BM_TIPOPRD --> A=Acessorio --> Pasta 1 			ณ
//ณ        	  := Pasta BM_TIPOPRD --> P=Pneu      --> Pasta 2 			ณ
//ณ        	  := Pasta BM_TIPOPRD --> S=Servico   --> Pasta 3			ณ
//ณ        	  := Pasta BM_TIPOPRD --> R=Roda      --> Pasta 3			ณ
//ณ        	  := Pasta BM_TIPOPRD --> R=Roda      --> Pasta 1 (Foi Alte ณ
//ณ        	  rado para roda perag regra de acessorio segundo solicita  ณ
//ณ        	  citacao de Rodrigo e Marcos Paulo autorizado por Marcos P.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
cTipoPrd := RetField("SB1", 1, xFilial("SB1") + cProduto, "B1_GRUPO")
cTipoPrd := AllTrim(RetField("SBM", 1, xFilial("SBM") + cTipoPrd, "BM_TIPOPRD"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica regra de excecao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FiltMod  บAutor  ณPaulo Benedet          บ Data ณ  06/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Faz o filtro da consulta padrao marca x modelo                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - Item vai para consulta                           บฑฑ
ฑฑบRetorno   ณ        .F. - Item nao vai para consulta                       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada no item 6 do SXB da consulta FS7             บฑฑ
ฑฑบ          ณ Eg. P_FiltMod                                                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณApagaReserบAutor  ณPaulo Benedet          บ Data ณ  06/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Apaga reservas do orcamento sigaloja.                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cLojSL1 - Codigo da loja                                      บฑฑ
ฑฑบ          ณ cNumSL1 - Numero do orcamento sigaloja                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada no ponto de entrada TMKVDC.                  บฑฑ
ฑฑบ          ณ Eg. P_ApagaReser(SL1->L1_FILIAL, SL1->L1_NUM)                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtualMM    บAutor  ณCarlos R. Abreu      บ Data ณ  07/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualizar margem media na Venda Assistida                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ nRet - Valor da margem media                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelos gatilhos: LR_DESC, LR_VALDESC          บฑฑ
ฑฑบ          ณ Eg: Dominio : LR_PRODUTO                                      บฑฑ
ฑฑบ          ณ     Cont Dom: LR_MM                                           บฑฑ
ฑฑบ          ณ     Tipo    : Primario                                        บฑฑ
ฑฑบ          ณ     Regra   : P_AtualMM()                                     บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNCCSEPU   บAutor  ณMarcelo Gaspar         บ Data ณ  11/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gerna Titulo de NCC para SEPU.                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _nFuncao  -> 3 = Inclusao                                     บฑฑ
ฑฑบ          ณ              4 = Alteracao                                    บฑฑ
ฑฑบ          ณ _cFilial  -> Filial                                           บฑฑ
ฑฑบ          ณ _cNumTit  -> No do Titulo                                     บฑฑ
ฑฑบ          ณ _cPref    -> Prefixo do Titulo                                บฑฑ
ฑฑบ          ณ _cTipoTit -> Tipo do Titulo                                   บฑฑ
ฑฑบ          ณ _nVlrSEPU -> Valor do Titulo                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lmsErroAuto -> .T. = Gerou o Titulo                           บฑฑ
ฑฑบ          ณ lmsErroAuto -> .F. = Nao Gerou o Titulo                       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ                                                               บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function NCCSEPU(_nFuncao,_cFilial,_cNumTit,_cPref,_cTipoTit,_nVlrSEPU)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local   aVetor    		:= {}        // Dad`os do Execauto
Local   _dDtVenc    	:= dDataBase // Data de Vencimento do Titulo
Local   _cFilAnt        := cFilAnt   // Salva conteudo da variavel padrao do sistema
Local   _lOK            := .T.
Local	cQuery			:= ""		// Query para reserva de numero no SE1
Local	cE1Num			:= ""		// Proximo numero disponivel no SE1

Private lmsErroAuto		:= .F.       // Variavel obrigatoria para uso do Execauto

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Troco o conteudo de cFilAnt para a filial corrente do titulo, por   ณ
//ณ causa da consistencia feita no FINA040 								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFilAnt := IIf(Empty(_cFilial), cFilAnt, _cFilial)

If _nFuncao == 3	//Inclusao
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณReserva o proximo codigo livre para a insercaoณ
	//ณde NCC's com o prefixo 'SEP'.                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤIMPORTANTEฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Na chamada desta funcao tem que estar posicionado no PA4            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Retorno o valor padrao de cFilAnt                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFilAnt := _cFilAnt

Return(_lOK)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณFormataCgcบ Autor ณ Ricardo Mansano       บ Data ณ  14/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Formata o parametro como CNPJ ou CPF.                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cCgc -> Numero a ser formatado                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Se Len(cCGC)=14 --> Formata como CNPJ                         บฑฑ
ฑฑบ          ณ Se Len(cCGC)#14 --> Formata como CPF                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Generica.                                                     บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DCalcEst บAutor  ณRicardo Mansano     บ Data ณ  21/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina faz chamada ao SaldoSB2() posicionando o B2 de      บฑฑ
ฑฑบ          ณ acordo com os parametros.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _cFilial = Filial                                          บฑฑ
ฑฑบ          ณ cProduto = Produto                                         บฑฑ
ฑฑบ          ณ cLocal   = Armazem                                         บฑฑ
ฑฑบ          ณ lMsg     = T = Mostra mensagem de erro                     บฑฑ
ฑฑบ          ณ            F = Nao mostra mensagem de erro                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ nRet := Saldo Disponivel em SB2                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Generica.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DCalcEst(_cFilial,cProduto,cLocal,lMsg)
Local nRet := 0
Local _aArea   		:= {}
Local _aAlias  		:= {}
Default lMsg := .T.

P_CtrlArea(1,@_aArea,@_aAlias,{"SB2"}) // GetArea

SB2->(DbSetOrder(1)) // B2_FILIAL + B2_COD + B2_LOCAL
If SB2->( DbSeek(_cFilial+cProduto+cLocal) )
	nRet := SaldoSb2() // Esta fun็ใo pega o B2 posicionado
Else
	If lMsg
		Aviso("Aten็ใo !!!","Produto: "+AllTrim(cProduto)+"/"+AllTrim(cLocal)+" nใo localizado na tabela de Saldos (SB2)!!!",{" << Voltar"},2,"Modelo do Veํculo !")
	EndIf
Endif

P_CtrlArea(2,_aArea,_aAlias) // RestArea
Return(nRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuSeqL4 บAutor  ณRicardo Mansano     บ Data ณ  27/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualiza o campo L4_SEQ. Por que na atualizacao do Server  บฑฑ
ฑฑบ          ณ Loja para o Matriz se existir mais de um registro no SL4   บฑฑ
ฑฑบ          ณ com o mesmo L4_NUM, a rotina de atualizacao sobrepoe e so  บฑฑ
ฑฑบ          ณ fica gravado o ultimo registro, pois os registros tem a    บฑฑ
ฑฑบ          ณ mesma chave principal.                                     บฑฑ
ฑฑบ          ณ Agora a rotina de atualizacao enxerga apenas o Order 3 do  บฑฑ
ฑฑบ          ณ SL4, que eh: L4_FILIAL + L4_NUM + L4_ORIGEM + L4_SEQ       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica.                                             บฑฑ
ฑฑบ          ณ cFilial := Filial da Vendas                                บฑฑ
ฑฑบ          ณ cNum    := Numero do Orcamento                             บฑฑ
ฑฑบ          ณ cOrigem := Origem TeleVendas->SIGATMK                      บฑฑ
ฑฑบ          ณ            VendaAssistida->Em Branco                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ - PE LJ7002  no Venda Assistida.                           บฑฑ
ฑฑบ          ณ - PE TMKVFIM no TeleVendas                                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ MontaCred       บAutor ณ Paulo Benedet       บData ณ 28/06/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Grava limite credito / data                                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pelo ponto de entrada CRD010PG                 บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณCNPJCPF          บAutor ณNorbert Waage Junior บData ณ 29/06/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณRotina para geracao do codigo/loja pelo CNPJ/CGC               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcCGC  - CGC/CNPJ do cliente                                    บฑฑ
ฑฑบ          ณcLoja - Loja do cliente, caso esta ja esteja preenchida        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณcCodigo - Codigo do cliente quando nao informada a loja        บฑฑ
ฑฑบ          ณaCodigo - Array com codigo e loja, quando informada a loja     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada via gatilho no campo A1_CGC ou via rotina       บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function CNPJCPF(cCGC,cLoja)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Conv1    บAutor  ณ Marcelo Gaspar     บ Data ณ  01/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que converte numeros em letras(base 35)             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Conv1(y)
Return AllTrim(IIf(y<10,Str(y),Chr(y+55)))



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ WHNVRUNI        บAutor ณ Paulo Benedet       บData ณ 04/07/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Liberar acesso ao campo LR_VRUNIT                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRer - T - Permite a edicao do campo                          บฑฑ
ฑฑบ          ณ        F - Nao permite a edicao do campo                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada pelo X3_WHEN do campo LR_VRUNIT                บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNaPilha   บAutor  ณNorbert Waage Juniorบ Data ณ  15/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ norbert@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณVarre a pilha de chamadas em busca do parametro recebido.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcFuncao - Nome da rotina a ser pesquisada                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet = .T. (Foi encontrada na pilha)                       บฑฑ
ฑฑบ          ณ        .F. (Nao foi encontrada)                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Generica                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelReservaบ Autor ณNorbert Waage Juniorบ Data ณ  21/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de cancelamento de reservas                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina acionada antes de gravar a venda, para que a reservaบฑฑ
ฑฑบ          ณ seja liberada para a emissao da NF.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Della Via Pneus                                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                   	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelReserva()

Local aArea 	:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSC0	:= SC0->(GetArea())
Local _cNum 	:= M->LQ_NUM

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSomente na grava็ใo da vendaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CalcVSeg บAutor  ณNorbert Waage Junior   บ Data ณ  23/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCalcula totais a serem pagos pela corretora e seguradora       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnTotCorr - Total pago pela corretora                           บฑฑ
ฑฑบ          ณnTotSeg  - Total pago pela seguradora                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelo bocao Condic.Pagamento                     บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre tabela de segurosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA8")
DbSetOrder(6) //PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre os itens da venda                                 ณ
//ณObs.: Ao inves de percorrer o SL2, percorro o aCols, pois oณ
//ณcampo L2_VLRITEM pode ter seu valor alterado antes da      ณ
//ณgravacao, quando usa-se uma NCC, por exemplo.              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(aCols)
	
	If !Empty(aCols[nX][nPosApo]) .And. !ATail(aCols[nX]) .And.;
		PA8->(DbSeek(xFilial("PA8")+aCols[nX][nPosApo]+ M->(LQ_CLIENTE+LQ_LOJA) + aCols[nX][nPosItApo]))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCalcula diferenca e percentuais a serem pagos pela seguradoraณ
		//ณe pela corretora                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTrata arredondamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nTotCorr	:= Round(nTotCorr,nDecimais)
nTotSeg		:= Round(nTotSeg ,nDecimais)

RestArea(aAreaPA8)
RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLjRodape  บAutor  ณNorbert Waage Junior   บ Data ณ  27/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para atualizacao da mensagem do rodape informativo dos  บฑฑ
ฑฑบ          ณtotais da venda.                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada para atualizar o rodape, como gatilho ou codigo บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function LjRodape(cCondPg)

Local aArea		:= GetArea()
Local nTotCorr	:= 0
Local nTotSeg	:= 0
Local nParc		:= 0
Local cDescCP	:= ""
Local nValPago	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObtem condicao de pagamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cCondPg)
	If !Empty(_cD020CPG)
		cCondPg	:=	_cD020CPG
	Else
		cCondPg	:=	GetAdvFVal("PAF","PAF_CONDPG",xFilial("PAF")+cFilAnt+M->LQ_TIPOVND,1,Space(TamSX3("E4_CODIGO")[1]))
	EndIf
EndIf

cDescCP	:= Space(10) + cCondPg + " - " + AllTrim(Posicione("SE4",1,xFilial("SE4")+cCondPg,"E4_DESCRI"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula totais da corretora e seguradoraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P_CalcVSeg(@nTotCorr,@nTotSeg)

nValPago := Lj7T_TOTAL( 2 ) - nNCCUsada - (nTotSeg+nTotCorr)
nValPago := IIf( nValPago > 0, nValPago, 0 )                               

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObtem a quantidade de parcelasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nParc := Len(Condicao( nValPago, cCondPg ))//Len(P_Lj7CondPg( 2, cCondPg ))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza o rodapeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Lj7R_Rodape(cDescCP + Space(10) + "TOTAL DA VENDA:  " + AllTrim(Str(nParc)) + "  X  " +;
Alltrim(Transform((nValPago/nParc),"@E 9,999,999.99")) +;
Iif((nTotSeg+nTotCorr)>0,;
Space(10) +	"BONIFICACAO DO CLIENTE: " + Alltrim(Transform((nTotSeg+nTotCorr),"@E 9,999,999.99")),""))

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltTes    บAutor  ณNorbert Waage Junior   บ Data ณ  01/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de troca inteligente de TES, a partir do tipo de opera- บฑฑ
ฑฑบ          ณcao informado.                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณlTodos - (.T.) Indica que todos os itens serao recalculados    บฑฑ
ฑฑบ          ณ         (.F.) Indica que apenas o item atual sera recalculado บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada a partir de gatilhos e funcoes internas         บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณO padrao de execucao eh para a linha atualณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Default lTodos := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConfigura variaveis para execucao unica ou para todos osณ
//ณitens da venda                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nInicial	:= Iif(lTodos,1,N)
nFinal		:= Iif(lTodos,Len(aCols),N)

//Sai da rotina na visualizacao
If !Altera .And. !Inclui
	Return Nil
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Solucao paleativa para a nao alteracao do codigo do cliente no array fiscal ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetTpOp   บAutor  ณNorbert Waage Junior   บ Data ณ  02/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRetorna o tipo de operacao do produto                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcCliente - Codigo do cliente                                   บฑฑ
ฑฑบ          ณcLoja    - Loja do Cliente                                     บฑฑ
ฑฑบ          ณcProduto - Codigo do produto                                   บฑฑ
ฑฑบ          ณcTipoCli - Tipo da entidade: C= Cliente(Default); F= Fornecedorบฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณcTpOp - Tipo da operacao                                       บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada a partir de gatilhos e funcoes internas         บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkTpOp   บAutor  ณNorbert Waage Junior   บ Data ณ  03/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina de validacoes referentes aos tipos de operacao          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณlRet   - (.T.) Validacoes ok                                   บฑฑ
ฑฑบ          ณ         (.F.) Problemas em alguma validacao                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina executada na confirmacao da venda/orcamento no PE LJ7001บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerificacao dos dados da vendaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida quantidades dos grupos de tributacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If  (nGrp1 > 0) .And. ( nGrp1 != nGrp2 )

	lRet :=  .F.

	cMsg := "A quantidade de itens do grupo tributแrio 001 com tipo de opera็ใo 03 ้ diferente da quantidade " +;
			"de itens do grupo tributแrio " + GetMV("FS_DEL039")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se existem produtos do mesmo grupo de tributacaoณ
//ณcom tipos de opera็ใo diferentes                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	
	//Percorre os grupos
	For nX := 1 to Len(aGrupos)
		
		//Se houver mais de um tipo de operacao por grupo
		If Len(aGrupos[nX][2]) > 1
			
			lRet := .F.
			cMsg := "Nใo ้ permitida a venda de produto do mesmo Grupo de Tributa็ใo com Tipos de Opera็ใo "+;
					"diferentes"
			nX := Len(aGrupos) + 1
			
		EndIf
		
	Next nX

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o cliente eh isentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lIsento := Empty(aCliente[1]) .Or. "ISENT" $ Upper(aCliente[1])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida grupos de tributacao para clientes fora do estadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet .And. !( lIsento ) .And. ( AllTrim(Upper(aCliente[2])) != cEstado )
	
	//Verifica se existem itens do grupo 001
	If ( nPos := AScan(aGrupos,{|x| x[1] == "001"}) ) != 0 
		
		//Verifica se existem itens do grupo 001 com tipo de operacao 01
		If ( AScan(aGrupos[nPos][2],{|x| x = "01"}) != 0 )
			
			//Verifica se ha itens do grupo 016
			If !(lRet := ( AScan(aGrupos,{|x| x[1] == "016"}) ) == 0)
			
				cMsg := "Nใo ้ permitida a venda de itens com grupo de tributa็ใo 016 para clientes de fora "+;
						"do estado quando jแ foram adicionados itens do grupo de tributa็ใo 001, com tipo de"+;
						" opera็ใo 01."
									
			EndIf
			
		EndIf
		
	EndIf

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida tipo de operacao de doacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet

	nX := 1

	//Se a condicao de pagamento e do tipo doacao, todos os itens devem ter tipo de operacao Doacao
	If ( AllTrim(Upper(_cD020CPG)) == AllTrim(Upper(GetMv("FS_DEL012"))) )
	
		//Varre aCols, verificando se ha itens com tipo de operacao diferente do tipo Doacao
		While (nX <= nLenAC) .And. ( lRet := (AllTrim(aCols[nX++][nPosTpOp]) == cDoacao) ) //Doacao
		EndDo	

		If !lRet
			cMsg := "Para utilizar a condi็ใo de pagamento do tipo Doa็ใo, todos os itens ser do tipo de opera็ใo"+;
			 		"Doa็ใo."
		EndIf
		
	Else      
	
	    //Verifica se exitem itens de doacao
		While (nX <= nLenAC) .And. !( lTipo17 := (AllTrim(aCols[nX++][nPosTpOp]) == cDoacao) ) //Doacao
		EndDo	
		
		If lTipo17 
			lRet := .F.
			cMsg := "Um ou mais itens desta venda ้ do tipo Doa็ใo. Para utilizar doa็๕es, todos os itens devem "+;
					"ser do tipo Doa็ใo, assim como a condi็ใo de pagamento."
		EndIf

	EndIf

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe houve erro, exibe a mensagemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cMsg)
	ApMsgAlert(cMsg,"Tipo de Opera็ใo")
EndIf

Restarea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหออออออัอออออออออออออออออออออหอออออัออออออออออปฑฑ
ฑฑบPrograma  ณ DISTRCLI        บAutor ณ Paulo Benedet       บData ณ 05/08/05 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสออออออฯอออออออออออออออออออออสอออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Atualizar os tipos de saidas na troca de cliente.             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ T - sempre                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Funcao chamada na validacao dos campos LM_CLIENTE, LM_LOJA    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOrdParcs  บAutor  ณNorbert Waage Junior   บ Data ณ  31/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณOrdena parcelas de pagamento do Venda Assistida                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina utilizada para ordenar array de pagamentos, deixando o  บฑฑ
ฑฑบ          ณpagamento em especie em primeiro, na tela do Venda Assistida.  บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function OrdParcs()

Local nPos
Local lVisuSint	:= If( SL4->(FieldPos("L4_FORMAID")) > 0, .T., .F. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณOrdena vetorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
If lVisuSint
	//aSort(aPgtos,,,{|x,y| x[3]+x[8]+Dtos(x[1]) < y[3]+y[8]+Dtos(y[1]) } ) //Condicao + Seq + Data
	aSort(aPgtos,,, {|x, y| DtoS(x[1]) + x[3] + x[8] < DtoS(y[1]) + y[3] + y[8]}) // Data + Form Pag + Seq
Else
	aSort(aPgtos,,,{|x,y|DtoS(x[1])+IIf(AllTrim(x[3]) $ MVCHEQUE,"Z","A") <;
						 DtoS(y[1])+IIf(AllTrim(y[3]) $ MVCHEQUE,"Z","A")}) //Data
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ A Forma $ sempre sera a primeira!!!  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNotifDP   บAutor  ณNorbert Waage Junior   บ Data ณ  12/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณNotifica o usuario sobre o uso de duplicatas                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaParc - Array que contem as parcelas                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada a partir da alteracao das parcelas ou da condi-บฑฑ
ฑฑบ          ณcao de pagamento na venda assistida.                           บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
		ApMsgAlert("Para pagamentos do tipo DP ้ necessแrio emitir a Nota Fiscal sobre o cupom.", "Forma de Pagamento")
	EndIf
	
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetStatFinบAutor  ณNorbert Waage Junior   บ Data ณ  15/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณStatus financeiro do cliente                                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcCliente - Codigo do Cliente                                   บฑฑ
ฑฑบ          ณcLoja    - Loja do Cliente                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณaRet     - Array com situacoes de bloqueio do cliente:         บฑฑ
ฑฑบ          ณ           1- Cheques Devolvidos                               บฑฑ
ฑฑบ          ณ           2- Lucros e Perdas                                  บฑฑ
ฑฑบ          ณ           3- Cobrancas de terceiros                           บฑฑ
ฑฑบ          ณ           4- Titulos Protestados                              บฑฑ
ฑฑบ          ณ           5- Pagamento em cartorio                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina de uso generico                                         บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ--Estrutura do array aRet--                  ณ
//ณ1 = Cheques devolvidos                       ณ
//ณ2 = Lucros / Perdas                          ณ
//ณ3 = Cobranca de terceiros                    ณ
//ณ4 = Titulos protestados                      ณ
//ณ5 = Pagamento em cartorio                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If DbSeek(cFilSE1+cCliente+cLoja)

	While !Eof() 				.And.;
	SE1->E1_FILIAL == cFilSE1	.And.;
	SE1->E1_CLIENTE == cCliente	.And.;
	SE1->E1_LOJA == cLoja
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAnalise de cheques devolvidosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParChDev) .And. (SE1->E1_SALDO > 0)

			aRet[1][1]++
			aRet[1][2]+= SE1->E1_SALDO

		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAnalise de Lucros / Perdas   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParLeP) .And. (SE1->E1_SALDO == 0)

			aRet[2][1]++
			aRet[2][2]+= SE1->E1_VALOR

		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAnalise de cobranca de 3os.  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParTerc)

			aRet[3][1]++
			aRet[3][2]+= SE1->E1_SALDO

		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAnalise de titulos protestadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (AllTrim(Upper(SE1->E1_PORTADO)) $ cParTitPr)

			aRet[4][1]++
			aRet[4][2]+= SE1->E1_SALDO

		EndIf
		
		DbSkip()

	End

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAnalise de pagamentos em cartorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldCupom บAutor  ณMarcio Domingos     บ Data ณ  11/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ User Function para validar:                                บฑฑ
ฑฑบ          ณ 1) Impressao de cupom no m๓dulo Venda Assistida;           บฑฑ
ฑฑบ          ณ 2) Gera็ใo de pedidos no Call Center;                      บฑฑ
ฑฑบ          ณ 3) Gera็ใo de pedidos no Televendas;                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _nOpc   = 1=Cupom / 2= Nota Fiscal (Venda Assistida)       บฑฑ
ฑฑบ          ณ                   / 2= Pedido (Televendas e Pedido Vendas) บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ _lRet   = .T. / .F.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Generica.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VldCupom(_nOpc,cCliente,cLoja)
Local _lRet 	:= .T.
Local _aArea	:= GetArea()             

If FunName() == "LOJA701"

	If _nOpc == 1
	
		// Cupom Fiscal
		// O sistema NAO deve permitir a emissao do cupom fiscal nas seguintes condicoes:
	
		// Condicao 1 : Cliente pessoa jurํdica e com inscricao estadual e fora do estado.
		If SA1->A1_PESSOA == "J" .And. !Empty(SA1->A1_INSCR) .And. Rtrim(SA1->A1_INSCR) <> "ISENTO" .And. SA1->A1_EST <> GetMv("MV_ESTADO")
			ApMsgAlert("Nใo ้ permitido finalizar vendas com cupom para cliente pessoa Juridica / Fora do Estado !","Aten็ใo !")
			_lRet	:= .F.
		Endif
		
		If _lRet
			//Condicao 2 : Cliente pessos juridica e tipo revendedor
			If SA1->A1_PESSOA = "J" .And. SA1->A1_TIPO = "R"                                             
				ApMsgAlert("Nใo ้ permitido finalizar vendas com cupom para cliente pessoa Juridica / Revendedor !","Aten็ใo !")
				_lRet	:= .F.
			Endif
		Endif	
		
	ElseIf _nOpc == 2	
			// Nota Fiscal
			// Cliente pessoa fisica e tipo consumidor final			                                
			If SA1->A1_PESSOA = "F" .And. SA1->A1_TIPO = "F"
				ApMsgAlert("Nใo ้ permitido finalizar vendas com Nota Fiscal para cliente Pessoa Fisica / Consumidor !","Aten็ใo !")
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
					ApMsgAlert("Nใo ้ permitido gerar pedidos para cliente pessoa fํsica e cosumidor final.","Aten็ใo !")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ Lj7ZeraPgtos บAutor ณ Paulo Benedet      บ Data ณ 28/08/07 บฑฑ
ฑฑฬออออออออออุออออออออออออออสออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Limpar objetos da condicao negociada                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Somente dentro da venda assistida                          บฑฑ
ฑฑบ          ณ Esta funcao eh uma componentizacao da funcao padrao de     บฑฑ
ฑฑบ          ณ mesmo nome                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via Pneus                                            บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณZera as variaveis da condicao de pagamento                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
M->LQ_CONDPG := Space(nTamLQ_CON)
cDescCondPg	:= Space(nTamE4_DES)
cCondSE4 := ""
oCondPg:Refresh()
oDescCondPg:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Zera o desconto no total apenas se foi informado depois da condicao ณ
//ณ de pagamento                                                        ณ
//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
//ณ Identifica em que momento foi dado o desconto no total              ณ
//ณ aDesconto[1] := 0	// Nao tem desconto                             ณ
//ณ aDesconto[1] := 1	// Antes da condicao de pagamento               ณ
//ณ aDesconto[1] := 2	// Depois da condicao de pagamento              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aDesconto[1] == 2
	LJ7T_Total( 2, Lj7T_Subtotal(2) - Lj7T_DescV(2) )
	Lj7T_DescV( 2, 0 )
	Lj7T_DescP( 2, 0 )
	Lj7T_Total( 2, Lj7T_Subtotal(2) )
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta o Valor das Parcelas e o Valor do Troco                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Lj7AjustaTroco()		

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ajusta os valores de PIS/COFINS caso Haja                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ vldsep   บAutor  ณ Eder Oliveira      บ Data ณ  06/30/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ validacoes do SEPU                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	    	MsgAlert("SEPU ja usado nใo pode ser alterado!")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETFORMULAบAutor  ณMicrosiga           บ Data ณ  07/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRETORNA FORMULA DE ACORDO COM A ROTINA                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DELLAVIA                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RETFORMULA
Local _cRet

If FunName()=="MATR930"
	_cRet := Substr(SF3->F3_OBSERV,10,6)
Else
	_cRet := SF2->F2_DOC
Endif                   

Return(_cRet)