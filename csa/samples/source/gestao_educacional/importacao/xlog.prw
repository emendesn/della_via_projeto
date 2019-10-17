#include "protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xCreateLog�Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria um arquivo de LOG.                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Generico.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xCreateLog( cToFile )
Local aStru	:= {{"LOG_TXT", "C", 200, 0},;
				{"LOG_DAT", "D",   8, 0},;
				{"LOG_HOR", "C",   8, 0}}

Local cLogF	:= CriaTrab( aStru, .T. )

if Select( cLogF ) > 0
	dbSelectArea( cLogF )
	dbCloseArea()
endif

dbUseArea(.T., "DBFCDX", cLogF, cLogF, .T.)

U_XAddLog( cLogF, '@ Inicio do registro de log...', cToFile )

Return cLogF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAddLog   �Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona um registro ao arquivo de Log.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xAddLog( cLog, cMsg, cToFile )

if Select( cLog ) > 0
	RecLock( cLog, .T.)
	( cLog )->( FieldPut( FieldPos("LOG_TXT"), Left( cMsg, 200 )) )
	if Len( Alltrim( cMsg ) ) > 0
		( cLog )->( FieldPut( FieldPos("LOG_HOR"), Time() ) )
		( cLog )->( FieldPut( FieldPos("LOG_DAT"), Date() ) )
	endif
	( cLog )->( msUnlock() )
endif

if cToFile <> nil
	xAddToFile( cLog, cToFile )
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xReadLog  �Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Armazena as mensagens do log num array.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xReadLog( cLog )
Local aTxt := {}

if Select( cLog ) > 0
	( cLog )->( dbGoTop() )
	while ( cLog )->( !eof() )
		if len( aTxt ) == 3500
			aAdd( aTxt, { '! Capacidade do arquivo de log excedida.', Space(8) } )
			exit
		endif
		aAdd( aTxt, { Rtrim(LOG_TXT), LOG_DAT, LOG_HOR } )
		( cLog )->( dbSkip() )
	end
endif

Return aTxt

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xKillLog  �Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Elimina o log passado como parametro.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xKillLog( cLog )

if Select( cLog ) > 0
	( cLog )->( dbCloseArea() )
	FErase( cLog + GetDBExtension() )
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xSaveLog  �Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava as informacoes do Log num arquivo texto.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xSaveLog( cLog, cFile, nType )
Local lRet	:= .F.
Local nHdl	:= -1
Local nType	:= if( nType == Nil, 0, nType )
Local cBuff	:= ""

if Select( cLog ) > 0
	
	if File( cFile )
		if nType == 0
			FErase( cFile )
			nHdl := FCreate( cFile )
		else
			nHdl := FOpen( cFile, 1 )
			if nHdl >= 0
				FSeek( nHdl, 0, 2 )
			endif
		endif
	else
		nHdl := FCreate( cFile )
	endif
	
	if nHdl >= 0
		( cLog )->( dbGoTop() )
		while ( cLog )->( !eof() )
			cBuff := if( Empty(LOG_DAT), Space(8), dtoc(LOG_DAT))+"  "+LOG_HOR+"  "+Rtrim(LOG_TXT) + CRLF
			FWrite( nHdl, cBuff, Len(cBuff) )
			( cLog )->( dbSkip() )
		end
		lRet := .T.
	endif
endif

FClose( nHdl )

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xShowLog  �Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exibe o Log numa dialog.                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Generico                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xShowLog( cLog )

// define msDialog oDlg title 'Visualiza��o do Log' from 00,00 to 380,600 pixel

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAddToFile�Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona a linha de log ao fim de um arquivo.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAddToFile( cLog, cToFile )
local nHdl		:= -1
local cBuff

if File( cToFile )
	nHdl := FOpen( cToFile, 1 )
	if nHdl >= 0
		FSeek( nHdl, 0, 2 )
	endif
else
	nHdl := FCreate( cToFile )
endif

if nHdl >= 0
	cBuff := ( cLog )->( if(Empty(LOG_DAT), Space(8), dtoc(LOG_DAT))+"  "+LOG_HOR+"  "+Rtrim(LOG_TXT) + CRLF )
	FWrite( nHdl,  cBuff, Len( cBuff ) )
endif

FClose( nHdl )

Return