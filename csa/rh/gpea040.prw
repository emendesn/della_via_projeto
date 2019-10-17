#include "protheus.ch"
#define CRLF ( chr(13)+chr(10) )
User Function GPEA040

IF INCLUI

	cMailConta	:=GETMV("MV_EMCONTA")            //Conta utilizada p/envio do email
	cMailServer	:=GETMV("MV_RELSERV")          //Server 
	cMailSenha	:=GETMV("MV_EMSENHA")

	cSubject    := 'CRIA�AO DE VERBAS'
	cEmail      :=  GETMV("MV_EMAISRV")
	cHtml       := 'ATEN��O'+ CRLF
    cHtml       += ''+CRLF    
	cHtml       += 'Foi criado o evento: ' + M->RV_COD + '-'+M->RV_DESC + CRLF
	cHtml       += 'Devera ser informado as Contas Contabeis para este Evento'+ CRLF
	cHtml       += 'Se a Verba for PROVENTO, informar as Contas de D�bito para Adm. e Produ��o' + CRLF
    cHtml       += 'Se a Verba for DESCONTO, informar as Contas de Cr�dito para Adm. e Produ��o' + CRLF	
    cHtml       += ''+CRLF    
    cHtml       += ''+CRLF
    cHtml       += 'Grato'+CRLF
    cHtml       += 'Administra��o de Pessoal '+CRLF   
	
	GPEMail(cSubject,cHtml,cEMail)   

EndIF
Return

	
   
