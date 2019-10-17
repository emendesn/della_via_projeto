#include "Protheus.ch"                      
#Include "TbiConn.ch"
#Include "AP5MAIL.CH"

user Function EMail()

Local oServer
Local oMessage

Local nNumMsg := 0
Local nTam    := 0
Local nI      := 0      

prepare environment empresa "99" filial "01" tables "SUC"

//Crio a conexão com o server STMP ( Envio de e-mail )

oServer := TMailManager():New()
oServer:Init( "", "smtp.osite.com.br", "marcio_d@osite.com.br", "BATMAN", 0, 25 )

//seto um tempo de time out com servidor de 1min
If oServer:SetSmtpTimeOut( 60 ) != 0
	Conout( "Falha ao setar o time out" )
	Return .F.
EndIf

MailAuth("marcio_d@osite.com.br","BATMAN")         
//realizo a conexão SMTP
If oServer:SmtpConnect() != 0
	Conout( "Falha ao conectar" )
	Return .F.
EndIf

//Crio uma nova conexão, agora de IMAP
oServer := TMailManager():New()

oServer:Init("10.10.2.20" , "", "callcenter@grupomesquita.com.br", "protheus", 60, 25 )

/*
If oServer:SetPopTimeOut( 60 ) != 0
	Conout( "Falha ao setar o time out" )
	Return .F.
EndIf
*/

If oServer:ImapConnect() != 0
	Conout( "Falha ao conectar" )
	Return .F.
EndIf

//Apos a conexão, crio o objeto da mensagem
oMessage := TMailMessage():New()

//Recebo o número de mensagens do servidor
oServer:GetNumMsgs( @nNumMsg )
nTam := nNumMsg

For nI := 1 To nTam
	//Limpo o objeto da mensagem
	oMessage:Clear()
	//Recebo a mensagem do servidor
	oMessage:Receive( oServer, nI )
	
	//Escrevo no server os dados do e-mail recebido
	Conout( oMessage:cFrom )
	Conout( oMessage:cTo )
	Conout( oMessage:cCc )
	Conout( oMessage:cSubject )
	Conout( oMessage:cBody )   
	
	If At("Dados do Atendimento",omessage:cbody) > 0		
		cCorpo	:= Replicate("-",60)+Chr(13)+Chr(10)     
		cCorpo 	+= "E-mail recebido de "+oMessage:cFrom+Chr(13)+Chr(10)     
		cCorpo 	+= "Data :"+oMessage:cDate+Chr(13)+Chr(10)+Chr(13)+Chr(10) 
		cNum 	:= Substr(omessage:cbody,At("Dados do Atendimento",omessage:cbody)+39,6)
		Conout("Atendimento n:"+cNum)    
		cCorpo	+= Substr(omessage:cbody,1,At(Chr(13)+Chr(10)+Chr(13)+Chr(10),omessage:cbody))
		Conout("Corpo:"+cCorpo)
		
		DbSelectArea("SUC")
		DbSetorder(1)
		If DbSeek(xFilial("SUC")+cNum)
		
			If Empty(SUC->UC_CODOBS)	// Inclusao	
				MSMM(,TamSx3("UC_OBS")[1],,cCorpo,1,,,"SUC","UC_CODOBS")			
			Else						// Alteracao
				cCorpoAnt := MSMM(SUC->UC_CODOBS,35)
				cCorpo += Chr(13)+Chr(10)+cCorpoAnt
				MSMM(SUC->UC_CODOBS,TamSx3("UC_OBS")[1],,cCorpo,1,,,"SUC","UC_CODOBS")
			Endif          
			
		Endif	                                               
		
	Endif	
	
Next

//Deleto todas as mensagens do servidor
/*
For nI := 1 To nTam
	oServer:DeleteMsg( nI )
Next
*/

//Diconecto do servidor Imap
oServer:ImapDisconnect()

//Disconecto do servidor
If oServer:SmtpDisconnect() != 0
	Conout( "Erro ao disconectar do servidor SMTP" )
	Return .F.
EndIf

Return .T.
