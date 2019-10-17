#Include "Protheus.Ch"
#include "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA052  �Autor  �Anderson            � Data �  23/09/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � andkurt@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina utilizada para DELETAR do banco de dados registros  ���
���          � da tabela SYP que estiverem relacionados com o campo       ���
���          � A1_CODHIST do cliente padrao (Obtido do MV_CLIPAD).        ���
���          � Nao sera utilizado o dbdelete e sim uma query com o DELETE ���
�������������������������������������������������������������������������͹��
���Parametros� cParam =  Nil --> Executado via menu                       ���
���          � cParam <> Nil --> Executado via Job                        ���
���			 � cParam = Finaliza para Execu��o na Finaliza��o do Orcamento���
���			 �         	no Televendas					                  ���
�������������������������������������������������������������������������͹��
���Observacao� Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada via JOB e atraves de menu                 ���
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
//User Function DELA052(cParam)
Project Function DELA052(cParam)
//�����������������������������������������������������������������������������Ŀ
//�Inicializacao de variaveis.                                                  �
//�������������������������������������������������������������������������������
Local cQuery 	:= ""
Local _aArea 	:= {}
Local _aAlias	:= {}
Local _cCliPad	:= Alltrim(GetMv("MV_CLIPAD"))

// Se Cliente Padrao em Branco
If Empty(_cCliPad)
	
	If cParam <> Nil
		If cParam <> "FINALIZA"
			ConOut("Cliente Padrao em Branco, verifique com o TI !!!")
		Endif
	Else
		Aviso("Aten��o !","Cliente Padrao em Branco, verifique com o TI !!!",{'Ok'} )
	EndIf
	
	Return
	
EndIf

// Abre as Tabelas para ser usado via JOB
If cParam <> Nil
	If cParam <> "FINALIZA"
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "DELA052" TABLES "SA1","SYP"
	EndIf
Else
	If !MsgNoYes("Elimina registros de historicos do Cliente Padrao: " + _cCliPad + " ?", "Pergunta")
		Return
	EndIf
EndIf

P_CtrlArea(1,@_aArea,@_aAlias,{"SA1","SYP"}) // GetArea

DbSelectArea("SA1")
DbSetOrder(1)
If !DbSeek(xFilial("SA1")+_cCliPad)
	
	If cParam == Nil // Executado via menu
		Aviso("Aviso!","Cliente Padrao NAO Encontrado !!!",{'Ok'} )
	Else
		If cParam <> "FINALIZA"
			ConOut("Cliente Padrao NAO Encontrado !!!")
		EndIf
	EndIF
	
	Return
	
EndIf

#IFDEF TOP
	cQuery := "DELETE FROM " + RetSQLName("SYP")			"
	cQuery += " WHERE YP_FILIAL = '" + xFILIAL("SYP") + "'	"
	cQuery += " AND YP_CHAVE = '" + SA1->A1_CODHIST + "'	"
	//  Comentado por Marcelo Alcantara
	//	cQuery += " AND D_E_L_E_T_ <> '*'					"
//	Begin Transaction
	TcSqlExec(cQuery)
//	End Transaction
	
	// Grava Data e Hora da ultima limpeza do arquivo SYP efetuada pelo JOB. - Marcelo Alcantara
	if cParam <> Nil .and. cParam <> "FINALIZA"
		PutMv( "MV_LIMPSYP", DtoC(Date()) + " - " + Time() )
	endif
	
#ELSE
	// Linha incluida pois o Compilador entendeu que esta variavel nunca foi usada
	// e impediu a Compilacao
	cQuery := cQuery
	If cParam == Nil // Executado via menu
		Aviso("Aten��o !","Rotina s� pode ser rodada com o SGBD Relacional (TOP) - Contate o Dpto. de TI !!!",{'Ok'} )
	EndIf
#ENDIF

If cParam == Nil // Executado via menu
	Aviso("Fim !","Rotina executada com sucesso !!!",{'Ok'} )
Else
	If cParam <> "FINALIZA"
		ConOut("DELA052 - FIM DO PROCESSO DE ELIMINACAO DE REGISTROS DO SYP")
	EndIF
EndIF

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return()
