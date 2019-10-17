#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ FSEA140  บAutor  ณ Ernani Forastieri  บ Data ณ  10/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para dispara JOBS manualmente                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FSEA140()
Local cMsg
Local nOpc

cMsg := 'O objetivo desta fun็ao ้ executar manualmente os JOBS relacionados' + Chr(13)
cMsg += 'a sincronia entre bases.'

nOpc := Aviso( 'Start Manual de Processos', cMsg, { '&Exporta็ใo', '&Importa็ใo' ,'&Monitor', '&Sair'} )

If     nOpc == 1
	StartJob( "u_FSEA020", GetEnvServer(), .F.,{ {.F., cEmpAnt, cFilAnt } })
	ApMsgInfo( 'Job de Exporta็ใo disparado.', 'ATENวรO' )

ElseIf nOpc == 2
	StartJob( "u_FSEA030", GetEnvServer(), .F.,{ {.F., cEmpAnt, cFilAnt } })
	ApMsgInfo( 'Job de Importa็ใo disparado.', 'ATENวรO' )

ElseIf nOpc == 3
	StartJob( "u_FSEA040", GetEnvServer(), .F.,{ {.F., cEmpAnt, cFilAnt } })
	ApMsgInfo( 'Job de Monitoramento disparado.', 'ATENวรO' )

EndIf

Return NIL

/////////////////////////////////////////////////////////////////////////////