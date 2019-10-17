#INCLUDE "FSEA120.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ FSEA120  ºAutor  ³ Ernani Forastieri  º Data ³  10/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para delecao dos indices dos arquivos dos pacotes   º±±
±±º          ³ em bases CodeBase                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Della Via                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FSEA120(aParams)
Local lManual    := IIf( aParams == NIL, .T., aParams[1][1])
Local cEmpresa   := IIf( lManual, SM0->M0_CODIGO, aParams[1][2] )
Local cFil       := IIf( lManual, SM0->M0_CODFIL, aParams[1][3] )
Local nHdl       := -1
//Local nHdl010    := -1
//Local nHdl020    := -1
//Local nHdl040    := -1
Local cExtensao  := ""
Local cIndExt    := ""
Local cArqInd    := ""
Local cTabela    := ""
Local lOkDel     := .T.
Local lErroAbert := .F.
Local aProcess   := {}
Local cArqSema   := "FSEA120"+cEmpresa+".LCK"
Local nI         := 0

If File(cArqSema)
	If ( lArqUse := ( FErase(cArqSema) < 0 ) )
		u_MsgConMon(STR0001) //"Job Delecao de indices ja esta em andamento"
		Return NIL
	EndIf
EndIf

// Abrindo o semaforo para trava
nHdl := MSFcreate(cArqSema)

u_MsgConMon(STR0002+ cEmpresa+" "+cFil, .F.) //"Iniciando Processo Delecao Indices "

// Prepara ambiente se for JOB
If !lManual
	RpcSetType(3)
	RpcSetEnv(cEmpresa, cFil,,,,, { "UA2" })
EndIf

lAmbTop := .F.
#IFDEF TOP
	lAmbTop := .T.
#ENDIF

// Inicializando tabelas
dbSelectArea("UA2")
dbSetOrder(1)

cExtensao := GetDbExtension()
cIndExt   := IndexExt()

If !lAmbTop
	
	dbSelectArea("UA2")
	dbGoTop()
	
	While !UA2->(Eof()) .and. !KillApp()
		lOkDel     := .F.
		lErroAbert := .F.
		cTabela    := UA2->UA2_TABELA
		
		u_MsgConMon(STR0003+ cTabela, .F.) //"Deletando indices "
		
		If Select(cTabela) > 0
			(cTabela)->(dbCloseArea())
		EndIf
		
		cArqInd := u_TrocaExt(u_InfoSX2(cTabela,0),cIndExt)
		
		If File(cArqInd) .and.  aScan(aProcess, cTabela) == 0
			
			For nI := 1 to 10
				If ( lOkDel := ( FErase(cArqInd) == 0 ) )
					Exit
				EndIf
				
				Sleep(10000)
			Next
			
			If  lOkDel
				u_MsgConMon(STR0004+ cTabela, .F.) //"Recriando indices "
				
				ChkFile(cTabela,.T.)
				If Select(cTabela) > 0
					(cTabela)->(dbCloseArea())
				Else
					u_MsgConMon(STR0005+ cTabela) //"Erro na abertura para recriar indices "
				EndIf
				
				aAdd(aProcess, cTabela)
			Else
				u_MsgConMon(STR0006+ cTabela) //"Nao foi possivel deletar indices "
			EndIf
			
		EndIf
		
		UA2->(dbSkip())
	End
EndIf

// Fechando o Semaforo
FClose( nHdl )
FErase(cArqSema)

u_MsgConMon(STR0007+ cEmpresa+" "+cFil, .F.) // //"Finalizando Processo Delecao Indices "
RpcClearEnv()
Return NIL

/////////////////////////////////////////////////////////////////////////////