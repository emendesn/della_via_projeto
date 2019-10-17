#include "rwmake.ch"

/*
Programa...: DFTRUN()
Autor......: Denis Francisco Tofoli
Descrição..: Executa qualquer função (Clipper, Protheus, Usuário) e devolve o resultado
Data.......: 25/05/2006
*/

User Function DftRun()
	Local oDlg
	Local cNomFunc := Space(100)
	Local cIPCliente := GetClientIP()

	DEFINE MSDIALOG oDlg FROM 000,000 TO 120,340 TITLE "Executar"  pixel Of oMainWnd PIXEL
	@ 017,003 SAY "Programa" SIZE 025,010 
	@ 015,030 GET cNomFunc SIZE 130,010

    @ 035,080 BUTTON "Executa_r" SIZE 035,011 ACTION Executar(cNomFunc)
   	@ 035,120 BUTTON "_Sair"     SIZE 035,011 ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
Return

Static Function Executar(cNome)
	Local xResult := nil
	cNome := allTrim(cNome)
	If Empty(cNome)
		msgbox("Digite o nome da função","Executar","ALERT")
		Return
	Endif

	If Substr(cNome,Len(cNome),1) <> ")"
		cNome := cNome+"()"
	Endif

	// Desvia o tratamento de erros
	bErrorRun := {|oErrRun| msgbox(oErrRun:Description,"Executar","STOP")}
	bLastHandler := ERRORBLOCK(bErrorRun)

	// Executa instrução e armazena o resultado
	xResult := &cNome

	// Retoma o tratamento de erros original
	ERRORBLOCK(bLastHandler)

	// Exibe o resultado
	if ValType(xResult) = "C"
		msgbox(xResult,"Resultado","INFO")
	Elseif ValType(xResult) = "N"
		msgbox(AllTrim(Str(xResult)),"Resultado","INFO")
	Elseif ValType(xResult) = "D"
		msgbox(dtoc(xResult),"Resultado","INFO")
	Elseif ValType(xResult) = "L"
		msgbox(iif(xResult,"Verdadeiro","Falso"),"Resultado","INFO")
	Endif
Return