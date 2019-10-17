#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FSEA140  �Autor  � Ernani Forastieri  � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para dispara JOBS manualmente                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Della Via                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FSEA140()
Local cMsg
Local nOpc

cMsg := 'O objetivo desta fun�ao � executar manualmente os JOBS relacionados' + Chr(13)
cMsg += 'a sincronia entre bases.'

nOpc := Aviso( 'Start Manual de Processos', cMsg, { '&Exporta��o', '&Importa��o' ,'&Monitor', '&Sair'} )

If     nOpc == 1
	StartJob( "u_FSEA020", GetEnvServer(), .F.,{ {.F., cEmpAnt, cFilAnt } })
	ApMsgInfo( 'Job de Exporta��o disparado.', 'ATEN��O' )

ElseIf nOpc == 2
	StartJob( "u_FSEA030", GetEnvServer(), .F.,{ {.F., cEmpAnt, cFilAnt } })
	ApMsgInfo( 'Job de Importa��o disparado.', 'ATEN��O' )

ElseIf nOpc == 3
	StartJob( "u_FSEA040", GetEnvServer(), .F.,{ {.F., cEmpAnt, cFilAnt } })
	ApMsgInfo( 'Job de Monitoramento disparado.', 'ATEN��O' )

EndIf

Return NIL

/////////////////////////////////////////////////////////////////////////////