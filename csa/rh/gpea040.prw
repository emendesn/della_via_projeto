#include "protheus.ch"
#define CRLF ( chr(13)+chr(10) )
User Function GPEA040

IF INCLUI

	cMailConta	:=GETMV("MV_EMCONTA")            //Conta utilizada p/envio do email
	cMailServer	:=GETMV("MV_RELSERV")          //Server 
	cMailSenha	:=GETMV("MV_EMSENHA")

	cSubject    := 'CRIAÇAO DE VERBAS'
	cEmail      :=  GETMV("MV_EMAISRV")
	cHtml       := 'ATENÇÃO'+ CRLF
    cHtml       += ''+CRLF    
	cHtml       += 'Foi criado o evento: ' + M->RV_COD + '-'+M->RV_DESC + CRLF
	cHtml       += 'Devera ser informado as Contas Contabeis para este Evento'+ CRLF
	cHtml       += 'Se a Verba for PROVENTO, informar as Contas de Débito para Adm. e Produção' + CRLF
    cHtml       += 'Se a Verba for DESCONTO, informar as Contas de Crédito para Adm. e Produção' + CRLF	
    cHtml       += ''+CRLF    
    cHtml       += ''+CRLF
    cHtml       += 'Grato'+CRLF
    cHtml       += 'Administração de Pessoal '+CRLF   
	
	GPEMail(cSubject,cHtml,cEMail)   

EndIF
Return

	
   
