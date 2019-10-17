#Include "Protheus.Ch"
#include "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DELA008A �Autor  �Ricardo Mansano     � Data �  12/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina a ser executada via Scheduler para excluir todos os ���
���          � SC0(Reservas) vinculados ao orcamento com a data de valida-���
���          � de expirada (dDatabase > L1_DTLIM), e executara o ajuste   ���
���          � em SB2(Saldos).                                            ���
�������������������������������������������������������������������������͹��
���Observacao� Rotina soh deve ser rodada no Servidor DB2 por usar Query  ���
�������������������������������������������������������������������������͹��
���Parametros� cParam =  Nil --> Executado via menu                       ���
���          � cParam <> Nil --> Executado via Job                        ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada via JOB ou menu, para excluir reservas    ���
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
Project Function DELA008A(cParam)
//�����������������������������������������������������������������������������Ŀ
//�Inicializacao de variaveis.                                                  �
//�������������������������������������������������������������������������������
Local cQuery := ""
Local _aArea := {}
Local _aAlias:= {}

// Abre as Tabelas para ser usado via JOB
If cParam <> Nil
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "DELA008" TABLES "SC0","SB2","SL1"
Else
	If !MsgNoYes("Confirma estorno de reservas?", "Pergunta")
		Return
	EndIf
EndIf

P_CtrlArea(1,@_aArea,@_aAlias,{"SC0","SB2"}) // GetArea

#IFDEF TOP

    /*
	cQuery := "SELECT DISTINCT L1_FILIAL, L1_NUM		 "
	cQuery += " FROM " + RetSqlName("SL1")+" L1,		 "
	cQuery +=            RetSqlName("SC0")+" C0			 "
	cQuery += " WHERE '"+DtoS(dDatabase)+"' > L1_DTLIM	 "
	cQuery += "  AND   L1_DOC         = ''  			 "
	cQuery += "  AND   L1_RESERVA     = 'S'  			 "
	cQuery += "  AND   L1.D_E_L_E_T_ <> '*'              "
	cQuery += "  AND   C0.D_E_L_E_T_ <> '*'              "
	cQuery += "  AND   C0_NUMORC=L1_NUM                  "
	cQuery += " ORDER BY L1_FILIAL, L1_NUM	 			 "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AliasTRB",.T.,.T.)
	*/
	
	cQuery := "SELECT DISTINCT L1_FILIAL, L1_NUM		 "
	cQuery += " FROM " + RetSqlName("SL1")+" L1			 "
	cQuery += " WHERE '"+DtoS(dDatabase)+"' > L1_DTLIM	 "
	cQuery += "  AND   L1_DOC         = ''  			 "
	cQuery += "  AND   L1_RESERVA     = 'S'  			 "
	cQuery += "  AND   L1.D_E_L_E_T_ <> '*'              "
	cQuery += " ORDER BY L1_FILIAL, L1_NUM	 			 "
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AliasTRB",.T.,.T.)

	dbSelectArea("SB2")
	dbSetOrder(1) // Filial + Codigo + Local
	
	dbSelectArea("SC0")
	dbSetOrder(3) // C0_FILIAL + C0_NUMORC + C0_PRODUTO
	
	While AliasTRB->(!Eof())
		
		ConOut("DELA008 - LIMPANDO RESERVAS DO ORCAMENTO: " + AliasTRB->L1_NUM)
		
		// Estorna Reservas em SC0
		If  SC0->( dbSeek(AliasTRB->L1_FILIAL + AliasTRB->L1_NUM ))
			While !SC0->(Eof()) .And. AliasTRB->L1_FILIAL + AliasTRB->L1_NUM == SC0->(C0_FILIAL + C0_NUMORC)
				
				Begin Transaction
				// Estorna Reservas em SB2
				If SB2->( DbSeek(AliasTRB->L1_FILIAL+SC0->C0_PRODUTO+SC0->C0_LOCAL) )
					RecLock("SB2",.F.)                                                                    
					SB2->B2_RESERVA -= SC0->C0_QTDPED
					If SB2->B2_RESERVA < 0
						SB2->B2_RESERVA	:= 0
					Endif	
					MsUnlock()
				Endif
				
				// Deleta Reserva em SC0
				RecLock("SC0",.F.)
				SC0->(dbDelete())
				MsUnLock()
				
				End Transaction
				SC0->(dbSkip())
			EndDo
			
		EndIf
		
		dbSelectArea("SL1")
		dbSetOrder(1) // L1_FILIAL + L1_NUM
		If dbSeek(AliasTRB->L1_FILIAL + AliasTRB->L1_NUM )
			RecLock("SL1",.F.)
			SL1->L1_RESERVA := "" // Campo padrao utilizado na regra que define as cores do mBrowse (LOJA701)
			MsUnLock()
		EndIf
		
		AliasTRB->(dbSkip())
	Enddo
	
	AliasTRB->(dbCloseArea())
	If cParam == Nil // Executado via menu
		Aviso("Aten��o !","Fim do Processamento !!!",{ " << Voltar " },1,"Rotina Terminada")
	EndIf
	
#ELSE
	// Linha incluida pois o Compilador entendeu que esta variavel nunca foi usada
	// e impediu a Compilacao
	cQuery := cQuery
	If cParam == Nil // Executado via menu
		Aviso("Aten��o !","Rotina s� pode ser rodada com o Servidor DB2 - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
	EndIf
#ENDIF

ConOut("DELA008 - FIM DO PROCESSO")

P_CtrlArea(2,_aArea,_aAlias) // RestArea
Return
