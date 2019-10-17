#Include "rwmake.ch"

User Function VerParam()
	Private cFunc := Space(50)

	DEFINE MSDIALOG oDlg FROM 000,000 TO 120,340 TITLE "Parametros" PIXEL
	@ 017,003 SAY "Função:" SIZE 025,010 
	@ 015,030 GET cFunc SIZE 130,010
    @ 035,080 BUTTON "Executa_r" SIZE 035,011 ACTION GetPar()
   	@ 035,120 BUTTON "_Sair"     SIZE 035,011 ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED

Return nil

Static Function GetPar()
	Local aParam := {}
	Local cTxt   := ""

	aParam := GetFuncPrm(AllTrim(cFunc))

	For k=1 To Len(aParam)
		cTxt += aParam[k] + chr(13)+chr(10)
	Next

	msgbox(cTxt,"Parametros","INFO")
Return