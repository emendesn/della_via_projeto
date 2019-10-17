#include "DellaVia.ch"

User Function DEDI004(aLog,cTitulo)
	Default cTitulo := ""
	Private aTipo   := {"Critica","Alerta","Atualização"}

	if ValType(aLog) = "A" .and. Len(aLog) > 0
		oProcess:= TWFProcess():New("EDI",cTitulo)                 //Inicia Processo
		oProcess:NewTask("EDI","\workflow\html\edi\DEDI004.html") //Carrega HTML modelo
		oProcess:cSubject := cTitulo                               //Assunto do e-mail
		oProcess:cTo := "denis.tofoli@dellavia.com.br"             //Destinatarios
		oHTML := oProcess:oHTML                                    //Define Objeto
	
		// Preenche as variaveis do e-mail
		oHtml:ValByName("data",dtoc(dDataBase))		
        
		For k=1 to Len(aLog)
			aadd((oHtml:valByName("tb.tipo")) ,aTipo[aLog[k,1]]                  )
			aadd((oHtml:valByName("tb.desc")) ,Substr(aLog[k,2],1,90)            )
			aadd((oHtml:valByName("tb.linha")),Transform(aLog[k,3],"@E 999,999") )
			aadd((oHtml:valByName("tb.arq"))  ,Substr(aLog[k,4],1,15)            )
		Next k

		//Envia e-mail
		oProcess:Start()
	Endif
Return nil