#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA043  �Autor  �Anderson Kurtinaitis� Data �  12/08/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � andkurt@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Atraves da tela de Venda Assistida no Controle de Lojas,   ���
���          � foi agragada uma nova funcao ao botao OUTROS, a Opcao de   ���
���          � Verificar a Obs. Convenio, campos PA6_CODOBS e PA6_MEMOBS  ���
���          � O usuario ainda podera usar CTRL+P para acessar a mesma    ���
���          � funcao.                                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   �                                                            ���
�������������������������������������������������������������������������͹��
���Aplicacao � Chamada atravez do programa LJ7016                         ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Project Function DELA043()

//Variaveis Locais da Funcao
Local cEdit1	 := ""
Local oEdit1

// Variaveis Private da Funcao
Private _oDlg
Private INCLUI := .F.

If Empty(M->LQ_CODCON)
	MsgAlert(OemtoAnsi("Preencha primeiro o C�digo do Conv�nio, verifique !"), "Aviso") 	
	Return(.T.)
Else
	// Cadastro de Convenios
	DbSelectArea("PA6")
	DbSetOrder(1)
	If !DbSeek(xFilial("PA6")+M->LQ_CODCON)
		MsgAlert(OemtoAnsi("O C�digo do Conv�nio n�o existe, verifique !"), "Aviso") 		
		Return(.T.)
	EndIf
EndIf

// Abastecendo aqui a variavel que sera mostrada na tela com o conteudo do Campo MEMO da Tabela PA6
cEdit1	:= MSMM(PA6->PA6_CODOBS)

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Observa��es do Conv�nio") FROM C(249),C(213) TO C(424),C(736) PIXEL

	// Cria Componentes Padroes do Sistema
	@ @ C(004),C(004) GET oEdit1 VAR OemtoAnsi(cEdit1) Of _oDlg PIXEL Size C(216),C(078) READONLY MEMO
	@ C(006),C(224) Button OemtoAnsi("&Fechar") Size C(037),C(012) PIXEL OF _oDlg Action(Close(_oDlg))

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C        �Autor  �Norbert Waage Junior� Data �  10/05/05   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para calculo de resolucao, utilizada para ajustar a  ���
���          �tela de acordo com a resolucao utilizada no monitor         ���
�������������������������������������������������������������������������͹��
���Parametros�nTam		= Valor de coordenada a ser convertido/ajustado   ���
�������������������������������������������������������������������������͹��
���Retorno   �nTam		= Valor convertido                                ���
�������������������������������������������������������������������������͹��
���Aplicacao �Esta rotina eh chamada para todas as coordenadas de tela u- ���
���          �tilizada neste programa, viabilizando assim a sua execucao  ���
���          �em qualquer resolucao de tela.                              ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
//���������������������������Ŀ                                                 
//�Tratamento para tema "Flat"�                                                 
//�����������������������������                                                 
If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                            
   	nTam *= 0.90                                                               
EndIf                                                                           
Return Int(nTam)                                                                