#INCLUDE "FSEA020.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ FSEA020  ºAutor  ³ Ernani Forastieri  º Data ³  10/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para start exportacao de Pacotes                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User  Function FSEA020(aParams)
Local lManual   := IIf( aParams == NIL, .T., aParams[1][1])
Local cEmpresa  := IIf( lManual, SM0->M0_CODIGO, aParams[1][2] )
Local cFil      := IIf( lManual, SM0->M0_CODIGO, aParams[1][3] )
Local aFiles    := { "UA1", "UA2", "UA3" }
Local nHdl      := -1
Local dDataRef  := Date()
Local cHoraRef  := Time()
Local cPacAnt   := ""
Local cArqSema  := "FSEA020"+cEmpresa+".LCK"
Local lUsaFTP   := .F.

// Abrindo o semaforo para trava
If File(cArqSema)
	If ( lArqUse := ( FErase(cArqSema) < 0 ) )
		u_MsgConMon(STR0001) //"Job disparador de exportacao ja esta em andamento"
		Return NIL
	EndIf
EndIf

nHdl := MSFcreate(cArqSema)

u_MsgConMon(STR0002+ cEmpresa+" "+cFil, .F.) //"Disparando Exportacoes Empresa "

// Prepara ambiente se for JOB
If !lManual
	RpcSetType(3)
	RpcSetEnv(cEmpresa, cFil,,,,, aFiles)
EndIf


// Inicializando tabelas
dbSelectArea("UA1")
dbSetOrder(1)
dbGoTop()

dbSelectArea("UA2")
dbSetOrder(1)
dbGoTop()

dbSelectArea("UA3")
dbSetOrder(1)
dbGoTop()

// Informacoes Gerais
dDataRef  := Date()
cHoraRef  := Time()
lUsaFTP   := GetMV( 'FS_USAFTP',, .T. ) // Usa FTP

dbSelectArea("UA1")
dbSeek(xFilial("UA1"))

If u_ConexFTP(,,,,,lUsaFTP)
	
	// Ponto de Entrada Inicio Exportaçao
	If ExistBlock("FSE020IN")
		aAreaAux := GetArea()
		ExecBlock("FSE020IN", .F., .F., { cEmpresa, cFil })
		RestArea(aAreaAux)
	EndIf
	
	While !UA1->(Eof()) .AND. xFilial("UA1") == UA1->UA1_FILIAL .AND. !KillApp()
		
		If UA1->UA1_STATUS == "1"    // Esta Ativo
			
			If (DTos(UA1->UA1_DTPRX) + UA1->UA1_HRPRX) <= (DToS(dDataRef)+SubStr(cHoraRef,1,5)) // Passou da Hora de Iniciar
				
				cPacAnt := UA1->UA1_PACOTE
				
				// Ponto de Entrada Inicio Exportacao Pacote
				If ExistBlock( UA1->UA1_RTIEPC )
					aAreaAux := GetArea()
					ExecBlock( UA1->UA1_RTIEPC,  .F., .F., { cPacAnt, cEmpresa, cFil } )
					RestArea( aAreaAux )
				EndIf
				
				dbSelectArea("UA2")
				dbSeek(xFilial("UA2") + cPacAnt)
				
				//				cPacAnt := UA2->UA2_PACOTE
				
				While !UA2->(Eof()) .AND. (xFilial("UA2")+cPacAnt) == UA2->(UA2_FILIAL+UA2_PACOTE) .AND. !KillApp()
					// Linha Alterada para Processar Sequencial
					//				StartJob("u_FSEA021", GetEnvServer(), .F., UA2->UA2_PACOTE, UA2->UA2_TABELA, cEmpresa, cFil, .F., dDataRef, cHoraRef )
					// Linha abaixo usada apenas para debugar
					u_FSEA021(UA2->UA2_PACOTE, UA2->UA2_TABELA, cEmpresa, cFil, .F., dDataRef, cHoraRef, lUsaFTP )
					dbSelectArea("UA2")
					UA2->(dbSkip())
				End
				
				// Ponto de Entrada Inicio Exportacao Pacote
				If ExistBlock( UA1->UA1_RTFEPC )
					aAreaAux := GetArea()
					ExecBlock( UA1->UA1_RTFEPC,  .F., .F., { cPacAnt, cEmpresa, cFil } )
					RestArea( aAreaAux )
				EndIf
				
				PrxExecucao(UA1->UA1_DTPRX, UA1->UA1_HRPRX)
			EndIf
			
		EndIf
		
		dbSelectArea("UA1")
		UA1->(dbSkip())
	End
	
	// Ponto de Entrada Final Exportaçao
	If ExistBlock("FSE020FI")
		aAreaAux := GetArea()
		ExecBlock("FSE020FI", .F., .F., {cEmpresa, cFil})
		RestArea(aAreaAux)
	EndIf
	
	// Linha Alterada para Processar Sequencial
	
	u_DesConxFTP()
Else
	
	If lUsaFTP
		u_MsgConMon(STR0004) //"Nao foi possivel fazer con	exao com FTP"
	Else
		u_MsgConMon(STR0005) //'Nao foi encontrado diretorio da rede para transacoes ou link de comunicacao com problemas'
	EndIf
EndIf

// Fechando o Semaforo
FClose( nHdl )
FErase(cArqSema)

u_MsgConMon(STR0003+ cEmpresa+" "+cFil, .F.) //"Finalizando Exportacoes Empresa "
RpcClearEnv()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ FSEA020  ºAutor  ³ Ernani Forastieri  º Data ³  10/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para pegar data e hora da proxima execucao          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrxExecucao(dDiaCalc, cHorCalc)
// Calculo Proxima Execucao

While .T. .AND. !KillApp()
	aDtHrPrx := u_PrxExec(dDiaCalc, cHorCalc, UA1->UA1_INTERV, UA1->UA1_UNITEM, .F.)
	
	If (DToS(aDtHrPrx[1])+aDtHrPrx[2]) >= (DToS(Date())+Time())
		dbSelectArea("UA1")
		RecLock("UA1", .F.)
		UA1->UA1_DTPRX := aDtHrPrx[1]
		UA1->UA1_HRPRX := aDtHrPrx[2]
		MsUnlock()
		Exit
	EndIf
	
	dDiaCalc := aDtHrPrx[1]
	cHorCalc := aDtHrPrx[2]
End

Return NIL

/////////////////////////////////////////////////////////////////////////////
