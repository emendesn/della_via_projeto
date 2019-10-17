#include "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA033   �Autor  �Norbert Waage Junior   � Data �  29/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de troca de codigo de codigo de clientes, respeitando os���
���          �parametros informados pelo cliente                             ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo menu SIGALOJA.XNU especifico               ���
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
Project Function DELA033()

Local aSay		:=	{}
Local aButton	:=	{}
Local lOk		:=	.F.
Local cPerg		:=	"DEL033"

ValidPerg(cPerg)

//���������������������������Ŀ
//�Texto explicativo da rotina�
//�����������������������������
aAdd( aSay, "Esta rotina tem por objetivo efetuar a troca do c�digo dos clientes especificados" )
aAdd( aSay, "nos par�metros informados pelo usuario.                                          " )
aAdd( aSay, "O c�digo do cliente ser� substitu�do por um c�digo gerado a partir de seu CNPJ ou" )
aAdd( aSay, "CPF.                                                                             " )

//������������������������Ŀ
//�Botoes da tela principal�
//��������������������������
//Parametros
aAdd( aButton, { 5,.T.,	{|| lOk := Pergunte(cPerg, .T.) }} )
//Confirma
aAdd( aButton, { 1,.T.,	{|| Iif(lOk,FechaBatch(),MsgInfo("Verifique os par�metros antes de prosseguir"))}} )
//Cancela
aAdd( aButton, { 2,.T.,	{|| (lOk := .F.,FechaBatch())}} )

//�����������Ŀ
//�Abre a tela�
//�������������
FormBatch( "Altera��o de c�digo de clientes", aSay, aButton )

//���������������������������������������������Ŀ
//�Acao executada caso o usuario confirme a tela�
//�����������������������������������������������
If lOk
	Processa({|lEnd| _AltCodA1(@lEnd)},"Aguarde","Selecionando registros...",.T.)
Endif

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_AltCodA1 �Autor  �Norbert Waage Junior   � Data �  29/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de troca de codigo de codigo de clientes                ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pela funcao DELA033                             ���
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
Static Function _AltCodA1(lEnd)

Local nX 	:= 0
Local nAlt	:= 0
Local nReg	:= 0
Local aCodNovo

//�����������������������Ŀ
//�Abre tabela de clientes�
//�������������������������
DbSelectArea("SA1")
DbSetOrder(3) //A1_FILIAL+A1_CGC
nReg := RecCount()
ProcRegua(nReg)
DbGoTop()

//������������������������������������������������Ŀ
//�Percorre SA1, salvando registros a ser alterados�
//��������������������������������������������������
While !Eof()

	IncProc("Atualizando clientes: Registro " + AllTrim(Str(++nX)) + " de " + AllTrim(Str(nReg)))

	If !Empty(SA1->A1_CGC) .And.;
		SA1->(A1_COD + A1_LOJA) >= mv_par01 + mv_par02 .And.;
		SA1->(A1_COD + A1_LOJA) <= mv_par03 + mv_par04

		aCodNovo := P_CNPJCPF(SA1->A1_CGC,SA1->A1_LOJA)
        
        If SA1->A1_COD != aCodNovo[1]
			//��������������Ŀ
			//�Grava registro�
			//����������������
			If SA1->(A1_COD + A1_LOJA) != (aCodNovo[1] + aCodNovo[2])
	
				RecLock("SA1",.F.)
				SA1->A1_COD 	:= aCodNovo[1]
				SA1->A1_LOJA	:= aCodNovo[2]
				SA1->A1_PESSOA	:= IIf(Len(AllTrim(SA1->A1_CGC)) > 11 ,"J","F")
				MsUnLock()
				nAlt++
	
			EndIf
			
		EndIf 	

	EndIf

	//�������������������������������Ŀ
	//�Tratamento para o botao cancela�
	//���������������������������������
	If lEnd .And. (lEnd := ApMsgNoYes("Deseja cancelar a execu��o do processo?","Interromper"))
		Exit
	EndIf

	DbSkip()

End

ApMsgInfo("Processo encerrado, " + AllTrim(Str(nAlt)) + " registros alterados.","Altera��o de c�digo")

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Norbert Waage Junior   � Data �  29/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Validacao das perguntas                                        ���
����������������������������������������������������������������������������͹��
���Parametros�cPerg - Nome do grupo de perguntas                             ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pela funcao DELA033                             ���
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
Static Function ValidPerg(cPerg)

Local aRegs := {}

AAdd(aRegs,{cPerg,"01","Cliente de   ?","","","mv_ch1", "C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
AAdd(aRegs,{cPerg,"02","Loja         ?","","","mv_ch2", "C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"03","Cliente at�  ?","","","mv_ch3", "C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
AAdd(aRegs,{cPerg,"04","Loja         ?","","","mv_ch4", "C", 2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

LValidPerg(aRegs)

Return Nil