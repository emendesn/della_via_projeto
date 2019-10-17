#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA043  บAutor  ณAnderson Kurtinaitisบ Data ณ  12/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ andkurt@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Atraves da tela de Venda Assistida no Controle de Lojas,   บฑฑ
ฑฑบ          ณ foi agragada uma nova funcao ao botao OUTROS, a Opcao de   บฑฑ
ฑฑบ          ณ Verificar a Obs. Convenio, campos PA6_CODOBS e PA6_MEMOBS  บฑฑ
ฑฑบ          ณ O usuario ainda podera usar CTRL+P para acessar a mesma    บฑฑ
ฑฑบ          ณ funcao.                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Chamada atravez do programa LJ7016                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Project Function DELA043()

//Variaveis Locais da Funcao
Local cEdit1	 := ""
Local oEdit1

// Variaveis Private da Funcao
Private _oDlg
Private INCLUI := .F.

If Empty(M->LQ_CODCON)
	MsgAlert(OemtoAnsi("Preencha primeiro o C๓digo do Conv๊nio, verifique !"), "Aviso") 	
	Return(.T.)
Else
	// Cadastro de Convenios
	DbSelectArea("PA6")
	DbSetOrder(1)
	If !DbSeek(xFilial("PA6")+M->LQ_CODCON)
		MsgAlert(OemtoAnsi("O C๓digo do Conv๊nio nใo existe, verifique !"), "Aviso") 		
		Return(.T.)
	EndIf
EndIf

// Abastecendo aqui a variavel que sera mostrada na tela com o conteudo do Campo MEMO da Tabela PA6
cEdit1	:= MSMM(PA6->PA6_CODOBS)

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Observa็๕es do Conv๊nio") FROM C(249),C(213) TO C(424),C(736) PIXEL

	// Cria Componentes Padroes do Sistema
	@ @ C(004),C(004) GET oEdit1 VAR OemtoAnsi(cEdit1) Of _oDlg PIXEL Size C(216),C(078) READONLY MEMO
	@ C(006),C(224) Button OemtoAnsi("&Fechar") Size C(037),C(012) PIXEL OF _oDlg Action(Close(_oDlg))

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ C        บAutor  ณNorbert Waage Juniorบ Data ณ  10/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina para calculo de resolucao, utilizada para ajustar a  บฑฑ
ฑฑบ          ณtela de acordo com a resolucao utilizada no monitor         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnTam		= Valor de coordenada a ser convertido/ajustado   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณnTam		= Valor convertido                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณEsta rotina eh chamada para todas as coordenadas de tela u- บฑฑ
ฑฑบ          ณtilizada neste programa, viabilizando assim a sua execucao  บฑฑ
ฑฑบ          ณem qualquer resolucao de tela.                              บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                                 
//ณTratamento para tema "Flat"ณ                                                 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                                 
If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                            
   	nTam *= 0.90                                                               
EndIf                                                                           
Return Int(nTam)                                                                