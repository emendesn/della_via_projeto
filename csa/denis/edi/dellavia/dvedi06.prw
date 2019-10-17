#include "DellaVia.ch"

User Function DVEDI06(aDados,nOpc,lErro)
	Local   aTipo   := {"Importação","Exportação"}
	Local   cTitulo := ""
	Default lErro   := .F.

	If !lErro
		cTitulo := "EDI - Mercador: "+aTipo[nOpc]

		if ValType(aDados) = "A" .and. Len(aDados) > 0
			oProcess:= TWFProcess():New("Mercador",cTitulo)                   //Inicia Processo
			oProcess:NewTask("Mercador","\workflow\HTML\edi\Mercador\wf.htm") //Carrega HTML modelo
			oProcess:cSubject := cTitulo                                      //Assunto do e-mail
			oProcess:cTo := GetMv("MV_EMAILMC")                               //Destinatarios
			oHTML := oProcess:oHTML                                           //Define Objeto
		
			// Preenche as variaveis do e-mail
			oHtml:ValByName("ACTION",aTipo[nOpc])
	        
			For j=1 to Len(aDados)
				aadd((oHtml:valByName("T.ORC"))    , aDados[j,1])
				aadd((oHtml:valByName("T.PEDCLI")) , aDados[j,2])
				aadd((oHtml:valByName("T.STATUS")) , aDados[j,3])
				aadd((oHtml:valByName("T.ARQ"))    , aDados[j,4])
				aadd((oHtml:valByName("T.NOTA"))   , aDados[j,5])
			Next j
	
			//Envia e-mail
			oProcess:Start()
		Endif
	Else
		aLinhas := {}
		aArea   := GetArea()
		aEstru  := {}

		aAdd(aEstru,{"M_LINHA"  ,"C",300,0})
		cTmpLog := CriaTrab(aEstru,.T.)
		dbUseArea(.T.,,cTmpLog,"MLOG",.F.,.F.)
		dbSelectArea("MLOG")

		If File("\SYSTEM\MERCADOR.LOG")
			Append from \SYSTEM\MERCADOR.LOG SDF
		Endif
		
		dbGoTop()
		Do While !eof()
			aadd(aLinhas , AllTrim(M_LINHA))
			dbSkip()
		Enddo
		dbCloseArea()
		fErase(cTmpLog+GetDBExtension())


		If Len(aLinhas) > 0
			oProcess:= TWFProcess():New("Mercador","EDI - Mercador: Erro")      //Inicia Processo
			oProcess:NewTask("Mercador","\workflow\HTML\edi\Mercador\erro.htm") //Carrega HTML modelo
			oProcess:cSubject := "EDI - Mercador: Erro"                         //Assunto do e-mail
			oProcess:cTo := GetMv("MV_EMAILMC")                                 //Destinatarios
			oHTML := oProcess:oHTML                                             //Define Objeto

			For j=1 to len(aLinhas)
				aadd((oHtml:valByName("T.LINHA")) , aLinhas[j])
			Next
		Endif
		//Envia e-mail
		oProcess:Start()

		RestArea(aArea)
	Endif
Return nil