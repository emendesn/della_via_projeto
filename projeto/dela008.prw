#Include "Protheus.Ch"
#include "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA008A บAutor  ณRicardo Mansano     บ Data ณ  12/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina a ser executada via Scheduler para excluir todos os บฑฑ
ฑฑบ          ณ SC0(Reservas) vinculados ao orcamento com a data de valida-บฑฑ
ฑฑบ          ณ de expirada (dDatabase > L1_DTLIM), e executara o ajuste   บฑฑ
ฑฑบ          ณ em SB2(Saldos).                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Rotina soh deve ser rodada no Servidor DB2 por usar Query  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cParam =  Nil --> Executado via menu                       บฑฑ
ฑฑบ          ณ cParam <> Nil --> Executado via Job                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada via JOB ou menu, para excluir reservas    บฑฑ
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
Project Function DELA008A(cParam)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializacao de variaveis.                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		Aviso("Aten็ใo !","Fim do Processamento !!!",{ " << Voltar " },1,"Rotina Terminada")
	EndIf
	
#ELSE
	// Linha incluida pois o Compilador entendeu que esta variavel nunca foi usada
	// e impediu a Compilacao
	cQuery := cQuery
	If cParam == Nil // Executado via menu
		Aviso("Aten็ใo !","Rotina s๓ pode ser rodada com o Servidor DB2 - Contate o Dpto. de TI !!!",{ " << Voltar " },1,"Rotina Terminada")
	EndIf
#ENDIF

ConOut("DELA008 - FIM DO PROCESSO")

P_CtrlArea(2,_aArea,_aAlias) // RestArea
Return
